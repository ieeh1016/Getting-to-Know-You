# Modular Product Spec

`조금씩` now uses a modular SPEC structure.

## Document Roles

- [`../spec.md`](../spec.md): entry point and global rules.
- Feature specs in this directory: current product truth for each user-facing area.
- [`legacy_full_spec.md`](legacy_full_spec.md): archived monolithic spec. Use for historical context, not as the primary source.
- [`../test_plan.md`](../test_plan.md): verification plan derived from these specs.
- [`../firebase_setup.md`](../firebase_setup.md): Firebase setup and rules guide derived from [`firestore.md`](firestore.md).

## Change Workflow

1. Identify the relevant feature spec.
2. Update that spec before changing behavior.
3. Update the test plan and tests.
4. Implement the smallest change that satisfies the spec.
5. Run the relevant verification gate.

## Product Principles

- Quiet, private, mobile-first.
- Gentle curiosity over performance or obligation.
- Shared records over live chat.
- Explicit actions over background tracking.
- Clear separation between private notes, shared entries, and revealed results.

## Current Feature Map

| Area | Spec |
| --- | --- |
| Home, navigation, first visit | [`home.md`](home.md) |
| Daily questions, answers, archive, records | [`questions.md`](questions.md) |
| Taste match | [`taste_match.md`](taste_match.md) |
| Schedule coordination and fixed meeting plans | [`meetings.md`](meetings.md) |
| Kakao map place board | [`places.md`](places.md) |
| Music notes | [`music.md`](music.md) |
| Stock stories and holdings | [`stocks.md`](stocks.md) |
| Profile cards | [`profile_cards.md`](profile_cards.md) |
| Wishlist | [`wishlist.md`](wishlist.md) |
| Improvement board | [`improvements.md`](improvements.md) |
| Firestore data/rules/budget | [`firestore.md`](firestore.md) |
| Testing | [`testing.md`](testing.md) |
