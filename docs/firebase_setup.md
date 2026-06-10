# Firebase Setup Guide

> Spec source: [spec.md](spec.md) section `MVP v0.3 Firebase Private`.
> 작성 기준일: 2026-06-08.

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

`spaces/main/curiosityCards` 하위 컬렉션은 앱에서 처음 `질문 보내기`를 누를 때 자동으로 만들어진다. Console에서 빈 컬렉션을 미리 만들 필요는 없지만, 아래 Security Rules에는 `curiosityCards` 규칙이 포함되어 있어야 한다.

## 6. Firestore Security Rules

Firestore Database -> Rules에 아래 규칙을 넣고 Publish 한다.

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

    function validMusicNote(noteId) {
      return request.resource.data.keys().hasOnly([
          'id',
          'title',
          'artist',
          'link',
          'note',
          'mood',
          'createdByProfileId',
          'createdLabel',
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
        && request.resource.data.createdByProfileId == request.auth.uid
        && request.resource.data.createdLabel is string
        && request.resource.data.createdLabel.size() <= 16;
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

      match /balanceSelections/{selectionId} {
        allow read: if isSpaceMember(spaceId);
        allow create, update: if isSpaceMember(spaceId)
          && request.resource.data.profileId == request.auth.uid
          && request.resource.data.questionId is string
          && request.resource.data.optionId is string;
        allow delete: if false;
      }

      match /profileCards/{profileId}/slots/{slotId} {
        allow read: if isSpaceMember(spaceId);
        allow create, update: if isSpaceMember(spaceId)
          && profileId == request.auth.uid
          && request.resource.data.id == slotId
          && request.resource.data.label is string
          && request.resource.data.icon is string
          && (!request.resource.data.keys().hasAny(['value'])
            || request.resource.data.value is string)
          && (!request.resource.data.keys().hasAny(['locked'])
            || request.resource.data.locked is bool);
        allow delete: if false;
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
        allow delete: if false;
      }

      match /musicNotes/{noteId} {
        allow read: if isSpaceMember(spaceId);
        allow create, update: if isSpaceMember(spaceId)
          && validMusicNote(noteId);
        allow delete: if false;
      }

      match /curiosityCards/{cardId} {
        allow read: if isSpaceMember(spaceId);
        allow create: if isSpaceMember(spaceId)
          && validNewCuriosityCard(spaceId, cardId);
        allow update: if isSpaceMember(spaceId)
          && validCuriosityReply(spaceId, cardId);
        allow delete: if false;
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
```

Secrets를 추가한 뒤 `main` 브랜치에 push하면 GitHub Actions가 Flutter Web을 다시 빌드한다.

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
- FlutterFire Auth usage: <https://firebase.flutter.dev/docs/auth/usage>
