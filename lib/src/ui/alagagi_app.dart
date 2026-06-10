import 'package:flutter/material.dart';

import '../data/firebase_alagagi_repositories.dart';
import '../data/music_note_seen_store.dart';
import '../domain/alagagi_controller.dart';

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
const musicTitleFieldKey = Key('music-title-field');
const musicArtistFieldKey = Key('music-artist-field');
const musicLinkFieldKey = Key('music-link-field');
const musicNoteFieldKey = Key('music-note-field');
const musicSubmitButtonKey = Key('music-submit-button');
const musicAddButtonKey = Key('music-add-button');
Key musicEditButtonKey(String noteId) => Key('music-edit-button-$noteId');
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
const myDashboardKey = Key('my-dashboard');
const myNextPrimaryButtonKey = Key('my-next-primary-button');
const myProfileCardActionButtonKey = Key('my-profile-card-action-button');
const myMusicActionButtonKey = Key('my-music-action-button');
const alagagiShellKey = Key('alagagi-shell');
const bottomNavigationKey = Key('bottom-navigation');
const archiveCalendarKey = Key('archive-question-calendar');
const archiveCalendarPreviousButtonKey = Key('archive-calendar-previous');
const archiveCalendarNextButtonKey = Key('archive-calendar-next');
const archiveCalendarTodayButtonKey = Key('archive-calendar-today');
const lateAnswerButtonKey = Key('late-answer-button');
const profileRecommendedSlotButtonKey = Key('profile-recommended-slot-button');
const profileEditorPanelKey = Key('profile-editor-panel');

Key archiveCalendarDayButtonKey(String dateKey) =>
    Key('archive-calendar-day-$dateKey');

Key answerPreviewBlockKey(String questionId, String profileId) =>
    Key('answer-preview-$questionId-$profileId');

Key musicNoteCardKey(String noteId) => Key('music-note-card-$noteId');

Key myTraceCardKey(String type) => Key('my-trace-card-$type');

Key profileCategoryChipKey(String category) =>
    Key('profile-category-chip-$category');

Key profileSlotCardKey(String slotId) => Key('profile-slot-card-$slotId');

Key profileSlotEditButtonKey(String slotId) => Key('profile-slot-edit-$slotId');

Key profileSlotFieldKey(String slotId) => Key('profile-slot-field-$slotId');

Key profileSlotSaveButtonKey(String slotId) => Key('profile-slot-save-$slotId');

Key profileSlotCancelButtonKey(String slotId) =>
    Key('profile-slot-cancel-$slotId');

const _longAnswerPreviewLength = 120;
const _brandName = '조금씩';
const _brandKicker = 'J O G E U M S S I K';

class AlagagiApp extends StatelessWidget {
  const AlagagiApp({
    super.key,
    this.firebaseEnabled = false,
    this.authRepository,
    this.dataRepository,
    this.musicNoteSeenStore,
  });

  final bool firebaseEnabled;
  final AlagagiAuthRepository? authRepository;
  final AlagagiDataRepository? dataRepository;
  final MusicNoteSeenStore? musicNoteSeenStore;

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
      );
    } else {
      home = AlagagiRoot(musicNoteSeenStore: musicNoteSeenStore);
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
  });

  final AlagagiController? controller;
  final VoidCallback? onSignOut;
  final MusicNoteSeenStore? musicNoteSeenStore;

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
        return _PhoneShell(child: _buildRoute());
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
      AlagagiRoute.music => MusicScreen(controller: _controller),
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
        : padding.bottom < 108
        ? 108.0
        : padding.bottom;
    final effectivePadding = padding.copyWith(bottom: bottomPadding);

    return Stack(
      children: [
        Positioned.fill(
          child: ListView(
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
          ),
        ),
        if (bottomNavigation != null)
          Positioned(left: 0, right: 0, bottom: 0, child: bottomNavigation!),
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
  });

  final AlagagiAuthRepository authRepository;
  final AlagagiDataRepository dataRepository;
  final MusicNoteSeenStore? musicNoteSeenStore;

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
  });

  final AlagagiAuthUser user;
  final AlagagiAuthRepository authRepository;
  final AlagagiDataRepository dataRepository;
  final MusicNoteSeenStore? musicNoteSeenStore;

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
        );
        return AlagagiRoot(
          controller: _controller,
          onSignOut: widget.authRepository.signOut,
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
                  letterSpacing: 4,
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
                  letterSpacing: 4,
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
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AlagagiColors.paper,
        border: Border.all(color: AlagagiColors.line),
      ),
      alignment: Alignment.center,
      child: Transform.rotate(
        angle: -0.08,
        child: Container(
          width: 38,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFEEF2EA),
            border: Border.all(color: const Color(0x668A9A7E)),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 13,
                  height: 13,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDCE5D3),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(11),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 9,
                top: 14,
                child: Container(
                  width: 20,
                  height: 3,
                  decoration: BoxDecoration(
                    color: AlagagiColors.sageDeep,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              Positioned(
                left: 9,
                top: 22,
                child: Container(
                  width: 15,
                  height: 3,
                  decoration: BoxDecoration(
                    color: AlagagiColors.sage,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              Positioned(
                left: 9,
                bottom: 9,
                child: Container(
                  width: 22,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB9A8C9),
                    borderRadius: BorderRadius.circular(999),
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

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          controller.state.personalization.appTitle,
          style: serif(context, size: 23, weight: FontWeight.w800),
        ),
        _CircleIconButton(
          icon: Icons.tune_rounded,
          onTap: () => controller.goTo(AlagagiRoute.my),
        ),
      ],
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
                  'TODAY\'S QUESTION',
                  style: sans(
                    size: 10.5,
                    color: AlagagiColors.sageDeep,
                    letterSpacing: 2,
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
                _AnswerSaveStatus(controller: controller),
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
            _AnswerSaveStatus(controller: controller),
          ],
        ],
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _showReadableDetailSheet(
                      context,
                      label: '내 댓글',
                      title: '상대 답에 남긴 댓글',
                      body: existingComment.body,
                      actionLabel: '수정하기',
                      onAction: () => controller.updateAnswerCommentDraft(
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
                        const SizedBox(height: 5),
                        const _FullTextCue(),
                      ],
                    ),
                  ),
                  if (existingComment.edited) ...[
                    const SizedBox(height: 8),
                    const _EditedBadge(),
                  ],
                ],
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
                            onPressed: () =>
                                controller.cancelAnswerCommentDraft(
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
                          label: existingComment == null ? '댓글 남기기' : '수정 저장',
                          onPressed: () => controller.submitAnswerComment(
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
        ],
      ),
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
  final VoidCallback onPressed;

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
  final VoidCallback onPressed;

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
            if ((isLong && onToggle != null) || onOpenFull != null) ...[
              const SizedBox(height: 6),
              Wrap(
                spacing: 14,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (isLong && onToggle != null)
                    _InlineTextAction(
                      label: expanded ? '접기' : '더 보기',
                      onPressed: onToggle,
                    ),
                  if (onOpenFull != null) const _FullTextCue(),
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
                if ((isLong && onToggle != null) || onOpenFull != null) ...[
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (isLong && onToggle != null)
                        _InlineTextAction(
                          label: expanded ? '접기' : '더 보기',
                          onPressed: onToggle,
                        ),
                      if (onOpenFull != null) const _FullTextCue(),
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.open_in_full_rounded,
          size: 13,
          color: AlagagiColors.sageDeep,
        ),
        const SizedBox(width: 4),
        Text(
          '전체 보기',
          style: sans(
            size: 11.5,
            weight: FontWeight.w700,
            color: AlagagiColors.sageDeep,
          ),
        ),
      ],
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
                                label,
                                style: sans(
                                  size: 10.5,
                                  weight: FontWeight.w800,
                                  color: AlagagiColors.sageDeep,
                                  letterSpacing: 1.6,
                                ),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                title,
                                style: serif(
                                  sheetContext,
                                  size: 20,
                                  weight: FontWeight.w800,
                                  height: 1.45,
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
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                      children: [
                        if (meta != null && meta.trim().isNotEmpty) ...[
                          Text(
                            meta,
                            style: sans(
                              size: 12,
                              color: AlagagiColors.muted,
                              height: 1.55,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                        Text(
                          body,
                          key: readableDetailBodyKey,
                          style: sans(
                            size: 14.2,
                            color: const Color(0xFF3F3E39),
                            height: 1.72,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(sheetContext).pop(),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AlagagiColors.muted,
                              side: const BorderSide(color: AlagagiColors.line),
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
                        if (actionLabel != null && onAction != null) ...[
                          const SizedBox(width: 10),
                          Expanded(
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

class _AnswerSaveStatus extends StatelessWidget {
  const _AnswerSaveStatus({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
    final status = state.answerSaveStatus;
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
                title: '마음의 결',
                value: '${insight.similarityPercent}',
                suffix: '% 닮음',
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
          title: '밸런스 게임',
          body: '글 안 써도 되는 취향 선택',
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
          const SizedBox(height: 16),
          if (day.canLateAnswer)
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
            if (onOpenFull != null) ...[
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
  const _SmallBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2EB),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      child: Text(
        label,
        style: sans(size: 10.5, color: AlagagiColors.sageDeep),
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
    final waiting = item.myAnswer != null && item.partnerAnswer == null;
    return _PaperCard(
      radius: 20,
      dashed: waiting,
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
                item.bothAnswered ? '둘 다 답함' : '답 기다리는 중',
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
                '${insight.similarityPercent}%',
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

class BalanceScreen extends StatelessWidget {
  const BalanceScreen({super.key, required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final question = controller.activeBalanceQuestion;
    final selected = controller.activeBalanceSelection;
    final partnerChoice = controller.activePartnerBalanceSelection;

    return _ScreenScroll(
      padding: const EdgeInsets.fromLTRB(24, 34, 24, 44),
      children: [
        _TopBar(
          title: '밸런스 게임',
          trailing:
              '${controller.state.activeBalanceIndex + 1} / ${controller.balanceQuestions.length}',
          onBack: () => controller.goTo(AlagagiRoute.home),
        ),
        const SizedBox(height: 16),
        const _BalanceHeroCard(),
        const SizedBox(height: 16),
        _BalanceDeckCard(
          question: question,
          selected: selected,
          partnerChoice: partnerChoice,
          activeIndex: controller.state.activeBalanceIndex,
          count: controller.balanceQuestions.length,
          partnerName: controller.state.partner.nickname,
          onSelect: controller.selectBalanceOption,
        ),
        const SizedBox(height: 18),
        _BalanceHistoryPreview(
          selected: selected,
          partnerChoice: partnerChoice,
          question: question,
          partnerName: controller.state.partner.nickname,
        ),
        const SizedBox(height: 18),
        _ProgressDots(
          activeIndex: controller.state.activeBalanceIndex,
          count: controller.balanceQuestions.length,
        ),
        const SizedBox(height: 16),
        _PrimaryButton(
          label: controller.isLastBalanceQuestion ? '완료' : '다음 질문',
          onPressed: controller.nextBalanceQuestion,
          color: AlagagiColors.sageDeep,
        ),
      ],
    );
  }
}

class _BalanceHeroCard extends StatelessWidget {
  const _BalanceHeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2F2F2B),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TASTE DECK',
            style: sans(
              size: 10.5,
              color: const Color(0xFFC9C9C2),
              weight: FontWeight.w700,
              letterSpacing: 2.2,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            '짧게 고르고,\n나중에 이야기로 이어져요',
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
            '정답을 맞히는 게임보다 취향의 방향을 남기는 작은 카드 덱이에요.',
            style: sans(
              size: 12.5,
              color: const Color(0xFFE3E2DC),
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceDeckCard extends StatelessWidget {
  const _BalanceDeckCard({
    required this.question,
    required this.selected,
    required this.partnerChoice,
    required this.activeIndex,
    required this.count,
    required this.partnerName,
    required this.onSelect,
  });

  final BalanceQuestion question;
  final String? selected;
  final String? partnerChoice;
  final int activeIndex;
  final int count;
  final String partnerName;
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
              Text(
                'QUESTION ${activeIndex + 1}',
                style: sans(
                  size: 10.5,
                  color: AlagagiColors.sageDeep,
                  weight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              const Spacer(),
              Container(
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AlagagiColors.softSage,
                  borderRadius: BorderRadius.circular(999),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '${activeIndex + 1} / $count',
                  style: sans(
                    size: 11,
                    color: AlagagiColors.sageDeep,
                    weight: FontWeight.w700,
                  ),
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
              size: 21,
              weight: FontWeight.w800,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 186,
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
                        selectedByPartner:
                            selected != null &&
                            partnerChoice == question.left.id,
                        onTap: () => onSelect(question.left.id),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _BalanceDeckOption(
                        option: question.right,
                        selectedByMe: selected == question.right.id,
                        selectedByPartner:
                            selected != null &&
                            partnerChoice == question.right.id,
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
          if (selected != null) ...[
            const SizedBox(height: 14),
            _BalanceHintPanel(
              selected: selected!,
              partnerChoice: partnerChoice,
              question: question,
              partnerName: partnerName,
            ),
          ],
        ],
      ),
    );
  }
}

class _BalanceDeckOption extends StatelessWidget {
  const _BalanceDeckOption({
    required this.option,
    required this.selectedByMe,
    required this.selectedByPartner,
    required this.onTap,
  });

  final BalanceOption option;
  final bool selectedByMe;
  final bool selectedByPartner;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 172),
          decoration: BoxDecoration(
            color: selectedByMe
                ? const Color(0xFFEEF3E8)
                : const Color(0xFFF8F8F4),
            border: Border.all(
              color: selectedByMe ? AlagagiColors.sageDeep : AlagagiColors.line,
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
                  const Spacer(),
                  if (selectedByPartner)
                    const Icon(
                      Icons.person_outline_rounded,
                      size: 17,
                      color: AlagagiColors.sageDeep,
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    selectedByMe ? '선택됨' : '고르기',
                    style: sans(
                      size: 10.5,
                      color: AlagagiColors.sageDeep,
                      weight: FontWeight.w700,
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

class _BalanceHintPanel extends StatelessWidget {
  const _BalanceHintPanel({
    required this.selected,
    required this.partnerChoice,
    required this.question,
    required this.partnerName,
  });

  final String selected;
  final String? partnerChoice;
  final BalanceQuestion question;
  final String partnerName;

  @override
  Widget build(BuildContext context) {
    final myLabel = selected == question.left.id
        ? question.left.label
        : question.right.label;
    final partnerChoice = this.partnerChoice;
    final copy = partnerChoice == null
        ? '$partnerName님 선택이 생기면 결과가 열려요. 지금은 내 취향만 조용히 저장해둘게요.'
        : partnerChoice == selected
        ? '둘 다 $myLabel 쪽을 골랐어요. 다음에 이야기 꺼내기 좋은 작은 힌트예요.'
        : '나는 $myLabel 쪽이에요. 서로 다른 선택도 취향을 알아가는 대화거리가 됩니다.';
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2F2F2B),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            partnerChoice == null ? 'WAITING' : 'RESULT',
            style: sans(
              size: 10.5,
              color: const Color(0xFFC9C9C2),
              weight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            copy,
            style: sans(size: 13, color: const Color(0xFFF2F1EB), height: 1.65),
          ),
        ],
      ),
    );
  }
}

class _BalanceHistoryPreview extends StatelessWidget {
  const _BalanceHistoryPreview({
    required this.selected,
    required this.partnerChoice,
    required this.question,
    required this.partnerName,
  });

  final String? selected;
  final String? partnerChoice;
  final BalanceQuestion question;
  final String partnerName;

  @override
  Widget build(BuildContext context) {
    final stateLabel = selected == null
        ? '아직 선택 전'
        : partnerChoice == null
        ? '대기 중'
        : selected == partnerChoice
        ? '같은 선택'
        : '다른 선택';
    final stateCopy = selected == null
        ? '끌리는 쪽을 고르면 내 취향 힌트가 남아요.'
        : partnerChoice == null
        ? '내 선택은 저장됐고, $partnerName님 선택이 생기면 결과가 열립니다.'
        : selected == partnerChoice
        ? '둘 다 같은 쪽을 골랐어요. 다음 선택에도 참고할 수 있어요.'
        : '서로 다른 쪽을 골랐어요. 틀림이 아니라 대화거리로 남겨둡니다.';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '최근 선택 힌트',
                style: serif(context, size: 16, weight: FontWeight.w800),
              ),
            ),
            Text('대화거리', style: sans(size: 11.5, color: AlagagiColors.muted)),
          ],
        ),
        const SizedBox(height: 10),
        Container(
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
                      style: sans(
                        size: 13,
                        color: const Color(0xFF45443F),
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:
                          selected != null &&
                              partnerChoice != null &&
                              selected == partnerChoice
                          ? const Color(0xFF2F2F2B)
                          : const Color(0xFFF8F8F4),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 9),
                    child: Text(
                      stateLabel,
                      style: sans(
                        size: 10.5,
                        color:
                            selected != null &&
                                partnerChoice != null &&
                                selected == partnerChoice
                            ? Colors.white
                            : AlagagiColors.muted,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              Text(
                stateCopy,
                style: sans(
                  size: 11.5,
                  color: AlagagiColors.muted,
                  height: 1.55,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
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
    return _ScreenScroll(
      bottomNavigation: _BottomNav(controller: controller),
      children: [
        _TopBar(
          title: '소개 카드',
          trailing: '',
          onBack: () => controller.goTo(AlagagiRoute.home),
        ),
        const SizedBox(height: 8),
        Text(
          '편한 만큼 채워두는 내 소개 카드',
          style: sans(size: 12.5, color: AlagagiColors.muted),
        ),
        const SizedBox(height: 16),
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
        const SizedBox(height: 16),
        if (isMine) ...[
          _ProfileCategoryChips(
            selectedCategory: _selectedCategory,
            onSelected: _selectCategory,
          ),
          const SizedBox(height: 14),
          _ProfileRecommendCard(
            slot: _recommendedSlot(card),
            onUse: _startEditing,
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
            title: _selectedCategory == '전체' ? '카드팩' : '$_selectedCategory 카드',
            meta:
                '${_filteredSlots(card.slots).where((slot) => slot.value == null).length}개 비어 있음',
          ),
          const SizedBox(height: 10),
          _ProfileSlotGrid(
            slots: _filteredSlots(card.slots),
            editingSlotId: _editingSlotId,
            onEdit: _startEditing,
          ),
        ] else ...[
          _ProfileCategoryChips(
            selectedCategory: _selectedCategory,
            onSelected: _selectCategory,
          ),
          const SizedBox(height: 14),
          const _ProfileQuietMatchStrip(),
          const SizedBox(height: 14),
          _ProfilePartnerReadList(slots: _filteredSlots(card.slots)),
        ],
      ],
    );
  }

  List<ProfileSlot> _filteredSlots(List<ProfileSlot> slots) {
    if (_selectedCategory == '전체') {
      return slots;
    }
    return slots.where((slot) => slot.category == _selectedCategory).toList();
  }

  ProfileSlot? _recommendedSlot(ProfileCardData card) {
    final filteredEmpty = _filteredSlots(
      card.slots,
    ).where((slot) => slot.value == null).toList();
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
      if (slot.value == null) {
        return slot;
      }
    }
    return null;
  }
}

class _ProfileSummaryCard extends StatelessWidget {
  const _ProfileSummaryCard({required this.card});

  final ProfileCardData card;

  @override
  Widget build(BuildContext context) {
    final progress = card.totalCount == 0
        ? 0.0
        : card.filledCount / card.totalCount;
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
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: card.profile.isMe
                      ? AlagagiColors.softSage
                      : const Color(0xFFE7DDF0),
                  borderRadius: BorderRadius.circular(18),
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
                      '${card.profile.nickname} 카드',
                      style: serif(context, size: 20, weight: FontWeight.w800),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      card.profile.isMe ? '편한 만큼만 채워두기' : '채워진 답만 보여요',
                      style: sans(size: 12, color: AlagagiColors.muted),
                    ),
                  ],
                ),
              ),
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
              minHeight: 7,
              backgroundColor: const Color(0xFFE6E9DF),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AlagagiColors.lavender,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            card.profile.isMe
                ? '다 채우지 않아도 괜찮아요. 지금 떠오르는 한 칸만 남겨도 충분합니다.'
                : '아직 비어 있는 칸은 따로 재촉하지 않습니다. 올라온 답만 천천히 읽어요.',
            style: sans(size: 12.5, color: AlagagiColors.muted, height: 1.6),
          ),
        ],
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

  static const categories = ['전체', '취향', '하루', '대화', '함께'];

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
  const _ProfileRecommendCard({required this.slot, required this.onUse});

  final ProfileSlot? slot;
  final ValueChanged<ProfileSlot> onUse;

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
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
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
  });

  final List<ProfileSlot> slots;
  final String? editingSlotId;
  final ValueChanged<ProfileSlot> onEdit;

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
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ProfileSlotCard extends StatelessWidget {
  const _ProfileSlotCard({
    required this.slot,
    required this.selected,
    required this.onEdit,
  });

  final ProfileSlot slot;
  final bool selected;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final filled = slot.value != null;
    return InkWell(
      key: profileSlotCardKey(slot.id),
      borderRadius: BorderRadius.circular(20),
      onTap: onEdit,
      child: Container(
        constraints: const BoxConstraints(minHeight: 134),
        decoration: BoxDecoration(
          color: AlagagiColors.paper,
          border: Border.all(
            color: selected ? AlagagiColors.sageDeep : AlagagiColors.line,
          ),
          borderRadius: BorderRadius.circular(20),
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
              children: [
                _ProfileSlotIcon(slotId: slot.id),
                const Spacer(),
                Container(
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: filled
                        ? const Color(0xFFF0EDF4)
                        : const Color(0xFFF8F8F4),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    filled ? '작성됨' : '비어 있음',
                    style: sans(
                      size: 10.5,
                      color: filled
                          ? const Color(0xFF7D688F)
                          : AlagagiColors.muted,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              slot.label,
              style: sans(
                size: 12.5,
                color: const Color(0xFF45443F),
                weight: FontWeight.w700,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              filled ? slot.value! : '아직 비어 있어요',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style:
                  sans(
                    size: 12,
                    color: filled
                        ? const Color(0xFF45443F)
                        : AlagagiColors.muted,
                    height: 1.55,
                  ).copyWith(
                    fontStyle: filled ? FontStyle.normal : FontStyle.italic,
                  ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (filled)
                    _InlineTextAction(
                      label: '전체 보기',
                      onPressed: () => _showReadableDetailSheet(
                        context,
                        label: '소개 카드',
                        title: slot.label,
                        body: slot.value!,
                        actionLabel: '수정하기',
                        onAction: onEdit,
                      ),
                    ),
                  _InlineTextAction(
                    key: profileSlotEditButtonKey(slot.id),
                    label: filled ? '수정' : '작성',
                    onPressed: onEdit,
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

class _ProfileQuietMatchStrip extends StatelessWidget {
  const _ProfileQuietMatchStrip();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2F2F2B),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'QUIET MATCH',
            style: sans(
              size: 10.5,
              color: const Color(0xFFC9C9C2),
              weight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            '비슷한 답은 참고 정도로만 보여줘요. 빈 칸은 따로 재촉하지 않습니다.',
            style: sans(size: 13, color: const Color(0xFFF2F1EB), height: 1.6),
          ),
        ],
      ),
    );
  }
}

class _ProfilePartnerReadList extends StatelessWidget {
  const _ProfilePartnerReadList({required this.slots});

  final List<ProfileSlot> slots;

  @override
  Widget build(BuildContext context) {
    final filledSlots = slots.where((slot) => slot.value != null).toList();
    if (filledSlots.isEmpty) {
      return const _InlineEmptyState(text: '아직 채워진 카드가 없어요. 천천히 기다려도 괜찮아요.');
    }
    return Column(
      children: [
        for (final slot in filledSlots) ...[
          _ProfileReadCard(slot: slot),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _ProfileReadCard extends StatelessWidget {
  const _ProfileReadCard({required this.slot});

  final ProfileSlot slot;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _showReadableDetailSheet(
        context,
        label: '소개 카드',
        title: slot.label,
        body: slot.value!,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AlagagiColors.paper,
          border: Border.all(color: AlagagiColors.line),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(15),
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
                    style: sans(
                      size: 12.5,
                      color: AlagagiColors.muted,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 9),
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
            const SizedBox(height: 6),
            const _FullTextCue(),
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
                    ? '표시됨'
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

class MusicScreen extends StatelessWidget {
  const MusicScreen({super.key, required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final notes = controller.musicNotes;
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
        const SizedBox(height: 12),
        if (notes.isEmpty)
          const _EmptyStateCard(text: '요즘 듣는 노래를 한 곡만 가볍게 남겨볼까요?')
        else
          for (final note in notes) ...[
            _MusicNoteCard(controller: controller, note: note),
            const SizedBox(height: 12),
          ],
      ],
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
            label: 'SONG',
            hint: '예: 밤 산책',
            initialValue: controller.state.musicDraftTitle,
            maxLength: 60,
            onChanged: (value) => controller.updateMusicDraft(title: value),
          ),
          const SizedBox(height: 10),
          _MusicTextField(
            fieldKey: musicArtistFieldKey,
            label: 'ARTIST',
            hint: '아티스트 이름',
            initialValue: controller.state.musicDraftArtist,
            maxLength: 60,
            onChanged: (value) => controller.updateMusicDraft(artist: value),
          ),
          const SizedBox(height: 10),
          _MusicTextField(
            fieldKey: musicLinkFieldKey,
            label: 'LINK',
            hint: 'https://...',
            initialValue: controller.state.musicDraftLink,
            maxLength: 180,
            onChanged: (value) => controller.updateMusicDraft(link: value),
          ),
          const SizedBox(height: 10),
          _MusicTextField(
            fieldKey: musicNoteFieldKey,
            label: 'SHORT NOTE',
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
  const _MusicNoteCard({required this.controller, required this.note});

  final AlagagiController controller;
  final MusicNote note;

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
                  if (note.link.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '링크가 저장되어 있어요',
                          style: sans(size: 11, color: AlagagiColors.sageDeep),
                        ),
                        const SizedBox(width: 8),
                        const _FullTextCue(),
                      ],
                    ),
                  ] else ...[
                    const SizedBox(height: 8),
                    const _FullTextCue(),
                  ],
                ],
              ),
            ),
          ],
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
        _TopBar(
          title: '마이',
          trailing: '',
          onBack: () => controller.goTo(AlagagiRoute.home),
        ),
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
              const SizedBox(height: 4),
              const _FullTextCue(),
            ],
          ),
        ),
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
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 12),
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
              showBadge: controller.hasNewPartnerMusicNotes,
              onTap: () => controller.goTo(AlagagiRoute.music),
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
  const _TopBar({
    required this.title,
    required this.trailing,
    required this.onBack,
  });

  final String title;
  final String trailing;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 56,
          child: Align(
            alignment: Alignment.centerLeft,
            child: _BackButton(onTap: onBack),
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

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AlagagiColors.line),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 18, color: AlagagiColors.sageDeep),
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
