import 'dart:async';

import 'package:flutter/material.dart';

import '../app/app_shell.dart';
import '../data/external_link_opener.dart';
import '../data/first_visit_guide_store.dart';
import '../data/firebase_alagagi_repositories.dart';
import '../data/music_note_seen_store.dart';
import '../domain/alagagi_controller.dart';
import '../features/balance/balance_screen.dart';
import '../features/home/curiosity_menu_sheet.dart';
import '../features/home/first_visit_guide_overlay.dart';
import '../features/home/home_header.dart';
import '../features/home/home_insight_grid.dart';
import '../features/home/home_plus_grid.dart';
import '../features/home/home_progress_summary_card.dart';
import '../features/home/unread_activity_panel.dart';
import '../features/improvements/improvement_board_screen.dart';
import '../features/meeting/meeting_plan_screen.dart';
import '../features/meeting/meeting_screen.dart';
import '../features/music/music_screen.dart';
import '../features/my/my_screen.dart';
import '../features/place/place_board_screen.dart';
import '../features/stocks/stock_story_screen.dart';
import '../features/wishlist/wishlist_screen.dart';
import '../shared/readable_detail_sheet.dart';
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
const editAnswerButtonKey = Key('edit-answer-button');
const homeQuestionCardKey = Key('home-question-card');
const homeQuestionAnswerButtonKey = Key('home-question-answer-button');
const answerRetryButtonKey = Key('answer-retry-button');
const answerCommentFieldKey = Key('answer-comment-field');
const answerCommentEditButtonKey = Key('answer-comment-edit-button');
const answerCommentCancelButtonKey = Key('answer-comment-cancel-button');
const answerCommentSubmitButtonKey = Key('answer-comment-submit-button');
const homeCuriosityEntryKey = Key('home-curiosity-entry');
const firstVisitGuideBookSheetKey = Key('first-visit-guide-book-sheet');
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
            }) => showReadableDetailSheet(
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
                showReadableDetailSheet(
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
              onOpenFull: () => showReadableDetailSheet(
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
                onOpenFull: () => showReadableDetailSheet(
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
                    onOpenFull: () => showReadableDetailSheet(
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
                        onTap: () => showReadableDetailSheet(
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
              onOpenFull: () => showReadableDetailSheet(
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
              onOpenFull: () => showReadableDetailSheet(
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
              onOpenFull: () => showReadableDetailSheet(
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
                  onPressed: () => showReadableDetailSheet(
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
              onOpenFull: () => showReadableDetailSheet(
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
              onOpenFull: () => showReadableDetailSheet(
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
      return AlagagiInlineEmptyState(text: emptyText);
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
    void openFull() => showReadableDetailSheet(
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
      return const AlagagiInlineEmptyState(
        text: '아직 채워진 카드가 없어요. 천천히 기다려도 괜찮아요.',
      );
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
    void openFull() => showReadableDetailSheet(
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
