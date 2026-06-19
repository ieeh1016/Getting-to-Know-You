# Firebase Setup Guide

> Spec source: [spec.md](spec.md) and [spec/firestore.md](spec/firestore.md).
> 작성 기준일: 2026-06-11.

이 앱은 Firebase Auth의 Email/Password 로그인을 사용하지만, 화면에는 이메일 대신 짧은 아이디만 보여준다.

- `youngwoo` -> `youngwoo@gettoknow.local`
- `minyoung` -> `minyoung@gettoknow.local`

비밀번호는 코드, Firestore, GitHub에 넣지 않는다. Firebase Console에서 직접 만들고 관리한다.

## 1. Firebase 프로젝트 만들기

1. [Firebase Console](https://console.firebase.google.com/)에 들어간다.
2. `Add project`를 누른다.
3. 프로젝트 이름은 예: `getting-to-know-you`.
4. Google Analytics는 MVP에서는 꺼도 된다.

## 2. Web App 등록

1. Project settings -> General -> Your apps에서 Web 아이콘을 누른다.
2. App nickname은 예: `alagagi-web`.
3. Hosting 설정은 체크하지 않아도 된다. 현재 호스팅은 GitHub Pages가 담당한다.
4. 생성 후 Firebase config 값에서 아래 값을 복사한다.

필요한 값:

- `apiKey`
- `appId`
- `messagingSenderId`
- `projectId`
- `authDomain`
- `storageBucket`

## 3. Authentication 켜기

1. Build -> Authentication -> Get started.
2. Sign-in method 탭으로 이동한다.
3. `Email/Password` provider를 Enable 한다.
4. Authentication -> Users -> Add user에서 두 계정을 만든다.

계정:

```text
youngwoo@gettoknow.local
minyoung@gettoknow.local
```

비밀번호:

- 직접 정한다.
- 두 사람에게만 알려준다.
- fake email이라 Firebase 기본 비밀번호 재설정 메일은 받을 수 없다. 잊어버리면 Console에서 새 비밀번호로 직접 변경한다.

## 4. Firestore Database 만들기

1. Build -> Firestore Database -> Create database.
2. Production mode로 시작한다.
3. Location은 기본값 또는 가까운 리전을 선택한다.
4. 생성 후 Authentication -> Users에서 두 계정의 UID를 복사한다.

아래 예시에서 값을 바꿔 넣는다.

- `{youngwooUid}`: `youngwoo@gettoknow.local` 계정의 UID
- `{minyoungUid}`: `minyoung@gettoknow.local` 계정의 UID

## 5. Firestore 문서 만들기

### `users/{youngwooUid}`

```json
{
  "displayName": "영우",
  "avatar": "🌿",
  "role": "owner",
  "spaceId": "main",
  "partnerUid": "{minyoungUid}"
}
```

### `users/{minyoungUid}`

```json
{
  "displayName": "민영",
  "avatar": "🪻",
  "role": "guest",
  "spaceId": "main",
  "partnerUid": "{youngwooUid}"
}
```

### `spaces/main`

```json
{
  "name": "조금씩",
  "memberIds": ["{youngwooUid}", "{minyoungUid}"],
  "personalization": {
    "appTitle": "조금씩",
    "homeLine": "오늘도 한 가지를 알아가요",
    "inviteLine": "하루에 하나씩, 조용히 알아가요",
    "accentEmoji": "🌿"
  }
}
```

Firestore Console에서 배열은 `array` 타입으로 넣는다.

`spaces/main/curiosityCards` 하위 컬렉션은 앱에서 처음 `질문 보내기`를 누를 때 자동으로 만들어진다. `spaces/main/stockStories` 하위 컬렉션도 `주식 이야기`에서 처음 `이야기 남기기`를 누를 때 자동으로 만들어진다. `spaces/main/stockHoldings` 하위 컬렉션은 `보유` 탭에서 처음 `보유 공유하기`를 누를 때 자동으로 만들어진다. `spaces/main/improvementPosts` 하위 컬렉션은 `건의함`에서 처음 `건의 남기기`를 누를 때 자동으로 만들어진다. Console에서 빈 컬렉션을 미리 만들 필요는 없지만, 아래 Security Rules에는 `curiosityCards`, `stockStories`, `stockHoldings`, `improvementPosts` 규칙이 포함되어 있어야 한다.

## 6. Firestore Security Rules

Firestore Database -> Rules에 아래 규칙을 넣고 Publish 한다.
저장소 기준 파일은 `firestore.rules`이며, 아래 문서 블록과 기준 파일은
`./scripts/check_firestore_rules_sync.sh`와 `test/harness_contract_test.dart`로
동기화 여부를 검증한다.

```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    function signedIn() {
      return request.auth != null;
    }

    function hasUserProfile() {
      return signedIn()
        && exists(/databases/$(database)/documents/users/$(request.auth.uid));
    }

    function currentUserProfile() {
      return get(/databases/$(database)/documents/users/$(request.auth.uid));
    }

    function isOwnerUser() {
      return hasUserProfile()
        && currentUserProfile().data.role == 'owner';
    }

    function isSpaceMember(spaceId) {
      return hasUserProfile()
        && exists(/databases/$(database)/documents/spaces/$(spaceId))
        && currentUserProfile().data.spaceId == spaceId
        && request.auth.uid in get(/databases/$(database)/documents/spaces/$(spaceId)).data.memberIds;
    }

    function validPersonalization(personalization) {
      return personalization is map
        && personalization.keys().hasOnly(['appTitle', 'homeLine', 'inviteLine', 'accentEmoji'])
        && personalization.appTitle is string
        && personalization.appTitle.size() > 0
        && personalization.appTitle.size() <= 16
        && personalization.homeLine is string
        && personalization.homeLine.size() > 0
        && personalization.homeLine.size() <= 40
        && personalization.inviteLine is string
        && personalization.inviteLine.size() <= 40
        && personalization.accentEmoji is string
        && personalization.accentEmoji.size() <= 8;
    }

    function validDiagnosticEvent(spaceId, eventId) {
      return request.resource.data.keys().hasOnly([
          'id',
          'feature',
          'action',
          'targetId',
          'message',
          'detail',
          'createdByProfileId',
          'createdAt'
        ])
        && request.resource.data.id == eventId
        && request.resource.data.feature is string
        && request.resource.data.feature.size() > 0
        && request.resource.data.feature.size() <= 40
        && request.resource.data.action is string
        && request.resource.data.action.size() > 0
        && request.resource.data.action.size() <= 80
        && request.resource.data.targetId is string
        && request.resource.data.targetId.size() <= 120
        && request.resource.data.message is string
        && request.resource.data.message.size() > 0
        && request.resource.data.message.size() <= 500
        && request.resource.data.detail is string
        && request.resource.data.detail.size() <= 1000
        && request.resource.data.createdByProfileId == request.auth.uid
        && request.resource.data.createdByProfileId in get(/databases/$(database)/documents/spaces/$(spaceId)).data.memberIds
        && request.resource.data.createdAt == request.time;
    }

    function validAnswerComment(spaceId, commentId) {
      return request.resource.data.keys().hasOnly([
          'questionId',
          'answerOwnerProfileId',
          'commenterProfileId',
          'body',
          'createdLabel',
          'edited',
          'updatedAt'
        ])
        && request.resource.data.questionId is string
        && request.resource.data.answerOwnerProfileId is string
        && request.resource.data.commenterProfileId == request.auth.uid
        && request.resource.data.answerOwnerProfileId != request.auth.uid
        && request.resource.data.answerOwnerProfileId in get(/databases/$(database)/documents/spaces/$(spaceId)).data.memberIds
        && request.resource.data.body is string
        && request.resource.data.body.size() > 0
        && request.resource.data.body.size() <= 120
        && request.resource.data.createdLabel is string
        && request.resource.data.edited is bool
        && commentId == request.resource.data.questionId + '_' + request.resource.data.answerOwnerProfileId + '_' + request.resource.data.commenterProfileId;
    }

    function validDailyProgress(progressId) {
      return progressId == 'daily'
        && request.resource.data.keys().hasOnly([
          'startedDateKey',
          'currentQuestionId',
          'openedDateKey',
          'catalogVersion',
          'updatedAt'
        ])
        && request.resource.data.currentQuestionId is string
        && request.resource.data.openedDateKey is string
        && request.resource.data.catalogVersion is string
        && (!request.resource.data.keys().hasAny(['startedDateKey'])
          || request.resource.data.startedDateKey is string)
        && request.resource.data.currentQuestionId.size() <= 16
        && request.resource.data.openedDateKey.size() <= 16
        && (!request.resource.data.keys().hasAny(['startedDateKey'])
          || request.resource.data.startedDateKey.size() <= 16)
        && request.resource.data.catalogVersion.size() <= 8;
    }

    function validMusicNoteShape(spaceId, noteId) {
      return request.resource.data.keys().hasOnly([
          'id',
          'title',
          'artist',
          'link',
          'note',
          'mood',
          'createdByProfileId',
          'createdLabel',
          'listenedByProfileIds',
          'updatedAt'
        ])
        && request.resource.data.id == noteId
        && request.resource.data.title is string
        && request.resource.data.title.size() > 0
        && request.resource.data.title.size() <= 60
        && request.resource.data.artist is string
        && request.resource.data.artist.size() > 0
        && request.resource.data.artist.size() <= 60
        && request.resource.data.link is string
        && request.resource.data.link.size() <= 180
        && request.resource.data.note is string
        && request.resource.data.note.size() <= 80
        && request.resource.data.mood in ['차분한', '산책', '카페', '밤', '가벼운', '집중']
        && request.resource.data.createdByProfileId in get(/databases/$(database)/documents/spaces/$(spaceId)).data.memberIds
        && request.resource.data.createdLabel is string
        && request.resource.data.createdLabel.size() <= 16
        && request.resource.data.listenedByProfileIds is list
        && request.resource.data.listenedByProfileIds.size() <= 2
        && request.resource.data.listenedByProfileIds.hasOnly(
          get(/databases/$(database)/documents/spaces/$(spaceId)).data.memberIds
        );
    }

    function validMusicNoteOwnerWrite(spaceId, noteId) {
      return validMusicNoteShape(spaceId, noteId)
        && request.resource.data.createdByProfileId == request.auth.uid;
    }

    function validMusicNoteListenUpdate(spaceId, noteId) {
      return validMusicNoteShape(spaceId, noteId)
        && request.resource.data.id == resource.data.id
        && request.resource.data.title == resource.data.title
        && request.resource.data.artist == resource.data.artist
        && request.resource.data.link == resource.data.link
        && request.resource.data.note == resource.data.note
        && request.resource.data.mood == resource.data.mood
        && request.resource.data.createdByProfileId == resource.data.createdByProfileId
        && request.resource.data.createdLabel == resource.data.createdLabel
        && request.resource.data.updatedAt == resource.data.updatedAt
        && request.resource.data.diff(resource.data).affectedKeys().hasOnly([
          'listenedByProfileIds'
        ])
        && (
          request.auth.uid in request.resource.data.listenedByProfileIds
          || (
            resource.data.keys().hasAny(['listenedByProfileIds'])
            && request.auth.uid in resource.data.listenedByProfileIds
          )
        );
    }

    function validImprovementPostShape(spaceId, postId) {
      return request.resource.data.keys().hasOnly([
          'id',
          'title',
          'body',
          'category',
          'createdByProfileId',
          'createdLabel',
          'ownerNote',
          'ownerNoteProfileId',
          'ownerNoteLabel',
          'resolved',
          'resolvedByProfileId',
          'resolvedLabel',
          'updatedAt'
        ])
        && request.resource.data.id == postId
        && request.resource.data.title is string
        && request.resource.data.title.size() >= 2
        && request.resource.data.title.size() <= 50
        && request.resource.data.body is string
        && request.resource.data.body.size() >= 4
        && request.resource.data.body.size() <= 300
        && request.resource.data.category in ['개선', '추가 요청', '불편함', '아이디어']
        && request.resource.data.createdByProfileId is string
        && request.resource.data.createdByProfileId in get(/databases/$(database)/documents/spaces/$(spaceId)).data.memberIds
        && request.resource.data.createdLabel is string
        && request.resource.data.createdLabel.size() <= 16
        && request.resource.data.ownerNote is string
        && request.resource.data.ownerNote.size() <= 160
        && request.resource.data.ownerNoteProfileId is string
        && request.resource.data.ownerNoteProfileId.size() <= 128
        && (request.resource.data.ownerNoteProfileId == ''
          || request.resource.data.ownerNoteProfileId in get(/databases/$(database)/documents/spaces/$(spaceId)).data.memberIds)
        && request.resource.data.ownerNoteLabel is string
        && request.resource.data.ownerNoteLabel.size() <= 16
        && request.resource.data.resolved is bool
        && request.resource.data.resolvedByProfileId is string
        && request.resource.data.resolvedByProfileId.size() <= 128
        && (request.resource.data.resolvedByProfileId == ''
          || request.resource.data.resolvedByProfileId in get(/databases/$(database)/documents/spaces/$(spaceId)).data.memberIds)
        && request.resource.data.resolvedLabel is string
        && request.resource.data.resolvedLabel.size() <= 16;
    }

    function validNewImprovementPost(spaceId, postId) {
      return validImprovementPostShape(spaceId, postId)
        && request.resource.data.createdByProfileId == request.auth.uid
        && request.resource.data.ownerNote == ''
        && request.resource.data.ownerNoteProfileId == ''
        && request.resource.data.ownerNoteLabel == ''
        && request.resource.data.resolved == false
        && request.resource.data.resolvedByProfileId == ''
        && request.resource.data.resolvedLabel == '';
    }

    function keepsImprovementOwnerFields() {
      return (
          (resource.data.keys().hasAny(['ownerNote']) && request.resource.data.ownerNote == resource.data.ownerNote)
          || (!resource.data.keys().hasAny(['ownerNote']) && request.resource.data.ownerNote == '')
        )
        && (
          (resource.data.keys().hasAny(['ownerNoteProfileId']) && request.resource.data.ownerNoteProfileId == resource.data.ownerNoteProfileId)
          || (!resource.data.keys().hasAny(['ownerNoteProfileId']) && request.resource.data.ownerNoteProfileId == '')
        )
        && (
          (resource.data.keys().hasAny(['ownerNoteLabel']) && request.resource.data.ownerNoteLabel == resource.data.ownerNoteLabel)
          || (!resource.data.keys().hasAny(['ownerNoteLabel']) && request.resource.data.ownerNoteLabel == '')
        )
        && (
          (resource.data.keys().hasAny(['resolved']) && request.resource.data.resolved == resource.data.resolved)
          || (!resource.data.keys().hasAny(['resolved']) && request.resource.data.resolved == false)
        )
        && (
          (resource.data.keys().hasAny(['resolvedByProfileId']) && request.resource.data.resolvedByProfileId == resource.data.resolvedByProfileId)
          || (!resource.data.keys().hasAny(['resolvedByProfileId']) && request.resource.data.resolvedByProfileId == '')
        )
        && (
          (resource.data.keys().hasAny(['resolvedLabel']) && request.resource.data.resolvedLabel == resource.data.resolvedLabel)
          || (!resource.data.keys().hasAny(['resolvedLabel']) && request.resource.data.resolvedLabel == '')
        );
    }

    function validImprovementPostOwnerEdit(spaceId, postId) {
      return validImprovementPostShape(spaceId, postId)
        && resource.data.createdByProfileId == request.auth.uid
        && request.resource.data.createdByProfileId == resource.data.createdByProfileId
        && request.resource.data.createdLabel == resource.data.createdLabel
        && request.resource.data.diff(resource.data).affectedKeys().hasOnly([
          'title',
          'body',
          'category',
          'ownerNote',
          'ownerNoteProfileId',
          'ownerNoteLabel',
          'resolved',
          'resolvedByProfileId',
          'resolvedLabel',
          'updatedAt'
        ])
        && keepsImprovementOwnerFields();
    }

    function validImprovementPostOwnerStatusUpdate(spaceId, postId) {
      return validImprovementPostShape(spaceId, postId)
        && isOwnerUser()
        && request.resource.data.createdByProfileId == resource.data.createdByProfileId
        && request.resource.data.createdLabel == resource.data.createdLabel
        && request.resource.data.diff(resource.data).affectedKeys().hasOnly([
          'ownerNote',
          'ownerNoteProfileId',
          'ownerNoteLabel',
          'resolved',
          'resolvedByProfileId',
          'resolvedLabel',
          'updatedAt'
        ])
        && (request.resource.data.ownerNote == ''
          || (request.resource.data.ownerNoteProfileId == request.auth.uid
            && request.resource.data.ownerNoteLabel.size() > 0))
        && (request.resource.data.resolved == false
          || (request.resource.data.resolvedByProfileId == request.auth.uid
            && request.resource.data.resolvedLabel.size() > 0));
    }

    function validCuriosityCardShape(spaceId, cardId) {
      return request.resource.data.keys().hasOnly([
          'id',
          'fromProfileId',
          'toProfileId',
          'question',
          'reply',
          'createdLabel',
          'repliedLabel',
          'updatedAt'
        ])
        && request.resource.data.id == cardId
        && request.resource.data.fromProfileId is string
        && request.resource.data.toProfileId is string
        && request.resource.data.fromProfileId != request.resource.data.toProfileId
        && request.resource.data.fromProfileId in get(/databases/$(database)/documents/spaces/$(spaceId)).data.memberIds
        && request.resource.data.toProfileId in get(/databases/$(database)/documents/spaces/$(spaceId)).data.memberIds
        && request.resource.data.question is string
        && request.resource.data.question.size() > 0
        && request.resource.data.question.size() <= 80
        && request.resource.data.reply is string
        && request.resource.data.reply.size() <= 160
        && request.resource.data.createdLabel is string
        && request.resource.data.createdLabel.size() <= 16
        && request.resource.data.repliedLabel is string
        && request.resource.data.repliedLabel.size() <= 16;
    }

    function validNewCuriosityCard(spaceId, cardId) {
      return validCuriosityCardShape(spaceId, cardId)
        && request.resource.data.fromProfileId == request.auth.uid
        && request.resource.data.toProfileId != request.auth.uid
        && request.resource.data.reply == ''
        && request.resource.data.repliedLabel == '';
    }

    function validCuriosityReply(spaceId, cardId) {
      return validCuriosityCardShape(spaceId, cardId)
        && resource.data.toProfileId == request.auth.uid
        && request.resource.data.fromProfileId == resource.data.fromProfileId
        && request.resource.data.toProfileId == resource.data.toProfileId
        && request.resource.data.question == resource.data.question
        && request.resource.data.createdLabel == resource.data.createdLabel
        && request.resource.data.diff(resource.data).affectedKeys().hasOnly([
          'reply',
          'repliedLabel',
          'updatedAt'
        ])
        && request.resource.data.reply.size() > 0;
    }

    function validStockStoryShape(spaceId, storyId) {
      return request.resource.data.keys().hasOnly([
          'id',
          'name',
          'reason',
          'upside',
          'risk',
          'question',
          'createdByProfileId',
          'createdLabel',
          'replyTone',
          'reply',
          'repliedByProfileId',
          'repliedLabel',
          'updatedByProfileId',
          'updatedAt'
        ])
        && request.resource.data.id == storyId
        && request.resource.data.name is string
        && request.resource.data.name.size() > 0
        && request.resource.data.name.size() <= 40
        && request.resource.data.reason is string
        && request.resource.data.reason.size() > 0
        && request.resource.data.reason.size() <= 120
        && request.resource.data.upside is string
        && request.resource.data.upside.size() > 0
        && request.resource.data.upside.size() <= 80
        && request.resource.data.risk is string
        && request.resource.data.risk.size() > 0
        && request.resource.data.risk.size() <= 80
        && request.resource.data.question is string
        && request.resource.data.question.size() > 0
        && request.resource.data.question.size() <= 100
        && request.resource.data.createdByProfileId is string
        && request.resource.data.createdByProfileId in get(/databases/$(database)/documents/spaces/$(spaceId)).data.memberIds
        && request.resource.data.createdLabel is string
        && request.resource.data.createdLabel.size() <= 16
        && request.resource.data.replyTone is string
        && request.resource.data.replyTone.size() <= 16
        && request.resource.data.reply is string
        && request.resource.data.reply.size() <= 160
        && request.resource.data.repliedByProfileId is string
        && (request.resource.data.repliedByProfileId == ''
          || request.resource.data.repliedByProfileId in get(/databases/$(database)/documents/spaces/$(spaceId)).data.memberIds)
        && request.resource.data.repliedLabel is string
        && request.resource.data.repliedLabel.size() <= 16
        && request.resource.data.updatedByProfileId is string
        && request.resource.data.updatedByProfileId in get(/databases/$(database)/documents/spaces/$(spaceId)).data.memberIds;
    }

    function validNewStockStory(spaceId, storyId) {
      return validStockStoryShape(spaceId, storyId)
        && request.resource.data.createdByProfileId == request.auth.uid
        && request.resource.data.replyTone == ''
        && request.resource.data.reply == ''
        && request.resource.data.repliedByProfileId == ''
        && request.resource.data.repliedLabel == ''
        && request.resource.data.updatedByProfileId == request.auth.uid;
    }

    function validStockStoryReply(spaceId, storyId) {
      return validStockStoryShape(spaceId, storyId)
        && resource.data.createdByProfileId != request.auth.uid
        && resource.data.reply == ''
        && resource.data.repliedByProfileId == ''
        && request.resource.data.createdByProfileId == resource.data.createdByProfileId
        && request.resource.data.name == resource.data.name
        && request.resource.data.reason == resource.data.reason
        && request.resource.data.upside == resource.data.upside
        && request.resource.data.risk == resource.data.risk
        && request.resource.data.question == resource.data.question
        && request.resource.data.createdLabel == resource.data.createdLabel
        && request.resource.data.diff(resource.data).affectedKeys().hasOnly([
          'replyTone',
          'reply',
          'repliedByProfileId',
          'repliedLabel',
          'updatedByProfileId',
          'updatedAt'
        ])
        && request.resource.data.replyTone in ['같이 볼래요', '더 찾아볼게요', '조심해요']
        && request.resource.data.reply.size() > 0
        && request.resource.data.repliedByProfileId == request.auth.uid
        && request.resource.data.updatedByProfileId == request.auth.uid
        && request.resource.data.repliedLabel is string
        && request.resource.data.repliedLabel.size() <= 16;
    }

    function validStockHoldingShape(spaceId, holdingId) {
      return request.resource.data.keys().hasOnly([
          'id',
          'name',
          'status',
          'weightLabel',
          'reason',
          'watchPoint',
          'concern',
          'question',
          'createdByProfileId',
          'createdLabel',
          'replyTone',
          'reply',
          'repliedByProfileId',
          'repliedLabel',
          'updatedByProfileId',
          'updatedAt'
        ])
        && request.resource.data.id == holdingId
        && request.resource.data.name is string
        && request.resource.data.name.size() > 0
        && request.resource.data.name.size() <= 40
        && request.resource.data.status in ['보유 중', '정리 고민 중', '최근 정리함']
        && request.resource.data.weightLabel in ['작게', '보통', '크게']
        && request.resource.data.reason is string
        && request.resource.data.reason.size() > 0
        && request.resource.data.reason.size() <= 120
        && request.resource.data.watchPoint is string
        && request.resource.data.watchPoint.size() > 0
        && request.resource.data.watchPoint.size() <= 80
        && request.resource.data.concern is string
        && request.resource.data.concern.size() > 0
        && request.resource.data.concern.size() <= 80
        && request.resource.data.question is string
        && request.resource.data.question.size() > 0
        && request.resource.data.question.size() <= 100
        && request.resource.data.createdByProfileId is string
        && request.resource.data.createdByProfileId in get(/databases/$(database)/documents/spaces/$(spaceId)).data.memberIds
        && request.resource.data.createdLabel is string
        && request.resource.data.createdLabel.size() <= 16
        && request.resource.data.replyTone is string
        && request.resource.data.replyTone.size() <= 16
        && request.resource.data.reply is string
        && request.resource.data.reply.size() <= 160
        && request.resource.data.repliedByProfileId is string
        && (request.resource.data.repliedByProfileId == ''
          || request.resource.data.repliedByProfileId in get(/databases/$(database)/documents/spaces/$(spaceId)).data.memberIds)
        && request.resource.data.repliedLabel is string
        && request.resource.data.repliedLabel.size() <= 16
        && request.resource.data.updatedByProfileId is string
        && request.resource.data.updatedByProfileId in get(/databases/$(database)/documents/spaces/$(spaceId)).data.memberIds;
    }

    function validNewStockHolding(spaceId, holdingId) {
      return validStockHoldingShape(spaceId, holdingId)
        && request.resource.data.createdByProfileId == request.auth.uid
        && request.resource.data.replyTone == ''
        && request.resource.data.reply == ''
        && request.resource.data.repliedByProfileId == ''
        && request.resource.data.repliedLabel == ''
        && request.resource.data.updatedByProfileId == request.auth.uid;
    }

    function validStockHoldingOwnerEdit(spaceId, holdingId) {
      return validStockHoldingShape(spaceId, holdingId)
        && resource.data.createdByProfileId == request.auth.uid
        && request.resource.data.createdByProfileId == resource.data.createdByProfileId
        && request.resource.data.createdLabel == resource.data.createdLabel
        && request.resource.data.replyTone == resource.data.replyTone
        && request.resource.data.reply == resource.data.reply
        && request.resource.data.repliedByProfileId == resource.data.repliedByProfileId
        && request.resource.data.repliedLabel == resource.data.repliedLabel
        && request.resource.data.diff(resource.data).affectedKeys().hasOnly([
          'name',
          'status',
          'weightLabel',
          'reason',
          'watchPoint',
          'concern',
          'question',
          'updatedByProfileId',
          'updatedAt'
        ])
        && request.resource.data.updatedByProfileId == request.auth.uid;
    }

    function validStockHoldingReply(spaceId, holdingId) {
      return validStockHoldingShape(spaceId, holdingId)
        && resource.data.createdByProfileId != request.auth.uid
        && resource.data.reply == ''
        && resource.data.repliedByProfileId == ''
        && request.resource.data.createdByProfileId == resource.data.createdByProfileId
        && request.resource.data.name == resource.data.name
        && request.resource.data.status == resource.data.status
        && request.resource.data.weightLabel == resource.data.weightLabel
        && request.resource.data.reason == resource.data.reason
        && request.resource.data.watchPoint == resource.data.watchPoint
        && request.resource.data.concern == resource.data.concern
        && request.resource.data.question == resource.data.question
        && request.resource.data.createdLabel == resource.data.createdLabel
        && request.resource.data.diff(resource.data).affectedKeys().hasOnly([
          'replyTone',
          'reply',
          'repliedByProfileId',
          'repliedLabel',
          'updatedByProfileId',
          'updatedAt'
        ])
        && request.resource.data.replyTone in ['같이 볼래요', '더 찾아볼게요', '조심해요']
        && request.resource.data.reply.size() > 0
        && request.resource.data.repliedByProfileId == request.auth.uid
        && request.resource.data.updatedByProfileId == request.auth.uid
        && request.resource.data.repliedLabel is string
        && request.resource.data.repliedLabel.size() <= 16;
    }

    function validScheduleEntry(entryId) {
      return request.resource.data.keys().hasOnly([
          'dateKey',
          'profileId',
          'availability',
          'timeSlots',
          'timeBlocks',
          'sharedMemo',
          'isMeetingDay',
          'meetingTimeLabel',
          'meetingNote',
          'meetingPlanItems',
          'updatedAt'
        ])
        && request.resource.data.dateKey is string
        && request.resource.data.dateKey.size() <= 16
        && request.resource.data.profileId == request.auth.uid
        && entryId == request.resource.data.dateKey + '_' + request.auth.uid
        && request.resource.data.availability in ['available', 'maybe', 'busy']
        && request.resource.data.timeSlots is list
        && request.resource.data.timeSlots.size() <= 3
        && request.resource.data.timeSlots.hasOnly(['morning', 'afternoon', 'evening'])
        && request.resource.data.timeBlocks is list
        && request.resource.data.timeBlocks.size() <= 6
        && request.resource.data.sharedMemo is string
        && request.resource.data.sharedMemo.size() <= 120
        && request.resource.data.isMeetingDay is bool
        && request.resource.data.meetingTimeLabel is string
        && request.resource.data.meetingTimeLabel.size() <= 40
        && request.resource.data.meetingNote is string
        && request.resource.data.meetingNote.size() <= 80
        && (!request.resource.data.keys().hasAny(['meetingPlanItems'])
          || request.resource.data.meetingPlanItems is list);
    }

    function validMeetingPlan(planId) {
      return request.resource.data.keys().hasOnly([
          'dateKey',
          'items',
          'updatedByProfileId',
          'updatedAt'
        ])
        && request.resource.data.dateKey is string
        && request.resource.data.dateKey.size() <= 16
        && planId == request.resource.data.dateKey
        && request.resource.data.items is list
        && request.resource.data.updatedByProfileId == request.auth.uid
        && request.resource.data.updatedAt == request.time;
    }

    function validSharedPlace(spaceId, placeId) {
      return request.resource.data.keys().hasOnly([
          'id',
          'name',
          'address',
          'category',
          'provider',
          'providerPlaceId',
          'latitude',
          'longitude',
          'note',
          'createdByProfileId',
          'interestedByProfileIds',
          'linkedDateKey',
          'meetingPlanLinks',
          'updatedByProfileId',
          'updatedAt'
        ])
        && request.resource.data.id == placeId
        && request.resource.data.name is string
        && request.resource.data.name.size() > 0
        && request.resource.data.name.size() <= 60
        && request.resource.data.address is string
        && request.resource.data.address.size() <= 90
        && request.resource.data.category in ['cafe', 'food', 'exhibition', 'walk', 'activity']
        && request.resource.data.provider == 'kakao'
        && request.resource.data.providerPlaceId is string
        && request.resource.data.providerPlaceId.size() <= 80
        && (
          request.resource.data.latitude == null
          || request.resource.data.latitude is number
        )
        && (
          request.resource.data.longitude == null
          || request.resource.data.longitude is number
        )
        && request.resource.data.note is string
        && request.resource.data.note.size() <= 120
        && request.resource.data.createdByProfileId in get(/databases/$(database)/documents/spaces/$(spaceId)).data.memberIds
        && request.resource.data.interestedByProfileIds is list
        && request.resource.data.interestedByProfileIds.size() <= 2
        && request.resource.data.linkedDateKey is string
        && request.resource.data.linkedDateKey.size() <= 16
        && validRequestSharedPlaceMeetingPlanLinks()
        && request.resource.data.updatedByProfileId == request.auth.uid
        && request.resource.data.updatedAt == request.time;
    }

    function requestSharedPlaceMeetingPlanLinks() {
      return request.resource.data.keys().hasAny(['meetingPlanLinks'])
        ? request.resource.data.meetingPlanLinks
        : [];
    }

    function existingSharedPlaceMeetingPlanLinks() {
      return resource.data.keys().hasAny(['meetingPlanLinks'])
        ? resource.data.meetingPlanLinks
        : [];
    }

    function existingSharedPlaceProvider() {
      return resource.data.keys().hasAny(['provider'])
        ? resource.data.provider
        : '';
    }

    function existingSharedPlaceProviderPlaceId() {
      return resource.data.keys().hasAny(['providerPlaceId'])
        ? resource.data.providerPlaceId
        : '';
    }

    function existingSharedPlaceLatitude() {
      return resource.data.keys().hasAny(['latitude'])
        ? resource.data.latitude
        : null;
    }

    function existingSharedPlaceLongitude() {
      return resource.data.keys().hasAny(['longitude'])
        ? resource.data.longitude
        : null;
    }

    function preservesOrNormalizesSharedPlaceMapFields() {
      return (
          request.resource.data.provider == existingSharedPlaceProvider()
          || !(existingSharedPlaceProvider() in ['kakao'])
        )
        && (
          request.resource.data.providerPlaceId == existingSharedPlaceProviderPlaceId()
          || existingSharedPlaceProviderPlaceId() == ''
        )
        && (
          request.resource.data.latitude == existingSharedPlaceLatitude()
          || existingSharedPlaceLatitude() == null
        )
        && (
          request.resource.data.longitude == existingSharedPlaceLongitude()
          || existingSharedPlaceLongitude() == null
        );
    }

    function validRequestSharedPlaceMeetingPlanLinks() {
      return !request.resource.data.keys().hasAny(['meetingPlanLinks'])
        || (
          request.resource.data.meetingPlanLinks is list
          && request.resource.data.meetingPlanLinks.size() <= 20
        );
    }

    function validNewSharedPlace(spaceId, placeId) {
      return validSharedPlace(spaceId, placeId)
        && request.resource.data.createdByProfileId == request.auth.uid
        && request.resource.data.providerPlaceId.size() > 0
        && request.resource.data.latitude is number
        && request.resource.data.longitude is number
        && request.resource.data.interestedByProfileIds.size() == 1
        && request.auth.uid in request.resource.data.interestedByProfileIds
        && (
          (
            request.resource.data.linkedDateKey == ''
            && requestSharedPlaceMeetingPlanLinks().size() == 0
          )
          || (
            request.resource.data.linkedDateKey != ''
            && requestSharedPlaceMeetingPlanLinks().size() > 0
          )
        );
    }

    function validSharedPlaceOwnerEdit(spaceId, placeId) {
      return validSharedPlace(spaceId, placeId)
        && resource.data.createdByProfileId == request.auth.uid
        && request.resource.data.id == resource.data.id
        && request.resource.data.createdByProfileId == resource.data.createdByProfileId
        && request.resource.data.interestedByProfileIds == resource.data.interestedByProfileIds
        && request.resource.data.linkedDateKey == resource.data.linkedDateKey
        && requestSharedPlaceMeetingPlanLinks() == existingSharedPlaceMeetingPlanLinks()
        && request.resource.data.diff(resource.data).affectedKeys().hasOnly([
          'name',
          'address',
          'category',
          'provider',
          'providerPlaceId',
          'latitude',
          'longitude',
          'note',
          'meetingPlanLinks',
          'updatedByProfileId',
          'updatedAt'
        ]);
    }

    function validSharedPlaceInterestUpdate(spaceId, placeId) {
      return validSharedPlace(spaceId, placeId)
        && requestSharedPlaceMeetingPlanLinks() == existingSharedPlaceMeetingPlanLinks()
        && preservesOrNormalizesSharedPlaceMapFields()
        && request.resource.data.diff(resource.data).affectedKeys().hasOnly([
          'interestedByProfileIds',
          'provider',
          'providerPlaceId',
          'latitude',
          'longitude',
          'meetingPlanLinks',
          'updatedByProfileId',
          'updatedAt'
        ])
        && (
          request.auth.uid in resource.data.interestedByProfileIds
          || request.auth.uid in request.resource.data.interestedByProfileIds
        );
    }

    function validSharedPlaceMeetingLinkUpdate(spaceId, placeId) {
      return validSharedPlace(spaceId, placeId)
        && request.resource.data.id == resource.data.id
        && request.resource.data.name == resource.data.name
        && request.resource.data.address == resource.data.address
        && request.resource.data.category == resource.data.category
        && preservesOrNormalizesSharedPlaceMapFields()
        && request.resource.data.note == resource.data.note
        && request.resource.data.createdByProfileId == resource.data.createdByProfileId
        && request.resource.data.diff(resource.data).affectedKeys().hasOnly([
          'interestedByProfileIds',
          'linkedDateKey',
          'meetingPlanLinks',
          'provider',
          'providerPlaceId',
          'latitude',
          'longitude',
          'updatedByProfileId',
          'updatedAt'
        ])
        && request.auth.uid in request.resource.data.interestedByProfileIds;
    }

    function validSharedPlaceMeetingPatchUpdate(spaceId, placeId) {
      return request.resource.data.diff(resource.data).affectedKeys().hasOnly([
          'interestedByProfileIds',
          'linkedDateKey',
          'meetingPlanLinks',
          'updatedByProfileId',
          'updatedAt'
        ])
        && request.resource.data.interestedByProfileIds is list
        && request.resource.data.interestedByProfileIds.size() <= 2
        && request.resource.data.interestedByProfileIds.hasOnly(
          get(/databases/$(database)/documents/spaces/$(spaceId)).data.memberIds
        )
        && (
          request.auth.uid in request.resource.data.interestedByProfileIds
          || (
            resource.data.keys().hasAny(['interestedByProfileIds'])
            && request.auth.uid in resource.data.interestedByProfileIds
          )
        )
        && request.resource.data.linkedDateKey is string
        && request.resource.data.linkedDateKey.size() <= 16
        && validRequestSharedPlaceMeetingPlanLinks()
        && request.resource.data.updatedByProfileId == request.auth.uid
        && request.resource.data.updatedAt is timestamp;
    }

    match /users/{userId} {
      allow read: if signedIn()
        && (
          request.auth.uid == userId
          || (
            hasUserProfile()
            && currentUserProfile().data.partnerUid == userId
          )
        );
      allow write: if false;
    }

    match /spaces/{spaceId} {
      allow read: if isSpaceMember(spaceId);
      allow create, delete: if false;
      allow update: if isSpaceMember(spaceId)
        && request.resource.data.diff(resource.data).affectedKeys().hasOnly([
          'personalization',
          'personalizationUpdatedAt'
        ])
        && validPersonalization(request.resource.data.personalization);

      match /answers/{answerId} {
        allow read: if isSpaceMember(spaceId);
        allow create, update: if isSpaceMember(spaceId)
          && request.resource.data.profileId == request.auth.uid
          && request.resource.data.questionId is string
          && request.resource.data.body is string
          && request.resource.data.createdLabel is string
          && request.resource.data.skipped is bool;
        allow delete: if false;
      }

      match /answerComments/{commentId} {
        allow read: if isSpaceMember(spaceId);
        allow create, update: if isSpaceMember(spaceId)
          && validAnswerComment(spaceId, commentId);
        allow delete: if false;
      }

      match /progress/{progressId} {
        allow read: if isSpaceMember(spaceId);
        allow create, update: if isSpaceMember(spaceId)
          && validDailyProgress(progressId);
        allow delete: if false;
      }

      match /diagnosticEvents/{eventId} {
        allow read: if isSpaceMember(spaceId)
          && isOwnerUser();
        allow create: if isSpaceMember(spaceId)
          && validDiagnosticEvent(spaceId, eventId);
        allow update, delete: if false;
      }

      match /balanceSelections/{selectionId} {
        allow read: if isSpaceMember(spaceId);
        allow create, update: if isSpaceMember(spaceId)
          && request.resource.data.profileId == request.auth.uid
          && request.resource.data.questionId is string
          && request.resource.data.optionId is string
          && (
            request.resource.data.reason == null
            || (
              request.resource.data.reason is string
              && request.resource.data.reason.size() <= 80
            )
          )
          && (
            request.resource.data.resultRevealedAt == null
            || request.resource.data.resultRevealedAt is timestamp
          );
        allow delete: if isSpaceMember(spaceId)
          && resource.data.profileId == request.auth.uid;
      }

      match /profileCards/{profileId}/slots/{slotId} {
        allow read: if isSpaceMember(spaceId);
        allow create, update: if isSpaceMember(spaceId)
          && profileId == request.auth.uid
          && request.resource.data.keys().hasOnly([
            'id',
            'label',
            'icon',
            'category',
            'inputHint',
            'value',
            'locked',
            'unlockHint',
            'skipped',
            'hidden',
            'custom',
            'updatedByProfileId',
            'updatedAt'
          ])
          && request.resource.data.id == slotId
          && request.resource.data.label is string
          && request.resource.data.label.size() > 0
          && request.resource.data.label.size() <= 40
          && request.resource.data.icon is string
          && request.resource.data.icon.size() <= 24
          && request.resource.data.category in ['취향', '하루', '대화', '함께', '직접']
          && request.resource.data.inputHint is string
          && request.resource.data.inputHint.size() <= 80
          && (
            request.resource.data.value == null
            || (
              request.resource.data.value is string
              && request.resource.data.value.size() <= 120
            )
          )
          && request.resource.data.locked is bool
          && (
            request.resource.data.unlockHint == null
            || (
              request.resource.data.unlockHint is string
              && request.resource.data.unlockHint.size() <= 80
            )
          )
          && request.resource.data.skipped is bool
          && request.resource.data.hidden is bool
          && request.resource.data.custom is bool
          && request.resource.data.updatedByProfileId == request.auth.uid
          && request.resource.data.updatedAt == request.time;
        allow delete: if isSpaceMember(spaceId)
          && profileId == request.auth.uid
          && resource.data.custom == true;
      }

      match /wishes/{wishId} {
        allow read: if isSpaceMember(spaceId);
        allow create, update: if isSpaceMember(spaceId)
          && request.resource.data.id == wishId
          && request.resource.data.title is string
          && request.resource.data.createdByProfileId is string
          && request.resource.data.kind in ['place', 'activity']
          && request.resource.data.likedByProfileIds is list
          && request.auth.uid in request.resource.data.likedByProfileIds
          && request.resource.data.done is bool;
        allow delete: if isSpaceMember(spaceId)
          && resource.data.createdByProfileId == request.auth.uid;
      }

      match /musicNotes/{noteId} {
        allow read: if isSpaceMember(spaceId);
        allow create: if isSpaceMember(spaceId)
          && validMusicNoteOwnerWrite(spaceId, noteId);
        allow update: if isSpaceMember(spaceId)
          && (
            validMusicNoteOwnerWrite(spaceId, noteId)
            || validMusicNoteListenUpdate(spaceId, noteId)
          );
        allow delete: if isSpaceMember(spaceId)
          && resource.data.createdByProfileId == request.auth.uid;
      }

      match /scheduleEntries/{entryId} {
        allow read: if isSpaceMember(spaceId);
        allow create, update: if isSpaceMember(spaceId)
          && validScheduleEntry(entryId);
        allow delete: if false;
      }

      match /meetingPlans/{planId} {
        allow read: if isSpaceMember(spaceId);
        allow create, update: if isSpaceMember(spaceId)
          && validMeetingPlan(planId);
        allow delete: if false;
      }

      match /sharedPlaces/{placeId} {
        allow read: if isSpaceMember(spaceId);
        allow create: if isSpaceMember(spaceId)
          && validNewSharedPlace(spaceId, placeId);
        allow update: if isSpaceMember(spaceId)
          && (
            validSharedPlaceOwnerEdit(spaceId, placeId)
            || validSharedPlaceInterestUpdate(spaceId, placeId)
            || validSharedPlaceMeetingLinkUpdate(spaceId, placeId)
            || validSharedPlaceMeetingPatchUpdate(spaceId, placeId)
          );
        allow delete: if isSpaceMember(spaceId)
          && resource.data.createdByProfileId == request.auth.uid;
      }

      match /improvementPosts/{postId} {
        allow read: if isSpaceMember(spaceId);
        allow create: if isSpaceMember(spaceId)
          && validNewImprovementPost(spaceId, postId);
        allow update: if isSpaceMember(spaceId)
          && (
            validImprovementPostOwnerEdit(spaceId, postId)
            || validImprovementPostOwnerStatusUpdate(spaceId, postId)
          );
        allow delete: if isSpaceMember(spaceId)
          && resource.data.createdByProfileId == request.auth.uid;
      }

      match /curiosityCards/{cardId} {
        allow read: if isSpaceMember(spaceId);
        allow create: if isSpaceMember(spaceId)
          && validNewCuriosityCard(spaceId, cardId);
        allow update: if isSpaceMember(spaceId)
          && validCuriosityReply(spaceId, cardId);
        allow delete: if false;
      }

      match /stockStories/{storyId} {
        allow read: if isSpaceMember(spaceId);
        allow create: if isSpaceMember(spaceId)
          && validNewStockStory(spaceId, storyId);
        allow update: if isSpaceMember(spaceId)
          && validStockStoryReply(spaceId, storyId);
        allow delete: if isSpaceMember(spaceId)
          && resource.data.createdByProfileId == request.auth.uid;
      }

      match /stockHoldings/{holdingId} {
        allow read: if isSpaceMember(spaceId);
        allow create: if isSpaceMember(spaceId)
          && validNewStockHolding(spaceId, holdingId);
        allow update: if isSpaceMember(spaceId)
          && (
            validStockHoldingOwnerEdit(spaceId, holdingId)
            || validStockHoldingReply(spaceId, holdingId)
          );
        allow delete: if isSpaceMember(spaceId)
          && resource.data.createdByProfileId == request.auth.uid;
      }
    }
  }
}
```

MVP 규칙은 두 사람 전용 공간을 전제로 한다. 나중에 사용자가 늘어나면 관리자 권한, 초대 코드, 필드별 write 제한을 더 촘촘하게 분리한다.

## 7. GitHub Secrets 추가

GitHub repo -> Settings -> Secrets and variables -> Actions -> New repository secret에서 아래 이름으로 추가한다.

```text
FIREBASE_API_KEY
FIREBASE_APP_ID
FIREBASE_MESSAGING_SENDER_ID
FIREBASE_PROJECT_ID
FIREBASE_AUTH_DOMAIN
FIREBASE_STORAGE_BUCKET
KAKAO_MAP_JS_KEY
FIREBASE_SERVICE_ACCOUNT
```

`FIREBASE_SERVICE_ACCOUNT`는 GitHub Actions가 Firestore Security Rules를 배포할 때만 사용한다.
Google Cloud Console에서 배포용 service account를 만들고, 프로젝트에
아래 권한을 모두 준 뒤 JSON key 전체를 GitHub Secret 값으로 저장한다.

- `Firebase Rules Admin`(`roles/firebaserules.admin`): Firestore Security Rules ruleset/release를 배포한다.
- `Service Usage Viewer`(`roles/serviceusage.serviceUsageViewer`): Firebase CLI가 `firestore.googleapis.com` 활성화 상태를 조회한다.

권한은 `IAM 및 관리자` -> `IAM` 화면에서 프로젝트 principal로 부여한다.
`서비스 계정` 상세 화면의 `권한` 탭은 "누가 이 서비스 계정을 사용할 수 있는가"에
가까워서, 거기에만 역할을 추가하면 GitHub Actions 배포 권한으로 동작하지 않을 수 있다.
GitHub Secret에 저장한 JSON의 `client_email` 값과 IAM 화면의 principal 이메일이
같은지 확인한다.

`firebaserules.googleapis.com/v1/projects/...:test`에서 403이 나면
`roles/firebaserules.admin`이 정확한 프로젝트의 정확한 service account principal에
붙어 있는지 다시 확인한다. 역할을 추가한 직후에는 IAM 전파에 몇 분 걸릴 수 있다.

Service account key 파일은 저장소에 커밋하지 않는다.

Secrets를 추가한 뒤 `main` 브랜치에 push하면 GitHub Actions가 Flutter Web을 다시
빌드하고, `firebase.json`이 가리키는 `firestore.rules`를 `firebase deploy --only
firestore:rules`로 배포한다. PR에서는 rules sync, analyze, test, build만 검증하고
Firebase Rules나 GitHub Pages를 실제 배포하지 않는다.

## 8. 배포 확인

1. GitHub repo -> Actions에서 `Deploy Flutter Web to GitHub Pages` workflow가 성공했는지 확인한다.
2. GitHub Pages URL을 연다.
3. 로그인 화면이 보이면 `youngwoo` 또는 `minyoung`과 Console에서 만든 비밀번호로 들어간다.
4. 새로고침 후 로그인 화면을 건너뛰고 홈으로 들어가면 자동 로그인이 정상이다.
5. `마이` -> `로그아웃`을 누르면 로그인 화면으로 돌아와야 한다.

## 9. 참고 문서

- Firebase Auth Flutter Email/Password: <https://firebase.google.com/docs/auth/flutter/password-auth>
- Firebase Auth Flutter 시작하기: <https://firebase.google.com/docs/auth/flutter/start>
- Firestore Security Rules 시작하기: <https://firebase.google.com/docs/firestore/security/get-started>
- Firebase Security Rules 배포 관리: <https://firebase.google.com/docs/rules/manage-deploy>
- Firebase Security Rules IAM 역할: <https://cloud.google.com/iam/docs/roles-permissions/firebaserules>
- FlutterFire Auth usage: <https://firebase.flutter.dev/docs/auth/usage>
