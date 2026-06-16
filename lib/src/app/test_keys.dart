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
