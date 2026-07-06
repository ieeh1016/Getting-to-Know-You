const {initializeApp} = require("firebase-admin/app");
const {getFirestore, FieldValue} = require("firebase-admin/firestore");
const {getMessaging} = require("firebase-admin/messaging");
const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const logger = require("firebase-functions/logger");

initializeApp();

const INVALID_TOKEN_ERROR_CODES = new Set([
  "messaging/invalid-registration-token",
  "messaging/registration-token-not-registered",
]);

const ACTIVITY_NOTIFICATION_COPY = {
  answerSaved: {
    title: "질문에 답했어요",
    body: "새 답변을 확인해요.",
  },
  answerSkipped: {
    title: "오늘 질문에 표시를 남겼어요",
    body: "조금씩에서 확인해요.",
  },
  answerCommentSaved: {
    title: "답변에 댓글을 남겼어요",
    body: "조금씩에서 확인해요.",
  },
  answerCommentReplySaved: {
    title: "댓글에 답장을 남겼어요",
    body: "조금씩에서 확인해요.",
  },
  balanceSelectionSaved: {
    title: "밸런스 질문을 골랐어요",
    body: "서로의 선택을 확인해요.",
  },
  profileSlotSaved: {
    title: "프로필 카드를 채웠어요",
    body: "새로 알게 된 점을 확인해요.",
  },
  wishSaved: {
    title: "위시리스트를 업데이트했어요",
    body: "함께 하고 싶은 것을 확인해요.",
  },
  memoryCardSaved: {
    title: "기억 카드를 남겼어요",
    body: "서로의 기억에서 확인해요.",
  },
  memoryCardResponseSaved: {
    title: "기억 카드에 반응했어요",
    body: "서로의 기억에서 확인해요.",
  },
  musicNoteSaved: {
    title: "음악을 남겼어요",
    body: "같이 듣고 싶은 음악을 확인해요.",
  },
  musicNoteListened: {
    title: "음악을 들었어요",
    body: "음악 공간에서 확인해요.",
  },
  musicNoteCommentSaved: {
    title: "음악에 댓글을 남겼어요",
    body: "음악 공간에서 확인해요.",
  },
  scheduleEntrySaved: {
    title: "만남 가능 시간을 남겼어요",
    body: "만남 달력에서 확인해요.",
  },
  meetingPlanSaved: {
    title: "만남 계획을 업데이트했어요",
    body: "같이 볼 계획을 확인해요.",
  },
  sharedPlaceSaved: {
    title: "장소를 공유했어요",
    body: "가보고 싶은 곳을 확인해요.",
  },
  sharedPlaceMeetingLinksSaved: {
    title: "장소 계획을 업데이트했어요",
    body: "만남 계획에서 확인해요.",
  },
  curiosityQuestionSaved: {
    title: "질문을 보냈어요",
    body: "홈에서 받은 질문을 확인해요.",
  },
  curiosityReplySaved: {
    title: "질문에 답했어요",
    body: "홈에서 답장을 확인해요.",
  },
  stockStorySaved: {
    title: "주식 이야기를 남겼어요",
    body: "주식 이야기에서 확인해요.",
  },
  stockHoldingSaved: {
    title: "보유 이야기를 남겼어요",
    body: "주식 이야기에서 확인해요.",
  },
  improvementPostSaved: {
    title: "건의를 남겼어요",
    body: "건의함에서 확인해요.",
  },
  improvementPostOwnerNoteSaved: {
    title: "건의에 답변을 남겼어요",
    body: "건의함에서 확인해요.",
  },
  improvementPostResolved: {
    title: "건의를 처리했어요",
    body: "건의함에서 확인해요.",
  },
};

exports.notifyActivityEventCreated = onDocumentCreated(
  "spaces/{spaceId}/activityEvents/{eventId}",
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) {
      return;
    }
    const {spaceId, eventId} = event.params;
    const activity = snapshot.data();
    const type = readString(activity, "type");
    const copy = ACTIVITY_NOTIFICATION_COPY[type];
    if (!copy) {
      logger.info("Unsupported activity notification type", {
        eventId,
        spaceId,
        type,
      });
      return;
    }

    const actorUid = readString(activity, "actorProfileId");
    if (!actorUid) {
      return;
    }
    const recipientUid = await resolveRecipientUid(spaceId, actorUid);
    if (!recipientUid || recipientUid === actorUid) {
      return;
    }

    const actorName = await readDisplayName(actorUid);
    const route = readString(activity, "route") || "home";
    const feature = readString(activity, "feature") || "activity";
    const targetId = readString(activity, "targetId");
    await sendUserNotification({
      eventId: `activity-${eventId}`,
      spaceId,
      recipientUid,
      title: `${actorName}님이 ${copy.title}`,
      body: copy.body,
      data: {
        type,
        route,
        feature,
        targetId,
        activityEventId: eventId,
        spaceId,
      },
    });
  },
);

async function resolveRecipientUid(spaceId, actorUid) {
  const snapshot = await getFirestore().collection("spaces").doc(spaceId).get();
  const space = snapshot.data() || {};
  const memberIds = Array.isArray(space.memberIds) ? space.memberIds : [];
  return memberIds.find((memberId) => {
    return typeof memberId === "string" && memberId && memberId !== actorUid;
  }) || "";
}

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
    logger.info("Sent activity notification", {
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
