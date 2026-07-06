const {initializeApp} = require("firebase-admin/app");
const {getFirestore, FieldValue} = require("firebase-admin/firestore");
const {getMessaging} = require("firebase-admin/messaging");
const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const logger = require("firebase-functions/logger");

initializeApp();

const MEMORY_ROUTE = "memoryCards";
const MEMORY_FEATURE = "memoryCards";
const INVALID_TOKEN_ERROR_CODES = new Set([
  "messaging/invalid-registration-token",
  "messaging/registration-token-not-registered",
]);

exports.notifyMemoryCardCreated = onDocumentCreated(
  "spaces/{spaceId}/memoryCards/{cardId}",
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) {
      return;
    }
    const {spaceId, cardId} = event.params;
    const card = snapshot.data();
    if (card.visibility !== "shared") {
      return;
    }
    const actorUid = readString(card, "createdByProfileId");
    const recipientUid = readString(card, "subjectProfileId");
    if (!actorUid || !recipientUid || actorUid === recipientUid) {
      return;
    }
    const actorName = await readDisplayName(actorUid);
    await sendUserNotification({
      eventId: `memory-card-created-${cardId}`,
      spaceId,
      recipientUid,
      title: `${actorName}님이 기억 카드를 남겼어요`,
      body: "서로의 기억에서 확인해요.",
      data: {
        type: "memoryCardCreated",
        route: MEMORY_ROUTE,
        feature: MEMORY_FEATURE,
        targetId: cardId,
        cardId,
        spaceId,
      },
    });
  },
);

exports.notifyMemoryCardResponseCreated = onDocumentCreated(
  "spaces/{spaceId}/memoryCardResponses/{responseId}",
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) {
      return;
    }
    const {spaceId, responseId} = event.params;
    const response = snapshot.data();
    const cardId = readString(response, "cardId");
    const actorUid = readString(response, "responderProfileId");
    if (!cardId || !actorUid) {
      return;
    }
    const cardSnapshot = await getFirestore()
      .collection("spaces")
      .doc(spaceId)
      .collection("memoryCards")
      .doc(cardId)
      .get();
    if (!cardSnapshot.exists) {
      return;
    }
    const card = cardSnapshot.data() || {};
    if (card.visibility !== "shared") {
      return;
    }
    const recipientUid = readString(card, "createdByProfileId");
    if (!recipientUid || actorUid === recipientUid) {
      return;
    }
    const actorName = await readDisplayName(actorUid);
    await sendUserNotification({
      eventId: `memory-card-response-created-${responseId}`,
      spaceId,
      recipientUid,
      title: `${actorName}님이 기억 카드에 반응했어요`,
      body: "서로의 기억에서 확인해요.",
      data: {
        type: "memoryCardResponseCreated",
        route: MEMORY_ROUTE,
        feature: MEMORY_FEATURE,
        targetId: cardId,
        cardId,
        responseId,
        spaceId,
      },
    });
  },
);

async function sendUserNotification({
  eventId,
  spaceId,
  recipientUid,
  title,
  body,
  data,
}) {
  const shouldSend = await markNotificationEvent(spaceId, eventId);
  if (!shouldSend) {
    return;
  }
  const tokenRefs = await loadEnabledTokenRefs(recipientUid, spaceId);
  if (tokenRefs.length === 0) {
    logger.info("No enabled notification tokens", {
      eventId,
      recipientUid,
      spaceId,
    });
    return;
  }
  for (const chunk of chunkArray(tokenRefs, 500)) {
    const tokens = chunk.map((tokenRef) => tokenRef.token);
    const response = await getMessaging().sendEachForMulticast({
      tokens,
      notification: {title, body},
      data: stringifyData(data),
      android: {
        priority: "high",
      },
      apns: {
        payload: {
          aps: {
            sound: "default",
          },
        },
      },
    });
    await disableInvalidTokens(chunk, response);
    logger.info("Sent memory notification", {
      eventId,
      recipientUid,
      successCount: response.successCount,
      failureCount: response.failureCount,
    });
  }
}

async function markNotificationEvent(spaceId, eventId) {
  const eventRef = getFirestore()
    .collection("spaces")
    .doc(spaceId)
    .collection("notificationEvents")
    .doc(eventId);
  let shouldSend = false;
  await getFirestore().runTransaction(async (transaction) => {
    const snapshot = await transaction.get(eventRef);
    if (snapshot.exists) {
      shouldSend = false;
      return;
    }
    shouldSend = true;
    transaction.create(eventRef, {
      eventId,
      createdAt: FieldValue.serverTimestamp(),
    });
  });
  return shouldSend;
}

async function loadEnabledTokenRefs(userId, spaceId) {
  const userRef = getFirestore().collection("users").doc(userId);
  const settingSnapshot = await userRef
    .collection("notificationSettings")
    .doc("push")
    .get();
  const setting = settingSnapshot.data() || {};
  if (setting.enabled !== true || setting.spaceId !== spaceId) {
    return [];
  }
  const tokenSnapshots = await userRef
    .collection("notificationTokens")
    .where("enabled", "==", true)
    .get();
  return tokenSnapshots.docs
    .map((doc) => ({
      ref: doc.ref,
      token: readString(doc.data(), "token"),
      spaceId: readString(doc.data(), "spaceId"),
    }))
    .filter((entry) => entry.token && entry.spaceId === spaceId);
}

async function disableInvalidTokens(tokenRefs, response) {
  const writes = [];
  response.responses.forEach((result, index) => {
    if (result.success) {
      return;
    }
    const code = result.error && result.error.code;
    if (!INVALID_TOKEN_ERROR_CODES.has(code)) {
      return;
    }
    writes.push(
      tokenRefs[index].ref.set(
        {
          enabled: false,
          updatedAt: FieldValue.serverTimestamp(),
        },
        {merge: true},
      ),
    );
  });
  await Promise.all(writes);
}

async function readDisplayName(userId) {
  const snapshot = await getFirestore().collection("users").doc(userId).get();
  return readString(snapshot.data() || {}, "displayName") || "상대";
}

function stringifyData(data) {
  return Object.fromEntries(
    Object.entries(data).map(([key, value]) => [key, String(value)]),
  );
}

function readString(data, key) {
  const value = data[key];
  return typeof value === "string" ? value : "";
}

function chunkArray(items, size) {
  const chunks = [];
  for (let index = 0; index < items.length; index += size) {
    chunks.push(items.slice(index, index + size));
  }
  return chunks;
}
