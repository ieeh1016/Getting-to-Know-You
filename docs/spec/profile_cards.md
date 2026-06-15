# Profile Cards Spec

## Purpose

Profile cards let users share small self-introduction answers at their own pace.

## Required Behavior

- Partner tab shows only filled partner cards as readable cards.
- My tab supports filling, editing, skipping, restoring, and hiding awkward prompts.
- Users can add custom profile cards.
- Custom cards created by one user can appear for the other user.
- UI should feel like a polished card notebook, not a form dump.

## Data Rules

- Slot values are stored under `profileCards/{profileId}/slots/{slotId}`.
- Users can create/update/delete only their own slot values unless rules explicitly allow shared custom-card metadata.
- Hidden/skipped states must remain recoverable.

## Acceptance Criteria

- Empty partner slots do not appear as partner content.
- Awkward default prompts can be hidden or skipped.
- Custom cards survive reload and appear in the appropriate card set.
