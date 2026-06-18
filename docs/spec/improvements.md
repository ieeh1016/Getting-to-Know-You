# Improvement Board Spec

## Purpose

The improvement board lets users leave ideas, requests, and feedback about the app itself.

## Required Behavior

- Users can add posts with title, body, and category.
- Post owners can edit and delete their posts.
- Only the owner account can leave implementation replies and mark posts as complete.
- Completed posts move out of the default open list and into the completed filter.
- The board is accessible from the home menu.
- UI should feel like a lightweight internal board, not a public forum.

## Data Rules

- Each post stores `id`, `title`, `body`, `category`, `createdByProfileId`, `createdLabel`, owner reply fields, completion fields, and `updatedAt`.
- Delete is owner-only.
- Firestore rules allow implementation replies and completion changes only for `users/{uid}.role == "owner"`.

## Acceptance Criteria

- Empty states explain that ideas can be left later.
- Owner-only actions do not appear on partner posts.
- Non-owner users can read owner replies but cannot write them or mark posts complete.
- Completed posts are available in a dedicated completed filter.
- Long post bodies open or display readably.
