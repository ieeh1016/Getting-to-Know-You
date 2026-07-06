# AI Context Map

이 문서는 AI coding agent가 SDD/TDD 흐름을 지키면서도 불필요한 context load를 줄이기 위한 작업별 라우팅 지도다.

`docs/spec.md`, `docs/spec/` feature spec, `docs/test_plan.md`가 source of truth다. 이 파일은 source of truth를 대체하지 않고, 어떤 문서를 먼저 열어야 하는지 알려주는 운영 색인이다.

## 사용 순서

1. 요청을 작업 유형으로 분류한다.
2. 아래 routing table의 "먼저 읽을 문서"만 우선 확인한다.
3. 관련 test나 code는 "검색 단서"로 좁힌 뒤 필요한 block만 읽는다.
4. 작업 중 scope가 넓어지면 "확장 조건"에 해당할 때만 추가 문서를 연다.
5. handoff에는 실제로 읽은 문서, 변경한 문서, 실행한 verification, skip한 이유를 남긴다.

## 기본 Context Budget

| 작업 크기 | 첫 확인 목표 | 확장 조건 |
| --- | --- | --- |
| Documentation-only | 수정 대상 문서와 상위 index 1개 | source of truth 충돌이 발견될 때 |
| 작은 UI/copy 수정 | feature spec, focused UI file, 관련 widget test | state, persistence, navigation이 바뀔 때 |
| Domain behavior 변경 | feature spec, `domain_model.md`, focused domain test, target implementation file | Firestore path나 owner field가 바뀔 때 |
| Firestore-backed 변경 | feature spec, `domain_model.md`, `firestore.md`, rules, repository, harness test | rules setup 문서 sync가 필요할 때 |
| Refactor/extraction | `code_structure.md`, `spec/testing.md`, focused source/test files | visible behavior나 widget key가 바뀔 때 |

## Routing Table

### Global Entry

- Always start from `AGENTS.md` for repository workflow.
- For product behavior, read `docs/spec.md` and the relevant feature spec.
- For traceability lookup, search `docs/spec_trace.md` before reading large test files.
- For full verification intent, search `docs/test_plan.md` by feature or trace ID.

### Auth, Session, Invite

- 먼저 읽을 문서:
  - `docs/spec.md`
  - `docs/spec/home.md`
  - `docs/spec/domain_model.md` if session model changes
- 검색 단서:
  - `AlagagiAuthRepository`
  - `AlagagiSession`
  - `signed out`
  - `setup required`
  - `invite`
- 주요 test:
  - `test/src/domain/alagagi_auth_test.dart`
  - `test/src/ui/alagagi_auth_gate_test.dart`
  - `test/widget_test.dart`

### Home, Navigation, First Visit

- 먼저 읽을 문서:
  - `docs/spec/home.md`
  - `docs/spec/testing.md` for visible UI changes
  - `docs/test_plan.md` entries with `HOME-`
- 검색 단서:
  - `home`
  - `unread`
  - `first visit`
  - `progress summary`
  - `feature launcher`
- 주요 code/test:
  - `lib/src/features/home/`
  - `test/src/ui/alagagi_app_test.dart`

### Questions, Answers, Archive, Records

- 먼저 읽을 문서:
  - `docs/spec/questions.md`
  - `docs/spec/domain_model.md` if answer/comment/progress data changes
  - `docs/test_plan.md` entries with `Q-`
- 검색 단서:
  - `answer draft`
  - `partner answer`
  - `late answer`
  - `question calendar`
  - `answer comment`
- 주요 code/test:
  - `lib/src/features/answer/`
  - `lib/src/features/archive/`
  - `lib/src/features/questions/`
  - `lib/src/features/records/`
  - `test/src/domain/alagagi_auth_test.dart`
  - `test/src/domain/alagagi_controller_test.dart`
  - `test/src/ui/alagagi_app_test.dart`

### Taste Match

- 먼저 읽을 문서:
  - `docs/spec/taste_match.md`
  - `docs/test_plan.md` entries with `TASTE-`
- 검색 단서:
  - `balance`
  - `selection`
  - `result reveal`
  - `taste note`
- 주요 code/test:
  - `lib/src/features/balance/`
  - `test/src/domain/alagagi_auth_test.dart`
  - `test/src/domain/alagagi_controller_test.dart`
  - `test/src/ui/alagagi_app_test.dart`

### Meetings And Meeting Plans

- 먼저 읽을 문서:
  - `docs/spec/meetings.md`
  - `docs/spec/domain_model.md`
  - `docs/test_plan.md` entries with `MEETING-`
- 검색 단서:
  - `schedule entry`
  - `meeting day`
  - `meeting plan`
  - `time block`
  - `linked place`
- 주요 code/test:
  - `lib/src/features/meeting/`
  - `lib/src/features/place/` if place links change
  - `test/src/domain/alagagi_auth_test.dart`
  - `test/src/domain/alagagi_controller_test.dart`
  - `test/src/ui/alagagi_app_test.dart`

### Places And Kakao Map

- 먼저 읽을 문서:
  - `docs/spec/places.md`
  - `docs/spec/domain_model.md`
  - `docs/map_open_api_guide.md`
  - `docs/test_plan.md` entries with `PLACE-`
- 검색 단서:
  - `shared place`
  - `Kakao`
  - `providerPlaceId`
  - `meetingPlanLinks`
  - `map movement`
- 주요 code/test:
  - `lib/src/features/place/`
  - `lib/src/data/firebase_alagagi_repositories.dart`
  - `test/harness_contract_test.dart`
  - `test/src/domain/alagagi_auth_test.dart`
  - `test/src/domain/alagagi_controller_test.dart`

### Music Notes And Comments

- 먼저 읽을 문서:
  - `docs/spec/music.md`
  - `docs/spec/domain_model.md` if storage or ownership changes
  - `docs/test_plan.md` entries with `MUSIC-`
- 검색 단서:
  - `music note`
  - `music note comment`
  - `listen state`
  - `updatedAt`
  - `link action`
- 주요 code/test:
  - `lib/src/features/music/`
  - `test/src/domain/alagagi_auth_test.dart`
  - `test/src/ui/alagagi_app_test.dart`

### Stocks

- 먼저 읽을 문서:
  - `docs/spec/stocks.md`
  - `docs/spec/domain_model.md` if story/holding storage changes
  - `docs/test_plan.md` entries with `STOCK-`
- 검색 단서:
  - `stock story`
  - `stock holding`
  - `reply`
  - `shared holdings`
- 주요 code/test:
  - `lib/src/features/stocks/`
  - `test/src/domain/alagagi_auth_test.dart`
  - `test/src/ui/alagagi_app_test.dart`

### Profile Cards

- 먼저 읽을 문서:
  - `docs/spec/profile_cards.md`
  - `docs/spec/domain_model.md` if slot storage changes
  - `docs/test_plan.md` entries with `PROFILE-`
- 검색 단서:
  - `profile card`
  - `slot`
  - `custom card`
  - `hidden slot`
- 주요 code/test:
  - `lib/src/features/profile/`
  - `test/src/domain/alagagi_auth_test.dart`
  - `test/src/domain/alagagi_controller_test.dart`
  - `test/src/ui/alagagi_app_test.dart`

### Wishlist

- 먼저 읽을 문서:
  - `docs/spec/wishlist.md`
  - `docs/spec/domain_model.md` if wish ownership changes
  - `docs/test_plan.md` entries with `WISH-`
- 검색 단서:
  - `wish`
  - `interest`
  - `mutual`
  - `done`
- 주요 code/test:
  - `lib/src/features/wishlist/`
  - `test/src/domain/alagagi_auth_test.dart`
  - `test/src/domain/alagagi_controller_test.dart`
  - `test/src/ui/alagagi_auth_gate_test.dart`
  - `test/src/ui/alagagi_app_test.dart`

### Memory Cards

- 먼저 읽을 문서:
  - `docs/spec/memory_cards.md`
  - `docs/spec/home.md`
  - `docs/spec/domain_model.md`
  - `docs/spec/firestore.md`
  - `docs/test_plan.md` entries with `MEMORY-`
- 검색 단서:
  - `memory card`
  - `memoryCards`
  - `memoryCardResponses`
  - `home menu`
  - `feature launcher`
- 주요 code/test:
  - `lib/src/features/memory/`
  - `lib/src/features/home/`
  - `lib/src/data/firebase_alagagi_repositories.dart`
  - `test/src/domain/alagagi_auth_test.dart`
  - `test/src/ui/alagagi_app_test.dart`
  - `test/harness_contract_test.dart`

### Improvements

- 먼저 읽을 문서:
  - `docs/spec/improvements.md`
  - `docs/spec/domain_model.md` if owner role behavior changes
  - `docs/test_plan.md` entries with `IMPROVE-`
- 검색 단서:
  - `improvement`
  - `owner note`
  - `resolved`
  - `delete`
- 주요 code/test:
  - `lib/src/features/improvements/`
  - `test/src/domain/alagagi_auth_test.dart`
  - `test/src/ui/alagagi_app_test.dart`

### Firestore Rules, Repository, Budget

- 먼저 읽을 문서:
  - `docs/spec/firestore.md`
  - `docs/spec/domain_model.md`
  - related feature spec
  - `docs/firebase_setup.md` only when rules text changes
- 검색 단서:
  - collection name
  - owner field name
  - `valid<Feature>Shape`
  - `updatedByProfileId`
  - `request.auth.uid`
- 주요 code/test:
  - `firestore.rules`
  - `lib/src/data/firebase_alagagi_repositories.dart`
  - `test/harness_contract_test.dart`
  - `scripts/check_firestore_rules_sync.sh`

### Code Structure Or Extraction

- 먼저 읽을 문서:
  - `docs/code_structure.md`
  - `docs/spec/testing.md`
  - related feature spec if visible behavior changes
- 검색 단서:
  - widget key
  - feature folder
  - moved widget name
  - import path
- 주요 code/test:
  - `lib/src/app/test_keys.dart`
  - `lib/src/shared/`
  - `lib/src/features/<feature>/`
  - related focused widget tests

### Design Proposal HTML

- 먼저 읽을 문서:
  - `docs/design/README.md`
  - related feature spec if proposal changes behavior
  - `docs/test_plan.md` only after an option is selected
- 검색 단서:
  - proposal file name
  - selected behavior
  - Firestore write
  - 390px
- 주요 file:
  - `docs/design/*.html`

## Verification Log Summary Rule

긴 command output은 대화나 handoff에 그대로 붙이지 않는다. 다음 형식으로 요약한다.

```text
Command:
- flutter test test/src/ui/alagagi_app_test.dart

Outcome:
- failed

First failing cases:
- home unread panel opens a scrollable full activity sheet

Relevant error:
- Expected to find text "더 보기" once, found none.

Likely files:
- lib/src/features/home/unread_activity_panel.dart
- test/src/ui/alagagi_app_test.dart

Next step:
- Inspect the panel entry condition before changing the test.
```

Full logs can stay in the terminal. Handoff should include only the command, outcome, first relevant failure, likely files, and next action.

## Expansion Rules

Open more files only when one of these is true.

- The focused file references a helper or model that owns the behavior.
- A test failure points to a different file or API boundary.
- A Firestore path, field ownership, or write budget rule changes.
- The selected feature spec conflicts with `domain_model.md`, `firestore.md`, or `test_plan.md`.
- A visible UI change needs 390px layout verification.

If the work remains documentation-only, do not inspect production implementation files unless the documentation names a concrete code contract that must be checked.
