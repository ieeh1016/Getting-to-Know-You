# Places Spec

## Purpose

Places let users search Kakao Map, save places they want to visit, and connect places to meeting plans.

## Required Behavior

- Only Kakao Map is used for map/search UI.
- The map has enough vertical space to be useful.
- Map drag/scroll gestures must not accidentally scroll the whole page.
- Map overlay UI can be temporarily hidden.
- A place can be saved with name, address, category/source metadata, note, coordinates when available, and creator profile.
- Place cards support interest and meeting-plan linking where relevant.
- The UI should not over-emphasize Kakao branding beyond what is needed for API attribution.

## Data Rules

- Place save writes one shared place document.
- Interest/link operations update only the relevant place or meeting entry.
- Location tracking is out of scope; saved coordinates come from selected place results only.

## Acceptance Criteria

- If Kakao map fails to render, the app retries refresh/init once.
- Place save works under Firestore rules.
- Page scroll does not move while dragging the map vertically.
- Place lists remain readable as the count grows.
