# Taste Match Spec

## 목적

Taste match는 취향을 발견하기 위한 가벼운 choice game이다. 빠르게 선택할 수 있고 기본적으로 private하며 나중에도 쓸모 있어야 한다.

## 현재 UX 구조

screen은 세 tab으로 나뉜다.

- `오늘`: today card를 선택하고, optional reason을 남기며, current card result만 reveal한다.
- `결과함`: waiting, locked, revealed result를 확인한다.
- `내 노트`: 내 choices와 내 reasons만 확인한다.

## 필수 동작

- card를 선택하면 choice를 즉시 저장한다.
- 이미 선택된 card를 다시 누르면 selection, reason, personal reveal state를 지운다.
- 다른 card를 누르면 selection이 바뀐다.
- reason text는 optional이며 짧은 delay 후 auto-save된다.
- result는 자동으로 보이지 않는다.
- partner choice, same/different state, comparison copy는 `결과 열어보기` 이후에만 보인다.
- `내 노트`는 partner choice 또는 same/different state를 절대 보여주지 않는다.
- `결과함`은 result ready 상태를 보여줄 수 있지만 reveal 전에는 comparison detail을 숨긴다.

## 데이터 규칙

- `balanceSelections`는 `questionId`, `profileId`, `optionId`, optional `reason`, optional `resultRevealedAt`, `updatedAt`을 저장한다.
- 선택된 card를 clear하면 user 자신의 `balanceSelections/{questionId_uid}` document를 삭제한다.
- result reveal state는 personal이다. 한 user가 result를 reveal해도 partner UI를 강제로 열지 않는다.
- reason typing은 keystroke마다 write하면 안 되며 debounce된다.

## 수용 기준

- reveal 전에는 partner option label이 보이지 않는다.
- reveal 전에는 `같음`, `다름`, score, percent, compatibility copy가 보이지 않는다.
- Firestore data에 `resultRevealedAt`이 있으면 reload 후에도 revealed result가 유지된다.
- default `오늘` tab은 choice flow에 집중할 수 있을 만큼 짧아야 한다.
