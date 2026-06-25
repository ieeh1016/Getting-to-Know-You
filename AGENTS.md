# AI Agent 작업 계약

이 저장소는 SDD + TDD 흐름으로 개발한다. `docs/spec.md`와 `docs/spec/` 아래의 관련 문서를 제품 기준 문서로 보고, 모든 동작 변경은 spec -> test -> implementation으로 추적 가능해야 한다.

## 필수 진행 순서

1. `docs/spec.md`와 `docs/spec/` 아래의 관련 feature spec을 읽는다.
2. domain model, Firestore mapping, ownership field, cross-feature data flow를 건드리는 변경이면 `docs/spec/domain_model.md`도 읽는다.
3. production behavior를 바꾸기 전에 top-level spec index 또는 feature spec을 먼저 갱신한다.
4. 새 동작에 맞춰 `docs/test_plan.md`를 갱신하고 domain/widget test를 추가하거나 조정한다.
5. 가능하면 production edit 전에 새로 추가하거나 바꾼 test가 실패하는 것을 먼저 확인한다.
6. spec과 test를 만족하는 가장 작은 production change를 구현한다.
7. 마무리 전에 verification을 실행한다.

순수 기계적 변경, documentation-only 변경, 긴급 수정이라면 production behavior test가 필요 없는 이유를 설명한다.

## Multi-Agent 작업

여러 AI agent가 이 저장소에서 함께 작업할 때는 `docs/agent_harness_playbook.md`를 운영 가이드로 사용한다. 앱 runtime에는 AI agent가 포함되지 않으며, 이 playbook은 개발과 검증 작업 전용이다.

- scope, file ownership, final review, handoff를 책임지는 orchestrator를 하나 둔다.
- 같은 writable file을 여러 active implementation agent에게 동시에 배정하지 않는다.
- parallel agent는 주로 spec, tests, UI QA, Firebase rules/budget, verification처럼 독립적인 review에 사용한다.
- final handoff에는 changed files, verification results, Firebase impact, UI QA notes, known risks를 포함한다.

## 검증

개발 중에는 focused command를 먼저 사용하고, handoff 전에는 full gate를 실행한다.

```sh
./scripts/check_firestore_rules_sync.sh
dart analyze
flutter test
flutter build web
```

local one-command gate는 다음과 같다.

```sh
./scripts/verify.sh
```

## 제품 Guardrail

- 이 앱은 소개팅 이후 아직 서로를 알아가는 두 사람을 위한 것이다. 이미 커플이라고 가정하지 않는다.
- heart, couple-app wording, anniversary language, pressure, tracking, guilt-inducing copy를 피한다.
- copy는 조용하고 따뜻하며 부담이 낮아야 한다.
- Mobile UI를 우선한다. 390px-class layout에서 text clipping, overlapping, 어색한 bottom navigation spacing을 확인한다.

## Design Proposal Guardrail

- 새 UI/UX 방향을 구현 전에 HTML 제안서로 만들 때는 `docs/design/README.md`를 따른다.
- `docs/design/*.html`은 시각 합의용 보조 문서이며 source of truth가 아니다. 선택된 behavior는 관련 `docs/spec/` 문서와 `docs/test_plan.md`에 반영한다.
- 디자인 제안서는 기본적으로 `page-title` -> `principles`/`diagnosis` -> `stage`/`showcase`의 390px-class mobile mock -> `proposal-note` 구조를 유지한다.
- fake status bar mock, 관계 압박 copy, Firestore write boundary가 불분명한 제안은 만들지 않는다.

## Code Organization Guardrail

- 새 code와 refactor는 `docs/code_structure.md`를 따른다.
- 새 feature screen이나 큰 panel을 `lib/src/ui/alagagi_app.dart`에 추가하지 않는다.
- 새 user-facing feature UI는 `lib/src/features/<feature>/` 아래에 둔다.
- 재사용 가능한 colors, typography, widgets, sheet primitives는 `lib/src/shared/` 아래에 둔다.
- old screen을 점진적으로 분리하는 동안 `alagagi_app.dart`는 임시 app root와 route switchboard로 유지한다.
- `part` file보다 명확한 import를 가진 실제 Dart library를 선호한다.

## Firebase Guardrail

- Firebase service account file, password, API secret, local password helper script는 절대 commit하지 않는다.
- Firestore write는 명시적인 user action에서만 발생해야 한다.
- draft typing, scrolling, route changes, tab changes, calendar navigation, music seen state는 Firestore write를 만들면 안 된다.
- 새 Firebase-backed feature는 `docs/spec/firestore.md`에 정리된 Spark/free-plan assumption 안에 둔다.

## Git Hygiene

- 명시적으로 요청받지 않는 한 user change를 revert하지 않는다.
- commit은 focused하게 유지하고 user-facing behavior 또는 harness change가 드러나게 이름 붙인다.
- `change-passwords.js` 같은 ignored local helper file을 포함하지 않는다.
- commit 전에는 `git status --short`와 staged diff scope를 확인한다.
