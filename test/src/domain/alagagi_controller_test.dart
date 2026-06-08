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

    test('edits today answer with existing body preloaded', () {
      final controller = AlagagiController()..enterSpace('영우');

      controller.updateDraftAnswer('처음 답변이에요.');
      controller.submitTodayAnswer();
      controller.editTodayAnswer();

      expect(controller.state.route, AlagagiRoute.answer);
      expect(controller.state.editingAnswer, isTrue);
      expect(controller.state.draftAnswer, '처음 답변이에요.');

      controller.updateDraftAnswer('수정한 답변이에요.');
      controller.submitTodayAnswer();

      expect(controller.state.route, AlagagiRoute.home);
      expect(controller.state.editingAnswer, isFalse);
      expect(controller.todayMyAnswer?.body, '수정한 답변이에요.');
      expect(controller.todayPartnerAnswer?.body, contains('조용해지는 시간'));
    });

    test('answers again after skipping today', () {
      final controller = AlagagiController()..enterSpace('영우');

      controller.skipToday();
      expect(controller.todayMyAnswer?.skipped, isTrue);

      controller.answerTodayAfterSkip();
      controller.updateDraftAnswer('다시 남기는 답이에요.');
      controller.submitTodayAnswer();

      expect(controller.todayMyAnswer?.skipped, isFalse);
      expect(controller.todayMyAnswer?.body, '다시 남기는 답이에요.');
    });

    test('toggles long answer expansion by answer key', () {
      final controller = AlagagiController()..enterSpace('영우');
      const questionId = 'q12';
      const profileId = 'me';

      expect(controller.isAnswerExpanded(questionId, profileId), isFalse);

      controller.toggleAnswerExpanded(questionId, profileId);
      expect(controller.isAnswerExpanded(questionId, profileId), isTrue);

      controller.toggleAnswerExpanded(questionId, profileId);
      expect(controller.isAnswerExpanded(questionId, profileId), isFalse);
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

    test(
      'question and balance catalogs avoid romantic commitment language',
      () {
        const blockedWords = ['하트', '애정 표현', '데이트 계획', '기념일', '커플'];
        final questionTexts = questionCatalogV1.expand(
          (question) => [question.text, question.highlightedText],
        );
        final balanceTexts = balanceQuestionCatalogV1.expand(
          (question) => [
            question.prompt,
            question.left.label,
            question.right.label,
          ],
        );

        for (final text in [...questionTexts, ...balanceTexts]) {
          for (final blockedWord in blockedWords) {
            expect(text, isNot(contains(blockedWord)));
          }
        }
      },
    );
  });
}
