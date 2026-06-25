# Archived SDD Notes

> Status: archived.
> Current source of truth: [`spec.md`](spec.md) and the feature specs under [`spec/`](spec/).

This file used to hold the early single-document SDD notes for the first MVP.
The active development workflow has moved to the modular spec structure:

1. Update [`spec.md`](spec.md) or the relevant feature spec under [`spec/`](spec/).
2. Update [`test_plan.md`](test_plan.md).
3. Add or adjust tests.
4. Implement and verify.

## Current Active Documents

- [`spec.md`](spec.md): product entry point and global rules.
- [`spec/README.md`](spec/README.md): spec document ownership and feature map.
- [`test_plan.md`](test_plan.md): verification plan and regression intent.
- [`code_structure.md`](code_structure.md): implementation structure guide.
- [`agent_harness_playbook.md`](agent_harness_playbook.md): multi-agent development guide.
- [`firebase_setup.md`](firebase_setup.md): Firebase setup and Firestore Rules guide.

## Historical Context

Older product decisions are preserved in
[`spec/legacy_full_spec.md`](spec/legacy_full_spec.md). Use that archive only
for background context. If it conflicts with `spec.md` or a feature spec, the
current modular spec wins.
