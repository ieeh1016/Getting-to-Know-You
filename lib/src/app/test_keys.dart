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
const readableDetailSheetKey = Key('readable-detail-sheet');
const readableDetailBodyKey = Key('readable-detail-body');
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

const improvementAddButtonKey = Key('improvement-add-button');
const improvementTitleFieldKey = Key('improvement-title-field');
const improvementBodyFieldKey = Key('improvement-body-field');
const improvementSubmitButtonKey = Key('improvement-submit-button');
const improvementRetryButtonKey = Key('improvement-retry-button');
Key improvementCategoryKey(String category) =>
    Key('improvement-category-$category');
Key improvementCardKey(String postId) => Key('improvement-card-$postId');
Key improvementEditButtonKey(String postId) =>
    Key('improvement-edit-button-$postId');
Key improvementDeleteButtonKey(String postId) =>
    Key('improvement-delete-button-$postId');

const wishTitleFieldKey = Key('wish-title-field');
const wishSubmitButtonKey = Key('wish-submit-button');
const wishAddButtonKey = Key('wish-add-button');
const wishlistBoardKey = Key('wishlist-board');

const answerFieldKey = Key('answer-field');
const answerRetryButtonKey = Key('answer-retry-button');
const editAnswerButtonKey = Key('edit-answer-button');
const answerCommentFieldKey = Key('answer-comment-field');
const answerCommentEditButtonKey = Key('answer-comment-edit-button');
const answerCommentCancelButtonKey = Key('answer-comment-cancel-button');
const answerCommentSubmitButtonKey = Key('answer-comment-submit-button');
Key answerPreviewBlockKey(String questionId, String profileId) =>
    Key('answer-preview-$questionId-$profileId');

const balanceDeckKey = Key('balance-deck');
const balanceReasonFieldKey = Key('balance-reason-field');
const balanceReasonSaveButtonKey = Key('balance-reason-save-button');
const balanceResultToggleButtonKey = Key('balance-result-toggle-button');
Key balanceRecordFilterButtonKey(String filter) =>
    Key('balance-record-filter-$filter');
Key balanceTabButtonKey(String tab) => Key('balance-tab-$tab');

const profileRecommendedSlotButtonKey = Key('profile-recommended-slot-button');
const profileRecommendedSlotSkipButtonKey = Key(
  'profile-recommended-slot-skip-button',
);
const profileEditorPanelKey = Key('profile-editor-panel');
const profileCustomCardAddButtonKey = Key('profile-custom-card-add-button');
const profileCustomCardPanelKey = Key('profile-custom-card-panel');
const profileCustomTitleFieldKey = Key('profile-custom-title-field');
const profileCustomBodyFieldKey = Key('profile-custom-body-field');
const profileCustomSubmitButtonKey = Key('profile-custom-submit-button');
const profileCustomCancelButtonKey = Key('profile-custom-cancel-button');
const profileHiddenSlotsPanelKey = Key('profile-hidden-slots-panel');
Key profileCategoryChipKey(String category) =>
    Key('profile-category-chip-$category');
Key profileSlotCardKey(String slotId) => Key('profile-slot-card-$slotId');
Key profileSlotReadButtonKey(String slotId) => Key('profile-slot-read-$slotId');
Key profileSlotEditButtonKey(String slotId) => Key('profile-slot-edit-$slotId');
Key profileSlotFieldKey(String slotId) => Key('profile-slot-field-$slotId');
Key profileSlotSaveButtonKey(String slotId) => Key('profile-slot-save-$slotId');
Key profileSlotCancelButtonKey(String slotId) =>
    Key('profile-slot-cancel-$slotId');
Key profileSlotSkipButtonKey(String slotId) => Key('profile-slot-skip-$slotId');
Key profileSlotRestoreButtonKey(String slotId) =>
    Key('profile-slot-restore-$slotId');
Key profileSlotHideButtonKey(String slotId) => Key('profile-slot-hide-$slotId');
Key profileSlotDeleteButtonKey(String slotId) =>
    Key('profile-slot-delete-$slotId');
Key profileCustomCategoryChipKey(String category) =>
    Key('profile-custom-category-$category');

const stockStoryAddButtonKey = Key('stock-story-add-button');
const stockStoryNameFieldKey = Key('stock-story-name-field');
const stockStoryReasonFieldKey = Key('stock-story-reason-field');
const stockStoryUpsideFieldKey = Key('stock-story-upside-field');
const stockStoryRiskFieldKey = Key('stock-story-risk-field');
const stockStoryQuestionFieldKey = Key('stock-story-question-field');
const stockStorySubmitButtonKey = Key('stock-story-submit-button');
const stockStoryTabStoriesKey = Key('stock-story-tab-stories');
const stockStoryTabHoldingsKey = Key('stock-story-tab-holdings');
Key stockStoryCardKey(String storyId) => Key('stock-story-card-$storyId');
Key stockStoryReplyFieldKey(String storyId) =>
    Key('stock-story-reply-field-$storyId');
Key stockStoryReplySubmitButtonKey(String storyId) =>
    Key('stock-story-reply-submit-$storyId');
Key stockStoryReplyToneKey(String storyId, String tone) =>
    Key('stock-story-reply-tone-$storyId-$tone');
Key stockStoryListFilterButtonKey(String filter) =>
    Key('stock-story-list-filter-$filter');

const stockHoldingAddButtonKey = Key('stock-holding-add-button');
const stockHoldingNameFieldKey = Key('stock-holding-name-field');
const stockHoldingReasonFieldKey = Key('stock-holding-reason-field');
const stockHoldingWatchFieldKey = Key('stock-holding-watch-field');
const stockHoldingConcernFieldKey = Key('stock-holding-concern-field');
const stockHoldingQuestionFieldKey = Key('stock-holding-question-field');
const stockHoldingSubmitButtonKey = Key('stock-holding-submit-button');
Key stockHoldingCardKey(String holdingId) =>
    Key('stock-holding-card-$holdingId');
Key stockHoldingEditButtonKey(String holdingId) =>
    Key('stock-holding-edit-button-$holdingId');
Key stockHoldingDeleteButtonKey(String holdingId) =>
    Key('stock-holding-delete-button-$holdingId');
Key stockHoldingStatusKey(String status) => Key('stock-holding-status-$status');
Key stockHoldingWeightKey(String weight) => Key('stock-holding-weight-$weight');
Key stockHoldingReplyFieldKey(String holdingId) =>
    Key('stock-holding-reply-field-$holdingId');
Key stockHoldingReplySubmitButtonKey(String holdingId) =>
    Key('stock-holding-reply-submit-$holdingId');
Key stockHoldingReplyToneKey(String holdingId, String tone) =>
    Key('stock-holding-reply-tone-$holdingId-$tone');
Key stockHoldingListFilterButtonKey(String filter) =>
    Key('stock-holding-list-filter-$filter');
