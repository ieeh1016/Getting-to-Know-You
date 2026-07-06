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
- `spaces/{spaceId}/balanceSelections/{questionId_uid}`
- `spaces/{spaceId}/profileCards/{profileId}/slots/{slotId}`
- `spaces/{spaceId}/wishes/{wishId}`
- `spaces/{spaceId}/memoryCards/{cardId}`
- `spaces/{spaceId}/memoryCardResponses/{responseId}`
- `spaces/{spaceId}/musicNotes/{noteId}`
- `spaces/{spaceId}/musicNoteComments/{commentId}`
- `spaces/{spaceId}/scheduleEntries/{dateKey_uid}`
- `spaces/{spaceId}/sharedPlaces/{placeId}`
- `spaces/{spaceId}/diagnosticEvents/{eventId}`
- `spaces/{spaceId}/curiosityCards/{cardId}`
- `spaces/{spaceId}/stockStories/{storyId}`
- `spaces/{spaceId}/stockHoldings/{holdingId}`
- `spaces/{spaceId}/improvementPosts/{postId}`
- `spaces/{spaceId}/notificationEvents/{eventId}`: Cloud Functions idempotency log. client read/write 없음.
- `users/{uid}/notificationSettings/push`
- `users/{uid}/notificationTokens/{tokenId}`

## Rules Maintenance

- `firestore.rules`가 바뀌면 [`../firebase_setup.md`](../firebase_setup.md)를 함께 갱신한다.
- practical한 범위에서 rules는 ownership, string bounds, list bounds, allowed enum value를 검증해야 한다.
- intended valid write를 허용하고 obvious cross-user write를 거절하기 전까지 feature는 완료된 것이 아니다.
- collection, owner field, cross-feature reference를 추가하면 [`domain_model.md`](domain_model.md)를 갱신한다.
