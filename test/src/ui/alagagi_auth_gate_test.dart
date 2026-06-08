import 'dart:async';

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
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('우리, 천천히\n알아가 볼래요?'), findsOneWidget);
      expect(find.text('민영과 영우만 들어올 수 있어요.'), findsOneWidget);
      expect(find.byKey(loginIdFieldKey), findsOneWidget);
      expect(find.byKey(loginPasswordFieldKey), findsOneWidget);
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

      expect(find.text('알아가기'), findsOneWidget);
      expect(find.text('오늘의 질문'), findsOneWidget);
      expect(find.textContaining('민영님의 답'), findsOneWidget);
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
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(loginIdFieldKey), findsNothing);
      expect(find.text('알아가기'), findsOneWidget);
      expect(find.text('오늘의 질문'), findsOneWidget);
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
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('마이'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('로그아웃'));
      await tester.pumpAndSettle();

      expect(find.byKey(loginIdFieldKey), findsOneWidget);
      expect(find.text('민영과 영우만 들어올 수 있어요.'), findsOneWidget);
    });
  });
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

  @override
  Future<AlagagiSession?> loadSession(AlagagiAuthUser user) async {
    loadedUsers.add(user);
    return sessionsByUid[user.uid];
  }

  @override
  Future<void> saveAnswer(String spaceId, Answer answer) async {}

  @override
  Future<void> saveProfileSlot(
    String spaceId,
    String profileId,
    ProfileSlot slot,
  ) async {}

  @override
  Future<void> saveWish(String spaceId, WishItem wish) async {}
}
