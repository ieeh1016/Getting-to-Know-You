import 'package:flutter_test/flutter_test.dart';
import 'package:minyoung_pick/src/domain/alagagi_controller.dart';

void main() {
  group('Firebase private login spec', () {
    test('maps short login ids to Firebase Auth emails', () {
      expect(firebaseEmailForLoginId('youngwoo'), 'youngwoo@gettoknow.local');
      expect(firebaseEmailForLoginId(' minyoung '), 'minyoung@gettoknow.local');
      expect(
        firebaseEmailForLoginId('custom@example.com'),
        'custom@example.com',
      );
    });

    test('session controller starts from home with real profile ids', () {
      final repository = RecordingAlagagiRepository();
      final controller = AlagagiController.forSession(
        const AlagagiSession(
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
        ),
        repository: repository,
      );

      expect(controller.state.route, AlagagiRoute.home);
      expect(controller.state.me.id, 'youngwooUid');
      expect(controller.state.partner.nickname, '민영');

      controller.updateDraftAnswer('노을 질 때가 좋아요.');
      controller.submitTodayAnswer();

      expect(repository.savedAnswers.single.spaceId, 'main');
      expect(repository.savedAnswers.single.answer.profileId, 'youngwooUid');
      expect(repository.savedAnswers.single.answer.body, '노을 질 때가 좋아요.');
    });
  });
}

class RecordingAlagagiRepository implements AlagagiDataRepository {
  final List<({String spaceId, Answer answer})> savedAnswers = [];
  final List<({String spaceId, String profileId, ProfileSlot slot})>
  savedProfileSlots = [];
  final List<({String spaceId, WishItem wish})> savedWishes = [];

  @override
  Future<AlagagiSession?> loadSession(AlagagiAuthUser user) async {
    return null;
  }

  @override
  Future<void> saveAnswer(String spaceId, Answer answer) async {
    savedAnswers.add((spaceId: spaceId, answer: answer));
  }

  @override
  Future<void> saveProfileSlot(
    String spaceId,
    String profileId,
    ProfileSlot slot,
  ) async {
    savedProfileSlots.add((spaceId: spaceId, profileId: profileId, slot: slot));
  }

  @override
  Future<void> saveWish(String spaceId, WishItem wish) async {
    savedWishes.add((spaceId: spaceId, wish: wish));
  }
}
