# Meetings Spec

## Purpose

Meetings help the two users coordinate available dates, mark a confirmed meeting day, and plan what to do on fixed days.

## Required Behavior

- Calendar shows my entries, partner entries, mutual availability, selected date, and confirmed meeting days distinctly.
- A user can add detailed time blocks with start/end time and title.
- A user can mark a mutually useful date as a meeting day.
- Meeting day details use free-form copy rather than forcing rigid time presets.
- The `만남` tab lists only fixed meeting days and lets users organize plans for that day.
- Plan copy uses `영우·민영의 계획`.

## Data Rules

- Schedule entries are stored per `dateKey` and profile.
- Meeting day details live on the selected schedule entry shape.
- Editing a date writes only the relevant schedule document.

## Acceptance Criteria

- Calendar indicators stay visible together when both people have entries.
- Selected date styling is distinguishable from fixed meeting day styling.
- Fixed meeting plan can add and remove plan items.
- Place-board links can be imported into meeting plans without breaking place ownership.
