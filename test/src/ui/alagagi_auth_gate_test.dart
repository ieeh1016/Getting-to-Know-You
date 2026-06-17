import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minyoung_pick/src/domain/alagagi_controller.dart';
import 'package:minyoung_pick/src/ui/alagagi_app.dart';

void main() {
  group('AlagagiAuthGate', () {
    testWidgets('shows login when Firebase mode is signed out', (tester) async {
      final auth = FakeAlagagiAuthRepository();
      final data = FakeAlagagiDataRepository();

      await tester.pumpWidget(
        AlagagiApp(
          firebaseEnabled: true,
          authRepository: auth,
          dataRepository: data,
          firstVisitGuideStore: _seenGuideStore(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('천천히 알아가는 기록'), findsOneWidget);
      expect(find.text('J O G E U M S S I K'), findsNothing);
      expect(find.text('조금씩'), findsOneWidget);
      expect(find.text('알아가기'), findsNothing);
      expect(find.text('아이디가 있으면 조용히 이어서 들어갈 수 있어요.'), findsOneWidget);
      expect(find.text('우리, 천천히\n알아가 볼래요?'), findsNothing);
      expect(find.text('두 사람만 로그인할 수 있어요.'), findsNothing);
      expect(find.byKey(loginIdFieldKey), findsOneWidget);
      expect(find.byKey(loginPasswordFieldKey), findsOneWidget);

      final passwordField = tester.widget<TextField>(
        find.descendant(
          of: find.byKey(loginPasswordFieldKey),
          matching: find.byType(TextField),
        ),
      );
      expect(passwordField.decoration?.labelText, '비밀번호');
      expect(passwordField.decoration?.hintText, isNull);
    });

    testWidgets('signs in and enters home with fake session', (tester) async {
      final auth = FakeAlagagiAuthRepository();
      final data = FakeAlagagiDataRepository(
        sessionsByUid: {'youngwooUid': testSession},
      );

      await tester.pumpWidget(
        AlagagiApp(
          firebaseEnabled: true,
          authRepository: auth,
          dataRepository: data,
          firstVisitGuideStore: _seenGuideStore(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(loginIdFieldKey), 'youngwoo');
      await tester.enterText(
        find.byKey(loginPasswordFieldKey),
        'good-password',
      );
      await tester.ensureVisible(find.byKey(loginButtonKey));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(loginButtonKey));
      await tester.pumpAndSettle();

      expect(find.text('조금씩'), findsOneWidget);
      expect(find.text('오늘의 질문'), findsOneWidget);
      expect(find.byKey(homeQuestionCardKey), findsOneWidget);
      expect(find.text('아직 내 답을 남기지 않았어요.'), findsOneWidget);
      expect(find.textContaining('답을 남기면'), findsOneWidget);
      expect(find.textContaining('공기가 조금 조용해지는 시간'), findsNothing);
      expect(data.loadedUsers.single.uid, 'youngwooUid');
    });

    testWidgets('existing auth session skips login', (tester) async {
      final auth = FakeAlagagiAuthRepository(
        initialUser: const AlagagiAuthUser(
          uid: 'youngwooUid',
          loginId: 'youngwoo',
          email: 'youngwoo@gettoknow.local',
        ),
      );
      final data = FakeAlagagiDataRepository(
        sessionsByUid: {'youngwooUid': testSession},
      );

      await tester.pumpWidget(
        AlagagiApp(
          firebaseEnabled: true,
          authRepository: auth,
          dataRepository: data,
          firstVisitGuideStore: _seenGuideStore(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(loginIdFieldKey), findsNothing);
      expect(find.text('조금씩'), findsOneWidget);
      expect(find.text('오늘의 질문'), findsOneWidget);
    });

    testWidgets('home refresh reloads the Firebase session', (tester) async {
      final auth = FakeAlagagiAuthRepository(
        initialUser: const AlagagiAuthUser(
          uid: 'youngwooUid',
          loginId: 'youngwoo',
          email: 'youngwoo@gettoknow.local',
        ),
      );
      final sessions = <String, AlagagiSession>{'youngwooUid': testSession};
      final data = FakeAlagagiDataRepository(sessionsByUid: sessions);

      await tester.pumpWidget(
        AlagagiApp(
          firebaseEnabled: true,
          authRepository: auth,
          dataRepository: data,
          firstVisitGuideStore: _seenGuideStore(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RefreshIndicator), findsOneWidget);
      expect(find.text('다시 불러온 조금씩'), findsNothing);
      expect(data.loadedUsers.length, 1);

      sessions['youngwooUid'] = const AlagagiSession(
        spaceId: 'main',
        me: AppProfile(
          id: 'youngwooUid',
          nickname: '영우',
          avatar: '🌿',
          isMe: true,
        ),
        partner: AppProfile(
          id: 'minyoungUid',
          nickname: '민영',
          avatar: '🪻',
          isMe: false,
        ),
        data: AlagagiSpaceData(
          personalization: SpacePersonalization(
            appTitle: '다시 불러온 조금씩',
            homeLine: '서버에서 새로 온 문구',
          ),
        ),
      );

      await tester.tap(find.byKey(homeMenuButtonKey));
      await tester.pumpAndSettle();
      expect(find.byKey(homeMenuRefreshButtonKey), findsOneWidget);
      await tester.tap(find.byKey(homeMenuRefreshButtonKey));
      await tester.pumpAndSettle();

      expect(data.loadedUsers.length, 2);
      expect(find.text('다시 불러온 조금씩'), findsOneWidget);
      expect(find.text('서버에서 새로 온 문구'), findsOneWidget);
    });

    testWidgets('missing user profile shows Firebase setup state', (
      tester,
    ) async {
      final auth = FakeAlagagiAuthRepository(
        initialUser: const AlagagiAuthUser(
          uid: 'missingUid',
          loginId: 'minyoung',
          email: 'minyoung@gettoknow.local',
        ),
      );
      final data = FakeAlagagiDataRepository();

      await tester.pumpWidget(
        AlagagiApp(
          firebaseEnabled: true,
          authRepository: auth,
          dataRepository: data,
          firstVisitGuideStore: _seenGuideStore(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Firebase Console 설정이 필요해요'), findsOneWidget);
      expect(find.textContaining('missingUid'), findsOneWidget);
    });

    testWidgets('logout returns to login', (tester) async {
      final auth = FakeAlagagiAuthRepository(
        initialUser: const AlagagiAuthUser(
          uid: 'youngwooUid',
          loginId: 'youngwoo',
          email: 'youngwoo@gettoknow.local',
        ),
      );
      final data = FakeAlagagiDataRepository(
        sessionsByUid: {'youngwooUid': testSession},
      );

      await tester.pumpWidget(
        AlagagiApp(
          firebaseEnabled: true,
          authRepository: auth,
          dataRepository: data,
          firstVisitGuideStore: _seenGuideStore(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('마이'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('로그아웃'),
        160,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('로그아웃'));
      await tester.pumpAndSettle();

      expect(find.byKey(loginIdFieldKey), findsOneWidget);
      expect(find.text('아이디가 있으면 조용히 이어서 들어갈 수 있어요.'), findsOneWidget);
    });

    testWidgets('Firebase session shows empty states instead of sample data', (
      tester,
    ) async {
      final auth = FakeAlagagiAuthRepository(
        initialUser: const AlagagiAuthUser(
          uid: 'youngwooUid',
          loginId: 'youngwoo',
          email: 'youngwoo@gettoknow.local',
        ),
      );
      final data = FakeAlagagiDataRepository(
        sessionsByUid: {'youngwooUid': testSession},
      );

      await tester.pumpWidget(
        AlagagiApp(
          firebaseEnabled: true,
          authRepository: auth,
          dataRepository: data,
          firstVisitGuideStore: _seenGuideStore(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('질문'));
      await tester.pumpAndSettle();
      expect(find.text('아직 쌓인 질문이 없어요. 오늘의 질문부터 천천히 시작해요.'), findsOneWidget);
      expect(find.textContaining('비 오는 날엔'), findsNothing);

      await tester.tap(find.text('기록'));
      await tester.pumpAndSettle();
      expect(find.text('기록은 답이 쌓이면 자연스럽게 만들어져요.'), findsOneWidget);
      expect(find.textContaining('잔잔한 음악'), findsNothing);

      await tester.tap(find.text('홈'));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(Scrollable), const Offset(0, -700));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('취향 매치'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('취향 매치'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('조용한 바다'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('조용한 바다'));
      await tester.pumpAndSettle();
      expect(
        find.text('민영님 선택이 생기면 결과가 열려요. 지금은 내 취향만 조용히 저장해둘게요.'),
        findsOneWidget,
      );
      expect(find.textContaining('민영님은'), findsNothing);

      await tester.ensureVisible(find.byKey(subScreenBackButtonKey));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(subScreenBackButtonKey));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(Scrollable), const Offset(0, -700));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('언젠가, 같이'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('언젠가, 같이'));
      await tester.pumpAndSettle();
      expect(find.text('같이 해보고 싶은 걸 하나만 담아볼까요?'), findsOneWidget);
      expect(find.textContaining('노을 예쁜 바닷가'), findsNothing);
    });

    testWidgets('wishlist add CTA creates a new wish card', (tester) async {
      final auth = FakeAlagagiAuthRepository(
        initialUser: const AlagagiAuthUser(
          uid: 'youngwooUid',
          loginId: 'youngwoo',
          email: 'youngwoo@gettoknow.local',
        ),
      );
      final data = FakeAlagagiDataRepository(
        sessionsByUid: {'youngwooUid': testSession},
      );

      await tester.pumpWidget(
        AlagagiApp(
          firebaseEnabled: true,
          authRepository: auth,
          dataRepository: data,
          firstVisitGuideStore: _seenGuideStore(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.drag(find.byType(Scrollable), const Offset(0, -700));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('언젠가, 같이'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('언젠가, 같이'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(wishAddButtonKey));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(wishTitleFieldKey), '한강에서 같이 산책하기');
      await tester.ensureVisible(find.byKey(wishSubmitButtonKey));
      await tester.pumpAndSettle();
      await tester.tap(find.text('담기'));
      await tester.pumpAndSettle();

      expect(find.text('한강에서 같이 산책하기'), findsOneWidget);
      expect(find.text('내가 담음'), findsOneWidget);
      expect(data.savedWishes.single.title, '한강에서 같이 산책하기');
    });
  });
}

FirstVisitGuideStore _seenGuideStore() {
  return MemoryFirstVisitGuideStore()
    ..markFirstVisitGuideSeen(testSession.spaceId, testSession.me.id);
}

const testSession = AlagagiSession(
  spaceId: 'main',
  me: AppProfile(id: 'youngwooUid', nickname: '영우', avatar: '🌿', isMe: true),
  partner: AppProfile(
    id: 'minyoungUid',
    nickname: '민영',
    avatar: '🪻',
    isMe: false,
  ),
);

class FakeAlagagiAuthRepository implements AlagagiAuthRepository {
  FakeAlagagiAuthRepository({AlagagiAuthUser? initialUser})
    : _currentUser = initialUser;

  final StreamController<AlagagiAuthUser?> _changes =
      StreamController<AlagagiAuthUser?>.broadcast();
  AlagagiAuthUser? _currentUser;

  @override
  Stream<AlagagiAuthUser?> authStateChanges() async* {
    yield _currentUser;
    yield* _changes.stream;
  }

  @override
  Future<AlagagiAuthUser> signInWithIdAndPassword({
    required String loginId,
    required String password,
  }) async {
    if (password == 'bad-password') {
      throw const AlagagiAuthException('아이디 또는 비밀번호를 다시 확인해 주세요.');
    }
    final user = AlagagiAuthUser(
      uid: '${loginId.trim()}Uid',
      loginId: loginId.trim(),
      email: firebaseEmailForLoginId(loginId),
    );
    _currentUser = user;
    _changes.add(user);
    return user;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    _changes.add(null);
  }
}

class FakeAlagagiDataRepository implements AlagagiDataRepository {
  FakeAlagagiDataRepository({this.sessionsByUid = const {}});

  final Map<String, AlagagiSession> sessionsByUid;
  final List<AlagagiAuthUser> loadedUsers = [];
  final List<WishItem> savedWishes = [];
  final List<MusicNote> savedMusicNotes = [];
  final List<ScheduleEntry> savedScheduleEntries = [];
  final List<MeetingPlan> savedMeetingPlans = [];
  final List<SharedPlace> savedSharedPlaces = [];
  final List<StockStory> savedStockStories = [];
  final List<StockHolding> savedStockHoldings = [];
  final List<CuriosityCard> savedCuriosityCards = [];
  final List<AnswerComment> savedAnswerComments = [];
  final List<SpacePersonalization> savedPersonalizations = [];

  @override
  Future<AlagagiSession?> loadSession(AlagagiAuthUser user) async {
    loadedUsers.add(user);
    return sessionsByUid[user.uid];
  }

  @override
  Future<void> saveAnswer(String spaceId, Answer answer) async {}

  @override
  Future<void> saveAnswerComment(String spaceId, AnswerComment comment) async {
    savedAnswerComments.add(comment);
  }

  @override
  Future<void> saveDailyQuestionProgress(
    String spaceId,
    DailyQuestionProgress progress,
  ) async {}

  @override
  Future<void> saveSpacePersonalization(
    String spaceId,
    SpacePersonalization personalization,
  ) async {
    savedPersonalizations.add(personalization);
  }

  @override
  Future<void> saveBalanceSelection(
    String spaceId,
    BalanceSelection selection,
  ) async {}

  @override
  Future<void> deleteBalanceSelection(
    String spaceId,
    String questionId,
    String profileId,
  ) async {}

  @override
  Future<void> saveProfileSlot(
    String spaceId,
    String profileId,
    ProfileSlot slot,
  ) async {}

  @override
  Future<void> deleteProfileSlot(
    String spaceId,
    String profileId,
    String slotId,
  ) async {}

  @override
  Future<void> saveWish(String spaceId, WishItem wish) async {
    savedWishes.add(wish);
  }

  @override
  Future<void> deleteWish(String spaceId, String wishId) async {}

  @override
  Future<void> saveMusicNote(String spaceId, MusicNote note) async {
    savedMusicNotes.add(note);
  }

  @override
  Future<void> saveMusicNoteListenState(String spaceId, MusicNote note) async {
    savedMusicNotes.add(note);
  }

  @override
  Future<void> deleteMusicNote(String spaceId, String noteId) async {}

  @override
  Future<void> saveScheduleEntry(String spaceId, ScheduleEntry entry) async {
    savedScheduleEntries.add(entry);
  }

  @override
  Future<void> saveMeetingPlan(String spaceId, MeetingPlan plan) async {
    savedMeetingPlans.add(plan);
  }

  @override
  Future<void> saveSharedPlace(String spaceId, SharedPlace place) async {
    savedSharedPlaces.add(place);
  }

  @override
  Future<void> deleteSharedPlace(String spaceId, String placeId) async {}

  @override
  Future<void> saveCuriosityCard(String spaceId, CuriosityCard card) async {
    savedCuriosityCards.add(card);
  }

  @override
  Future<void> saveStockStory(String spaceId, StockStory story) async {
    savedStockStories.add(story);
  }

  @override
  Future<void> deleteStockStory(String spaceId, String storyId) async {}

  @override
  Future<void> saveStockHolding(String spaceId, StockHolding holding) async {
    savedStockHoldings.add(holding);
  }

  @override
  Future<void> deleteStockHolding(String spaceId, String holdingId) async {}

  @override
  Future<void> saveImprovementPost(
    String spaceId,
    ImprovementPost post,
  ) async {}

  @override
  Future<void> deleteImprovementPost(String spaceId, String postId) async {}
}
