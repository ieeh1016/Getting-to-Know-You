# Meetings Spec

## 목적

Meetings는 두 user가 가능한 날짜를 조율하고, confirmed meeting day를 표시하고, fixed day에 무엇을 할지 계획하도록 돕는다.

## 필수 동작

- calendar는 my entries, partner entries, mutual availability, selected date, confirmed meeting day를 구분해서 보여준다.
- user는 start/end time과 title이 있는 detailed time block을 추가할 수 있다.
- user는 서로에게 괜찮은 날짜를 meeting day로 표시할 수 있다.
- user는 fixed meeting day를 취소해 `만남` tab과 calendar marker에서 제거할 수 있다.
- meeting day detail은 rigid time preset을 강제하지 않고 free-form copy를 사용한다.
- `만남` tab은 fixed meeting day만 보여주고, 그날의 plan을 정리하게 한다.
- plan copy는 `영우·민영의 계획`을 사용한다.
- 사람 행에 붙는 `상대에게 남길 한마디`와 만나는 날 메모는 두 줄까지 보여주고, 넘치면 `전체 보기`로 원문을 연다. 한 줄로 잘라 `...`만 남기면 남긴 말을 읽을 방법이 없다.

## 데이터 규칙

- schedule entry는 `dateKey`와 profile별로 저장한다.
- meeting day detail은 selected schedule entry shape에 저장된다.
- meeting cancellation은 shared `MeetingPlan.isCancelled` 상태로 저장하고 기존 plan item은 보존한다.
- date edit은 관련 schedule document 하나만 쓴다.
- 다가오는/지난 meeting day 구분은 Asia/Seoul 기준 오늘 `YYYY-MM-DD` dateKey로 계산한다.

## 수용 기준

- 두 사람 모두 entry가 있을 때 calendar indicator들이 함께 보인다.
- selected date styling은 fixed meeting day styling과 구분되어야 한다.
- fixed meeting plan에서 plan item을 add/remove할 수 있다.
- fixed meeting day를 취소하면 upcoming/past meeting list에서 빠진다.
- place ownership을 깨지 않고 place-board link를 meeting plan으로 가져올 수 있다.
- 긴 한마디는 사람 행에서 잘리더라도 `전체 보기`로 원문 전체를 읽을 수 있다. 짧은 한마디에는 cue가 붙지 않는다.
- `전체 보기` sheet 열람은 Firestore write를 만들지 않는다.

## 여행과 겹치는 날

- `계획 중`인 여행의 기간에 든 날은 달력에 짐가방 표시를 붙이고, 그 날을 고르면 어느 여행인지 이름과 몇 일차를 보여준 뒤 그 여행으로 들어가게 한다. 표시만 있고 들어갈 길이 없으면 확인하러 나갔다 와야 한다.
- 그 날의 상태 문구는 `조율 중인 날짜`가 아니라 `여행 중인 날`로 읽는다. 이미 잡혀 있는 날에 조율을 재촉하지 않는다. 입력 자체는 막지 않는다.
- `이 날 장소 후보` 빈 상태는 보드에 담아둔 곳이 있으면 바로 아래 붙이기 목록을 가리키고, 보드까지 비었을 때만 장소 탭을 안내한다.
