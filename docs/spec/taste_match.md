# Taste Match Spec

## Purpose

Taste match is a lightweight choice game for discovering preferences. It should feel quick, private by default, and useful later.

## Current UX Structure

The screen is split into three tabs:

- `오늘`: choose today's card, optionally add a reason, and reveal only the current card result.
- `결과함`: view waiting, locked, and revealed results.
- `내 노트`: view only my choices and my reasons.

## Required Behavior

- Selecting a card saves the choice immediately.
- Tapping the already-selected card keeps the selection; it does not clear it.
- Tapping the other card changes the selection.
- Reason text is optional and auto-saved after a short delay.
- Results are not shown automatically.
- Partner choice, same/different state, and comparison copy appear only after `결과 열어보기`.
- `내 노트` never shows partner choice or same/different state.
- `결과함` may show that a result is ready, but must hide comparison details until reveal.

## Data Rules

- `balanceSelections` stores `questionId`, `profileId`, `optionId`, optional `reason`, optional `resultRevealedAt`, and `updatedAt`.
- Result reveal state is personal. A user revealing a result does not force the partner's UI open.
- Reason typing must not write on every keystroke; it is debounced.

## Acceptance Criteria

- Before reveal, no partner option label is visible.
- Before reveal, no `같음`, `다름`, score, percent, or compatibility copy is visible.
- A revealed result remains revealed after reload when Firestore data includes `resultRevealedAt`.
- The default `오늘` tab is short enough to keep the choice flow focused.
