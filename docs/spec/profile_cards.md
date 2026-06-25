# Profile Cards Spec

## 목적

Profile card는 user가 작은 self-introduction answer를 자신의 속도로 공유하게 한다.

## 필수 동작

- Partner tab은 채워진 partner card만 readable card로 보여준다.
- My tab은 filling, editing, skipping, restoring, awkward prompt hiding을 지원한다.
- user는 custom profile card를 추가할 수 있다.
- 한 user가 만든 custom card는 다른 user에게도 나타날 수 있다.
- UI는 form dump가 아니라 polished card notebook처럼 느껴져야 한다.

## 데이터 규칙

- slot value는 `profileCards/{profileId}/slots/{slotId}` 아래에 저장한다.
- rules가 shared custom-card metadata를 명시적으로 허용하지 않는 한 user는 자신의 slot value만 create/update/delete할 수 있다.
- hidden/skipped state는 recoverable해야 한다.

## 수용 기준

- empty partner slot은 partner content처럼 보이지 않는다.
- awkward default prompt는 hide 또는 skip할 수 있다.
- custom card는 reload 후에도 유지되고 적절한 card set에 나타난다.
