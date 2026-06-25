# Improvement Board Spec

## 목적

Improvement board는 user가 앱 자체에 대한 idea, request, feedback을 남기게 한다.

## 필수 동작

- user는 title, body, category가 있는 post를 추가할 수 있다.
- post owner는 자신의 post를 edit/delete할 수 있다.
- owner account만 implementation reply를 남기고 post를 complete 처리할 수 있다.
- completed post는 default open list에서 빠지고 completed filter로 이동한다.
- board는 home menu에서 접근할 수 있다.
- UI는 public forum이 아니라 lightweight internal board처럼 느껴져야 한다.

## 데이터 규칙

- 각 post는 `id`, `title`, `body`, `category`, `createdByProfileId`, `createdLabel`, owner reply fields, completion fields, `updatedAt`을 저장한다.
- delete는 owner-only다.
- Firestore rules는 `users/{uid}.role == "owner"`인 경우에만 implementation reply와 completion change를 허용한다.

## 수용 기준

- empty state는 나중에 idea를 남길 수 있음을 설명한다.
- owner-only action은 partner post에 나타나지 않는다.
- non-owner user는 owner reply를 읽을 수 있지만 쓸 수 없고 post를 complete 처리할 수 없다.
- completed post는 전용 completed filter에서 볼 수 있다.
- long post body는 읽기 좋게 열리거나 표시된다.
