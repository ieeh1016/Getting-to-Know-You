# Testing And Verification Spec

## 목적

Testing은 SDD change를 추적 가능하게 유지하고 mobile-first Flutter Web app의 UI regression을 막는다.

## 필수 Gate

- `dart analyze`
- 관련 `flutter test` target
- 중요한 frontend change에는 `flutter build web`
- visible layout 또는 interaction change에는 browser verification

## Test Strategy

- domain test는 state transition, persistence call, write budget을 다룬다.
- widget test는 visible Korean copy, navigation, editing, filter, owner/partner action을 다룬다.
- Firestore-related change는 rules/doc update를 포함하고, practical하면 repository/controller test를 하나 이상 포함한다.
- UI change는 긴 한국어 text, 390px-class layout, bottom navigation spacing, overlapping content 부재를 확인해야 한다.
- `alagagi_app.dart`에서 UI를 추출하는 refactor는 existing widget key를 보존하고 이동한 feature의 focused test를 실행해야 한다.
- Verification 역할은 test를 임의로 수정하지 않는다. 실패한 test가 spec과 맞지 않는다고 판단되면 실패 내용을 보고하고, spec/test plan/Test Agent 범위에서 별도 수정한다.

## Code Structure Verification

- 새 feature UI는 `lib/src/features/<feature>/` 아래에 둔다.
- shared styling과 primitive는 `lib/src/shared/` 아래에 둔다.
- cross-file widget key는 `lib/src/app/test_keys.dart` 아래에 둔다.
- ongoing file/module extraction의 implementation guide는 `docs/code_structure.md`다.

## Fail-First 선호

- behavior change에서는 practical하면 implementation 전에 test를 추가하거나 조정한다.
- 순수 structural change 또는 documentation-only change라서 fail-first를 건너뛰었다면 handoff에 그 이유를 적는다.
