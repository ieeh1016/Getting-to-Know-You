# AI 앱 개발 프로세스

버전: 0.1  
목적: 새 앱 저장소에 이 파일 하나를 복사한 뒤, AI coding agent에게 읽혀 SDD/TDD 기반의 개발 운영 문서 체계를 부트스트랩한다.

이 파일은 **휴대 가능한 방법론 seed**다. 특정 앱의 영구적인 제품 `source of truth`가 아니다. 이 파일의 역할은 새 프로젝트 안에 프로젝트별 기준 문서, 테스트 계획, trace 문서, context routing 문서를 만들어내는 것이다.

## 이 파일의 사용법

### 새 프로젝트에서 시작할 때

1. 새 repo root에 `AI_APP_DEV_PROCESS.md`를 복사한다.
2. 아래의 부트스트랩 프롬프트를 AI agent에게 준다.
3. AI가 생성한 운영 문서를 사람이 먼저 검토한다.
4. 승인 후 첫 feature를 `spec -> test plan/tests -> implementation -> verification` 순서로 시작한다.

### 기존 프로젝트에 도입할 때

1. 기존 repo root에 `AI_APP_DEV_PROCESS.md`를 복사한다.
2. AI agent에게 현재 프로젝트를 audit하고 migration plan을 만들게 한다.
3. production behavior는 바꾸지 않고 운영 문서부터 생성한다.
4. trace ID와 테스트는 닿는 영역부터 점진적으로 추가한다.

## 부트스트랩 프롬프트

새 앱 repo에서 첫 요청으로 그대로 사용할 수 있다.

```text
AI_APP_DEV_PROCESS.md를 먼저 읽어줘.

이 파일의 방법론에 맞춰 이 repo의 AI 앱 개발 운영 문서를 부트스트랩해줘.

목표:
- 첫 30분 안에 사람이 검토 가능한 개발 운영 뼈대를 만든다.
- 부트스트랩 단계에서는 production app code를 만들지 않는다.

규칙:
- production app code는 만들거나 수정하지 마.
- spec-driven, test-driven AI 개발에 필요한 운영 문서와 템플릿을 생성해.
- 내가 제공하는 앱 아이디어와 기술 스택에 맞춰 템플릿을 조정해.
- 기술 스택, DB, 배포 방식, 테스트 프레임워크가 불확실하면 추측하지 말고 Open Questions에 남겨.
- 이 bootstrap 파일과 프로젝트별 source-of-truth 문서를 분리해.
- context routing, trace ID, verification gate, 짧은 실패 로그 handoff 규칙을 포함해.
- 첫 구현 후보는 정확히 하나만 추천하고, 그 feature의 fail-first test 후보를 함께 적어.
- scaffold 후에는 멈추고 changed files, open questions, 첫 구현 후보, 승인 필요 항목을 요약해.

생성할 것:
- README.md
- AGENTS.md
- docs/spec.md
- docs/spec/README.md
- docs/spec/<mvp-feature>.md seed
- docs/spec/testing.md
- docs/test_plan.md
- docs/ai_context_map.md
- docs/spec_trace.md
- docs/code_structure.md
- UI 앱이면 docs/design/README.md
- 명령을 알 수 있으면 scripts/verify.sh, 모르면 TODO placeholder

앱 아이디어:
- [여기에 앱 아이디어를 적는다.]

알려진 기술 스택:
- Frontend: [unknown / Flutter / React / SwiftUI / etc.]
- Backend: [unknown / Firebase / Supabase / REST API / local-only / etc.]
- Test tools: [unknown / flutter test / jest / pytest / etc.]
- Deployment: [unknown / web / mobile / desktop / etc.]
```

## 첫 30분 프로토콜

부트스트랩 turn은 제품 구현이 아니라 개발 운영 뼈대를 만드는 시간이다.

| 시간 | 목표 | 산출물 |
| --- | --- | --- |
| 0-5분 | repo와 앱 아이디어 파악 | Project profile draft, stack unknowns, production edit 없음 |
| 5-10분 | 필수 질문 확인 또는 기록 | Open Questions, scaffold 가능한 최소 가정 |
| 10-20분 | 운영 문서 scaffold | README, AGENTS, spec index, feature spec seed, test plan, context map, trace table |
| 20-25분 | 첫 구현 후보 선정 | 가장 작고 검증 가능한 user-visible behavior 1개, fail-first test 후보 1개 |
| 25-30분 | review checkpoint | changed files, open questions, first feature recommendation, approval checklist |

이 프로토콜 후 agent는 멈춘다. production code는 사람이 scaffold를 승인하거나 명시적으로 진행을 요청한 뒤에 시작한다.

## 필수 부트스트랩 질문

답을 앱 아이디어에서 추론할 수 없을 때만 묻는다. 답이 부족해도 scaffold는 진행하되, 불확실한 항목은 Open Questions에 남긴다.

- 앱 이름 또는 임시 이름은 무엇인가?
- 주 사용자는 누구인가?
- 사용자가 첫날 반드시 할 수 있어야 하는 일은 무엇인가?
- MVP에서 제외할 것은 무엇인가?
- 핵심 데이터 객체는 무엇인가?
- 로그인이 필요한가, 아니면 local-only 앱인가?
- 저장소, DB, API, backend 후보는 정해졌는가?
- 첫 화면에서 가장 중요하게 보여야 하는 상태는 무엇인가?
- copy, tone, design, 정책에서 피해야 할 것은 무엇인가?
- 기대하는 검증 기준은 무엇인가? 예: unit test, widget test, e2e, build.

## 핵심 개념

이 방법론은 다섯 가지 축으로 구성된다.

| 축 | 목적 | 프로젝트 산출물 |
| --- | --- | --- |
| SDD | 제품 동작을 구현 전에 문서화한다. | `docs/spec.md`, `docs/spec/*.md` |
| TDD | 새 동작을 테스트로 먼저 또는 함께 보호한다. | `docs/test_plan.md`, test files |
| Traceability | 중요한 동작을 spec에서 test와 code까지 추적한다. | `docs/spec_trace.md` |
| Context Efficiency | AI가 작업에 필요한 문맥만 읽게 한다. | `docs/ai_context_map.md` |
| Verification Discipline | 실패를 숨기지 않고 짧고 정확하게 보고한다. | `AGENTS.md`, CI, scripts |

## Source Of Truth 규칙

- 제품 동작의 기준은 새 프로젝트의 `docs/spec.md`와 `docs/spec/*.md`다.
- 검증 의도는 `docs/test_plan.md`에 둔다.
- `docs/ai_context_map.md`와 `docs/spec_trace.md`는 운영 색인이다. 제품 truth가 아니다.
- 디자인 제안서는 합의용 문서다. 선택된 behavior가 spec과 test plan에 반영되기 전까지 source of truth가 아니다.
- 이 `AI_APP_DEV_PROCESS.md`는 새 repo를 시작하는 bootstrap kernel이다. 앱별 요구사항을 영구 보관하는 문서가 아니다.

## 절대 규칙

이 규칙들은 생성될 `AGENTS.md`에 들어가야 한다.

- 제품 동작 변경은 `spec -> test plan/tests -> implementation`으로 추적 가능해야 한다.
- 제품 source of truth는 프로젝트별 spec이다. chat history나 이 bootstrap 파일이 아니다.
- production behavior는 관련 spec이 갱신되기 전에 바뀌면 안 된다.
- 동작 변경은 문서화된 예외가 없는 한 fail-first testing을 사용해야 한다.
- fail-first 증거에는 command, 실패한 test 이름, 관련 failure, 그 failure가 새 spec behavior를 가리킨다는 설명이 포함되어야 한다.
- 테스트를 통과시키기 위해 test, snapshot, fixture, golden을 약화하거나 삭제하면 안 된다.
- test, snapshot, fixture, golden을 바꿔야 한다면 source spec과 replacement coverage 또는 no-longer-applicable 이유를 적어야 한다.
- draft typing, scrolling, route changes, tab changes, preview opening, passive read는 feature spec이 명시하지 않는 한 persistence write를 만들면 안 된다.
- data mutation은 명시적인 user/system action 뒤에 있어야 하며 actor와 ownership이 분명해야 한다.
- user change는 명시 요청 없이 revert하지 않는다.
- 큰 test file이나 큰 implementation file은 전체를 열기 전에 검색으로 좁힌다.
- 긴 command output은 handoff에 통째로 붙이지 않고 요약한다.
- documentation-only 또는 mechanical change는 왜 fail-first test가 필요 없거나 practical하지 않은지 설명해야 한다.
- production code, runtime behavior, tests, fixtures, snapshots, behavior 의미가 바뀌면 documentation-only가 아니다.
- auth, security, data mutation, payment, offline, error-state, authorization 흐름은 반복 검색 가능성과 무관하게 trace coverage를 우선한다.

## Fail-First 예외 조건

fail-first를 건너뛸 수 있는 경우는 좁게 제한한다.

| 예외 | handoff에 필요한 증거 |
| --- | --- |
| Documentation-only | 변경 파일, behavior 불변 이유, source-of-truth 충돌 확인 |
| 순수 이동/이름 변경 | behavior 보존 설명, focused verification 또는 생략 이유 |
| 테스트 인프라 사용 불가 | 시도한 command 또는 blocker, risk, follow-up |
| 긴급 수정 | risk, follow-up test plan, 필요 시 owner approval |
| obsolete behavior 삭제 | 제거를 증명하는 source spec, 대체 coverage 또는 제거된 coverage 설명 |

예외가 기록되지 않았다면 작업은 완료된 것이 아니다.

## 부트스트랩 산출물

첫 bootstrap turn은 기존 동등 문서가 없는 한 아래 파일을 만든다.

| 파일 | 필수 | 목적 |
| --- | --- | --- |
| `README.md` | 필수 | 앱 이름, 대상 사용자, 가치, MVP 그룹, setup note를 사람이 읽기 쉽게 설명한다. |
| `AGENTS.md` | 필수 | AI coding contract. |
| `docs/spec.md` | 필수 | 제품 spec index와 전역 제품 규칙. |
| `docs/spec/README.md` | 필수 | feature spec ownership과 변경 workflow. |
| `docs/spec/<feature>.md` | 필수 | feature-level behavior, data rules, acceptance criteria. |
| `docs/spec/domain_model.md` | 조건부 | shared domain model, ownership, persistence mapping. 데이터가 사용자/기능 간 흐르면 필수. |
| `docs/spec/data_policy.md` | 조건부 | storage, mutation budget, security, privacy, sync policy. stack에 맞게 이름을 바꿔도 된다. |
| `docs/spec/testing.md` | 필수 | testing and verification strategy. |
| `docs/test_plan.md` | 필수 | unit/widget/integration/manual verification plan. |
| `docs/spec_trace.md` | 필수 | high-value spec/test trace lookup table. |
| `docs/ai_context_map.md` | 필수 | token-efficient AI task routing map. |
| `docs/code_structure.md` | 권장 | target project structure와 refactor boundary. |
| `docs/design/README.md` | UI 앱이면 권장 | UI 변경 전 HTML proposal 규칙. |
| `scripts/verify.sh` | 권장 | local one-command verification gate. |
| `.github/pull_request_template.md` | 선택 | spec, test, data, UI, verification checklist. |

이미 같은 개념의 문서가 다른 이름으로 있으면 중복 생성하지 말고 cross-link를 추가한다.

## 생성될 `README.md` 템플릿

```md
# [App Name]

[한 문장 제품 설명]

## 누구를 위한 앱인가

- [Primary user]
- [Secondary user if any]

## 핵심 사용 순간

[사용자가 첫날 바로 느껴야 하는 첫 번째 가치]

## MVP 기능 그룹

- [Feature group 1]
- [Feature group 2]
- [Feature group 3]

## 현재 상태

- Stage: bootstrap / prototype / MVP / production
- Stack: [known or unknown]
- First implementation candidate: [feature]

## 개발 프로세스

이 repo는 `AGENTS.md`, `docs/spec.md`, `docs/test_plan.md`,
`docs/ai_context_map.md`, `docs/spec_trace.md`를 사용해 AI-assisted SDD/TDD로 개발한다.
```

## Project Profile 템플릿

AI agent는 아래 profile을 질문하거나 추론한다. 모르는 것은 Open Questions로 남긴다.

```md
# Project Profile

## Product

- App name:
- One-sentence purpose:
- Primary users:
- Main platform:
- Primary workflows:
- Out of scope:

## Stack

- Frontend:
- Backend:
- Database/storage:
- Auth:
- Test framework:
- Build/deploy:
- Analytics/monitoring:

## Data Risk

- User-generated data:
- Private or sensitive data:
- Offline behavior:
- Persistence write boundaries:
- Security rules or access-control model:

## UX Risk

- Mobile or desktop first:
- Accessibility requirements:
- Localization:
- Visual design system:
- Known copy/tone guardrails:

## Open Questions

- [Question 1]
- [Question 2]
```

## 생성될 `AGENTS.md` 템플릿

repo root에 만들거나 기존 문서에 반영한다.

```md
# AI Agent 작업 계약

이 저장소는 spec-driven development와 test-driven development를 함께 사용한다.
제품 동작의 source of truth는 `docs/spec.md`와 관련 `docs/spec/*.md` feature spec이다.

## 필수 작업 순서

1. `docs/ai_context_map.md`로 작업 유형을 분류한다.
2. `docs/spec.md`와 관련 feature spec을 읽는다.
3. data ownership, persistence, authorization, cross-feature behavior가 바뀌면 `docs/spec/domain_model.md`와 data policy spec을 읽는다.
4. 큰 test file을 열기 전에 `docs/spec_trace.md`와 `docs/test_plan.md`를 검색한다.
5. production behavior를 바꾸기 전에 관련 spec을 갱신한다.
6. `docs/test_plan.md`를 갱신하고 test를 추가하거나 조정한다.
7. 동작 변경에는 fail-first를 사용한다. 예외가 있으면 기록한다.
8. spec과 tests를 만족하는 가장 작은 변경을 구현한다.
9. focused verification을 먼저 실행하고 필요한 final gate를 실행한다.
10. verification 결과는 command, outcome, 첫 관련 failure, likely files, next action으로 요약한다.

## Context 효율 규칙

- 모든 문서를 기본으로 읽지 않는다.
- 작업 유형별 routing table에서 시작한다.
- 큰 파일은 `rg`로 검색한 뒤 필요한 range만 읽는다.
- focused file이 다른 owner/helper/model을 가리키거나, test failure가 다른 boundary를 가리키거나, spec 충돌이 있을 때만 context를 확장한다.
- skip한 verification과 이유를 기록한다.

## Change Safety

- 명시 요청 없이 user change를 revert하지 않는다.
- 실패를 없애기 위해 test를 약화하지 않는다.
- test를 바꿔야 한다면 source spec과 replacement coverage를 적는다.
- 새 dependency는 기존 도구로 충분하지 않은 이유를 설명한 뒤 추가한다.
- 변경 범위는 요청된 behavior에 가깝게 유지한다.
- fail-first를 건너뛰면 허용 예외와 증거를 기록한다.
```

## Spec 시스템

전역 규칙과 feature truth를 분리한다.

### `docs/spec.md` 템플릿

```md
# Product Spec Index

> Source of truth: 이 index와 `docs/spec/` feature specs.

## Product Principle

- [Principle 1]
- [Principle 2]
- [Principle 3]

## 사용 방법

1. 제품 scope와 전역 규칙은 이 파일에서 확인한다.
2. behavior를 바꾸기 전에 관련 feature spec을 읽는다.
3. data ownership 또는 persistence가 바뀌면 `docs/spec/domain_model.md`와 data policy spec을 읽는다.
4. spec, test plan/tests, implementation 순서로 진행한다.
5. spec이 충돌하면 가장 구체적인 최신 feature spec을 우선하고 두 문서를 함께 갱신한다.

## Feature Specs

- [Feature A](spec/feature_a.md)
- [Feature B](spec/feature_b.md)
- [Testing](spec/testing.md)

## Global Rules

- [Global product rule]
- [Global UX rule]
- [Global data rule]
```

### Feature Spec 템플릿

```md
# [Feature Name] Spec

## 목적

이 feature가 해결하는 사용자 문제와 제품 내 역할을 설명한다.

## 필수 동작

- [Behavior 1]
- [Behavior 2]
- [Behavior 3]

## Data Rules

- draft input은 명시 submit 전까지 local state다.
- [Create/update/delete boundary]
- [Ownership or authorization rule]
- [Read/write budget or mutation limit]

## UI/UX Rules

- [Layout or interaction rule]
- [Empty/loading/saved/failed state]
- [Copy/tone guardrail]

## Acceptance Criteria

- [Observable outcome]
- [Failure/retry behavior]
- [No unexpected mutation]
- [Mobile/accessibility/performance condition if relevant]

## Out Of Scope

- [Non-goal 1]
- [Non-goal 2]
```

### Domain Model 템플릿

```md
# Domain Model Spec

이 문서는 shared data vocabulary, ownership, persistence mapping, cross-feature relation을 정의한다.

## Common Rules

- `id` field는 stable identifier다.
- `createdBy`는 최초 작성자이며 조용히 바뀌면 안 된다.
- `updatedBy`는 가장 최근 explicit mutation을 수행한 actor다.
- backend-backed flow의 `updatedAt`은 server 또는 trusted timestamp다.
- draft input, scrolling, filtering, navigation은 persistence write가 아니다.

## Model Map

| Area | Domain model | Storage/API | Ownership and mutation boundary |
| --- | --- | --- | --- |
| [Feature] | `[Model]` | `[Path/table/endpoint]` | `[Who can write what]` |

## Cross-Feature Relations

- [Relation 1]
- [Relation 2]

## Write Design Checklist

1. domain model과 owner field를 추가하거나 갱신한다.
2. feature spec behavior를 추가하거나 갱신한다.
3. storage/API/security policy를 추가하거나 갱신한다.
4. tests를 추가하거나 갱신한다.
5. spec이 batch를 허용하지 않는 한 explicit action 하나는 가장 작은 practical mutation으로 유지한다.
```

### Data Policy 템플릿

`docs/spec/data_policy.md`, `docs/spec/firestore.md`, `docs/spec/api_policy.md`처럼 stack에 맞는 이름을 사용한다.

```md
# Data Policy Spec

## Global Data Rules

- passive UI action은 write를 만들면 안 된다.
- explicit save/select/edit/delete action은 write를 만들 수 있다.
- 각 mutation에는 owner 또는 actor가 있어야 한다.
- secret, service account, raw private payload, credential helper는 commit하지 않는다.

## Mutation Budget

| Action | Max mutation count | Notes |
| --- | --- | --- |
| [Action] | [Count] | [Notes] |

## Storage/API Map

| Feature | Path/table/endpoint | Read rule | Write rule |
| --- | --- | --- | --- |
| [Feature] | [Storage] | [Read] | [Write] |

## Security Maintenance

- storage 변경에는 security rule 또는 API authorization 변경이 따라야 한다.
- 의도한 valid write는 허용되어야 한다.
- 명백한 cross-user/cross-owner write는 거절되어야 한다.
- practical하면 harness 또는 integration coverage를 추가한다.
```

## Test Plan 시스템

### `docs/spec/testing.md` 템플릿

```md
# Testing And Verification Spec

## 목적

Testing은 spec change를 추적 가능하게 유지하고 user-facing regression을 막는다.

## Required Gates

- Static analysis 또는 lint
- Focused test target
- 중요한 frontend/deployment change에는 build check
- visible UI change에는 browser/device/manual verification

## Test Strategy

- Domain tests는 state transition, persistence call, mutation budget, ownership을 다룬다.
- UI/widget tests는 visible copy, navigation, editing, filtering, owner/partner action, error state를 다룬다.
- Integration/harness tests는 security rules, API contract, generated docs, CI wiring을 다룬다.
- UI change는 realistic viewport와 긴 text risk를 확인해야 한다.

## Fail-First

- behavior change는 허용 예외가 없는 한 implementation 전에 test를 추가하거나 조정한다.
- fail-first를 건너뛰면 handoff에 이유와 예외를 적는다.
```

### `docs/test_plan.md` 템플릿

```md
# Test Plan

> Source specs: `docs/spec.md`와 관련 `docs/spec/*.md`.
> production code 변경 전에 behavior를 spec에 추가하고 practical하면 test로 보호한다.

## Trace ID 운영

- 반복 검색될 behavior는 `docs/spec_trace.md`의 trace ID를 사용한다.
- 모든 bullet을 한 번에 ID화하지 않는다.
- 닿는 feature와 자주 실패하는 regression부터 점진적으로 붙인다.
- auth/security/payment/data mutation/offline/error-state는 우선 trace한다.

## Unit Tests

- `[TRACE-ID]` [Domain or pure logic behavior]

## UI / Widget Tests

- `[TRACE-ID]` [Visible user-facing behavior]

## Integration / Harness Tests

- `[TRACE-ID]` [Rules, docs, API contract, CI, generated files]

## Manual Checks

- [Manual verification item]

## Data / Mutation Budget Checks

- [Read/write/mutation budget item]
```

## Trace ID 시스템

Trace ID는 거대한 test plan을 또 하나 만드는 것이 아니라, 자주 찾아야 할 behavior를 빠르게 연결하는 lookup index다.

### Prefix 템플릿

| Prefix | Area |
| --- | --- |
| `HARNESS-` | AI workflow, docs, CI, verification |
| `AUTH-` | Auth, session, invite, account |
| `HOME-` | Home, navigation, dashboard |
| `DATA-` | Data policy, persistence, mutation budget |
| `API-` | API endpoints and contracts |
| `UI-` | Shared UI, layout, visual regression |
| `FEATURE-` | 새 앱 feature에 맞게 교체 |

### `docs/spec_trace.md` 템플릿

```md
# Spec Trace

이 파일은 high-value lookup index다. `docs/test_plan.md`를 대체하지 않는다.

## ID Rules

| Prefix | Area |
| --- | --- |
| `HARNESS-` | AI workflow and verification |
| `[FEATURE]-` | Feature behavior |

## Trace Rules

- 반복 검색될 가능성이 높은 behavior에 row를 추가한다.
- auth, security, payment, data mutation, authorization, offline, critical error-state behavior는 항상 우선 추가한다.
- production test가 없는 behavior는 No-test reason을 적는다.
- test name이 바뀌면 같은 변경에서 이 파일도 갱신한다.

## Trace Rows

| ID | Behavior | Source | Test Plan Area | Tests | No-test reason |
| --- | --- | --- | --- | --- | --- |
| `HARNESS-001` | Agents follow spec -> tests -> implementation -> verification. | `AGENTS.md` | Harness | `[test file]`: `[test name]` | |
| `[FEATURE]-001` | [Behavior] | `docs/spec/[feature].md` | Unit/UI | `[test file]`: `[test name]` | |
| `[DOC-ONLY-001]` | [Documentation-only behavior] | `[doc path]` | Manual | | Documentation-only; no production behavior changed |

## Maintenance Notes

- Row는 짧게 유지한다.
- test name 변경 시 함께 갱신한다.
- test가 의도적으로 없으면 `Documentation-only; no production test required`처럼 적는다.
```

## AI Context Routing

### `docs/ai_context_map.md` 템플릿

~~~md
# AI Context Map

이 파일은 AI agent가 SDD/TDD를 지키면서 불필요한 context load를 줄이도록 돕는다.
운영 색인이지 source of truth가 아니다.

## 사용 순서

1. 작업 유형을 분류한다.
2. 해당 유형의 initial docs만 읽는다.
3. 관련 tests/code는 큰 파일을 열기 전에 검색한다.
4. focused evidence가 다른 boundary를 가리킬 때만 context를 확장한다.
5. 무엇을 읽었고 무엇을 skip했는지 기록한다.

## Context Budget

| Task type | Initial context | Initial budget | Expand when | Do not open first |
| --- | --- | ---: | --- | --- |
| Documentation-only | Target doc and parent index | 1-2 files | Source-of-truth conflict | Production implementation files |
| Small UI/copy | Feature spec, focused UI file, focused UI test | 3-4 files | State, persistence, routing, or layout risk changes | App root, full UI mega-test |
| Domain behavior | Feature spec, domain model, focused domain test, implementation owner | 4-6 files | Data ownership or API changes | Full test suite files |
| Data/security/API | Feature spec, domain model, data policy, rules/API tests | 5-7 files | Storage contract changes | Unrelated UI files |
| Refactor/extraction | Code structure guide, focused files, focused tests | 3-5 files | Behavior or public API changes | Feature specs unrelated to moved code |
| Verification fix | Failure summary, trace row, likely files | 2-4 files | Failure points to another boundary | Full logs pasted into chat |

## Routing Table

### [Feature Name Or Task Type]

- First docs:
  - `docs/spec/[feature].md`
  - `docs/spec/domain_model.md` if data changes
  - `docs/test_plan.md` entries with `[PREFIX]-`
- Search terms:
  - `[domain term]`
  - `[UI label]`
  - `[method or model name]`
- Primary code/tests:
  - `[path]`
  - `[test path]`
- Expand only if:
  - `[specific condition]`
- Do not open first:
  - `[large file or unrelated area]`

## Verification Log Summary Rule

```text
Command:
- [command]

Outcome:
- passed | failed | skipped

First relevant failure:
- [test name or error summary]

Likely files:
- [path]

Next action:
- [action]
```

Full logs stay in the terminal or CI artifact. Handoff gets the summary.
~~~

## 개발 Workflow

모든 behavior-changing task는 이 순서를 따른다.

```text
작업 분류
-> context routing
-> source specs 읽기
-> spec 갱신
-> test plan / trace 갱신
-> test 추가 또는 조정
-> practical하면 fail-first 확인
-> 가장 작은 구현
-> focused verification
-> 필요 시 broader gate
-> concise handoff
```

## Definition Of Ready

feature 또는 bugfix가 구현 준비 상태가 되려면 다음이 충족되어야 한다.

- 관련 feature spec이 존재하거나 갱신되어 있다.
- data ownership과 mutation boundary가 분명하다.
- test plan이 intended regression coverage를 말한다.
- 모르는 제품/stack 결정은 Open Questions에 있다.
- context map이 likely docs/tests/code를 가리킨다.

## Definition Of Done

작업 완료 조건은 다음과 같다.

- spec이 최종 behavior를 반영한다.
- test plan과 tests가 최종 behavior를 반영한다.
- implementation이 기존 project structure를 따른다.
- focused verification이 실행됐다.
- skipped verification이 설명됐다.
- handoff가 changed files, verification outcome, data impact, UI impact, risks를 말한다.

## Feature Change Packet

AI에게 feature 구현을 요청할 때 사용한다.

```md
# Feature Change Packet

## Goal

[사용자 관점에서 무엇이 바뀌어야 하는가.]

## Scope

- In scope:
- Out of scope:

## Source Specs

- `docs/spec/[feature].md`
- `docs/spec/domain_model.md` if needed
- `docs/spec/data_policy.md` if needed

## Expected Tests

- Unit:
- UI/widget:
- Integration/harness:

## Data Mutation Boundary

- Passive actions:
- Explicit actions:
- Max mutations per action:
- Owner/actor:

## Verification

- Focused:
- Final:
```

## Task Intake 템플릿

non-trivial work 시작 전에 사용한다.

```md
# Task Intake

## Task Type

- documentation-only / UI-copy-layout / domain behavior / data-security-API / refactor / verification-fix

## Source Specs

- Read:
- To update:

## Context Plan

- Context budget:
- First files:
- Search terms:
- Large files to avoid initially:

## Trace

- Existing trace IDs:
- New trace IDs needed:

## Test Plan

- Test plan section:
- Fail-first command:
- Expected failure:

## Implementation Scope

- In scope files:
- Out of scope files:

## Exception

- Fail-first skipped? yes/no
- If yes, allowed exception and evidence:
```

## Handoff Packet

non-trivial work의 최종 응답에는 다음을 포함한다.

- changed files
- spec/test sections changed
- trace IDs added or updated
- fail-first evidence or allowed exception
- verification commands and outcomes
- data/API/security impact
- UI/UX impact if visible
- skipped verification and why
- known risks or open questions
- context note: unusually large files read or avoided

### Handoff 템플릿

```md
## Handoff

Role / Scope:
- [orchestrator/spec/test/implementation/verification]

Task Type:
- [documentation-only/UI/domain/data/refactor]

Context Used:
- Planned budget:
- Actual files read:
- Large reads avoided:

Trace:
- IDs:
- Source specs:
- Test plan sections:

Fail-First:
- Command:
- Expected failure observed:
- Exception if skipped:

Changes:
- [file path]: [summary]

Verification:
- [command] -> [passed/failed/skipped]
- First relevant failure:
- Likely files:
- Next action:

Risks / Open Questions:
- [risk]
```

## Multi-Agent 운영 모델

multi-agent는 역할과 파일 소유권이 분리될 때만 사용한다.

### 역할

| Role | Responsibility | Write access |
| --- | --- | --- |
| Orchestrator | scope, sequencing, integration, final review | 조정 |
| Spec Reviewer | product truth, acceptance criteria, out-of-scope 검토 | docs only |
| Test Reviewer | test plan, traceability, fail-first intent 검토 | 할당 시 docs/tests |
| Implementation Worker | bounded file/module set 구현 | assigned files only |
| UI QA Reviewer | layout, copy, accessibility, screenshots 검토 | 보통 read-only |
| Data/Security Reviewer | mutation boundary, API rules, privacy 검토 | 보통 read-only |
| Verification Reviewer | verification 실행 또는 검토, failure 보고 | 기본 read-only |

### Multi-Agent 규칙

- 같은 writable file을 여러 implementation agent에게 동시에 배정하지 않는다.
- 독립적인 review question에는 read-only explorer를 선호한다.
- worker는 혼자 작업하는 것이 아니며 다른 변경을 revert하면 안 된다.
- Orchestrator가 결과를 통합하고 source specs 기준으로 conflict를 해결한다.
- Verification agent는 build를 통과시키려고 test를 수정하면 안 된다.
- coordination cost가 context saving보다 크면 multi-agent를 쓰지 않는다.

## Design Proposal Workflow

UI-heavy 앱에서는 production UI 변경 전에 visual proposal이 유용하다.

### `docs/design/README.md` 템플릿

```md
# Design Proposal HTML Guide

Design proposal HTML files are lightweight visual decision documents.
They are not product source of truth.

## Use When

- New feature screen or major flow
- Dense mobile or desktop screen rework
- Multiple UI options need comparison
- Data ownership or mutation state needs to be visible in UI

## Required Content

- Problem or product moment
- Recommended option
- Empty/loading/saved/failed states if relevant
- Data mutation note
- Test and verification notes

## After Selection

- Update feature spec.
- Update test plan.
- Implement production code only after spec/test alignment.
```

## Stack Adapters

공통 프로세스 위에 stack adapter를 선택한다. stack이 불확실하면 Open Question으로 남긴다.

### Flutter / Dart Adapter

- Static analysis: `dart analyze`
- Unit/widget tests: `flutter test`
- 중요한 web change: `flutter build web`
- feature-first folder 예: `lib/src/features/<feature>/`
- shared UI와 styling은 `lib/src/shared/`
- cross-file widget key는 안정적인 app/test key 위치에 둔다.

추천 `scripts/verify.sh`:

```sh
#!/usr/bin/env bash
set -euo pipefail

flutter pub get
dart analyze
flutter test
flutter build web
```

### React / TypeScript Adapter

- Static analysis: `npm run lint` 또는 `pnpm lint`
- Type check: `npm run typecheck` 또는 `pnpm typecheck`
- Unit tests: `npm test`, `pnpm test`, 또는 `vitest`
- Build: `npm run build` 또는 `pnpm build`
- UI verification은 mobile과 desktop viewport를 포함한다.

추천 `scripts/verify.sh`:

```sh
#!/usr/bin/env bash
set -euo pipefail

npm install
npm run lint
npm run typecheck
npm test
npm run build
```

### Firebase / Firestore Adapter

- collection path와 owner field를 문서화한다.
- security rules와 setup docs를 동기화한다.
- intended valid write와 obvious invalid cross-owner write를 테스트한다.
- user typing, scrolling, tab changes, route changes, seen state는 Firestore write를 만들지 않는다.
- explicit action은 practical한 최소 document write로 유지한다.

### Supabase / SQL Adapter

- table, row ownership, RLS policy, API mutation을 문서화한다.
- owner와 non-owner row-level security를 테스트한다.
- draft input은 explicit submit 전까지 local이다.
- navigation, filtering, preview에서 hidden write를 만들지 않는다.

### REST / GraphQL API Adapter

- endpoint 또는 operation을 data policy spec에 문서화한다.
- request/response contract를 test에 trace한다.
- mutation operation에는 actor, authorization, idempotency, retry behavior가 필요하다.
- backend behavior를 frontend code만 보고 추정하지 않는다.

### Local-Only App Adapter

- local storage key와 migration policy를 문서화한다.
- local file write 또는 localStorage update도 persistence write로 취급한다.
- explicit-save 원칙은 local-only에서도 유지한다.
- data migration과 empty/corrupt local state를 테스트한다.

## Security And Secret Handling

생성된 project docs에는 다음이 포함되어야 한다.

- service account file, private key, password, raw private payload dump, credential helper를 commit하지 않는다.
- public client config와 private secret을 분리한다.
- 필요한 environment variables를 문서화한다.
- local development secret load 방식을 문서화한다.
- practical하면 forbidden committed file을 잡는 check/test를 추가한다.

## Code Structure Guide 템플릿

~~~md
# Code Structure Guide

## Target Structure

```text
src/
  app/
  features/
    <feature>/
  shared/
  domain/
  data/
tests/
docs/
```

## Rules

- stack convention이 더 강하지 않다면 새 feature code는 `features/<feature>/` 아래에 둔다.
- shared primitive는 `shared/` 아래에 둔다.
- practical하면 domain model과 repository를 UI에서 분리한다.
- legacy catch-all file에는 의도적인 transitional change가 아니면 새 code를 더하지 않는다.
- refactor는 behavior를 보존하고 focused verification을 포함한다.
~~~

## Pull Request Checklist 템플릿

```md
## PR Checklist

- [ ] Relevant spec updated or no behavior change explained
- [ ] Test plan updated or no test impact explained
- [ ] Tests added/updated for behavior changes
- [ ] Focused verification run
- [ ] Final gate run or skipped with reason
- [ ] Data mutation/security impact reviewed
- [ ] UI/copy/accessibility impact reviewed
- [ ] Trace IDs updated for high-value behavior
- [ ] No secrets or local credential helpers committed
```

## 부트스트랩 완료 기준

부트스트랩은 다음을 만족할 때 완료된다.

- `README.md`만 읽어도 app name, target user, core product moment, MVP feature groups, current status가 이해된다.
- `AGENTS.md`가 생성된 workflow docs를 가리킨다.
- `docs/spec.md`가 feature specs 또는 Open Questions를 나열한다.
- MVP feature spec seed가 최소 2개 있다. 하나만 알려진 경우 그 이유를 설명한다.
- 각 feature seed에는 purpose, required behavior, data/state notes, out-of-scope notes, test candidates가 있다.
- `docs/test_plan.md`가 trace ID guidance를 포함한다.
- `docs/ai_context_map.md`가 task routing을 포함한다.
- `docs/spec_trace.md`가 harness/process row와 첫 feature behavior placeholder를 포함한다.
- `docs/code_structure.md`가 있거나, stack이 너무 불확실해 Open Question으로 남겨져 있다.
- UI 앱이면 `docs/design/README.md`가 있다.
- `scripts/verify.sh`가 있거나 verification commands가 TODO placeholder로 정리되어 있다.
- 첫 구현 후보는 정확히 하나의 작은 user-visible behavior다.
- 첫 fail-first test 후보가 적혀 있다.
- stack-specific unknowns는 Open Questions로 남아 있다.
- 명시 요청이 없는 한 production code가 생성되지 않았다.
- 최종 bootstrap 응답이 generated files, remaining questions, first implementation candidate, fail-first candidate, approval items를 요약한다.

## 첫 Feature 진행 흐름

bootstrap 이후 첫 feature는 의도적으로 작아야 한다.

1. 사용자에게 보이는 feature 하나를 고른다.
2. 해당 feature spec을 작성하거나 다듬는다.
3. test plan bullet을 추가한다.
4. behavior가 중요하면 첫 trace row를 추가한다.
5. practical하면 failing test를 추가한다.
6. 가장 작은 구현을 한다.
7. focused verification을 실행한다.
8. 결과를 handoff한다.

## 이 방법론 파일 관리

`AI_APP_DEV_PROCESS.md`는 개인 방법론 파일처럼 버전 관리한다.

### Versioning

- template 또는 운영 규칙이 바뀌면 minor version을 올린다.
- 짧은 changelog를 유지한다.
- portable file에 app-specific behavior를 넣지 않는다.
- stack-specific advice는 adapter로 분리한다.

### Changelog

| Version | Date | Notes |
| --- | --- | --- |
| 0.1 | 2026-06-29 | AI-assisted SDD/TDD app development를 위한 portable bootstrap process 초안. |

## 마지막 원칙

이 파일은 프로젝트를 시작해야지, 프로젝트 자체가 되면 안 된다.

bootstrap docs가 생긴 뒤 future agents는 다음 문서를 기준으로 일한다.

- `AGENTS.md`: workflow
- `docs/spec.md`와 feature specs: product truth
- `docs/test_plan.md`: verification intent
- `docs/spec_trace.md`: high-value lookup
- `docs/ai_context_map.md`: token-efficient context routing

이 파일은 복사하기 충분히 portable하고, 새 앱마다 같은 disciplined process를 만들 만큼은 명확해야 한다.
