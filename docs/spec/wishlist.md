# Wishlist Spec

## 목적

Wishlist는 `언젠가, 같이`로 표시되며 두 user가 함께 하고 싶을 수 있는 것들을 모아둔다.

## 필수 동작

- user는 place 또는 activity wish를 추가할 수 있다.
- user는 wish에 interest를 표시할 수 있다.
- 필요한 경우 user는 wish를 done으로 표시할 수 있다.
- filter는 all, mutual, places, activities를 구분하게 돕는다.
- copy는 `관심`, `같이 해보고 싶은`처럼 low-pressure를 유지하고 commitment-heavy language를 피한다.

## 데이터 규칙

- wish document는 creator, kind, title, optional note/icon, interest profile IDs, done state, created/updated timestamp를 저장한다.
- add/interest/done action은 최대 하나의 wish document만 써야 한다.

## 수용 기준

- mutual interest는 romantic pressure 없이 보여야 한다.
- 긴 wish list도 filter로 scan 가능해야 한다.
- owner action과 partner action은 명확하고 충돌하지 않아야 한다.
