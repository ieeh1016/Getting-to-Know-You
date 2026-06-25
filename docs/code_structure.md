# Code Structure Guide

이 앱은 하나의 큰 UI file에서 feature-first Flutter module 구조로 이동 중이다.
새 작업은 `lib/src/ui/alagagi_app.dart`에 screen code를 더 쌓기보다 이 방향으로 진행한다.

## 목표 구조

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

지금은 앱을 하나의 Flutter package로 유지한다. 재사용, 독립 배포, Flutter-free domain testing이 실제로 필요해질 때만 별도 Dart 또는 Flutter package로 나눈다.

## 현재 Migration 규칙

- 새 feature screen이나 큰 panel을 `lib/src/ui/alagagi_app.dart`에 추가하지 않는다.
- 새 user-facing feature UI는 `lib/src/features/<feature>/` 아래에 둔다.
- 재사용 가능한 visual primitive, typography, color, button, sheet helper는 `lib/src/shared/` 아래에 둔다.
- widget을 `alagagi_app.dart` 밖으로 옮길 때 cross-file test key는 `lib/src/app/test_keys.dart`에 둔다.
- migration 중에는 `alagagi_app.dart`를 임시 app root, route switchboard, compatibility export로 유지한다.
- 이 migration에서는 `part` file을 피한다. 명확한 import를 가진 실제 Dart library를 선호한다.
- `alagagi_app.dart` 안의 old screen을 건드릴 때 behavior risk가 관리 가능하다면 같은 변경에서 해당 widget 또는 panel 추출을 검토한다.

## 현재 추출된 Module

- `lib/src/shared/ui_style.dart`: shared colors와 typography helper.
- `lib/src/shared/ui_components.dart`: feature screen 전반에서 쓰는 shared button, card, chip, label, brand mark, avatar stack, badge, quiet metric, text field, inline text action, progress indicator, inline empty state.
- `lib/src/shared/readable_detail_sheet.dart`: 긴 answer, note, comment, profile card, music, stock, post를 위한 reusable full-text bottom sheet. shared readable-preview cue와 open-full icon control을 포함한다.
- `lib/src/app/test_keys.dart`: 추출된 widget을 위한 cross-file widget key.
- `lib/src/app/app_shell.dart`: reusable screen scroll shell, bottom navigation, sub-screen top bar.
- `lib/src/features/home/unread_activity_panel.dart`: Home unread activity preview와 full-list sheet.
- `lib/src/features/home/first_visit_guide_overlay.dart`: first-visit Home onboarding overlay.
- `lib/src/features/home/first_visit_guide_book_sheet.dart`: first-visit와 My screen help entry point에서 열리는 reusable guide book bottom sheet.
- `lib/src/features/home/curiosity_menu_sheet.dart`: Home curiosity question과 reply bottom sheet.
- `lib/src/features/home/home_progress_summary_card.dart`: Home progress summary card.
- `lib/src/features/home/home_header.dart`: Home brand header, menu sheet, progress strip.
- `lib/src/features/home/home_insight_grid.dart`: Home answer/record summary metric grid.
- `lib/src/features/home/home_plus_grid.dart`: Home plus-feature launcher grid.
- `lib/src/features/home/home_screen.dart`: Home screen composition, today's question card, partner answer preview, Home feature sections.
- `lib/src/features/auth/auth_screens.dart`: login, loading, Firebase setup guidance, invite, shared auth-note UI screen.
- `lib/src/features/answer/answer_screen.dart`: today/late-answer editor, answer hint, partner lock copy, save retry control.
- `lib/src/features/archive/archive_screen.dart`: question archive calendar, selected-date detail, late-answer entry point, archive filter, archived answer card.
- `lib/src/features/improvements/improvement_board_screen.dart`: improvement board, request draft form, owner edit/delete action, save status UI.
- `lib/src/features/my/my_screen.dart`: My dashboard, next action, recent traces, help, account card.
- `lib/src/features/music/music_screen.dart`: music note list, filter, draft editor, listened state, link action.
- `lib/src/features/meeting/meeting_common.dart`: meeting date label, time label, save status, shared schedule text field widget.
- `lib/src/features/meeting/meeting_screen.dart`: schedule coordination tab. calendar readability marker, detailed schedule input, fixed meeting-day control을 포함한다.
- `lib/src/features/meeting/meeting_plan_screen.dart`: fixed meeting day plan tab. date strip, shared plan item, linked place candidate를 포함한다.
- `lib/src/features/place/place_common.dart`: meeting plan과 place board에서 쓰는 shared place category label, icon, save status widget.
- `lib/src/features/place/place_board_screen.dart`: place board tab, Kakao place search, map preview/fallback UI, shared place card action.
- `lib/src/features/stocks/stock_story_screen.dart`: stock story와 holding tab, draft form, filter, reply composer, owner edit/delete action.
- `lib/src/features/wishlist/wishlist_screen.dart`: shared wishlist board, wish draft form, filter, mutual-interest lane, wish card.
- `lib/src/features/balance/balance_screen.dart`: taste match deck, result privacy flow, result box, personal taste note tab.
- `lib/src/features/profile/profile_card_screen.dart`: profile card tab, custom card creation, category filter, editor panel, hidden slot, read-only partner card view.
- `lib/src/features/questions/question_view_switch.dart`: question-related view를 위한 shared archive/records segmented switch.
- `lib/src/features/questions/answer_save_status.dart`: Home과 Archive에서 쓰는 shared answer save feedback과 retry status row.
- `lib/src/features/questions/answer_blocks.dart`: Home과 Archive에서 쓰는 shared answer preview, answer line, comment composer, read-only comment, question support block.
- `lib/src/features/questions/question_formatters.dart`: answer/archive flow를 위한 shared question date display helper.
- `lib/src/features/records/records_screen.dart`: relationship insight summary, matched keywords, stats grid, timeline view.

## 추출 순서

1. shared foundation: colors, typography, common keys, buttons, sheet shells.
2. Home panels와 sheets.
3. bottom-tab feature screens: music, meetings, places, my.
4. menu feature screens: profile cards, wishlist, stocks, improvements, taste match.
5. UI dependency가 낮아진 뒤 domain model/repository/controller split.

## 완료 기준

모든 extraction은 behavior를 보존하고 focused verification을 포함해야 한다.

- 이동한 files와 caller에 대한 `dart analyze`.
- 관련 widget/domain tests.
- visible 또는 routing-level change에는 `flutter build web`.
