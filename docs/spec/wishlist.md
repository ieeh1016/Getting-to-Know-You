# Wishlist Spec

## Purpose

Wishlist, shown as `언젠가, 같이`, captures things the two users might want to do together.

## Required Behavior

- A user can add a place or activity wish.
- A user can mark interest in a wish.
- A user can mark a wish done where appropriate.
- Filters help separate all, mutual, places, and activities.
- Copy should stay low-pressure: `관심`, `같이 해보고 싶은`, not commitment-heavy language.

## Data Rules

- Wish documents store creator, kind, title, optional note/icon, interest profile IDs, done state, created/updated timestamps.
- Add/interest/done actions should write at most one wish document.

## Acceptance Criteria

- Mutual interest is visible without romantic pressure.
- Long wish lists remain scannable with filters.
- Owner and partner actions are clear and do not conflict.
