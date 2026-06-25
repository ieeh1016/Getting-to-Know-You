# Domain Model Spec

## Purpose

This document defines the shared data vocabulary for `조금씩`.
Feature specs explain what users can do. This document explains which domain
objects represent that behavior, how those objects relate to Firestore, and
which user is allowed to change each record.

Use this document when a change touches:

- A model in `lib/src/domain/alagagi_controller.dart`.
- A Firestore mapper in `lib/src/data/firebase_alagagi_repositories.dart`.
- `firestore.rules` or [`../firebase_setup.md`](../firebase_setup.md).
- A flow that connects two features, such as meeting plans using saved places.

## Source Boundaries

- Feature behavior remains owned by the relevant feature spec.
- Firestore security details remain owned by [`firestore.md`](firestore.md) and
  `firestore.rules`.
- This document is the cross-feature model map. If it conflicts with a feature
  spec, update both documents before implementation.

## Shared Conventions

- `spaceId` identifies the private two-person space.
- `profileId` values are Firebase Auth UIDs for the two members.
- `createdByProfileId` is the original author and should not silently change.
- `updatedByProfileId` is the member who made the latest explicit save.
- `updatedAt` is written with a server timestamp in Firebase-backed flows.
- `createdLabel`, `repliedLabel`, and similar fields are user-facing display
  labels. They are not ordering keys.
- `dateKey` is a short date string, currently `YYYY-MM-DD`, based on the app's
  calendar logic.
- Draft typing, scrolling, tab switches, calendar movement, map movement, and
  local seen-state changes are not domain writes.

## Identity And Session

| Model | Storage | Role |
| --- | --- | --- |
| `AlagagiAuthUser` | Firebase Auth | Signed-in account identity. |
| `AppProfile` | `users/{uid}` | Display identity, partner link, and optional owner role. |
| `AlagagiSession` | Derived | Current `spaceId`, my profile, partner profile, and loaded space data. |
| `AlagagiSpaceData` | Derived from space subcollections | Read model used by screens and controller state. |
| `SpacePersonalization` | `spaces/{spaceId}` | App title/home copy/invite copy customization. |

The app is scoped to known members of a single private space. Public discovery,
multi-space browsing, and anonymous writes are outside the current domain.

## Feature Model Map

| Area | Domain models | Firestore storage | Ownership and write boundary |
| --- | --- | --- | --- |
| Questions | `DailyQuestion`, `Answer`, `AnswerComment`, `DailyQuestionProgress` | `answers`, `answerComments`, `progress/daily` | A member writes only their own answer. A comment is one per question/answer owner/commenter pair. The answer owner can add one reply to that comment. |
| Records | `ArchiveItem`, `QuestionCalendarDay`, `TimelineEvent`, `RelationshipInsight` | Derived from answers and catalog data | Read-only projections. They must not create writes while browsing, filtering, or changing months. |
| Taste match | `BalanceQuestion`, `BalanceOption`, `BalanceSelection` | `balanceSelections/{questionId_uid}` | A member writes/deletes their own selection. Reason is optional; result reveal is an explicit state. |
| Profile cards | `ProfileSlot`, `ProfileSlotValue`, `ProfileCardData` | `profileCards/{profileId}/slots/{slotId}` | A member writes their own slots. Custom slots can be deleted by the owning profile. |
| Wishlist | `WishItem` | `wishes/{wishId}` | Creator can delete. Interest and done state are shared fields, but writes must include the acting member in `likedByProfileIds`. |
| Music | `MusicNote` | `musicNotes/{noteId}` | Creator can create/edit/delete. Either member can explicitly update listen state without changing note content. |
| Schedule coordination | `ScheduleTimeBlock`, `ScheduleEntry`, `MeetingCandidate` | `scheduleEntries/{dateKey_uid}` | A member writes only their own date entry. Meeting-day markers live on schedule entries. |
| Meeting plans | `MeetingPlan` | `meetingPlans/{dateKey}` | Shared plan list for a fixed meeting day. The latest saver is captured by `updatedByProfileId`. |
| Places | `SharedPlace`, `MeetingPlaceLink` | `sharedPlaces/{placeId}` | Creator owns place content. Either interested member can update interest or meeting links through the narrow place-link path. Provider is Kakao only. |
| Curiosity | `CuriosityCard` | `curiosityCards/{cardId}` | Sender creates one question for the other member. Receiver writes the reply. |
| Stocks | `StockStory`, `StockHolding` | `stockStories`, `stockHoldings` | Creator writes initial story/holding. Partner replies to story; holding owner can edit holding details and partner can reply. |
| Improvements | `ImprovementPost` | `improvementPosts/{postId}` | Creator can create/edit/delete their post. Owner-role user can add owner note and mark resolved. |
| Diagnostics | `DiagnosticEvent` | `diagnosticEvents/{eventId}` | Operational save-failure records. Members can create; owner-role user can read. They are not user-facing content. |

## Cross-Feature Relationships

- `ScheduleEntry.isMeetingDay` makes a date eligible for the `만남` tab.
- `MeetingPlan.dateKey` is the shared plan record for that fixed meeting day.
- `SharedPlace.meetingPlanLinks` connects saved places to meeting dates and can
  include a `reservationTimeLabel`.
- `WishItem.kind == place` and `SharedPlace` are related user concepts but are
  separate domain records. Wishlist ideas do not automatically create places.
- `Answer`, `AnswerComment`, and `CuriosityCard` are separate question flows.
  Do not merge their storage or notification states without a spec change.
- Home unread activity is a derived summary across feature records and local
  seen state. It should not create Firestore writes while rendering.

## Write Design Checklist

Before adding or changing a Firebase-backed model:

1. Name the domain model and owner fields in this document.
2. Add or update the feature spec behavior.
3. Add the Firestore path to [`firestore.md`](firestore.md).
4. Update `firestore.rules` and [`../firebase_setup.md`](../firebase_setup.md)
   together.
5. Keep one explicit user action to one document write unless a spec explicitly
   approves a batch.
6. Add a harness or domain test when a repository field must be accepted by
   Firestore Rules.

## Current Implementation Note

Most models still live in `lib/src/domain/alagagi_controller.dart` during the
ongoing extraction. As UI modules move out of `lib/src/ui/alagagi_app.dart`,
new or heavily changed domain models should move toward the target
`lib/src/domain/models/`, `lib/src/domain/repositories/`, and
`lib/src/domain/controller/` shape described in
[`../code_structure.md`](../code_structure.md).
