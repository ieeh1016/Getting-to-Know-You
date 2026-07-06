## Summary

- 

## SDD / TDD Checklist

- [ ] `docs/spec.md` was updated before production behavior changed.
- [ ] `docs/test_plan.md` was updated for the new or changed behavior.
- [ ] Domain/widget tests were added or adjusted where behavior changed.
- [ ] The smallest production change was made after the spec/test intent was clear.
- [ ] If multiple AI agents contributed, `docs/agent_harness_playbook.md` handoff and file-ownership rules were followed.

## Product / Firebase Checks

- [ ] User-facing copy stays quiet and does not assume a couple relationship.
- [ ] Mobile layout was considered for 390px-class screens.
- [ ] Firestore writes happen only on explicit user actions.
- [ ] `firestore.rules` and `docs/firebase_setup.md` stayed in sync when rules changed.
- [ ] Firebase deploy remains main-branch only and uses `firebase.json` -> `firestore.rules` plus `functions/`.
- [ ] Firebase Spark/free-plan boundaries remain acceptable.
- [ ] No secrets, passwords, service account files, or local helper scripts are included.

## Verification

- [ ] `./scripts/check_firestore_rules_sync.sh`
- [ ] `dart analyze`
- [ ] `flutter test`
- [ ] `flutter build web` when deployment or visible web UI is affected
