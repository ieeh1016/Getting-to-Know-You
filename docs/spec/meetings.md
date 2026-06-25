# Meetings Spec

## 목적

Meetings는 두 user가 가능한 날짜를 조율하고, confirmed meeting day를 표시하고, fixed day에 무엇을 할지 계획하도록 돕는다.

## 필수 동작

- calendar는 my entries, partner entries, mutual availability, selected date, confirmed meeting day를 구분해서 보여준다.
- user는 start/end time과 title이 있는 detailed time block을 추가할 수 있다.
- user는 서로에게 괜찮은 날짜를 meeting day로 표시할 수 있다.
- meeting day detail은 rigid time preset을 강제하지 않고 free-form copy를 사용한다.
- `만남` tab은 fixed meeting day만 보여주고, 그날의 plan을 정리하게 한다.
- plan copy는 `영우·민영의 계획`을 사용한다.

## 데이터 규칙

- schedule entry는 `dateKey`와 profile별로 저장한다.
- meeting day detail은 selected schedule entry shape에 저장된다.
- date edit은 관련 schedule document 하나만 쓴다.

## 수용 기준

- 두 사람 모두 entry가 있을 때 calendar indicator들이 함께 보인다.
- selected date styling은 fixed meeting day styling과 구분되어야 한다.
- fixed meeting plan에서 plan item을 add/remove할 수 있다.
- place ownership을 깨지 않고 place-board link를 meeting plan으로 가져올 수 있다.
