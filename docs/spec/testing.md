# Testing And Verification Spec

## Purpose

Testing keeps SDD changes traceable and prevents UI regressions in a mobile-first Flutter Web app.

## Required Gates

- `dart analyze`
- Relevant `flutter test` target(s)
- `flutter build web` for significant frontend changes
- Browser verification for visible layout or interaction changes

## Test Strategy

- Domain tests cover state transitions, persistence calls, and write budgets.
- Widget tests cover visible Korean copy, navigation, editing, filters, and owner/partner actions.
- Firestore-related changes include rules/doc updates and at least one repository/controller test when practical.
- UI changes should verify long Korean text, 390px-class layout, bottom navigation spacing, and absence of overlapping content.
- Refactors that extract UI from `alagagi_app.dart` must preserve existing widget keys and run focused tests for the moved feature.

## Code Structure Verification

- New feature UI should be placed under `lib/src/features/<feature>/`.
- Shared styling and primitives should be placed under `lib/src/shared/`.
- Cross-file widget keys should live under `lib/src/app/test_keys.dart`.
- `docs/code_structure.md` is the implementation guide for ongoing file/module extraction.

## Fail-First Preference

- For behavior changes, add or adjust a test before implementation when practical.
- If fail-first is skipped because the change is purely structural or documentation-only, mention that in the handoff.
