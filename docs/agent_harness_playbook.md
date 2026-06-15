# Multi-Agent Harness Playbook

This playbook defines how multiple AI coding agents can collaborate on this
repository. It is for development and verification work only. The app runtime
does not include AI agents.

## Operating Model

Every multi-agent task still follows the repository contract:

1. `docs/spec.md`
2. `docs/test_plan.md` and tests
3. Production implementation
4. Verification and handoff

`docs/spec.md` wins over `docs/test_plan.md`, tests, code, and chat history
when those sources disagree.

## Agent Roles

### Orchestrator Agent

- Owns task scope, sequencing, file ownership, and final handoff.
- Decides which work stays local and which work can run in parallel.
- Resolves conflicts against `docs/spec.md`.
- Must check `git status --short` before and after changes.

### Spec Agent

- Updates product behavior, acceptance criteria, copy/tone, out-of-scope notes,
  and Firebase budget assumptions in `docs/spec.md`.
- Must not change production code.
- Hands off the exact spec sections changed.

### Test Agent

- Updates `docs/test_plan.md`.
- Adds or adjusts domain/widget/harness tests.
- Notes whether fail-first was observed or why it was not practical.
- Must not weaken or delete tests without spec-backed justification.

### Implementation Agent

- Makes the smallest production change that satisfies the spec and tests.
- Keeps repository writes behind explicit user actions.
- Avoids adding behavior not covered by the spec.
- Must not edit the same files as another active implementation agent.

### UI QA Agent

- Reviews visible UI changes against 390px-class mobile layouts.
- Checks long Korean text, bottom navigation spacing, and overlapping elements.
- Rejects hearts, couple-app wording, anniversary language, pressure, tracking,
  and guilt-inducing copy.
- Uses screenshots or browser checks when a visual change is significant.

### Firebase Rules/Budget Agent

- Reviews Firestore data shapes, security rules, read/write estimates, and
  Spark/free-plan boundaries.
- Confirms draft typing, scrolling, route changes, tab changes, calendar
  navigation, and seen state do not create Firestore writes.
- Checks that secrets, service accounts, raw API payloads, media blobs, and
  location paths are not committed.

### Verification Agent

- Runs or reviews `dart analyze`, `flutter test`, and `flutter build web` when
  relevant.
- Can run `./scripts/verify.sh` for the local full gate.
- Reports remaining risks and any skipped verification.

## Handoff Packet

Each agent handoff should include:

- Role and scope
- Files read or changed
- Spec/test sections touched
- Verification performed
- Known risks or open questions

Final handoff should include:

- Changed files
- Verification commands and outcomes
- Firebase read/write or rules impact
- UI QA notes for visible changes
- Any manual follow-up required

## Conflict Rules

- Do not assign the same writable file to multiple active implementation
  agents.
- Parallel agents should prefer read-only review unless their write scopes are
  clearly disjoint.
- If a needed behavior is missing from the spec, pause implementation and route
  back to the Spec Agent.
- If a test contradicts the spec, update the test plan and test only after the
  spec is clear.
- If UX convenience conflicts with security or Firebase budget rules, security
  and budget rules win.

## Practical Patterns

- Use two explorers in parallel for independent review questions, such as
  "Firestore rules gap" and "390px UI risk".
- Use workers only for disjoint file sets, such as one agent updating docs and
  another adding tests.
- Keep the Orchestrator on the critical path for integration, final review, and
  commit scope.

