# Multi-Agent Harness Playbook

이 playbook은 여러 AI coding agent가 이 저장소에서 협업하는 방식을 정의한다.
개발과 verification 작업 전용이며, 앱 runtime에는 AI agent가 포함되지 않는다.

## 운영 모델

모든 multi-agent task는 저장소 작업 계약을 따른다.

1. `docs/spec.md`와 관련 `docs/spec/*.md` feature spec
2. `docs/test_plan.md`와 tests
3. production implementation
4. verification and handoff

`docs/spec.md`와 `docs/spec/` 아래 feature spec은 `docs/test_plan.md`, tests,
code, chat history보다 우선한다. 자료가 서로 충돌하면 최신 spec을 따른다.
archived `docs/spec/legacy_full_spec.md`는 migration context로만 사용한다.

## Agent 역할

### Orchestrator Agent

- task scope, sequencing, file ownership, final handoff를 책임진다.
- 어떤 작업을 local로 유지하고 어떤 작업을 parallel로 실행할지 결정한다.
- 충돌은 `docs/spec.md`와 관련 feature spec을 기준으로 정리한다.
- 변경 전후에 반드시 `git status --short`를 확인한다.

### Spec Agent

- 관련 spec file의 product behavior, acceptance criteria, copy/tone,
  out-of-scope note, Firebase budget assumption을 갱신한다.
- production code를 변경하지 않는다.
- 변경한 정확한 spec section을 handoff한다.

### Test Agent

- `docs/test_plan.md`를 갱신한다.
- domain/widget/harness test를 추가하거나 조정한다.
- fail-first를 확인했는지, 확인하지 못했다면 왜 practical하지 않았는지 기록한다.
- spec-backed justification 없이 test를 약화하거나 삭제하지 않는다.

### Implementation Agent

- spec과 tests를 만족하는 가장 작은 production change를 만든다.
- repository write는 explicit user action 뒤에만 둔다.
- spec에 없는 behavior를 추가하지 않는다.
- 다른 active implementation agent와 같은 file을 동시에 수정하지 않는다.

### UI QA Agent

- visible UI change를 390px-class mobile layout 기준으로 검토한다.
- 긴 한국어 text, bottom navigation spacing, overlapping element를 확인한다.
- heart, couple-app wording, anniversary language, pressure, tracking,
  guilt-inducing copy를 거절한다.
- visual change가 중요하면 screenshot 또는 browser check를 사용한다.

### Firebase Rules/Budget Agent

- Firestore data shape, security rules, read/write estimate,
  Spark/free-plan boundary를 검토한다.
- draft typing, scrolling, route changes, tab changes, calendar navigation,
  seen state가 Firestore write를 만들지 않는지 확인한다.
- secret, service account, raw API payload, media blob, location path가 commit되지 않는지 확인한다.

### Verification Agent

- 필요할 때 `dart analyze`, `flutter test`, `flutter build web`를 실행하거나 검토한다.
- local full gate로 `./scripts/verify.sh`를 실행할 수 있다.
- 남은 risk와 skipped verification을 보고한다.

## Handoff Packet

각 agent handoff에는 다음을 포함한다.

- role과 scope
- 읽거나 변경한 files
- 변경한 spec/test section
- 수행한 verification
- known risks 또는 open questions

final handoff에는 다음을 포함한다.

- changed files
- verification commands and outcomes
- Firebase read/write 또는 rules impact
- visible change에 대한 UI QA notes
- 필요한 manual follow-up

## 충돌 규칙

- 같은 writable file을 여러 active implementation agent에게 배정하지 않는다.
- parallel agent는 write scope가 명확히 분리되어 있지 않다면 read-only review를 선호한다.
- 필요한 behavior가 spec에 없으면 implementation을 멈추고 Spec Agent로 되돌린다.
- test가 spec과 충돌하면 spec이 명확해진 뒤 test plan과 test를 갱신한다.
- UX convenience가 security 또는 Firebase budget rule과 충돌하면 security와 budget rule을 우선한다.

## 실전 패턴

- `Firestore rules gap`, `390px UI risk`처럼 독립적인 review question은 두 explorer를 parallel로 사용한다.
- worker는 한 agent가 docs를 갱신하고 다른 agent가 tests를 추가하는 식으로 file set이 분리될 때만 사용한다.
- integration, final review, commit scope는 Orchestrator가 critical path에서 관리한다.
