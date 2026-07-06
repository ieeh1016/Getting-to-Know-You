# Push Notifications Spec

## 목적

푸시 알림은 앱을 열지 않은 상태에서도 새 공유 활동을 가볍게 알려준다. Home 활동/새 소식이 source of truth이고, 푸시는 외부 신호일 뿐이다.

## Product Rules

- 사용자가 `마이` 화면에서 직접 켠 뒤에만 FCM token을 저장한다.
- 앱 첫 진입이나 로그인 직후에 권한 prompt를 자동으로 띄우지 않는다.
- Android와 iPhone 앱을 1차 지원한다. Web push는 VAPID/service worker 설정 전까지 지원하지 않는다.
- private memory card는 절대 푸시를 보내지 않는다.
- 알림 title/body에는 기억 카드 본문, 수정 제안 전문, private note를 넣지 않는다.
- 알림을 누르면 해당 feature route로 이동한다. 현재 1차 대상은 `서로의 기억`이다.
- 사용자가 알림을 꺼도 Firestore 데이터와 Home 활동은 계속 남아야 한다.

## Trigger Events

- `spaces/{spaceId}/memoryCards/{cardId}` create
  - `visibility == shared`인 경우에만 `subjectProfileId`에게 발송한다.
  - `createdByProfileId == subjectProfileId`이면 발송하지 않는다.
- `spaces/{spaceId}/memoryCardResponses/{responseId}` create
  - 원본 카드가 shared일 때만 카드 작성자에게 발송한다.
  - responder가 카드 작성자와 같으면 발송하지 않는다.

## Data Model

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

- `firebase_messaging`으로 권한을 요청하고 FCM registration token을 가져온다.
- token refresh는 사용자가 push setting을 켠 경우에만 Firestore에 갱신한다.
- foreground message는 system notification 대신 in-app SnackBar로 보여주고 `열기` action을 제공한다.
- terminated/background 상태에서 알림을 탭하면 `getInitialMessage()` 또는 `onMessageOpenedApp`로 route를 적용한다.

## Server Behavior

- Cloud Functions Firestore create trigger가 memory card/create response event를 감지한다.
- 발송 전 `notificationEvents/{eventId}`를 transaction으로 먼저 생성해 중복 발송을 줄인다.
- recipient의 `notificationSettings/push.enabled == true`이고 token의 `enabled == true`, `spaceId`가 같은 경우에만 전송한다.
- invalid FCM token은 `enabled: false`로 비활성화한다.

## Platform Setup

- Android: `POST_NOTIFICATIONS` permission을 manifest에 선언한다.
- iOS: Firebase Console에 APNs authentication key를 등록하고 Xcode Push Notifications capability를 켠다.
- iOS: remote notification background mode를 설정한다.

## Verification

- Widget test: fake push service로 `마이` 화면에서 push setting을 켤 수 있음을 검증한다.
- Harness test: Firestore Rules, push token paths, Cloud Functions trigger/privacy guard를 검증한다.
- Manual smoke: Android/iPhone 실기기에서 권한 prompt, token 등록, shared memory card 알림, notification tap route를 확인한다.
