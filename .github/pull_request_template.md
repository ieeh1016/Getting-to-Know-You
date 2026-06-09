## Summary

- 

## SDD / TDD Checklist

- [ ] `docs/spec.md` was updated before production behavior changed.
- [ ] `docs/test_plan.md` was updated for the new or changed behavior.
- [ ] Domain/widget tests were added or adjusted where behavior changed.
- [ ] The smallest production change was made after the spec/test intent was clear.

## Product / Firebase Checks

- [ ] User-facing copy stays quiet and does not assume a couple relationship.
- [ ] Mobile layout was considered for 390px-class screens.
- [ ] Firestore writes happen only on explicit user actions.
- [ ] Firebase Spark/free-plan boundaries remain acceptable.
- [ ] No secrets, passwords, service account files, or local helper scripts are included.

## Verification

- [ ] `dart analyze`
- [ ] `flutter test`
- [ ] `flutter build web` when deployment or visible web UI is affected

