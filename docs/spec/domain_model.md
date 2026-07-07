# Domain Model Spec

## 목적

이 문서는 `조금씩`의 shared data vocabulary를 정의한다.
feature spec은 사용자가 무엇을 할 수 있는지 설명한다. 이 문서는 그 behavior를 어떤 domain object가 표현하는지, object가 Firestore와 어떻게 연결되는지, 어떤 사용자가 각 record를 바꿀 수 있는지 설명한다.

다음 변경에서는 이 문서를 함께 확인한다.

- A model in `lib/src/domain/alagagi_controller.dart`.
- A Firestore mapper in `lib/src/data/firebase_alagagi_repositories.dart`.
- `firestore.rules` or [`../firebase_setup.md`](../firebase_setup.md).
- A flow that connects two features, such as meeting plans using saved places.

## 기준 범위

- feature behavior는 관련 feature spec이 소유한다.
- Firestore security detail은 [`firestore.md`](firestore.md)와 `firestore.rules`가 소유한다.
- 이 문서는 cross-feature model map이다. feature spec과 충돌하면 implementation 전에 두 문서를 함께 갱신한다.

## 공통 규칙

- `spaceId`는 두 사람의 private space를 식별한다.
- `profileId` 값은 두 member의 Firebase Auth UID다.
- `createdByProfileId`는 최초 작성자이며 조용히 바뀌면 안 된다.
- `updatedByProfileId`는 가장 최근 explicit save를 수행한 member다.
- `updatedAt`은 Firebase-backed flow에서 server timestamp로 기록한다.
- `createdLabel`, `repliedLabel` 같은 field는 user-facing display label이며 ordering key가 아니다.
- `dateKey`는 앱 calendar logic 기준의 짧은 date string이며 현재 형식은 `YYYY-MM-DD`다.
- draft typing, scrolling, tab switch, calendar movement, map movement, local seen-state change는 domain write가 아니다.

## Identity와 Session

| Model | Storage | 역할 |
| --- | --- | --- |
| `AlagagiAuthUser` | Firebase Auth | signed-in account identity. |
| `AppProfile` | `users/{uid}` | display identity, partner link, optional owner role. |
| `AlagagiSession` | derived | 현재 `spaceId`, 내 profile, partner profile, loaded space data. |
| `AlagagiSpaceData` | space subcollection에서 derived | screen과 controller state가 사용하는 read model. |
| `SpacePersonalization` | `spaces/{spaceId}` | app title/home copy/invite copy customization. |

앱은 하나의 private space에 속한 known member로 범위를 제한한다. public discovery, multi-space browsing, anonymous write는 현재 domain 밖이다.

## Feature Model Map

| 영역 | Domain model | Firestore storage | Ownership과 write boundary |
| --- | --- | --- | --- |
| Questions | `DailyQuestion`, `Answer`, `AnswerComment`, `DailyQuestionProgress` | `answers`, `answerComments`, `progress/daily` | member는 자신의 answer만 쓴다. comment는 question/answer owner/commenter 조합당 하나다. answer owner는 그 comment에 reply를 하나 남길 수 있다. |
| Records | `ArchiveItem`, `QuestionCalendarDay`, `TimelineEvent`, `RelationshipInsight` | answer와 catalog data에서 derived | read-only projection이다. browsing, filtering, month change 중 write를 만들면 안 된다. |
| Taste match | `BalanceQuestion`, `BalanceOption`, `BalanceSelection` | `balanceSelections/{questionId_uid}` | member는 자신의 selection을 쓰거나 삭제한다. reason은 optional이고 result reveal은 explicit state다. |
| Profile cards | `ProfileSlot`, `ProfileSlotValue`, `ProfileCardData` | `profileCards/{profileId}/slots/{slotId}` | member는 자신의 slot을 쓴다. custom slot은 owning profile이 삭제할 수 있다. |
| Wishlist | `WishItem` | `wishes/{wishId}` | creator는 삭제할 수 있다. interest와 done state는 shared field지만 write에는 acting member가 `likedByProfileIds`에 포함되어야 한다. |
| Memory cards | `MemoryCard`, `MemoryCardResponse` | `memoryCards/{cardId}`, `memoryCardResponses/{cardId_responderUid}` | card creator는 card body/visibility를 쓴다. shared card의 subject member는 reaction/correction response를 쓸 수 있지만 card body를 직접 덮어쓰지 않는다. private card는 creator만 읽고 쓸 수 있다. |
| Music | `MusicNote`, `MusicNoteComment` | `musicNotes/{noteId}`, `musicNoteComments/{commentId}` | note creator는 create/edit/delete할 수 있다. 두 member 모두 note content를 바꾸지 않고 listen state만 명시적으로 update할 수 있다. comment creator는 자신의 comment만 create/edit/delete할 수 있고 parent note ordering은 바꾸지 않는다. |
| Schedule coordination | `ScheduleTimeBlock`, `ScheduleEntry`, `MeetingCandidate` | `scheduleEntries/{dateKey_uid}` | member는 자신의 date entry만 쓴다. meeting-day marker는 schedule entry에 저장된다. |
| Meeting plans | `MeetingPlan` | `meetingPlans/{dateKey}` | fixed meeting day의 shared plan list와 cancellation state다. 가장 최근 saver는 `updatedByProfileId`로 기록한다. |
| Places | `SharedPlace`, `MeetingPlaceLink` | `sharedPlaces/{placeId}` | creator가 place content를 소유한다. interested member는 narrow place-link path로 interest 또는 meeting link를 update할 수 있다. provider는 Kakao만 사용한다. |
| Curiosity | `CuriosityCard` | `curiosityCards/{cardId}` | sender는 상대 member에게 question을 하나 만든다. receiver가 reply를 쓴다. |
| Stocks | `StockStory`, `StockHolding` | `stockStories`, `stockHoldings` | creator가 initial story/holding을 쓴다. partner는 story에 reply하고, holding owner는 holding detail을 edit하며 partner도 reply할 수 있다. |
| Improvements | `ImprovementPost` | `improvementPosts/{postId}` | creator는 자신의 post를 create/edit/delete할 수 있다. owner-role user는 owner note를 남기고 resolved 처리할 수 있다. |
| Push notifications | `PushNotificationSetupState`, `PushNotificationIntent`, `activityEvents` | `users/{uid}/notificationSettings/push`, `users/{uid}/notificationTokens/{tokenId}`, `activityEvents`, `notificationEvents` | Spark 기본 빌드에서는 푸시 알림 UI, token write, activity event write가 휴면 상태다. Blaze 전환 후에는 member가 자신의 push setting/token만 쓰고, client가 safe metadata만 담은 activity event를 만들며, Cloud Functions는 상대 member에게 1회 발송한다. private content와 긴 본문은 payload에 넣지 않는다. |
| Diagnostics | `DiagnosticEvent` | `diagnosticEvents/{eventId}` | operational save-failure record다. member는 create할 수 있고 owner-role user는 read할 수 있다. user-facing content가 아니다. |

## Cross-Feature 관계

- `ScheduleEntry.isMeetingDay`는 해당 date를 `만남` tab에 표시 가능한 상태로 만든다.
- `MeetingPlan.dateKey`는 그 fixed meeting day의 shared plan record다.
- `SharedPlace.meetingPlanLinks`는 saved place를 meeting date와 연결하며 `reservationTimeLabel`을 포함할 수 있다.
- `WishItem.kind == place`와 `SharedPlace`는 user concept상 관련이 있지만 서로 다른 domain record다. wishlist idea가 place를 자동 생성하지 않는다.
- `Answer`, `AnswerComment`, `CuriosityCard`는 서로 다른 question flow다. spec change 없이 storage나 notification state를 합치지 않는다.
- Home unread activity는 feature record와 local seen state를 모아 만든 derived summary다. rendering 중 Firestore write를 만들면 안 된다.
- Push notification은 Home unread activity를 대체하지 않는다. Spark plan에서는 휴면 상태이며, Blaze 전환 후에도 FCM payload는 route/target id만 담고 실제 detail은 앱이 Firestore read model에서 다시 읽는다.

## Write Design Checklist

Firebase-backed model을 추가하거나 변경하기 전에 다음을 확인한다.

1. 이 문서에 domain model과 owner field를 명시한다.
2. feature spec behavior를 추가하거나 갱신한다.
3. [`firestore.md`](firestore.md)에 Firestore path를 추가한다.
4. `firestore.rules`와 [`../firebase_setup.md`](../firebase_setup.md)를 함께 갱신한다.
5. spec이 명시적으로 batch를 승인하지 않는 한 explicit user action 하나는 document write 하나로 유지한다.
6. repository field가 Firestore Rules에서 허용되어야 한다면 harness 또는 domain test를 추가한다.

## 현재 구현 Note

진행 중인 extraction 동안 대부분의 model은 아직 `lib/src/domain/alagagi_controller.dart`에 있다.
UI module이 `lib/src/ui/alagagi_app.dart` 밖으로 이동할수록 새로 만들거나 크게 바꾸는 domain model은 [`../code_structure.md`](../code_structure.md)에 정리된 목표 구조인 `lib/src/domain/models/`, `lib/src/domain/repositories/`, `lib/src/domain/controller/` 방향으로 옮긴다.
