# Stocks Spec

## Purpose

Stocks let users share stock stories and holdings as conversation prompts, not financial advice or trading signals.

## Required Behavior

- Stock stories collect name, reason, upside, risk, and one question.
- Holdings collect name, status, weight label, reason, watch point, concern, and one question.
- Users can edit and delete their own holdings.
- Partner stories/holdings can receive replies.
- Lists should remain usable as item count grows through tabs/filters/detail sheets.

## Copy Rules

- Avoid buy/sell advice, returns, ranking, and pressure.
- Use reflective language such as `같이 보면 좋을 포인트`.

## Data Rules

- Story add/reply writes one story document.
- Holding add/edit/delete writes only the relevant holding document.
- Reply metadata stores reply body, tone, author, and replied label where applicable.

## Acceptance Criteria

- Same holding shared by both users can show `함께 보유 중`.
- Full detail sheets show long reason/risk/watch content.
- Partner-owned items do not expose owner-only edit/delete actions.
