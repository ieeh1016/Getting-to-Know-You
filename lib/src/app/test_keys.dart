import 'package:flutter/material.dart';

const bottomNavigationKey = Key('bottom-navigation');
const subScreenBackButtonKey = Key('sub-screen-back-button');
const musicTitleFieldKey = Key('music-title-field');
const musicArtistFieldKey = Key('music-artist-field');
const musicLinkFieldKey = Key('music-link-field');
const musicNoteFieldKey = Key('music-note-field');
const musicSubmitButtonKey = Key('music-submit-button');
const musicAddButtonKey = Key('music-add-button');
Key musicEditButtonKey(String noteId) => Key('music-edit-button-$noteId');
Key musicLinkButtonKey(String noteId) => Key('music-link-button-$noteId');
Key musicListenedButtonKey(String noteId) =>
    Key('music-listened-button-$noteId');
Key musicListFilterButtonKey(String filter) => Key('music-list-filter-$filter');
Key musicNoteCardKey(String noteId) => Key('music-note-card-$noteId');
const unreadActivityPanelKey = Key('unread-activity-panel');
const unreadActivityClearButtonKey = Key('unread-activity-clear-button');
const unreadActivityMoreButtonKey = Key('unread-activity-more-button');
const unreadActivitySheetKey = Key('unread-activity-sheet');
const homeProgressSummaryKey = Key('home-progress-summary');
const homeProgressSummaryCtaKey = Key('home-progress-summary-cta');
const homeBrandLogoKey = Key('home-brand-logo');
const homeMenuButtonKey = Key('home-menu-button');
const homeMenuSheetKey = Key('home-menu-sheet');
const homeMenuCuriosityButtonKey = Key('home-menu-curiosity-button');
const homeMenuStockStoryButtonKey = Key('home-menu-stock-story-button');
const homeMenuImprovementButtonKey = Key('home-menu-improvement-button');
const homeMenuBalanceButtonKey = Key('home-menu-balance-button');
const homeMenuProfileCardButtonKey = Key('home-menu-profile-card-button');
const homeMenuWishlistButtonKey = Key('home-menu-wishlist-button');
const homeMenuGuideButtonKey = Key('home-menu-guide-button');
const homeCuriositySheetKey = Key('home-curiosity-sheet');
const curiosityQuestionFieldKey = Key('curiosity-question-field');
const curiosityQuestionSubmitButtonKey = Key(
  'curiosity-question-submit-button',
);
const curiosityReplyFieldKey = Key('curiosity-reply-field');
const curiosityReplySubmitButtonKey = Key('curiosity-reply-submit-button');
const firstVisitGuideSheetKey = Key('first-visit-guide-sheet');
const firstVisitGuideStartButtonKey = Key('first-visit-guide-start-button');
const firstVisitGuideTourButtonKey = Key('first-visit-guide-tour-button');
const myDashboardKey = Key('my-dashboard');
const myNextPrimaryButtonKey = Key('my-next-primary-button');
const myProfileCardActionButtonKey = Key('my-profile-card-action-button');
const myMusicActionButtonKey = Key('my-music-action-button');
const myFirstVisitGuideButtonKey = Key('my-first-visit-guide-button');
Key myTraceCardKey(String type) => Key('my-trace-card-$type');

const meetingCalendarKey = Key('meeting-calendar');
const meetingSharedMemoFieldKey = Key('meeting-shared-memo-field');
const meetingSubmitButtonKey = Key('meeting-submit-button');
const meetingRetryButtonKey = Key('meeting-retry-button');
const meetingTimeBlockStartFieldKey = Key('meeting-time-block-start-field');
const meetingTimeBlockEndFieldKey = Key('meeting-time-block-end-field');
const meetingTimeBlockTitleFieldKey = Key('meeting-time-block-title-field');
const meetingTimeBlockAddButtonKey = Key('meeting-time-block-add-button');
const meetingDayTimeFieldKey = Key('meeting-day-time-field');
const meetingDayNoteFieldKey = Key('meeting-day-note-field');
const meetingDayPlanFieldKey = Key('meeting-day-plan-field');
const meetingDaySaveButtonKey = Key('meeting-day-save-button');
const meetingPlanScreenKey = Key('meeting-plan-screen');
const meetingPlanDraftFieldKey = Key('meeting-plan-draft-field');
const meetingPlanItemAddButtonKey = Key('meeting-plan-item-add-button');
const meetingPlanSaveButtonKey = Key('meeting-plan-save-button');
const meetingPlanPlaceMoreButtonKey = Key('meeting-plan-place-more-button');
Key meetingTimeBlockPresetButtonKey(String presetId) =>
    Key('meeting-time-block-preset-$presetId');
Key meetingDateButtonKey(String dateKey) => Key('meeting-date-$dateKey');
Key meetingPlanDateButtonKey(String dateKey) =>
    Key('meeting-plan-date-$dateKey');
Key meetingPlanPlaceLinkButtonKey(String placeId) =>
    Key('meeting-plan-place-link-$placeId');
Key meetingPlanItemRemoveButtonKey(int index) =>
    Key('meeting-plan-item-remove-$index');
Key meetingDayIndicatorKey(String dateKey) =>
    Key('meeting-day-indicator-$dateKey');
Key meetingMutualIndicatorKey(String dateKey) =>
    Key('meeting-mutual-indicator-$dateKey');
Key meetingMyEntryIndicatorKey(String dateKey) =>
    Key('meeting-my-entry-indicator-$dateKey');
Key meetingPartnerEntryIndicatorKey(String dateKey) =>
    Key('meeting-partner-entry-indicator-$dateKey');
Key meetingTimeSlotButtonKey(String slot) => Key('meeting-time-slot-$slot');
Key meetingTimeBlockRemoveButtonKey(String blockId) =>
    Key('meeting-time-block-remove-$blockId');

const placeBoardKey = Key('place-board');
const placeAddButtonKey = Key('place-add-button');
const placeSearchFieldKey = Key('place-search-field');
const placeSearchButtonKey = Key('place-search-button');
const placeNameFieldKey = Key('place-name-field');
const placeAddressFieldKey = Key('place-address-field');
const placeNoteFieldKey = Key('place-note-field');
const placeSubmitButtonKey = Key('place-submit-button');
Key placeSearchResultButtonKey(String placeId) =>
    Key('place-search-result-$placeId');
Key placeInterestButtonKey(String placeId) =>
    Key('place-interest-button-$placeId');
Key placeEditButtonKey(String placeId) => Key('place-edit-button-$placeId');
Key placeDeleteButtonKey(String placeId) => Key('place-delete-button-$placeId');
const placeRetryButtonKey = Key('place-retry-button');
