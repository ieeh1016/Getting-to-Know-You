import 'dart:async';

import 'package:flutter/material.dart';

import '../data/external_link_opener.dart';
import '../data/first_visit_guide_store.dart';
import '../data/firebase_alagagi_repositories.dart';
import '../data/music_note_seen_store.dart';
import '../domain/alagagi_controller.dart';
import 'kakao_map_panel.dart';

const inviteNicknameFieldKey = Key('invite-nickname-field');
const loginIdFieldKey = Key('login-id-field');
const loginPasswordFieldKey = Key('login-password-field');
const loginButtonKey = Key('login-button');
const answerFieldKey = Key('answer-field');
const wishTitleFieldKey = Key('wish-title-field');
const wishSubmitButtonKey = Key('wish-submit-button');
const wishAddButtonKey = Key('wish-add-button');
const wishlistBoardKey = Key('wishlist-board');
const balanceDeckKey = Key('balance-deck');
const balanceReasonFieldKey = Key('balance-reason-field');
const balanceReasonSaveButtonKey = Key('balance-reason-save-button');
const balanceResultToggleButtonKey = Key('balance-result-toggle-button');
Key balanceRecordFilterButtonKey(String filter) =>
    Key('balance-record-filter-$filter');
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
const unreadActivityPanelKey = Key('unread-activity-panel');
const unreadActivityClearButtonKey = Key('unread-activity-clear-button');
const homeProgressSummaryKey = Key('home-progress-summary');
const homeProgressSummaryCtaKey = Key('home-progress-summary-cta');
const editAnswerButtonKey = Key('edit-answer-button');
const homeQuestionCardKey = Key('home-question-card');
const homeQuestionAnswerButtonKey = Key('home-question-answer-button');
const subScreenBackButtonKey = Key('sub-screen-back-button');
const answerRetryButtonKey = Key('answer-retry-button');
const answerCommentFieldKey = Key('answer-comment-field');
const answerCommentEditButtonKey = Key('answer-comment-edit-button');
const answerCommentCancelButtonKey = Key('answer-comment-cancel-button');
const answerCommentSubmitButtonKey = Key('answer-comment-submit-button');
const readableDetailSheetKey = Key('readable-detail-sheet');
const readableDetailBodyKey = Key('readable-detail-body');
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
const homeCuriosityEntryKey = Key('home-curiosity-entry');
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
const firstVisitGuideBookSheetKey = Key('first-visit-guide-book-sheet');
const myDashboardKey = Key('my-dashboard');
const myNextPrimaryButtonKey = Key('my-next-primary-button');
const myProfileCardActionButtonKey = Key('my-profile-card-action-button');
const myMusicActionButtonKey = Key('my-music-action-button');
const myFirstVisitGuideButtonKey = Key('my-first-visit-guide-button');
const stockStoryAddButtonKey = Key('stock-story-add-button');
const stockStoryNameFieldKey = Key('stock-story-name-field');

const _mapCenterLatitude = 37.5665;
const _mapCenterLongitude = 126.9780;
const _placeBoardMapHorizontalBleed = 12.0;
const _selectedPlaceMiniMapHeight = 204.0;
const stockStoryReasonFieldKey = Key('stock-story-reason-field');
const stockStoryUpsideFieldKey = Key('stock-story-upside-field');
const stockStoryRiskFieldKey = Key('stock-story-risk-field');
const stockStoryQuestionFieldKey = Key('stock-story-question-field');
const stockStorySubmitButtonKey = Key('stock-story-submit-button');
const stockStoryTabStoriesKey = Key('stock-story-tab-stories');
const stockStoryTabHoldingsKey = Key('stock-story-tab-holdings');
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
const stockHoldingAddButtonKey = Key('stock-holding-add-button');
const stockHoldingNameFieldKey = Key('stock-holding-name-field');
const stockHoldingReasonFieldKey = Key('stock-holding-reason-field');
const stockHoldingWatchFieldKey = Key('stock-holding-watch-field');
const stockHoldingConcernFieldKey = Key('stock-holding-concern-field');
const stockHoldingQuestionFieldKey = Key('stock-holding-question-field');
const stockHoldingSubmitButtonKey = Key('stock-holding-submit-button');
Key stockStoryCardKey(String storyId) => Key('stock-story-card-$storyId');
Key stockStoryReplyFieldKey(String storyId) =>
    Key('stock-story-reply-field-$storyId');
Key stockStoryReplySubmitButtonKey(String storyId) =>
    Key('stock-story-reply-submit-$storyId');
Key stockStoryReplyToneKey(String storyId, String tone) =>
    Key('stock-story-reply-tone-$storyId-$tone');
Key stockStoryListFilterButtonKey(String filter) =>
    Key('stock-story-list-filter-$filter');
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
Key stockHoldingListFilterButtonKey(String filter) =>
    Key('stock-holding-list-filter-$filter');

double _placeBoardMapHeight(BuildContext context) {
  final viewportHeight = MediaQuery.sizeOf(context).height;
  return (viewportHeight * 0.58).clamp(386.0, 440.0).toDouble();
}

Key stockHoldingReplyToneKey(String holdingId, String tone) =>
    Key('stock-holding-reply-tone-$holdingId-$tone');
const alagagiShellKey = Key('alagagi-shell');
const bottomNavigationKey = Key('bottom-navigation');
const archiveCalendarKey = Key('archive-question-calendar');
const archiveCalendarPreviousButtonKey = Key('archive-calendar-previous');
const archiveCalendarNextButtonKey = Key('archive-calendar-next');
const archiveCalendarTodayButtonKey = Key('archive-calendar-today');
const lateAnswerButtonKey = Key('late-answer-button');
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

Key archiveCalendarDayButtonKey(String dateKey) =>
    Key('archive-calendar-day-$dateKey');

Key answerPreviewBlockKey(String questionId, String profileId) =>
    Key('answer-preview-$questionId-$profileId');

Key musicNoteCardKey(String noteId) => Key('music-note-card-$noteId');

Key myTraceCardKey(String type) => Key('my-trace-card-$type');

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

const _longAnswerPreviewLength = 120;
const _compactReadablePreviewLength = 64;
const _brandName = '조금씩';
const _brandKicker = '천천히 알아가는 기록';

bool _showsReadableCue(
  String body, {
  int threshold = _longAnswerPreviewLength,
  bool expanded = false,
}) => !expanded && body.trim().length > threshold;

String? _normalizedOpenableLink(String rawLink) {
  final trimmed = rawLink.trim();
  if (trimmed.isEmpty) {
    return null;
  }

  final hasScheme = RegExp(r'^[a-zA-Z][a-zA-Z0-9+.-]*:').hasMatch(trimmed);
  final candidate = hasScheme ? trimmed : 'https://$trimmed';
  final uri = Uri.tryParse(candidate);
  if (uri == null || uri.host.trim().isEmpty) {
    return null;
  }

  final scheme = uri.scheme.toLowerCase();
  if (scheme != 'http' && scheme != 'https') {
    return null;
  }

  return uri.toString();
}

class AlagagiApp extends StatelessWidget {
  const AlagagiApp({
    super.key,
    this.firebaseEnabled = false,
    this.authRepository,
    this.dataRepository,
    this.musicNoteSeenStore,
    this.firstVisitGuideStore,
    this.onOpenExternalLink,
  });

  final bool firebaseEnabled;
  final AlagagiAuthRepository? authRepository;
  final AlagagiDataRepository? dataRepository;
  final MusicNoteSeenStore? musicNoteSeenStore;
  final FirstVisitGuideStore? firstVisitGuideStore;
  final ValueChanged<String>? onOpenExternalLink;

  @override
  Widget build(BuildContext context) {
    late final Widget home;
    if (firebaseEnabled) {
      final auth = authRepository ?? FirebaseAlagagiAuthRepository();
      final data = dataRepository ?? FirestoreAlagagiDataRepository();
      home = AlagagiAuthGate(
        authRepository: auth,
        dataRepository: data,
        musicNoteSeenStore: musicNoteSeenStore,
        firstVisitGuideStore: firstVisitGuideStore,
        onOpenExternalLink: onOpenExternalLink,
      );
    } else {
      home = AlagagiRoot(
        musicNoteSeenStore: musicNoteSeenStore,
        onOpenExternalLink: onOpenExternalLink,
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _brandName,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AlagagiColors.outerBackground,
        fontFamily: 'Apple SD Gothic Neo',
        fontFamilyFallback: alagagiSansFonts,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AlagagiColors.sageDeep,
          brightness: Brightness.light,
        ),
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: AlagagiColors.ink,
          displayColor: AlagagiColors.ink,
        ),
      ),
      home: home,
    );
  }
}

class AlagagiRoot extends StatefulWidget {
  const AlagagiRoot({
    super.key,
    this.controller,
    this.onSignOut,
    this.musicNoteSeenStore,
    this.firstVisitGuideStore,
    this.onOpenExternalLink,
  });

  final AlagagiController? controller;
  final VoidCallback? onSignOut;
  final MusicNoteSeenStore? musicNoteSeenStore;
  final FirstVisitGuideStore? firstVisitGuideStore;
  final ValueChanged<String>? onOpenExternalLink;

  @override
  State<AlagagiRoot> createState() => _AlagagiRootState();
}

class _AlagagiRootState extends State<AlagagiRoot> {
  late final AlagagiController _controller;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller =
        widget.controller ??
        AlagagiController(
          musicNoteSeenStore:
              widget.musicNoteSeenStore ?? createDefaultMusicNoteSeenStore(),
          firstVisitGuideStore: widget.firstVisitGuideStore,
        );
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return _PhoneShell(
          child: Stack(
            children: [
              Positioned.fill(child: _buildRoute()),
              if (_controller.state.firstVisitGuideVisible &&
                  _controller.state.route == AlagagiRoute.home)
                _FirstVisitGuideOverlay(controller: _controller),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRoute() {
    return switch (_controller.state.route) {
      AlagagiRoute.invite => InviteScreen(controller: _controller),
      AlagagiRoute.home => HomeScreen(controller: _controller),
      AlagagiRoute.answer => AnswerScreen(controller: _controller),
      AlagagiRoute.archive => ArchiveScreen(controller: _controller),
      AlagagiRoute.records => RecordsScreen(controller: _controller),
      AlagagiRoute.music => MusicScreen(
        controller: _controller,
        onOpenExternalLink: widget.onOpenExternalLink ?? openExternalLink,
      ),
      AlagagiRoute.meetings => MeetingScreen(controller: _controller),
      AlagagiRoute.meetingPlans => MeetingPlanScreen(controller: _controller),
      AlagagiRoute.places => PlaceBoardScreen(
        controller: _controller,
        onOpenExternalLink: widget.onOpenExternalLink ?? openExternalLink,
      ),
      AlagagiRoute.stockStory => StockStoryScreen(controller: _controller),
      AlagagiRoute.improvements => ImprovementBoardScreen(
        controller: _controller,
      ),
      AlagagiRoute.balance => BalanceScreen(controller: _controller),
      AlagagiRoute.profileCard => ProfileCardScreen(controller: _controller),
      AlagagiRoute.wishlist => WishlistScreen(controller: _controller),
      AlagagiRoute.my => MyScreen(
        controller: _controller,
        onSignOut: widget.onSignOut,
      ),
    };
  }
}

class AlagagiColors {
  static const outerBackground = Color(0xFFE9E8E2);
  static const appBackground = Color(0xFFF4F3EF);
  static const paper = Color(0xFFFCFCFA);
  static const ink = Color(0xFF2E2E2C);
  static const muted = Color(0xFF9A9890);
  static const sage = Color(0xFF8A9A7E);
  static const sageDeep = Color(0xFF6F7F63);
  static const lavender = Color(0xFFB9A8C9);
  static const line = Color(0xFFE8E6DF);
  static const softSage = Color(0xFFDFE6D4);
  static const sagePanel = Color(0xFFCDD6C2);
}

const alagagiSansFonts = [
  'Apple SD Gothic Neo',
  'Noto Sans CJK KR',
  'Noto Sans KR',
  'Malgun Gothic',
  'Arial Unicode MS',
  'Apple Color Emoji',
];

const alagagiSerifFonts = [
  'Nanum Myeongjo',
  'AppleMyungjo',
  'Noto Serif CJK KR',
  'Noto Serif KR',
  'Apple SD Gothic Neo',
  'Noto Sans CJK KR',
  'Apple Color Emoji',
];

TextStyle serif(
  BuildContext context, {
  double? size,
  FontWeight? weight,
  Color? color,
  double? height,
}) {
  return TextStyle(
    fontFamily: 'Nanum Myeongjo',
    fontFamilyFallback: alagagiSerifFonts,
    fontSize: size,
    fontWeight: weight,
    color: color ?? AlagagiColors.ink,
    height: height,
    letterSpacing: 0,
  );
}

TextStyle sans({
  double? size,
  FontWeight? weight,
  Color? color,
  double? height,
  double? letterSpacing,
}) {
  return TextStyle(
    fontFamily: 'Apple SD Gothic Neo',
    fontFamilyFallback: alagagiSansFonts,
    fontSize: size,
    fontWeight: weight,
    color: color ?? AlagagiColors.ink,
    height: height,
    letterSpacing: letterSpacing ?? 0,
  );
}

class _PhoneShell extends StatelessWidget {
  const _PhoneShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.sizeOf(context);
    final shouldFrame = mediaSize.width >= 600;

    if (!shouldFrame) {
      return Scaffold(
        body: Container(
          key: alagagiShellKey,
          width: double.infinity,
          height: double.infinity,
          margin: EdgeInsets.zero,
          decoration: const BoxDecoration(color: AlagagiColors.appBackground),
          child: SafeArea(child: child),
        ),
      );
    }

    final availableHeight = mediaSize.height - 48;
    final shellHeight = availableHeight.clamp(520.0, 840.0);

    return Scaffold(
      body: Center(
        child: Container(
          key: alagagiShellKey,
          width: 390,
          height: shellHeight,
          constraints: const BoxConstraints(maxWidth: 390),
          margin: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: AlagagiColors.appBackground,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.white, width: 8),
            boxShadow: const [
              BoxShadow(
                color: Color(0x2E3C3C32),
                blurRadius: 70,
                offset: Offset(0, 30),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: child,
        ),
      ),
    );
  }
}

class _ScreenScroll extends StatelessWidget {
  const _ScreenScroll({
    required this.children,
    this.bottomNavigation,
    this.padding = const EdgeInsets.fromLTRB(28, 34, 28, 112),
  });

  final List<Widget> children;
  final Widget? bottomNavigation;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = bottomNavigation == null
        ? padding.bottom
        : padding.bottom > 72
        ? 24.0
        : padding.bottom;
    final effectivePadding = padding.copyWith(bottom: bottomPadding);

    final scrollable = ListView(
      padding: EdgeInsets.zero,
      children: [
        Padding(
          padding: effectivePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ],
    );

    if (bottomNavigation == null) {
      return scrollable;
    }

    return Column(
      children: [
        Expanded(child: scrollable),
        bottomNavigation!,
      ],
    );
  }
}

class AlagagiAuthGate extends StatelessWidget {
  const AlagagiAuthGate({
    super.key,
    required this.authRepository,
    required this.dataRepository,
    this.musicNoteSeenStore,
    this.firstVisitGuideStore,
    this.onOpenExternalLink,
  });

  final AlagagiAuthRepository authRepository;
  final AlagagiDataRepository dataRepository;
  final MusicNoteSeenStore? musicNoteSeenStore;
  final FirstVisitGuideStore? firstVisitGuideStore;
  final ValueChanged<String>? onOpenExternalLink;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AlagagiAuthUser?>(
      stream: authRepository.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const _PhoneShell(child: LoadingScreen());
        }

        final user = snapshot.data;
        if (user == null) {
          return _PhoneShell(
            child: LoginScreen(authRepository: authRepository),
          );
        }

        return _SessionGate(
          key: ValueKey(user.uid),
          user: user,
          authRepository: authRepository,
          dataRepository: dataRepository,
          musicNoteSeenStore: musicNoteSeenStore,
          firstVisitGuideStore: firstVisitGuideStore,
          onOpenExternalLink: onOpenExternalLink,
        );
      },
    );
  }
}

class _SessionGate extends StatefulWidget {
  const _SessionGate({
    super.key,
    required this.user,
    required this.authRepository,
    required this.dataRepository,
    this.musicNoteSeenStore,
    this.firstVisitGuideStore,
    this.onOpenExternalLink,
  });

  final AlagagiAuthUser user;
  final AlagagiAuthRepository authRepository;
  final AlagagiDataRepository dataRepository;
  final MusicNoteSeenStore? musicNoteSeenStore;
  final FirstVisitGuideStore? firstVisitGuideStore;
  final ValueChanged<String>? onOpenExternalLink;

  @override
  State<_SessionGate> createState() => _SessionGateState();
}

class _SessionGateState extends State<_SessionGate> {
  late Future<AlagagiSession?> _sessionFuture;
  AlagagiController? _controller;

  @override
  void initState() {
    super.initState();
    _sessionFuture = widget.dataRepository.loadSession(widget.user);
  }

  @override
  void didUpdateWidget(covariant _SessionGate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.user.uid != widget.user.uid ||
        oldWidget.dataRepository != widget.dataRepository) {
      _controller?.dispose();
      _controller = null;
      _sessionFuture = widget.dataRepository.loadSession(widget.user);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AlagagiSession?>(
      future: _sessionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _PhoneShell(child: LoadingScreen());
        }

        final session = snapshot.data;
        if (session == null) {
          return _PhoneShell(
            child: FirebaseSetupRequiredScreen(
              user: widget.user,
              onSignOut: widget.authRepository.signOut,
            ),
          );
        }

        _controller ??= AlagagiController.forSession(
          session,
          repository: widget.dataRepository,
          musicNoteSeenStore:
              widget.musicNoteSeenStore ?? createDefaultMusicNoteSeenStore(),
          firstVisitGuideStore:
              widget.firstVisitGuideStore ??
              createDefaultFirstVisitGuideStore(),
        );
        return AlagagiRoot(
          controller: _controller,
          onSignOut: widget.authRepository.signOut,
          onOpenExternalLink: widget.onOpenExternalLink,
        );
      },
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AlagagiColors.sageDeep),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.authRepository});

  final AlagagiAuthRepository authRepository;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorText;
  bool _signingIn = false;

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final loginId = _idController.text.trim();
    final password = _passwordController.text;
    if (loginId.isEmpty || password.isEmpty) {
      setState(() {
        _errorText = '아이디와 비밀번호를 적어주세요.';
      });
      return;
    }

    setState(() {
      _signingIn = true;
      _errorText = null;
    });

    try {
      await widget.authRepository.signInWithIdAndPassword(
        loginId: loginId,
        password: password,
      );
    } on AlagagiAuthException catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorText = error.message;
        _signingIn = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorText = '로그인 중 문제가 생겼어요. 잠시 후 다시 시도해 주세요.';
        _signingIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(34, 44, 34, 34),
          child: Column(
            children: [
              const _InviteSeal(),
              const SizedBox(height: 26),
              Text(
                _brandKicker,
                style: sans(
                  size: 11,
                  color: AlagagiColors.sageDeep,
                  letterSpacing: 0.4,
                  weight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                _brandName,
                textAlign: TextAlign.center,
                style: serif(
                  context,
                  size: 29,
                  weight: FontWeight.w800,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                '아이디가 있으면 조용히 이어서 들어갈 수 있어요.',
                textAlign: TextAlign.center,
                style: sans(
                  size: 14,
                  color: const Color(0xFF5A5A54),
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 26),
              const _LoginNotes(),
              const SizedBox(height: 24),
              _LoginTextField(
                key: loginIdFieldKey,
                controller: _idController,
                label: '아이디',
                hintText: 'youngwoo 또는 minyoung',
              ),
              const SizedBox(height: 10),
              _LoginTextField(
                key: loginPasswordFieldKey,
                controller: _passwordController,
                label: '비밀번호',
                obscureText: true,
                onSubmitted: (_) => _submit(),
              ),
              if (_errorText != null) ...[
                const SizedBox(height: 10),
                Text(
                  _errorText!,
                  textAlign: TextAlign.center,
                  style: sans(size: 12, color: AlagagiColors.sageDeep),
                ),
              ],
              const SizedBox(height: 14),
              _PrimaryButton(
                buttonKey: loginButtonKey,
                label: _signingIn ? '로그인 중...' : '로그인',
                onPressed: _signingIn ? null : _submit,
              ),
              const SizedBox(height: 14),
              Text(
                '다음부터는 자동으로 이어질 수 있어요',
                textAlign: TextAlign.center,
                style: sans(size: 11, color: AlagagiColors.muted, height: 1.6),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LoginTextField extends StatelessWidget {
  const _LoginTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.obscureText = false,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final String? hintText;
  final bool obscureText;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          hintText: hintText,
        ),
        style: sans(size: 14),
      ),
    );
  }
}

class FirebaseSetupRequiredScreen extends StatelessWidget {
  const FirebaseSetupRequiredScreen({
    super.key,
    required this.user,
    required this.onSignOut,
  });

  final AlagagiAuthUser user;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return _ScreenScroll(
      padding: const EdgeInsets.fromLTRB(28, 34, 28, 34),
      children: [
        const SizedBox(height: 30),
        Text(
          'Firebase Console 설정이 필요해요',
          textAlign: TextAlign.center,
          style: serif(context, size: 24, weight: FontWeight.w800, height: 1.4),
        ),
        const SizedBox(height: 14),
        Text(
          '로그인은 되었고, 이제 Firestore에 이 계정의 프로필 문서를 만들어주면 돼요.',
          textAlign: TextAlign.center,
          style: sans(size: 13, color: AlagagiColors.muted, height: 1.6),
        ),
        const SizedBox(height: 20),
        _PaperCard(
          radius: 18,
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'users/${user.uid}',
                style: sans(
                  size: 13,
                  weight: FontWeight.w600,
                  color: AlagagiColors.sageDeep,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'displayName, avatar, spaceId, partnerUid 필드를 추가한 뒤 다시 들어오면 홈으로 이어져요.',
                style: sans(size: 13, color: AlagagiColors.muted, height: 1.6),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _PrimaryButton(
          label: '로그인 화면으로 돌아가기',
          onPressed: onSignOut,
          color: AlagagiColors.sageDeep,
        ),
      ],
    );
  }
}

class InviteScreen extends StatefulWidget {
  const InviteScreen({super.key, required this.controller});

  final AlagagiController controller;

  @override
  State<InviteScreen> createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  final TextEditingController _nicknameController = TextEditingController(
    text: '민영',
  );

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(34, 44, 34, 34),
          child: Column(
            children: [
              const _InviteSeal(),
              const SizedBox(height: 26),
              Text(
                _brandKicker,
                style: sans(
                  size: 11,
                  color: AlagagiColors.sageDeep,
                  letterSpacing: 0.4,
                  weight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                '우리, 천천히\n알아가 볼래요?',
                textAlign: TextAlign.center,
                style: serif(
                  context,
                  size: 27,
                  weight: FontWeight.w800,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 18),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '영우',
                      style: serif(
                        context,
                        size: 14,
                        weight: FontWeight.w700,
                        color: AlagagiColors.sageDeep,
                      ),
                    ),
                    const TextSpan(text: '님이 대화 공간을 열어두었어요.\n'),
                    const TextSpan(
                      text: '하루에 질문 하나, 서로의 이야기를 나누는\n작고 조용한 공간이에요.',
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                style: sans(
                  size: 14,
                  color: const Color(0xFF5A5A54),
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 26),
              const _InviteNotes(),
              const SizedBox(height: 28),
              _NicknameField(
                controller: _nicknameController,
                errorText: widget.controller.state.inviteError,
              ),
              const SizedBox(height: 12),
              _PrimaryButton(
                label: '대화 공간으로 들어가기',
                onPressed: () =>
                    widget.controller.enterSpace(_nicknameController.text),
              ),
              const SizedBox(height: 14),
              Text(
                '가입 절차 없이 바로 시작해요 · 언제든 그만둘 수 있어요',
                textAlign: TextAlign.center,
                style: sans(size: 11, color: AlagagiColors.muted, height: 1.6),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InviteSeal extends StatelessWidget {
  const _InviteSeal();

  @override
  Widget build(BuildContext context) {
    return const _BrandLeafMark(size: 80, iconSize: 34);
  }
}

class _BrandLeafMark extends StatelessWidget {
  const _BrandLeafMark({this.size = 42, this.iconSize = 20});

  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AlagagiColors.paper,
        border: Border.all(color: AlagagiColors.line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F57624C),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Container(
        width: size * 0.62,
        height: size * 0.62,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFFEEF2EA), Color(0xFFFCFCFA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.eco_outlined,
          size: iconSize,
          color: AlagagiColors.sageDeep,
        ),
      ),
    );
  }
}

class _InviteNotes extends StatelessWidget {
  const _InviteNotes();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AlagagiColors.paper,
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: const Column(
        children: [
          _NoteRow(
            icon: Icons.wb_sunny_outlined,
            title: '하루에 딱 하나',
            body: '부담 없이, 답하고 싶을 때만 답해요.',
          ),
          _NoteDivider(),
          _NoteRow(
            icon: Icons.lock_outline_rounded,
            title: '비공개 기록',
            body: '로그인한 두 사람만 볼 수 있어요.',
          ),
          _NoteDivider(),
          _NoteRow(
            icon: Icons.eco_outlined,
            title: '천천히 적어두기',
            body: '답이 없어도 괜찮고, 서두르지 않아도 돼요.',
          ),
        ],
      ),
    );
  }
}

class _LoginNotes extends StatelessWidget {
  const _LoginNotes();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AlagagiColors.paper,
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: const Column(
        children: [
          _NoteRow(
            icon: Icons.schedule_outlined,
            title: '짧게 확인',
            body: '필요할 때만 들어와도 괜찮아요.',
          ),
          _NoteDivider(),
          _NoteRow(
            icon: Icons.lock_outline_rounded,
            title: '비공개 공간',
            body: '아이디가 있는 사람만 볼 수 있어요.',
          ),
          _NoteDivider(),
          _NoteRow(
            icon: Icons.refresh_rounded,
            title: '자동 로그인',
            body: '다음부터는 이어서 열릴 수 있어요.',
          ),
        ],
      ),
    );
  }
}

class _NoteDivider extends StatelessWidget {
  const _NoteDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 13),
      child: Divider(height: 1, color: AlagagiColors.line),
    );
  }
}

class _NoteRow extends StatelessWidget {
  const _NoteRow({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: const Color(0xFFEEF1E8),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 15, color: AlagagiColors.sageDeep),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$title\n',
                  style: sans(size: 13, weight: FontWeight.w500),
                ),
                TextSpan(text: body),
              ],
            ),
            style: sans(size: 13, color: const Color(0xFF55554F), height: 1.5),
          ),
        ),
      ],
    );
  }
}

class _NicknameField extends StatelessWidget {
  const _NicknameField({required this.controller, required this.errorText});

  final TextEditingController controller;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AlagagiColors.line),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text('나는', style: sans(size: 13, color: AlagagiColors.muted)),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  key: inviteNicknameFieldKey,
                  controller: controller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '불러줬으면 하는 이름',
                  ),
                  style: sans(size: 14),
                ),
              ),
              Text('이에요', style: sans(size: 13, color: AlagagiColors.muted)),
            ],
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            errorText!,
            style: sans(size: 12, color: AlagagiColors.sageDeep),
          ),
        ],
      ],
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return _ScreenScroll(
      bottomNavigation: _BottomNav(controller: controller),
      children: [
        _HomeHeader(controller: controller),
        const SizedBox(height: 18),
        _ProgressStrip(controller: controller),
        _UnreadActivityPanel(controller: controller),
        const SizedBox(height: 22),
        const _SectionLabel('오늘의 질문'),
        const SizedBox(height: 12),
        _QuestionCard(controller: controller),
        const SizedBox(height: 16),
        _HomeProgressSummaryCard(controller: controller),
        const SizedBox(height: 22),
        const _SectionLabel('알아간 기록'),
        const SizedBox(height: 12),
        _InsightGrid(controller: controller),
        const SizedBox(height: 24),
        const _SectionLabel('가볍게 알아가는 것들'),
        const SizedBox(height: 12),
        _PlusGrid(controller: controller),
      ],
    );
  }
}

class _UnreadActivityPanel extends StatelessWidget {
  const _UnreadActivityPanel({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final activities = controller.unreadActivities;
    if (activities.isEmpty) {
      return const SizedBox.shrink();
    }
    final visibleActivities = activities.take(3).toList();
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        key: unreadActivityPanelKey,
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAF5),
          border: Border.all(color: const Color(0x338A9A7E)),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AlagagiColors.softSage,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    size: 16,
                    color: AlagagiColors.sageDeep,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    '새로 도착한 것',
                    style: sans(
                      size: 13.5,
                      weight: FontWeight.w800,
                      color: const Color(0xFF3F403B),
                    ),
                  ),
                ),
                TextButton(
                  key: unreadActivityClearButtonKey,
                  onPressed: controller.markAllUnreadActivitiesSeen,
                  style: TextButton.styleFrom(
                    foregroundColor: AlagagiColors.muted,
                    visualDensity: VisualDensity.compact,
                    textStyle: sans(size: 11.5, weight: FontWeight.w800),
                  ),
                  child: const Text('모두 확인'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            for (var index = 0; index < visibleActivities.length; index++) ...[
              _UnreadActivityRow(
                activity: visibleActivities[index],
                onTap: () =>
                    _openUnreadActivity(context, visibleActivities[index]),
              ),
              if (index != visibleActivities.length - 1)
                const Divider(height: 14, color: AlagagiColors.line),
            ],
            if (activities.length > visibleActivities.length) ...[
              const SizedBox(height: 8),
              Text(
                '외 ${activities.length - visibleActivities.length}개 더 있어요.',
                style: sans(size: 11.5, color: AlagagiColors.muted),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _openUnreadActivity(BuildContext context, UnreadActivity activity) {
    if (activity.feature == UnreadActivityFeature.curiosity) {
      controller.markFeatureSeen(UnreadActivityFeature.curiosity);
      _showCuriosityMenuSheet(context, controller);
      return;
    }
    controller.openUnreadActivity(activity);
  }
}

class _UnreadActivityRow extends StatelessWidget {
  const _UnreadActivityRow({required this.activity, required this.onTap});

  final UnreadActivity activity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              _TinyUnreadDot(),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.feature.label,
                      style: sans(
                        size: 11.2,
                        weight: FontWeight.w800,
                        color: AlagagiColors.sageDeep,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      activity.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: sans(
                        size: 12.4,
                        height: 1.45,
                        color: const Color(0xFF4D4C47),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: AlagagiColors.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TinyUnreadDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: AlagagiColors.sageDeep,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _FirstVisitGuideOverlay extends StatelessWidget {
  const _FirstVisitGuideOverlay({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: Colors.transparent,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxSheetHeight = (constraints.maxHeight - 32).clamp(
              320.0,
              620.0,
            );
            return Container(
              color: AlagagiColors.ink.withValues(alpha: 0.28),
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxSheetHeight),
                child: Container(
                  key: firstVisitGuideSheetKey,
                  decoration: BoxDecoration(
                    color: AlagagiColors.paper,
                    border: Border.all(color: AlagagiColors.line),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x2E2C2B25),
                        blurRadius: 42,
                        offset: Offset(0, 18),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
                  child: SingleChildScrollView(
                    child: SafeArea(
                      top: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: const Color(0xFFD7D5CC),
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                          ),
                          const SizedBox(height: 17),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '처음 방문 안내',
                                  style: sans(
                                    size: 10.5,
                                    weight: FontWeight.w800,
                                    color: AlagagiColors.sageDeep,
                                    letterSpacing: 1.6,
                                  ),
                                ),
                              ),
                              Container(
                                height: 26,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEF2EA),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  '약 30초',
                                  style: sans(
                                    size: 11,
                                    weight: FontWeight.w800,
                                    color: AlagagiColors.sageDeep,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '오늘은 여기서 시작하면 충분해요',
                            style: serif(
                              context,
                              size: 23,
                              weight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            '기능을 전부 외울 필요 없이, 편한 것부터 하나씩 눌러보면 됩니다.',
                            style: sans(
                              size: 12.7,
                              color: AlagagiColors.muted,
                              height: 1.58,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const _FirstVisitPathRow(
                            number: '01',
                            title: '오늘 질문에 답하기',
                            body: '가장 자연스러운 첫 행동으로 안내합니다.',
                          ),
                          const SizedBox(height: 8),
                          const _FirstVisitPathRow(
                            number: '02',
                            title: '한 곡 남기기',
                            body: '말보다 음악이 편한 날을 위한 선택지입니다.',
                          ),
                          const SizedBox(height: 8),
                          const _FirstVisitPathRow(
                            number: '03',
                            title: '언젠가 같이 담기',
                            body: '해보고 싶은 일을 가볍게 모아둡니다.',
                          ),
                          const SizedBox(height: 13),
                          Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: AlagagiColors.sage,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 7),
                              Expanded(
                                child: Text(
                                  '닫아도 마이에서 처음 안내를 다시 볼 수 있어요.',
                                  style: sans(
                                    size: 11.5,
                                    color: AlagagiColors.muted,
                                    height: 1.45,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _PrimaryButton(
                            buttonKey: firstVisitGuideTourButtonKey,
                            label: '30초 둘러보기',
                            onPressed: () {
                              _showFirstVisitGuideBook(context);
                              controller.completeFirstVisitGuide();
                            },
                            color: AlagagiColors.sageDeep,
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 44,
                            child: TextButton(
                              key: firstVisitGuideStartButtonKey,
                              onPressed: controller.completeFirstVisitGuide,
                              style: TextButton.styleFrom(
                                foregroundColor: AlagagiColors.sageDeep,
                                textStyle: sans(
                                  size: 13,
                                  weight: FontWeight.w800,
                                ),
                              ),
                              child: const Text('바로 시작하기'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FirstVisitPathRow extends StatelessWidget {
  const _FirstVisitPathRow({
    required this.number,
    required this.title,
    required this.body,
  });

  final String number;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 62),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F4),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Text(
              number,
              style: sans(
                size: 11,
                weight: FontWeight.w800,
                color: AlagagiColors.sageDeep,
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: sans(
                    size: 13,
                    weight: FontWeight.w800,
                    color: const Color(0xFF46443F),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  body,
                  style: sans(
                    size: 11.5,
                    color: AlagagiColors.muted,
                    height: 1.42,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Semantics(
            key: homeBrandLogoKey,
            label: '${controller.state.personalization.appTitle} 로고',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const _BrandLeafMark(),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Text(
                        controller.state.personalization.appTitle,
                        style: serif(
                          context,
                          size: 24,
                          weight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Padding(
                  padding: const EdgeInsets.only(left: 53),
                  child: Text(
                    _brandKicker,
                    style: sans(
                      size: 10.5,
                      weight: FontWeight.w800,
                      color: AlagagiColors.sageDeep,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Tooltip(
          message: '조금씩 메뉴',
          child: IconButton(
            key: homeMenuButtonKey,
            onPressed: () => _showHomeMenuSheet(context, controller),
            icon: const Icon(Icons.menu_rounded, size: 20),
            color: AlagagiColors.sageDeep,
            style: IconButton.styleFrom(
              backgroundColor: AlagagiColors.paper,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: AlagagiColors.line),
                borderRadius: BorderRadius.circular(999),
              ),
              fixedSize: const Size(42, 42),
            ),
          ),
        ),
      ],
    );
  }
}

void _showHomeMenuSheet(BuildContext context, AlagagiController controller) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      final maxHeight = MediaQuery.sizeOf(sheetContext).height * 0.88;
      return SafeArea(
        child: Container(
          key: homeMenuSheetKey,
          margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          constraints: BoxConstraints(maxHeight: maxHeight),
          decoration: BoxDecoration(
            color: AlagagiColors.paper,
            border: Border.all(color: AlagagiColors.line),
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Color(0x2E2C2B25),
                blurRadius: 44,
                offset: Offset(0, 18),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(18, 11, 18, 18),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD7D5CC),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 17),
                Text(
                  '기능 모아보기',
                  style: serif(context, size: 21, weight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  '오늘 질문을 방해하지 않는 선에서, 가끔 꺼내볼 기능을 한곳에 모았어요.',
                  style: sans(
                    size: 12.3,
                    color: AlagagiColors.muted,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 14),
                _HomeMenuRow(
                  rowKey: homeMenuCuriosityButtonKey,
                  icon: Icons.question_answer_outlined,
                  title: '궁금함 한 장',
                  subtitle: '상대에게 짧게 물어보기',
                  badgeCount: controller.unreadCountForFeature(
                    UnreadActivityFeature.curiosity,
                  ),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    controller.markFeatureSeen(UnreadActivityFeature.curiosity);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _showCuriosityMenuSheet(context, controller);
                    });
                  },
                ),
                const SizedBox(height: 8),
                _HomeMenuRow(
                  rowKey: homeMenuStockStoryButtonKey,
                  icon: Icons.bar_chart_rounded,
                  title: '주식 이야기',
                  subtitle: '관심 종목과 걱정 포인트를 함께 보기',
                  badgeCount: controller.unreadCountForFeature(
                    UnreadActivityFeature.stocks,
                  ),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    controller.goTo(AlagagiRoute.stockStory);
                  },
                ),
                const SizedBox(height: 8),
                _HomeMenuRow(
                  rowKey: homeMenuImprovementButtonKey,
                  icon: Icons.rate_review_outlined,
                  title: '건의함',
                  subtitle: '개선 아이디어와 추가 요청 남기기',
                  badgeCount: controller.unreadCountForFeature(
                    UnreadActivityFeature.improvements,
                  ),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    controller.goTo(AlagagiRoute.improvements);
                  },
                ),
                const SizedBox(height: 8),
                _HomeMenuRow(
                  rowKey: homeMenuBalanceButtonKey,
                  icon: Icons.swap_horiz_rounded,
                  title: '취향 매치',
                  subtitle: '둘 중 하나를 고르고 서로의 취향 보기',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    controller.goTo(AlagagiRoute.balance);
                  },
                ),
                const SizedBox(height: 8),
                _HomeMenuRow(
                  rowKey: homeMenuProfileCardButtonKey,
                  icon: Icons.badge_outlined,
                  title: '소개 카드',
                  subtitle: '취향과 대화 방식을 편한 만큼 채우기',
                  badgeCount: controller.unreadCountForFeature(
                    UnreadActivityFeature.profileCard,
                  ),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    if (controller.unreadCountForFeature(
                          UnreadActivityFeature.profileCard,
                        ) >
                        0) {
                      controller.setProfileCardTab(ProfileCardTab.partner);
                    } else {
                      controller.setProfileCardTab(ProfileCardTab.me);
                    }
                    controller.goTo(AlagagiRoute.profileCard);
                  },
                ),
                const SizedBox(height: 8),
                _HomeMenuRow(
                  rowKey: homeMenuWishlistButtonKey,
                  icon: Icons.bookmark_add_outlined,
                  title: '언젠가, 같이',
                  subtitle: '같이 해보고 싶은 일을 조용히 담기',
                  badgeCount: controller.unreadCountForFeature(
                    UnreadActivityFeature.wishlist,
                  ),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    controller.goTo(AlagagiRoute.wishlist);
                  },
                ),
                const SizedBox(height: 8),
                _HomeMenuRow(
                  rowKey: homeMenuGuideButtonKey,
                  icon: Icons.info_outline_rounded,
                  title: '처음 안내',
                  subtitle: '조금씩 사용하는 방법 다시 보기',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _showFirstVisitGuideBook(context);
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _HomeMenuRow extends StatelessWidget {
  const _HomeMenuRow({
    required this.rowKey,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.badgeCount = 0,
  });

  final Key rowKey;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: rowKey,
        borderRadius: BorderRadius.circular(17),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 64),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8F4),
            border: Border.all(color: AlagagiColors.line),
            borderRadius: BorderRadius.circular(17),
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2EA),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 19, color: AlagagiColors.sageDeep),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: sans(
                        size: 13.1,
                        weight: FontWeight.w800,
                        color: const Color(0xFF46443F),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: sans(
                        size: 11.2,
                        color: AlagagiColors.muted,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              if (badgeCount > 0) ...[
                const SizedBox(width: 8),
                _UnreadCountBadge(count: badgeCount),
              ],
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AlagagiColors.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UnreadCountBadge extends StatelessWidget {
  const _UnreadCountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      constraints: const BoxConstraints(minWidth: 22),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFB18472),
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: Text(
        count > 9 ? '9+' : '$count',
        style: sans(size: 10.5, weight: FontWeight.w900, color: Colors.white),
      ),
    );
  }
}

class _ProgressStrip extends StatelessWidget {
  const _ProgressStrip({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AlagagiColors.ink,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DAY ${controller.todayQuestion.day} · 서로의 ${controller.todayQuestion.number}번째 질문',
                  style: sans(
                    size: 11,
                    color: const Color(0xFFB8B6AD),
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  controller.state.personalization.homeLine,
                  style: serif(
                    context,
                    size: 16,
                    weight: FontWeight.w700,
                    color: AlagagiColors.appBackground,
                  ),
                ),
              ],
            ),
          ),
          _AvatarStack(
            me: controller.state.me,
            partner: controller.state.partner,
          ),
        ],
      ),
    );
  }
}

class _AvatarStack extends StatelessWidget {
  const _AvatarStack({required this.me, required this.partner});

  final AppProfile me;
  final AppProfile partner;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 36,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: _SmallAvatar(profile: me, color: AlagagiColors.sagePanel),
          ),
          Positioned(
            left: 26,
            child: _SmallAvatar(
              profile: partner,
              color: const Color(0xFFD8CCE2),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallAvatar extends StatelessWidget {
  const _SmallAvatar({required this.profile, required this.color});

  final AppProfile profile;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: AlagagiColors.ink, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(profile.avatar, style: const TextStyle(fontSize: 15)),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: sans(size: 11, color: AlagagiColors.muted, letterSpacing: 3),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final question = controller.todayQuestion;
    final myAnswer = controller.todayMyAnswer;
    final partnerAnswer = controller.todayPartnerAnswer;
    final receivedComment = myAnswer == null
        ? null
        : controller.commentForAnswer(
            question.id,
            myAnswer.profileId,
            controller.state.partner.id,
          );
    final isSkipped = myAnswer?.skipped ?? false;

    return _PaperCard(
      key: homeQuestionCardKey,
      radius: 22,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 21),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Today\'s Question',
                  style: sans(
                    size: 10.5,
                    color: AlagagiColors.sageDeep,
                    letterSpacing: 1.2,
                    weight: FontWeight.w700,
                  ),
                ),
              ),
              _DayChip(label: 'DAY ${question.day}'),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            question.text,
            style: serif(
              context,
              size: 22,
              weight: FontWeight.w800,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          if (isSkipped)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _QuestionSupportBlock(
                  title: '오늘은 잠시 넘겨뒀어요.',
                  body: '다시 답하고 싶어지면 여기서 바로 이어갈 수 있어요.',
                ),
                const SizedBox(height: 16),
                _PrimaryButton(
                  label: '다시 답하기',
                  onPressed: controller.answerTodayAfterSkip,
                  color: AlagagiColors.sageDeep,
                ),
                _AnswerSaveStatus(
                  controller: controller,
                  questionId: question.id,
                ),
              ],
            )
          else if (myAnswer == null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _QuestionSupportBlock(
                  title: '아직 내 답을 남기지 않았어요.',
                  body:
                      '답을 남기면 ${controller.state.partner.nickname}님의 답도 함께 열려요.',
                ),
                const SizedBox(height: 16),
                _PrimaryButton(
                  buttonKey: homeQuestionAnswerButtonKey,
                  label: '답 남기기',
                  onPressed: () => controller.goTo(AlagagiRoute.answer),
                  color: AlagagiColors.sageDeep,
                ),
              ],
            )
          else ...[
            _AnswerPreviewBlock(
              key: answerPreviewBlockKey(
                myAnswer.questionId,
                myAnswer.profileId,
              ),
              label: '내 답',
              body: myAnswer.body,
              onOpenFull: () => _showReadableDetailSheet(
                context,
                label: '내 답',
                title: question.text,
                body: myAnswer.body,
                actionLabel: '수정하기',
                onAction: controller.editTodayAnswer,
              ),
              action: _InlineTextAction(
                key: editAnswerButtonKey,
                label: '수정하기',
                onPressed: controller.editTodayAnswer,
              ),
              expanded: controller.isAnswerExpanded(
                myAnswer.questionId,
                myAnswer.profileId,
              ),
              onToggle: () => controller.toggleAnswerExpanded(
                myAnswer.questionId,
                myAnswer.profileId,
              ),
            ),
            if (receivedComment != null) ...[
              const SizedBox(height: 10),
              _ReadOnlyCommentBlock(
                label: '${controller.state.partner.nickname}님의 댓글',
                body: receivedComment.body,
                onOpenFull: () => _showReadableDetailSheet(
                  context,
                  label: '${controller.state.partner.nickname}님의 댓글',
                  title: '내 답에 남겨진 댓글',
                  body: receivedComment.body,
                ),
              ),
            ],
            const SizedBox(height: 16),
            if (partnerAnswer == null)
              _QuestionSupportBlock(
                title: '${controller.state.partner.nickname}님 답은 기다리는 중이에요.',
                body: '상대 답이 준비되면 이 자리에서 이어서 볼 수 있어요.',
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AnswerPreviewBlock(
                    key: answerPreviewBlockKey(
                      partnerAnswer.questionId,
                      partnerAnswer.profileId,
                    ),
                    label: '${controller.state.partner.nickname}님 답',
                    accentColor: AlagagiColors.lavender,
                    body: partnerAnswer.body,
                    onOpenFull: () => _showReadableDetailSheet(
                      context,
                      label: '${controller.state.partner.nickname}님 답',
                      title: question.text,
                      body: partnerAnswer.body,
                    ),
                    expanded: controller.isAnswerExpanded(
                      partnerAnswer.questionId,
                      partnerAnswer.profileId,
                    ),
                    onToggle: () => controller.toggleAnswerExpanded(
                      partnerAnswer.questionId,
                      partnerAnswer.profileId,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _AnswerCommentBox(
                    controller: controller,
                    questionId: partnerAnswer.questionId,
                    answerOwnerProfileId: partnerAnswer.profileId,
                  ),
                ],
              ),
            _AnswerSaveStatus(controller: controller, questionId: question.id),
          ],
        ],
      ),
    );
  }
}

void _showCuriosityMenuSheet(
  BuildContext context,
  AlagagiController controller,
) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return DraggableScrollableSheet(
        initialChildSize: 0.72,
        minChildSize: 0.42,
        maxChildSize: 0.86,
        expand: false,
        builder: (_, scrollController) {
          return AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              return _CuriositySheetContent(
                controller: controller,
                scrollController: scrollController,
              );
            },
          );
        },
      );
    },
  );
}

class _CuriositySheetContent extends StatelessWidget {
  const _CuriositySheetContent({
    required this.controller,
    required this.scrollController,
  });

  final AlagagiController controller;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final received = controller.latestReceivedCuriosityCard;
    final sent =
        controller.pendingSentCuriosityCard ??
        controller.latestSentCuriosityCard;
    final receivedCount = controller.unansweredReceivedCuriosityCount;
    final badge = receivedCount > 0
        ? '받은 질문 $receivedCount'
        : sent != null && !sent.hasReply
        ? '답장 기다림'
        : '새 질문';
    final isSaving = controller.state.curiositySaveStatus == SaveStatus.saving;

    return SafeArea(
      child: Container(
        key: homeCuriositySheetKey,
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        decoration: BoxDecoration(
          color: AlagagiColors.paper,
          border: Border.all(color: AlagagiColors.line),
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [
            BoxShadow(
              color: Color(0x2E2C2B25),
              blurRadius: 44,
              offset: Offset(0, 18),
            ),
          ],
        ),
        child: SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(18, 11, 18, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD7D5CC),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 17),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2EA),
                      border: Border.all(color: const Color(0x336F7F63)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.question_answer_outlined,
                      size: 20,
                      color: AlagagiColors.sageDeep,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '궁금함 한 장',
                          style: serif(
                            context,
                            size: 20,
                            weight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '서로에게 따로 남기는 작은 질문',
                          style: sans(
                            size: 12,
                            color: AlagagiColors.muted,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _CuriosityBadge(label: badge),
                ],
              ),
              const SizedBox(height: 15),
              _ReceivedCuriosityPanel(controller: controller, card: received),
              if (sent != null) ...[
                const SizedBox(height: 10),
                _SentCuriosityPanel(controller: controller, card: sent),
              ],
              const SizedBox(height: 10),
              _CuriosityComposePanel(
                controller: controller,
                isSaving: isSaving,
              ),
              _CuriositySaveStatus(controller: controller),
              const SizedBox(height: 8),
              _SheetOutlineAction(
                label: '나중에 보기',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CuriosityBadge extends StatelessWidget {
  const _CuriosityBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 26),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2EA),
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        label,
        style: sans(
          size: 10.5,
          weight: FontWeight.w800,
          color: AlagagiColors.sageDeep,
        ),
      ),
    );
  }
}

class _ReceivedCuriosityPanel extends StatelessWidget {
  const _ReceivedCuriosityPanel({required this.controller, required this.card});

  final AlagagiController controller;
  final CuriosityCard? card;

  @override
  Widget build(BuildContext context) {
    final card = this.card;
    final partnerName = controller.state.partner.nickname;
    if (card == null) {
      return _CuriosityPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '받은 질문',
              style: sans(
                size: 10.5,
                weight: FontWeight.w800,
                color: AlagagiColors.sageDeep,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              '아직 받은 궁금함은 없어요.',
              style: serif(context, size: 15, weight: FontWeight.w800),
            ),
          ],
        ),
      );
    }

    final hasReply = card.hasReply;
    final isSaving =
        controller.state.curiositySaveStatus == SaveStatus.saving &&
        controller.isCuriositySaveTarget(card.id);
    return _CuriosityPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$partnerName님이 물었어요',
            style: sans(
              size: 10.5,
              weight: FontWeight.w800,
              color: AlagagiColors.sageDeep,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            card.question,
            style: serif(
              context,
              size: 15.5,
              weight: FontWeight.w800,
              height: 1.42,
            ),
          ),
          const SizedBox(height: 12),
          if (hasReply)
            _CuriosityReadBlock(label: '내 답장', body: card.reply!)
          else ...[
            _CuriosityTextField(
              fieldKey: curiosityReplyFieldKey,
              value: controller.curiosityReplyDraftFor(card.id),
              hintText: '짧게 답해도 괜찮아요.',
              maxLines: 3,
              onChanged: (value) => controller.updateCuriosityReplyDraft(
                cardId: card.id,
                value: value,
              ),
            ),
            const SizedBox(height: 10),
            _PrimaryButton(
              label: isSaving ? '저장 중...' : '답장 저장하기',
              buttonKey: curiosityReplySubmitButtonKey,
              onPressed: isSaving
                  ? null
                  : () => controller.submitCuriosityReply(card.id),
              color: AlagagiColors.sageDeep,
            ),
          ],
        ],
      ),
    );
  }
}

class _SentCuriosityPanel extends StatelessWidget {
  const _SentCuriosityPanel({required this.controller, required this.card});

  final AlagagiController controller;
  final CuriosityCard card;

  @override
  Widget build(BuildContext context) {
    final partnerName = controller.state.partner.nickname;
    return _CuriosityPanel(
      backgroundColor: const Color(0xFFF8F8F4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '내가 남긴 질문',
            style: sans(
              size: 10.5,
              weight: FontWeight.w800,
              color: AlagagiColors.sageDeep,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            card.question,
            style: serif(
              context,
              size: 15,
              weight: FontWeight.w800,
              height: 1.42,
            ),
          ),
          const SizedBox(height: 9),
          if (card.hasReply)
            _CuriosityReadBlock(label: '$partnerName님 답장', body: card.reply!)
          else
            Text(
              '$partnerName님 답장을 기다리는 중이에요.',
              style: sans(size: 12, color: AlagagiColors.muted, height: 1.45),
            ),
        ],
      ),
    );
  }
}

class _CuriosityComposePanel extends StatelessWidget {
  const _CuriosityComposePanel({
    required this.controller,
    required this.isSaving,
  });

  final AlagagiController controller;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    final partnerName = controller.state.partner.nickname;
    final pendingSent = controller.pendingSentCuriosityCard;
    final targetId = controller.state.curiositySaveTargetId;
    final savingQuestion =
        isSaving && (targetId == null || targetId.startsWith('curiosity_'));
    if (pendingSent != null) {
      return _CuriosityPanel(
        backgroundColor: const Color(0xFFFFFEFA),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '답장을 기다리는 질문이 있어요',
              style: sans(
                size: 10.5,
                weight: FontWeight.w800,
                color: AlagagiColors.sageDeep,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '한 장이 열린 동안에는 새 질문을 잠시 쉬어가요.',
              style: sans(size: 12, color: AlagagiColors.muted, height: 1.45),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 42,
              child: OutlinedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.hourglass_empty_rounded, size: 15),
                label: const Text('답장 기다리는 중'),
                style: OutlinedButton.styleFrom(
                  disabledForegroundColor: AlagagiColors.muted,
                  side: const BorderSide(color: AlagagiColors.line),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: sans(size: 12, weight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return _CuriosityPanel(
      backgroundColor: const Color(0xFFFFFEFA),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$partnerName님에게 궁금한 것',
            style: sans(
              size: 10.5,
              weight: FontWeight.w800,
              color: AlagagiColors.sageDeep,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 9),
          _CuriosityTextField(
            fieldKey: curiosityQuestionFieldKey,
            value: controller.state.curiosityQuestionDraft,
            hintText: '예: 이번 주에 기대되는 일이 있어요?',
            maxLines: 2,
            onChanged: controller.updateCuriosityQuestionDraft,
          ),
          const SizedBox(height: 10),
          _PrimaryButton(
            label: savingQuestion ? '보내는 중...' : '질문 보내기',
            buttonKey: curiosityQuestionSubmitButtonKey,
            onPressed: savingQuestion
                ? null
                : controller.submitCuriosityQuestion,
            color: AlagagiColors.ink,
          ),
        ],
      ),
    );
  }
}

class _CuriosityPanel extends StatelessWidget {
  const _CuriosityPanel({
    required this.child,
    this.backgroundColor = const Color(0xFFFFFEFA),
  });

  final Widget child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(14),
      child: child,
    );
  }
}

class _CuriosityReadBlock extends StatelessWidget {
  const _CuriosityReadBlock({required this.label, required this.body});

  final String label;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2EA),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: sans(
              size: 10.5,
              weight: FontWeight.w800,
              color: AlagagiColors.sageDeep,
            ),
          ),
          const SizedBox(height: 5),
          Text(body, style: sans(size: 13, height: 1.5)),
        ],
      ),
    );
  }
}

class _CuriosityTextField extends StatefulWidget {
  const _CuriosityTextField({
    required this.fieldKey,
    required this.value,
    required this.hintText,
    required this.maxLines,
    required this.onChanged,
  });

  final Key fieldKey;
  final String value;
  final String hintText;
  final int maxLines;
  final ValueChanged<String> onChanged;

  @override
  State<_CuriosityTextField> createState() => _CuriosityTextFieldState();
}

class _CuriosityTextFieldState extends State<_CuriosityTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant _CuriosityTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.text = widget.value;
      _controller.selection = TextSelection.collapsed(
        offset: _controller.text.length,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: widget.fieldKey,
      controller: _controller,
      minLines: widget.maxLines,
      maxLines: widget.maxLines,
      maxLength: widget.fieldKey == curiosityQuestionFieldKey ? 80 : 160,
      onChanged: widget.onChanged,
      style: sans(size: 13, height: 1.45),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: sans(size: 12.5, color: AlagagiColors.muted),
        counterText: '',
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AlagagiColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AlagagiColors.sageDeep),
        ),
      ),
    );
  }
}

class _CuriositySaveStatus extends StatelessWidget {
  const _CuriositySaveStatus({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final error = controller.state.curiosityError;
    final feedback = controller.state.curiositySaveFeedback;
    const errorColor = Color(0xFFB18472);
    if (error == null && feedback == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Icon(
            error == null
                ? Icons.check_circle_outline_rounded
                : Icons.error_outline_rounded,
            size: 16,
            color: error == null ? AlagagiColors.sageDeep : errorColor,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              error ?? feedback ?? '',
              style: sans(
                size: 12,
                color: error == null ? AlagagiColors.sageDeep : errorColor,
                weight: FontWeight.w700,
              ),
            ),
          ),
          if (error != null &&
              controller.state.curiositySaveStatus == SaveStatus.failed)
            TextButton(
              onPressed: controller.retryCuriositySave,
              child: Text(
                '다시 시도',
                style: sans(size: 12, weight: FontWeight.w800),
              ),
            ),
        ],
      ),
    );
  }
}

class _SheetOutlineAction extends StatelessWidget {
  const _SheetOutlineAction({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AlagagiColors.sageDeep,
          side: const BorderSide(color: Color(0x338A9A7E)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          textStyle: sans(size: 12, weight: FontWeight.w800),
        ),
        child: Text(label, textAlign: TextAlign.center),
      ),
    );
  }
}

class _HomeProgressSummaryCard extends StatelessWidget {
  const _HomeProgressSummaryCard({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final summary = controller.homeProgressSummary;
    return _PaperCard(
      key: homeProgressSummaryKey,
      radius: 22,
      padding: const EdgeInsets.fromLTRB(17, 16, 17, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '오늘의 작은 흐름',
                  style: serif(context, size: 16, weight: FontWeight.w800),
                ),
              ),
              Text(
                '가볍게 확인만',
                style: sans(size: 11, color: AlagagiColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (var index = 0; index < summary.items.length; index++) ...[
            if (index > 0) const Divider(height: 1, color: AlagagiColors.line),
            _HomeProgressSummaryRow(item: summary.items[index]),
          ],
          if (summary.primaryAction != null) ...[
            const SizedBox(height: 10),
            _SecondaryActionButton(
              key: homeProgressSummaryCtaKey,
              label: summary.primaryAction!.label,
              icon: Icons.arrow_forward_rounded,
              onPressed: controller.activateHomeProgressSummaryAction,
            ),
          ],
        ],
      ),
    );
  }
}

class _HomeProgressSummaryRow extends StatelessWidget {
  const _HomeProgressSummaryRow({required this.item});

  final HomeProgressSummaryItem item;

  @override
  Widget build(BuildContext context) {
    final color = _summaryToneColor(item.tone);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _summaryToneFill(item.tone),
              border: Border.all(color: AlagagiColors.line),
            ),
            alignment: Alignment.center,
            child: Icon(_summaryIcon(item.id), size: 17, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: sans(size: 10.5, color: AlagagiColors.muted),
                ),
                const SizedBox(height: 3),
                Text(
                  item.stateText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: sans(
                    size: 13,
                    weight: FontWeight.w500,
                    color: const Color(0xFF4C4B46),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
        ],
      ),
    );
  }
}

IconData _summaryIcon(String id) {
  return switch (id) {
    'todayQuestion' => Icons.notes_rounded,
    'bothAnswered' => Icons.lock_open_rounded,
    'music' => Icons.music_note_rounded,
    _ => Icons.circle_outlined,
  };
}

Color _summaryToneColor(HomeProgressSummaryTone tone) {
  return switch (tone) {
    HomeProgressSummaryTone.ready => AlagagiColors.sageDeep,
    HomeProgressSummaryTone.waiting => const Color(0xFFB18472),
    HomeProgressSummaryTone.calm => const Color(0xFFC7C3BA),
  };
}

Color _summaryToneFill(HomeProgressSummaryTone tone) {
  return switch (tone) {
    HomeProgressSummaryTone.ready => AlagagiColors.sagePanel,
    HomeProgressSummaryTone.waiting => const Color(0xFFF5F1E9),
    HomeProgressSummaryTone.calm => const Color(0xFFF8F8F4),
  };
}

class _SecondaryActionButton extends StatelessWidget {
  const _SecondaryActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 15),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: AlagagiColors.sageDeep,
          side: const BorderSide(color: Color(0x338A9A7E)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: serif(context, size: 13.5, weight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 28),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2EB),
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      child: Text(
        label,
        style: sans(
          size: 11,
          color: AlagagiColors.sageDeep,
          weight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _QuestionSupportBlock extends StatelessWidget {
  const _QuestionSupportBlock({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F4),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(17),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: serif(
              context,
              size: 13,
              weight: FontWeight.w800,
              color: AlagagiColors.sageDeep,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            body,
            style: sans(size: 12.5, color: AlagagiColors.muted, height: 1.55),
          ),
        ],
      ),
    );
  }
}

class _AnswerCommentBox extends StatelessWidget {
  const _AnswerCommentBox({
    required this.controller,
    required this.questionId,
    required this.answerOwnerProfileId,
    this.readOnly = false,
  });

  final AlagagiController controller;
  final String questionId;
  final String answerOwnerProfileId;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final existingComment = controller.commentForAnswer(
      questionId,
      answerOwnerProfileId,
      controller.state.me.id,
    );
    final inputValue = controller.commentInputValueForAnswer(
      questionId,
      answerOwnerProfileId,
    );
    final hasDraft = controller.hasCommentDraftForAnswer(
      questionId,
      answerOwnerProfileId,
    );
    final showEditor = !readOnly && (hasDraft || existingComment == null);
    final showEditButton = !readOnly && existingComment != null && !hasDraft;
    if (readOnly && existingComment == null) {
      return const SizedBox.shrink();
    }
    final isSaveTarget = controller.isCommentSaveTarget(
      questionId: questionId,
      answerOwnerProfileId: answerOwnerProfileId,
    );
    final isSaving =
        isSaveTarget && controller.state.commentSaveStatus == SaveStatus.saving;
    final inputLength = inputValue.length;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEFA),
        border: Border.all(
          color: showEditor ? const Color(0x5C6F7F63) : AlagagiColors.line,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: showEditor
            ? const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 22,
                  offset: Offset(0, 10),
                ),
              ]
            : null,
      ),
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2EB),
                  border: Border.all(color: AlagagiColors.line),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 14,
                  color: AlagagiColors.sageDeep,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      showEditor
                          ? existingComment == null
                                ? '댓글 남기기'
                                : '댓글 다듬기'
                          : '내 댓글',
                      style: serif(
                        context,
                        size: 13,
                        weight: FontWeight.w800,
                        color: AlagagiColors.sageDeep,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      showEditor ? '저장 전까지는 내 화면에서만 바뀌어요' : '상대 답에 남긴 짧은 코멘트',
                      style: sans(size: 10.5, color: AlagagiColors.muted),
                    ),
                  ],
                ),
              ),
              if (showEditButton)
                _CommentIconButton(
                  key: answerCommentEditButtonKey,
                  tooltip: '댓글 수정',
                  icon: Icons.edit_outlined,
                  onPressed: () => controller.updateAnswerCommentDraft(
                    questionId: questionId,
                    answerOwnerProfileId: answerOwnerProfileId,
                    value: existingComment.body,
                  ),
                ),
            ],
          ),
          if (existingComment != null && !showEditor) ...[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 36),
              child: Builder(
                builder: (context) {
                  final showReadableCue = _showsReadableCue(
                    existingComment.body,
                  );
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => _showReadableDetailSheet(
                          context,
                          label: '내 댓글',
                          title: '상대 답에 남긴 댓글',
                          body: existingComment.body,
                          actionLabel: readOnly ? null : '수정하기',
                          onAction: readOnly
                              ? null
                              : () => controller.updateAnswerCommentDraft(
                                  questionId: questionId,
                                  answerOwnerProfileId: answerOwnerProfileId,
                                  value: existingComment.body,
                                ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              existingComment.body,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: sans(
                                size: 13,
                                color: AlagagiColors.ink,
                                height: 1.55,
                              ),
                            ),
                            if (showReadableCue) ...[
                              const SizedBox(height: 5),
                              const _FullTextCue(),
                            ],
                          ],
                        ),
                      ),
                      if (existingComment.edited) ...[
                        const SizedBox(height: 8),
                        const _EditedBadge(),
                      ],
                    ],
                  );
                },
              ),
            ),
          ],
          if (showEditor) ...[
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F4),
                border: Border.all(color: const Color(0x336F7F63)),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AlagagiColors.line),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextFormField(
                      key: answerCommentFieldKey,
                      initialValue: inputValue,
                      maxLength: 120,
                      minLines: 1,
                      maxLines: 3,
                      onChanged: (value) => controller.updateAnswerCommentDraft(
                        questionId: questionId,
                        answerOwnerProfileId: answerOwnerProfileId,
                        value: value,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        hintText: existingComment == null
                            ? '이 답에 짧게 남겨볼까요?'
                            : '댓글을 다듬어볼까요?',
                      ),
                      style: sans(size: 13, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '짧고 편한 말투로 남겨요',
                          style: sans(size: 10.5, color: AlagagiColors.muted),
                        ),
                      ),
                      Text(
                        '$inputLength / 120',
                        style: sans(size: 10.5, color: AlagagiColors.muted),
                      ),
                    ],
                  ),
                  if (controller.state.commentError != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 14,
                          color: Color(0xFFB18472),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            controller.state.commentError!,
                            style: sans(
                              size: 11,
                              color: const Color(0xFFB18472),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (existingComment != null) ...[
                        SizedBox(
                          width: 88,
                          child: _CommentSecondaryButton(
                            key: answerCommentCancelButtonKey,
                            label: '취소',
                            onPressed: isSaving
                                ? null
                                : () => controller.cancelAnswerCommentDraft(
                                    questionId: questionId,
                                    answerOwnerProfileId: answerOwnerProfileId,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 9),
                      ],
                      Expanded(
                        flex: existingComment == null ? 1 : 2,
                        child: _CommentPrimaryButton(
                          key: answerCommentSubmitButtonKey,
                          label: isSaving
                              ? '저장 중'
                              : existingComment == null
                              ? '댓글 남기기'
                              : '수정 저장',
                          onPressed: isSaving
                              ? null
                              : () => controller.submitAnswerComment(
                                  questionId: questionId,
                                  answerOwnerProfileId: answerOwnerProfileId,
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          if (isSaveTarget) ...[
            const SizedBox(height: 10),
            _CommentSaveStatus(
              controller: controller,
              questionId: questionId,
              answerOwnerProfileId: answerOwnerProfileId,
            ),
          ],
        ],
      ),
    );
  }
}

class _CommentSaveStatus extends StatelessWidget {
  const _CommentSaveStatus({
    required this.controller,
    required this.questionId,
    required this.answerOwnerProfileId,
  });

  final AlagagiController controller;
  final String questionId;
  final String answerOwnerProfileId;

  @override
  Widget build(BuildContext context) {
    if (!controller.isCommentSaveTarget(
      questionId: questionId,
      answerOwnerProfileId: answerOwnerProfileId,
    )) {
      return const SizedBox.shrink();
    }

    final state = controller.state;
    final status = state.commentSaveStatus;
    final message = switch (status) {
      SaveStatus.saving => '댓글 저장 중이에요...',
      SaveStatus.saved => state.commentSaveFeedback,
      SaveStatus.failed => state.commentError,
      SaveStatus.idle => null,
    };
    if (message == null || message.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            message,
            style: sans(
              size: 11.5,
              color: status == SaveStatus.failed
                  ? AlagagiColors.sageDeep
                  : AlagagiColors.muted,
              height: 1.45,
            ),
          ),
        ),
        if (status == SaveStatus.failed)
          _InlineTextAction(
            label: '댓글 저장 다시 시도',
            onPressed: controller.retryAnswerCommentSave,
          ),
      ],
    );
  }
}

class _CommentIconButton extends StatelessWidget {
  const _CommentIconButton({
    super.key,
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        color: AlagagiColors.sageDeep,
        constraints: const BoxConstraints.tightFor(width: 34, height: 34),
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: AlagagiColors.line),
        ),
      ),
    );
  }
}

class _CommentSecondaryButton extends StatelessWidget {
  const _CommentSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AlagagiColors.ink,
          side: const BorderSide(color: AlagagiColors.line),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: serif(context, size: 13.5, weight: FontWeight.w800),
        ),
        child: Text(label, softWrap: false),
      ),
    );
  }
}

class _CommentPrimaryButton extends StatelessWidget {
  const _CommentPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AlagagiColors.sageDeep,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: serif(context, size: 13.5, weight: FontWeight.w800),
        ),
        child: Text(label),
      ),
    );
  }
}

class _EditedBadge extends StatelessWidget {
  const _EditedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F4),
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text('수정됨', style: sans(size: 10.5, color: AlagagiColors.muted)),
    );
  }
}

class _AnswerPreviewBlock extends StatelessWidget {
  const _AnswerPreviewBlock({
    super.key,
    required this.label,
    required this.body,
    this.accentColor = AlagagiColors.sageDeep,
    this.action,
    this.expanded = false,
    this.onToggle,
    this.onOpenFull,
  });

  final String label;
  final String body;
  final Color accentColor;
  final Widget? action;
  final bool expanded;
  final VoidCallback? onToggle;
  final VoidCallback? onOpenFull;

  @override
  Widget build(BuildContext context) {
    final isLong = body.length > _longAnswerPreviewLength;
    final showReadableCue = _showsReadableCue(body, expanded: expanded);
    final visibleBody = isLong && !expanded
        ? '${body.substring(0, _longAnswerPreviewLength).trimRight()}...'
        : body;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onOpenFull,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F4),
          border: Border.all(color: AlagagiColors.line),
          borderRadius: BorderRadius.circular(17),
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: serif(
                      context,
                      size: 13,
                      weight: FontWeight.w800,
                      color: accentColor,
                    ),
                  ),
                ),
                ?action,
              ],
            ),
            const SizedBox(height: 8),
            Text(
              visibleBody,
              style: sans(
                size: 13.5,
                color: const Color(0xFF4A4A46),
                height: 1.62,
              ),
            ),
            if ((isLong && onToggle != null) ||
                (showReadableCue && onOpenFull != null)) ...[
              const SizedBox(height: 6),
              Wrap(
                spacing: 14,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (isLong && onToggle != null)
                    _InlineTextAction(
                      label: expanded ? '접기' : '더 보기',
                      onPressed: onToggle,
                    ),
                  if (showReadableCue && onOpenFull != null)
                    const _FullTextCue(),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AnswerLine extends StatelessWidget {
  const _AnswerLine({
    required this.tag,
    required this.tagColor,
    required this.body,
    this.expanded = false,
    this.onToggle,
    this.onOpenFull,
  });

  final String tag;
  final Color tagColor;
  final String body;
  final bool expanded;
  final VoidCallback? onToggle;
  final VoidCallback? onOpenFull;

  @override
  Widget build(BuildContext context) {
    final isLong = body.length > _longAnswerPreviewLength;
    final showReadableCue = _showsReadableCue(body, expanded: expanded);
    final visibleBody = isLong && !expanded
        ? '${body.substring(0, _longAnswerPreviewLength).trimRight()}...'
        : body;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onOpenFull,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 48,
            child: Text(
              tag,
              style: serif(
                context,
                size: 13,
                weight: FontWeight.w700,
                color: tagColor,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  visibleBody,
                  style: sans(
                    size: 14,
                    color: const Color(0xFF4A4A46),
                    height: 1.65,
                  ),
                ),
                if ((isLong && onToggle != null) ||
                    (showReadableCue && onOpenFull != null)) ...[
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (isLong && onToggle != null)
                        _InlineTextAction(
                          label: expanded ? '접기' : '더 보기',
                          onPressed: onToggle,
                        ),
                      if (showReadableCue && onOpenFull != null)
                        const _FullTextCue(),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineTextAction extends StatelessWidget {
  const _InlineTextAction({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AlagagiColors.sageDeep,
        minimumSize: const Size(0, 30),
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(label, style: sans(size: 12, weight: FontWeight.w700)),
    );
  }
}

class _FullTextCue extends StatelessWidget {
  const _FullTextCue();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '전체 보기',
      button: true,
      child: Container(
        constraints: const BoxConstraints(minHeight: 30),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F4ED),
          border: Border.all(color: const Color(0x336F7F63)),
          borderRadius: BorderRadius.circular(999),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '펼쳐 읽기',
              style: sans(
                size: 11.5,
                weight: FontWeight.w800,
                color: AlagagiColors.sageDeep,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right_rounded,
              size: 15,
              color: AlagagiColors.sageDeep,
            ),
          ],
        ),
      ),
    );
  }
}

class _OpenReadableIconButton extends StatelessWidget {
  const _OpenReadableIconButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: '전체 보기',
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 44, height: 44),
      icon: Container(
        width: 31,
        height: 31,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F4ED),
          border: Border.all(color: const Color(0x336F7F63)),
          borderRadius: BorderRadius.circular(999),
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.open_in_full_rounded,
          size: 15,
          color: AlagagiColors.sageDeep,
        ),
      ),
    );
  }
}

void _showReadableDetailSheet(
  BuildContext context, {
  required String label,
  required String title,
  required String body,
  String? meta,
  String? actionLabel,
  VoidCallback? onAction,
}) {
  final trimmedMeta = meta?.trim();
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return DraggableScrollableSheet(
        initialChildSize: 0.62,
        minChildSize: 0.34,
        maxChildSize: 0.88,
        expand: false,
        builder: (_, scrollController) {
          return SafeArea(
            child: Container(
              key: readableDetailSheetKey,
              margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              decoration: BoxDecoration(
                color: AlagagiColors.paper,
                border: Border.all(color: AlagagiColors.line),
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x2E2C2B25),
                    blurRadius: 44,
                    offset: Offset(0, 18),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD7D5CC),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFF7FAF2), AlagagiColors.paper],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _ReadableDetailMark(label: label),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    label,
                                    style: sans(
                                      size: 10.5,
                                      weight: FontWeight.w800,
                                      color: AlagagiColors.sageDeep,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    title,
                                    style: serif(
                                      sheetContext,
                                      size: 19.5,
                                      weight: FontWeight.w800,
                                      height: 1.43,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            _ReadableDetailCloseButton(
                              onPressed: () => Navigator.of(sheetContext).pop(),
                            ),
                          ],
                        ),
                        if (trimmedMeta != null && trimmedMeta.isNotEmpty) ...[
                          const SizedBox(height: 13),
                          Wrap(
                            spacing: 7,
                            runSpacing: 7,
                            children: [_ReadableDetailPill(text: trimmedMeta)],
                          ),
                        ],
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                      children: [_ReadableDetailBodyCard(body: body)],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 44,
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(sheetContext).pop(),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AlagagiColors.muted,
                                side: const BorderSide(
                                  color: AlagagiColors.line,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                textStyle: sans(
                                  size: 13,
                                  weight: FontWeight.w700,
                                ),
                              ),
                              child: const Text('닫기'),
                            ),
                          ),
                        ),
                        if (actionLabel != null && onAction != null) ...[
                          const SizedBox(width: 10),
                          Expanded(
                            child: SizedBox(
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(sheetContext).pop();
                                  onAction();
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: AlagagiColors.sageDeep,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  textStyle: sans(
                                    size: 13,
                                    weight: FontWeight.w800,
                                  ),
                                ),
                                child: Text(actionLabel),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

class _ReadableDetailMark extends StatelessWidget {
  const _ReadableDetailMark({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.76),
        border: Border.all(color: const Color(0x336F7F63)),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Icon(
        _iconForLabel(label),
        size: 20,
        color: AlagagiColors.sageDeep,
      ),
    );
  }

  IconData _iconForLabel(String label) {
    if (label.contains('음악')) {
      return Icons.music_note_rounded;
    }
    if (label.contains('주식')) {
      return Icons.bar_chart_rounded;
    }
    if (label.contains('댓글')) {
      return Icons.chat_bubble_outline_rounded;
    }
    if (label.contains('소개')) {
      return Icons.badge_outlined;
    }
    return Icons.description_outlined;
  }
}

class _ReadableDetailCloseButton extends StatelessWidget {
  const _ReadableDetailCloseButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '닫기',
      child: SizedBox(
        width: 42,
        height: 42,
        child: IconButton(
          onPressed: onPressed,
          icon: const Icon(Icons.close_rounded, size: 20),
          color: AlagagiColors.muted,
          padding: EdgeInsets.zero,
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.72),
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: AlagagiColors.line),
              borderRadius: BorderRadius.circular(21),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReadableDetailPill extends StatelessWidget {
  const _ReadableDetailPill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 26),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        border: Border.all(color: const Color(0x266F7F63)),
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        text,
        style: sans(
          size: 11,
          weight: FontWeight.w700,
          color: AlagagiColors.muted,
          height: 1.25,
        ),
      ),
    );
  }
}

class _ReadableDetailBodyCard extends StatelessWidget {
  const _ReadableDetailBodyCard({required this.body});

  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEFA),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(21),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 19),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 1,
            bottom: 1,
            child: Container(
              width: 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: const LinearGradient(
                  colors: [AlagagiColors.sage, AlagagiColors.lavender],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              body,
              key: readableDetailBodyKey,
              style: sans(
                size: 14.2,
                color: const Color(0xFF3F3E39),
                height: 1.82,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showFirstVisitGuideBook(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return DraggableScrollableSheet(
        initialChildSize: 0.74,
        minChildSize: 0.42,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollController) {
          return SafeArea(
            child: Container(
              key: firstVisitGuideBookSheetKey,
              margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              decoration: BoxDecoration(
                color: AlagagiColors.paper,
                border: Border.all(color: AlagagiColors.line),
                borderRadius: BorderRadius.circular(26),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 32,
                    offset: Offset(0, 16),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD7D5CC),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'GUIDE BOOK',
                                style: sans(
                                  size: 10.5,
                                  weight: FontWeight.w800,
                                  color: AlagagiColors.sageDeep,
                                  letterSpacing: 1.6,
                                ),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                '헷갈릴 때만 다시 보는 안내서',
                                style: serif(
                                  sheetContext,
                                  size: 21,
                                  weight: FontWeight.w800,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                '읽어도 상대에게 알림이 가지 않습니다. 필요한 기능만 눌러서 확인하면 돼요.',
                                style: sans(
                                  size: 12.3,
                                  color: AlagagiColors.muted,
                                  height: 1.58,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: '닫기',
                          onPressed: () => Navigator.of(sheetContext).pop(),
                          icon: const Icon(Icons.close_rounded, size: 20),
                          color: AlagagiColors.muted,
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                      children: const [
                        _GuideBookFeatureRow(
                          icon: Icons.question_answer_outlined,
                          title: '오늘의 질문',
                          body: '답을 남기면 상대 답도 함께 열려요.',
                          where: '홈',
                        ),
                        SizedBox(height: 8),
                        _GuideBookFeatureRow(
                          icon: Icons.calendar_month_outlined,
                          title: '질문함과 기록',
                          body: '지난 질문을 보고 늦게 답할 질문을 확인해요.',
                          where: '질문',
                        ),
                        SizedBox(height: 8),
                        _GuideBookFeatureRow(
                          icon: Icons.music_note_outlined,
                          title: '음악 노트',
                          body: '요즘 듣는 곡과 짧은 메모를 남겨요.',
                          where: '음악',
                        ),
                        SizedBox(height: 8),
                        _GuideBookFeatureRow(
                          icon: Icons.badge_outlined,
                          title: '소개 카드',
                          body: '취향과 대화 방식을 편한 질문부터 채워요.',
                          where: '메뉴',
                        ),
                        SizedBox(height: 8),
                        _GuideBookFeatureRow(
                          icon: Icons.bookmark_add_outlined,
                          title: '언젠가, 같이',
                          body: '같이 해보고 싶은 일을 조용히 담아둬요.',
                          where: '메뉴',
                        ),
                        SizedBox(height: 8),
                        _GuideBookFeatureRow(
                          icon: Icons.tune_rounded,
                          title: '취향 매치',
                          body: '둘 중 하나를 고르고 서로의 취향을 가볍게 봐요.',
                          where: '메뉴',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                    child: SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(sheetContext).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AlagagiColors.sageDeep,
                          side: const BorderSide(color: Color(0x338A9A7E)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          textStyle: sans(size: 13, weight: FontWeight.w800),
                        ),
                        child: const Text('닫기'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

class _GuideBookFeatureRow extends StatelessWidget {
  const _GuideBookFeatureRow({
    required this.icon,
    required this.title,
    required this.body,
    required this.where,
  });

  final IconData icon;
  final String title;
  final String body;
  final String where;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AlagagiColors.paper,
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2EA),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, size: 19, color: AlagagiColors.sageDeep),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: sans(
                    size: 12.8,
                    weight: FontWeight.w800,
                    color: const Color(0xFF46443F),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  body,
                  style: sans(
                    size: 11.4,
                    color: AlagagiColors.muted,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 9),
          Container(
            height: 24,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F4),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              where,
              style: sans(
                size: 10,
                weight: FontWeight.w800,
                color: AlagagiColors.sageDeep,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerSaveStatus extends StatelessWidget {
  const _AnswerSaveStatus({required this.controller, this.questionId});

  final AlagagiController controller;
  final String? questionId;

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
    final status = state.answerSaveStatus;
    if (questionId != null && state.answerSaveQuestionId != questionId) {
      return const SizedBox.shrink();
    }
    final message = switch (status) {
      SaveStatus.saving => '저장 중이에요...',
      SaveStatus.saved => state.answerSaveFeedback,
      SaveStatus.failed => state.answerError,
      SaveStatus.idle => null,
    };
    if (message == null || message.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              message,
              style: sans(
                size: 12,
                color: status == SaveStatus.failed
                    ? AlagagiColors.sageDeep
                    : AlagagiColors.muted,
                height: 1.5,
              ),
            ),
          ),
          if (status == SaveStatus.failed)
            _InlineTextAction(
              key: answerRetryButtonKey,
              label: '다시 시도',
              onPressed: controller.retryAnswerSave,
            ),
        ],
      ),
    );
  }
}

class _InsightGrid extends StatelessWidget {
  const _InsightGrid({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final insight = controller.insight;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _InsightBox(
                title: '함께 답한 질문',
                value: '${insight.matchCount}',
                suffix: '개',
                highlighted: true,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _InsightBox(
                title: '주고받은 질문',
                value: '${insight.questionCount}',
                suffix: '개',
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _PaperCard(
          radius: 18,
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '닮은 취향 키워드',
                style: sans(
                  size: 11,
                  color: AlagagiColors.muted,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 8,
                children: insight.matchedKeywords.isEmpty
                    ? [
                        Text(
                          '기록은 답이 쌓이면 자연스럽게 만들어져요.',
                          style: sans(
                            size: 12.5,
                            color: AlagagiColors.muted,
                            height: 1.5,
                          ),
                        ),
                      ]
                    : insight.matchedKeywords.take(4).map((keyword) {
                        return _KeywordChip(label: keyword);
                      }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InsightBox extends StatelessWidget {
  const _InsightBox({
    required this.title,
    required this.value,
    required this.suffix,
    this.highlighted = false,
  });

  final String title;
  final String value;
  final String suffix;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: highlighted ? null : AlagagiColors.paper,
        gradient: highlighted
            ? const LinearGradient(
                colors: [AlagagiColors.softSage, AlagagiColors.sagePanel],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        border: highlighted ? null : Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: sans(size: 11, color: AlagagiColors.muted)),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: value),
                TextSpan(
                  text: suffix,
                  style: serif(
                    context,
                    size: 13,
                    color: AlagagiColors.muted,
                    weight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            style: serif(
              context,
              size: 30,
              weight: FontWeight.w800,
              color: highlighted ? AlagagiColors.sageDeep : AlagagiColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlusGrid extends StatelessWidget {
  const _PlusGrid({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PlusTile(
          icon: Icons.swap_horiz_rounded,
          title: '취향 매치',
          body: '둘 중 하나로 남기는 취향 힌트',
          onTap: () => controller.goTo(AlagagiRoute.balance),
        ),
        const SizedBox(height: 10),
        _PlusTile(
          icon: Icons.person_outline_rounded,
          title: '소개 카드',
          body: '편한 만큼 내 취향 남기기',
          onTap: () => controller.goTo(AlagagiRoute.profileCard),
        ),
        const SizedBox(height: 10),
        _PlusTile(
          icon: Icons.bookmark_border_rounded,
          title: '언젠가, 같이',
          body: '같이 해보고 싶은 것 담기',
          onTap: () => controller.goTo(AlagagiRoute.wishlist),
        ),
      ],
    );
  }
}

class _PlusTile extends StatelessWidget {
  const _PlusTile({
    required this.icon,
    required this.title,
    required this.body,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AlagagiColors.paper,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AlagagiColors.line),
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2EB),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 22, color: AlagagiColors.sageDeep),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: serif(context, size: 17, weight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      body,
                      style: sans(size: 12.5, color: AlagagiColors.muted),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 17,
                color: AlagagiColors.sageDeep,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnswerScreen extends StatefulWidget {
  const AnswerScreen({super.key, required this.controller});

  final AlagagiController controller;

  @override
  State<AnswerScreen> createState() => _AnswerScreenState();
}

class _AnswerScreenState extends State<AnswerScreen> {
  late final TextEditingController _answerController;

  @override
  void initState() {
    super.initState();
    _answerController = TextEditingController(
      text: widget.controller.state.draftAnswer,
    );
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.controller.activeAnswerQuestion;
    final state = widget.controller.state;
    final count = state.draftAnswer.length;
    final isSaving = state.answerSaveStatus == SaveStatus.saving;
    final isEditing = state.editingAnswer;
    final isToday = widget.controller.isActiveAnswerToday;
    final selectedDateContext = isToday
        ? null
        : _questionDateContext(state.selectedArchiveDateKey, question);

    return Stack(
      children: [
        _ScreenScroll(
          padding: const EdgeInsets.fromLTRB(28, 34, 28, 166),
          children: [
            _TopBar(
              title: isToday ? '오늘의 질문' : '늦게 답하기',
              trailing: 'DAY ${question.day}',
              onBack: () => widget.controller.goTo(
                isToday ? AlagagiRoute.home : AlagagiRoute.archive,
              ),
            ),
            if (selectedDateContext != null) ...[
              const SizedBox(height: 10),
              Text(
                selectedDateContext,
                textAlign: TextAlign.center,
                style: serif(
                  context,
                  size: 14,
                  weight: FontWeight.w700,
                  color: AlagagiColors.sageDeep,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              '${question.number}',
              style: serif(
                context,
                size: 64,
                weight: FontWeight.w800,
                color: const Color(0xFFECEAE2),
              ),
            ),
            Text(
              isToday ? 'TODAY\'S QUESTION' : 'PAST QUESTION',
              style: sans(
                size: 11,
                color: AlagagiColors.sageDeep,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              question.text,
              style: serif(
                context,
                size: 24,
                weight: FontWeight.w700,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            _PaperCard(
              radius: 20,
              padding: const EdgeInsets.all(20),
              child: TextField(
                key: answerFieldKey,
                controller: _answerController,
                minLines: 5,
                maxLines: 7,
                maxLength: 300,
                onChanged: widget.controller.updateDraftAnswer,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                  hintText: '떠오르는 대로 적어볼까요...',
                ),
                style: sans(size: 15, height: 1.7),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '$count / 300자',
                style: sans(size: 11, color: AlagagiColors.muted),
              ),
            ),
            const SizedBox(height: 18),
            const _HintBox(),
            const SizedBox(height: 18),
            const _PartnerLockedBox(),
            if (state.answerError != null) ...[
              const SizedBox(height: 12),
              Text(
                state.answerError!,
                style: sans(size: 12, color: AlagagiColors.sageDeep),
                textAlign: TextAlign.center,
              ),
              if (state.answerSaveStatus == SaveStatus.failed) ...[
                const SizedBox(height: 8),
                _InlineTextAction(
                  key: answerRetryButtonKey,
                  label: '저장 다시 시도',
                  onPressed: widget.controller.retryAnswerSave,
                ),
              ],
            ],
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(28, 18, 28, 26),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0x00F4F3EF), AlagagiColors.appBackground],
                begin: Alignment.topCenter,
                end: Alignment.center,
              ),
            ),
            child: Column(
              children: [
                if (isToday && !isEditing)
                  TextButton(
                    onPressed: isSaving ? null : widget.controller.skipToday,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '오늘은 답하기 어렵나요? ',
                            style: sans(size: 12, color: AlagagiColors.muted),
                          ),
                          TextSpan(
                            text: '내일 다시 보기',
                            style: sans(
                              size: 12,
                              color: AlagagiColors.sageDeep,
                              weight: FontWeight.w500,
                            ).copyWith(decoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                    ),
                  ),
                _PrimaryButton(
                  label: isEditing
                      ? '수정 저장하기'
                      : isToday
                      ? '답 남기고 ${state.partner.nickname}님 답 열어보기'
                      : '저장하기',
                  onPressed: isSaving
                      ? null
                      : widget.controller.submitActiveAnswer,
                  color: AlagagiColors.sageDeep,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HintBox extends StatelessWidget {
  const _HintBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2EB),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        children: [
          const Icon(
            Icons.eco_outlined,
            size: 17,
            color: AlagagiColors.sageDeep,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '정답은 없어요. 떠오르는 대로, 솔직한 한 줄이면 충분해요.',
              style: sans(
                size: 12,
                color: const Color(0xFF5A5A54),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PartnerLockedBox extends StatelessWidget {
  const _PartnerLockedBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AlagagiColors.line, width: 1.5),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Icon(
            Icons.lock_outline_rounded,
            size: 22,
            color: AlagagiColors.muted,
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: '상대 답은 내 답을 남기면\n'),
                TextSpan(
                  text: '같이 열려요',
                  style: sans(
                    size: 12.5,
                    color: AlagagiColors.lavender,
                    weight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            style: sans(size: 12.5, color: AlagagiColors.muted, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key, required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final items = controller.archiveItems;
    return _ScreenScroll(
      bottomNavigation: _BottomNav(controller: controller),
      children: [
        Text('질문', style: serif(context, size: 23, weight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(
          '그동안 주고받은 ${controller.insight.questionCount}개의 이야기',
          style: sans(size: 12.5, color: AlagagiColors.muted),
        ),
        const SizedBox(height: 16),
        _QuestionViewSwitch(controller: controller),
        const SizedBox(height: 16),
        _QuestionCalendar(controller: controller),
        const SizedBox(height: 14),
        _SelectedQuestionDetail(controller: controller),
        const SizedBox(height: 16),
        _ArchiveTabs(controller: controller),
        const SizedBox(height: 16),
        if (items.isEmpty)
          const _EmptyStateCard(text: '아직 쌓인 질문이 없어요. 오늘의 질문부터 천천히 시작해요.')
        else
          for (final item in items) ...[
            _ArchiveCard(
              controller: controller,
              item: item,
              partnerName: controller.state.partner.nickname,
            ),
            const SizedBox(height: 14),
          ],
      ],
    );
  }
}

class _QuestionCalendar extends StatelessWidget {
  const _QuestionCalendar({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final days = controller.visibleQuestionCalendarDays;
    if (days.isEmpty) {
      return const SizedBox.shrink();
    }
    final displayedDay = days.firstWhere(
      (day) => day.isInDisplayedMonth,
      orElse: () => days.first,
    );
    final selectedDate = DateTime.tryParse(displayedDay.dateKey);
    final title = selectedDate == null
        ? '질문 캘린더'
        : '${selectedDate.year}년 ${selectedDate.month}월';

    return _PaperCard(
      key: archiveCalendarKey,
      radius: 20,
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: serif(context, size: 17, weight: FontWeight.w800),
                ),
              ),
              _CalendarControlButton(
                buttonKey: archiveCalendarPreviousButtonKey,
                tooltip: '이전 달',
                icon: Icons.chevron_left_rounded,
                onPressed: controller.selectPreviousArchiveMonth,
              ),
              const SizedBox(width: 2),
              TextButton(
                key: archiveCalendarTodayButtonKey,
                style: TextButton.styleFrom(
                  minimumSize: const Size(42, 32),
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: controller.selectTodayArchiveMonth,
                child: Text(
                  '오늘',
                  style: sans(
                    size: 11,
                    color: AlagagiColors.sageDeep,
                    weight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 2),
              _CalendarControlButton(
                buttonKey: archiveCalendarNextButtonKey,
                tooltip: '다음 달',
                icon: Icons.chevron_right_rounded,
                onPressed: controller.selectNextArchiveMonth,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const _WeekdayLabels(),
          const SizedBox(height: 6),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            childAspectRatio: 1.05,
            children: [
              for (final day in days)
                _CalendarDayButton(
                  day: day,
                  onTap:
                      day.question == null ||
                          day.status == QuestionCalendarStatus.future ||
                          day.status == QuestionCalendarStatus.catalogEnded
                      ? null
                      : () => controller.selectArchiveDate(day.dateKey),
                ),
            ],
          ),
          const SizedBox(height: 14),
          const _CalendarLegend(),
        ],
      ),
    );
  }
}

class _CalendarControlButton extends StatelessWidget {
  const _CalendarControlButton({
    required this.buttonKey,
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final Key buttonKey;
  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        key: buttonKey,
        borderRadius: BorderRadius.circular(14),
        onTap: onPressed,
        child: SizedBox(
          width: 34,
          height: 32,
          child: Icon(
            icon,
            size: 20,
            color: onPressed == null
                ? const Color(0xFFC7C3BA)
                : AlagagiColors.sageDeep,
          ),
        ),
      ),
    );
  }
}

class _WeekdayLabels extends StatelessWidget {
  const _WeekdayLabels();

  @override
  Widget build(BuildContext context) {
    const weekdayLabels = ['월', '화', '수', '목', '금', '토', '일'];

    return Row(
      children: [
        for (final label in weekdayLabels)
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: sans(
                size: 10.5,
                color: AlagagiColors.muted,
                weight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

class _CalendarDayButton extends StatelessWidget {
  const _CalendarDayButton({required this.day, required this.onTap});

  final QuestionCalendarDay day;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(day.dateKey);
    final selected = day.isSelected;
    final disabled = onTap == null;
    final inDisplayedMonth = day.isInDisplayedMonth;
    final color = _statusColor(day.status);
    final foregroundColor = disabled
        ? const Color(0xFFC7C3BA)
        : inDisplayedMonth
        ? AlagagiColors.ink
        : AlagagiColors.muted;
    return Material(
      key: archiveCalendarDayButtonKey(day.dateKey),
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFFF0F2EB)
                : inDisplayedMonth
                ? Colors.white
                : const Color(0xFFFAF8F3),
            border: Border.all(
              color: day.isToday
                  ? AlagagiColors.sageDeep
                  : selected
                  ? AlagagiColors.sagePanel
                  : inDisplayedMonth
                  ? Colors.transparent
                  : AlagagiColors.line,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${date?.day ?? ''}',
                style: sans(
                  size: 11.5,
                  weight: day.isToday || selected
                      ? FontWeight.w700
                      : FontWeight.w400,
                  color: foregroundColor,
                ),
              ),
              const SizedBox(height: 4),
              _StatusDot(
                status: day.status,
                color: disabled ? const Color(0xFFDCD8CF) : color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.status, required this.color});

  final QuestionCalendarStatus status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (status == QuestionCalendarStatus.skippedByMe) {
      return Container(
        width: 12,
        height: 2,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
      );
    }
    if (status == QuestionCalendarStatus.unanswered) {
      return Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color),
        ),
      );
    }
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _CalendarLegend extends StatelessWidget {
  const _CalendarLegend();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 7,
      runSpacing: 7,
      children: const [
        _LegendItem(label: '미답', status: QuestionCalendarStatus.unanswered),
        _LegendItem(
          label: '내가 답함',
          status: QuestionCalendarStatus.myAnswerOnly,
        ),
        _LegendItem(
          label: '상대 답',
          status: QuestionCalendarStatus.partnerAnswerOnly,
        ),
        _LegendItem(label: '둘 다', status: QuestionCalendarStatus.bothAnswered),
        _LegendItem(label: '패스', status: QuestionCalendarStatus.skippedByMe),
        _LegendItem(label: '예정', status: QuestionCalendarStatus.future),
        _LegendItem(label: '없음', status: QuestionCalendarStatus.catalogEnded),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.label, required this.status});

  final String label;
  final QuestionCalendarStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StatusDot(status: status, color: _statusColor(status)),
          const SizedBox(width: 5),
          Text(label, style: sans(size: 10.5, color: AlagagiColors.muted)),
        ],
      ),
    );
  }
}

class _SelectedQuestionDetail extends StatelessWidget {
  const _SelectedQuestionDetail({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final day = controller.selectedQuestionCalendarDay;
    final question = day?.question;
    if (day == null) {
      return const SizedBox.shrink();
    }
    final statusLabel = _statusLabel(day.status);
    if (question == null || day.status == QuestionCalendarStatus.future) {
      return _PaperCard(
        radius: 22,
        padding: const EdgeInsets.all(19),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    _calendarDateLabel(day.dateKey),
                    style: serif(
                      context,
                      size: 13,
                      weight: FontWeight.w700,
                      color: AlagagiColors.sageDeep,
                    ),
                  ),
                ),
                _SmallBadge(label: day.isToday ? '오늘' : statusLabel),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              statusLabel,
              style: serif(context, size: 18, weight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              '이 날짜에는 아직 답할 질문이 없어요.',
              style: sans(size: 12.5, color: AlagagiColors.muted, height: 1.5),
            ),
          ],
        ),
      );
    }
    final myAnswer = controller.answerForQuestion(question.id);
    final partnerAnswer = myAnswer == null || myAnswer.skipped
        ? null
        : controller.partnerAnswerForQuestion(question.id);
    final receivedComment = myAnswer == null
        ? null
        : controller.commentForAnswer(
            question.id,
            myAnswer.profileId,
            controller.state.partner.id,
          );
    return _PaperCard(
      radius: 22,
      padding: const EdgeInsets.all(19),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _questionDateContext(day.dateKey, question),
                  style: serif(
                    context,
                    size: 13,
                    weight: FontWeight.w700,
                    color: AlagagiColors.sageDeep,
                  ),
                ),
              ),
              _SmallBadge(label: day.isToday ? '오늘' : statusLabel),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            question.text,
            style: serif(
              context,
              size: 19,
              weight: FontWeight.w700,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          if (myAnswer != null && !myAnswer.skipped)
            _AnswerPreviewBlock(
              key: answerPreviewBlockKey(
                myAnswer.questionId,
                myAnswer.profileId,
              ),
              label: '내 답',
              accentColor: AlagagiColors.sageDeep,
              body: myAnswer.body,
              onOpenFull: () => _showReadableDetailSheet(
                context,
                label: '내 답',
                title: question.text,
                body: myAnswer.body,
              ),
              expanded: controller.isAnswerExpanded(
                myAnswer.questionId,
                myAnswer.profileId,
              ),
              onToggle: () => controller.toggleAnswerExpanded(
                myAnswer.questionId,
                myAnswer.profileId,
              ),
            )
          else if (myAnswer != null && myAnswer.skipped)
            const _QuestionSupportBlock(
              title: '패스한 질문',
              body: '이날은 답하지 않고 지나갔어요. 빈 답변으로 보여주지 않아요.',
            )
          else
            Text(
              day.canLateAnswer ? '아직 내 답이 없어요.' : statusLabel,
              style: sans(size: 12.5, color: AlagagiColors.muted),
            ),
          if (receivedComment != null) ...[
            const SizedBox(height: 10),
            _ReadOnlyCommentBlock(
              label: '받은 댓글',
              body: receivedComment.body,
              onOpenFull: () => _showReadableDetailSheet(
                context,
                label: '받은 댓글',
                title: '내 답에 남겨진 댓글',
                body: receivedComment.body,
              ),
            ),
          ],
          if (partnerAnswer != null) ...[
            const SizedBox(height: 12),
            _AnswerPreviewBlock(
              key: answerPreviewBlockKey(
                partnerAnswer.questionId,
                partnerAnswer.profileId,
              ),
              label: '${controller.state.partner.nickname}님 답',
              accentColor: AlagagiColors.lavender,
              body: partnerAnswer.body,
              onOpenFull: () => _showReadableDetailSheet(
                context,
                label: '${controller.state.partner.nickname}님 답',
                title: question.text,
                body: partnerAnswer.body,
              ),
              expanded: controller.isAnswerExpanded(
                partnerAnswer.questionId,
                partnerAnswer.profileId,
              ),
              onToggle: () => controller.toggleAnswerExpanded(
                partnerAnswer.questionId,
                partnerAnswer.profileId,
              ),
            ),
            const SizedBox(height: 10),
            _AnswerCommentBox(
              controller: controller,
              questionId: partnerAnswer.questionId,
              answerOwnerProfileId: partnerAnswer.profileId,
              readOnly: true,
            ),
          ] else if (myAnswer != null && !myAnswer.skipped) ...[
            const SizedBox(height: 12),
            Text(
              '상대 답은 아직 기다리는 중이에요.',
              style: sans(size: 12.5, color: AlagagiColors.muted),
            ),
          ],
          _AnswerSaveStatus(controller: controller, questionId: question.id),
          const SizedBox(height: 16),
          if (day.canLateAnswer && myAnswer == null)
            _PrimaryButton(
              buttonKey: lateAnswerButtonKey,
              label: '늦게 답하기',
              onPressed: () => controller.startLateAnswer(question.id),
              color: AlagagiColors.sageDeep,
            )
          else if (day.isToday && myAnswer == null)
            _PrimaryButton(
              label: '오늘 답하기',
              onPressed: () => controller.goTo(AlagagiRoute.answer),
              color: AlagagiColors.sageDeep,
            ),
        ],
      ),
    );
  }
}

class _ReadOnlyCommentBlock extends StatelessWidget {
  const _ReadOnlyCommentBlock({
    required this.label,
    required this.body,
    this.onOpenFull,
  });

  final String label;
  final String body;
  final VoidCallback? onOpenFull;

  @override
  Widget build(BuildContext context) {
    final showReadableCue = _showsReadableCue(body);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onOpenFull,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: AlagagiColors.line),
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: sans(size: 11, color: AlagagiColors.muted)),
            const SizedBox(height: 4),
            Text(
              body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: sans(size: 13, height: 1.5),
            ),
            if (showReadableCue && onOpenFull != null) ...[
              const SizedBox(height: 5),
              const _FullTextCue(),
            ],
          ],
        ),
      ),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({required this.label, this.dark = false});

  final String label;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: dark
            ? Colors.white.withValues(alpha: 0.14)
            : const Color(0xFFF0F2EB),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      child: Text(
        label,
        style: sans(
          size: 10.5,
          color: dark ? Colors.white : AlagagiColors.sageDeep,
        ),
      ),
    );
  }
}

Color _statusColor(QuestionCalendarStatus status) {
  return switch (status) {
    QuestionCalendarStatus.myAnswerOnly => AlagagiColors.sage,
    QuestionCalendarStatus.partnerAnswerOnly => AlagagiColors.lavender,
    QuestionCalendarStatus.bothAnswered => AlagagiColors.sageDeep,
    QuestionCalendarStatus.skippedByMe => const Color(0xFFB18472),
    QuestionCalendarStatus.future => const Color(0xFFDDD9D0),
    QuestionCalendarStatus.catalogEnded => const Color(0xFFDDD9D0),
    QuestionCalendarStatus.unanswered => const Color(0xFFC7C3BA),
  };
}

String _statusLabel(QuestionCalendarStatus status) {
  return switch (status) {
    QuestionCalendarStatus.future => '아직 열리지 않았어요',
    QuestionCalendarStatus.unanswered => '미답',
    QuestionCalendarStatus.myAnswerOnly => '내 답만 있음',
    QuestionCalendarStatus.partnerAnswerOnly => '상대 답만 있음',
    QuestionCalendarStatus.bothAnswered => '둘 다 답함',
    QuestionCalendarStatus.skippedByMe => '패스',
    QuestionCalendarStatus.catalogEnded => '질문 없음',
  };
}

String _questionDateContext(String? dateKey, DailyQuestion question) {
  final date = dateKey == null ? null : DateTime.tryParse(dateKey);
  if (date == null) {
    return 'DAY ${question.day}';
  }
  return '${date.month}월 ${date.day}일 · DAY ${question.day}';
}

String _calendarDateLabel(String dateKey) {
  final date = DateTime.tryParse(dateKey);
  if (date == null) {
    return '선택한 날짜';
  }
  return '${date.month}월 ${date.day}일';
}

class _ArchiveTabs extends StatelessWidget {
  const _ArchiveTabs({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        _FilterPill(
          label: '전체',
          selected: controller.state.archiveFilter == ArchiveFilter.all,
          onTap: () => controller.setArchiveFilter(ArchiveFilter.all),
        ),
        _FilterPill(
          label: '둘 다 답함',
          selected:
              controller.state.archiveFilter == ArchiveFilter.bothAnswered,
          onTap: () => controller.setArchiveFilter(ArchiveFilter.bothAnswered),
        ),
        _FilterPill(
          label: '닮은 답',
          selected: controller.state.archiveFilter == ArchiveFilter.similar,
          onTap: () => controller.setArchiveFilter(ArchiveFilter.similar),
        ),
      ],
    );
  }
}

class _ArchiveCard extends StatelessWidget {
  const _ArchiveCard({
    required this.controller,
    required this.item,
    required this.partnerName,
  });

  final AlagagiController controller;
  final ArchiveItem item;
  final String partnerName;

  @override
  Widget build(BuildContext context) {
    final skipped = item.myAnswer?.skipped ?? false;
    final waiting =
        item.myAnswer != null && item.partnerAnswer == null && !skipped;
    return _PaperCard(
      radius: 20,
      dashed: waiting || skipped,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: waiting
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'No.${item.question.number} · ${item.myAnswer?.createdLabel ?? '오늘'}',
                style: serif(
                  context,
                  size: 12,
                  weight: FontWeight.w700,
                  color: AlagagiColors.sageDeep,
                ),
              ),
              Text(
                skipped
                    ? '패스'
                    : item.bothAnswered
                    ? '둘 다 답함'
                    : '답 기다리는 중',
                style: sans(size: 11, color: AlagagiColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item.question.text,
            style: serif(
              context,
              size: 16,
              weight: FontWeight.w700,
              height: 1.5,
            ),
            textAlign: waiting ? TextAlign.center : TextAlign.start,
          ),
          const SizedBox(height: 14),
          if (item.myAnswer == null)
            Text(
              '아직 답을 남기지 않았어요.',
              style: sans(size: 13, color: AlagagiColors.muted),
            )
          else if (skipped)
            Column(
              children: [
                Text(
                  '패스한 질문',
                  textAlign: TextAlign.center,
                  style: serif(
                    context,
                    size: 14,
                    weight: FontWeight.w800,
                    color: AlagagiColors.sageDeep,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '이날은 답하지 않고 지나갔어요.',
                  textAlign: TextAlign.center,
                  style: sans(
                    size: 13,
                    color: AlagagiColors.muted,
                    height: 1.5,
                  ),
                ),
              ],
            )
          else if (waiting)
            Column(
              children: [
                Text(
                  '내 답은 남겼어요.\n상대가 답하면 함께 열려요.',
                  textAlign: TextAlign.center,
                  style: sans(
                    size: 13,
                    color: AlagagiColors.muted,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 6),
                _InlineTextAction(
                  label: '내 답 보기',
                  onPressed: () => _showReadableDetailSheet(
                    context,
                    label: '내 답',
                    title: item.question.text,
                    body: item.myAnswer!.body,
                  ),
                ),
              ],
            )
          else ...[
            _AnswerLine(
              tag: '나',
              tagColor: AlagagiColors.sageDeep,
              body: item.myAnswer!.body,
              onOpenFull: () => _showReadableDetailSheet(
                context,
                label: '내 답',
                title: item.question.text,
                body: item.myAnswer!.body,
              ),
              expanded: controller.isAnswerExpanded(
                item.myAnswer!.questionId,
                item.myAnswer!.profileId,
              ),
              onToggle: () => controller.toggleAnswerExpanded(
                item.myAnswer!.questionId,
                item.myAnswer!.profileId,
              ),
            ),
            const SizedBox(height: 10),
            _AnswerLine(
              tag: partnerName,
              tagColor: AlagagiColors.lavender,
              body: item.partnerAnswer!.body,
              onOpenFull: () => _showReadableDetailSheet(
                context,
                label: '$partnerName님 답',
                title: item.question.text,
                body: item.partnerAnswer!.body,
              ),
              expanded: controller.isAnswerExpanded(
                item.partnerAnswer!.questionId,
                item.partnerAnswer!.profileId,
              ),
              onToggle: () => controller.toggleAnswerExpanded(
                item.partnerAnswer!.questionId,
                item.partnerAnswer!.profileId,
              ),
            ),
            const SizedBox(height: 10),
            _AnswerCommentBox(
              controller: controller,
              questionId: item.partnerAnswer!.questionId,
              answerOwnerProfileId: item.partnerAnswer!.profileId,
              readOnly: true,
            ),
          ],
          if (item.matchedKeywords.isNotEmpty) ...[
            const SizedBox(height: 12),
            _SimilarityBadge(keyword: item.matchedKeywords.first),
          ],
        ],
      ),
    );
  }
}

class RecordsScreen extends StatelessWidget {
  const RecordsScreen({super.key, required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final insight = controller.insight;
    final isEmpty = insight.questionCount == 0;
    return _ScreenScroll(
      bottomNavigation: _BottomNav(controller: controller),
      children: [
        Text('질문', style: serif(context, size: 23, weight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(
          '답변에서 보이는 작은 공통점',
          style: sans(size: 12.5, color: AlagagiColors.muted),
        ),
        const SizedBox(height: 16),
        _QuestionViewSwitch(controller: controller),
        const SizedBox(height: 18),
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AlagagiColors.softSage, AlagagiColors.sagePanel],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.all(26),
          child: Column(
            children: [
              _AvatarStack(
                me: controller.state.me,
                partner: controller.state.partner,
              ),
              const SizedBox(height: 12),
              Text(
                '함께 답한 질문',
                style: sans(
                  size: 11,
                  weight: FontWeight.w800,
                  color: const Color(0xFF5A6650),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 5),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: '${insight.matchCount}'),
                    TextSpan(
                      text: '개',
                      style: serif(
                        context,
                        size: 18,
                        weight: FontWeight.w700,
                        color: const Color(0xFF5A6650),
                      ),
                    ),
                  ],
                ),
                style: serif(
                  context,
                  size: 46,
                  weight: FontWeight.w800,
                  color: AlagagiColors.sageDeep,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isEmpty ? '기록은 답이 쌓이면 자연스럽게 만들어져요.' : '답변 속 공통점이 조금씩 보여요',
                style: sans(size: 12, color: const Color(0xFF5A6650)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const _SectionLabel('겹치는 키워드'),
        const SizedBox(height: 12),
        if (insight.matchedKeywords.isEmpty)
          const _EmptyStateCard(text: '아직 닮은 키워드는 없어요. 답이 쌓이면 여기에 보여드릴게요.')
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: insight.matchedKeywords
                .map((keyword) => _KeywordChip(label: keyword, leaf: true))
                .toList(),
          ),
        const SizedBox(height: 24),
        const _SectionLabel('숫자로 보는 대화'),
        const SizedBox(height: 12),
        _StatsGrid(insight: insight),
        const SizedBox(height: 24),
        const _SectionLabel('우리의 발자취'),
        const SizedBox(height: 12),
        if (insight.timeline.isEmpty)
          const _EmptyStateCard(text: '아직 남겨진 발자취가 없어요.')
        else
          _Timeline(events: insight.timeline),
      ],
    );
  }
}

class _QuestionViewSwitch extends StatelessWidget {
  const _QuestionViewSwitch({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final route = controller.state.route;
    return Row(
      children: [
        Expanded(
          child: _SegmentButton(
            label: '달력',
            selected: route == AlagagiRoute.archive,
            onTap: () => controller.goTo(AlagagiRoute.archive),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SegmentButton(
            label: '기록',
            selected: route == AlagagiRoute.records,
            onTap: () => controller.goTo(AlagagiRoute.records),
          ),
        ),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.insight});

  final RelationshipInsight insight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: '기록된 날',
                value: '${insight.daysTogether}',
                suffix: '일',
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _StatCard(
                title: '주고받은 질문',
                value: '${insight.questionCount}',
                suffix: '개',
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: '닮은 답',
                value: '${insight.matchCount}',
                suffix: '번',
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _StatCard(
                title: '가장 긴 답',
                value: '${insight.longestAnswerLength}',
                suffix: '자',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.suffix,
  });

  final String title;
  final String value;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    return _PaperCard(
      radius: 18,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: sans(size: 11, color: AlagagiColors.muted)),
          const SizedBox(height: 6),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: value),
                TextSpan(
                  text: suffix,
                  style: serif(context, size: 12, color: AlagagiColors.muted),
                ),
              ],
            ),
            style: serif(context, size: 28, weight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.events});

  final List<TimelineEvent> events;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: events.map((event) {
        return Padding(
          padding: const EdgeInsets.only(left: 6, bottom: 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: AlagagiColors.sage,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.dateLabel,
                      style: sans(size: 11, color: AlagagiColors.muted),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      event.description,
                      style: sans(size: 13.5, height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

enum _BalanceRecordFilter { all, withReason, noReason }

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key, required this.controller});

  final AlagagiController controller;

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  _BalanceRecordFilter _filter = _BalanceRecordFilter.all;
  String? _visibleResultQuestionId;

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final question = controller.activeBalanceQuestion;
    final selected = controller.activeBalanceSelection;
    final partnerChoice = controller.activePartnerBalanceSelection;
    final progressLabel =
        '${controller.state.activeBalanceIndex + 1} / ${controller.balanceQuestions.length}';

    return _ScreenScroll(
      padding: const EdgeInsets.fromLTRB(24, 34, 24, 44),
      children: [
        _TopBar(
          title: '취향 매치',
          trailing: progressLabel,
          onBack: () => controller.goTo(AlagagiRoute.home),
        ),
        const SizedBox(height: 16),
        _BalanceTodayCard(
          completedCount: controller.balanceCompletedCount,
          revealedCount: controller.balanceRevealedCount,
          totalCount: controller.balanceQuestions.length,
        ),
        const SizedBox(height: 16),
        _BalanceDeckCard(
          question: question,
          selected: selected,
          activeIndex: controller.state.activeBalanceIndex,
          count: controller.balanceQuestions.length,
          onSelect: (optionId) {
            if (selected == optionId) {
              return;
            }
            controller.selectBalanceOption(optionId);
            setState(() => _visibleResultQuestionId = null);
          },
        ),
        if (selected != null) ...[
          const SizedBox(height: 14),
          _BalanceReasonCard(
            question: question,
            selected: selected,
            initialReason: controller.activeBalanceReason ?? '',
            onSave: controller.saveBalanceReason,
          ),
          const SizedBox(height: 14),
          _BalanceRevealCard(
            question: question,
            selected: selected,
            partnerChoice: partnerChoice,
            partnerName: controller.state.partner.nickname,
            resultVisible: _visibleResultQuestionId == question.id,
            resultRevealed: controller.isBalanceResultRevealedFor(question),
            onToggleResult: partnerChoice == null
                ? null
                : () {
                    if (!controller.isBalanceResultRevealedFor(question)) {
                      controller.revealBalanceResult(question);
                    }
                    setState(() {
                      _visibleResultQuestionId =
                          _visibleResultQuestionId == question.id
                          ? null
                          : question.id;
                    });
                  },
          ),
        ],
        if (selected != null && _visibleResultQuestionId == question.id) ...[
          const SizedBox(height: 14),
          _BalanceResultCard(
            question: question,
            selected: selected,
            partnerChoice: partnerChoice,
            myName: controller.state.me.nickname,
            partnerName: controller.state.partner.nickname,
            onOpenMeetings: () => controller.goTo(AlagagiRoute.meetingPlans),
            onOpenPlaces: () => controller.goTo(AlagagiRoute.places),
            onOpenMusic: () => controller.goTo(AlagagiRoute.music),
          ),
        ],
        const SizedBox(height: 18),
        _BalanceResultBoxSection(
          controller: controller,
          expandedResultQuestionId: _visibleResultQuestionId,
          onRevealResult: controller.revealBalanceResult,
          onOpenMeetings: () => controller.goTo(AlagagiRoute.meetingPlans),
          onOpenPlaces: () => controller.goTo(AlagagiRoute.places),
          onOpenMusic: () => controller.goTo(AlagagiRoute.music),
        ),
        const SizedBox(height: 18),
        _BalanceRecordSection(
          controller: controller,
          filter: _filter,
          onFilterChanged: (filter) => setState(() => _filter = filter),
        ),
        const SizedBox(height: 18),
        _ProgressDots(
          activeIndex: controller.state.activeBalanceIndex,
          count: controller.balanceQuestions.length,
        ),
        const SizedBox(height: 16),
        _PrimaryButton(
          label: selected == null
              ? '먼저 하나를 골라주세요'
              : controller.isLastBalanceQuestion
              ? '완료'
              : '다음 취향',
          onPressed: selected == null ? null : controller.nextBalanceQuestion,
          color: selected == null
              ? const Color(0xFFC7C3BA)
              : AlagagiColors.sageDeep,
        ),
      ],
    );
  }
}

class _BalanceTodayCard extends StatelessWidget {
  const _BalanceTodayCard({
    required this.completedCount,
    required this.revealedCount,
    required this.totalCount,
  });

  final int completedCount;
  final int revealedCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final progress = totalCount == 0 ? 0.0 : completedCount / totalCount;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2F2F2B),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'TODAY TASTE',
                style: sans(
                  size: 10.5,
                  color: const Color(0xFFC9C9C2),
                  weight: FontWeight.w700,
                  letterSpacing: 2.2,
                ),
              ),
              const Spacer(),
              Container(
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0x22FFFFFF),
                  borderRadius: BorderRadius.circular(999),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '$completedCount/$totalCount',
                  style: sans(
                    size: 11,
                    color: Colors.white,
                    weight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '둘 중 하나만 골라도\n취향 기록이 쌓여요',
            style: serif(
              context,
              size: 22,
              weight: FontWeight.w800,
              height: 1.45,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            '결과는 내가 열어보기 전까지 조용히 잠겨 있어요.',
            style: sans(
              size: 12.5,
              color: const Color(0xFFE3E2DC),
              height: 1.65,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 7,
              value: progress.clamp(0.0, 1.0).toDouble(),
              color: const Color(0xFFD9C58B),
              backgroundColor: const Color(0x33FFFFFF),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _BalanceMiniPill(label: '내가 고른 카드 $completedCount개'),
              _BalanceMiniPill(label: '열어본 결과 $revealedCount개'),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceMiniPill extends StatelessWidget {
  const _BalanceMiniPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0x22FFFFFF),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0x22FFFFFF)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(label, style: sans(size: 11, color: const Color(0xFFEFEFE8))),
    );
  }
}

class _BalanceDeckCard extends StatelessWidget {
  const _BalanceDeckCard({
    required this.question,
    required this.selected,
    required this.activeIndex,
    required this.count,
    required this.onSelect,
  });

  final BalanceQuestion question;
  final String? selected;
  final int activeIndex;
  final int count;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: balanceDeckKey,
      decoration: BoxDecoration(
        color: AlagagiColors.paper,
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AlagagiColors.softSage,
                  borderRadius: BorderRadius.circular(999),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '취향 카드 ${activeIndex + 1}',
                  style: sans(
                    size: 11,
                    color: AlagagiColors.sageDeep,
                    weight: FontWeight.w800,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${activeIndex + 1} / $count',
                style: sans(
                  size: 11.5,
                  color: AlagagiColors.muted,
                  weight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            question.prompt,
            textAlign: TextAlign.center,
            style: serif(
              context,
              size: 22,
              weight: FontWeight.w800,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '지금 더 끌리는 쪽을 바로 골라주세요.',
            textAlign: TextAlign.center,
            style: sans(size: 12, color: AlagagiColors.muted, height: 1.5),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 188,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _BalanceDeckOption(
                        option: question.left,
                        selectedByMe: selected == question.left.id,
                        onTap: () => onSelect(question.left.id),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _BalanceDeckOption(
                        option: question.right,
                        selectedByMe: selected == question.right.id,
                        onTap: () => onSelect(question.right.id),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2F2F2B),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'VS',
                    style: serif(
                      context,
                      size: 13,
                      weight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceDeckOption extends StatelessWidget {
  const _BalanceDeckOption({
    required this.option,
    required this.selectedByMe,
    required this.onTap,
  });

  final BalanceOption option;
  final bool selectedByMe;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          constraints: const BoxConstraints(minHeight: 178),
          decoration: BoxDecoration(
            color: selectedByMe
                ? const Color(0xFFEEF3E8)
                : const Color(0xFFF8F8F4),
            border: Border.all(
              color: selectedByMe ? AlagagiColors.sageDeep : AlagagiColors.line,
              width: selectedByMe ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _BalanceOptionIcon(
                    optionId: option.id,
                    selected: selectedByMe,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.label,
                    style: serif(
                      context,
                      size: 18,
                      weight: FontWeight.w800,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    selectedByMe ? '내 선택' : '끌리는 쪽 고르기',
                    style: sans(
                      size: 11.5,
                      color: AlagagiColors.muted,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 25,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selectedByMe
                        ? const Color(0xFF2F2F2B)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 9),
                  child: Text(
                    selectedByMe ? '선택됨' : '고르기',
                    style: sans(
                      size: 10.5,
                      color: selectedByMe
                          ? Colors.white
                          : AlagagiColors.sageDeep,
                      weight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BalanceReasonCard extends StatelessWidget {
  const _BalanceReasonCard({
    required this.question,
    required this.selected,
    required this.initialReason,
    required this.onSave,
  });

  final BalanceQuestion question;
  final String selected;
  final String initialReason;
  final ValueChanged<String> onSave;

  @override
  Widget build(BuildContext context) {
    final selectedLabel = _balanceOptionLabel(question, selected);
    return Container(
      decoration: BoxDecoration(
        color: AlagagiColors.paper,
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(22),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '선택 이유 한 줄',
            style: serif(context, size: 16, weight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            '$selectedLabel 쪽을 고른 이유를 짧게 남기면 나중에 더 잘 기억나요.',
            style: sans(size: 12, color: AlagagiColors.muted, height: 1.55),
          ),
          const SizedBox(height: 12),
          _BalanceReasonField(initialValue: initialReason, onSave: onSave),
        ],
      ),
    );
  }
}

class _BalanceReasonField extends StatefulWidget {
  const _BalanceReasonField({required this.initialValue, required this.onSave});

  final String initialValue;
  final ValueChanged<String> onSave;

  @override
  State<_BalanceReasonField> createState() => _BalanceReasonFieldState();
}

class _BalanceReasonFieldState extends State<_BalanceReasonField> {
  late final TextEditingController _controller;
  Timer? _saveDebounce;
  late String _lastSavedValue;
  bool _hasPendingSave = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _lastSavedValue = widget.initialValue.trim();
  }

  @override
  void didUpdateWidget(covariant _BalanceReasonField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue &&
        _controller.text != widget.initialValue) {
      _saveDebounce?.cancel();
      _controller.text = widget.initialValue;
      _controller.selection = TextSelection.collapsed(
        offset: widget.initialValue.length,
      );
      _lastSavedValue = widget.initialValue.trim();
      _hasPendingSave = false;
    }
  }

  @override
  void dispose() {
    _saveDebounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _scheduleSave(String value) {
    _saveDebounce?.cancel();
    if (value.trim() == _lastSavedValue) {
      if (_hasPendingSave) {
        setState(() => _hasPendingSave = false);
      }
      return;
    }
    if (!_hasPendingSave) {
      setState(() => _hasPendingSave = true);
    }
    _saveDebounce = Timer(const Duration(milliseconds: 650), _flushSave);
  }

  void _flushSave() {
    final value = _controller.text;
    final trimmed = value.trim();
    if (trimmed == _lastSavedValue) {
      if (mounted) {
        setState(() => _hasPendingSave = false);
      }
      return;
    }
    widget.onSave(value);
    if (mounted) {
      setState(() {
        _lastSavedValue = trimmed;
        _hasPendingSave = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasSavedReason = _lastSavedValue.isNotEmpty;
    final statusText = _hasPendingSave
        ? '잠시 후 자동 저장돼요'
        : hasSavedReason
        ? '이유가 자동 저장됐어요'
        : '이유 없이 선택만 저장해도 괜찮아요';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          key: balanceReasonFieldKey,
          controller: _controller,
          minLines: 1,
          maxLines: 2,
          maxLength: 80,
          textInputAction: TextInputAction.done,
          onChanged: _scheduleSave,
          onSubmitted: (_) {
            _saveDebounce?.cancel();
            _flushSave();
          },
          decoration: InputDecoration(
            counterText: '',
            hintText: '예: 요즘 조용한 곳이 더 끌려요',
            hintStyle: sans(size: 12, color: const Color(0xFFAAA69A)),
            filled: true,
            fillColor: const Color(0xFFF8F8F4),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AlagagiColors.line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AlagagiColors.line),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AlagagiColors.sageDeep),
            ),
          ),
          style: sans(size: 13, color: const Color(0xFF3A3934), height: 1.45),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Icon(
              _hasPendingSave
                  ? Icons.more_horiz_rounded
                  : Icons.check_circle_outline_rounded,
              size: 16,
              color: _hasPendingSave
                  ? AlagagiColors.muted
                  : AlagagiColors.sageDeep,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                statusText,
                style: sans(
                  size: 11.5,
                  color: AlagagiColors.muted,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BalanceRevealCard extends StatelessWidget {
  const _BalanceRevealCard({
    required this.question,
    required this.selected,
    required this.partnerChoice,
    required this.partnerName,
    required this.resultVisible,
    required this.resultRevealed,
    required this.onToggleResult,
  });

  final BalanceQuestion question;
  final String selected;
  final String? partnerChoice;
  final String partnerName;
  final bool resultVisible;
  final bool resultRevealed;
  final VoidCallback? onToggleResult;

  @override
  Widget build(BuildContext context) {
    final selectedLabel = _balanceOptionLabel(question, selected);
    final hasPartnerChoice = partnerChoice != null;
    return Container(
      decoration: BoxDecoration(
        color: AlagagiColors.paper,
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(22),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: hasPartnerChoice
                      ? AlagagiColors.softSage
                      : const Color(0xFFF8F8F4),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(
                  hasPartnerChoice
                      ? Icons.lock_open_rounded
                      : Icons.hourglass_empty_rounded,
                  size: 18,
                  color: AlagagiColors.sageDeep,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '내 선택이 저장됐어요',
                      style: serif(context, size: 16, weight: FontWeight.w800),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$selectedLabel 쪽으로 남겨둘게요.',
                      style: sans(
                        size: 12,
                        color: AlagagiColors.muted,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            hasPartnerChoice
                ? resultRevealed
                      ? '이미 열어본 결과예요. 원할 때 다시 펼쳐볼 수 있어요.'
                      : '서로의 선택이 준비됐어요. 결과는 버튼을 눌렀을 때만 열립니다.'
                : '$partnerName님 선택이 생기면 결과가 열려요. 지금은 내 취향만 조용히 저장해둘게요.',
            style: sans(size: 12.5, color: AlagagiColors.muted, height: 1.6),
          ),
          if (hasPartnerChoice) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 42,
              child: OutlinedButton(
                key: balanceResultToggleButtonKey,
                onPressed: onToggleResult,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AlagagiColors.sageDeep,
                  side: const BorderSide(color: Color(0x338A9A7E)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  resultVisible
                      ? '결과 접기'
                      : resultRevealed
                      ? '결과 다시 보기'
                      : '결과 열어보기',
                  style: sans(size: 13, weight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BalanceResultCard extends StatelessWidget {
  const _BalanceResultCard({
    required this.question,
    required this.selected,
    required this.partnerChoice,
    required this.myName,
    required this.partnerName,
    required this.onOpenMeetings,
    required this.onOpenPlaces,
    required this.onOpenMusic,
  });

  final BalanceQuestion question;
  final String? selected;
  final String? partnerChoice;
  final String myName;
  final String partnerName;
  final VoidCallback onOpenMeetings;
  final VoidCallback onOpenPlaces;
  final VoidCallback onOpenMusic;

  @override
  Widget build(BuildContext context) {
    final selected = this.selected;
    final partnerChoice = this.partnerChoice;
    final hasPartnerChoice = selected != null && partnerChoice != null;
    final sameChoice = hasPartnerChoice && selected == partnerChoice;
    final title = selected == null
        ? '오늘의 카드를 골라볼까요?'
        : partnerChoice == null
        ? '$partnerName님 선택을 기다리는 중'
        : sameChoice
        ? '같은 취향이 열렸어요'
        : '다른 취향이 이야기로 남았어요';
    final body = selected == null
        ? '내가 먼저 고르기 전에는 상대 선택을 보여주지 않아요.'
        : partnerChoice == null
        ? '$partnerName님 선택이 생기면 결과가 열려요. 지금은 내 취향만 조용히 저장해둘게요.'
        : sameChoice
        ? '둘 다 ${_balanceOptionLabel(question, selected)} 쪽을 골랐어요. 다음 만남이나 장소를 정할 때 바로 참고하기 좋아요.'
        : '$myName님은 ${_balanceOptionLabel(question, selected)}, $partnerName님은 ${_balanceOptionLabel(question, partnerChoice)} 쪽이에요. 서로 다른 선택도 자연스러운 대화거리가 됩니다.';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2F2F2B),
        borderRadius: BorderRadius.circular(22),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            selected == null
                ? 'READY'
                : partnerChoice == null
                ? 'WAITING'
                : 'RESULT',
            style: sans(
              size: 10.5,
              color: const Color(0xFFC9C9C2),
              weight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: serif(
              context,
              size: 19,
              weight: FontWeight.w800,
              color: Colors.white,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: sans(size: 13, color: const Color(0xFFF2F1EB), height: 1.65),
          ),
          if (selected != null) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _BalanceResultChoice(
                    label: '$myName 선택',
                    value: _balanceOptionLabel(question, selected),
                    highlighted: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _BalanceResultChoice(
                    label: '$partnerName 선택',
                    value: partnerChoice == null
                        ? '아직 기다리는 중'
                        : _balanceOptionLabel(question, partnerChoice),
                    highlighted: sameChoice,
                  ),
                ),
              ],
            ),
          ],
          if (hasPartnerChoice) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _BalanceRouteChip(
                  icon: Icons.event_note_outlined,
                  label: '만남 계획',
                  onTap: onOpenMeetings,
                ),
                _BalanceRouteChip(
                  icon: Icons.place_outlined,
                  label: '장소 보기',
                  onTap: onOpenPlaces,
                ),
                _BalanceRouteChip(
                  icon: Icons.music_note_outlined,
                  label: '음악 노트',
                  onTap: onOpenMusic,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _BalanceResultChoice extends StatelessWidget {
  const _BalanceResultChoice({
    required this.label,
    required this.value,
    required this.highlighted,
  });

  final String label;
  final String value;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: highlighted ? const Color(0x22D9C58B) : const Color(0x14FFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x18FFFFFF)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: sans(size: 10.5, color: const Color(0xFFC9C9C2)),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: sans(
              size: 12.5,
              color: Colors.white,
              weight: FontWeight.w800,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceRouteChip extends StatelessWidget {
  const _BalanceRouteChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0x1FFFFFFF),
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 11),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15, color: const Color(0xFFEFEFE8)),
              const SizedBox(width: 5),
              Text(
                label,
                style: sans(
                  size: 11.5,
                  color: const Color(0xFFEFEFE8),
                  weight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BalanceResultBoxSection extends StatelessWidget {
  const _BalanceResultBoxSection({
    required this.controller,
    required this.expandedResultQuestionId,
    required this.onRevealResult,
    required this.onOpenMeetings,
    required this.onOpenPlaces,
    required this.onOpenMusic,
  });

  final AlagagiController controller;
  final String? expandedResultQuestionId;
  final ValueChanged<BalanceQuestion> onRevealResult;
  final VoidCallback onOpenMeetings;
  final VoidCallback onOpenPlaces;
  final VoidCallback onOpenMusic;

  @override
  Widget build(BuildContext context) {
    final items = controller.balanceQuestions.where((question) {
      return controller.balanceSelectionFor(question) != null;
    }).toList();
    final revealableCount = items.where((question) {
      return controller.isBalanceResultReadyFor(question) &&
          !controller.isBalanceResultRevealedFor(question);
    }).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '결과함',
                style: serif(context, size: 17, weight: FontWeight.w800),
              ),
            ),
            Text(
              revealableCount == 0 ? '잠긴 결과 없음' : '열 수 있음 $revealableCount개',
              style: sans(size: 11.5, color: AlagagiColors.muted),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '서로의 선택은 내가 직접 열어본 카드에서만 보여요.',
          style: sans(size: 12, color: AlagagiColors.muted, height: 1.5),
        ),
        const SizedBox(height: 10),
        if (items.isEmpty)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AlagagiColors.paper,
              border: Border.all(color: AlagagiColors.line),
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.all(15),
            child: Text(
              '아직 결과함에 들어간 카드가 없어요. 오늘의 취향을 하나 고르면 결과 상태를 여기서 볼 수 있습니다.',
              style: sans(size: 12.5, color: AlagagiColors.muted, height: 1.6),
            ),
          )
        else
          Column(
            children: items.map((question) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _BalanceResultBoxTile(
                  question: question,
                  selected: controller.balanceSelectionFor(question)!,
                  partnerChoice: controller.partnerBalanceSelectionFor(
                    question,
                  ),
                  revealed: controller.isBalanceResultRevealedFor(question),
                  suppressInlineResult: expandedResultQuestionId == question.id,
                  myName: controller.state.me.nickname,
                  partnerName: controller.state.partner.nickname,
                  onReveal: () => onRevealResult(question),
                  onOpenMeetings: onOpenMeetings,
                  onOpenPlaces: onOpenPlaces,
                  onOpenMusic: onOpenMusic,
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}

class _BalanceResultBoxTile extends StatelessWidget {
  const _BalanceResultBoxTile({
    required this.question,
    required this.selected,
    required this.partnerChoice,
    required this.revealed,
    required this.suppressInlineResult,
    required this.myName,
    required this.partnerName,
    required this.onReveal,
    required this.onOpenMeetings,
    required this.onOpenPlaces,
    required this.onOpenMusic,
  });

  final BalanceQuestion question;
  final String selected;
  final String? partnerChoice;
  final bool revealed;
  final bool suppressInlineResult;
  final String myName;
  final String partnerName;
  final VoidCallback onReveal;
  final VoidCallback onOpenMeetings;
  final VoidCallback onOpenPlaces;
  final VoidCallback onOpenMusic;

  @override
  Widget build(BuildContext context) {
    final ready = partnerChoice != null;
    final statusLabel = !ready
        ? '기다림'
        : revealed
        ? '열어본 결과'
        : '결과 잠금';
    final statusColor = revealed
        ? const Color(0xFF2F2F2B)
        : ready
        ? const Color(0xFFF8EFD9)
        : const Color(0xFFF8F8F4);
    final statusTextColor = revealed
        ? Colors.white
        : ready
        ? const Color(0xFF8C7333)
        : AlagagiColors.muted;
    final copy = !ready
        ? '$partnerName님 선택을 기다리는 중이에요. 내 선택은 조용히 저장돼 있어요.'
        : revealed
        ? '이미 열어본 결과예요. 비교 내용과 다음 액션을 다시 볼 수 있어요.'
        : '서로의 선택이 준비됐어요. 결과를 열기 전까지 비교 내용은 숨겨둘게요.';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AlagagiColors.paper,
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  question.prompt,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: sans(
                    size: 13,
                    color: const Color(0xFF45443F),
                    weight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(999),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 9),
                child: Text(
                  statusLabel,
                  style: sans(
                    size: 10.5,
                    color: statusTextColor,
                    weight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            copy,
            style: sans(size: 11.8, color: AlagagiColors.muted, height: 1.55),
          ),
          if (!revealed) ...[
            const SizedBox(height: 9),
            _BalanceRecordValue(
              label: '내 선택',
              value: _balanceOptionLabel(question, selected),
            ),
          ],
          if (ready && !revealed) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: OutlinedButton(
                onPressed: onReveal,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AlagagiColors.sageDeep,
                  side: const BorderSide(color: Color(0x338A9A7E)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  '결과 열어보기',
                  style: sans(size: 12.5, weight: FontWeight.w800),
                ),
              ),
            ),
          ],
          if (revealed && partnerChoice != null && !suppressInlineResult) ...[
            const SizedBox(height: 11),
            _BalanceInlineResultSummary(
              question: question,
              selected: selected,
              partnerChoice: partnerChoice!,
              myName: myName,
              partnerName: partnerName,
              onOpenMeetings: onOpenMeetings,
              onOpenPlaces: onOpenPlaces,
              onOpenMusic: onOpenMusic,
            ),
          ] else if (revealed && suppressInlineResult) ...[
            const SizedBox(height: 9),
            _BalanceRecordValue(label: '상세', value: '위에 열려 있어요'),
          ],
        ],
      ),
    );
  }
}

class _BalanceInlineResultSummary extends StatelessWidget {
  const _BalanceInlineResultSummary({
    required this.question,
    required this.selected,
    required this.partnerChoice,
    required this.myName,
    required this.partnerName,
    required this.onOpenMeetings,
    required this.onOpenPlaces,
    required this.onOpenMusic,
  });

  final BalanceQuestion question;
  final String selected;
  final String partnerChoice;
  final String myName;
  final String partnerName;
  final VoidCallback onOpenMeetings;
  final VoidCallback onOpenPlaces;
  final VoidCallback onOpenMusic;

  @override
  Widget build(BuildContext context) {
    final sameChoice = selected == partnerChoice;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2F2F2B),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sameChoice ? '같은 취향이 열렸어요' : '다른 취향이 이야기로 남았어요',
            style: serif(
              context,
              size: 15,
              weight: FontWeight.w800,
              color: Colors.white,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              Expanded(
                child: _BalanceResultChoice(
                  label: '$myName 선택',
                  value: _balanceOptionLabel(question, selected),
                  highlighted: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _BalanceResultChoice(
                  label: '$partnerName 선택',
                  value: _balanceOptionLabel(question, partnerChoice),
                  highlighted: sameChoice,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _BalanceRouteChip(
                icon: Icons.event_note_outlined,
                label: '만남 계획',
                onTap: onOpenMeetings,
              ),
              _BalanceRouteChip(
                icon: Icons.place_outlined,
                label: '장소 보기',
                onTap: onOpenPlaces,
              ),
              _BalanceRouteChip(
                icon: Icons.music_note_outlined,
                label: '음악 노트',
                onTap: onOpenMusic,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceRecordSection extends StatelessWidget {
  const _BalanceRecordSection({
    required this.controller,
    required this.filter,
    required this.onFilterChanged,
  });

  final AlagagiController controller;
  final _BalanceRecordFilter filter;
  final ValueChanged<_BalanceRecordFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final records = controller.balanceQuestions.where((question) {
      final selected = controller.balanceSelectionFor(question);
      if (selected == null) {
        return false;
      }
      final hasReason = (controller.balanceReasonFor(question) ?? '')
          .trim()
          .isNotEmpty;
      return switch (filter) {
        _BalanceRecordFilter.all => true,
        _BalanceRecordFilter.withReason => hasReason,
        _BalanceRecordFilter.noReason => !hasReason,
      };
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '내 취향 노트',
                style: serif(context, size: 17, weight: FontWeight.w800),
              ),
            ),
            Text(
              '${records.length}개',
              style: sans(size: 11.5, color: AlagagiColors.muted),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _BalanceRecordFilter.values.map((item) {
              final selected = item == filter;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _BalanceFilterChip(
                  filter: item,
                  selected: selected,
                  onTap: () => onFilterChanged(item),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 10),
        if (records.isEmpty)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AlagagiColors.paper,
              border: Border.all(color: AlagagiColors.line),
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.all(15),
            child: Text(
              _emptyRecordCopy(filter),
              style: sans(size: 12.5, color: AlagagiColors.muted, height: 1.6),
            ),
          )
        else
          Column(
            children: records.map((question) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _BalanceRecordTile(
                  question: question,
                  selected: controller.balanceSelectionFor(question)!,
                  reason: controller.balanceReasonFor(question),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}

class _BalanceFilterChip extends StatelessWidget {
  const _BalanceFilterChip({
    required this.filter,
    required this.selected,
    required this.onTap,
  });

  final _BalanceRecordFilter filter;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: balanceRecordFilterButtonKey(filter.name),
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF2F2F2B) : AlagagiColors.paper,
            border: Border.all(
              color: selected ? const Color(0xFF2F2F2B) : AlagagiColors.line,
            ),
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            _filterLabel(filter),
            style: sans(
              size: 12,
              color: selected ? Colors.white : AlagagiColors.muted,
              weight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _BalanceRecordTile extends StatelessWidget {
  const _BalanceRecordTile({
    required this.question,
    required this.selected,
    required this.reason,
  });

  final BalanceQuestion question;
  final String selected;
  final String? reason;

  @override
  Widget build(BuildContext context) {
    final reason = this.reason?.trim();
    final hasReason = reason != null && reason.isNotEmpty;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AlagagiColors.paper,
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  question.prompt,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: sans(
                    size: 13,
                    color: const Color(0xFF45443F),
                    weight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F4),
                  borderRadius: BorderRadius.circular(999),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 9),
                child: Text(
                  hasReason ? '메모 있음' : '선택만 저장',
                  style: sans(
                    size: 10.5,
                    color: AlagagiColors.muted,
                    weight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              _BalanceRecordValue(
                label: '내 선택',
                value: _balanceOptionLabel(question, selected),
              ),
              const _BalanceRecordValue(label: '결과', value: '결과함에서만 공개'),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            hasReason ? reason : '아직 이유를 남기지 않았어요.',
            style: sans(size: 11.5, color: AlagagiColors.muted, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _BalanceRecordValue extends StatelessWidget {
  const _BalanceRecordValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F4),
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      child: Text(
        '$label · $value',
        style: sans(
          size: 11,
          color: const Color(0xFF57564E),
          weight: FontWeight.w700,
        ),
      ),
    );
  }
}

String _balanceOptionLabel(BalanceQuestion question, String? optionId) {
  if (optionId == question.left.id) {
    return question.left.label;
  }
  if (optionId == question.right.id) {
    return question.right.label;
  }
  return '아직 선택 전';
}

String _filterLabel(_BalanceRecordFilter filter) {
  return switch (filter) {
    _BalanceRecordFilter.all => '전체',
    _BalanceRecordFilter.withReason => '이유 있음',
    _BalanceRecordFilter.noReason => '메모 없음',
  };
}

String _emptyRecordCopy(_BalanceRecordFilter filter) {
  return switch (filter) {
    _BalanceRecordFilter.all => '아직 남긴 취향이 없어요. 오늘의 카드를 하나 골라보면 기록이 시작됩니다.',
    _BalanceRecordFilter.withReason => '아직 이유를 남긴 취향이 없어요. 짧게 한 줄만 적어도 충분합니다.',
    _BalanceRecordFilter.noReason => '메모 없이 저장된 취향이 없어요.',
  };
}

class _BalanceOptionIcon extends StatelessWidget {
  const _BalanceOptionIcon({required this.optionId, required this.selected});

  final String optionId;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Icon(
      _iconForOption(optionId),
      size: 34,
      color: selected ? AlagagiColors.sageDeep : const Color(0xFF6F7567),
    );
  }

  IconData _iconForOption(String id) {
    return switch (id) {
      'sea' => Icons.water_drop_outlined,
      'forest' || 'mountain' => Icons.landscape_outlined,
      'home' => Icons.home_outlined,
      'walk' || 'outside' => Icons.directions_walk_rounded,
      'quiet' => Icons.local_cafe_outlined,
      'dessert' => Icons.cake_outlined,
      'calm' => Icons.movie_outlined,
      'funny' => Icons.mood_outlined,
      'brunch' || 'familiar' => Icons.restaurant_outlined,
      'evening' => Icons.nights_stay_outlined,
      'reserved' => Icons.event_available_outlined,
      'spontaneous' || 'new' => Icons.explore_outlined,
      'deep' => Icons.forum_outlined,
      'light' => Icons.chat_bubble_outline_rounded,
      _ => Icons.tune_rounded,
    };
  }
}

class ProfileCardScreen extends StatefulWidget {
  const ProfileCardScreen({super.key, required this.controller});

  final AlagagiController controller;

  @override
  State<ProfileCardScreen> createState() => _ProfileCardScreenState();
}

class _ProfileCardScreenState extends State<ProfileCardScreen> {
  String? _editingSlotId;
  String _slotDraft = '';
  String _selectedCategory = '전체';
  bool _customCardDraftVisible = false;

  AlagagiController get controller => widget.controller;

  void _startEditing(ProfileSlot slot) {
    setState(() {
      _editingSlotId = slot.id;
      _slotDraft = slot.value ?? '';
    });
  }

  void _cancelEditing() {
    setState(() {
      _editingSlotId = null;
      _slotDraft = '';
    });
  }

  void _saveSlot(ProfileSlot slot, [String? draftOverride]) {
    final value = (draftOverride ?? _slotDraft).trim();
    if (value.isEmpty) {
      return;
    }
    controller.fillProfileSlot(slot.id, value);
    setState(() {
      _editingSlotId = null;
      _slotDraft = '';
    });
  }

  void _skipSlot(ProfileSlot slot) {
    controller.skipProfileSlot(slot.id);
    if (_editingSlotId == slot.id) {
      _cancelEditing();
    }
  }

  void _hideSlot(ProfileSlot slot) {
    controller.hideProfileSlot(slot.id);
    if (_editingSlotId == slot.id) {
      _cancelEditing();
    }
  }

  void _restoreSlot(ProfileSlot slot) {
    controller.restoreProfileSlot(slot.id);
  }

  void _deleteSlot(ProfileSlot slot) {
    controller.deleteCustomProfileSlot(slot.id);
    if (_editingSlotId == slot.id) {
      _cancelEditing();
    }
  }

  String? _saveCustomCard(String title, String body, String category) {
    final error = controller.addCustomProfileSlot(
      title: title,
      value: body,
      category: category,
    );
    if (error == null) {
      setState(() => _customCardDraftVisible = false);
    }
    return error;
  }

  void _selectCategory(String category) {
    setState(() => _selectedCategory = category);
  }

  @override
  Widget build(BuildContext context) {
    final card = controller.activeProfileCard;
    final isMine = card.profile.isMe;
    final selectedSlot = isMine && _editingSlotId != null
        ? _slotById(card.slots, _editingSlotId!)
        : null;
    final filteredSlots = _filteredSlots(card.slots);
    final filledSlots = _filledSlots(filteredSlots);
    final pendingSlots = _pendingSlots(filteredSlots);
    final recommendedSlot = _recommendedSlot(card);
    return _ScreenScroll(
      bottomNavigation: _BottomNav(controller: controller),
      children: [
        _TopBar(
          title: '소개 카드',
          trailing: '',
          onBack: () => controller.goTo(AlagagiRoute.home),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _SegmentButton(
                label: '${controller.state.partner.nickname}님 카드',
                selected:
                    controller.state.profileCardTab == ProfileCardTab.partner,
                onTap: () {
                  _cancelEditing();
                  controller.setProfileCardTab(ProfileCardTab.partner);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _SegmentButton(
                label: '내 카드',
                selected: controller.state.profileCardTab == ProfileCardTab.me,
                onTap: () {
                  _cancelEditing();
                  controller.setProfileCardTab(ProfileCardTab.me);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _ProfileSummaryCard(card: card),
        if (isMine) ...[
          const SizedBox(height: 14),
          _ProfileCustomCardEntry(
            customCount: card.customCount,
            onTap: () {
              _cancelEditing();
              setState(() => _customCardDraftVisible = true);
            },
          ),
          if (_customCardDraftVisible) ...[
            const SizedBox(height: 12),
            _ProfileCustomCardPanel(
              onSave: _saveCustomCard,
              onCancel: () => setState(() => _customCardDraftVisible = false),
            ),
          ],
          const SizedBox(height: 16),
          _ProfileCategoryChips(
            selectedCategory: _selectedCategory,
            onSelected: _selectCategory,
          ),
          if (selectedSlot != null) ...[
            const SizedBox(height: 14),
            _ProfileEditorPanel(
              slot: selectedSlot,
              draft: _slotDraft,
              onChanged: (value) => setState(() => _slotDraft = value),
              onSave: (value) => _saveSlot(selectedSlot, value),
              onCancel: _cancelEditing,
            ),
          ],
          const SizedBox(height: 18),
          _ProfileSectionHeader(
            title: _selectedCategory == '전체'
                ? '작성한 카드'
                : '$_selectedCategory에 남긴 카드',
            meta: filledSlots.isEmpty ? '아직 비어 있어요' : '최근 카드 먼저',
          ),
          const SizedBox(height: 10),
          _ProfileSlotList(
            slots: filledSlots,
            editingSlotId: _editingSlotId,
            emptyText: _selectedCategory == '전체'
                ? '아직 작성한 카드가 없어요. 편한 질문 하나부터 남겨봐요.'
                : '이 분류에는 아직 작성한 카드가 없어요.',
            onEdit: _startEditing,
            onSkip: _skipSlot,
            onHide: _hideSlot,
            onRestore: _restoreSlot,
            onDelete: _deleteSlot,
          ),
          const SizedBox(height: 18),
          _ProfileSectionHeader(
            title: '편한 질문',
            meta: pendingSlots.isEmpty
                ? '모두 정리됨'
                : '${pendingSlots.length}개 남음',
          ),
          const SizedBox(height: 10),
          _ProfileRecommendCard(
            slot: recommendedSlot,
            onUse: _startEditing,
            onSkip: _skipSlot,
          ),
          if (pendingSlots.isNotEmpty) ...[
            const SizedBox(height: 10),
            _ProfileSlotGrid(
              slots: pendingSlots,
              editingSlotId: _editingSlotId,
              onEdit: _startEditing,
              onSkip: _skipSlot,
              onHide: _hideSlot,
              onRestore: _restoreSlot,
              onDelete: _deleteSlot,
            ),
          ],
          if (_hiddenSlots(card.slots).isNotEmpty) ...[
            const SizedBox(height: 16),
            _ProfileHiddenSlotsPanel(
              slots: _hiddenSlots(card.slots),
              onRestore: _restoreSlot,
            ),
          ],
        ] else ...[
          const SizedBox(height: 14),
          _ProfileCategoryChips(
            selectedCategory: _selectedCategory,
            onSelected: _selectCategory,
          ),
          const SizedBox(height: 14),
          _ProfileSectionHeader(
            title: _selectedCategory == '전체'
                ? '모든 답변'
                : '$_selectedCategory 답변',
            meta: filteredSlots.where((slot) => slot.value != null).isEmpty
                ? '아직 없음'
                : '${filteredSlots.where((slot) => slot.value != null).length}개',
          ),
          const SizedBox(height: 10),
          _ProfilePartnerReadList(slots: filteredSlots),
        ],
      ],
    );
  }

  List<ProfileSlot> _filteredSlots(List<ProfileSlot> slots) {
    final visibleSlots = slots.where((slot) => !slot.hidden);
    if (_selectedCategory == '전체') {
      return visibleSlots.toList();
    }
    return visibleSlots
        .where((slot) => slot.category == _selectedCategory)
        .toList();
  }

  List<ProfileSlot> _filledSlots(List<ProfileSlot> slots) {
    final filled = slots.where((slot) => slot.value != null).toList();
    filled.sort((a, b) {
      if (a.custom != b.custom) {
        return a.custom ? -1 : 1;
      }
      final aUpdatedAt = a.updatedAt;
      final bUpdatedAt = b.updatedAt;
      if (aUpdatedAt != null && bUpdatedAt != null) {
        return bUpdatedAt.compareTo(aUpdatedAt);
      }
      return 0;
    });
    return filled;
  }

  List<ProfileSlot> _pendingSlots(List<ProfileSlot> slots) {
    return slots.where((slot) => slot.value == null).toList();
  }

  List<ProfileSlot> _hiddenSlots(List<ProfileSlot> slots) {
    return slots.where((slot) => slot.hidden && !slot.custom).toList();
  }

  ProfileSlot? _recommendedSlot(ProfileCardData card) {
    final filteredEmpty = _filteredSlots(
      card.slots,
    ).where((slot) => slot.value == null && !slot.skipped).toList();
    if (filteredEmpty.isNotEmpty) {
      return filteredEmpty.first;
    }
    return _firstEmptySlot(card.slots);
  }

  ProfileSlot? _slotById(List<ProfileSlot> slots, String slotId) {
    for (final slot in slots) {
      if (slot.id == slotId) {
        return slot;
      }
    }
    return null;
  }

  ProfileSlot? _firstEmptySlot(List<ProfileSlot> slots) {
    for (final slot in slots) {
      if (slot.value == null && !slot.skipped && !slot.hidden) {
        return slot;
      }
    }
    return null;
  }
}

class _ProfileSlotList extends StatelessWidget {
  const _ProfileSlotList({
    required this.slots,
    required this.editingSlotId,
    required this.emptyText,
    required this.onEdit,
    required this.onSkip,
    required this.onHide,
    required this.onRestore,
    required this.onDelete,
  });

  final List<ProfileSlot> slots;
  final String? editingSlotId;
  final String emptyText;
  final ValueChanged<ProfileSlot> onEdit;
  final ValueChanged<ProfileSlot> onSkip;
  final ValueChanged<ProfileSlot> onHide;
  final ValueChanged<ProfileSlot> onRestore;
  final ValueChanged<ProfileSlot> onDelete;

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) {
      return _InlineEmptyState(text: emptyText);
    }
    return Column(
      children: [
        for (final slot in slots) ...[
          _ProfileSlotCard(
            slot: slot,
            selected: editingSlotId == slot.id,
            onEdit: () => onEdit(slot),
            onSkip: () => onSkip(slot),
            onHide: () => onHide(slot),
            onRestore: () => onRestore(slot),
            onDelete: () => onDelete(slot),
          ),
          if (slot != slots.last) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _ProfileSummaryCard extends StatelessWidget {
  const _ProfileSummaryCard({required this.card});

  final ProfileCardData card;

  @override
  Widget build(BuildContext context) {
    final isMine = card.profile.isMe;
    final progress = card.totalCount == 0
        ? 0.0
        : card.filledCount / card.totalCount;
    final customFilledCount = card.slots
        .where((slot) => !slot.hidden && slot.custom && slot.value != null)
        .length;
    final title = isMine ? '내 소개 서랍' : '${card.profile.nickname}님이 남긴 소개';
    final subtitle = isMine ? '편한 만큼 남기고, 애매한 질문은 숨겨두기' : '채워진 답만 보여요';
    final dark = !isMine;
    return Container(
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF2F2F2B) : null,
        gradient: dark
            ? null
            : const LinearGradient(
                colors: [AlagagiColors.paper, Color(0xFFF3F5EE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        border: Border.all(
          color: dark ? const Color(0x332F2F2B) : AlagagiColors.line,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: dark ? const Color(0x2A2F2F2B) : const Color(0x08000000),
            blurRadius: dark ? 34 : 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      padding: const EdgeInsets.all(19),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: isMine
                      ? AlagagiColors.softSage
                      : const Color(0xFFF0EDF4),
                  borderRadius: BorderRadius.circular(19),
                ),
                alignment: Alignment.center,
                child: Text(
                  card.profile.avatar,
                  style: const TextStyle(fontSize: 25),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: serif(
                        context,
                        size: 21,
                        weight: FontWeight.w800,
                        color: dark ? Colors.white : AlagagiColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: sans(
                        size: 12.2,
                        color: dark
                            ? const Color(0xFFD5D3CB)
                            : AlagagiColors.muted,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              if (isMine)
                Container(
                  height: 31,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2F2F2B),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    '${card.filledCount} / ${card.totalCount}',
                    style: sans(
                      size: 11,
                      color: Colors.white,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: dark
                  ? const Color(0x24FFFFFF)
                  : const Color(0xFFE6E9DF),
              valueColor: AlwaysStoppedAnimation<Color>(
                dark ? const Color(0xFFF4ECD9) : AlagagiColors.lavender,
              ),
            ),
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: _ProfileSummaryStatCell(
                  value: '${card.filledCount}',
                  label: isMine ? '작성함' : '답변',
                  dark: dark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ProfileSummaryStatCell(
                  value: '$customFilledCount',
                  label: '직접 카드',
                  dark: dark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ProfileSummaryStatCell(
                  value: isMine ? '${card.hiddenCount}' : '${card.totalCount}',
                  label: isMine ? '숨김' : '전체 카드',
                  dark: dark,
                ),
              ),
            ],
          ),
          if (!isMine) ...[
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                color: const Color(0x1AFFFFFF),
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              child: Row(
                children: [
                  const Icon(
                    Icons.mark_chat_read_outlined,
                    size: 18,
                    color: Color(0xFFF4ECD9),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      customFilledCount > 0
                          ? '직접 만든 카드도 함께 올라와 있어요'
                          : '상대가 채운 카드만 조용히 보여줘요',
                      style: sans(
                        size: 11.5,
                        color: const Color(0xFFD5D3CB),
                        height: 1.45,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProfileSummaryStatCell extends StatelessWidget {
  const _ProfileSummaryStatCell({
    required this.value,
    required this.label,
    required this.dark,
  });

  final String value;
  final String label;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 54),
      decoration: BoxDecoration(
        color: dark
            ? const Color(0x14FFFFFF)
            : Colors.white.withValues(alpha: 0.5),
        border: Border.all(
          color: dark ? const Color(0x16FFFFFF) : AlagagiColors.line,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: sans(
              size: 17,
              weight: FontWeight.w800,
              color: dark ? Colors.white : AlagagiColors.ink,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: sans(
              size: 10.8,
              weight: FontWeight.w700,
              color: dark ? const Color(0xFFCFCBC1) : AlagagiColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCustomCardEntry extends StatelessWidget {
  const _ProfileCustomCardEntry({
    required this.customCount,
    required this.onTap,
  });

  final int customCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: profileCustomCardAddButtonKey,
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2F2F2B),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x242F2F2B),
              blurRadius: 28,
              offset: Offset(0, 16),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0x1FFFFFFF),
                borderRadius: BorderRadius.circular(999),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.add_rounded,
                size: 21,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '내 질문으로 카드 추가',
                    style: sans(
                      size: 13.5,
                      color: Colors.white,
                      weight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '기본 질문이 애매하면 직접 만들어 남겨요',
                    style: sans(size: 11.5, color: const Color(0xFFD9D7CF)),
                  ),
                ],
              ),
            ),
            Container(
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: customCount > 0
                    ? const Color(0xFFF4ECD9)
                    : const Color(0x1FFFFFFF),
                borderRadius: BorderRadius.circular(999),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                '$customCount개',
                style: sans(
                  size: 11.5,
                  color: customCount > 0
                      ? const Color(0xFF8B6E31)
                      : const Color(0xFFD9D7CF),
                  weight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCustomCardPanel extends StatefulWidget {
  const _ProfileCustomCardPanel({required this.onSave, required this.onCancel});

  final String? Function(String title, String body, String category) onSave;
  final VoidCallback onCancel;

  @override
  State<_ProfileCustomCardPanel> createState() =>
      _ProfileCustomCardPanelState();
}

class _ProfileCustomCardPanelState extends State<_ProfileCustomCardPanel> {
  static const categories = ['직접', '취향', '하루', '대화', '함께'];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  String _selectedCategory = '직접';
  String? _error;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _submit() {
    final error = widget.onSave(
      _titleController.text,
      _bodyController.text,
      _selectedCategory,
    );
    if (error != null) {
      setState(() => _error = error);
    }
  }

  OutlineInputBorder _inputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(17),
      borderSide: BorderSide(color: color),
    );
  }

  Widget _fieldLabel(String label, String trailing) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: sans(
            size: 11.5,
            color: AlagagiColors.muted,
            weight: FontWeight.w800,
          ),
        ),
        Text(
          trailing,
          style: sans(
            size: 11.5,
            color: AlagagiColors.muted,
            weight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleLength = _titleController.text.characters.length;
    final bodyLength = _bodyController.text.characters.length;
    return Container(
      key: profileCustomCardPanelKey,
      decoration: BoxDecoration(
        color: AlagagiColors.paper,
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AlagagiColors.paper, Color(0xFFEEF2E8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border(bottom: BorderSide(color: AlagagiColors.line)),
            ),
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CARD STUDIO',
                  style: sans(
                    size: 10.5,
                    color: AlagagiColors.sageDeep,
                    weight: FontWeight.w800,
                    letterSpacing: 1.8,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '내가 편한 질문으로\n소개를 남겨요',
                  style: serif(
                    context,
                    size: 21,
                    weight: FontWeight.w800,
                    height: 1.34,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  '답변이 저장된 뒤에만 상대 카드에 보여요. 작성 중인 내용은 공유되지 않아요.',
                  style: sans(
                    size: 12.5,
                    color: AlagagiColors.muted,
                    height: 1.58,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 15, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _fieldLabel('카드 제목', '$titleLength / 32'),
                const SizedBox(height: 7),
                TextField(
                  key: profileCustomTitleFieldKey,
                  controller: _titleController,
                  maxLength: 32,
                  onChanged: (_) => setState(() => _error = null),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: '예: 요즘 내가 자주 하는 생각',
                    filled: true,
                    fillColor: Colors.white,
                    border: _inputBorder(AlagagiColors.line),
                    enabledBorder: _inputBorder(AlagagiColors.line),
                    focusedBorder: _inputBorder(AlagagiColors.sageDeep),
                  ),
                  style: sans(size: 13.5),
                ),
                const SizedBox(height: 12),
                _fieldLabel('답변', '$bodyLength / 120'),
                const SizedBox(height: 7),
                TextField(
                  key: profileCustomBodyFieldKey,
                  controller: _bodyController,
                  maxLength: 120,
                  minLines: 4,
                  maxLines: 6,
                  onChanged: (_) => setState(() => _error = null),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: '내가 공유하고 싶은 답변을 편하게 적어주세요',
                    filled: true,
                    fillColor: Colors.white,
                    border: _inputBorder(AlagagiColors.line),
                    enabledBorder: _inputBorder(AlagagiColors.line),
                    focusedBorder: _inputBorder(AlagagiColors.sageDeep),
                  ),
                  style: sans(size: 13.5, height: 1.65),
                ),
                const SizedBox(height: 12),
                _fieldLabel('분류', '상대 카드에서도 표시'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final category in categories)
                      _ProfileCustomCategoryChip(
                        category: category,
                        selected: _selectedCategory == category,
                        onTap: () => setState(() {
                          _selectedCategory = category;
                          _error = null;
                        }),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F2E7),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    '저장하면 상대의 카드 화면에 새 카드로 올라가고, 새로 도착한 것에도 표시됩니다.',
                    style: sans(
                      size: 11.8,
                      color: const Color(0xFF816A39),
                      height: 1.52,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    _error!,
                    style: sans(
                      size: 12,
                      color: const Color(0xFFB3605C),
                      weight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                SizedBox(
                  width: 88,
                  height: 48,
                  child: OutlinedButton(
                    key: profileCustomCancelButtonKey,
                    onPressed: widget.onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AlagagiColors.muted,
                      side: const BorderSide(color: AlagagiColors.line),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: sans(size: 13, weight: FontWeight.w800),
                    ),
                    child: const Text('취소'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      key: profileCustomSubmitButtonKey,
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AlagagiColors.sageDeep,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: sans(size: 13, weight: FontWeight.w900),
                      ),
                      child: const Text('카드 저장'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCustomCategoryChip extends StatelessWidget {
  const _ProfileCustomCategoryChip({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final String category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: profileCustomCategoryChipKey(category),
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AlagagiColors.softSage : const Color(0xFFF8F8F4),
          border: Border.all(
            color: selected ? const Color(0x338A9A7E) : AlagagiColors.line,
          ),
          borderRadius: BorderRadius.circular(999),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 11),
        child: Text(
          category,
          style: sans(
            size: 12,
            color: selected ? AlagagiColors.sageDeep : AlagagiColors.muted,
            weight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _ProfileCategoryChips extends StatelessWidget {
  const _ProfileCategoryChips({
    required this.selectedCategory,
    required this.onSelected,
  });

  final String selectedCategory;
  final ValueChanged<String> onSelected;

  static const categories = ['전체', '직접', '취향', '하루', '대화', '함께'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final category in categories) ...[
            _ProfileCategoryChip(
              category: category,
              selected: selectedCategory == category,
              onTap: () => onSelected(category),
            ),
            if (category != categories.last) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _ProfileCategoryChip extends StatelessWidget {
  const _ProfileCategoryChip({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final String category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: profileCategoryChipKey(category),
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        height: 34,
        decoration: BoxDecoration(
          color: selected ? AlagagiColors.softSage : AlagagiColors.paper,
          border: Border.all(
            color: selected ? const Color(0x338A9A7E) : AlagagiColors.line,
          ),
          borderRadius: BorderRadius.circular(999),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: selected ? AlagagiColors.sageDeep : AlagagiColors.muted,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              category,
              style: sans(
                size: 12,
                color: selected ? AlagagiColors.sageDeep : AlagagiColors.muted,
                weight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileRecommendCard extends StatelessWidget {
  const _ProfileRecommendCard({
    required this.slot,
    required this.onUse,
    required this.onSkip,
  });

  final ProfileSlot? slot;
  final ValueChanged<ProfileSlot> onUse;
  final ValueChanged<ProfileSlot> onSkip;

  @override
  Widget build(BuildContext context) {
    final slot = this.slot;
    if (slot == null) {
      return const _EmptyStateCard(text: '지금 보이는 카드팩은 모두 채워졌어요.');
    }
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2E8),
        border: Border.all(color: const Color(0x338A9A7E)),
        borderRadius: BorderRadius.circular(22),
      ),
      padding: const EdgeInsets.all(17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TODAY PICK',
            style: sans(
              size: 10.5,
              color: AlagagiColors.sageDeep,
              weight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            slot.label,
            style: serif(
              context,
              size: 18,
              weight: FontWeight.w800,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            slot.inputHint,
            style: sans(
              size: 12.5,
              color: const Color(0xFF7F8876),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 13),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              TextButton.icon(
                key: profileRecommendedSlotButtonKey,
                onPressed: () => onUse(slot),
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('이 질문 쓰기'),
                style: TextButton.styleFrom(
                  backgroundColor: AlagagiColors.sageDeep,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 10,
                  ),
                  textStyle: sans(size: 12, weight: FontWeight.w700),
                ),
              ),
              TextButton(
                key: profileRecommendedSlotSkipButtonKey,
                onPressed: () => onSkip(slot),
                style: TextButton.styleFrom(
                  foregroundColor: AlagagiColors.muted,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  textStyle: sans(size: 12, weight: FontWeight.w700),
                ),
                child: const Text('오늘은 넘기기'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileEditorPanel extends StatefulWidget {
  const _ProfileEditorPanel({
    required this.slot,
    required this.draft,
    required this.onChanged,
    required this.onSave,
    required this.onCancel,
  });

  final ProfileSlot slot;
  final String draft;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSave;
  final VoidCallback onCancel;

  @override
  State<_ProfileEditorPanel> createState() => _ProfileEditorPanelState();
}

class _ProfileEditorPanelState extends State<_ProfileEditorPanel> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.draft);
  }

  @override
  void didUpdateWidget(covariant _ProfileEditorPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.slot.id != widget.slot.id) {
      _controller.text = widget.draft;
      _controller.selection = TextSelection.collapsed(
        offset: _controller.text.length,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final draftLength = _controller.text.characters.length;
    return Container(
      key: profileEditorPanelKey,
      decoration: BoxDecoration(
        color: AlagagiColors.paper,
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFAFAF5), Color(0xFFEEF2E8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border(bottom: BorderSide(color: AlagagiColors.line)),
            ),
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.slot.category.toUpperCase(),
                  style: sans(
                    size: 10.5,
                    color: AlagagiColors.sageDeep,
                    weight: FontWeight.w700,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.slot.label,
                  style: serif(
                    context,
                    size: 20,
                    weight: FontWeight.w800,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  '너무 설명하려고 하지 않아도 돼요. 떠오르는 장면 하나만 적어도 충분합니다.',
                  style: sans(
                    size: 12.5,
                    color: AlagagiColors.muted,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final suggestion in _suggestionsForSlot(widget.slot))
                  Container(
                    height: 31,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8F4),
                      border: Border.all(color: AlagagiColors.line),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      suggestion,
                      style: sans(
                        size: 11.5,
                        color: AlagagiColors.muted,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AlagagiColors.line),
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: TextFormField(
                key: profileSlotFieldKey(widget.slot.id),
                controller: _controller,
                maxLength: 120,
                minLines: 4,
                maxLines: 6,
                onChanged: (value) {
                  setState(() {});
                  widget.onChanged(value);
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                  hintText: widget.slot.inputHint,
                ),
                style: sans(size: 13.5, height: 1.7),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '한 줄이어도 괜찮아요',
                  style: sans(size: 11.5, color: AlagagiColors.muted),
                ),
                Text(
                  '$draftLength / 120',
                  style: sans(size: 11.5, color: AlagagiColors.muted),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
            child: Row(
              children: [
                SizedBox(
                  width: 92,
                  height: 48,
                  child: OutlinedButton(
                    key: profileSlotCancelButtonKey(widget.slot.id),
                    onPressed: widget.onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AlagagiColors.muted,
                      side: const BorderSide(color: AlagagiColors.line),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('취소'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      key: profileSlotSaveButtonKey(widget.slot.id),
                      onPressed: _controller.text.trim().isEmpty
                          ? null
                          : () => widget.onSave(_controller.text),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AlagagiColors.sageDeep,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: const Color(0xFFE2E0D8),
                        disabledForegroundColor: AlagagiColors.muted,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: sans(size: 13.5, weight: FontWeight.w700),
                      ),
                      child: const Text('카드 저장'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<String> _suggestionsForSlot(ProfileSlot slot) {
    return switch (slot.id) {
      'rest' || 'comfort' => ['퇴근 후 조용한 시간', '커피 한 잔', '걷는 시간', '정리된 방'],
      'cafe' => ['창가 자리', '조용한 음악', '넓은 테이블', '따뜻한 조명'],
      'walk' || 'neighborhood' => ['강변', '공원', '낯선 동네', '해 질 때'],
      'talk_style' || 'pace' => ['조금 천천히', '생각할 시간', '짧은 답도 편하게', '부담 없이'],
      _ => ['요즘 떠오른 것', '가볍게 한 줄', '작은 장면', '편한 만큼'],
    };
  }
}

class _ProfileSectionHeader extends StatelessWidget {
  const _ProfileSectionHeader({required this.title, required this.meta});

  final String title;
  final String meta;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: serif(context, size: 16, weight: FontWeight.w800),
          ),
        ),
        Text(meta, style: sans(size: 11.5, color: AlagagiColors.muted)),
      ],
    );
  }
}

class _ProfileSlotGrid extends StatelessWidget {
  const _ProfileSlotGrid({
    required this.slots,
    required this.editingSlotId,
    required this.onEdit,
    required this.onSkip,
    required this.onHide,
    required this.onRestore,
    required this.onDelete,
  });

  final List<ProfileSlot> slots;
  final String? editingSlotId;
  final ValueChanged<ProfileSlot> onEdit;
  final ValueChanged<ProfileSlot> onSkip;
  final ValueChanged<ProfileSlot> onHide;
  final ValueChanged<ProfileSlot> onRestore;
  final ValueChanged<ProfileSlot> onDelete;

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) {
      return const _EmptyStateCard(text: '이 카테고리에는 아직 카드가 없어요.');
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 10) / 2;
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final slot in slots)
              SizedBox(
                width: cardWidth,
                child: _ProfileSlotCard(
                  slot: slot,
                  selected: editingSlotId == slot.id,
                  onEdit: () => onEdit(slot),
                  onSkip: () => onSkip(slot),
                  onHide: () => onHide(slot),
                  onRestore: () => onRestore(slot),
                  onDelete: () => onDelete(slot),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ProfileHiddenSlotsPanel extends StatelessWidget {
  const _ProfileHiddenSlotsPanel({
    required this.slots,
    required this.onRestore,
  });

  final List<ProfileSlot> slots;
  final ValueChanged<ProfileSlot> onRestore;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: profileHiddenSlotsPanelKey,
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAF5),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '숨긴 질문',
            style: sans(
              size: 13,
              color: const Color(0xFF45443F),
              weight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '기본 질문은 삭제 대신 숨겨두고, 필요하면 다시 꺼낼 수 있어요.',
            style: sans(size: 12, color: AlagagiColors.muted, height: 1.5),
          ),
          const SizedBox(height: 10),
          for (final slot in slots) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    slot.label,
                    style: sans(
                      size: 12.5,
                      color: const Color(0xFF45443F),
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
                TextButton(
                  key: profileSlotRestoreButtonKey(slot.id),
                  onPressed: () => onRestore(slot),
                  style: TextButton.styleFrom(
                    foregroundColor: AlagagiColors.sageDeep,
                    textStyle: sans(size: 12, weight: FontWeight.w700),
                  ),
                  child: const Text('다시 보기'),
                ),
              ],
            ),
            if (slot != slots.last)
              const Divider(height: 14, color: AlagagiColors.line),
          ],
        ],
      ),
    );
  }
}

class _ProfileSlotCard extends StatelessWidget {
  const _ProfileSlotCard({
    required this.slot,
    required this.selected,
    required this.onEdit,
    required this.onSkip,
    required this.onHide,
    required this.onRestore,
    required this.onDelete,
  });

  final ProfileSlot slot;
  final bool selected;
  final VoidCallback onEdit;
  final VoidCallback onSkip;
  final VoidCallback onHide;
  final VoidCallback onRestore;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final filled = slot.value != null;
    final skipped = slot.skipped && !filled;
    final accent = filled && slot.custom;
    final mutedBody = !filled;
    final badgeLabel = slot.custom
        ? '직접 카드'
        : filled
        ? '기본 카드'
        : skipped
        ? '넘겨둠'
        : '비어 있음';
    final badgeBackground = slot.custom
        ? const Color(0xFFF0EDF4)
        : filled
        ? const Color(0xFFF8F8F4)
        : skipped
        ? const Color(0xFFECEAE2)
        : const Color(0xFFF4ECD9);
    final badgeColor = slot.custom
        ? const Color(0xFF7D688F)
        : skipped
        ? const Color(0xFF8A8175)
        : filled
        ? AlagagiColors.muted
        : const Color(0xFF8B6E31);
    void openFull() => _showReadableDetailSheet(
      context,
      label: '소개 카드',
      title: slot.label,
      body: slot.value!,
      actionLabel: '수정하기',
      onAction: onEdit,
    );
    return InkWell(
      key: profileSlotCardKey(slot.id),
      borderRadius: BorderRadius.circular(21),
      onTap: filled
          ? openFull
          : skipped
          ? onRestore
          : onEdit,
      child: Container(
        constraints: BoxConstraints(minHeight: filled ? 0 : 126),
        decoration: BoxDecoration(
          color: accent
              ? const Color(0xFFFBFDF8)
              : skipped
              ? const Color(0xFFF8F8F4)
              : AlagagiColors.paper,
          border: Border.all(
            color: selected
                ? AlagagiColors.sageDeep
                : accent
                ? const Color(0x3D6F7F63)
                : AlagagiColors.line,
          ),
          borderRadius: BorderRadius.circular(21),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProfileSlotIcon(slotId: slot.id),
                const SizedBox(width: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      slot.custom ? '직접 만든 카드' : slot.category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: sans(
                        size: 11.5,
                        color: AlagagiColors.muted,
                        weight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                if (filled) ...[
                  _OpenReadableIconButton(
                    key: profileSlotReadButtonKey(slot.id),
                    onPressed: openFull,
                  ),
                  const SizedBox(width: 2),
                ],
                Container(
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: badgeBackground,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    badgeLabel,
                    style: sans(
                      size: 10.5,
                      color: badgeColor,
                      weight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              slot.label,
              style: sans(
                size: filled ? 14 : 13,
                color: const Color(0xFF45443F),
                weight: FontWeight.w800,
                height: 1.42,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              filled
                  ? slot.value!
                  : skipped
                  ? '지금은 넘겨둔 질문이에요'
                  : slot.inputHint,
              maxLines: filled ? 4 : 3,
              overflow: TextOverflow.ellipsis,
              style:
                  sans(
                    size: filled ? 12.7 : 11.8,
                    color: mutedBody
                        ? AlagagiColors.muted
                        : const Color(0xFF45443F),
                    height: filled ? 1.62 : 1.48,
                    weight: filled ? FontWeight.w500 : null,
                  ).copyWith(
                    fontStyle: mutedBody ? FontStyle.italic : FontStyle.normal,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _InlineTextAction(
                  key: skipped
                      ? profileSlotRestoreButtonKey(slot.id)
                      : profileSlotEditButtonKey(slot.id),
                  label: skipped
                      ? '다시 보기'
                      : filled
                      ? '수정'
                      : '작성',
                  onPressed: skipped ? onRestore : onEdit,
                ),
                if (slot.custom)
                  _InlineTextAction(
                    key: profileSlotDeleteButtonKey(slot.id),
                    label: '삭제',
                    onPressed: onDelete,
                  )
                else
                  _InlineTextAction(
                    key: profileSlotHideButtonKey(slot.id),
                    label: '숨기기',
                    onPressed: onHide,
                  ),
                if (!filled && !skipped)
                  _InlineTextAction(
                    key: profileSlotSkipButtonKey(slot.id),
                    label: '나중에',
                    onPressed: onSkip,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfilePartnerReadList extends StatelessWidget {
  const _ProfilePartnerReadList({required this.slots});

  final List<ProfileSlot> slots;

  @override
  Widget build(BuildContext context) {
    final filledSlots = slots.where((slot) => slot.value != null).toList()
      ..sort((a, b) {
        if (a.custom != b.custom) {
          return a.custom ? -1 : 1;
        }
        final aUpdatedAt = a.updatedAt;
        final bUpdatedAt = b.updatedAt;
        if (aUpdatedAt != null && bUpdatedAt != null) {
          return bUpdatedAt.compareTo(aUpdatedAt);
        }
        return 0;
      });
    if (filledSlots.isEmpty) {
      return const _InlineEmptyState(text: '아직 채워진 카드가 없어요. 천천히 기다려도 괜찮아요.');
    }
    return Column(
      children: [
        for (final slot in filledSlots) ...[
          _ProfileReadCard(slot: slot, featured: slot.custom),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _ProfileReadCard extends StatelessWidget {
  const _ProfileReadCard({required this.slot, required this.featured});

  final ProfileSlot slot;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    void openFull() => _showReadableDetailSheet(
      context,
      label: '소개 카드',
      title: slot.label,
      body: slot.value!,
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: openFull,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: featured ? const Color(0xFFFDFBFE) : AlagagiColors.paper,
          border: Border.all(
            color: featured ? const Color(0x3DB9A8C9) : AlagagiColors.line,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _ProfileSlotIcon(slotId: slot.id),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    slot.label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: sans(
                      size: 13.5,
                      color: const Color(0xFF45443F),
                      weight: FontWeight.w800,
                      height: 1.3,
                    ),
                  ),
                ),
                Container(
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: featured
                        ? const Color(0xFFF0EDF4)
                        : const Color(0xFFF8F8F4),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    featured ? '직접 카드' : slot.category,
                    style: sans(
                      size: 10.5,
                      color: featured
                          ? const Color(0xFF7D688F)
                          : AlagagiColors.muted,
                      weight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                _OpenReadableIconButton(
                  key: profileSlotReadButtonKey(slot.id),
                  onPressed: openFull,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              slot.value!,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: sans(
                size: 13.5,
                color: const Color(0xFF45443F),
                height: 1.7,
                weight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InlineEmptyState extends StatelessWidget {
  const _InlineEmptyState({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(16),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: sans(size: 12.5, color: AlagagiColors.muted, height: 1.5),
      ),
    );
  }
}

class _ProfileSlotIcon extends StatelessWidget {
  const _ProfileSlotIcon({required this.slotId});

  final String slotId;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: AlagagiColors.softSage,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Icon(
        _iconForSlot(slotId),
        size: 15,
        color: AlagagiColors.sageDeep,
      ),
    );
  }

  IconData _iconForSlot(String id) {
    return switch (id) {
      'food' || 'shared_food' => Icons.restaurant_outlined,
      'song' => Icons.music_note_outlined,
      'rest' || 'weekend' => Icons.weekend_outlined,
      'cafe' => Icons.local_cafe_outlined,
      'walk' || 'neighborhood' || 'photo_walk' => Icons.directions_walk_rounded,
      'comfort' || 'recharge' => Icons.eco_outlined,
      'promise' => Icons.event_available_outlined,
      'kindness' => Icons.volunteer_activism_outlined,
      'pace' || 'morning_night' || 'focus_time' => Icons.schedule_rounded,
      'wish_scene' || 'rainy_day' => Icons.near_me_outlined,
      'talk_style' || 'question_style' => Icons.chat_bubble_outline_rounded,
      'careful_words' => Icons.edit_note_rounded,
      'small_taste' || 'object' || 'small_hobby' => Icons.lightbulb_outline,
      _ => Icons.notes_outlined,
    };
  }
}

class _TodaySlotCard extends StatefulWidget {
  const _TodaySlotCard({required this.controller});

  final AlagagiController controller;

  @override
  State<_TodaySlotCard> createState() => _TodaySlotCardState();
}

class _TodaySlotCardState extends State<_TodaySlotCard> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slot = widget.controller.todayFillableProfileSlot;
    if (slot == null) {
      return const _EmptyStateCard(text: '소개 카드가 모두 채워졌어요.');
    }

    return _PaperCard(
      radius: 20,
      padding: const EdgeInsets.all(20),
      highlightedBorder: AlagagiColors.softSage,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFEEF1E8),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Text(
              '비어 있는 칸',
              style: sans(
                size: 11,
                color: AlagagiColors.sageDeep,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '나의 ‘${slot.label}’을 적어볼까요?',
            style: serif(context, size: 17, weight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            '부담 없는 한 줄이면 충분해요.',
            style: sans(size: 12.5, color: AlagagiColors.muted),
          ),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AlagagiColors.line),
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.fromLTRB(14, 4, 6, 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '한 줄로 적어볼까요…',
                    ),
                    style: sans(size: 13),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      widget.controller.fillTodayProfileSlot(_controller.text),
                  style: TextButton.styleFrom(
                    backgroundColor: AlagagiColors.sageDeep,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('채우기'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key, required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final wishes = controller.visibleWishes;
    final mutualWishes = wishes
        .where((wish) => wish.isMutual && !wish.done)
        .toList();
    final quietWishes = wishes
        .where((wish) => !wish.isMutual && !wish.done)
        .toList();
    final doneWishes = wishes.where((wish) => wish.done).toList();

    return _ScreenScroll(
      bottomNavigation: _BottomNav(controller: controller),
      children: [
        _TopBar(
          title: '언젠가, 같이',
          trailing: '',
          onBack: () => controller.goTo(AlagagiRoute.home),
        ),
        const SizedBox(height: 4),
        Text(
          '언젠가 해볼 만한 것을 가볍게 적어둬요',
          style: sans(size: 12.5, color: AlagagiColors.muted),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: _WishlistAddButton(controller: controller),
        ),
        if (controller.state.wishDraftVisible) ...[
          const SizedBox(height: 14),
          _WishDraftCard(controller: controller),
        ],
        const SizedBox(height: 16),
        _WishlistHero(
          mutualCount: mutualWishes.length,
          totalCount: wishes.length,
          doneCount: doneWishes.length,
        ),
        const SizedBox(height: 14),
        _WishlistFilters(controller: controller),
        const SizedBox(height: 18),
        _WishlistBoard(
          wishes: wishes,
          mutualWishes: mutualWishes,
          quietWishes: quietWishes,
          doneWishes: doneWishes,
          controller: controller,
        ),
      ],
    );
  }
}

class _WishlistHero extends StatelessWidget {
  const _WishlistHero({
    required this.mutualCount,
    required this.totalCount,
    required this.doneCount,
  });

  final int mutualCount;
  final int totalCount;
  final int doneCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AlagagiColors.paper, Color(0xFFF3F5EE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'QUIET BOARD',
            style: sans(
              size: 10.5,
              color: AlagagiColors.sageDeep,
              weight: FontWeight.w700,
              letterSpacing: 2.2,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            '같이 해볼 일을\n가볍게 모아둬요',
            style: serif(
              context,
              size: 22,
              weight: FontWeight.w800,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            '바로 약속을 정하지 않아도 괜찮아요. 서로 관심이 겹치면 다음에 꺼내기 쉬워집니다.',
            style: sans(size: 12.5, color: AlagagiColors.muted, height: 1.65),
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              Expanded(
                child: _WishlistSummaryTile(
                  value: '$mutualCount',
                  label: '서로 관심',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _WishlistSummaryTile(
                  value: '$totalCount',
                  label: '담아둔 것',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _WishlistSummaryTile(value: '$doneCount', label: '함께함'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WishlistSummaryTile extends StatelessWidget {
  const _WishlistSummaryTile({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xBFFFFFFA),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: sans(
              size: 15,
              color: AlagagiColors.ink,
              weight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: sans(size: 10.5, color: AlagagiColors.muted, height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _WishlistAddButton extends StatelessWidget {
  const _WishlistAddButton({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: OutlinedButton.icon(
        key: wishAddButtonKey,
        onPressed: controller.startWishDraft,
        icon: const Icon(Icons.add_rounded, size: 16),
        label: const Text('하고 싶은 것 담기'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AlagagiColors.sageDeep,
          side: const BorderSide(color: Color(0x338A9A7E)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          textStyle: sans(size: 12, weight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _WishlistBoard extends StatelessWidget {
  const _WishlistBoard({
    required this.wishes,
    required this.mutualWishes,
    required this.quietWishes,
    required this.doneWishes,
    required this.controller,
  });

  final List<WishItem> wishes;
  final List<WishItem> mutualWishes;
  final List<WishItem> quietWishes;
  final List<WishItem> doneWishes;
  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    if (wishes.isEmpty) {
      return const _EmptyStateCard(text: '같이 해보고 싶은 걸 하나만 담아볼까요?');
    }
    return Column(
      key: wishlistBoardKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _WishlistLane(
          title: '서로 관심 있어요',
          meta: '다음에 꺼내기 좋은 것',
          wishes: mutualWishes,
          emptyText: '서로 관심이 겹친 항목은 여기에 모여요.',
          controller: controller,
        ),
        const SizedBox(height: 18),
        _WishlistLane(
          title: '조용한 제안',
          meta: '관심 표시 전',
          wishes: quietWishes,
          emptyText: '아직 한 명만 담아둔 제안이 없어요.',
          controller: controller,
        ),
        const SizedBox(height: 18),
        _WishlistLane(
          title: '함께했어요',
          meta: '가볍게 남은 기록',
          wishes: doneWishes,
          emptyText: '함께한 뒤에는 여기에 조용히 쌓여요.',
          controller: controller,
        ),
      ],
    );
  }
}

class _WishlistLane extends StatelessWidget {
  const _WishlistLane({
    required this.title,
    required this.meta,
    required this.wishes,
    required this.emptyText,
    required this.controller,
  });

  final String title;
  final String meta;
  final List<WishItem> wishes;
  final String emptyText;
  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: serif(context, size: 16, weight: FontWeight.w800),
              ),
            ),
            Text(meta, style: sans(size: 11.5, color: AlagagiColors.muted)),
          ],
        ),
        const SizedBox(height: 10),
        if (wishes.isEmpty)
          _InlineEmptyState(text: emptyText)
        else
          for (final wish in wishes) ...[
            _WishCard(
              wish: wish,
              meId: controller.state.me.id,
              partnerId: controller.state.partner.id,
              partnerName: controller.state.partner.nickname,
              onInterest: () => controller.toggleWishLike(wish.id),
            ),
            const SizedBox(height: 10),
          ],
      ],
    );
  }
}

class _WishDraftCard extends StatelessWidget {
  const _WishDraftCard({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return _PaperCard(
      radius: 18,
      padding: const EdgeInsets.all(16),
      highlightedBorder: AlagagiColors.sage,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '새 위시 담기',
            style: serif(context, size: 17, weight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            '언젠가 같이 해보고 싶은 걸 한 줄로 적어봐요.',
            style: sans(size: 12.5, color: AlagagiColors.muted),
          ),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AlagagiColors.line),
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: TextField(
              key: wishTitleFieldKey,
              maxLength: 60,
              onChanged: controller.updateWishDraftTitle,
              decoration: const InputDecoration(
                border: InputBorder.none,
                counterText: '',
                hintText: '예: 한강에서 같이 산책하기',
              ),
              style: sans(size: 13.5),
            ),
          ),
          if (controller.state.wishDraftError != null) ...[
            const SizedBox(height: 8),
            Text(
              controller.state.wishDraftError!,
              style: sans(size: 12, color: AlagagiColors.sageDeep),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _FilterPill(
                label: '가고 싶은 곳',
                selected: controller.state.wishDraftKind == WishKind.place,
                onTap: () => controller.setWishDraftKind(WishKind.place),
              ),
              _FilterPill(
                label: '해보고 싶은 것',
                selected: controller.state.wishDraftKind == WishKind.activity,
                onTap: () => controller.setWishDraftKind(WishKind.activity),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton(
                onPressed: controller.cancelWishDraft,
                child: Text(
                  '취소',
                  style: sans(size: 13, color: AlagagiColors.muted),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PrimaryButton(
                  label: '담기',
                  onPressed: controller.submitWishDraft,
                  color: AlagagiColors.sageDeep,
                  buttonKey: wishSubmitButtonKey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WishlistFilters extends StatelessWidget {
  const _WishlistFilters({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _FilterPill(
          label: '전체',
          selected: controller.state.wishlistFilter == WishlistFilter.all,
          onTap: () => controller.setWishlistFilter(WishlistFilter.all),
        ),
        _FilterPill(
          label: '서로 관심',
          selected: controller.state.wishlistFilter == WishlistFilter.mutual,
          onTap: () => controller.setWishlistFilter(WishlistFilter.mutual),
        ),
        _FilterPill(
          label: '가고 싶은 곳',
          selected: controller.state.wishlistFilter == WishlistFilter.places,
          onTap: () => controller.setWishlistFilter(WishlistFilter.places),
        ),
        _FilterPill(
          label: '해보고 싶은 것',
          selected:
              controller.state.wishlistFilter == WishlistFilter.activities,
          onTap: () => controller.setWishlistFilter(WishlistFilter.activities),
        ),
      ],
    );
  }
}

class _WishCard extends StatelessWidget {
  const _WishCard({
    required this.wish,
    required this.meId,
    required this.partnerId,
    required this.partnerName,
    required this.onInterest,
  });

  final WishItem wish;
  final String meId;
  final String partnerId;
  final String partnerName;
  final VoidCallback onInterest;

  @override
  Widget build(BuildContext context) {
    final likedByMe = wish.likedByProfileIds.contains(meId);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onInterest,
        child: Container(
          decoration: BoxDecoration(
            color: wish.isMutual ? null : AlagagiColors.paper,
            gradient: wish.isMutual
                ? const LinearGradient(
                    colors: [Color(0xFFEEF1E8), Color(0xFFE6ECDC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            border: Border.all(
              color: wish.isMutual ? AlagagiColors.sage : AlagagiColors.line,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2EB),
                  borderRadius: BorderRadius.circular(13),
                ),
                alignment: Alignment.center,
                child: _WishKindIcon(kind: wish.kind, done: wish.done),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wish.title,
                      style:
                          sans(
                            size: 14.5,
                            weight: FontWeight.w500,
                            color: wish.done
                                ? AlagagiColors.muted
                                : const Color(0xFF33332F),
                          ).copyWith(
                            decoration: wish.done
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      wish.isMutual
                          ? '둘 다 표시함'
                          : wish.createdByProfileId == partnerId
                          ? '$partnerName님이 담음'
                          : '내가 담음',
                      style: sans(size: 11, color: AlagagiColors.muted),
                    ),
                  ],
                ),
              ),
              _InterestBadge(
                label: wish.done
                    ? '완료'
                    : likedByMe
                    ? '관심 표시됨'
                    : '관심 표시',
                selected: likedByMe || wish.done,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WishKindIcon extends StatelessWidget {
  const _WishKindIcon({required this.kind, required this.done});

  final WishKind kind;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Icon(
      kind == WishKind.place
          ? Icons.place_outlined
          : Icons.lightbulb_outline_rounded,
      size: 22,
      color: done ? AlagagiColors.muted : AlagagiColors.sageDeep,
    );
  }
}

class _InterestBadge extends StatelessWidget {
  const _InterestBadge({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 42),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: selected ? AlagagiColors.sageDeep : Colors.white,
        border: Border.all(
          color: selected ? AlagagiColors.sageDeep : AlagagiColors.line,
        ),
        borderRadius: BorderRadius.circular(999),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: sans(
          size: 11,
          weight: FontWeight.w700,
          color: selected ? Colors.white : AlagagiColors.sageDeep,
        ),
      ),
    );
  }
}

class MeetingScreen extends StatelessWidget {
  const MeetingScreen({super.key, required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final candidates = controller.meetingCandidates;
    final meetingDayEntry = controller.nextMeetingDayEntry;
    return _ScreenScroll(
      bottomNavigation: _BottomNav(controller: controller),
      children: [
        _TopBar(title: '만날 수 있는 날', trailing: ''),
        const SizedBox(height: 4),
        Text(
          '각자의 일정 내용은 지키면서 겹치는 여유만 맞춰요',
          style: sans(size: 12.5, color: AlagagiColors.muted),
        ),
        const SizedBox(height: 16),
        _MeetingHeroCard(
          candidateCount: candidates.length,
          meetingDayEntry: meetingDayEntry,
        ),
        const SizedBox(height: 14),
        _MeetingCalendar(controller: controller),
        const SizedBox(height: 14),
        _MeetingDetailCard(
          key: ValueKey('meeting-detail-${controller.selectedMeetingDateKey}'),
          controller: controller,
        ),
        const SizedBox(height: 18),
        const _SectionLabel('서로 괜찮은 후보'),
        const SizedBox(height: 10),
        if (candidates.isEmpty)
          const _EmptyStateCard(text: '둘 다 가능하다고 남긴 날이 생기면 여기에 모여요.')
        else
          for (final candidate in candidates.take(3)) ...[
            _MeetingCandidateCard(candidate: candidate),
            const SizedBox(height: 10),
          ],
      ],
    );
  }
}

class MeetingPlanScreen extends StatelessWidget {
  const MeetingPlanScreen({super.key, required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final entries = controller.meetingDayEntries;
    final selectedEntry = controller.selectedMeetingPlanEntry;
    return _ScreenScroll(
      bottomNavigation: _BottomNav(controller: controller),
      children: [
        _TopBar(title: '만남', trailing: ''),
        const SizedBox(height: 4),
        Text(
          '정해진 날만 모아서 뭐하고 어디 갈지 정리해요',
          style: sans(size: 12.5, color: AlagagiColors.muted),
        ),
        const SizedBox(height: 16),
        if (entries.isEmpty)
          _MeetingPlanEmptyState(controller: controller)
        else ...[
          _MeetingPlanHeroCard(entry: selectedEntry ?? entries.first),
          const SizedBox(height: 14),
          _MeetingPlanDateStrip(controller: controller, entries: entries),
          const SizedBox(height: 14),
          if (selectedEntry != null)
            _MeetingPlanDetailCard(
              key: ValueKey('meeting-plan-detail-${selectedEntry.dateKey}'),
              controller: controller,
              entry: selectedEntry,
            ),
        ],
      ],
    );
  }
}

class _MeetingPlanEmptyState extends StatelessWidget {
  const _MeetingPlanEmptyState({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return _PaperCard(
      key: meetingPlanScreenKey,
      radius: 24,
      padding: const EdgeInsets.all(20),
      dashed: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(
            Icons.favorite_border_rounded,
            size: 28,
            color: AlagagiColors.sageDeep,
          ),
          const SizedBox(height: 12),
          Text(
            '아직 정해진 만나는 날이 없어요',
            textAlign: TextAlign.center,
            style: serif(context, size: 20, weight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            '약속 탭에서 서로 가능한 날짜를 만나는 날로 정하면 여기에 계획 공간이 열려요.',
            textAlign: TextAlign.center,
            style: sans(size: 12.5, color: AlagagiColors.muted, height: 1.55),
          ),
          const SizedBox(height: 16),
          _PrimaryButton(
            label: '약속에서 날짜 정하기',
            onPressed: () => controller.goTo(AlagagiRoute.meetings),
            color: AlagagiColors.sageDeep,
          ),
        ],
      ),
    );
  }
}

class _MeetingPlanHeroCard extends StatelessWidget {
  const _MeetingPlanHeroCard({required this.entry});

  final ScheduleEntry entry;

  @override
  Widget build(BuildContext context) {
    final timeLabel = entry.meetingTimeLabel.trim();
    final note = entry.meetingNote.trim();
    final planCount = entry.meetingPlanItems.length;
    return _PaperCard(
      key: meetingPlanScreenKey,
      radius: 24,
      padding: const EdgeInsets.all(20),
      highlightedBorder: const Color(0x22E1C77A),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AlagagiColors.ink,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.favorite_rounded,
                  color: Color(0xFFE1C77A),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _meetingDateLabel(entry.dateKey),
                      style: serif(context, size: 20, weight: FontWeight.w800),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      timeLabel.isEmpty ? '시간은 편하게 다시 정해도 괜찮아요.' : timeLabel,
                      style: sans(size: 12, color: AlagagiColors.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (note.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              note,
              style: sans(
                size: 12.5,
                height: 1.5,
                color: const Color(0xFF5F5D57),
              ),
            ),
          ],
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _SmallBadge(
                label: planCount == 0 ? '계획 비어 있음' : '계획 $planCount개',
              ),
              const _SmallBadge(label: '확정 날짜'),
            ],
          ),
        ],
      ),
    );
  }
}

class _MeetingPlanDateStrip extends StatelessWidget {
  const _MeetingPlanDateStrip({
    required this.controller,
    required this.entries,
  });

  final AlagagiController controller;
  final List<ScheduleEntry> entries;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 82,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: entries.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final entry = entries[index];
          final selected =
              entry.dateKey == controller.selectedMeetingPlanDateKey;
          return _MeetingPlanDateCard(
            entry: entry,
            selected: selected,
            onTap: () => controller.selectMeetingPlanDate(entry.dateKey),
          );
        },
      ),
    );
  }
}

class _MeetingPlanDateCard extends StatelessWidget {
  const _MeetingPlanDateCard({
    required this.entry,
    required this.selected,
    required this.onTap,
  });

  final ScheduleEntry entry;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(entry.dateKey);
    final day = date?.day.toString() ?? entry.dateKey;
    final month = date == null ? '' : '${date.month}월';
    return SizedBox(
      width: 78,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: meetingPlanDateButtonKey(entry.dateKey),
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: selected ? AlagagiColors.ink : AlagagiColors.paper,
              border: Border.all(
                color: selected ? AlagagiColors.ink : AlagagiColors.line,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  month,
                  style: sans(
                    size: 10.5,
                    color: selected ? Colors.white70 : AlagagiColors.muted,
                  ),
                ),
                const Spacer(),
                Text(
                  day,
                  style: sans(
                    size: 21,
                    weight: FontWeight.w800,
                    color: selected ? Colors.white : AlagagiColors.ink,
                  ),
                ),
                Text(
                  entry.meetingPlanItems.isEmpty
                      ? '비어 있음'
                      : '${entry.meetingPlanItems.length}개',
                  style: sans(
                    size: 10.5,
                    color: selected
                        ? const Color(0xFFE1C77A)
                        : AlagagiColors.sageDeep,
                    weight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MeetingPlanDetailCard extends StatefulWidget {
  const _MeetingPlanDetailCard({
    super.key,
    required this.controller,
    required this.entry,
  });

  final AlagagiController controller;
  final ScheduleEntry entry;

  @override
  State<_MeetingPlanDetailCard> createState() => _MeetingPlanDetailCardState();
}

class _MeetingPlanDetailCardState extends State<_MeetingPlanDetailCard> {
  bool _showAllBoardPlaces = false;

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final entry = widget.entry;
    final linkedPlaces = controller.placesForMeetingPlan(entry.dateKey);
    final boardPlaces = controller.sharedPlaces
        .where((place) => place.linkedDateKey != entry.dateKey)
        .toList();
    final hiddenBoardPlaceCount = boardPlaces.length > 4
        ? boardPlaces.length - 4
        : 0;
    final visibleBoardPlaces = _showAllBoardPlaces
        ? boardPlaces
        : boardPlaces.take(4).toList();
    final pairPlanTitle = _meetingPlanPairTitle(controller);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PaperCard(
          radius: 24,
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF5D2),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0x33D9B34F)),
                    ),
                    alignment: Alignment.center,
                    child: const Text('📝', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pairPlanTitle,
                          style: serif(
                            context,
                            size: 20,
                            weight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '같이 하고 싶은 것들을 편하게 모아요.',
                          style: sans(
                            size: 11.5,
                            color: AlagagiColors.muted,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _SmallBadge(label: _meetingDateShortLabel(entry.dateKey)),
                ],
              ),
              const SizedBox(height: 12),
              _MeetingPlanTaskList(controller: controller),
              const SizedBox(height: 12),
              _MeetingPlanTaskComposer(controller: controller),
              if (controller.state.meetingDraftError != null &&
                  controller.state.meetingSaveStatus != SaveStatus.failed) ...[
                const SizedBox(height: 9),
                Text(
                  controller.state.meetingDraftError!,
                  style: sans(size: 12, color: AlagagiColors.sageDeep),
                ),
              ],
              const SizedBox(height: 12),
              _PrimaryButton(
                label: '만남 계획 저장',
                buttonKey: meetingPlanSaveButtonKey,
                onPressed: controller.submitMeetingPlanDraft,
                color: AlagagiColors.ink,
              ),
              _MeetingSaveStatus(controller: controller),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            const Expanded(child: _SectionLabel('이 날 장소 후보')),
            _SmallBadge(label: '${linkedPlaces.length}곳'),
          ],
        ),
        _PlaceSaveStatus(controller: controller),
        const SizedBox(height: 10),
        if (linkedPlaces.isEmpty)
          const _EmptyStateCard(text: '장소 탭에서 저장한 곳을 이 날 후보로 붙여볼 수 있어요.')
        else
          for (final place in linkedPlaces) ...[
            _MeetingPlanPlaceRow(
              controller: controller,
              place: place,
              selectedDateKey: entry.dateKey,
              linked: true,
            ),
            const SizedBox(height: 10),
          ],
        if (boardPlaces.isNotEmpty) ...[
          const SizedBox(height: 12),
          const _SectionLabel('장소 보드에서 가져오기'),
          const SizedBox(height: 10),
          for (final place in visibleBoardPlaces) ...[
            _MeetingPlanPlaceRow(
              controller: controller,
              place: place,
              selectedDateKey: entry.dateKey,
              linked: false,
            ),
            const SizedBox(height: 10),
          ],
          if (boardPlaces.length > 4)
            _MeetingPlanMorePlacesButton(
              expanded: _showAllBoardPlaces,
              hiddenCount: hiddenBoardPlaceCount,
              onPressed: () {
                setState(() => _showAllBoardPlaces = !_showAllBoardPlaces);
              },
            ),
        ],
      ],
    );
  }
}

class _MeetingPlanTaskList extends StatelessWidget {
  const _MeetingPlanTaskList({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final items = controller.meetingPlanDraftItems;
    if (items.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F4),
          border: Border.all(color: AlagagiColors.line),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Row(
          children: [
            Icon(
              Icons.playlist_add_check_rounded,
              size: 20,
              color: AlagagiColors.sageDeep,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '둘이 같이 하고 싶은 걸 하나씩 적어두면 좋아요.',
                style: sans(
                  size: 12.2,
                  color: AlagagiColors.muted,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Column(
      children: [
        for (var index = 0; index < items.length; index++) ...[
          _MeetingPlanTaskRow(
            index: index,
            label: items[index],
            onRemove: () => controller.removeMeetingPlanDraftItem(index),
          ),
          if (index != items.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _MeetingPlanTaskRow extends StatelessWidget {
  const _MeetingPlanTaskRow({
    required this.index,
    required this.label,
    required this.onRemove,
  });

  final int index;
  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F4),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Color(0xFFF0F2EB),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${index + 1}',
              style: sans(
                size: 11,
                weight: FontWeight.w800,
                color: AlagagiColors.sageDeep,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: sans(size: 13, weight: FontWeight.w700, height: 1.35),
            ),
          ),
          SizedBox(
            width: 34,
            height: 34,
            child: IconButton(
              key: meetingPlanItemRemoveButtonKey(index),
              onPressed: onRemove,
              icon: const Icon(Icons.close_rounded, size: 17),
              color: AlagagiColors.muted,
              tooltip: '삭제',
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}

class _MeetingPlanTaskComposer extends StatelessWidget {
  const _MeetingPlanTaskComposer({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _MeetingTextField(
            fieldKey: meetingPlanDraftFieldKey,
            label: '추가할 계획',
            hint: '예: 전시 보기',
            initialValue: controller.state.meetingPlanItemDraft,
            maxLength: 40,
            helperText: '',
            minLines: 1,
            maxLines: 1,
            onChanged: controller.updateMeetingPlanItemDraft,
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 56,
          child: OutlinedButton.icon(
            key: meetingPlanItemAddButtonKey,
            onPressed: controller.addMeetingPlanDraftItem,
            icon: const Icon(Icons.add_rounded, size: 17),
            label: const Text('추가'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AlagagiColors.sageDeep,
              side: const BorderSide(color: Color(0x338A9A7E)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              textStyle: sans(size: 12.5, weight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }
}

String _meetingPlanPairTitle(AlagagiController controller) {
  final me = controller.state.me.nickname.trim();
  final partner = controller.state.partner.nickname.trim();
  if ({me, partner}.containsAll(const ['영우', '민영'])) {
    return '영우·민영의 계획';
  }
  final names = [
    if (me.isNotEmpty) me,
    if (partner.isNotEmpty && partner != me) partner,
  ];
  if (names.length >= 2) {
    return '${names.take(2).join('·')}의 계획';
  }
  if (names.length == 1) {
    return '${names.single}의 계획';
  }
  return '우리의 계획';
}

class _MeetingPlanMorePlacesButton extends StatelessWidget {
  const _MeetingPlanMorePlacesButton({
    required this.expanded,
    required this.hiddenCount,
    required this.onPressed,
  });

  final bool expanded;
  final int hiddenCount;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: OutlinedButton.icon(
        key: meetingPlanPlaceMoreButtonKey,
        onPressed: onPressed,
        icon: Icon(
          expanded ? Icons.keyboard_arrow_up_rounded : Icons.more_horiz_rounded,
          size: 18,
        ),
        label: Text(expanded ? '접기' : '$hiddenCount곳 더 보기'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AlagagiColors.sageDeep,
          side: const BorderSide(color: Color(0x338A9A7E)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          textStyle: sans(size: 12.5, weight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _MeetingPlanPlaceRow extends StatelessWidget {
  const _MeetingPlanPlaceRow({
    required this.controller,
    required this.place,
    required this.selectedDateKey,
    required this.linked,
  });

  final AlagagiController controller;
  final SharedPlace place;
  final String selectedDateKey;
  final bool linked;

  @override
  Widget build(BuildContext context) {
    final busy =
        controller.state.placeSaveStatus == SaveStatus.saving &&
        controller.isPlaceSaveTarget(place.id);
    return _PaperCard(
      radius: 18,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: linked ? const Color(0xFFF4EEDC) : const Color(0xFFF0F2EB),
              borderRadius: BorderRadius.circular(15),
            ),
            alignment: Alignment.center,
            child: Icon(
              _placeCategoryIcon(place.category),
              size: 21,
              color: linked ? const Color(0xFF8A6F2D) : AlagagiColors.sageDeep,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: sans(size: 13.5, weight: FontWeight.w800),
                ),
                const SizedBox(height: 3),
                Text(
                  [
                    _placeCategoryLabel(place.category),
                    if (place.isMutual) '서로 관심',
                    if (place.address.isNotEmpty) place.address,
                  ].join(' · '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: sans(size: 11.2, color: AlagagiColors.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 32,
            child: OutlinedButton(
              key: meetingPlanPlaceLinkButtonKey(place.id),
              onPressed: busy
                  ? null
                  : () {
                      if (controller.selectedMeetingPlanDateKey !=
                          selectedDateKey) {
                        controller.selectMeetingPlanDate(selectedDateKey);
                      }
                      controller.linkPlaceToSelectedMeetingPlan(place.id);
                    },
              style: OutlinedButton.styleFrom(
                foregroundColor: linked
                    ? const Color(0xFF8A6F2D)
                    : AlagagiColors.sageDeep,
                disabledForegroundColor: AlagagiColors.muted,
                side: BorderSide(
                  color: linked
                      ? const Color(0x33C8AD6D)
                      : const Color(0x338A9A7E),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                textStyle: sans(size: 11.5, weight: FontWeight.w800),
              ),
              child: Text(linked ? '빼기' : '담기'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MeetingHeroCard extends StatelessWidget {
  const _MeetingHeroCard({
    required this.candidateCount,
    required this.meetingDayEntry,
  });

  final int candidateCount;
  final ScheduleEntry? meetingDayEntry;

  @override
  Widget build(BuildContext context) {
    final meetingTimeLabel = meetingDayEntry?.meetingTimeLabel.trim() ?? '';
    final heroTitle = meetingDayEntry != null
        ? '${_meetingDateShortLabel(meetingDayEntry!.dateKey)}\n만나는 날이에요'
        : candidateCount == 0
        ? '가능한 날을\n하나씩 남겨볼까요?'
        : '이번 달엔\n$candidateCount일이 서로 괜찮아요';
    final heroSubtitle = meetingDayEntry != null
        ? [
            if (meetingTimeLabel.isEmpty)
              '시간은 편할 때 다시 적어도 괜찮아요.'
            else
              '$meetingTimeLabel에 만나기로 했어요.',
            if (meetingDayEntry!.meetingPlanItems.isNotEmpty)
              '만남 탭에 그날 계획이 정리돼 있어요.',
          ].join(' ')
        : '상대에게 보여도 괜찮은 일정과 만날 수 있는 여유만 남겨요.';
    return _PaperCard(
      radius: 24,
      padding: const EdgeInsets.all(20),
      highlightedBorder: const Color(0x228A9A7E),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NEXT MEETING',
            style: sans(
              size: 10.5,
              weight: FontWeight.w800,
              color: AlagagiColors.sageDeep,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            heroTitle,
            style: serif(
              context,
              size: 22,
              weight: FontWeight.w800,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            heroSubtitle,
            style: sans(size: 12.5, color: AlagagiColors.muted, height: 1.6),
          ),
        ],
      ),
    );
  }
}

class _MeetingCalendar extends StatelessWidget {
  const _MeetingCalendar({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final selectedDate =
        DateTime.tryParse(controller.selectedMeetingDateKey) ?? DateTime.now();
    final firstDay = DateTime(selectedDate.year, selectedDate.month);
    final daysInMonth = DateTime(
      selectedDate.year,
      selectedDate.month + 1,
      0,
    ).day;
    final leading = firstDay.weekday % 7;
    final cells = <DateTime?>[
      for (var i = 0; i < leading; i++) null,
      for (var day = 1; day <= daysInMonth; day++)
        DateTime(selectedDate.year, selectedDate.month, day),
    ];

    return _PaperCard(
      radius: 22,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${selectedDate.year}년 ${selectedDate.month}월',
                  style: serif(context, size: 18, weight: FontWeight.w800),
                ),
              ),
              Text(
                '상세 일정 표시',
                style: sans(size: 11.5, color: AlagagiColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              for (final label in const ['일', '월', '화', '수', '목', '금', '토'])
                Expanded(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: sans(
                      size: 10.5,
                      color: AlagagiColors.muted,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 7),
          GridView.builder(
            key: meetingCalendarKey,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cells.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              childAspectRatio: 0.92,
            ),
            itemBuilder: (context, index) {
              final date = cells[index];
              if (date == null) {
                return const SizedBox.shrink();
              }
              final dateKey = _dateKeyForUi(date);
              final myEntry = controller.scheduleEntryFor(
                controller.state.me.id,
                dateKey,
              );
              final partnerEntry = controller.scheduleEntryFor(
                controller.state.partner.id,
                dateKey,
              );
              final selected = dateKey == controller.selectedMeetingDateKey;
              final mutual =
                  myEntry?.canMeet == true &&
                  partnerEntry?.canMeet == true &&
                  myEntry!.timeSlots
                      .intersection(partnerEntry!.timeSlots)
                      .isNotEmpty;
              final meetingDay = controller.meetingDayEntryFor(dateKey) != null;
              final busy = myEntry?.availability == MeetingAvailability.busy;
              final hasMyEntry = myEntry != null;
              final hasMyDetails = myEntry?.timeBlocks.isNotEmpty ?? false;
              return _MeetingDateCell(
                dateKey: dateKey,
                day: date.day,
                selected: selected,
                meetingDay: meetingDay,
                mutual: mutual,
                busy: busy,
                hasMyEntry: hasMyEntry,
                hasMyDetails: hasMyDetails,
                hasPartner: partnerEntry != null,
                onTap: () => controller.selectMeetingDate(dateKey),
              );
            },
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: const [
              _LegendDot(color: Color(0xFFE1C77A), label: '만나는 날'),
              _LegendDot(color: AlagagiColors.sageDeep, label: '서로 가능'),
              _LegendDot(color: AlagagiColors.sage, label: '내 입력'),
              _LegendDot(color: Color(0xFFC8AD6D), label: '내 상세 일정'),
              _LegendDot(color: Color(0xFFB18472), label: '상대 표시'),
            ],
          ),
        ],
      ),
    );
  }
}

class _MeetingDateCell extends StatelessWidget {
  const _MeetingDateCell({
    required this.dateKey,
    required this.day,
    required this.selected,
    required this.meetingDay,
    required this.mutual,
    required this.busy,
    required this.hasMyEntry,
    required this.hasMyDetails,
    required this.hasPartner,
    required this.onTap,
  });

  final String dateKey;
  final int day;
  final bool selected;
  final bool meetingDay;
  final bool mutual;
  final bool busy;
  final bool hasMyEntry;
  final bool hasMyDetails;
  final bool hasPartner;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const meetingDayFill = Color(0xFFFFF5D2);
    const meetingDayBorder = Color(0xFFD9B34F);
    const meetingDayForeground = Color(0xFF6F5518);
    final background = selected
        ? AlagagiColors.ink
        : meetingDay
        ? meetingDayFill
        : mutual
        ? const Color(0xFFEEF2E8)
        : busy || hasMyDetails
        ? const Color(0xFFF4EEDC)
        : hasMyEntry
        ? const Color(0xFFF5F8EF)
        : Colors.white;
    final foreground = selected
        ? Colors.white
        : meetingDay
        ? meetingDayForeground
        : mutual
        ? AlagagiColors.sageDeep
        : busy || hasMyDetails
        ? const Color(0xFF8A6F2D)
        : hasMyEntry
        ? AlagagiColors.sageDeep
        : const Color(0xFF4D4B45);
    final borderColor = selected
        ? AlagagiColors.ink
        : meetingDay
        ? meetingDayBorder
        : mutual
        ? const Color(0x668A9A7E)
        : hasMyEntry
        ? const Color(0x338A9A7E)
        : AlagagiColors.line;
    final indicators = <Widget>[
      if (mutual)
        _TinyDot(
          key: meetingMutualIndicatorKey(dateKey),
          color: selected ? Colors.white : AlagagiColors.sageDeep,
        ),
      if (hasMyEntry)
        _TinyDot(
          key: meetingMyEntryIndicatorKey(dateKey),
          color: selected ? const Color(0xFFB8C8A5) : AlagagiColors.sage,
        ),
      if (hasMyDetails)
        _TinyDot(
          color: selected ? const Color(0xFFE1C77A) : const Color(0xFFC8AD6D),
        ),
      if (hasPartner)
        _TinyDot(
          key: meetingPartnerEntryIndicatorKey(dateKey),
          color: selected ? const Color(0xFFD3A28F) : const Color(0xFFB18472),
        ),
    ];
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: meetingDateButtonKey(dateKey),
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: background,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Text(
                  '$day',
                  style: sans(
                    size: 12,
                    weight: FontWeight.w800,
                    color: foreground,
                  ),
                ),
              ),
              if (meetingDay)
                Positioned(
                  bottom: 5,
                  left: 0,
                  right: 0,
                  child: Semantics(
                    label: '만나는 날',
                    child: Center(
                      child: Container(
                        key: meetingDayIndicatorKey(dateKey),
                        width: 18,
                        height: 3.5,
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xFFE1C77A)
                              : const Color(0xFFD9B34F),
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x22000000),
                              blurRadius: 3,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              if (!meetingDay)
                Positioned(
                  bottom: 4,
                  left: 4,
                  right: 4,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (
                          var index = 0;
                          index < indicators.length;
                          index++
                        ) ...[
                          if (index > 0) const SizedBox(width: 3),
                          indicators[index],
                        ],
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MeetingTimePreset {
  const _MeetingTimePreset({
    required this.id,
    required this.label,
    required this.start,
    required this.end,
    required this.title,
  });

  final String id;
  final String label;
  final String start;
  final String end;
  final String title;
}

const _meetingTimePresets = [
  _MeetingTimePreset(
    id: 'morning',
    label: '오전 일정',
    start: '10:00',
    end: '12:00',
    title: '오전 일정',
  ),
  _MeetingTimePreset(
    id: 'lunch',
    label: '점심 약속',
    start: '12:00',
    end: '13:30',
    title: '점심 약속',
  ),
  _MeetingTimePreset(
    id: 'afternoon',
    label: '오후 일정',
    start: '14:00',
    end: '17:00',
    title: '오후 일정',
  ),
  _MeetingTimePreset(
    id: 'evening',
    label: '저녁 약속',
    start: '19:00',
    end: '21:00',
    title: '저녁 약속',
  ),
];

class _MeetingDetailCard extends StatelessWidget {
  const _MeetingDetailCard({super.key, required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final myEntry = controller.mySelectedScheduleEntry;
    final partnerEntry = controller.partnerSelectedScheduleEntry;
    final meetingDayEntry = controller.meetingDayEntryFor(
      controller.selectedMeetingDateKey,
    );
    final sharedSlots =
        myEntry?.timeSlots.intersection(
          partnerEntry?.timeSlots ?? const <MeetingTimeSlot>{},
        ) ??
        const <MeetingTimeSlot>{};
    final mutual =
        myEntry?.canMeet == true &&
        partnerEntry?.canMeet == true &&
        sharedSlots.isNotEmpty;
    final showMeetingDayPanel = mutual || meetingDayEntry != null;
    return _PaperCard(
      radius: 24,
      padding: const EdgeInsets.all(18),
      highlightedBorder: AlagagiColors.sage,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _meetingDateLabel(controller.selectedMeetingDateKey),
                  style: serif(context, size: 21, weight: FontWeight.w800),
                ),
              ),
              _SmallBadge(
                label: _meetingAvailabilityLabel(myEntry?.availability),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _MeetingPersonRow(
            name: controller.state.me.nickname,
            avatar: controller.state.me.avatar,
            entry: myEntry,
            isMe: true,
          ),
          const SizedBox(height: 8),
          _MeetingPersonRow(
            name: controller.state.partner.nickname,
            avatar: controller.state.partner.avatar,
            entry: partnerEntry,
            isMe: false,
          ),
          if (showMeetingDayPanel) ...[
            const SizedBox(height: 14),
            _MeetingDayPanel(
              controller: controller,
              alreadyMeetingDay: meetingDayEntry != null,
              sharedSlots: sharedSlots,
            ),
          ],
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _FilterPill(
                label: '가능해요',
                selected:
                    controller.state.meetingDraftAvailability ==
                    MeetingAvailability.available,
                onTap: () => controller.setMeetingAvailability(
                  MeetingAvailability.available,
                ),
              ),
              _FilterPill(
                label: '조율 필요',
                selected:
                    controller.state.meetingDraftAvailability ==
                    MeetingAvailability.maybe,
                onTap: () => controller.setMeetingAvailability(
                  MeetingAvailability.maybe,
                ),
              ),
              _FilterPill(
                label: '어려워요',
                selected:
                    controller.state.meetingDraftAvailability ==
                    MeetingAvailability.busy,
                onTap: () =>
                    controller.setMeetingAvailability(MeetingAvailability.busy),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('대략 가능한 시간', style: sans(size: 11.5, weight: FontWeight.w800)),
          const SizedBox(height: 7),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final slot in MeetingTimeSlot.values)
                _FilterPill(
                  key: meetingTimeSlotButtonKey(slot.name),
                  label: _meetingTimeSlotLabel(slot),
                  selected: controller.state.meetingDraftTimeSlots.contains(
                    slot,
                  ),
                  onTap: () => controller.toggleMeetingTimeSlot(slot),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text('상대에게 보이는 일정', style: sans(size: 11.5, weight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(
            '24시간 표기로 적거나, 자주 쓰는 시간대를 먼저 골라요.',
            style: sans(size: 11.2, color: AlagagiColors.muted),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final preset in _meetingTimePresets)
                _FilterPill(
                  key: meetingTimeBlockPresetButtonKey(preset.id),
                  label: preset.label,
                  selected: false,
                  onTap: () => controller.updateMeetingTimeBlockDraft(
                    start: preset.start,
                    end: preset.end,
                    title: preset.title,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _MeetingTextField(
                  fieldKey: meetingTimeBlockStartFieldKey,
                  label: '시작',
                  hint: '14:00',
                  initialValue: controller.state.meetingBlockStartDraft,
                  maxLength: 5,
                  helperText: '예: 09:30',
                  minLines: 1,
                  maxLines: 1,
                  keyboardType: TextInputType.datetime,
                  onChanged: (value) =>
                      controller.updateMeetingTimeBlockDraft(start: value),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MeetingTextField(
                  fieldKey: meetingTimeBlockEndFieldKey,
                  label: '종료',
                  hint: '16:00',
                  initialValue: controller.state.meetingBlockEndDraft,
                  maxLength: 5,
                  helperText: '예: 18:00',
                  minLines: 1,
                  maxLines: 1,
                  keyboardType: TextInputType.datetime,
                  onChanged: (value) =>
                      controller.updateMeetingTimeBlockDraft(end: value),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _MeetingTextField(
            fieldKey: meetingTimeBlockTitleFieldKey,
            label: '일정 내용',
            hint: '예: 병원 예약, 친구 약속',
            initialValue: controller.state.meetingBlockTitleDraft,
            maxLength: 40,
            helperText: '',
            minLines: 1,
            maxLines: 1,
            onChanged: (value) =>
                controller.updateMeetingTimeBlockDraft(title: value),
          ),
          const SizedBox(height: 9),
          SizedBox(
            height: 38,
            child: OutlinedButton.icon(
              key: meetingTimeBlockAddButtonKey,
              onPressed: controller.addMeetingTimeBlock,
              icon: const Icon(Icons.add_rounded, size: 17),
              label: const Text('상세 일정 추가'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AlagagiColors.sageDeep,
                side: const BorderSide(color: Color(0x338A9A7E)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: sans(size: 12.5, weight: FontWeight.w800),
              ),
            ),
          ),
          if (controller.state.meetingDraftTimeBlocks.isNotEmpty) ...[
            const SizedBox(height: 10),
            Column(
              children: [
                for (final block in controller.state.meetingDraftTimeBlocks)
                  _MeetingTimeBlockRow(
                    block: block,
                    onRemove: () => controller.removeMeetingTimeBlock(block.id),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 14),
          _MeetingTextField(
            fieldKey: meetingSharedMemoFieldKey,
            label: '상대에게 남길 한마디',
            hint: '예: 19:30 이후면 편해요',
            initialValue: controller.state.meetingDraftSharedMemo,
            maxLength: 120,
            helperText: '시간표에 덧붙일 짧은 조율 메시지예요.',
            onChanged: (value) =>
                controller.updateMeetingDraft(sharedMemo: value),
          ),
          if (controller.state.meetingDraftError != null &&
              controller.state.meetingSaveStatus != SaveStatus.failed) ...[
            const SizedBox(height: 9),
            Text(
              controller.state.meetingDraftError!,
              style: sans(size: 12, color: AlagagiColors.sageDeep),
            ),
          ],
          const SizedBox(height: 14),
          _PrimaryButton(
            label: '일정 저장하기',
            buttonKey: meetingSubmitButtonKey,
            onPressed: controller.submitMeetingDraft,
            color: AlagagiColors.sageDeep,
          ),
          _MeetingSaveStatus(controller: controller),
        ],
      ),
    );
  }
}

class _MeetingDayPanel extends StatelessWidget {
  const _MeetingDayPanel({
    required this.controller,
    required this.alreadyMeetingDay,
    required this.sharedSlots,
  });

  final AlagagiController controller;
  final bool alreadyMeetingDay;
  final Set<MeetingTimeSlot> sharedSlots;

  @override
  Widget build(BuildContext context) {
    final slotLabel = sharedSlots.isEmpty
        ? '겹치는 시간을 확인하고 있어요.'
        : '${sharedSlots.map(_meetingTimeSlotLabel).join(', ')}에 서로 괜찮아요.';
    return Container(
      decoration: BoxDecoration(
        color: alreadyMeetingDay ? AlagagiColors.ink : const Color(0xFFF3F6EE),
        border: Border.all(
          color: alreadyMeetingDay
              ? AlagagiColors.ink
              : const Color(0x338A9A7E),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  alreadyMeetingDay ? '만나는 날' : '둘 다 가능한 날이에요',
                  style: serif(
                    context,
                    size: 18,
                    weight: FontWeight.w800,
                    color: alreadyMeetingDay ? Colors.white : AlagagiColors.ink,
                  ),
                ),
              ),
              _SmallBadge(
                label: alreadyMeetingDay ? '정해짐' : '후보',
                dark: alreadyMeetingDay,
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            alreadyMeetingDay
                ? '시간이나 메모는 정해진 형식 없이 편하게 다시 적어둘 수 있어요.'
                : '$slotLabel 시간은 편한 말로 바로 적어도 괜찮아요.',
            style: sans(
              size: 12,
              height: 1.55,
              color: alreadyMeetingDay
                  ? Colors.white.withValues(alpha: 0.72)
                  : AlagagiColors.muted,
            ),
          ),
          const SizedBox(height: 12),
          _MeetingTextField(
            fieldKey: meetingDayTimeFieldKey,
            label: '만나는 시간',
            hint: '예: 19:00-21:00, 저녁 7시쯤',
            initialValue: controller.state.meetingDraftMeetingTimeLabel,
            maxLength: 40,
            helperText: '딱 맞춘 형식이 아니어도 괜찮아요.',
            minLines: 1,
            maxLines: 1,
            onChanged: (value) =>
                controller.updateMeetingDayDraft(timeLabel: value),
          ),
          const SizedBox(height: 9),
          _MeetingTextField(
            fieldKey: meetingDayNoteFieldKey,
            label: '만나는 날 메모',
            hint: '예: 장소는 성수 쪽으로 천천히 보기',
            initialValue: controller.state.meetingDraftMeetingNote,
            maxLength: 80,
            helperText: '',
            minLines: 1,
            maxLines: 2,
            onChanged: (value) => controller.updateMeetingDayDraft(note: value),
          ),
          const SizedBox(height: 11),
          _PrimaryButton(
            label: alreadyMeetingDay ? '만나는 날 수정 저장' : '만나는 날로 저장하기',
            buttonKey: meetingDaySaveButtonKey,
            onPressed: controller.submitMeetingDayDraft,
            color: alreadyMeetingDay
                ? AlagagiColors.sageDeep
                : AlagagiColors.ink,
          ),
        ],
      ),
    );
  }
}

class _MeetingSaveStatus extends StatelessWidget {
  const _MeetingSaveStatus({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
    final status = state.meetingSaveStatus;
    final message = switch (status) {
      SaveStatus.saving => '일정을 저장하고 있어요.',
      SaveStatus.saved => state.meetingSaveFeedback,
      SaveStatus.failed => state.meetingDraftError,
      SaveStatus.idle => null,
    };
    if (message == null || message.isEmpty) {
      return const SizedBox.shrink();
    }
    final failed = status == SaveStatus.failed;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(
          color: failed ? const Color(0xFFFFF7F3) : const Color(0xFFF7F8F3),
          border: Border.all(
            color: failed ? const Color(0x33B18472) : const Color(0x338A9A7E),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(
              failed
                  ? Icons.error_outline_rounded
                  : status == SaveStatus.saving
                  ? Icons.sync_rounded
                  : Icons.check_circle_outline_rounded,
              size: 16,
              color: failed ? const Color(0xFFB18472) : AlagagiColors.sageDeep,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: sans(
                  size: 12,
                  color: failed
                      ? const Color(0xFFB18472)
                      : AlagagiColors.sageDeep,
                  weight: FontWeight.w700,
                ),
              ),
            ),
            if (failed && controller.canRetryMeetingSave)
              TextButton(
                key: meetingRetryButtonKey,
                onPressed: controller.retryMeetingSave,
                child: Text(
                  '다시 시도',
                  style: sans(size: 12, weight: FontWeight.w800),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MeetingPersonRow extends StatelessWidget {
  const _MeetingPersonRow({
    required this.name,
    required this.avatar,
    required this.entry,
    required this.isMe,
  });

  final String name;
  final String avatar;
  final ScheduleEntry? entry;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final status = _meetingAvailabilityLabel(entry?.availability);
    final sharedMemo = entry?.sharedMemo.trim() ?? '';
    final meetingTimeLabel = entry?.meetingTimeLabel.trim() ?? '';
    final meetingNote = entry?.meetingNote.trim() ?? '';
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F4),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(11),
      child: Row(
        children: [
          _AvatarBubble(label: avatar),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: sans(size: 12.5, weight: FontWeight.w800)),
                const SizedBox(height: 3),
                Text(
                  [
                    status,
                    if (entry != null && entry!.timeSlots.isNotEmpty)
                      entry!.timeSlots.map(_meetingTimeSlotLabel).join(', '),
                  ].join(' · '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: sans(
                    size: 11.2,
                    color: AlagagiColors.muted,
                    height: 1.4,
                  ),
                ),
                if (entry != null && entry!.timeBlocks.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  for (final block in entry!.timeBlocks.take(3))
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        _meetingTimeBlockLabel(block),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: sans(
                          size: 11,
                          color: const Color(0xFF6B675F),
                          height: 1.35,
                        ),
                      ),
                    ),
                ],
                if (sharedMemo.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  Text(
                    isMe ? '상대에게: $sharedMemo' : sharedMemo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: sans(
                      size: 11,
                      color: const Color(0xFF6B675F),
                      height: 1.35,
                    ),
                  ),
                ],
                if (entry?.isMeetingDay == true) ...[
                  const SizedBox(height: 5),
                  Text(
                    [
                      '만나는 날',
                      if (meetingTimeLabel.isNotEmpty) meetingTimeLabel,
                      if (meetingNote.isNotEmpty) meetingNote,
                    ].join(' · '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: sans(
                      size: 11,
                      color: AlagagiColors.sageDeep,
                      weight: FontWeight.w800,
                      height: 1.35,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MeetingTimeBlockRow extends StatelessWidget {
  const _MeetingTimeBlockRow({required this.block, required this.onRemove});

  final ScheduleTimeBlock block;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F4),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.fromLTRB(11, 8, 6, 8),
      child: Row(
        children: [
          Icon(Icons.schedule_rounded, size: 16, color: AlagagiColors.sageDeep),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _meetingTimeBlockLabel(block),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: sans(size: 12.2, color: const Color(0xFF56544D)),
            ),
          ),
          SizedBox(
            width: 30,
            height: 30,
            child: IconButton(
              key: meetingTimeBlockRemoveButtonKey(block.id),
              onPressed: onRemove,
              icon: const Icon(Icons.close_rounded, size: 16),
              color: AlagagiColors.muted,
              padding: EdgeInsets.zero,
              tooltip: '삭제',
            ),
          ),
        ],
      ),
    );
  }
}

class _MeetingCandidateCard extends StatelessWidget {
  const _MeetingCandidateCard({required this.candidate});

  final MeetingCandidate candidate;

  @override
  Widget build(BuildContext context) {
    final detailCount =
        (candidate.myEntry?.timeBlocks.length ?? 0) +
        (candidate.partnerEntry?.timeBlocks.length ?? 0);
    return _PaperCard(
      radius: 18,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AlagagiColors.ink,
              borderRadius: BorderRadius.circular(15),
            ),
            alignment: Alignment.center,
            child: Text(
              DateTime.tryParse(candidate.dateKey)?.day.toString() ?? '',
              style: sans(
                size: 15,
                weight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _meetingDateLabel(candidate.dateKey),
                  style: sans(size: 13.5, weight: FontWeight.w800),
                ),
                const SizedBox(height: 3),
                Text(
                  [
                    '${candidate.sharedSlots.map(_meetingTimeSlotLabel).join(', ')}에 겹쳐요',
                    if (detailCount > 0) '상세 일정 $detailCount개',
                  ].join(' · '),
                  style: sans(size: 11.5, color: AlagagiColors.muted),
                ),
              ],
            ),
          ),
          const _SmallBadge(label: '추천'),
        ],
      ),
    );
  }
}

class _MeetingTextField extends StatefulWidget {
  const _MeetingTextField({
    required this.fieldKey,
    required this.label,
    required this.hint,
    required this.initialValue,
    required this.maxLength,
    required this.helperText,
    required this.onChanged,
    this.minLines = 2,
    this.maxLines = 3,
    this.keyboardType,
  });

  final Key fieldKey;
  final String label;
  final String hint;
  final String initialValue;
  final int maxLength;
  final String helperText;
  final ValueChanged<String> onChanged;
  final int minLines;
  final int maxLines;
  final TextInputType? keyboardType;

  @override
  State<_MeetingTextField> createState() => _MeetingTextFieldState();
}

class _MeetingTextFieldState extends State<_MeetingTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant _MeetingTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue &&
        _controller.text != widget.initialValue) {
      _controller.text = widget.initialValue;
      _controller.selection = TextSelection.collapsed(
        offset: widget.initialValue.length,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F4),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.fromLTRB(14, 7, 14, 7),
      child: TextFormField(
        key: widget.fieldKey,
        controller: _controller,
        maxLength: widget.maxLength,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          helperText: widget.helperText.isEmpty ? null : widget.helperText,
          counterText: '',
          isDense: true,
          border: InputBorder.none,
        ),
        style: sans(size: 13, height: 1.45),
      ),
    );
  }
}

class PlaceBoardScreen extends StatefulWidget {
  const PlaceBoardScreen({
    super.key,
    required this.controller,
    required this.onOpenExternalLink,
  });

  final AlagagiController controller;
  final ValueChanged<String> onOpenExternalLink;

  @override
  State<PlaceBoardScreen> createState() => _PlaceBoardScreenState();
}

class _PlaceBoardScreenState extends State<PlaceBoardScreen> {
  bool _mapOverlayVisible = true;

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final onOpenExternalLink = widget.onOpenExternalLink;
    final places = controller.sharedPlaces;
    final mutualCount = places.where((place) => place.isMutual).length;
    return _ScreenScroll(
      bottomNavigation: _BottomNav(controller: controller),
      children: [
        _TopBar(title: '가보고 싶은 곳', trailing: ''),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Text(
                '지도에서 찾은 장소를 둘만의 보드에 모아요',
                style: sans(size: 12.5, color: AlagagiColors.muted),
              ),
            ),
            const SizedBox(width: 8),
            _PlaceMapOverlayButton(
              visible: _mapOverlayVisible,
              onPressed: _toggleMapOverlay,
            ),
          ],
        ),
        const SizedBox(height: 14),
        _PlaceMapPreview(
          controller: controller,
          mutualCount: mutualCount,
          totalCount: places.length,
          places: places,
          overlayVisible: _mapOverlayVisible,
        ),
        _PlaceSaveStatus(controller: controller),
        const SizedBox(height: 14),
        if (controller.state.placeDraftVisible)
          _PlaceDraftCard(controller: controller)
        else
          _PlaceSearchEntryCard(controller: controller),
        const SizedBox(height: 18),
        Row(
          children: [
            const Expanded(child: _SectionLabel('장소 보드')),
            _SmallBadge(label: '지도 검색'),
          ],
        ),
        const SizedBox(height: 12),
        if (places.isEmpty)
          const _EmptyStateCard(text: '가보고 싶은 곳을 하나만 담아볼까요?')
        else
          Column(
            key: placeBoardKey,
            children: [
              for (final place in places) ...[
                _PlaceCard(
                  controller: controller,
                  place: place,
                  onOpenExternalLink: onOpenExternalLink,
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
      ],
    );
  }

  void _toggleMapOverlay() {
    setState(() => _mapOverlayVisible = !_mapOverlayVisible);
  }
}

class _PlaceMapPreview extends StatefulWidget {
  const _PlaceMapPreview({
    required this.controller,
    required this.mutualCount,
    required this.totalCount,
    required this.places,
    required this.overlayVisible,
  });

  final AlagagiController controller;
  final int mutualCount;
  final int totalCount;
  final List<SharedPlace> places;
  final bool overlayVisible;

  @override
  State<_PlaceMapPreview> createState() => _PlaceMapPreviewState();
}

class _PlaceMapPreviewState extends State<_PlaceMapPreview> {
  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final mutualCount = widget.mutualCount;
    final totalCount = widget.totalCount;
    final places = widget.places;
    final overlayVisible = widget.overlayVisible;
    final draftLatitude = controller.state.placeDraftLatitude;
    final draftLongitude = controller.state.placeDraftLongitude;
    final hasDraftLocation =
        controller.state.placeDraftVisible &&
        draftLatitude != null &&
        draftLongitude != null;
    final markers = [
      for (final place in places)
        if (place.latitude != null && place.longitude != null)
          KakaoMapMarkerData(
            id: place.id,
            title: place.name,
            latitude: place.latitude!,
            longitude: place.longitude!,
          ),
      if (hasDraftLocation)
        KakaoMapMarkerData(
          id: 'place-draft-preview',
          title: controller.state.placeDraftName.trim().isEmpty
              ? '선택한 장소'
              : controller.state.placeDraftName.trim(),
          latitude: draftLatitude,
          longitude: draftLongitude,
        ),
    ];
    final mapHeight = _placeBoardMapHeight(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final mapFrame = Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE9EEE8),
            border: Border.all(color: AlagagiColors.line),
            borderRadius: BorderRadius.circular(24),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned.fill(
                child: KakaoMapPanel(
                  centerLatitude: hasDraftLocation
                      ? draftLatitude
                      : _mapCenterLatitude,
                  centerLongitude: hasDraftLocation
                      ? draftLongitude
                      : _mapCenterLongitude,
                  level: hasDraftLocation ? 4 : 6,
                  markers: markers,
                  fallbackBuilder: (context, reason) => _PlaceMapFallback(
                    reason: reason,
                    mutualCount: mutualCount,
                    totalCount: totalCount,
                  ),
                ),
              ),
              if (overlayVisible) ...[
                Positioned(
                  left: 16,
                  top: 16,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AlagagiColors.paper.withValues(alpha: 0.93),
                      border: Border.all(color: AlagagiColors.line),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: AlagagiColors.softSage,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.map_outlined,
                            size: 18,
                            color: AlagagiColors.sageDeep,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '장소 지도',
                                style: sans(
                                  size: 12.8,
                                  weight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                hasDraftLocation
                                    ? '선택한 장소가 큰 지도에 표시됐어요'
                                    : '저장한 장소를 한눈에 크게 봐요',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: sans(
                                  size: 11.2,
                                  color: hasDraftLocation
                                      ? AlagagiColors.sageDeep
                                      : AlagagiColors.muted,
                                  weight: hasDraftLocation
                                      ? FontWeight.w700
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AlagagiColors.paper.withValues(alpha: 0.94),
                      border: Border.all(color: AlagagiColors.line),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                totalCount == 0
                                    ? '아직 담은 장소가 없어요'
                                    : '$totalCount곳이 지도에 모였어요',
                                style: sans(size: 13, weight: FontWeight.w800),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _SmallBadge(label: '지도'),
                          ],
                        ),
                        const SizedBox(height: 9),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            _MapSummaryPill(label: '서로 관심 $mutualCount'),
                            _MapSummaryPill(label: '담은 곳 $totalCount'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
        if (!constraints.hasBoundedWidth) {
          return SizedBox(height: mapHeight, child: mapFrame);
        }
        final expandedWidth =
            constraints.maxWidth + (_placeBoardMapHorizontalBleed * 2);
        return SizedBox(
          height: mapHeight,
          child: OverflowBox(
            alignment: Alignment.center,
            minWidth: expandedWidth,
            maxWidth: expandedWidth,
            child: SizedBox(
              width: expandedWidth,
              height: mapHeight,
              child: mapFrame,
            ),
          ),
        );
      },
    );
  }
}

class _PlaceMapOverlayButton extends StatelessWidget {
  const _PlaceMapOverlayButton({
    required this.visible,
    required this.onPressed,
  });

  final bool visible;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: visible ? '지도 정보 숨기기' : '지도 정보 보기',
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          visible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
          size: 18,
        ),
        style: IconButton.styleFrom(
          fixedSize: const Size(36, 36),
          minimumSize: const Size(36, 36),
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: AlagagiColors.paper.withValues(alpha: 0.94),
          foregroundColor: AlagagiColors.sageDeep,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
            side: const BorderSide(color: AlagagiColors.line),
          ),
        ),
      ),
    );
  }
}

class _PlaceSaveStatus extends StatelessWidget {
  const _PlaceSaveStatus({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
    final status = state.placeSaveStatus;
    final message = switch (status) {
      SaveStatus.saving => '장소를 저장 중이에요...',
      SaveStatus.saved => state.placeSaveFeedback,
      SaveStatus.failed => state.placeError,
      SaveStatus.idle => null,
    };
    if (message == null || message.isEmpty) {
      return const SizedBox.shrink();
    }
    final failed = status == SaveStatus.failed;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(
          color: failed ? const Color(0xFFFFF7F3) : const Color(0xFFF7F8F3),
          border: Border.all(
            color: failed ? const Color(0x33B18472) : const Color(0x338A9A7E),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(
              failed
                  ? Icons.error_outline_rounded
                  : status == SaveStatus.saving
                  ? Icons.sync_rounded
                  : Icons.check_circle_outline_rounded,
              size: 16,
              color: failed ? const Color(0xFFB18472) : AlagagiColors.sageDeep,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: sans(
                  size: 12,
                  color: failed
                      ? const Color(0xFFB18472)
                      : AlagagiColors.sageDeep,
                  weight: FontWeight.w700,
                ),
              ),
            ),
            if (failed && controller.canRetryPlaceSave)
              TextButton(
                key: placeRetryButtonKey,
                onPressed: controller.retryPlaceSave,
                child: Text(
                  '다시 시도',
                  style: sans(size: 12, weight: FontWeight.w800),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PlaceMapFallback extends StatelessWidget {
  const _PlaceMapFallback({
    required this.reason,
    required this.mutualCount,
    required this.totalCount,
  });

  final String reason;
  final int mutualCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final message = _kakaoMapFallbackMessage(reason);
    return Stack(
      children: [
        Positioned.fill(child: CustomPaint(painter: _QuietMapPainter())),
        const _MapPin(left: 238, top: 94, color: AlagagiColors.sageDeep),
        const _MapPin(left: 92, top: 126, color: AlagagiColors.lavender),
        const _MapPin(left: 174, top: 156, color: Color(0xFFB18472)),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: sans(
                size: 10.8,
                color: const Color(0xFF7B7870),
                height: 1.35,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PlaceSearchEntryCard extends StatelessWidget {
  const _PlaceSearchEntryCard({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return _PaperCard(
      radius: 24,
      padding: const EdgeInsets.all(18),
      highlightedBorder: const Color(0x228A9A7E),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'PLACE SEARCH',
            style: sans(
              size: 10.5,
              weight: FontWeight.w800,
              color: AlagagiColors.sageDeep,
              letterSpacing: 1.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '지도에서 찾고\n둘의 보드에 담아요',
            style: serif(
              context,
              size: 22,
              weight: FontWeight.w800,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '장소를 검색해 선택하면 주소와 좌표가 저장되고, 지도에 바로 표시됩니다.',
            style: sans(size: 12.5, color: AlagagiColors.muted, height: 1.6),
          ),
          const SizedBox(height: 15),
          FilledButton.icon(
            key: placeAddButtonKey,
            onPressed: controller.startPlaceDraft,
            icon: const Icon(Icons.search_rounded, size: 18),
            label: const Text('장소 검색하기'),
            style: FilledButton.styleFrom(
              backgroundColor: AlagagiColors.sageDeep,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: sans(size: 13, weight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceDraftCard extends StatelessWidget {
  const _PlaceDraftCard({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.state.editingPlaceId != null;
    return _PaperCard(
      radius: 22,
      padding: const EdgeInsets.all(18),
      highlightedBorder: AlagagiColors.sage,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            isEditing ? '장소 정보를\n다듬어요.' : '가보고 싶은 곳을\n보드에 담아요.',
            style: serif(
              context,
              size: 20,
              weight: FontWeight.w800,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            isEditing
                ? '메모와 카테고리를 고치거나, 다른 지도 검색 결과로 장소를 바꿀 수 있어요.'
                : '지도에서 장소를 검색하고 결과를 선택하면 주소와 좌표가 함께 저장돼요.',
            style: sans(size: 12.5, color: AlagagiColors.muted, height: 1.6),
          ),
          const SizedBox(height: 14),
          _KakaoPlaceSearchPanel(controller: controller),
          const SizedBox(height: 12),
          _SelectedPlacePreview(controller: controller),
          const SizedBox(height: 10),
          _PlaceTextField(
            fieldKey: placeNoteFieldKey,
            label: 'NOTE',
            hint: '왜 같이 가보고 싶은지 한 줄로',
            initialValue: controller.state.placeDraftNote,
            maxLength: 120,
            minLines: 2,
            maxLines: 3,
            onChanged: (value) => controller.updatePlaceDraft(note: value),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final category in PlaceCategory.values)
                _FilterPill(
                  label: _placeCategoryLabel(category),
                  selected: controller.state.placeDraftCategory == category,
                  onTap: () => controller.setPlaceDraftCategory(category),
                ),
            ],
          ),
          if (controller.state.placeDraftError != null) ...[
            const SizedBox(height: 10),
            _PlaceDraftErrorCard(message: controller.state.placeDraftError!),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton(
                onPressed: controller.cancelPlaceDraft,
                child: Text(
                  '취소',
                  style: sans(size: 13, color: AlagagiColors.muted),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PrimaryButton(
                  label: isEditing ? '수정 저장하기' : '장소 보드에 담기',
                  buttonKey: placeSubmitButtonKey,
                  onPressed: controller.submitPlaceDraft,
                  color: AlagagiColors.sageDeep,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _KakaoPlaceSearchPanel extends StatefulWidget {
  const _KakaoPlaceSearchPanel({required this.controller});

  final AlagagiController controller;

  @override
  State<_KakaoPlaceSearchPanel> createState() => _KakaoPlaceSearchPanelState();
}

class _KakaoPlaceSearchPanelState extends State<_KakaoPlaceSearchPanel> {
  final TextEditingController _queryController = TextEditingController();
  List<KakaoPlaceSearchResult> _results = const [];
  bool _searching = false;
  String? _error;

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final keyword = _queryController.text.trim();
    if (keyword.length < 2) {
      setState(() {
        _results = const [];
        _error = '두 글자 이상 입력해주세요.';
      });
      return;
    }

    setState(() {
      _searching = true;
      _error = null;
    });
    try {
      final results = await searchKakaoPlaces(keyword);
      if (!mounted) {
        return;
      }
      setState(() {
        _results = results;
        _error = results.isEmpty ? '검색 결과가 없어요.' : null;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _results = const [];
        _error = '장소 검색을 불러오지 못했어요.';
      });
    } finally {
      if (mounted) {
        setState(() => _searching = false);
      }
    }
  }

  void _select(KakaoPlaceSearchResult result) {
    widget.controller.applyKakaoPlaceResult(
      providerPlaceId: result.id,
      name: result.name,
      address: result.roadAddress.isNotEmpty
          ? result.roadAddress
          : result.address,
      latitude: result.latitude,
      longitude: result.longitude,
      category: _placeCategoryFromKakaoResult(result),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedPlaceId = widget.controller.state.placeDraftProviderPlaceId;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F4),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(17),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  key: placeSearchFieldKey,
                  controller: _queryController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _search(),
                  decoration: InputDecoration(
                    hintText: '장소명 검색',
                    prefixIcon: const Icon(Icons.search_rounded, size: 18),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 11,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AlagagiColors.line),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AlagagiColors.line),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: AlagagiColors.sageDeep,
                      ),
                    ),
                  ),
                  style: sans(size: 13.2),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 44,
                child: FilledButton(
                  key: placeSearchButtonKey,
                  onPressed: _searching ? null : _search,
                  style: FilledButton.styleFrom(
                    backgroundColor: AlagagiColors.sageDeep,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: sans(size: 12.5, weight: FontWeight.w800),
                  ),
                  child: Text(_searching ? '검색 중' : '검색'),
                ),
              ),
            ],
          ),
          if (_error != null) ...[
            const SizedBox(height: 9),
            if (_error!.contains('장소 검색'))
              _KakaoSearchHelpCard(message: _error!, onRetry: _search)
            else
              Text(
                _error!,
                style: sans(size: 11.5, color: AlagagiColors.muted),
              ),
          ],
          if (_results.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '검색 결과',
                    style: sans(size: 12.2, weight: FontWeight.w800),
                  ),
                ),
                Text(
                  '누르면 지도와 저장 미리보기가 바뀌어요',
                  style: sans(size: 10.5, color: AlagagiColors.muted),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Column(
              children: [
                for (final result in _results)
                  _KakaoPlaceResultRow(
                    result: result,
                    selected: result.id == selectedPlaceId,
                    onTap: () => _select(result),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _KakaoSearchHelpCard extends StatelessWidget {
  const _KakaoSearchHelpCard({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4E9E4),
        border: Border.all(color: const Color(0x33B18472)),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 17,
                color: Color(0xFF8F5F50),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: sans(
                    size: 12,
                    color: const Color(0xFF8F5F50),
                    weight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '개발자 콘솔의 Web 플랫폼에 현재 도메인과 JavaScript Key가 등록되어 있는지 확인해주세요.',
            style: sans(
              size: 11.4,
              color: const Color(0xFF7B6860),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: const [
              _KakaoSetupChip('https://ieeh1016.github.io'),
              _KakaoSetupChip('http://127.0.0.1:8097'),
              _KakaoSetupChip('JavaScript Key'),
            ],
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 15),
            label: const Text('다시 검색하기'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF8F5F50),
              side: const BorderSide(color: Color(0x33B18472)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
              textStyle: sans(size: 12, weight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _KakaoSetupChip extends StatelessWidget {
  const _KakaoSetupChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        border: Border.all(color: const Color(0x22B18472)),
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Text(
        label,
        style: sans(
          size: 10.5,
          color: const Color(0xFF7B6860),
          weight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _KakaoPlaceResultRow extends StatelessWidget {
  const _KakaoPlaceResultRow({
    required this.result,
    required this.selected,
    required this.onTap,
  });

  final KakaoPlaceSearchResult result;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final address = result.roadAddress.isNotEmpty
        ? result.roadAddress
        : result.address;
    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: InkWell(
        key: placeSearchResultButtonKey(result.id),
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: selected ? AlagagiColors.sagePanel : Colors.white,
            border: Border.all(
              color: selected ? const Color(0x668A9A7E) : AlagagiColors.line,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: selected
                      ? AlagagiColors.sageDeep
                      : AlagagiColors.softSage,
                  borderRadius: BorderRadius.circular(13),
                ),
                alignment: Alignment.center,
                child: Icon(
                  selected ? Icons.check_rounded : Icons.place_outlined,
                  size: 17,
                  color: selected ? Colors.white : AlagagiColors.sageDeep,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: sans(size: 12.7, weight: FontWeight.w800),
                    ),
                    if (address.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: sans(size: 10.8, color: AlagagiColors.muted),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: selected ? Colors.white : AlagagiColors.paper,
                  border: Border.all(color: const Color(0x336F7F63)),
                  borderRadius: BorderRadius.circular(999),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                child: Text(
                  selected ? '선택됨' : '선택',
                  style: sans(
                    size: 10.8,
                    color: AlagagiColors.sageDeep,
                    weight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectedPlacePreview extends StatelessWidget {
  const _SelectedPlacePreview({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final name = controller.state.placeDraftName.trim();
    final address = controller.state.placeDraftAddress.trim();
    final latitude = controller.state.placeDraftLatitude;
    final longitude = controller.state.placeDraftLongitude;
    final hasSelection =
        name.isNotEmpty && latitude != null && longitude != null;
    return Container(
      decoration: BoxDecoration(
        color: hasSelection ? AlagagiColors.paper : const Color(0xFFF8F8F4),
        border: Border.all(
          color: hasSelection ? const Color(0x668A9A7E) : AlagagiColors.line,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: hasSelection
                      ? AlagagiColors.sageDeep
                      : AlagagiColors.softSage,
                  borderRadius: BorderRadius.circular(13),
                ),
                alignment: Alignment.center,
                child: Icon(
                  hasSelection
                      ? Icons.check_rounded
                      : Icons.add_location_alt_outlined,
                  size: 18,
                  color: hasSelection ? Colors.white : AlagagiColors.sageDeep,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasSelection ? '선택한 장소가 준비됐어요' : '검색 결과를 선택해주세요',
                      style: sans(size: 13.5, weight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasSelection
                          ? '저장하면 둘의 장소 보드와 지도에 함께 표시됩니다.'
                          : '검색 결과를 누르면 주소와 좌표가 자동으로 들어와요.',
                      style: sans(
                        size: 11.6,
                        color: AlagagiColors.muted,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _SmallBadge(label: hasSelection ? '지도' : '대기'),
            ],
          ),
          const SizedBox(height: 12),
          _SelectedPlaceField(
            fieldKey: placeNameFieldKey,
            label: '선택한 장소',
            value: name,
            emptyText: '아직 선택된 장소가 없어요.',
          ),
          const SizedBox(height: 9),
          _SelectedPlaceField(
            fieldKey: placeAddressFieldKey,
            label: '주소',
            value: address,
            emptyText: '장소를 고르면 주소가 표시돼요.',
          ),
          if (hasSelection) ...[
            const SizedBox(height: 11),
            _SelectedPlaceMiniMap(
              name: name,
              latitude: latitude,
              longitude: longitude,
            ),
          ],
        ],
      ),
    );
  }
}

class _SelectedPlaceMiniMap extends StatelessWidget {
  const _SelectedPlaceMiniMap({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  final String name;
  final double latitude;
  final double longitude;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _selectedPlaceMiniMapHeight,
      decoration: BoxDecoration(
        color: const Color(0xFFE9EEE8),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: KakaoMapPanel(
        centerLatitude: latitude,
        centerLongitude: longitude,
        level: 4,
        markers: [
          KakaoMapMarkerData(
            id: 'selected-place-preview',
            title: name,
            latitude: latitude,
            longitude: longitude,
          ),
        ],
        fallbackBuilder: (context, reason) => Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _QuietMapPainter())),
            const _MapPin(left: 154, top: 72, color: AlagagiColors.sageDeep),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  _kakaoMapFallbackMessage(reason),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: sans(
                    size: 10.5,
                    color: const Color(0xFF7B7870),
                    height: 1.35,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceDraftErrorCard extends StatelessWidget {
  const _PlaceDraftErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4E9E4),
        border: Border.all(color: const Color(0x33B18472)),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 17,
            color: Color(0xFF8F5F50),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: sans(
                size: 12,
                color: const Color(0xFF8F5F50),
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectedPlaceField extends StatelessWidget {
  const _SelectedPlaceField({
    required this.fieldKey,
    required this.label,
    required this.value,
    required this.emptyText,
  });

  final Key fieldKey;
  final String label;
  final String value;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    final hasValue = value.trim().isNotEmpty;
    return Container(
      key: fieldKey,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F4),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: sans(
              size: 10.5,
              weight: FontWeight.w800,
              color: AlagagiColors.sageDeep,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            hasValue ? value : emptyText,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: sans(
              size: 13.3,
              color: hasValue ? const Color(0xFF4D4B45) : AlagagiColors.muted,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceTextField extends StatelessWidget {
  const _PlaceTextField({
    required this.fieldKey,
    required this.label,
    required this.hint,
    required this.initialValue,
    required this.maxLength,
    required this.onChanged,
    this.minLines = 1,
    this.maxLines = 1,
  });

  final Key fieldKey;
  final String label;
  final String hint;
  final String initialValue;
  final int maxLength;
  final ValueChanged<String> onChanged;
  final int minLines;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F4),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.fromLTRB(14, 7, 14, 7),
      child: TextFormField(
        key: fieldKey,
        initialValue: initialValue,
        maxLength: maxLength,
        minLines: minLines,
        maxLines: maxLines,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          counterText: '',
          border: InputBorder.none,
        ),
        style: sans(size: 13.5, height: 1.45),
      ),
    );
  }
}

class _PlaceCard extends StatelessWidget {
  const _PlaceCard({
    required this.controller,
    required this.place,
    required this.onOpenExternalLink,
  });

  final AlagagiController controller;
  final SharedPlace place;
  final ValueChanged<String> onOpenExternalLink;

  @override
  Widget build(BuildContext context) {
    final isMine = place.createdByProfileId == controller.state.me.id;
    final likedByMe = place.interestedByProfileIds.contains(
      controller.state.me.id,
    );
    final placeBusy =
        controller.state.placeSaveStatus == SaveStatus.saving &&
        controller.isPlaceSaveTarget(place.id);
    final creator = isMine
        ? controller.state.me.nickname
        : controller.state.partner.nickname;
    final kakaoPlaceUrl = _kakaoPlaceUrl(place);
    return _PaperCard(
      radius: 19,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2EB),
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                child: Icon(
                  _placeCategoryIcon(place.category),
                  size: 22,
                  color: AlagagiColors.sageDeep,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            place.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: sans(size: 14.5, weight: FontWeight.w800),
                          ),
                        ),
                        const SizedBox(width: 7),
                        _SmallBadge(
                          label: place.isMutual
                              ? '서로 관심'
                              : _providerLabel(place.provider),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_placeCategoryLabel(place.category)} · $creator 저장',
                      style: sans(size: 11.3, color: AlagagiColors.muted),
                    ),
                    if (place.address.isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Text(
                        place.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: sans(size: 11.5, color: const Color(0xFF6F6C65)),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (place.note.isNotEmpty) ...[
            const SizedBox(height: 11),
            Text(
              place.note,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: sans(
                size: 12.3,
                color: const Color(0xFF5F5D57),
                height: 1.45,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (kakaoPlaceUrl != null)
                SizedBox(
                  height: 32,
                  child: OutlinedButton.icon(
                    onPressed: () => onOpenExternalLink(kakaoPlaceUrl),
                    icon: const Icon(Icons.open_in_new_rounded, size: 14),
                    label: const Text('지도에서 열기'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AlagagiColors.sageDeep,
                      side: const BorderSide(color: Color(0x336F7F63)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      textStyle: sans(size: 11.5, weight: FontWeight.w800),
                    ),
                  ),
                ),
              SizedBox(
                height: 32,
                child: OutlinedButton.icon(
                  key: placeInterestButtonKey(place.id),
                  onPressed: placeBusy
                      ? null
                      : () => controller.togglePlaceInterest(place.id),
                  icon: Icon(
                    likedByMe
                        ? Icons.remove_circle_outline_rounded
                        : Icons.add_circle_outline_rounded,
                    size: 14,
                  ),
                  label: Text(likedByMe ? '관심 해제' : '관심 표시'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AlagagiColors.sageDeep,
                    disabledForegroundColor: AlagagiColors.muted,
                    side: const BorderSide(color: Color(0x336F7F63)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                    textStyle: sans(size: 11.5, weight: FontWeight.w800),
                  ),
                ),
              ),
              if (isMine)
                SizedBox(
                  height: 32,
                  child: OutlinedButton.icon(
                    key: placeEditButtonKey(place.id),
                    onPressed: placeBusy
                        ? null
                        : () => controller.startEditingPlace(place.id),
                    icon: const Icon(Icons.edit_outlined, size: 14),
                    label: const Text('수정'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AlagagiColors.sageDeep,
                      side: const BorderSide(color: Color(0x336F7F63)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      textStyle: sans(size: 11.5, weight: FontWeight.w800),
                    ),
                  ),
                ),
              if (isMine)
                SizedBox(
                  height: 32,
                  child: OutlinedButton.icon(
                    key: placeDeleteButtonKey(place.id),
                    onPressed: placeBusy
                        ? null
                        : () => controller.deletePlace(place.id),
                    icon: const Icon(Icons.delete_outline_rounded, size: 14),
                    label: const Text('삭제'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFB18472),
                      side: const BorderSide(color: Color(0x33B18472)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      textStyle: sans(size: 11.5, weight: FontWeight.w800),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _TinyDot(color: color),
        const SizedBox(width: 5),
        Text(label, style: sans(size: 10.8, color: AlagagiColors.muted)),
      ],
    );
  }
}

class _TinyDot extends StatelessWidget {
  const _TinyDot({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _AvatarBubble extends StatelessWidget {
  const _AvatarBubble({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        color: AlagagiColors.sagePanel,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(label, style: sans(size: 13)),
    );
  }
}

class _MapPin extends StatelessWidget {
  const _MapPin({required this.left, required this.top, required this.color});

  final double left;
  final double top;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Transform.rotate(
        angle: -0.78,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
              bottomLeft: Radius.circular(4),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x26393934),
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 9,
              height: 9,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MapSummaryPill extends StatelessWidget {
  const _MapSummaryPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AlagagiColors.paper.withValues(alpha: 0.92),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: Text(
        label,
        style: sans(
          size: 11,
          weight: FontWeight.w800,
          color: AlagagiColors.sageDeep,
        ),
      ),
    );
  }
}

class _QuietMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0x66CDD6C2)
      ..strokeWidth = 1;
    for (var x = 0.0; x < size.width; x += 54) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (var y = 0.0; y < size.height; y += 54) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    final roadPaint = Paint()
      ..color = const Color(0xBFFFFFFA)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 18;
    canvas.drawLine(
      Offset(-20, size.height * .72),
      Offset(size.width + 20, size.height * .34),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * .18, -10),
      Offset(size.width * .78, size.height + 10),
      roadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

String _dateKeyForUi(DateTime date) {
  String twoDigits(int value) => value.toString().padLeft(2, '0');
  return '${date.year}-${twoDigits(date.month)}-${twoDigits(date.day)}';
}

String _meetingDateLabel(String dateKey) {
  final date = DateTime.tryParse(dateKey);
  if (date == null) {
    return dateKey;
  }
  const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
  return '${date.month}월 ${date.day}일 ${weekdays[date.weekday - 1]}요일';
}

String _meetingDateShortLabel(String dateKey) {
  final date = DateTime.tryParse(dateKey);
  if (date == null) {
    return dateKey;
  }
  return '${date.month}월 ${date.day}일';
}

String _meetingAvailabilityLabel(MeetingAvailability? availability) {
  return switch (availability) {
    MeetingAvailability.available => '가능',
    MeetingAvailability.maybe => '조율 필요',
    MeetingAvailability.busy => '어려움',
    null => '아직 없음',
  };
}

String _meetingTimeSlotLabel(MeetingTimeSlot slot) {
  return switch (slot) {
    MeetingTimeSlot.morning => '오전',
    MeetingTimeSlot.afternoon => '오후',
    MeetingTimeSlot.evening => '저녁',
  };
}

String _meetingTimeBlockLabel(ScheduleTimeBlock block) {
  return '${block.timeLabel} · ${block.title}';
}

String? _kakaoPlaceUrl(SharedPlace place) {
  final providerPlaceId = place.providerPlaceId.trim();
  if (providerPlaceId.isNotEmpty) {
    return 'https://place.map.kakao.com/${Uri.encodeComponent(providerPlaceId)}';
  }
  final latitude = place.latitude;
  final longitude = place.longitude;
  if (latitude == null || longitude == null) {
    return null;
  }
  return 'https://map.kakao.com/link/map/'
      '${Uri.encodeComponent(place.name)},$latitude,$longitude';
}

String _kakaoMapFallbackMessage(String reason) {
  if (reason.contains('불러오지') || reason.contains('브릿지')) {
    return '지도를 불러오지 못했어요. 도메인 등록과 JavaScript Key를 확인해주세요.';
  }
  return reason.isEmpty ? '지도를 준비하고 있어요.' : reason;
}

String _placeCategoryLabel(PlaceCategory category) {
  return switch (category) {
    PlaceCategory.cafe => '카페',
    PlaceCategory.food => '식사',
    PlaceCategory.exhibition => '전시',
    PlaceCategory.walk => '산책',
    PlaceCategory.activity => '활동',
  };
}

IconData _placeCategoryIcon(PlaceCategory category) {
  return switch (category) {
    PlaceCategory.cafe => Icons.local_cafe_outlined,
    PlaceCategory.food => Icons.restaurant_outlined,
    PlaceCategory.exhibition => Icons.museum_outlined,
    PlaceCategory.walk => Icons.directions_walk_rounded,
    PlaceCategory.activity => Icons.auto_awesome_motion_outlined,
  };
}

String _providerLabel(MapApiProvider provider) {
  return switch (provider) {
    MapApiProvider.kakao => '지도 검색',
  };
}

PlaceCategory _placeCategoryFromKakaoResult(KakaoPlaceSearchResult result) {
  final text =
      '${result.categoryGroupCode} ${result.categoryName} ${result.name}'
          .toLowerCase();
  if (text.contains('ce7') || text.contains('카페') || text.contains('cafe')) {
    return PlaceCategory.cafe;
  }
  if (text.contains('fd6') ||
      text.contains('음식') ||
      text.contains('식당') ||
      text.contains('restaurant')) {
    return PlaceCategory.food;
  }
  if (text.contains('ct1') ||
      text.contains('문화') ||
      text.contains('전시') ||
      text.contains('미술') ||
      text.contains('museum') ||
      text.contains('gallery')) {
    return PlaceCategory.exhibition;
  }
  if (text.contains('at4') ||
      text.contains('관광') ||
      text.contains('공원') ||
      text.contains('산책')) {
    return PlaceCategory.walk;
  }
  return PlaceCategory.activity;
}

class ImprovementBoardScreen extends StatelessWidget {
  const ImprovementBoardScreen({super.key, required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final posts = controller.improvementPosts;
    final state = controller.state;
    return _ScreenScroll(
      bottomNavigation: _BottomNav(controller: controller),
      children: [
        _TopBar(
          title: '건의함',
          trailing: '',
          onBack: () => controller.goTo(AlagagiRoute.home),
        ),
        const SizedBox(height: 4),
        Text(
          '좋아졌으면 하는 부분을 조용히 모아둬요',
          style: sans(size: 12.5, color: AlagagiColors.muted),
        ),
        const SizedBox(height: 16),
        const _ImprovementHeroCard(),
        if (state.improvementDraftVisible) ...[
          const SizedBox(height: 16),
          _ImprovementDraftCard(
            key: ValueKey(
              state.editingImprovementPostId ?? 'new-improvement-post',
            ),
            controller: controller,
          ),
        ],
        const SizedBox(height: 18),
        Row(
          children: [
            const Expanded(child: _SectionLabel('남긴 글')),
            if (!state.improvementDraftVisible)
              _ImprovementAddButton(controller: controller),
          ],
        ),
        const SizedBox(height: 12),
        _ImprovementSummaryCard(controller: controller),
        _ImprovementSaveStatus(controller: controller),
        const SizedBox(height: 12),
        if (posts.isEmpty)
          const _EmptyStateCard(text: '생각나는 개선점이나 추가 요청을 하나만 남겨볼까요?')
        else
          for (final post in posts) ...[
            _ImprovementPostCard(controller: controller, post: post),
            const SizedBox(height: 12),
          ],
      ],
    );
  }
}

class _ImprovementHeroCard extends StatelessWidget {
  const _ImprovementHeroCard();

  @override
  Widget build(BuildContext context) {
    return _PaperCard(
      radius: 22,
      padding: const EdgeInsets.all(18),
      highlightedBorder: AlagagiColors.sage,
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2EA),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.rate_review_outlined,
              size: 24,
              color: AlagagiColors.sageDeep,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '작은 불편함도\n다음 개선 후보가 돼요.',
                  style: serif(
                    context,
                    size: 19,
                    weight: FontWeight.w800,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '둘이 쓰면서 필요한 기능을 가볍게 쌓아둘 수 있어요.',
                  style: sans(
                    size: 12.3,
                    color: AlagagiColors.muted,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImprovementSummaryCard extends StatelessWidget {
  const _ImprovementSummaryCard({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final posts = controller.improvementPosts;
    final mineCount = posts
        .where((post) => post.createdByProfileId == controller.state.me.id)
        .length;
    final featureCount = posts.where((post) => post.category == '추가 요청').length;
    return _PaperCard(
      radius: 18,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Expanded(
            child: _QuietMetric(label: '전체', value: '${posts.length}'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _QuietMetric(label: '내 글', value: '$mineCount'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _QuietMetric(
              label: '추가 요청',
              value: '$featureCount',
              muted: featureCount == 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _ImprovementAddButton extends StatelessWidget {
  const _ImprovementAddButton({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: OutlinedButton.icon(
        key: improvementAddButtonKey,
        onPressed: controller.startImprovementDraft,
        icon: const Icon(Icons.add_rounded, size: 16),
        label: const Text('글 남기기'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AlagagiColors.sageDeep,
          side: const BorderSide(color: Color(0x338A9A7E)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          textStyle: sans(size: 12, weight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _ImprovementDraftCard extends StatelessWidget {
  const _ImprovementDraftCard({super.key, required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
    final isEditing = state.editingImprovementPostId != null;
    return _PaperCard(
      radius: 22,
      padding: const EdgeInsets.all(18),
      highlightedBorder: AlagagiColors.sage,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            isEditing ? '남긴 건의를\n다시 정리해요.' : '필요한 점을\n짧게 남겨요.',
            style: serif(
              context,
              size: 20,
              weight: FontWeight.w800,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              for (final category in improvementPostCategoryOptions)
                _FilterPill(
                  key: improvementCategoryKey(category),
                  label: category,
                  selected: state.improvementDraftCategory == category,
                  onTap: () =>
                      controller.updateImprovementDraft(category: category),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _StockStoryTextField(
            fieldKey: improvementTitleFieldKey,
            label: '제목',
            hint: '예: 장소 검색 결과 정렬',
            initialValue: state.improvementDraftTitle,
            maxLength: 50,
            onChanged: (value) =>
                controller.updateImprovementDraft(title: value),
          ),
          const SizedBox(height: 10),
          _StockStoryTextField(
            fieldKey: improvementBodyFieldKey,
            label: '내용',
            hint: '어떤 점이 바뀌면 좋을지 편하게 적어주세요.',
            initialValue: state.improvementDraftBody,
            maxLength: 300,
            maxLines: 4,
            onChanged: (value) =>
                controller.updateImprovementDraft(body: value),
          ),
          if (state.improvementDraftError != null) ...[
            const SizedBox(height: 10),
            Text(
              state.improvementDraftError!,
              style: sans(size: 12, color: const Color(0xFF9A5A45)),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton(
                onPressed: controller.cancelImprovementDraft,
                child: Text(
                  '취소',
                  style: sans(size: 13, color: AlagagiColors.muted),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PrimaryButton(
                  label: isEditing ? '수정 저장' : '건의 남기기',
                  onPressed: controller.submitImprovementDraft,
                  color: AlagagiColors.sageDeep,
                  buttonKey: improvementSubmitButtonKey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ImprovementPostCard extends StatelessWidget {
  const _ImprovementPostCard({required this.controller, required this.post});

  final AlagagiController controller;
  final ImprovementPost post;

  @override
  Widget build(BuildContext context) {
    final isMine = post.createdByProfileId == controller.state.me.id;
    final creator = isMine
        ? controller.state.me.nickname
        : controller.state.partner.nickname;
    return GestureDetector(
      key: improvementCardKey(post.id),
      behavior: HitTestBehavior.opaque,
      onTap: () => _showReadableDetailSheet(
        context,
        label: post.category,
        title: post.title,
        meta: '$creator · ${post.createdLabel}',
        body: post.body,
      ),
      child: _PaperCard(
        radius: 19,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isMine
                        ? const Color(0xFFEEF2EA)
                        : const Color(0xFFF1ECF6),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    _improvementCategoryIcon(post.category),
                    size: 20,
                    color: isMine
                        ? AlagagiColors.sageDeep
                        : const Color(0xFF7D6A8E),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              post.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: sans(
                                size: 14.2,
                                weight: FontWeight.w800,
                                color: const Color(0xFF33332F),
                              ),
                            ),
                          ),
                          _SmallBadge(label: post.category),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$creator · ${post.createdLabel}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: sans(size: 11.6, color: AlagagiColors.muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              post.body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: sans(
                size: 12.7,
                color: const Color(0xFF6F6C65),
                height: 1.5,
              ),
            ),
            if (isMine) ...[
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    key: improvementEditButtonKey(post.id),
                    onPressed: () => controller.startImprovementEdit(post.id),
                    icon: const Icon(Icons.edit_outlined, size: 15),
                    label: const Text('수정'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AlagagiColors.sageDeep,
                      side: const BorderSide(color: Color(0x338A9A7E)),
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      textStyle: sans(size: 12, weight: FontWeight.w800),
                    ),
                  ),
                  OutlinedButton.icon(
                    key: improvementDeleteButtonKey(post.id),
                    onPressed: () => controller.deleteImprovementPost(post.id),
                    icon: const Icon(Icons.delete_outline_rounded, size: 15),
                    label: const Text('삭제'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF9A5A45),
                      side: const BorderSide(color: Color(0x339A5A45)),
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      textStyle: sans(size: 12, weight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ImprovementSaveStatus extends StatelessWidget {
  const _ImprovementSaveStatus({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
    final message = switch (state.improvementSaveStatus) {
      SaveStatus.saving => '건의를 저장 중이에요...',
      SaveStatus.saved => state.improvementSaveFeedback,
      SaveStatus.failed => state.improvementDraftError,
      SaveStatus.idle => null,
    };
    if (message == null || message.isEmpty) {
      return const SizedBox.shrink();
    }
    final failed = state.improvementSaveStatus == SaveStatus.failed;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(
          color: failed ? const Color(0xFFFFF7F3) : const Color(0xFFF7F8F3),
          border: Border.all(
            color: failed ? const Color(0x33B18472) : const Color(0x338A9A7E),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(
              failed
                  ? Icons.error_outline_rounded
                  : state.improvementSaveStatus == SaveStatus.saving
                  ? Icons.sync_rounded
                  : Icons.check_circle_outline_rounded,
              size: 16,
              color: failed ? const Color(0xFFB18472) : AlagagiColors.sageDeep,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: sans(
                  size: 12,
                  color: failed
                      ? const Color(0xFF9A5A45)
                      : AlagagiColors.sageDeep,
                  height: 1.4,
                ),
              ),
            ),
            if (failed)
              TextButton(
                key: improvementRetryButtonKey,
                onPressed: controller.retryImprovementSave,
                child: Text(
                  '다시 시도',
                  style: sans(
                    size: 12,
                    weight: FontWeight.w800,
                    color: const Color(0xFF9A5A45),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

IconData _improvementCategoryIcon(String category) {
  return switch (category) {
    '추가 요청' => Icons.add_task_outlined,
    '불편함' => Icons.report_problem_outlined,
    '아이디어' => Icons.lightbulb_outline_rounded,
    _ => Icons.tune_rounded,
  };
}

class StockStoryScreen extends StatelessWidget {
  const StockStoryScreen({super.key, required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final activeTab = controller.state.stockStoryTab;
    return _ScreenScroll(
      bottomNavigation: _BottomNav(controller: controller),
      children: [
        _TopBar(
          title: '주식 이야기',
          trailing: '',
          onBack: () => controller.goTo(AlagagiRoute.home),
        ),
        const SizedBox(height: 4),
        Text(
          '관심 종목과 걱정 포인트를 조심히 나눠요',
          style: sans(size: 12.5, color: AlagagiColors.muted),
        ),
        const SizedBox(height: 16),
        const _StockStoryHeroCard(),
        const SizedBox(height: 14),
        _StockStoryTabs(controller: controller),
        const SizedBox(height: 16),
        if (activeTab == StockStoryTab.stories)
          _StockStoriesPane(controller: controller)
        else
          _StockHoldingsPane(controller: controller),
      ],
    );
  }
}

class _StockStoryTabs extends StatelessWidget {
  const _StockStoryTabs({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final activeTab = controller.state.stockStoryTab;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFCFCFA),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          Expanded(
            child: _StockStoryTabButton(
              buttonKey: stockStoryTabStoriesKey,
              label: '이야기',
              selected: activeTab == StockStoryTab.stories,
              onTap: () => controller.setStockStoryTab(StockStoryTab.stories),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: _StockStoryTabButton(
              buttonKey: stockStoryTabHoldingsKey,
              label: '보유',
              selected: activeTab == StockStoryTab.holdings,
              onTap: () => controller.setStockStoryTab(StockStoryTab.holdings),
            ),
          ),
        ],
      ),
    );
  }
}

class _StockStoryTabButton extends StatelessWidget {
  const _StockStoryTabButton({
    required this.buttonKey,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final Key buttonKey;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AlagagiColors.sageDeep : Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        key: buttonKey,
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: SizedBox(
          height: 38,
          child: Center(
            child: Text(
              label,
              style: sans(
                size: 12.5,
                weight: FontWeight.w800,
                color: selected ? Colors.white : AlagagiColors.muted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StockStoriesPane extends StatelessWidget {
  const _StockStoriesPane({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final stories = controller.visibleStockStories;
    final totalCount = controller.stockStories.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (controller.state.stockStoryDraftVisible) ...[
          _StockStoryDraftCard(controller: controller),
          const SizedBox(height: 18),
        ],
        Row(
          children: [
            const Expanded(child: _SectionLabel('같이 볼 이야기')),
            if (!controller.state.stockStoryDraftVisible)
              _StockStoryAddButton(controller: controller),
          ],
        ),
        if (totalCount > 0) ...[
          const SizedBox(height: 12),
          _StockStorySummaryCard(controller: controller),
          const SizedBox(height: 10),
          _StockStoryFilterBar(controller: controller),
        ],
        const SizedBox(height: 12),
        if (totalCount == 0)
          const _EmptyStateCard(text: '관심 가는 종목을 하나만 가볍게 남겨볼까요?')
        else if (stories.isEmpty)
          const _EmptyStateCard(text: '이 조건에 맞는 이야기는 아직 없어요.')
        else
          for (final story in stories) ...[
            _StockStoryCard(controller: controller, story: story),
            const SizedBox(height: 12),
          ],
      ],
    );
  }
}

class _StockStorySummaryCard extends StatelessWidget {
  const _StockStorySummaryCard({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final stories = controller.stockStories;
    final replyNeededCount = stories
        .where(
          (story) =>
              story.createdByProfileId == controller.state.partner.id &&
              !story.hasReply,
        )
        .length;
    final repliedCount = stories.where((story) => story.hasReply).length;
    return _PaperCard(
      radius: 18,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Expanded(
            child: _QuietMetric(label: '전체 이야기', value: '${stories.length}'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _QuietMetric(
              label: '답장 필요',
              value: '$replyNeededCount',
              muted: replyNeededCount == 0,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _QuietMetric(
              label: '답장 있음',
              value: '$repliedCount',
              muted: repliedCount == 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _StockStoryFilterBar extends StatelessWidget {
  const _StockStoryFilterBar({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final selected = controller.state.stockStoryListFilter;
    final filters = [
      (StockStoryListFilter.all, '전체'),
      (StockStoryListFilter.mine, '내가 남김'),
      (StockStoryListFilter.partner, '상대가 남김'),
      (StockStoryListFilter.needsReply, '답장 필요'),
      (StockStoryListFilter.replied, '답장 있음'),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final filter in filters) ...[
            _FilterPill(
              key: stockStoryListFilterButtonKey(filter.$1.name),
              label: filter.$2,
              selected: selected == filter.$1,
              onTap: () => controller.setStockStoryListFilter(filter.$1),
            ),
            if (filter != filters.last) const SizedBox(width: 7),
          ],
        ],
      ),
    );
  }
}

class _StockStoryHeroCard extends StatelessWidget {
  const _StockStoryHeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2F2F2B),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '관점 노트',
            style: sans(
              size: 10.5,
              weight: FontWeight.w800,
              color: const Color(0xFFC9C9C2),
              letterSpacing: 1.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '신호보다,\n서로의 생각을 남겨요.',
            style: serif(
              context,
              size: 22,
              weight: FontWeight.w800,
              color: Colors.white,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            '좋아 보이는 점과 조심할 점을 같이 적어두면 판단이 조금 더 차분해져요.',
            style: sans(
              size: 12.5,
              color: const Color(0xFFD8D8D1),
              height: 1.58,
            ),
          ),
        ],
      ),
    );
  }
}

class _StockStoryAddButton extends StatelessWidget {
  const _StockStoryAddButton({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: OutlinedButton.icon(
        key: stockStoryAddButtonKey,
        onPressed: controller.startStockStoryDraft,
        icon: const Icon(Icons.add_rounded, size: 16),
        label: const Text('이야기 남기기'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AlagagiColors.sageDeep,
          side: const BorderSide(color: Color(0x338A9A7E)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          textStyle: sans(size: 12, weight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _StockStoryDraftCard extends StatelessWidget {
  const _StockStoryDraftCard({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return _PaperCard(
      radius: 22,
      padding: const EdgeInsets.all(18),
      highlightedBorder: AlagagiColors.sage,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '같이 살펴볼 이야기를\n가볍게 남겨요.',
            style: serif(
              context,
              size: 20,
              weight: FontWeight.w800,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            '결론보다 이유와 걱정을 함께 남기면 충분해요.',
            style: sans(size: 12.5, color: AlagagiColors.muted, height: 1.6),
          ),
          const SizedBox(height: 16),
          _StockStoryTextField(
            fieldKey: stockStoryNameFieldKey,
            label: '종목명',
            hint: '예: 삼성전자, Apple',
            initialValue: controller.state.stockStoryDraftName,
            maxLength: 40,
            onChanged: (value) => controller.updateStockStoryDraft(name: value),
          ),
          const SizedBox(height: 10),
          _StockStoryTextField(
            fieldKey: stockStoryReasonFieldKey,
            label: '관심 이유',
            hint: '왜 같이 보고 싶은지',
            initialValue: controller.state.stockStoryDraftReason,
            maxLength: 120,
            maxLines: 2,
            onChanged: (value) =>
                controller.updateStockStoryDraft(reason: value),
          ),
          const SizedBox(height: 10),
          _StockStoryTextField(
            fieldKey: stockStoryUpsideFieldKey,
            label: '기대 포인트',
            hint: '좋아 보이는 점',
            initialValue: controller.state.stockStoryDraftUpside,
            maxLength: 80,
            onChanged: (value) =>
                controller.updateStockStoryDraft(upside: value),
          ),
          const SizedBox(height: 10),
          _StockStoryTextField(
            fieldKey: stockStoryRiskFieldKey,
            label: '걱정 포인트',
            hint: '조심해서 볼 점',
            initialValue: controller.state.stockStoryDraftRisk,
            maxLength: 80,
            onChanged: (value) => controller.updateStockStoryDraft(risk: value),
          ),
          const SizedBox(height: 10),
          _StockStoryTextField(
            fieldKey: stockStoryQuestionFieldKey,
            label: '궁금한 점',
            hint: '상대에게 묻고 싶은 것',
            initialValue: controller.state.stockStoryDraftQuestion,
            maxLength: 100,
            maxLines: 2,
            onChanged: (value) =>
                controller.updateStockStoryDraft(question: value),
          ),
          if (controller.state.stockStoryDraftError != null) ...[
            const SizedBox(height: 10),
            Text(
              controller.state.stockStoryDraftError!,
              style: sans(size: 12, color: AlagagiColors.sageDeep),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton(
                onPressed: controller.cancelStockStoryDraft,
                child: Text(
                  '취소',
                  style: sans(size: 13, color: AlagagiColors.muted),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PrimaryButton(
                  label: '이야기 남기기',
                  onPressed: controller.submitStockStoryDraft,
                  color: AlagagiColors.sageDeep,
                  buttonKey: stockStorySubmitButtonKey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StockStoryTextField extends StatelessWidget {
  const _StockStoryTextField({
    required this.fieldKey,
    required this.label,
    required this.hint,
    required this.initialValue,
    required this.maxLength,
    required this.onChanged,
    this.maxLines = 1,
  });

  final Key fieldKey;
  final String label;
  final String hint;
  final String initialValue;
  final int maxLength;
  final ValueChanged<String> onChanged;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F4),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.fromLTRB(14, 7, 14, 7),
      child: TextFormField(
        key: fieldKey,
        initialValue: initialValue,
        maxLength: maxLength,
        minLines: maxLines,
        maxLines: maxLines,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          counterText: '',
          border: InputBorder.none,
        ),
        style: sans(size: 13.5, height: 1.5),
      ),
    );
  }
}

class _StockStoryCard extends StatelessWidget {
  const _StockStoryCard({required this.controller, required this.story});

  final AlagagiController controller;
  final StockStory story;

  @override
  Widget build(BuildContext context) {
    final isMine = story.createdByProfileId == controller.state.me.id;
    final creator = isMine
        ? controller.state.me.nickname
        : controller.state.partner.nickname;
    final detailBody = [
      '관심 이유\n${story.reason}',
      '기대 포인트\n${story.upside}',
      '걱정 포인트\n${story.risk}',
      '궁금한 점\n${story.question}',
      if (story.hasReply) '${story.replyTone ?? '답장'}\n${story.reply!.trim()}',
    ].join('\n\n');
    return GestureDetector(
      key: stockStoryCardKey(story.id),
      behavior: HitTestBehavior.opaque,
      onTap: () => _showReadableDetailSheet(
        context,
        label: '주식 이야기',
        title: story.name,
        meta: '$creator · ${story.createdLabel}',
        body: detailBody,
      ),
      child: _PaperCard(
        radius: 19,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StockStoryMark(name: story.name, isMine: isMine),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              story.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: sans(
                                size: 14.2,
                                weight: FontWeight.w800,
                                color: const Color(0xFF33332F),
                              ),
                            ),
                          ),
                          _SmallBadge(
                            label: story.hasReply ? '답장 있음' : '기다리는 중',
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        creator,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: sans(size: 11.6, color: AlagagiColors.muted),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        story.reason,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: sans(
                          size: 12.3,
                          color: const Color(0xFF6F6C65),
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StockStoryMiniBox(label: '기대', body: story.upside),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StockStoryMiniBox(label: '걱정', body: story.risk),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _StockStoryQuestion(text: story.question),
            if (story.hasReply) ...[
              const SizedBox(height: 10),
              _StockStoryReplyBlock(story: story),
            ] else if (!isMine) ...[
              const SizedBox(height: 12),
              _StockStoryReplyComposer(controller: controller, story: story),
            ],
            if (controller.state.stockStoryReplyError != null && !isMine) ...[
              const SizedBox(height: 8),
              Text(
                controller.state.stockStoryReplyError!,
                style: sans(size: 12, color: AlagagiColors.sageDeep),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StockStoryMark extends StatelessWidget {
  const _StockStoryMark({required this.name, required this.isMine});

  final String name;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: isMine ? AlagagiColors.softSage : const Color(0xFFF5EFEA),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Text(
        name.characters.first.toUpperCase(),
        style: sans(
          size: 15,
          weight: FontWeight.w900,
          color: isMine ? AlagagiColors.sageDeep : const Color(0xFFB18472),
        ),
      ),
    );
  }
}

class _StockStoryMiniBox extends StatelessWidget {
  const _StockStoryMiniBox({required this.label, required this.body});

  final String label;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 70),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F4),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: sans(
              size: 10.5,
              weight: FontWeight.w800,
              color: AlagagiColors.sageDeep,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: sans(size: 11.5, color: AlagagiColors.ink, height: 1.38),
          ),
        ],
      ),
    );
  }
}

class _StockStoryQuestion extends StatelessWidget {
  const _StockStoryQuestion({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AlagagiColors.ink,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '궁금한 점',
            style: sans(
              size: 10.5,
              weight: FontWeight.w800,
              color: const Color(0xFFC9C9C2),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            text,
            style: sans(size: 12.3, color: Colors.white, height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _StockStoryReplyBlock extends StatelessWidget {
  const _StockStoryReplyBlock({required this.story});

  final StockStory story;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2EA),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            story.replyTone ?? '답장',
            style: sans(
              size: 10.5,
              weight: FontWeight.w800,
              color: AlagagiColors.sageDeep,
            ),
          ),
          const SizedBox(height: 5),
          Text(story.reply ?? '', style: sans(size: 12.5, height: 1.5)),
        ],
      ),
    );
  }
}

class _StockStoryReplyComposer extends StatelessWidget {
  const _StockStoryReplyComposer({
    required this.controller,
    required this.story,
  });

  final AlagagiController controller;
  final StockStory story;

  @override
  Widget build(BuildContext context) {
    final selectedTone = controller.stockStoryReplyToneFor(story.id);
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEFA),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(17),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '내 관점 남기기',
            style: sans(
              size: 11.5,
              weight: FontWeight.w800,
              color: AlagagiColors.sageDeep,
            ),
          ),
          const SizedBox(height: 9),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              for (final tone in stockStoryReplyToneOptions)
                _FilterPill(
                  key: stockStoryReplyToneKey(story.id, tone),
                  label: tone,
                  selected: selectedTone == tone,
                  onTap: () =>
                      controller.setStockStoryReplyTone(story.id, tone),
                ),
            ],
          ),
          const SizedBox(height: 9),
          TextField(
            key: stockStoryReplyFieldKey(story.id),
            minLines: 2,
            maxLines: 3,
            maxLength: 160,
            onChanged: (value) => controller.updateStockStoryReplyDraft(
              storyId: story.id,
              value: value,
            ),
            decoration: InputDecoration(
              hintText: '숫자 하나나 확인할 점만 남겨도 괜찮아요.',
              hintStyle: sans(size: 12.2, color: AlagagiColors.muted),
              counterText: '',
              filled: true,
              fillColor: const Color(0xFFF8F8F4),
              contentPadding: const EdgeInsets.all(12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AlagagiColors.line),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AlagagiColors.sageDeep),
              ),
            ),
            style: sans(size: 13, height: 1.45),
          ),
          const SizedBox(height: 9),
          _PrimaryButton(
            label: '관점 남기기',
            buttonKey: stockStoryReplySubmitButtonKey(story.id),
            onPressed: () => controller.submitStockStoryReply(story.id),
            color: AlagagiColors.sageDeep,
          ),
        ],
      ),
    );
  }
}

class _StockHoldingsPane extends StatelessWidget {
  const _StockHoldingsPane({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final holdings = controller.visibleStockHoldings;
    final allHoldings = controller.stockHoldings;
    final mineCount = allHoldings
        .where(
          (holding) => holding.createdByProfileId == controller.state.me.id,
        )
        .length;
    final partnerCount = allHoldings.length - mineCount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (controller.state.stockHoldingDraftVisible) ...[
          _StockHoldingDraftCard(controller: controller),
          const SizedBox(height: 18),
        ],
        Row(
          children: [
            const Expanded(child: _SectionLabel('공유한 보유 종목')),
            if (!controller.state.stockHoldingDraftVisible)
              _StockHoldingAddButton(controller: controller),
          ],
        ),
        const SizedBox(height: 12),
        _StockHoldingSummaryCard(
          controller: controller,
          mineCount: mineCount,
          partnerCount: partnerCount,
        ),
        if (allHoldings.isNotEmpty) ...[
          const SizedBox(height: 10),
          _StockHoldingFilterBar(controller: controller),
        ],
        const SizedBox(height: 12),
        if (allHoldings.isEmpty)
          const _EmptyStateCard(text: '들고 있는 종목을 부담 없이 하나만 공유해볼까요?')
        else if (holdings.isEmpty)
          const _EmptyStateCard(text: '이 조건에 맞는 보유 종목은 아직 없어요.')
        else
          for (final holding in holdings) ...[
            _StockHoldingCard(controller: controller, holding: holding),
            const SizedBox(height: 12),
          ],
      ],
    );
  }
}

class _StockHoldingSummaryCard extends StatelessWidget {
  const _StockHoldingSummaryCard({
    required this.controller,
    required this.mineCount,
    required this.partnerCount,
  });

  final AlagagiController controller;
  final int mineCount;
  final int partnerCount;

  @override
  Widget build(BuildContext context) {
    final replyNeededCount = controller.stockHoldings
        .where(
          (holding) =>
              holding.createdByProfileId == controller.state.partner.id &&
              !holding.hasReply,
        )
        .length;
    return _PaperCard(
      radius: 18,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Expanded(
            child: _QuietMetric(label: '내 종목', value: '$mineCount'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _QuietMetric(label: '상대 종목', value: '$partnerCount'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _QuietMetric(
              label: '답장 필요',
              value: '$replyNeededCount',
              muted: replyNeededCount == 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _StockHoldingFilterBar extends StatelessWidget {
  const _StockHoldingFilterBar({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final selected = controller.state.stockHoldingListFilter;
    final filters = [
      (StockHoldingListFilter.all, '전체'),
      (StockHoldingListFilter.mine, '내 종목'),
      (StockHoldingListFilter.partner, '상대 종목'),
      (StockHoldingListFilter.needsReply, '답장 필요'),
      (StockHoldingListFilter.shared, '함께 보유'),
      (StockHoldingListFilter.holding, '보유 중'),
      (StockHoldingListFilter.considering, '정리 고민'),
      (StockHoldingListFilter.closed, '최근 정리'),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final filter in filters) ...[
            _FilterPill(
              key: stockHoldingListFilterButtonKey(filter.$1.name),
              label: filter.$2,
              selected: selected == filter.$1,
              onTap: () => controller.setStockHoldingListFilter(filter.$1),
            ),
            if (filter != filters.last) const SizedBox(width: 7),
          ],
        ],
      ),
    );
  }
}

class _StockHoldingAddButton extends StatelessWidget {
  const _StockHoldingAddButton({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: OutlinedButton.icon(
        key: stockHoldingAddButtonKey,
        onPressed: controller.startStockHoldingDraft,
        icon: const Icon(Icons.add_rounded, size: 16),
        label: const Text('보유 공유'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AlagagiColors.sageDeep,
          side: const BorderSide(color: Color(0x338A9A7E)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          textStyle: sans(size: 12, weight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _StockHoldingDraftCard extends StatelessWidget {
  const _StockHoldingDraftCard({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
    final isEditing = state.editingStockHoldingId != null;
    return _PaperCard(
      radius: 22,
      padding: const EdgeInsets.all(18),
      highlightedBorder: AlagagiColors.sage,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            isEditing ? '보유 종목을\n다시 정리해요.' : '들고 있는 이유를\n숫자보다 먼저 나눠요.',
            style: serif(
              context,
              size: 20,
              weight: FontWeight.w800,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            isEditing
                ? '처음 남긴 답장과 기록은 유지하고, 내가 적은 내용만 고칠 수 있어요.'
                : '수량이나 금액 없이도 보유 상태와 지켜볼 점만 공유할 수 있어요.',
            style: sans(size: 12.5, color: AlagagiColors.muted, height: 1.6),
          ),
          const SizedBox(height: 16),
          _StockStoryTextField(
            fieldKey: stockHoldingNameFieldKey,
            label: '종목명',
            hint: '예: 삼성전자, Apple',
            initialValue: state.stockHoldingDraftName,
            maxLength: 40,
            onChanged: (value) =>
                controller.updateStockHoldingDraft(name: value),
          ),
          const SizedBox(height: 12),
          _StockHoldingChoiceGroup(
            label: '보유 상태',
            options: stockHoldingStatusOptions,
            selected: state.stockHoldingDraftStatus,
            keyBuilder: stockHoldingStatusKey,
            onSelected: (value) =>
                controller.updateStockHoldingDraft(status: value),
          ),
          const SizedBox(height: 12),
          _StockHoldingChoiceGroup(
            label: '비중 느낌',
            options: stockHoldingWeightOptions,
            selected: state.stockHoldingDraftWeightLabel,
            keyBuilder: stockHoldingWeightKey,
            onSelected: (value) =>
                controller.updateStockHoldingDraft(weightLabel: value),
          ),
          const SizedBox(height: 10),
          _StockStoryTextField(
            fieldKey: stockHoldingReasonFieldKey,
            label: '보유 이유',
            hint: '왜 들고 있는지',
            initialValue: state.stockHoldingDraftReason,
            maxLength: 120,
            maxLines: 2,
            onChanged: (value) =>
                controller.updateStockHoldingDraft(reason: value),
          ),
          const SizedBox(height: 10),
          _StockStoryTextField(
            fieldKey: stockHoldingWatchFieldKey,
            label: '보고 싶은 점',
            hint: '앞으로 확인할 지점',
            initialValue: state.stockHoldingDraftWatchPoint,
            maxLength: 80,
            onChanged: (value) =>
                controller.updateStockHoldingDraft(watchPoint: value),
          ),
          const SizedBox(height: 10),
          _StockStoryTextField(
            fieldKey: stockHoldingConcernFieldKey,
            label: '걱정 포인트',
            hint: '조심해서 볼 점',
            initialValue: state.stockHoldingDraftConcern,
            maxLength: 80,
            onChanged: (value) =>
                controller.updateStockHoldingDraft(concern: value),
          ),
          const SizedBox(height: 10),
          _StockStoryTextField(
            fieldKey: stockHoldingQuestionFieldKey,
            label: '물어보고 싶은 점',
            hint: '상대에게 묻고 싶은 것',
            initialValue: state.stockHoldingDraftQuestion,
            maxLength: 100,
            maxLines: 2,
            onChanged: (value) =>
                controller.updateStockHoldingDraft(question: value),
          ),
          if (state.stockHoldingDraftError != null) ...[
            const SizedBox(height: 10),
            Text(
              state.stockHoldingDraftError!,
              style: sans(size: 12, color: AlagagiColors.sageDeep),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton(
                onPressed: controller.cancelStockHoldingDraft,
                child: Text(
                  '취소',
                  style: sans(size: 13, color: AlagagiColors.muted),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PrimaryButton(
                  label: isEditing ? '수정 저장' : '보유 공유하기',
                  onPressed: controller.submitStockHoldingDraft,
                  color: AlagagiColors.sageDeep,
                  buttonKey: stockHoldingSubmitButtonKey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StockHoldingChoiceGroup extends StatelessWidget {
  const _StockHoldingChoiceGroup({
    required this.label,
    required this.options,
    required this.selected,
    required this.keyBuilder,
    required this.onSelected,
  });

  final String label;
  final List<String> options;
  final String selected;
  final Key Function(String value) keyBuilder;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: sans(
            size: 10.5,
            weight: FontWeight.w800,
            color: AlagagiColors.sageDeep,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: [
            for (final option in options)
              _FilterPill(
                key: keyBuilder(option),
                label: option,
                selected: selected == option,
                onTap: () => onSelected(option),
              ),
          ],
        ),
      ],
    );
  }
}

class _StockHoldingCard extends StatelessWidget {
  const _StockHoldingCard({required this.controller, required this.holding});

  final AlagagiController controller;
  final StockHolding holding;

  @override
  Widget build(BuildContext context) {
    final isMine = holding.createdByProfileId == controller.state.me.id;
    final creator = isMine
        ? controller.state.me.nickname
        : controller.state.partner.nickname;
    final isShared = controller.stockHoldingSharedByBoth(holding.name);
    final detailBody = [
      '보유 이유\n${holding.reason}',
      '보고 싶은 점\n${holding.watchPoint}',
      '걱정 포인트\n${holding.concern}',
      '물어보고 싶은 점\n${holding.question}',
      if (holding.hasReply)
        '${holding.replyTone ?? '답장'}\n${holding.reply!.trim()}',
    ].join('\n\n');
    return GestureDetector(
      key: stockHoldingCardKey(holding.id),
      behavior: HitTestBehavior.opaque,
      onTap: () => _showReadableDetailSheet(
        context,
        label: '보유 주식',
        title: holding.name,
        meta: '$creator · ${holding.status} · ${holding.weightLabel}',
        body: detailBody,
      ),
      child: _PaperCard(
        radius: 19,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StockStoryMark(name: holding.name, isMine: isMine),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              holding.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: sans(
                                size: 14.2,
                                weight: FontWeight.w800,
                                color: const Color(0xFF33332F),
                              ),
                            ),
                          ),
                          if (isShared)
                            const _SmallBadge(label: '함께 보유 중')
                          else
                            _SmallBadge(label: holding.status),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$creator · ${holding.weightLabel}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: sans(size: 11.6, color: AlagagiColors.muted),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        holding.reason,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: sans(
                          size: 12.3,
                          color: const Color(0xFF6F6C65),
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StockStoryMiniBox(
                    label: '볼 점',
                    body: holding.watchPoint,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StockStoryMiniBox(label: '걱정', body: holding.concern),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _StockStoryQuestion(text: holding.question),
            if (holding.hasReply) ...[
              const SizedBox(height: 10),
              _StockHoldingReplyBlock(holding: holding),
            ] else if (!isMine) ...[
              const SizedBox(height: 12),
              _StockHoldingReplyComposer(
                controller: controller,
                holding: holding,
              ),
            ],
            if (controller.state.stockHoldingReplyError != null && !isMine) ...[
              const SizedBox(height: 8),
              Text(
                controller.state.stockHoldingReplyError!,
                style: sans(size: 12, color: AlagagiColors.sageDeep),
              ),
            ],
            if (isMine) ...[
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    key: stockHoldingEditButtonKey(holding.id),
                    onPressed: () =>
                        controller.startStockHoldingEdit(holding.id),
                    icon: const Icon(Icons.edit_outlined, size: 15),
                    label: const Text('수정'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AlagagiColors.sageDeep,
                      side: const BorderSide(color: Color(0x338A9A7E)),
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      textStyle: sans(size: 12, weight: FontWeight.w800),
                    ),
                  ),
                  OutlinedButton.icon(
                    key: stockHoldingDeleteButtonKey(holding.id),
                    onPressed: () => controller.deleteStockHolding(holding.id),
                    icon: const Icon(Icons.delete_outline_rounded, size: 15),
                    label: const Text('삭제'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF9A5A45),
                      side: const BorderSide(color: Color(0x339A5A45)),
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      textStyle: sans(size: 12, weight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StockHoldingReplyBlock extends StatelessWidget {
  const _StockHoldingReplyBlock({required this.holding});

  final StockHolding holding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2EA),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            holding.replyTone ?? '답장',
            style: sans(
              size: 10.5,
              weight: FontWeight.w800,
              color: AlagagiColors.sageDeep,
            ),
          ),
          const SizedBox(height: 5),
          Text(holding.reply ?? '', style: sans(size: 12.5, height: 1.5)),
        ],
      ),
    );
  }
}

class _StockHoldingReplyComposer extends StatelessWidget {
  const _StockHoldingReplyComposer({
    required this.controller,
    required this.holding,
  });

  final AlagagiController controller;
  final StockHolding holding;

  @override
  Widget build(BuildContext context) {
    final selectedTone = controller.stockHoldingReplyToneFor(holding.id);
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEFA),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(17),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '내 관점 남기기',
            style: sans(
              size: 11.5,
              weight: FontWeight.w800,
              color: AlagagiColors.sageDeep,
            ),
          ),
          const SizedBox(height: 9),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              for (final tone in stockStoryReplyToneOptions)
                _FilterPill(
                  key: stockHoldingReplyToneKey(holding.id, tone),
                  label: tone,
                  selected: selectedTone == tone,
                  onTap: () =>
                      controller.setStockHoldingReplyTone(holding.id, tone),
                ),
            ],
          ),
          const SizedBox(height: 9),
          TextField(
            key: stockHoldingReplyFieldKey(holding.id),
            minLines: 2,
            maxLines: 3,
            maxLength: 160,
            onChanged: (value) => controller.updateStockHoldingReplyDraft(
              holdingId: holding.id,
              value: value,
            ),
            decoration: InputDecoration(
              hintText: '같이 볼 숫자나 걱정되는 점만 남겨도 괜찮아요.',
              hintStyle: sans(size: 12.2, color: AlagagiColors.muted),
              counterText: '',
              filled: true,
              fillColor: const Color(0xFFF8F8F4),
              contentPadding: const EdgeInsets.all(12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AlagagiColors.line),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AlagagiColors.sageDeep),
              ),
            ),
            style: sans(size: 13, height: 1.45),
          ),
          const SizedBox(height: 9),
          _PrimaryButton(
            label: '관점 남기기',
            buttonKey: stockHoldingReplySubmitButtonKey(holding.id),
            onPressed: () => controller.submitStockHoldingReply(holding.id),
            color: AlagagiColors.sageDeep,
          ),
        ],
      ),
    );
  }
}

class MusicScreen extends StatelessWidget {
  const MusicScreen({
    super.key,
    required this.controller,
    required this.onOpenExternalLink,
  });

  final AlagagiController controller;
  final ValueChanged<String> onOpenExternalLink;

  @override
  Widget build(BuildContext context) {
    final notes = controller.visibleMusicNotes;
    final totalCount = controller.musicNotes.length;
    return _ScreenScroll(
      bottomNavigation: _BottomNav(controller: controller),
      children: [
        Text('음악 노트', style: serif(context, size: 23, weight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(
          '각자의 요즘을 한 곡씩 조용히 남겨요',
          style: sans(size: 12.5, color: AlagagiColors.muted),
        ),
        const SizedBox(height: 18),
        const _MusicHeroCard(),
        if (controller.state.musicDraftVisible) ...[
          const SizedBox(height: 16),
          _MusicDraftCard(
            key: ValueKey(
              controller.state.editingMusicNoteId ?? 'new-music-note',
            ),
            controller: controller,
          ),
        ],
        const SizedBox(height: 18),
        Row(
          children: [
            const Expanded(child: _SectionLabel('들어볼 곡')),
            if (!controller.state.musicDraftVisible)
              _MusicAddInlineButton(controller: controller),
          ],
        ),
        if (totalCount > 0) ...[
          const SizedBox(height: 12),
          _MusicLibrarySummaryCard(controller: controller),
          const SizedBox(height: 10),
          _MusicFilterBar(controller: controller),
        ],
        const SizedBox(height: 12),
        if (totalCount == 0)
          const _EmptyStateCard(text: '요즘 듣는 노래를 한 곡만 가볍게 남겨볼까요?')
        else if (notes.isEmpty)
          const _EmptyStateCard(text: '이 조건에 맞는 곡은 아직 없어요.')
        else
          for (final note in notes) ...[
            _MusicNoteCard(
              controller: controller,
              note: note,
              onOpenExternalLink: onOpenExternalLink,
            ),
            const SizedBox(height: 12),
          ],
      ],
    );
  }
}

class _MusicLibrarySummaryCard extends StatelessWidget {
  const _MusicLibrarySummaryCard({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final totalCount = controller.musicNotes.length;
    final unlistenedCount = controller.unlistenedMusicNoteCount;
    final mutualCount = controller.mutualListenedMusicNoteCount;
    return _PaperCard(
      radius: 18,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Expanded(
            child: _QuietMetric(
              label: '아직 들을 곡',
              value: '$unlistenedCount',
              muted: unlistenedCount == 0,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _QuietMetric(label: '전체 노트', value: '$totalCount'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _QuietMetric(
              label: '둘 다 들음',
              value: '$mutualCount',
              muted: mutualCount == 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _MusicFilterBar extends StatelessWidget {
  const _MusicFilterBar({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final selected = controller.state.musicListFilter;
    final filters = [
      (MusicListFilter.all, '전체'),
      (MusicListFilter.unlistened, '아직'),
      (MusicListFilter.listened, '들었어요'),
      (MusicListFilter.mine, '내가 남김'),
      (MusicListFilter.partner, '상대가 남김'),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final filter in filters) ...[
            _FilterPill(
              key: musicListFilterButtonKey(filter.$1.name),
              label: filter.$2,
              selected: selected == filter.$1,
              onTap: () => controller.setMusicListFilter(filter.$1),
            ),
            if (filter != filters.last) const SizedBox(width: 7),
          ],
        ],
      ),
    );
  }
}

class _QuietMetric extends StatelessWidget {
  const _QuietMetric({
    required this.label,
    required this.value,
    this.muted = false,
  });

  final String label;
  final String value;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: muted ? const Color(0xFFF8F8F4) : const Color(0xFFF1F4EC),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: sans(size: 10.5, color: AlagagiColors.muted)),
          const SizedBox(height: 4),
          Text(
            value,
            style: serif(
              context,
              size: 19,
              weight: FontWeight.w800,
              color: muted ? AlagagiColors.muted : AlagagiColors.sageDeep,
            ),
          ),
        ],
      ),
    );
  }
}

class _MusicAddInlineButton extends StatelessWidget {
  const _MusicAddInlineButton({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: OutlinedButton.icon(
        key: musicAddButtonKey,
        onPressed: controller.startMusicDraft,
        icon: const Icon(Icons.add_rounded, size: 16),
        label: const Text('한 곡 남기기'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AlagagiColors.sageDeep,
          side: const BorderSide(color: Color(0x338A9A7E)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          textStyle: sans(size: 12, weight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _MusicHeroCard extends StatelessWidget {
  const _MusicHeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2F2F2B),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MUSIC NOTE',
            style: sans(
              size: 10.5,
              weight: FontWeight.w700,
              color: const Color(0xFFC9C9C2),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '각자의 요즘을\n노래로 조금씩 남겨요.',
            style: serif(
              context,
              size: 22,
              weight: FontWeight.w800,
              color: Colors.white,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            '많이 설명하지 않아도, 한 곡이면 분위기가 전해질 때가 있어요.',
            style: sans(
              size: 12.5,
              color: const Color(0xFFD8D8D1),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: const [
              _MusicCover(color: AlagagiColors.sage, darkBorder: true),
              _OverlapCover(color: AlagagiColors.lavender),
              _OverlapCover(color: Color(0xFFB18472)),
              _OverlapCover(color: Color(0xFFC8AD6D)),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverlapCover extends StatelessWidget {
  const _OverlapCover({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(-10, 0),
      child: _MusicCover(color: color, darkBorder: true),
    );
  }
}

class _MusicDraftCard extends StatelessWidget {
  const _MusicDraftCard({super.key, required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.state.editingMusicNoteId != null;
    return _PaperCard(
      radius: 22,
      padding: const EdgeInsets.all(18),
      highlightedBorder: AlagagiColors.sage,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            isEditing ? '음악 노트 다듬기' : '요즘의 한 곡을\n가볍게 건네요.',
            style: serif(
              context,
              size: 20,
              weight: FontWeight.w800,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            isEditing
                ? '처음 남긴 분위기는 유지하면서 필요한 부분만 고쳐요.'
                : '정성스러운 소개보다, 떠오른 이유 한 줄이면 충분해요.',
            style: sans(size: 12.5, color: AlagagiColors.muted, height: 1.6),
          ),
          const SizedBox(height: 16),
          _MusicTextField(
            fieldKey: musicTitleFieldKey,
            label: '곡 제목',
            hint: '예: 밤 산책',
            initialValue: controller.state.musicDraftTitle,
            maxLength: 60,
            onChanged: (value) => controller.updateMusicDraft(title: value),
          ),
          const SizedBox(height: 10),
          _MusicTextField(
            fieldKey: musicArtistFieldKey,
            label: '아티스트',
            hint: '아티스트 이름',
            initialValue: controller.state.musicDraftArtist,
            maxLength: 60,
            onChanged: (value) => controller.updateMusicDraft(artist: value),
          ),
          const SizedBox(height: 10),
          _MusicTextField(
            fieldKey: musicLinkFieldKey,
            label: '링크',
            hint: 'https://...',
            initialValue: controller.state.musicDraftLink,
            maxLength: 180,
            onChanged: (value) => controller.updateMusicDraft(link: value),
          ),
          const SizedBox(height: 10),
          _MusicTextField(
            fieldKey: musicNoteFieldKey,
            label: '짧은 메모',
            hint: '왜 건네고 싶은 곡인지 한 줄로',
            initialValue: controller.state.musicDraftNote,
            maxLength: 80,
            minLines: 2,
            maxLines: 3,
            onChanged: (value) => controller.updateMusicDraft(note: value),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final mood in musicMoodOptions)
                _FilterPill(
                  label: mood,
                  selected: controller.state.musicDraftMood == mood,
                  onTap: () => controller.setMusicDraftMood(mood),
                ),
            ],
          ),
          if (controller.state.musicDraftError != null) ...[
            const SizedBox(height: 10),
            Text(
              controller.state.musicDraftError!,
              style: sans(size: 12, color: AlagagiColors.sageDeep),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton(
                onPressed: controller.cancelMusicDraft,
                child: Text(
                  '취소',
                  style: sans(size: 13, color: AlagagiColors.muted),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PrimaryButton(
                  label: isEditing ? '수정 저장' : '노래 남기기',
                  onPressed: controller.submitMusicDraft,
                  color: AlagagiColors.sageDeep,
                  buttonKey: musicSubmitButtonKey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MusicTextField extends StatelessWidget {
  const _MusicTextField({
    required this.fieldKey,
    required this.label,
    required this.hint,
    required this.initialValue,
    required this.maxLength,
    required this.onChanged,
    this.minLines = 1,
    this.maxLines = 1,
  });

  final Key fieldKey;
  final String label;
  final String hint;
  final String initialValue;
  final int maxLength;
  final ValueChanged<String> onChanged;
  final int minLines;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F4),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.fromLTRB(14, 7, 14, 7),
      child: TextFormField(
        key: fieldKey,
        initialValue: initialValue,
        maxLength: maxLength,
        minLines: minLines,
        maxLines: maxLines,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          counterText: '',
          border: InputBorder.none,
        ),
        style: sans(size: 13.5, height: 1.5),
      ),
    );
  }
}

class _MusicNoteCard extends StatelessWidget {
  const _MusicNoteCard({
    required this.controller,
    required this.note,
    required this.onOpenExternalLink,
  });

  final AlagagiController controller;
  final MusicNote note;
  final ValueChanged<String> onOpenExternalLink;

  @override
  Widget build(BuildContext context) {
    final isMine = note.createdByProfileId == controller.state.me.id;
    final creator = isMine
        ? controller.state.me.nickname
        : controller.state.partner.nickname;
    final detailBody = [
      if (note.note.trim().isNotEmpty) note.note.trim(),
      if (note.link.trim().isNotEmpty) '링크\n${note.link.trim()}',
    ].join('\n\n');
    final showReadableCue =
        note.link.trim().isNotEmpty ||
        _showsReadableCue(detailBody, threshold: _compactReadablePreviewLength);
    final openableLink = _normalizedOpenableLink(note.link);
    final listened = note.isListenedBy(controller.state.me.id);
    return GestureDetector(
      key: musicNoteCardKey(note.id),
      behavior: HitTestBehavior.opaque,
      onTap: () => _showReadableDetailSheet(
        context,
        label: '음악 노트',
        title: note.title,
        meta: '$creator · ${note.artist} · ${note.mood}',
        body: detailBody.isEmpty ? '남겨둔 메모는 아직 없어요.' : detailBody,
        actionLabel: isMine ? '수정하기' : null,
        onAction: isMine ? () => controller.startMusicEdit(note.id) : null,
      ),
      child: _PaperCard(
        radius: 19,
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MusicCover(
              color: isMine ? AlagagiColors.sage : AlagagiColors.lavender,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          note.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: sans(
                            size: 14,
                            weight: FontWeight.w700,
                            color: const Color(0xFF33332F),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _SmallBadge(label: note.mood),
                      if (isMine) ...[
                        const SizedBox(width: 4),
                        Tooltip(
                          message: '음악 노트 수정',
                          child: IconButton(
                            key: musicEditButtonKey(note.id),
                            onPressed: () => controller.startMusicEdit(note.id),
                            icon: const Icon(Icons.edit_rounded, size: 17),
                            color: AlagagiColors.sageDeep,
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints.tightFor(
                              width: 32,
                              height: 32,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$creator · ${note.artist}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: sans(size: 11.6, color: AlagagiColors.muted),
                  ),
                  if (note.note.isNotEmpty) ...[
                    const SizedBox(height: 7),
                    Text(
                      note.note,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: sans(
                        size: 12.3,
                        color: const Color(0xFF6F6C65),
                        height: 1.45,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _MusicListenedButton(
                        note: note,
                        listened: listened,
                        onPressed: () =>
                            controller.toggleMusicNoteListened(note.id),
                      ),
                      if (note.link.isNotEmpty)
                        if (openableLink == null)
                          Text(
                            '링크가 저장되어 있어요',
                            style: sans(
                              size: 11,
                              color: AlagagiColors.sageDeep,
                            ),
                          )
                        else
                          _MusicLinkButton(
                            key: musicLinkButtonKey(note.id),
                            onPressed: () => onOpenExternalLink(openableLink),
                          ),
                      if (showReadableCue) const _FullTextCue(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MusicListenedButton extends StatelessWidget {
  const _MusicListenedButton({
    required this.note,
    required this.listened,
    required this.onPressed,
  });

  final MusicNote note;
  final bool listened;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final bothListened = note.listenedByProfileIds.length >= 2;
    final label = bothListened
        ? '둘 다 들음'
        : listened
        ? '들었어요'
        : '아직';
    return Tooltip(
      message: listened ? '들은 표시 취소' : '들었어요 표시',
      child: SizedBox(
        height: 30,
        child: OutlinedButton(
          key: musicListenedButtonKey(note.id),
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: listened
                ? const Color(0xFFF1F4EC)
                : const Color(0xFFF8F8F4),
            foregroundColor: listened
                ? AlagagiColors.sageDeep
                : AlagagiColors.muted,
            side: BorderSide(
              color: listened
                  ? const Color(0x668A9A7E)
                  : const Color(0x22000000),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            minimumSize: const Size(0, 30),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            textStyle: sans(size: 11.4, weight: FontWeight.w800),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(listened ? '🎧' : '👀', style: sans(size: 12)),
              const SizedBox(width: 5),
              Text(label, softWrap: false),
            ],
          ),
        ),
      ),
    );
  }
}

class _MusicLinkButton extends StatelessWidget {
  const _MusicLinkButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.open_in_new_rounded, size: 13),
        label: const Text('링크 열기', softWrap: false),
        style: OutlinedButton.styleFrom(
          foregroundColor: AlagagiColors.sageDeep,
          minimumSize: const Size(0, 30),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          side: const BorderSide(color: Color(0x336F7F63)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 9),
          textStyle: sans(size: 11.5, weight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _MusicCover extends StatelessWidget {
  const _MusicCover({required this.color, this.darkBorder = false});

  final Color color;
  final bool darkBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, Color.alphaBlend(Colors.white54, color)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: darkBorder ? const Color(0xFF2F2F2B) : AlagagiColors.line,
          width: darkBorder ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(
        Icons.music_note_rounded,
        size: 22,
        color: darkBorder ? Colors.white : AlagagiColors.sageDeep,
      ),
    );
  }
}

class MyScreen extends StatelessWidget {
  const MyScreen({super.key, required this.controller, this.onSignOut});

  final AlagagiController controller;
  final VoidCallback? onSignOut;

  @override
  Widget build(BuildContext context) {
    final answeredItems = controller.archiveItems
        .where((item) => item.myAnswer != null && !item.myAnswer!.skipped)
        .toList();
    final myProfileCard = controller.myProfileCard;
    final myMusicNotes = controller.musicNotes
        .where((note) => note.createdByProfileId == controller.state.me.id)
        .toList();
    final recentAnswer = answeredItems.isEmpty
        ? null
        : answeredItems.first.myAnswer;
    final recentQuestion = answeredItems.isEmpty
        ? null
        : answeredItems.first.question;
    final recentMusic = myMusicNotes.isEmpty ? null : myMusicNotes.first;
    final todayAnswer = controller.todayMyAnswer;
    final needsTodayAnswer = todayAnswer == null || todayAnswer.skipped;
    final musicActionLabel = myMusicNotes.isEmpty ? '음악 노트 남기기' : '내 음악 노트 다듬기';
    final musicActionState = myMusicNotes.isEmpty ? '아직 없음' : '최근 1곡';

    return _ScreenScroll(
      bottomNavigation: _BottomNav(controller: controller),
      children: [
        _TopBar(title: '마이', trailing: ''),
        const SizedBox(height: 18),
        Column(
          key: myDashboardKey,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _MyProfileSummaryCard(controller: controller),
            const SizedBox(height: 16),
            _MySectionHeader(title: '내 기록', trailing: '최근 기준'),
            Row(
              children: [
                Expanded(
                  child: _MyStatCard(
                    value: '${answeredItems.length}',
                    label: '남긴\n질문 답',
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: _MyStatCard(
                    value: '${myProfileCard.filledCount}',
                    label: '채운\n소개 카드',
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: _MyStatCard(
                    value: '${myMusicNotes.length}',
                    label: '남긴\n음악 노트',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _MySectionHeader(title: '다음에 해볼 것', trailing: '가볍게 하나씩'),
            _MyPrimaryNextCard(
              buttonKey: myNextPrimaryButtonKey,
              label: needsTodayAnswer ? '오늘 질문 답하기' : '질문함 이어보기',
              description: needsTodayAnswer
                  ? '아직 내 답이 비어 있어요. 짧게 남겨도 충분해요.'
                  : '지나온 질문들을 조용히 다시 볼 수 있어요.',
              meta: needsTodayAnswer
                  ? 'DAY ${controller.todayQuestion.day}'
                  : '질문함',
              progress: needsTodayAnswer ? 0.64 : 1,
              onTap: needsTodayAnswer
                  ? controller.activateHomeProgressSummaryAction
                  : () => controller.goTo(AlagagiRoute.archive),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _MyNextTile(
                    buttonKey: myProfileCardActionButtonKey,
                    icon: Icons.badge_outlined,
                    label: '소개 카드 한 칸 채우기',
                    state:
                        '${myProfileCard.filledCount} / ${myProfileCard.totalCount}',
                    description: '대화할 때 편한 방식을 적어볼 수 있어요.',
                    tone: const Color(0xFFF0EDF4),
                    iconColor: const Color(0xFF7E6D91),
                    onTap: () {
                      controller.setProfileCardTab(ProfileCardTab.me);
                      controller.goTo(AlagagiRoute.profileCard);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MyNextTile(
                    buttonKey: myMusicActionButtonKey,
                    icon: Icons.music_note_rounded,
                    label: musicActionLabel,
                    state: musicActionState,
                    description: myMusicNotes.isEmpty
                        ? '요즘 듣는 한 곡을 남겨볼 수 있어요.'
                        : '최근 남긴 곡을 다시 수정할 수 있어요.',
                    tone: const Color(0xFFF6F0DF),
                    iconColor: const Color(0xFF8D7847),
                    onTap: () {
                      if (myMusicNotes.isEmpty) {
                        controller.startMusicDraft();
                      } else {
                        controller.startMusicEdit(myMusicNotes.first.id);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _MySectionHeader(title: '최근 내 흔적', trailing: '읽기 전용'),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _MyTraceCard(
                    key: myTraceCardKey('question'),
                    label: 'QUESTION',
                    title: recentQuestion?.text ?? '아직 남긴 답이 없어요',
                    body: recentAnswer?.body ?? '오늘 질문부터 천천히 시작해요.',
                    onTap: () => _showReadableDetailSheet(
                      context,
                      label: '최근 질문 답변',
                      title: recentQuestion?.text ?? '아직 남긴 답이 없어요',
                      body: recentAnswer?.body ?? '오늘 질문부터 천천히 시작해요.',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MyTraceCard(
                    key: myTraceCardKey('music'),
                    label: 'MUSIC',
                    title: recentMusic?.title ?? '아직 음악 노트가 없어요',
                    body: recentMusic?.note.isNotEmpty == true
                        ? recentMusic!.note
                        : '요즘의 한 곡을 가볍게 남겨볼 수 있어요.',
                    onTap: () => _showReadableDetailSheet(
                      context,
                      label: '최근 음악 노트',
                      title: recentMusic?.title ?? '아직 음악 노트가 없어요',
                      body: recentMusic?.note.isNotEmpty == true
                          ? recentMusic!.note
                          : '요즘의 한 곡을 가볍게 남겨볼 수 있어요.',
                      meta: recentMusic == null
                          ? null
                          : '${recentMusic.artist} · ${recentMusic.mood}',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _MyHelpCard(onOpenGuide: () => _showFirstVisitGuideBook(context)),
            const SizedBox(height: 16),
            _MyAccountCard(onSignOut: onSignOut),
          ],
        ),
      ],
    );
  }
}

class _MyProfileSummaryCard extends StatelessWidget {
  const _MyProfileSummaryCard({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return _PaperCard(
      radius: 22,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AlagagiColors.sage,
                      Color.alphaBlend(Colors.white60, AlagagiColors.sage),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Text(
                  _profileInitial(controller.state.me.nickname),
                  style: serif(
                    context,
                    size: 22,
                    weight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.state.me.nickname,
                      style: serif(context, size: 21, weight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${controller.state.partner.nickname}과 알아가는 비공개 공간에 들어와 있어요.',
                      style: sans(
                        size: 12.5,
                        color: AlagagiColors.muted,
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _MyStatusChip(label: '로그인됨'),
              _MyStatusChip(label: '조용한 속도'),
              _MyStatusChip(label: '2명 공간'),
            ],
          ),
        ],
      ),
    );
  }

  static String _profileInitial(String nickname) {
    if (nickname.isEmpty) {
      return '?';
    }
    return nickname.substring(0, 1);
  }
}

class _MyStatusChip extends StatelessWidget {
  const _MyStatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2EA),
        border: Border.all(color: const Color(0x338A9A7E)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AlagagiColors.sage,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: sans(
              size: 11.5,
              weight: FontWeight.w700,
              color: AlagagiColors.sageDeep,
            ),
          ),
        ],
      ),
    );
  }
}

class _MySectionHeader extends StatelessWidget {
  const _MySectionHeader({required this.title, required this.trailing});

  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              title,
              style: serif(context, size: 18, weight: FontWeight.w800),
            ),
          ),
          Text(trailing, style: sans(size: 11.5, color: AlagagiColors.muted)),
        ],
      ),
    );
  }
}

class _MyStatCard extends StatelessWidget {
  const _MyStatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return _PaperCard(
      radius: 18,
      padding: const EdgeInsets.fromLTRB(11, 13, 11, 13),
      child: SizedBox(
        height: 72,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: serif(context, size: 24, weight: FontWeight.w800),
            ),
            const SizedBox(height: 7),
            Text(
              label,
              style: sans(size: 11.5, color: AlagagiColors.muted, height: 1.2),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyPrimaryNextCard extends StatelessWidget {
  const _MyPrimaryNextCard({
    required this.buttonKey,
    required this.label,
    required this.description,
    required this.meta,
    required this.progress,
    required this.onTap,
  });

  final Key buttonKey;
  final String label;
  final String description;
  final String meta;
  final double progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: buttonKey,
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AlagagiColors.paper, Color(0xFFEEF2EA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: const Color(0x428A9A7E)),
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0F4A4841),
                blurRadius: 24,
                offset: Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 23,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.72),
                        border: Border.all(color: const Color(0x2E6F7F63)),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'NEXT STEP',
                        style: sans(
                          size: 10,
                          weight: FontWeight.w800,
                          color: AlagagiColors.sageDeep,
                        ),
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      label,
                      style: sans(
                        size: 15,
                        weight: FontWeight.w800,
                        color: const Color(0xFF46443F),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style: sans(
                        size: 12,
                        color: AlagagiColors.muted,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 13),
                    Row(
                      children: [
                        Container(
                          height: 25,
                          padding: const EdgeInsets.symmetric(horizontal: 9),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            meta,
                            style: sans(
                              size: 10.8,
                              weight: FontWeight.w800,
                              color: AlagagiColors.sageDeep,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: LinearProgressIndicator(
                              value: progress.clamp(0, 1),
                              minHeight: 5,
                              backgroundColor: const Color(0x2E8A9A7E),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AlagagiColors.sage,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: AlagagiColors.sageDeep,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MyNextTile extends StatelessWidget {
  const _MyNextTile({
    required this.buttonKey,
    required this.icon,
    required this.label,
    required this.state,
    required this.description,
    required this.tone,
    required this.iconColor,
    required this.onTap,
  });

  final Key buttonKey;
  final IconData icon;
  final String label;
  final String state;
  final String description;
  final Color tone;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: buttonKey,
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: _PaperCard(
          radius: 20,
          padding: const EdgeInsets.all(13),
          child: SizedBox(
            height: 98,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: tone,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(icon, size: 18, color: iconColor),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state,
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: sans(
                          size: 10.5,
                          weight: FontWeight.w700,
                          color: AlagagiColors.muted,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: sans(
                    size: 13,
                    height: 1.35,
                    weight: FontWeight.w800,
                    color: const Color(0xFF46443F),
                  ),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: sans(
                      size: 11.3,
                      color: AlagagiColors.muted,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MyTraceCard extends StatelessWidget {
  const _MyTraceCard({
    super.key,
    required this.label,
    required this.title,
    required this.body,
    required this.onTap,
  });

  final String label;
  final String title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final showReadableCue = _showsReadableCue(
      body,
      threshold: _compactReadablePreviewLength,
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: _PaperCard(
        radius: 20,
        padding: const EdgeInsets.all(14),
        child: SizedBox(
          height: 104,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: sans(
                  size: 10,
                  weight: FontWeight.w800,
                  color: AlagagiColors.sageDeep,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: sans(
                  size: 13.6,
                  weight: FontWeight.w800,
                  color: const Color(0xFF46443F),
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 7),
              Expanded(
                child: Text(
                  body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: sans(
                    size: 11.6,
                    color: AlagagiColors.muted,
                    height: 1.45,
                  ),
                ),
              ),
              if (showReadableCue) ...[
                const SizedBox(height: 4),
                const _FullTextCue(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MyHelpCard extends StatelessWidget {
  const _MyHelpCard({required this.onOpenGuide});

  final VoidCallback onOpenGuide;

  @override
  Widget build(BuildContext context) {
    return _PaperCard(
      radius: 20,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '도움말',
            style: sans(
              size: 13.2,
              weight: FontWeight.w800,
              color: const Color(0xFF46443F),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '헷갈릴 때만 조용히 열어볼 수 있어요. 읽어도 상대에게 알림이 가지 않습니다.',
            style: sans(size: 11.7, color: AlagagiColors.muted, height: 1.55),
          ),
          const SizedBox(height: 12),
          Material(
            color: Colors.transparent,
            child: InkWell(
              key: myFirstVisitGuideButtonKey,
              borderRadius: BorderRadius.circular(18),
              onTap: onOpenGuide,
              child: Container(
                decoration: BoxDecoration(
                  color: AlagagiColors.paper,
                  border: Border.all(color: AlagagiColors.line),
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: const EdgeInsets.all(13),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2EA),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        Icons.menu_book_outlined,
                        size: 19,
                        color: AlagagiColors.sageDeep,
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '처음 안내 다시 보기',
                            style: sans(
                              size: 12.8,
                              weight: FontWeight.w800,
                              color: const Color(0xFF46443F),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '짧은 기능 안내를 다시 확인해요.',
                            style: sans(
                              size: 11.2,
                              color: AlagagiColors.muted,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 9),
                    Container(
                      width: 26,
                      height: 26,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEEF2EA),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: AlagagiColors.sageDeep,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MyAccountCard extends StatelessWidget {
  const _MyAccountCard({required this.onSignOut});

  final VoidCallback? onSignOut;

  @override
  Widget build(BuildContext context) {
    return _PaperCard(
      radius: 20,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '계정',
            style: sans(
              size: 13.2,
              weight: FontWeight.w800,
              color: const Color(0xFF46443F),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            onSignOut == null
                ? '이 기기에서 이어가는 조용한 공간이에요.'
                : '이 기기에서 잠시 나가고 싶을 때만 로그아웃하면 돼요.',
            style: sans(size: 11.7, color: AlagagiColors.muted, height: 1.55),
          ),
          if (onSignOut != null) ...[
            const SizedBox(height: 13),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton(
                onPressed: onSignOut,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AlagagiColors.sageDeep,
                  side: const BorderSide(color: Color(0x336F7F63)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: sans(size: 13, weight: FontWeight.w800),
                ),
                child: const Text('로그아웃'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: bottomNavigationKey,
      decoration: BoxDecoration(
        color: AlagagiColors.paper.withValues(alpha: 0.94),
        border: const Border(top: BorderSide(color: AlagagiColors.line)),
      ),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
      child: Row(
        children: [
          Expanded(
            child: _NavItem(
              icon: Icons.home_outlined,
              label: '홈',
              selected: controller.state.route == AlagagiRoute.home,
              onTap: () => controller.goTo(AlagagiRoute.home),
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.menu_book_outlined,
              label: '질문',
              selected:
                  controller.state.route == AlagagiRoute.archive ||
                  controller.state.route == AlagagiRoute.records,
              onTap: () => controller.goTo(AlagagiRoute.archive),
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.music_note_outlined,
              label: '음악',
              selected: controller.state.route == AlagagiRoute.music,
              showBadge:
                  controller.unreadCountForFeature(
                    UnreadActivityFeature.music,
                  ) >
                  0,
              onTap: () => controller.goTo(AlagagiRoute.music),
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.event_available_outlined,
              label: '약속',
              selected: controller.state.route == AlagagiRoute.meetings,
              showBadge:
                  controller.unreadCountForFeature(
                    UnreadActivityFeature.meetings,
                  ) >
                  0,
              onTap: () => controller.goTo(AlagagiRoute.meetings),
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.favorite_border_rounded,
              label: '만남',
              selected: controller.state.route == AlagagiRoute.meetingPlans,
              showBadge:
                  controller.unreadCountForFeature(
                    UnreadActivityFeature.meetings,
                  ) >
                  0,
              onTap: () => controller.goTo(AlagagiRoute.meetingPlans),
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.place_outlined,
              label: '장소',
              selected: controller.state.route == AlagagiRoute.places,
              showBadge:
                  controller.unreadCountForFeature(
                    UnreadActivityFeature.places,
                  ) >
                  0,
              onTap: () => controller.goTo(AlagagiRoute.places),
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.person_outline_rounded,
              label: '마이',
              selected: controller.state.route == AlagagiRoute.my,
              onTap: () => controller.goTo(AlagagiRoute.my),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.showBadge = false,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  size: 19,
                  color: selected ? AlagagiColors.ink : AlagagiColors.muted,
                ),
                if (showBadge)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFB18472),
                        border: Border.all(
                          color: AlagagiColors.paper,
                          width: 1.2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: sans(
                size: 10,
                weight: selected ? FontWeight.w700 : FontWeight.w400,
                color: selected ? AlagagiColors.ink : AlagagiColors.muted,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: selected ? 16 : 0,
              height: 4,
              decoration: BoxDecoration(
                color: selected ? AlagagiColors.sageDeep : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, required this.trailing, this.onBack});

  final String title;
  final String trailing;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 56,
          child: Align(
            alignment: Alignment.centerLeft,
            child: onBack == null
                ? const SizedBox.shrink()
                : _BackButton(onTap: onBack!),
          ),
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: serif(
              context,
              size: 18,
              weight: FontWeight.w700,
              color: AlagagiColors.ink,
            ),
          ),
        ),
        SizedBox(
          width: 56,
          child: Text(
            trailing,
            textAlign: TextAlign.right,
            style: serif(
              context,
              size: 13,
              color: AlagagiColors.sageDeep,
              weight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '뒤로',
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(19),
        child: InkWell(
          key: subScreenBackButtonKey,
          borderRadius: BorderRadius.circular(19),
          onTap: onTap,
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AlagagiColors.paper,
              border: Border.all(color: AlagagiColors.line),
              borderRadius: BorderRadius.circular(19),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A505046),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.chevron_left_rounded,
              size: 21,
              color: Color(0xFF656D5E),
            ),
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.onPressed,
    this.color = AlagagiColors.ink,
    this.buttonKey,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final Key? buttonKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        key: buttonKey,
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: AlagagiColors.appBackground,
          padding: const EdgeInsets.symmetric(vertical: 17),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: serif(context, size: 15, weight: FontWeight.w700),
        ),
        child: Text(label, textAlign: TextAlign.center),
      ),
    );
  }
}

class _PaperCard extends StatelessWidget {
  const _PaperCard({
    super.key,
    required this.child,
    required this.radius,
    required this.padding,
    this.dashed = false,
    this.highlightedBorder,
  });

  final Widget child;
  final double radius;
  final EdgeInsets padding;
  final bool dashed;
  final Color? highlightedBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: dashed ? Colors.transparent : AlagagiColors.paper,
        border: Border.all(
          color: highlightedBorder ?? AlagagiColors.line,
          width: dashed ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(radius),
      ),
      padding: padding,
      child: child,
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  const _EmptyStateCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return _PaperCard(
      radius: 18,
      padding: const EdgeInsets.all(18),
      dashed: true,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: sans(size: 13, color: AlagagiColors.muted, height: 1.6),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? AlagagiColors.ink : Colors.white,
          border: Border.all(
            color: selected ? AlagagiColors.ink : AlagagiColors.line,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          label,
          style: sans(
            size: 12.5,
            color: selected ? AlagagiColors.appBackground : AlagagiColors.muted,
          ),
        ),
      ),
    );
  }
}

class _KeywordChip extends StatelessWidget {
  const _KeywordChip({required this.label, this.leaf = false});

  final String label;
  final bool leaf;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AlagagiColors.paper,
        border: leaf ? Border.all(color: AlagagiColors.line) : null,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Text(
        label,
        style: sans(size: 11.5, color: const Color(0xFF5A5A54)),
      ),
    );
  }
}

class _SimilarityBadge extends StatelessWidget {
  const _SimilarityBadge({required this.keyword});

  final String keyword;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEEF1E8),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: Text(
        '둘 다 ‘$keyword’ 취향',
        style: sans(size: 11, color: AlagagiColors.sageDeep),
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? AlagagiColors.ink : Colors.white,
          border: Border.all(
            color: selected ? AlagagiColors.ink : AlagagiColors.line,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(vertical: 9),
        alignment: Alignment.center,
        child: Text(
          label,
          style: sans(
            size: 12.5,
            color: selected ? AlagagiColors.appBackground : AlagagiColors.muted,
          ),
        ),
      ),
    );
  }
}

class _ProgressDots extends StatelessWidget {
  const _ProgressDots({required this.activeIndex, required this.count});

  final int activeIndex;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final active = activeIndex == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: active ? 20 : 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: active ? AlagagiColors.sageDeep : const Color(0xFFD5D3CA),
            borderRadius: BorderRadius.circular(6),
          ),
        );
      }),
    );
  }
}
