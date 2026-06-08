import 'package:flutter_test/flutter_test.dart';
import 'package:minyoung_pick/src/domain/alagagi_controller.dart';

void main() {
  group('AlagagiController', () {
    test('starts on invite with Youngwoo as the inviter side', () {
      final controller = AlagagiController();

      expect(controller.state.route, AlagagiRoute.invite);
      expect(controller.state.partner.nickname, '영우');
      expect(controller.todayQuestion.text, contains('좋아하는 시간'));
    });

    test('enters the home screen with a nickname', () {
      final controller = AlagagiController();

      controller.enterSpace('영우');

      expect(controller.state.route, AlagagiRoute.home);
      expect(controller.state.me.nickname, '영우');
      expect(controller.state.inviteError, isNull);
    });

    test('keeps invite screen and reports a gentle error without nickname', () {
      final controller = AlagagiController();

      controller.enterSpace('   ');

      expect(controller.state.route, AlagagiRoute.invite);
      expect(controller.state.inviteError, contains('이름'));
    });

    test('submits today answer and unlocks partner answer', () {
      final controller = AlagagiController()..enterSpace('영우');

      controller.updateDraftAnswer('저는 노을 질 때가 제일 좋아요.');
      controller.submitTodayAnswer();

      expect(controller.state.route, AlagagiRoute.home);
      expect(controller.todayMyAnswer?.body, '저는 노을 질 때가 제일 좋아요.');
      expect(controller.todayPartnerAnswer?.body, contains('조용해지는 시간'));
    });

    test('filters archive by both answered and similar answers', () {
      final controller = AlagagiController();

      controller.setArchiveFilter(ArchiveFilter.bothAnswered);
      expect(
        controller.archiveItems.every((item) => item.bothAnswered),
        isTrue,
      );

      controller.setArchiveFilter(ArchiveFilter.similar);
      expect(controller.archiveItems.every((item) => item.similar), isTrue);
    });

    test('selects balance answer and advances to the next question', () {
      final controller = AlagagiController();

      controller.selectBalanceOption('sea');
      expect(controller.activeBalanceSelection, 'sea');

      controller.nextBalanceQuestion();
      expect(controller.activeBalanceQuestion.prompt, '쉬는 날엔?');
    });

    test('fills my profile card motto slot', () {
      final controller = AlagagiController();

      controller.fillTodayProfileSlot('천천히, 하지만 꾸준히');

      expect(controller.state.profileCardTab, ProfileCardTab.me);
      expect(
        controller.activeProfileCard.slots
            .firstWhere((slot) => slot.id == 'motto')
            .value,
        '천천히, 하지만 꾸준히',
      );
    });

    test('wishlist mutual filter reacts to liking partner wish', () {
      final controller = AlagagiController();

      controller.toggleWishLike('movie');
      controller.setWishlistFilter(WishlistFilter.mutual);

      expect(
        controller.visibleWishes.map((wish) => wish.id),
        contains('movie'),
      );
    });
  });
}
