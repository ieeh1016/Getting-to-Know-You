# Stocks Spec

## 목적

Stocks는 stock story와 holding을 financial advice나 trading signal이 아니라 conversation prompt로 공유하게 한다.

## 필수 동작

- stock story는 name, reason, upside, risk, question 하나를 받는다.
- holding은 name, status, weight label, reason, watch point, concern, question 하나를 받는다.
- user는 자신의 holding을 edit/delete할 수 있다.
- partner story/holding에는 reply를 남길 수 있다.
- item count가 늘어나도 tab/filter/detail sheet로 list를 계속 사용할 수 있어야 한다.

## Copy 규칙

- buy/sell advice, returns, ranking, pressure를 피한다.
- `같이 보면 좋을 포인트`처럼 함께 살펴보는 language를 사용한다.

## 데이터 규칙

- story add/reply는 story document 하나를 쓴다.
- holding add/edit/delete는 관련 holding document만 쓴다.
- reply metadata는 필요한 경우 reply body, tone, author, replied label을 저장한다.

## 수용 기준

- 두 user가 같은 holding을 공유하면 `함께 보유 중`을 보여줄 수 있다.
- full detail sheet는 긴 reason/risk/watch content를 보여준다.
- partner-owned item에는 owner-only edit/delete action이 보이지 않는다.
