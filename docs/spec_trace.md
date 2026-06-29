# Spec Trace

이 문서는 feature spec, `docs/test_plan.md`, 실제 test file/test name을 빠르게 연결하기 위한 얇은 추적표다.

`docs/spec.md`, `docs/spec/` feature spec, `docs/test_plan.md`가 source of truth다. 이 파일은 긴 문서와 큰 test file을 매번 처음부터 읽지 않도록 돕는 lookup index다.

## ID 규칙

| Prefix | 영역 |
| --- | --- |
| `HARNESS-` | AI agent workflow, context routing, verification handoff |
| `AUTH-` | login, session, invite |
| `HOME-` | home, navigation, unread activity, first visit guide |
| `Q-` | questions, answers, comments, archive, records |
| `TASTE-` | taste match and balance selection |
| `MEETING-` | schedule coordination and fixed meeting plans |
| `PLACE-` | Kakao map place board and meeting place links |
| `MUSIC-` | music notes, listen state, music comments |
| `STOCK-` | stock stories and holdings |
| `PROFILE-` | profile cards and slots |
| `WISH-` | wishlist |
| `IMPROVE-` | improvement board |
| `FIRESTORE-` | Firestore rules, repository paths, write budget |

새 behavior를 추가할 때는 관련 feature spec과 `docs/test_plan.md`를 먼저 갱신하고, practical하면 이 표에 trace row를 추가한다.

## High-Value Trace Rows

| ID | Behavior | Source | Test Plan Area | Tests |
| --- | --- | --- | --- | --- |
| `HARNESS-001` | AI agents follow spec -> test_plan/tests -> implementation -> verification. | `AGENTS.md`, `docs/agent_harness_playbook.md` | Unit Tests, Manual Checks / AI Harness | `test/harness_contract_test.dart`: `multi-agent harness playbook is linked and role complete` |
| `HARNESS-002` | AI agents use context routing and concise verification log summaries to reduce repeated context load. | `AGENTS.md`, `docs/ai_context_map.md`, `docs/spec_trace.md` | Unit Tests, Manual Checks / AI Harness | `test/harness_contract_test.dart`: `AI context routing and trace lookup docs are linked` |
| `HARNESS-003` | Portable `AI_APP_DEV_PROCESS.md` remains a bootstrap kernel that scaffolds project-specific source-of-truth docs instead of becoming product truth itself. | `AI_APP_DEV_PROCESS.md` | Unit Tests, Manual Checks / AI Harness | `test/harness_contract_test.dart`: `portable AI app process stays bootstrap-oriented` |
| `FIRESTORE-001` | `firestore.rules` and `docs/firebase_setup.md` rules block stay in sync. | `docs/spec/firestore.md`, `docs/firebase_setup.md`, `firestore.rules` | Unit Tests, Manual Checks / AI Harness | `test/harness_contract_test.dart`: `Firestore rules file stays in sync with Firebase setup docs` |
| `FIRESTORE-002` | Repository collection names are covered by Firestore security rule match paths. | `docs/spec/firestore.md`, `firestore.rules` | Unit Tests | `test/harness_contract_test.dart`: `Firestore repository collections are covered by security rules` |
| `Q-ANSWER-001` | Answer draft changes are local state only and do not call repository writes. | `docs/spec/questions.md`, `docs/spec/domain_model.md` | Unit Tests | `test/src/domain/alagagi_auth_test.dart`: `answer draft changes do not call repository writes` |
| `Q-ANSWER-002` | Failed or pending answer save keeps partner answer and comment composer locked. | `docs/spec/questions.md` | Unit Tests, Widget Tests | `test/src/domain/alagagi_auth_test.dart`: `partner answer stays locked until my answer save succeeds` |
| `Q-CALENDAR-001` | Question calendar derives month grid and day state from progress and answers without calendar writes. | `docs/spec/questions.md` | Unit Tests, Widget Tests, Firestore Free Plan Budget Checks | `test/src/domain/alagagi_auth_test.dart`: `question calendar month grid follows today and selected month`; `test/src/ui/alagagi_app_test.dart`: `archive calendar shows controls weekdays and selected detail` |
| `Q-LATE-001` | Past unanswered question can be saved with stable `{questionId}_{uid}` late-answer key. | `docs/spec/questions.md` | Unit Tests, Widget Tests | `test/src/ui/alagagi_app_test.dart`: `archive calendar opens and saves a late answer` |
| `HOME-UNREAD-001` | Home shows short unread previews and opens a scrollable full activity sheet when there are more items. | `docs/spec/home.md` | Unit Tests, Widget Tests | `test/src/ui/alagagi_app_test.dart`: `home unread panel opens a scrollable full activity sheet` |
| `HOME-MUSIC-001` | New partner music status is device-local and is cleared only when the music tab is seen. | `docs/spec/home.md`, `docs/spec/music.md` | Unit Tests, Widget Tests | `test/src/ui/alagagi_app_test.dart`: `home summary marks new partner music until music tab is seen` |
| `TASTE-001` | Balance selection waits for user choice before next action and separates result reveal from selection. | `docs/spec/taste_match.md` | Unit Tests, Widget Tests | `test/src/domain/alagagi_auth_test.dart`: `revealing a balance result is saved separately from selection`; `test/src/ui/alagagi_app_test.dart`: `balance next action waits until an option is selected` |
| `MEETING-PLAN-001` | Fixed meeting day plan saves shared plan items for the selected day. | `docs/spec/meetings.md`, `docs/spec/domain_model.md` | Unit Tests, Widget Tests, Firestore Free Plan Budget Checks | `test/src/domain/alagagi_auth_test.dart`: `session meeting plan saves to the shared meeting plan document`; `test/src/ui/alagagi_app_test.dart`: `meeting plan tab saves plan items for a fixed meeting day` |
| `MEETING-PLAN-002` | Meeting plan item count is not capped at eight. | `docs/spec/meetings.md`, `docs/spec/firestore.md` | Unit Tests | `test/harness_contract_test.dart`: `meeting plan rules do not cap plan item count at eight`; `test/src/domain/alagagi_controller_test.dart`: `meeting plan draft can store more than eight items` |
| `PLACE-001` | Shared place saves provider metadata safely and does not store location tracking paths or raw movement state. | `docs/spec/places.md`, `docs/spec/firestore.md` | Unit Tests, Widget Tests, Firestore Free Plan Budget Checks | `test/harness_contract_test.dart`: `shared place rules cover repository write metadata and date links`; `test/src/ui/alagagi_app_test.dart`: `place tab adds a shared place without location tracking copy` |
| `PLACE-MEETING-001` | Meeting place links use a narrow Firestore patch and preserve place ownership. | `docs/spec/places.md`, `docs/spec/meetings.md`, `docs/spec/domain_model.md` | Unit Tests, Firestore Free Plan Budget Checks | `test/harness_contract_test.dart`: `shared place meeting link saves use a narrow Firestore patch`; `test/src/domain/alagagi_controller_test.dart`: `meeting plan places store reservation time and custom order` |
| `MUSIC-NOTE-001` | Music note listen state toggles only my listen state and does not open detail. | `docs/spec/music.md` | Unit Tests, Widget Tests | `test/src/domain/alagagi_auth_test.dart`: `music note listen emoji toggles my listen state only`; `test/src/ui/alagagi_app_test.dart`: `music listen emoji toggles without opening detail` |
| `MUSIC-COMMENT-001` | Music note comment draft is local until submit and comment save does not reorder parent note. | `docs/spec/music.md`, `docs/spec/domain_model.md` | Unit Tests, Widget Tests, Firestore Free Plan Budget Checks | `test/src/domain/alagagi_auth_test.dart`: `music note comment draft saves only on submit and keeps note ordering`; `test/src/ui/alagagi_app_test.dart`: `music note card previews comments and detail composer saves` |
| `MUSIC-COMMENT-002` | Music note comment edit/delete is owner-only. | `docs/spec/music.md`, `docs/spec/domain_model.md` | Unit Tests, Widget Tests | `test/src/domain/alagagi_auth_test.dart`: `music note comment edit and delete are owner-only`; `test/src/ui/alagagi_app_test.dart`: `music detail lets me edit and delete only my comments` |
| `STOCK-HOLDING-001` | Stock holding draft is local and saved only on explicit submit. | `docs/spec/stocks.md`, `docs/spec/domain_model.md` | Unit Tests, Widget Tests, Firestore Free Plan Budget Checks | `test/src/domain/alagagi_auth_test.dart`: `stock holdings load from session data and save only on submit`; `test/src/ui/alagagi_app_test.dart`: `stock holdings tab shares a held stock without a new home card` |
| `STOCK-HOLDING-002` | Stock holding owner can edit/delete own holding, and partner reply updates existing partner holding document. | `docs/spec/stocks.md` | Unit Tests, Widget Tests | `test/src/domain/alagagi_auth_test.dart`: `stock holding owner can edit and delete own holding`; `test/src/domain/alagagi_auth_test.dart`: `stock holding reply updates the existing partner holding document`; `test/src/ui/alagagi_app_test.dart`: `stock holding cards allow owners to edit and delete holdings` |
| `PROFILE-001` | Profile cards can be saved, hidden, restored, and deleted by the owning profile. | `docs/spec/profile_cards.md`, `docs/spec/domain_model.md` | Unit Tests, Widget Tests | `test/src/domain/alagagi_auth_test.dart`: `custom profile cards can be saved, hidden, restored, and deleted`; `test/src/ui/alagagi_app_test.dart`: `profile card can add custom cards and hide default prompts` |
| `WISH-001` | Wish draft creates and saves my wish only on explicit submit. | `docs/spec/wishlist.md`, `docs/spec/domain_model.md` | Unit Tests, Widget Tests, Firestore Free Plan Budget Checks | `test/src/domain/alagagi_auth_test.dart`: `wish draft creates and saves my wish`; `test/src/ui/alagagi_auth_gate_test.dart`: `wishlist add CTA creates a new wish card` |
| `IMPROVE-001` | Improvement post creator can edit/delete own posts, while owner-only reply and completion stay owner-only. | `docs/spec/improvements.md`, `docs/spec/domain_model.md` | Unit Tests, Widget Tests | `test/src/domain/alagagi_auth_test.dart`: `improvement board saves edits and deletes owner posts`; `test/src/domain/alagagi_auth_test.dart`: `only owner can reply and resolve improvement posts`; `test/src/ui/alagagi_app_test.dart`: `improvement board owner replies and moves completed posts` |

## Maintenance Notes

- Add or update trace rows only for behavior that is likely to be searched again.
- Keep each row short enough that agents can scan it before opening large files.
- If a test name changes, update this file in the same change.
- If a behavior intentionally has no test because it is documentation-only, say so in the `Tests` column.
- Do not duplicate every `docs/test_plan.md` bullet here. This file is a high-value lookup index, not the canonical test plan.
