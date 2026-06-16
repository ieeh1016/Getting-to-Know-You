import 'dart:async';

import 'package:flutter/material.dart';

import '../app/app_shell.dart';
import '../data/external_link_opener.dart';
import '../data/first_visit_guide_store.dart';
import '../data/firebase_alagagi_repositories.dart';
import '../data/music_note_seen_store.dart';
import '../domain/alagagi_controller.dart';
import '../features/home/curiosity_menu_sheet.dart';
import '../features/home/first_visit_guide_overlay.dart';
import '../features/home/home_header.dart';
import '../features/home/home_insight_grid.dart';
import '../features/home/home_plus_grid.dart';
import '../features/home/home_progress_summary_card.dart';
import '../features/home/unread_activity_panel.dart';
import '../features/meeting/meeting_plan_screen.dart';
import '../features/meeting/meeting_screen.dart';
import '../features/music/music_screen.dart';
import '../features/my/my_screen.dart';
import '../features/place/place_board_screen.dart';
import '../shared/ui_components.dart';
import '../shared/ui_style.dart';

export '../app/test_keys.dart';
export '../app/app_shell.dart';
export '../shared/ui_components.dart';
export '../shared/ui_style.dart';

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
Key balanceTabButtonKey(String tab) => Key('balance-tab-$tab');
const editAnswerButtonKey = Key('edit-answer-button');
const homeQuestionCardKey = Key('home-question-card');
const homeQuestionAnswerButtonKey = Key('home-question-answer-button');
const answerRetryButtonKey = Key('answer-retry-button');
const answerCommentFieldKey = Key('answer-comment-field');
const answerCommentEditButtonKey = Key('answer-comment-edit-button');
const answerCommentCancelButtonKey = Key('answer-comment-cancel-button');
const answerCommentSubmitButtonKey = Key('answer-comment-submit-button');
const readableDetailSheetKey = Key('readable-detail-sheet');
const readableDetailBodyKey = Key('readable-detail-body');
const homeCuriosityEntryKey = Key('home-curiosity-entry');
const firstVisitGuideBookSheetKey = Key('first-visit-guide-book-sheet');
const stockStoryAddButtonKey = Key('stock-story-add-button');
const stockStoryNameFieldKey = Key('stock-story-name-field');

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

Key stockHoldingReplyToneKey(String holdingId, String tone) =>
    Key('stock-holding-reply-tone-$holdingId-$tone');
const alagagiShellKey = Key('alagagi-shell');
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
const _brandName = '조금씩';
const _brandKicker = '천천히 알아가는 기록';

bool _showsReadableCue(
  String body, {
  int threshold = _longAnswerPreviewLength,
  bool expanded = false,
}) => !expanded && body.trim().length > threshold;

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
                FirstVisitGuideOverlay(
                  controller: _controller,
                  onOpenGuideBook: () => _showFirstVisitGuideBook(context),
                ),
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
        onOpenReadableDetail:
            ({
              required label,
              required title,
              required body,
              meta,
              actionLabel,
              onAction,
            }) => _showReadableDetailSheet(
              context,
              label: label,
              title: title,
              body: body,
              meta: meta,
              actionLabel: actionLabel,
              onAction: onAction,
            ),
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
        onOpenGuideBook: () => _showFirstVisitGuideBook(context),
        onOpenReadableDetail:
            ({required label, required title, required body, meta}) =>
                _showReadableDetailSheet(
                  context,
                  label: label,
                  title: title,
                  body: body,
                  meta: meta,
                ),
        onSignOut: widget.onSignOut,
      ),
    };
  }
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
              AlagagiPrimaryButton(
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
    return AlagagiScreenScroll(
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
        AlagagiPaperCard(
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
        AlagagiPrimaryButton(
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
              AlagagiPrimaryButton(
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
    return const AlagagiBrandLeafMark(size: 80, iconSize: 34);
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
    return AlagagiScreenScroll(
      bottomNavigation: AlagagiBottomNav(controller: controller),
      children: [
        HomeHeader(
          controller: controller,
          brandKicker: _brandKicker,
          onOpenMenu: () => showHomeMenuSheet(
            context: context,
            controller: controller,
            onOpenCuriosity: () => showCuriosityMenuSheet(context, controller),
            onOpenGuideBook: () => _showFirstVisitGuideBook(context),
          ),
        ),
        const SizedBox(height: 18),
        HomeProgressStrip(controller: controller),
        UnreadActivityPanel(
          controller: controller,
          onOpenCuriosity: (context) =>
              showCuriosityMenuSheet(context, controller),
        ),
        const SizedBox(height: 22),
        const AlagagiSectionLabel('오늘의 질문'),
        const SizedBox(height: 12),
        _QuestionCard(controller: controller),
        const SizedBox(height: 16),
        HomeProgressSummaryCard(controller: controller),
        const SizedBox(height: 22),
        const AlagagiSectionLabel('알아간 기록'),
        const SizedBox(height: 12),
        HomeInsightGrid(controller: controller),
        const SizedBox(height: 24),
        const AlagagiSectionLabel('가볍게 알아가는 것들'),
        const SizedBox(height: 12),
        HomePlusGrid(controller: controller),
      ],
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

    return AlagagiPaperCard(
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
                AlagagiPrimaryButton(
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
                AlagagiPrimaryButton(
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
                              const AlagagiFullTextCue(),
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
                    const AlagagiFullTextCue(),
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
                        const AlagagiFullTextCue(),
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
        AlagagiScreenScroll(
          padding: const EdgeInsets.fromLTRB(28, 34, 28, 166),
          children: [
            AlagagiTopBar(
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
            AlagagiPaperCard(
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
                AlagagiPrimaryButton(
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
    return AlagagiScreenScroll(
      bottomNavigation: AlagagiBottomNav(controller: controller),
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
          const AlagagiEmptyStateCard(text: '아직 쌓인 질문이 없어요. 오늘의 질문부터 천천히 시작해요.')
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

    return AlagagiPaperCard(
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
      return AlagagiPaperCard(
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
                AlagagiSmallBadge(label: day.isToday ? '오늘' : statusLabel),
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
    return AlagagiPaperCard(
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
              AlagagiSmallBadge(label: day.isToday ? '오늘' : statusLabel),
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
            AlagagiPrimaryButton(
              buttonKey: lateAnswerButtonKey,
              label: '늦게 답하기',
              onPressed: () => controller.startLateAnswer(question.id),
              color: AlagagiColors.sageDeep,
            )
          else if (day.isToday && myAnswer == null)
            AlagagiPrimaryButton(
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
              const AlagagiFullTextCue(),
            ],
          ],
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
        AlagagiFilterPill(
          label: '전체',
          selected: controller.state.archiveFilter == ArchiveFilter.all,
          onTap: () => controller.setArchiveFilter(ArchiveFilter.all),
        ),
        AlagagiFilterPill(
          label: '둘 다 답함',
          selected:
              controller.state.archiveFilter == ArchiveFilter.bothAnswered,
          onTap: () => controller.setArchiveFilter(ArchiveFilter.bothAnswered),
        ),
        AlagagiFilterPill(
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
    return AlagagiPaperCard(
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
            AlagagiSimilarityBadge(keyword: item.matchedKeywords.first),
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
    return AlagagiScreenScroll(
      bottomNavigation: AlagagiBottomNav(controller: controller),
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
              AlagagiAvatarStack(
                meAvatar: controller.state.me.avatar,
                partnerAvatar: controller.state.partner.avatar,
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
        const AlagagiSectionLabel('겹치는 키워드'),
        const SizedBox(height: 12),
        if (insight.matchedKeywords.isEmpty)
          const AlagagiEmptyStateCard(
            text: '아직 닮은 키워드는 없어요. 답이 쌓이면 여기에 보여드릴게요.',
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: insight.matchedKeywords
                .map(
                  (keyword) => AlagagiKeywordChip(label: keyword, leaf: true),
                )
                .toList(),
          ),
        const SizedBox(height: 24),
        const AlagagiSectionLabel('숫자로 보는 대화'),
        const SizedBox(height: 12),
        _StatsGrid(insight: insight),
        const SizedBox(height: 24),
        const AlagagiSectionLabel('우리의 발자취'),
        const SizedBox(height: 12),
        if (insight.timeline.isEmpty)
          const AlagagiEmptyStateCard(text: '아직 남겨진 발자취가 없어요.')
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
          child: AlagagiSegmentButton(
            label: '달력',
            selected: route == AlagagiRoute.archive,
            onTap: () => controller.goTo(AlagagiRoute.archive),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AlagagiSegmentButton(
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
    return AlagagiPaperCard(
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

enum _BalanceTab { choose, results, notes }

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key, required this.controller});

  final AlagagiController controller;

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  _BalanceTab _activeTab = _BalanceTab.choose;
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

    return AlagagiScreenScroll(
      padding: const EdgeInsets.fromLTRB(24, 34, 24, 44),
      children: [
        AlagagiTopBar(
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
        const SizedBox(height: 12),
        _BalanceTabBar(
          activeTab: _activeTab,
          resultCount: controller.balanceRevealedCount,
          noteCount: controller.balanceCompletedCount,
          onChanged: (tab) {
            setState(() {
              _activeTab = tab;
              _visibleResultQuestionId = null;
            });
          },
        ),
        const SizedBox(height: 16),
        if (_activeTab == _BalanceTab.choose) ...[
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
          AlagagiProgressDots(
            activeIndex: controller.state.activeBalanceIndex,
            count: controller.balanceQuestions.length,
          ),
          const SizedBox(height: 16),
          AlagagiPrimaryButton(
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
        ] else if (_activeTab == _BalanceTab.results) ...[
          _BalanceResultBoxSection(
            controller: controller,
            expandedResultQuestionId: _visibleResultQuestionId,
            onRevealResult: controller.revealBalanceResult,
            onOpenMeetings: () => controller.goTo(AlagagiRoute.meetingPlans),
            onOpenPlaces: () => controller.goTo(AlagagiRoute.places),
            onOpenMusic: () => controller.goTo(AlagagiRoute.music),
          ),
        ] else ...[
          _BalanceRecordSection(
            controller: controller,
            filter: _filter,
            onFilterChanged: (filter) => setState(() => _filter = filter),
          ),
        ],
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

class _BalanceTabBar extends StatelessWidget {
  const _BalanceTabBar({
    required this.activeTab,
    required this.resultCount,
    required this.noteCount,
    required this.onChanged,
  });

  final _BalanceTab activeTab;
  final int resultCount;
  final int noteCount;
  final ValueChanged<_BalanceTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AlagagiColors.paper,
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(5),
      child: Row(
        children: _BalanceTab.values.map((tab) {
          final selected = tab == activeTab;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: _BalanceTabButton(
                tab: tab,
                selected: selected,
                count: switch (tab) {
                  _BalanceTab.choose => null,
                  _BalanceTab.results => resultCount,
                  _BalanceTab.notes => noteCount,
                },
                onTap: () => onChanged(tab),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _BalanceTabButton extends StatelessWidget {
  const _BalanceTabButton({
    required this.tab,
    required this.selected,
    required this.count,
    required this.onTap,
  });

  final _BalanceTab tab;
  final bool selected;
  final int? count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.white : AlagagiColors.muted;
    final label = _balanceTabLabel(tab);
    final count = this.count;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: balanceTabButtonKey(tab.name),
        borderRadius: BorderRadius.circular(14),
        onTap: selected ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF2F2F2B) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_balanceTabIcon(tab), size: 15, color: color),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: sans(size: 12, color: color, weight: FontWeight.w800),
                ),
              ),
              if (count != null) ...[
                const SizedBox(width: 4),
                Text(
                  '$count',
                  style: sans(
                    size: 10.5,
                    color: color.withValues(alpha: .82),
                    weight: FontWeight.w800,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
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

String _balanceTabLabel(_BalanceTab tab) {
  return switch (tab) {
    _BalanceTab.choose => '오늘',
    _BalanceTab.results => '결과함',
    _BalanceTab.notes => '내 노트',
  };
}

IconData _balanceTabIcon(_BalanceTab tab) {
  return switch (tab) {
    _BalanceTab.choose => Icons.style_outlined,
    _BalanceTab.results => Icons.lock_open_outlined,
    _BalanceTab.notes => Icons.sticky_note_2_outlined,
  };
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
    return AlagagiScreenScroll(
      bottomNavigation: AlagagiBottomNav(controller: controller),
      children: [
        AlagagiTopBar(
          title: '소개 카드',
          trailing: '',
          onBack: () => controller.goTo(AlagagiRoute.home),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AlagagiSegmentButton(
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
              child: AlagagiSegmentButton(
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
      return const AlagagiEmptyStateCard(text: '지금 보이는 카드팩은 모두 채워졌어요.');
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
      return const AlagagiEmptyStateCard(text: '이 카테고리에는 아직 카드가 없어요.');
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
      return const AlagagiEmptyStateCard(text: '소개 카드가 모두 채워졌어요.');
    }

    return AlagagiPaperCard(
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

    return AlagagiScreenScroll(
      bottomNavigation: AlagagiBottomNav(controller: controller),
      children: [
        AlagagiTopBar(
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
      return const AlagagiEmptyStateCard(text: '같이 해보고 싶은 걸 하나만 담아볼까요?');
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
    return AlagagiPaperCard(
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
              AlagagiFilterPill(
                label: '가고 싶은 곳',
                selected: controller.state.wishDraftKind == WishKind.place,
                onTap: () => controller.setWishDraftKind(WishKind.place),
              ),
              AlagagiFilterPill(
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
                child: AlagagiPrimaryButton(
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
        AlagagiFilterPill(
          label: '전체',
          selected: controller.state.wishlistFilter == WishlistFilter.all,
          onTap: () => controller.setWishlistFilter(WishlistFilter.all),
        ),
        AlagagiFilterPill(
          label: '서로 관심',
          selected: controller.state.wishlistFilter == WishlistFilter.mutual,
          onTap: () => controller.setWishlistFilter(WishlistFilter.mutual),
        ),
        AlagagiFilterPill(
          label: '가고 싶은 곳',
          selected: controller.state.wishlistFilter == WishlistFilter.places,
          onTap: () => controller.setWishlistFilter(WishlistFilter.places),
        ),
        AlagagiFilterPill(
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

class ImprovementBoardScreen extends StatelessWidget {
  const ImprovementBoardScreen({super.key, required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final posts = controller.improvementPosts;
    final state = controller.state;
    return AlagagiScreenScroll(
      bottomNavigation: AlagagiBottomNav(controller: controller),
      children: [
        AlagagiTopBar(
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
            const Expanded(child: AlagagiSectionLabel('남긴 글')),
            if (!state.improvementDraftVisible)
              _ImprovementAddButton(controller: controller),
          ],
        ),
        const SizedBox(height: 12),
        _ImprovementSummaryCard(controller: controller),
        _ImprovementSaveStatus(controller: controller),
        const SizedBox(height: 12),
        if (posts.isEmpty)
          const AlagagiEmptyStateCard(text: '생각나는 개선점이나 추가 요청을 하나만 남겨볼까요?')
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
    return AlagagiPaperCard(
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
    return AlagagiPaperCard(
      radius: 18,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Expanded(
            child: AlagagiQuietMetric(label: '전체', value: '${posts.length}'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AlagagiQuietMetric(label: '내 글', value: '$mineCount'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AlagagiQuietMetric(
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
    return AlagagiPaperCard(
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
                AlagagiFilterPill(
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
                child: AlagagiPrimaryButton(
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
      child: AlagagiPaperCard(
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
                          AlagagiSmallBadge(label: post.category),
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
    return AlagagiScreenScroll(
      bottomNavigation: AlagagiBottomNav(controller: controller),
      children: [
        AlagagiTopBar(
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
            const Expanded(child: AlagagiSectionLabel('같이 볼 이야기')),
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
          const AlagagiEmptyStateCard(text: '관심 가는 종목을 하나만 가볍게 남겨볼까요?')
        else if (stories.isEmpty)
          const AlagagiEmptyStateCard(text: '이 조건에 맞는 이야기는 아직 없어요.')
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
    return AlagagiPaperCard(
      radius: 18,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Expanded(
            child: AlagagiQuietMetric(
              label: '전체 이야기',
              value: '${stories.length}',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AlagagiQuietMetric(
              label: '답장 필요',
              value: '$replyNeededCount',
              muted: replyNeededCount == 0,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AlagagiQuietMetric(
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
            AlagagiFilterPill(
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
    return AlagagiPaperCard(
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
                child: AlagagiPrimaryButton(
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
      child: AlagagiPaperCard(
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
                          AlagagiSmallBadge(
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
                AlagagiFilterPill(
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
          AlagagiPrimaryButton(
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
            const Expanded(child: AlagagiSectionLabel('공유한 보유 종목')),
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
          const AlagagiEmptyStateCard(text: '들고 있는 종목을 부담 없이 하나만 공유해볼까요?')
        else if (holdings.isEmpty)
          const AlagagiEmptyStateCard(text: '이 조건에 맞는 보유 종목은 아직 없어요.')
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
    return AlagagiPaperCard(
      radius: 18,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Expanded(
            child: AlagagiQuietMetric(label: '내 종목', value: '$mineCount'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AlagagiQuietMetric(label: '상대 종목', value: '$partnerCount'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AlagagiQuietMetric(
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
            AlagagiFilterPill(
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
    return AlagagiPaperCard(
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
                child: AlagagiPrimaryButton(
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
              AlagagiFilterPill(
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
      child: AlagagiPaperCard(
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
                            const AlagagiSmallBadge(label: '함께 보유 중')
                          else
                            AlagagiSmallBadge(label: holding.status),
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
                AlagagiFilterPill(
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
          AlagagiPrimaryButton(
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
