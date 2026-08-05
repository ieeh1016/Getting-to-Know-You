// 서로 노트(profile card) 슬롯 값을 모두 지우는 일회성 admin script.
//
// 슬롯 질문 세트를 새로 바꾸면 예전 질문에 남긴 답이 Firestore에 그대로 남는다.
// 이 script는 `spaces/{spaceId}/profileCards/{profileId}/slots/*` 문서를 지운다.
// 카드 질문 목록 자체는 앱 코드의 `profileSlotCatalogV3`가 소유하므로 지울 대상이 아니다.
//
// 되돌릴 수 없다. 실행 전에 반드시 --dry-run으로 지워질 문서를 먼저 확인한다.
//
// 사용법:
//   node scripts/reset_profile_slots.js --key=<service-account.json> --space=<spaceId> --dry-run
//   node scripts/reset_profile_slots.js --key=<service-account.json> --space=<spaceId> --confirm
//
// service account json은 절대 저장소에 commit하지 않는다.

const { cert, initializeApp } = require('firebase-admin/app');
const { getFirestore } = require('firebase-admin/firestore');

function parseArgs(argv) {
  const args = { dryRun: false, confirm: false, key: null, space: null };
  for (const arg of argv.slice(2)) {
    if (arg === '--dry-run') {
      args.dryRun = true;
    } else if (arg === '--confirm') {
      args.confirm = true;
    } else if (arg.startsWith('--key=')) {
      args.key = arg.slice('--key='.length);
    } else if (arg.startsWith('--space=')) {
      args.space = arg.slice('--space='.length);
    } else {
      throw new Error(`Unknown argument: ${arg}`);
    }
  }
  if (!args.key) {
    throw new Error('--key=<service-account.json> is required.');
  }
  if (!args.space) {
    throw new Error('--space=<spaceId> is required.');
  }
  if (args.dryRun === args.confirm) {
    throw new Error('Pass exactly one of --dry-run or --confirm.');
  }
  return args;
}

async function collectSlotDocuments(firestore, spaceId) {
  const space = firestore.collection('spaces').doc(spaceId);
  const spaceSnapshot = await space.get();
  if (!spaceSnapshot.exists) {
    throw new Error(`Space not found: ${spaceId}`);
  }

  const profileCards = await space.collection('profileCards').listDocuments();
  const documents = [];
  for (const profileCard of profileCards) {
    const slots = await profileCard.collection('slots').get();
    for (const slot of slots.docs) {
      documents.push({
        profileId: profileCard.id,
        slotId: slot.id,
        label: slot.get('label') ?? '(label 없음)',
        value: slot.get('value') ?? '',
        ref: slot.ref,
      });
    }
  }
  return documents;
}

async function deleteInBatches(firestore, documents) {
  const batchSize = 400;
  for (let index = 0; index < documents.length; index += batchSize) {
    const batch = firestore.batch();
    for (const document of documents.slice(index, index + batchSize)) {
      batch.delete(document.ref);
    }
    await batch.commit();
  }
}

async function main() {
  const args = parseArgs(process.argv);
  const serviceAccount = require(args.key);

  initializeApp({ credential: cert(serviceAccount) });
  const firestore = getFirestore();

  const documents = await collectSlotDocuments(firestore, args.space);
  if (documents.length === 0) {
    console.log(`No profile card slots found in space ${args.space}.`);
    return;
  }

  console.log(`Space: ${args.space}`);
  console.log(`Profile card slot documents: ${documents.length}`);
  for (const document of documents) {
    const preview = document.value.length > 30
      ? `${document.value.slice(0, 30)}...`
      : document.value;
    console.log(
      `  ${document.profileId}/${document.slotId} · ${document.label} · ${preview}`,
    );
  }

  if (args.dryRun) {
    console.log('');
    console.log('Dry run only. Nothing was deleted.');
    console.log('Rerun with --confirm to delete these documents.');
    return;
  }

  await deleteInBatches(firestore, documents);
  console.log('');
  console.log(`Deleted ${documents.length} profile card slot documents.`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error.message);
    console.error('');
    console.error('Usage:');
    console.error(
      '  node scripts/reset_profile_slots.js --key=<service-account.json> --space=<spaceId> --dry-run',
    );
    console.error(
      '  node scripts/reset_profile_slots.js --key=<service-account.json> --space=<spaceId> --confirm',
    );
    process.exit(1);
  });
