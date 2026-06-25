# AI Agent Working Contract

This repository is built with an SDD + TDD workflow. Treat `docs/spec.md` and the relevant files under `docs/spec/` as the product source of truth, and keep every behavior change traceable from spec to tests to implementation.

## Required Order

1. Read `docs/spec.md` and the relevant feature spec under `docs/spec/`.
2. Read `docs/spec/domain_model.md` when a change touches domain models, Firestore mapping, ownership fields, or cross-feature data flow.
3. Update the top-level spec index or feature spec before changing production behavior.
4. Update `docs/test_plan.md` and add or adjust domain/widget tests for the new behavior.
5. Prefer observing the new or changed test fail before production edits when practical.
6. Implement the smallest production change that satisfies the spec and tests.
7. Run verification before finishing.

For purely mechanical, documentation-only, or emergency fixes, explain why a production behavior test is not needed.

## Multi-Agent Work

When multiple AI agents collaborate on this repository, use
`docs/agent_harness_playbook.md` as the operating guide. The app runtime does
not include AI agents; this playbook is only for development and verification
work.

- Keep one orchestrator responsible for scope, file ownership, final review,
  and handoff.
- Do not assign the same writable file to multiple active implementation
  agents.
- Use parallel agents primarily for independent reviews such as spec, tests,
  UI QA, Firebase rules/budget, and verification.
- Final handoff should include changed files, verification results, Firebase
  impact, UI QA notes, and known risks.

## Verification

Use the focused command first while developing, then run the full gate before handoff:

```sh
./scripts/check_firestore_rules_sync.sh
dart analyze
flutter test
flutter build web
```

The local one-command gate is:

```sh
./scripts/verify.sh
```

## Product Guardrails

- The app is for two people after a blind date who are still getting to know each other. Do not assume they are already a couple.
- Avoid hearts, couple-app wording, anniversary language, pressure, tracking, or guilt-inducing copy.
- Keep copy quiet, warm, and low-pressure.
- Mobile UI comes first. Check 390px-class layouts for text clipping, overlapping, and awkward bottom navigation spacing.

## Code Organization Guardrails

- Follow `docs/code_structure.md` for new code and refactors.
- Do not add new feature screens or large panels to `lib/src/ui/alagagi_app.dart`.
- Put new user-facing feature UI under `lib/src/features/<feature>/`.
- Put reusable colors, typography, widgets, and sheet primitives under `lib/src/shared/`.
- Keep `alagagi_app.dart` as the temporary app root and route switchboard while extracting old screens incrementally.
- Prefer real Dart libraries over `part` files.

## Firebase Guardrails

- Never commit Firebase service account files, passwords, API secrets, or local password helper scripts.
- Firestore writes happen only on explicit user actions.
- Draft typing, scrolling, route changes, tab changes, calendar navigation, and music seen state must not create Firestore writes.
- Keep new Firebase-backed features inside the Spark/free-plan assumptions documented in `docs/spec/firestore.md`.

## Git Hygiene

- Do not revert user changes unless explicitly asked.
- Keep commits focused and name the user-facing behavior or harness change.
- Do not include ignored local helper files such as `change-passwords.js`.
- Before commit, check `git status --short` and staged diff scope.
