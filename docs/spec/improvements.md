# Improvement Board Spec

## Purpose

The improvement board lets users leave ideas, requests, and feedback about the app itself.

## Required Behavior

- Users can add posts with title, body, and category.
- Post owners can edit and delete their posts.
- The board is accessible from the home menu.
- UI should feel like a lightweight internal board, not a public forum.

## Data Rules

- Each post stores `id`, `title`, `body`, `category`, `createdByProfileId`, `createdLabel`, and `updatedAt`.
- Delete is owner-only.

## Acceptance Criteria

- Empty states explain that ideas can be left later.
- Owner-only actions do not appear on partner posts.
- Long post bodies open or display readably.
