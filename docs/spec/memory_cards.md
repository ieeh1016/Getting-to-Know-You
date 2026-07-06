# Memory Cards Spec

## 목적

기억 카드는 두 사람이 서로에 대해 잊고 싶지 않은 작은 내용을 직접 남기는 shared record다. 대화 자동 분석이나 회고 추출이 아니라, 사용자가 명시적으로 작성한 카드만 저장한다.

## 진입

- 하단 navigation tab을 추가하지 않는다.
- Home에는 `서로의 기억` 주요 카드를 보여준다.
  - 최근 공유 카드 1개 또는 empty state를 보여준다.
  - 영우의 공간, 민영이의 공간 카드 수를 요약한다.
  - `기억 보기`, `카드 만들기` action을 제공한다.
- Home menu의 `기능 모아보기`에도 `서로의 기억` 항목을 제공한다.
- 기억 카드 화면은 bottom-tab root가 아닌 sub-screen이며 back action을 가진다.

## 카드 공간

- `영우의 공간`은 영우가 민영이에 대해 남긴 카드 목록이다.
- `민영이의 공간`은 민영이가 영우에 대해 남긴 카드 목록이다.
- 화면 안에서는 두 공간을 tab/segmented control로 전환한다.
- 각 카드는 다음 공개 범위를 가진다.
  - `shared`: 두 member 모두 볼 수 있고 상대가 반응할 수 있다.
  - `private`: 작성자만 볼 수 있다.
- partner가 작성한 `private` 카드는 목록과 카운트에 노출하지 않는다.

## 카드 작성

- 사용자는 카드 유형, 제목, 내용을 직접 입력한다.
- 지원 유형:
  - 좋아하는 것
  - 싫어하는 것
  - 요즘 이야기
  - 함께 할 것
  - 조심할 것
- 공개 범위 기본값은 `shared`다.
- draft 입력, 유형 선택, 공개 범위 선택, 공간 tab 전환은 Firestore write를 만들지 않는다.
- `저장하고 공유하기` 또는 `나만 저장하기` 제출 시 `memoryCards/{cardId}` 한 문서만 저장한다.
- 작성자는 자신의 카드만 수정할 수 있다.

## 반응과 수정 요청

- 상대는 `shared` 카드에만 반응할 수 있다.
- 지원 반응:
  - `맞아`
  - `좋아`
  - `조금 수정`
- `맞아`, `좋아`는 상대의 `memoryCardResponses/{cardId_responderUid}` 문서 하나를 저장한다.
- `조금 수정`은 correction text를 함께 저장하며 원문 카드를 즉시 바꾸지 않는다.
- 작성자가 수정 요청을 반영할 때만 `memoryCards/{cardId}`를 수정한다.
- partner는 작성자의 카드 원문을 직접 덮어쓸 수 없다.

## Home과 unread

- partner가 shared memory card를 새로 만들거나 수정하면 Home unread activity에 포함될 수 있다.
- partner가 내 shared card에 반응하거나 수정 요청을 남기면 Home unread activity에 포함될 수 있다.
- 내가 만든 카드와 내가 남긴 반응은 내 unread activity가 아니다.
- memory card seen state는 device-local store를 사용하며 Firestore write를 만들지 않는다.

## Copy Guardrail

- 카드 copy는 상대를 평가하거나 채점하지 않는다.
- `기억률`, `점수`, `랭킹`, `서운함 방지율` 같은 pressure copy를 사용하지 않는다.
- 민감한 내용은 `나만 보기`로 옮길 수 있어야 한다.
- 공유 카드는 “내가 너를 이렇게 기억하고 있어”에 가까운 따뜻한 표현을 사용한다.

## Empty/Failure State

- 카드가 없으면 Home card와 memory screen은 `아직 남긴 기억이 없어요` 계열의 낮은 압박 copy를 보여준다.
- 저장 실패 시 입력값은 유지하고 `저장 다시 시도` action을 제공한다.
- 카드 열람, 필터, tab 이동, bottom sheet open은 저장을 만들지 않는다.
