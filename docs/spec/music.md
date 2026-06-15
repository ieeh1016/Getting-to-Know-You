# Music Spec

## Purpose

Music notes let users share songs, notes, and whether they have listened, without turning the screen into a long unfiltered list.

## Required Behavior

- A user can add a song title, artist, optional link, mood, and note.
- A user can edit their own music note.
- Partner notes are read-only except for listen-state actions.
- Listen emoji/state can be toggled without opening the detail sheet.
- List filtering helps when music count grows.
- New/unseen partner additions can surface in home summary.

## Data Rules

- Add/edit writes refresh `updatedAt`.
- Listen-state writes update only `listenedByProfileIds`; they do not refresh `updatedAt`.
- External links are normalized before opening.

## Acceptance Criteria

- Music list prioritizes useful unread/unlistened states.
- Edit action appears only on my notes.
- Link action opens the normalized URL through the external link opener.
- Long notes open in a readable detail sheet.
