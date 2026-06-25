import 'dart:async';

import 'package:flutter/material.dart';

import '../data/external_link_opener.dart';
import '../data/first_visit_guide_store.dart';
import '../data/firebase_alagagi_repositories.dart';
import '../data/music_note_seen_store.dart';
import '../domain/alagagi_controller.dart';
import '../features/answer/answer_screen.dart';
import '../features/archive/archive_screen.dart';
import '../features/auth/auth_screens.dart';
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
import '../shared/ui_style.dart';

export '../app/test_keys.dart';
export '../app/app_shell.dart';
export '../shared/ui_components.dart';
export '../shared/ui_style.dart';

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
    this.onRefreshSession,
    this.onRouteEntered,
    this.sessionRefreshInProgress = false,
  });

  final AlagagiController? controller;
  final VoidCallback? onSignOut;
  final MusicNoteSeenStore? musicNoteSeenStore;
  final FirstVisitGuideStore? firstVisitGuideStore;
  final ValueChanged<String>? onOpenExternalLink;
  final Future<void> Function()? onRefreshSession;
  final ValueChanged<AlagagiRoute>? onRouteEntered;
  final bool sessionRefreshInProgress;

  @override
  State<AlagagiRoot> createState() => _AlagagiRootState();
}

class _AlagagiRootState extends State<AlagagiRoot> {
  late final AlagagiController _controller;
  late final bool _ownsController;
  late AlagagiRoute _observedRoute;

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
    _observedRoute = _controller.state.route;
    _controller.addListener(_handleRouteChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleRouteChange);
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleRouteChange() {
    final route = _controller.state.route;
    if (route == _observedRoute) {
      return;
    }
    _observedRoute = route;
    widget.onRouteEntered?.call(route);
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
        onRefresh: widget.onRefreshSession,
        isRefreshing: widget.sessionRefreshInProgress,
      ),
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
  bool _sessionRefreshInProgress = false;
  DateTime? _lastRouteRefreshAt;

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

  AlagagiController _createController(AlagagiSession session) {
    return AlagagiController.forSession(
      session,
      repository: widget.dataRepository,
      musicNoteSeenStore:
          widget.musicNoteSeenStore ?? createDefaultMusicNoteSeenStore(),
      firstVisitGuideStore:
          widget.firstVisitGuideStore ?? createDefaultFirstVisitGuideStore(),
    );
  }

  Future<void> _refreshSession({bool showFeedback = true}) async {
    if (_sessionRefreshInProgress) {
      return;
    }
    setState(() {
      _sessionRefreshInProgress = true;
    });
    try {
      final session = await widget.dataRepository.loadSession(widget.user);
      if (!mounted) {
        return;
      }
      if (session == null) {
        _controller?.dispose();
        _controller = null;
        setState(() {
          _sessionFuture = Future<AlagagiSession?>.value();
        });
        return;
      }
      final controller = _controller;
      if (controller == null || !controller.canApplySession(session)) {
        controller?.dispose();
        _controller = _createController(session);
        setState(() {
          _sessionFuture = Future<AlagagiSession?>.value(session);
        });
      } else {
        controller.refreshFromSession(session);
      }
      if (mounted && showFeedback) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('최신 내용으로 다시 확인했어요.')));
      }
    } catch (_) {
      if (mounted && showFeedback) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('새로 불러오지 못했어요. 다시 시도해 주세요.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _sessionRefreshInProgress = false;
        });
      }
    }
  }

  void _refreshSessionForRoute(AlagagiRoute route) {
    if (route == AlagagiRoute.invite || route == AlagagiRoute.home) {
      return;
    }
    final now = DateTime.now();
    final lastRefreshAt = _lastRouteRefreshAt;
    if (lastRefreshAt != null &&
        now.difference(lastRefreshAt) < const Duration(seconds: 20)) {
      return;
    }
    _lastRouteRefreshAt = now;
    unawaited(_refreshSession(showFeedback: false));
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

        _controller ??= _createController(session);
        return AlagagiRoot(
          key: ValueKey('root-${widget.user.uid}-${session.spaceId}'),
          controller: _controller,
          onSignOut: widget.authRepository.signOut,
          onOpenExternalLink: widget.onOpenExternalLink,
          onRefreshSession: _refreshSession,
          onRouteEntered: _refreshSessionForRoute,
          sessionRefreshInProgress: _sessionRefreshInProgress,
        );
      },
    );
  }
}
