# Profile Cards Spec

## 목적

Profile card는 user가 작은 self-introduction answer를 자신의 속도로 공유하게 한다.

## 필수 동작

- Partner tab은 채워진 partner card만 readable card로 보여준다.
- My tab은 filling, editing, skipping, restoring, awkward prompt hiding을 지원한다.
- user는 custom profile card를 추가할 수 있다.
- 한 user가 만든 custom card는 다른 user에게도 나타날 수 있다.
- UI는 form dump가 아니라 polished card notebook처럼 느껴져야 한다.

## 슬롯 카탈로그

- `profileSlotCatalogV3`은 20개 슬롯을 `취향`, `하루`, `대화`, `함께` 네 category로 나눠 가진다.
- 슬롯 질문은 만난 지 얼마 되지 않은 두 사람이 서로의 연락 방식, 하루 리듬, 편해지는 순간을 알아가는 데 초점을 둔다.
- 카탈로그에 없는 slot id는 화면에 그리지 않는다. 예전 카탈로그(`song`, `food`, `rest` 등)의 저장값은 UI에서 사라진다.
- Firestore 문서까지 지우려면 `scripts/reset_profile_slots.js`를 `--dry-run`으로 확인한 뒤 `--confirm`으로 실행한다. 되돌릴 수 없다.
- custom slot은 카탈로그와 무관하게 유지되며 `custom: true`로 구분한다.

## 데이터 규칙

- slot value는 `profileCards/{profileId}/slots/{slotId}` 아래에 저장한다.
- rules가 shared custom-card metadata를 명시적으로 허용하지 않는 한 user는 자신의 slot value만 create/update/delete할 수 있다.
- hidden/skipped state는 recoverable해야 한다.

## 수용 기준

- empty partner slot은 partner content처럼 보이지 않는다.
- awkward default prompt는 hide 또는 skip할 수 있다.
- custom card는 reload 후에도 유지되고 적절한 card set에 나타난다.
