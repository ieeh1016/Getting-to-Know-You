# Firestore And Data Policy Spec

## Purpose

This spec defines Firebase, Firestore, security, and Spark/free-plan boundaries for all features.

## Global Rules

- Two-person private space only.
- No public sign-up or multi-space discovery in MVP.
- No Cloud Functions dependency unless explicitly approved.
- No Storage media uploads, TTL, PITR, backup, restore, clone, or scheduled jobs for MVP.
- No secrets, service account JSON, raw API keys beyond approved public client config, or private payload dumps in the repo.

## Write Budget Rules

- Typing, scrolling, route changes, tab changes, calendar navigation, map movement, and seen-state reads must not create Firestore writes.
- Explicit save/select/edit/delete actions should write one document unless a feature spec says otherwise.
- Batch writes require a spec note and test coverage.

## Current Collections

- `spaces/{spaceId}/answers/{questionId_uid}`
- `spaces/{spaceId}/answerComments/{questionId_ownerUid_commenterUid}`
- `spaces/{spaceId}/progress/{progressId}`
- `spaces/{spaceId}/balanceSelections/{questionId_uid}`
- `spaces/{spaceId}/profileCards/{profileId}/slots/{slotId}`
- `spaces/{spaceId}/wishes/{wishId}`
- `spaces/{spaceId}/musicNotes/{noteId}`
- `spaces/{spaceId}/scheduleEntries/{dateKey_uid}`
- `spaces/{spaceId}/sharedPlaces/{placeId}`
- `spaces/{spaceId}/diagnosticEvents/{eventId}`
- `spaces/{spaceId}/curiosityCards/{cardId}`
- `spaces/{spaceId}/stockStories/{storyId}`
- `spaces/{spaceId}/stockHoldings/{holdingId}`
- `spaces/{spaceId}/improvementPosts/{postId}`

## Rules Maintenance

- Update [`../firebase_setup.md`](../firebase_setup.md) when `firestore.rules` changes.
- Rules must validate ownership, string bounds, list bounds, and allowed enum values where practical.
- A feature is not complete until rules allow the intended valid writes and reject obvious cross-user writes.
- Update [`domain_model.md`](domain_model.md) when adding a collection, owner field, or cross-feature reference.
