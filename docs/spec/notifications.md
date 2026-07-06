# Push Notifications Spec

## 목적

푸시 알림은 앱을 열지 않은 상태에서도 새 공유 활동을 가볍게 알려주는 선택 기능이다. 현재 Spark plan 운영에서는 Cloud Functions를 배포할 수 없으므로 기본 비활성화되어 있다. Home 활동/새 소식이 source of truth이고, 푸시는 나중에 Blaze plan으로 전환할 때 되살릴 외부 신호다.

## Product Rules

- Spark 기본 빌드에서는 `마이` 화면에 푸시 알림 토글을 보여주지 않고 FCM token을 저장하지 않는다.
- 앱 첫 진입이나 로그인 직후에 권한 prompt를 자동으로 띄우지 않는다.
- Blaze 전환 후 `ENABLE_PUSH_NOTIFICATIONS=true`로 빌드한 경우에만 사용자가 직접 켠 뒤 FCM token을 저장한다.
- Android와 iPhone 앱을 1차 지원한다. Web push는 VAPID/service worker 설정 전까지 지원하지 않는다.
- private memory card는 절대 푸시를 보내지 않는다.
- 알림 title/body에는 기억 카드 본문, 수정 제안 전문, private note, 질문/댓글/건의 본문 같은 긴 사용자 입력을 넣지 않는다.
- 알림을 누르면 해당 feature route로 이동한다.
- 사용자가 알림을 꺼도 Firestore 데이터와 Home 활동은 계속 남아야 한다.

## Trigger Events

- Spark 기본 빌드에서는 client가 `spaces/{spaceId}/activityEvents/{eventId}`를 생성하지 않는다.
- Blaze 전환 후 `ENABLE_ACTIVITY_EVENTS=true`와 Cloud Functions 배포를 함께 켠 경우에만, client는 사용자가 명시적으로 저장/작성/반응한 동작이 성공할 때 `activityEvents`를 생성한다.
- Cloud Functions는 `activityEvents` create만 감지하고, 같은 space의 상대 member에게 발송한다.
- 현재 activity event 대상:
  - 질문 답변/넘김, 답변 댓글/답장
  - 밸런스 선택
  - 프로필 카드 저장
  - 위시 저장/상태 변경
  - shared 기억 카드 저장, shared 기억 카드 반응/수정 제안
  - 음악 노트 저장, 들었어요, 음악 댓글
  - 만남 가능 시간, 만남 계획, 장소/장소 계획 저장
  - 질문 카드 보내기/답장
  - 주식 이야기/보유 이야기 저장 또는 답장
  - 건의함 글, 답변, 처리 완료
- 앱 접속, 화면 보기, 스크롤, 임시 입력, 저장 실패, private 기억 카드는 activity event를 만들지 않는다.

## Data Model

- `spaces/{spaceId}/activityEvents/{eventId}`
  - `id: string`
  - `type: string`
  - `actorProfileId: string`
  - `route: string`
  - `feature: string`
  - `targetId: string`
  - `createdAt: server timestamp`
- `users/{uid}/notificationSettings/push`
  - `enabled: bool`
  - `spaceId: string`
  - `updatedAt: server timestamp`
- `users/{uid}/notificationTokens/{tokenId}`
  - `token: string`
  - `platform: android | ios | unknown`
  - `spaceId: string`
  - `enabled: bool`
  - `updatedAt: server timestamp`
- `spaces/{spaceId}/notificationEvents/{eventId}`
  - Cloud Functions idempotency log이다.
  - client read/write를 제공하지 않는다.

## Client Behavior

- Spark 기본 빌드에서는 push service를 bind하지 않고, token refresh를 Firestore에 갱신하지 않는다.
- Blaze 전환 후에는 `firebase_messaging`으로 권한을 요청하고 FCM registration token을 가져온다.
- token refresh는 사용자가 push setting을 켠 경우에만 Firestore에 갱신한다.
- foreground message는 system notification 대신 in-app SnackBar로 보여주고 `열기` action을 제공한다.
- terminated/background 상태에서 알림을 탭하면 `getInitialMessage()` 또는 `onMessageOpenedApp`로 route를 적용한다.

## Server Behavior

- Cloud Functions Firestore create trigger가 `activityEvents`를 감지한다.
- 발송 전 `notificationEvents/activity-{eventId}`를 transaction으로 먼저 생성해 function retry 중복 발송을 줄인다.
- recipient는 `spaces/{spaceId}.memberIds` 중 `actorProfileId`가 아닌 member로 계산한다.
- recipient의 `notificationSettings/push.enabled == true`이고 token의 `enabled == true`, `spaceId`가 같은 경우에만 전송한다.
- invalid FCM token은 `enabled: false`로 비활성화한다.

## Platform Setup

- Android: `POST_NOTIFICATIONS` permission을 manifest에 선언한다.
- iOS: Firebase Console에 APNs authentication key를 등록하고 Xcode Push Notifications capability를 켠다.
- iOS: remote notification background mode를 설정한다.

## Verification

- Widget test: Spark 기본 빌드에서 fake push service를 주입해도 `마이` 화면에 push setting이 보이지 않고 service가 호출되지 않음을 검증한다.
- Harness test: Firestore Rules, dormant push token paths, activity event trigger/privacy guard, Spark CI deploy guard를 검증한다.
- Manual smoke: Blaze 전환 시 Android/iPhone 실기기에서 권한 prompt, token 등록, activity event 알림, notification tap route를 확인한다.
