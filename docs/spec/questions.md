# Questions And Records Spec

## Purpose

Daily questions are the core slow-conversation loop. Records and archive preserve answers without turning the app into chat.

## Required Behavior

- One active daily question is selected by shared progress data.
- A user can write, save, edit, and retry their answer.
- Partner answer remains locked until the user's answer is saved.
- Answer comments are short, explicit-save notes on opened partner answers.
- Archive supports all, both answered, and similar-answer filters.
- Record screen may show shared-answer summaries and matched keywords without scores or percentages.

## Data Rules

- Draft typing is local state only.
- Answer submit/edit writes at most one answer document.
- Comment create/update writes at most one comment document.
- Skipped or empty answers must not appear as saved answer content.

## Acceptance Criteria

- Answer save failure keeps retry UI visible.
- Partner answer and comment composer stay locked while my answer is unsaved or failed.
- Late answer writes use the stable `{questionId}_{uid}` answer key.
- Question calendar day state derives from progress and answer data.
