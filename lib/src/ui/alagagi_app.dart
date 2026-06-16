import 'dart:async';

import 'package:flutter/material.dart';

import '../app/app_shell.dart';
import '../app/test_keys.dart';
import '../data/external_link_opener.dart';
import '../data/first_visit_guide_store.dart';
import '../data/firebase_alagagi_repositories.dart';
import '../data/music_note_seen_store.dart';
import '../domain/alagagi_controller.dart';
import '../features/answer/answer_screen.dart';
import '../features/archive/archive_screen.dart';
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
import '../features/profile/profile_card_screen.dart';
import '../features/questions/answer_save_status.dart';
import '../features/questions/answer_blocks.dart';
import '../features/records/records_screen.dart';
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
const homeQuestionCardKey = Key('home-question-card');
const homeQuestionAnswerButtonKey = Key('home-question-answer-button');
const homeCuriosityEntryKey = Key('home-curiosity-entry');
const firstVisitGuideBookSheetKey = Key('first-visit-guide-book-sheet');
const alagagiShellKey = Key('alagagi-shell');

const _brandName = '조금씩';
const _brandKicker = '천천히 알아가는 기록';

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
                const QuestionSupportBlock(
                  title: '오늘은 잠시 넘겨뒀어요.',
                  body: '다시 답하고 싶어지면 여기서 바로 이어갈 수 있어요.',
                ),
                const SizedBox(height: 16),
                AlagagiPrimaryButton(
                  label: '다시 답하기',
                  onPressed: controller.answerTodayAfterSkip,
                  color: AlagagiColors.sageDeep,
                ),
                AnswerSaveStatus(
                  controller: controller,
                  questionId: question.id,
                ),
              ],
            )
          else if (myAnswer == null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QuestionSupportBlock(
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
            AnswerPreviewBlock(
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
              action: AlagagiInlineTextAction(
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
              ReadOnlyCommentBlock(
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
              QuestionSupportBlock(
                title: '${controller.state.partner.nickname}님 답은 기다리는 중이에요.',
                body: '상대 답이 준비되면 이 자리에서 이어서 볼 수 있어요.',
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnswerPreviewBlock(
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
                  AnswerCommentBox(
                    controller: controller,
                    questionId: partnerAnswer.questionId,
                    answerOwnerProfileId: partnerAnswer.profileId,
                  ),
                ],
              ),
            AnswerSaveStatus(controller: controller, questionId: question.id),
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
