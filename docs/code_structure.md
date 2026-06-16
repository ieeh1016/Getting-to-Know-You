# Code Structure Guide

This app is being migrated away from a single large UI file into feature-first
Flutter modules. New work should move in this direction instead of adding more
screen code to `lib/src/ui/alagagi_app.dart`.

## Target Shape

```text
lib/src/app/
  app_shell.dart
  test_keys.dart

lib/src/shared/
  ui_style.dart
  ui_components.dart
  widgets/
  sheets/

lib/src/features/<feature>/
  <feature>_screen.dart
  <feature>_panel.dart
  <feature>_sheet.dart

lib/src/domain/
  models/
  repositories/
  controller/
```

The app can stay in one Flutter package for now. Split into separate Dart or
Flutter packages only when there is a concrete need for reuse, independent
publishing, or Flutter-free domain testing.

## Current Migration Rules

- Do not add new feature screens or large panels to `lib/src/ui/alagagi_app.dart`.
- Put new user-facing feature UI under `lib/src/features/<feature>/`.
- Put reusable visual primitives, typography, colors, buttons, and sheet helpers
  under `lib/src/shared/`.
- Put cross-file test keys under `lib/src/app/test_keys.dart` when a widget is
  moved out of `alagagi_app.dart`.
- Keep `alagagi_app.dart` as the temporary app root, route switchboard, and
  compatibility export while migration is in progress.
- Avoid `part` files for this migration. Prefer real Dart libraries with clear
  imports.
- When touching an old screen inside `alagagi_app.dart`, consider extracting the
  touched widget or panel as part of the same change if the behavior risk is
  manageable.

## Current Extracted Modules

- `lib/src/shared/ui_style.dart`: shared colors and typography helpers.
- `lib/src/shared/ui_components.dart`: shared buttons, cards, chips, labels,
  brand marks, avatar stacks, badges, quiet metrics, text fields, inline text
  actions, progress indicators, and inline empty states used across feature
  screens.
- `lib/src/shared/readable_detail_sheet.dart`: Reusable full-text bottom sheet
  for long answers, notes, comments, profile cards, music, stocks, and posts,
  including shared readable-preview cues and open-full icon controls.
- `lib/src/app/test_keys.dart`: cross-file widget keys for extracted widgets.
- `lib/src/app/app_shell.dart`: reusable screen scroll shell, bottom navigation,
  and sub-screen top bar.
- `lib/src/features/home/unread_activity_panel.dart`: Home unread activity
  preview and full-list sheet.
- `lib/src/features/home/first_visit_guide_overlay.dart`: First-visit Home
  onboarding overlay.
- `lib/src/features/home/curiosity_menu_sheet.dart`: Home curiosity question and
  reply bottom sheet.
- `lib/src/features/home/home_progress_summary_card.dart`: Home progress summary
  card.
- `lib/src/features/home/home_header.dart`: Home brand header, menu sheet, and
  progress strip.
- `lib/src/features/home/home_insight_grid.dart`: Home answer/record summary
  metric grid.
- `lib/src/features/home/home_plus_grid.dart`: Home plus-feature launcher grid.
- `lib/src/features/improvements/improvement_board_screen.dart`: Improvement
  board, request draft form, owner edit/delete actions, and save status UI.
- `lib/src/features/my/my_screen.dart`: My dashboard, next actions, recent
  traces, help, and account card.
- `lib/src/features/music/music_screen.dart`: Music note list, filters, draft
  editor, listened state, and link actions.
- `lib/src/features/meeting/meeting_common.dart`: Meeting date labels, time
  labels, save status, and shared schedule text field widgets.
- `lib/src/features/meeting/meeting_screen.dart`: Schedule coordination tab,
  including calendar readability markers, detailed schedule input, and fixed
  meeting-day controls.
- `lib/src/features/meeting/meeting_plan_screen.dart`: Fixed meeting day plan
  tab, including date strip, shared plan items, and linked place candidates.
- `lib/src/features/place/place_common.dart`: Shared place category labels,
  icons, and save status widget used by meeting plans and the place board.
- `lib/src/features/place/place_board_screen.dart`: Place board tab, Kakao
  place search, map preview/fallback UI, and shared place card actions.
- `lib/src/features/stocks/stock_story_screen.dart`: Stock story and holdings
  tabs, draft forms, filters, reply composers, and owner edit/delete actions.
- `lib/src/features/wishlist/wishlist_screen.dart`: Shared wishlist board,
  wish draft form, filters, mutual-interest lanes, and wish cards.
- `lib/src/features/balance/balance_screen.dart`: Taste match deck, result
  privacy flow, result box, and personal taste note tabs.
- `lib/src/features/profile/profile_card_screen.dart`: Profile card tabs,
  custom card creation, category filters, editor panels, hidden slots, and
  read-only partner card views.
- `lib/src/features/questions/question_view_switch.dart`: Shared archive/records
  segmented switch for question-related views.
- `lib/src/features/records/records_screen.dart`: Relationship insight summary,
  matched keywords, stats grid, and timeline view.

## Extraction Order

1. Shared foundations: colors, typography, common keys, buttons, sheet shells.
2. Home panels and sheets.
3. Bottom-tab feature screens: music, meetings, places, my.
4. Menu feature screens: profile cards, wishlist, stocks, improvements, taste
   match.
5. Domain model/repository/controller split after UI dependencies are lower.

## Completion Criteria

Every extraction should preserve behavior and include focused verification:

- `dart analyze` for moved files and their callers.
- Relevant widget/domain tests.
- `flutter build web` for visible or routing-level changes.
