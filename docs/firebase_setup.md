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
  "name": "알아가기",
  "memberIds": ["{youngwooUid}", "{minyoungUid}"]
}
```

Firestore Console에서 배열은 `array` 타입으로 넣는다.

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
      allow write: if false;

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

      match /profileCards/{profileId}/slots/{slotId} {
        allow read: if isSpaceMember(spaceId);
        allow create, update: if isSpaceMember(spaceId)
          && profileId == request.auth.uid
          && request.resource.data.id == slotId
          && request.resource.data.label is string
          && request.resource.data.icon is string
          && request.resource.data.locked is bool;
        allow delete: if false;
      }

      match /wishes/{wishId} {
        allow read: if isSpaceMember(spaceId);
        allow create, update: if isSpaceMember(spaceId)
          && request.resource.data.id == wishId
          && request.resource.data.title is string
          && request.resource.data.kind in ['place', 'activity']
          && request.resource.data.likedByProfileIds is list
          && request.auth.uid in request.resource.data.likedByProfileIds
          && request.resource.data.done is bool;
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
- FlutterFire Auth usage: <https://firebase.flutter.dev/docs/auth/usage>
- Firestore Security Rules 시작하기: <https://firebase.google.com/docs/firestore/security/get-started>
