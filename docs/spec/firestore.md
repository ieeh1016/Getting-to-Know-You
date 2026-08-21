# Firestore And Data Policy Spec

## 목적

이 spec은 모든 feature의 Firebase, Firestore, security, Spark/free-plan boundary를 정의한다.

## 전역 규칙

- two-person private space만 지원한다.
- MVP에서는 public sign-up 또는 multi-space discovery를 제공하지 않는다.
- 명시적으로 승인하지 않는 한 Cloud Functions dependency를 두지 않는다.
- 예외: 푸시 알림은 사용자 승인 후 Firebase Cloud Messaging과 Cloud Functions를 사용한다. client는 알림 토큰/설정만 쓰고, 실제 발송은 Admin SDK가 수행한다.
- MVP에서는 Storage media upload, TTL, PITR, backup, restore, clone, scheduled job을 사용하지 않는다.
- repo에는 secret, service account JSON, 승인된 public client config를 넘어서는 raw API key, private payload dump를 넣지 않는다.

## Write Budget 규칙

- typing, scrolling, route changes, tab changes, calendar navigation, map movement, seen-state read는 Firestore write를 만들면 안 된다.
- feature spec이 다르게 정하지 않는 한 explicit save/select/edit/delete action은 document 하나만 써야 한다.
- batch write는 spec note와 test coverage가 필요하다.

## 현재 Collection

- `spaces/{spaceId}/answers/{questionId_uid}`
- `spaces/{spaceId}/answerComments/{questionId_ownerUid_commenterUid}`
- `spaces/{spaceId}/progress/{progressId}`
- `spaces/{spaceId}/profileCards/{profileId}/slots/{slotId}`
- `spaces/{spaceId}/wishes/{wishId}`
- `spaces/{spaceId}/memoryCards/{cardId}`
- `spaces/{spaceId}/memoryCardResponses/{responseId}`
- `spaces/{spaceId}/musicNotes/{noteId}`
- `spaces/{spaceId}/musicNoteComments/{commentId}`
- `spaces/{spaceId}/scheduleEntries/{dateKey_uid}`
- `spaces/{spaceId}/sharedPlaces/{placeId}`
- `spaces/{spaceId}/trips/{tripId}`
- `spaces/{spaceId}/tripItems/{itemId}`: `cost`, `paidByProfileId`, `wishId`와 여행 문서의 `currencyLabel`은 더 이상 쓰지 않는다. 이미 저장된 문서에 남아 있어 규칙의 허용 키 목록에서 빼면 그 문서들이 수정되지 않으므로, 키는 남기고 값이 있을 때만 검사한다.
- `spaces/{spaceId}/tripPhotos/{photoId}`: 갤러리 사진을 줄여 담는 data URI. Cloud Storage 없이 Spark plan 안에서 다루기 위한 경로라 문서당 크기 상한이 있다. session 로딩에서 읽지 않고, 여행 **하나를 열 때 `tripId`로 걸러 그 여행 것만** 읽는다. 문서가 커서 매 접속마다 전부 받으면 전송량이 크게 든다.
- `spaces/{spaceId}/diagnosticEvents/{eventId}`
- `spaces/{spaceId}/curiosityCards/{cardId}`
- `spaces/{spaceId}/stockStories/{storyId}`
- `spaces/{spaceId}/stockHoldings/{holdingId}`
- `spaces/{spaceId}/improvementPosts/{postId}`
- `spaces/{spaceId}/activityEvents/{eventId}`: Spark 기본 빌드에서는 생성하지 않는 푸시 알림용 활동 이벤트 휴면 경로. Blaze 전환 후 client가 명시적 저장 동작 성공 시 생성할 수 있다. client read/update/delete 없음.
- `spaces/{spaceId}/notificationEvents/{eventId}`: Cloud Functions idempotency log 휴면 경로. client read/write 없음.
- `users/{uid}/notificationSettings/push`
- `users/{uid}/notificationTokens/{tokenId}`

## 오프라인

- Firestore local persistence를 켠다(`Settings(persistenceEnabled: true)`). 여행은 이 앱에서 유일하게 집 밖에서 쓰는 기능이라, 비행기나 로밍을 끈 해외에서 새로고침해도 마지막에 본 내용이 남아야 한다. 무료 플랜 범위 안이며 추가 write를 만들지 않는다.
- 로그인은 됐는데 session을 읽지 못한 경우와 프로필 문서가 없는 경우는 다른 화면으로 보여준다. 연결 실패에 개발자용 Firebase 설정 안내를 띄우면 사용자가 할 수 있는 일이 없다. 연결 실패에는 다시 시도만 준다.

## 삭제 권한

- 여행과 그 하위의 `tripItems`, `tripPhotos`는 **space member 누구든** 지울 수 있다. 둘이 같이 채우는 공간이라 누가 담았는지로 가르면 상대가 담은 것을 정리할 길이 없고, 여행을 지울 때 자식 문서만 남는다. 되돌릴 수 없는 것은 규칙이 아니라 앱의 확인 sheet로 막는다.
- 사진 문서의 `caption`만 올린 사람이 아니면 바꿀 수 없다. 남의 말을 고치는 것과 정리하는 것은 다르다. `dateKey`로 묶는 것은 둘 다 한다.
- 그 밖의 collection은 만든 사람만 지운다.

## Rules Maintenance

- `firestore.rules`가 바뀌면 [`../firebase_setup.md`](../firebase_setup.md)를 함께 갱신한다.
- practical한 범위에서 rules는 ownership, string bounds, list bounds, allowed enum value를 검증해야 한다.
- intended valid write를 허용하고 obvious cross-user write를 거절하기 전까지 feature는 완료된 것이 아니다.
- collection, owner field, cross-feature reference를 추가하면 [`domain_model.md`](domain_model.md)를 갱신한다.
