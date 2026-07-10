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
