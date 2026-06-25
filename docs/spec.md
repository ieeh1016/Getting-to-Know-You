# 조금씩 Product Spec Index

> Source of truth: this index plus the feature specs in [`docs/spec/`](spec/).
> The previous monolithic spec is preserved as [`docs/spec/legacy_full_spec.md`](spec/legacy_full_spec.md) for migration context only.

## How To Use

1. Start with [`docs/spec/README.md`](spec/README.md) for product principles, scope rules, and document ownership.
2. Open the relevant feature spec before changing behavior.
3. For data, rules, or cross-feature changes, also open [`docs/spec/domain_model.md`](spec/domain_model.md).
4. Update the feature spec first, then [`docs/test_plan.md`](test_plan.md), then tests and implementation.
5. If specs conflict, the more specific feature spec wins over the legacy archive.

## Supporting Documents

- [`docs/code_structure.md`](code_structure.md): implementation structure and extraction guide.
- [`docs/spec/domain_model.md`](spec/domain_model.md): shared domain model, ownership, and Firestore mapping guide.
- [`docs/firebase_setup.md`](firebase_setup.md): Firebase setup and canonical Firestore Rules documentation.
- [`docs/map_open_api_guide.md`](map_open_api_guide.md): Kakao Map API setup and operation guide for the Places feature.
- [`docs/agent_harness_playbook.md`](agent_harness_playbook.md): development-only multi-agent workflow guide.
- [`docs/sdd.md`](sdd.md): archived SDD redirect. Do not use it as a behavior source of truth.

## Feature Specs

- [Home and navigation](spec/home.md)
- [Domain model](spec/domain_model.md)
- [Questions and records](spec/questions.md)
- [Taste match](spec/taste_match.md)
- [Meetings](spec/meetings.md)
- [Places](spec/places.md)
- [Music](spec/music.md)
- [Stocks](spec/stocks.md)
- [Profile cards](spec/profile_cards.md)
- [Wishlist](spec/wishlist.md)
- [Improvement board](spec/improvements.md)
- [Firestore and data policy](spec/firestore.md)
- [Testing and verification](spec/testing.md)

## Global Rules

- The app is a private, low-pressure space for two people to learn about each other gradually.
- Do not use couple-app pressure, anniversary language, public social-network mechanics, scores, percentages, or ranking copy.
- Avoid hearts and overt romantic commitment signals in core UI.
- User-generated data must remain explicit-save oriented. Typing, scrolling, route changes, tab changes, and map movement must not create Firestore writes.
- New Firebase-backed features must fit Spark/free-plan assumptions unless the user explicitly approves a paid dependency.
- Behavior changes must be traceable from spec to tests to implementation.
