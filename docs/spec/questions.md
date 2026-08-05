# Questions And Records Spec

## 목적

Daily question은 앱의 핵심 slow-conversation loop다. records와 archive는 앱을 chat처럼 만들지 않으면서 answer를 보존한다.

## 필수 동작

- active daily question 하나는 shared progress data로 선택된다.
- user는 자신의 answer를 write, save, edit, retry할 수 있다.
- partner answer는 user의 answer가 저장될 때까지 locked 상태를 유지한다.
- answer comment는 열린 partner answer에 남기는 짧은 explicit-save note다.
- answer comment UI는 answer와 같은 위계의 별도 card가 아니라 answer 아래에 붙은 작은 comment shelf로 보여준다.
- comment composer는 기본적으로 한 줄 entry로 접혀 있고, user가 댓글 남기기를 명시적으로 시작하면 editor가 열린다.
- archive는 all, both answered, similar-answer filter를 지원한다.
- record screen은 score나 percentage 없이 shared-answer summary와 matched keyword를 보여줄 수 있다.

## 질문 카탈로그

- 질문 catalog는 버전으로 쌓는다. `questionCatalogV1`은 이미 지나간 질문이라 보존용이고, `questionCatalogV2`는 앞으로 나올 질문이다.
- **이미 나온 질문의 id와 문구는 절대 바꾸지 않는다.** answer는 `{questionId}_{uid}` key로 저장되므로, 지나간 자리의 문구를 바꾸면 예전 답변이 다른 질문에 붙어 보인다.
- 활성 순서는 `buildActiveQuestionCatalog(startedDateKey, todayDateKey)`가 만든다. 오늘까지 나온 자리는 v1 원문 그대로 두고, **내일부터** v2가 이어진다.
- cutover를 상수로 고정하지 않는다. space의 실제 `startedDateKey`와 오늘 날짜에서 매번 계산해야 시작일이 달라도 어긋나지 않는다.
- `day`와 `number`는 활성 순서 안에서 1부터 연속이어야 한다. 오늘의 질문 위치를 날짜 차이로 계산하기 때문이다.
- 답이 있는 질문은 활성 순서에서 빠졌더라도 기록 화면에서 사라지면 안 된다. 조회는 `allKnownQuestions`(v1 + v2)로 fallback한다.
- 새 질문 세트를 또 추가할 때는 기존 catalog를 그대로 두고 새 id namespace를 쓴다. v1은 `q001`–`q058`, v2는 `qb001`–`qb058`이다.
- v2 질문은 만난 지 얼마 되지 않아 서로를 알아가는 두 사람 기준으로 쓴다. 가벼운 일상 -> 서로에 대한 관찰과 연락/만남 방식 -> 가치관 -> 조금 더 깊은 마음 순으로 이어진다.
- 장기 약속을 압박하는 표현(`결혼`, `평생`, `영원`, `기념일`, `헤어지`)은 전체 catalog에서 쓰지 않는다.

## 데이터 규칙

- draft typing은 local state only다.
- answer submit/edit은 최대 하나의 answer document만 쓴다.
- comment create/update는 최대 하나의 comment document만 쓴다.
- skipped 또는 empty answer는 saved answer content처럼 보이면 안 된다.

## 수용 기준

- answer save failure 후에도 retry UI가 계속 보여야 한다.
- 내 answer가 unsaved 또는 failed 상태이면 partner answer와 comment composer는 locked 상태를 유지한다.
- late answer write는 stable `{questionId}_{uid}` answer key를 사용한다.
- question calendar day state는 progress와 answer data에서 계산한다.
