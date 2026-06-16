import 'dart:async';

import 'package:flutter/material.dart';

import '../app/app_shell.dart';
import '../data/external_link_opener.dart';
import '../data/first_visit_guide_store.dart';
import '../data/firebase_alagagi_repositories.dart';
import '../data/music_note_seen_store.dart';
import '../domain/alagagi_controller.dart';
import '../features/answer/answer_screen.dart';
import '../features/archive/archive_screen.dart';
import '../features/balance/balance_screen.dart';
import '../features/home/first_visit_guide_overlay.dart';
import '../features/home/first_visit_guide_book_sheet.dart';
import '../features/home/home_screen.dart';
import '../features/improvements/improvement_board_screen.dart';
import '../features/meeting/meeting_plan_screen.dart';
import '../features/meeting/meeting_screen.dart';
import '../features/music/music_screen.dart';
import '../features/my/my_screen.dart';
import '../features/place/place_board_screen.dart';
import '../features/profile/profile_card_screen.dart';
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
                  onOpenGuideBook: () => showFirstVisitGuideBook(context),
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
      AlagagiRoute.home => HomeScreen(
        controller: _controller,
        brandKicker: _brandKicker,
        onOpenGuideBook: () => showFirstVisitGuideBook(context),
      ),
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
        onOpenGuideBook: () => showFirstVisitGuideBook(context),
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
