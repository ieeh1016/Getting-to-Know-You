// firestore.rules를 emulator에 올려 실제 쓰기로 검사한다.
//
// scripts/check_firestore_rules_sync.sh는 규칙 파일과 문서가 같은지만 본다.
// 규칙이 실제 쓰기를 받아주는지는 아무도 확인하지 않아, 앱은 통과하는데
// 서버가 거부하는 상태가 배포된 적이 여러 번 있다. 여기서 그걸 잡는다.
import { readFileSync } from 'node:fs';
import { after, before, describe, it } from 'node:test';
import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from '@firebase/rules-unit-testing';
import {
  doc,
  serverTimestamp,
  setDoc,
  updateDoc,
} from 'firebase/firestore';

const ME = 'youngwooUid';
const PARTNER = 'minyoungUid';
const SPACE = 'main';

let env;

before(async () => {
  env = await initializeTestEnvironment({
    projectId: 'rules-test',
    firestore: {
      rules: readFileSync(new URL('../../firestore.rules', import.meta.url), 'utf8'),
      host: '127.0.0.1',
      port: 8080,
    },
  });
});

after(async () => {
  await env?.cleanup();
});

async function seed(write) {
  await env.withSecurityRulesDisabled(async (context) => {
    await write(context.firestore());
  });
}

function placeRef(db, id) {
  return doc(db, `spaces/${SPACE}/sharedPlaces/${id}`);
}

/// 계획 탭에서 장소를 그 날에 붙일 때 실제로 나가는 patch.
function meetingLinkPatch(uid, dateKey) {
  return {
    interestedByProfileIds: [uid],
    linkedDateKey: '',
    meetingPlanLinks: [
      { dateKey, order: 0, reservationTimeLabel: '' },
    ],
    updatedByProfileId: uid,
    updatedAt: new Date(),
  };
}

describe('sharedPlaces rules', () => {
  before(async () => {
    await seed(async (db) => {
      await setDoc(doc(db, `spaces/${SPACE}`), {
        memberIds: [ME, PARTNER],
      });
      // isSpaceMember는 users 문서와 그 안의 spaceId를 함께 본다.
      for (const uid of [ME, PARTNER]) {
        await setDoc(doc(db, `users/${uid}`), {
          spaceId: SPACE,
          displayName: uid,
        });
      }
      // 장소 보드 초기에 담긴 문서. `mapLink`가 아직 없던 시절 모양이다.
      await setDoc(placeRef(db, 'legacy_place'), {
        id: 'legacy_place',
        name: '연남동 카페',
        address: '서울 마포구',
        category: 'cafe',
        provider: 'kakao',
        providerPlaceId: '12345',
        latitude: 37.56,
        longitude: 126.92,
        note: '',
        createdByProfileId: ME,
        interestedByProfileIds: [ME],
        linkedDateKey: '',
        meetingPlanLinks: [],
        updatedByProfileId: ME,
        updatedAt: new Date(),
      });
      // 요즘 담기는 문서. `mapLink`가 있다.
      for (const id of ['modern_place', 'edit_place', 'interest_place']) {
        await setDoc(placeRef(db, id), {
          id,
          name: 'Ramen Nagi',
          address: 'Shinjuku, Tokyo',
          category: 'food',
          provider: 'manual',
          providerPlaceId: '',
          latitude: null,
          longitude: null,
          note: '',
          mapLink: '',
          createdByProfileId: ME,
          interestedByProfileIds: [ME],
          linkedDateKey: '',
          meetingPlanLinks: [],
          updatedByProfileId: ME,
          updatedAt: new Date(),
        });
      }
      await setDoc(placeRef(db, '_unused_modern'), {
        id: 'modern_place',
        name: 'Ramen Nagi',
        address: 'Shinjuku, Tokyo',
        category: 'food',
        provider: 'manual',
        providerPlaceId: '',
        latitude: null,
        longitude: null,
        note: '',
        mapLink: '',
        createdByProfileId: ME,
        interestedByProfileIds: [ME],
        linkedDateKey: '',
        meetingPlanLinks: [],
        updatedByProfileId: ME,
        updatedAt: new Date(),
      });
    });
  });

  it('계획 탭에서 옛 장소를 그 날에 붙일 수 있다', async () => {
    const db = env.authenticatedContext(ME).firestore();
    await assertSucceeds(
      updateDoc(placeRef(db, 'legacy_place'), meetingLinkPatch(ME, '2026-09-12')),
    );
  });

  it('계획 탭에서 요즘 장소도 그 날에 붙일 수 있다', async () => {
    const db = env.authenticatedContext(ME).firestore();
    await assertSucceeds(
      updateDoc(placeRef(db, 'modern_place'), meetingLinkPatch(ME, '2026-09-12')),
    );
  });

  it('상대가 담은 장소도 내 계획 날짜에 붙일 수 있다', async () => {
    const db = env.authenticatedContext(PARTNER).firestore();
    await assertSucceeds(
      updateDoc(
        placeRef(db, 'legacy_place'),
        meetingLinkPatch(PARTNER, '2026-09-13'),
      ),
    );
  });

  it('직접 담은 장소는 좌표가 없어도 만들 수 있다', async () => {
    const db = env.authenticatedContext(ME).firestore();
    await assertSucceeds(
      setDoc(placeRef(db, 'hand_added'), {
        id: 'hand_added',
        name: 'Ramen Nagi',
        address: 'Shinjuku, Tokyo',
        category: 'food',
        provider: 'manual',
        providerPlaceId: '',
        latitude: null,
        longitude: null,
        note: '',
        mapLink: '',
        createdByProfileId: ME,
        interestedByProfileIds: [ME],
        linkedDateKey: '',
        meetingPlanLinks: [],
        updatedByProfileId: ME,
        updatedAt: serverTimestamp(),
      }),
    );
  });

  it('장소 이름을 고칠 수 있다', async () => {
    const db = env.authenticatedContext(ME).firestore();
    await assertSucceeds(
      setDoc(
        placeRef(db, 'edit_place'),
        {
          id: 'edit_place',
          name: 'Ramen Nagi 신주쿠점',
          address: 'Shinjuku, Tokyo',
          category: 'food',
          provider: 'manual',
          providerPlaceId: '',
          latitude: null,
          longitude: null,
          note: '',
          mapLink: 'https://maps.app.goo.gl/abc',
          createdByProfileId: ME,
          interestedByProfileIds: [ME],
          linkedDateKey: '',
          meetingPlanLinks: [],
          updatedByProfileId: ME,
          updatedAt: serverTimestamp(),
        },
        { merge: true },
      ),
    );
  });

  it('상대가 관심 표시를 켤 수 있다', async () => {
    const db = env.authenticatedContext(PARTNER).firestore();
    await assertSucceeds(
      updateDoc(placeRef(db, 'interest_place'), {
        interestedByProfileIds: [ME, PARTNER],
        updatedByProfileId: PARTNER,
        updatedAt: new Date(),
      }),
    );
  });

  it('space 밖의 사람은 아무것도 쓸 수 없다', async () => {
    const db = env.authenticatedContext('strangerUid').firestore();
    await assertFails(
      updateDoc(
        placeRef(db, 'legacy_place'),
        meetingLinkPatch('strangerUid', '2026-09-12'),
      ),
    );
  });
});
