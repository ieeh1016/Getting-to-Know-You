import 'package:flutter_test/flutter_test.dart';
import 'package:minyoung_pick/src/domain/alagagi_controller.dart';

void main() {
  AlagagiController buildController() {
    return AlagagiController.forSession(
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
        data: AlagagiSpaceData(),
      ),
    );
  }

  group('Memory card limits', () {
    test('a body at the documented limit is accepted', () {
      final controller = buildController();

      final card = controller.createMemoryCard(
        type: MemoryCardType.likes,
        title: '긴 기억',
        body: '가' * kMemoryCardBodyMaxLength,
      );

      expect(card, isNotNull);
      expect(card!.body.length, kMemoryCardBodyMaxLength);
    });

    test('a body one character over the limit is rejected', () {
      final controller = buildController();

      final card = controller.createMemoryCard(
        type: MemoryCardType.likes,
        title: '너무 긴 기억',
        body: '가' * (kMemoryCardBodyMaxLength + 1),
      );

      expect(card, isNull);
      expect(controller.visibleMemoryCards, isEmpty);
    });

    test('a title at the documented limit is accepted', () {
      final controller = buildController();

      final card = controller.createMemoryCard(
        type: MemoryCardType.current,
        title: '가' * kMemoryCardTitleMaxLength,
        body: '짧은 내용',
      );

      expect(card, isNotNull);
      expect(card!.title.length, kMemoryCardTitleMaxLength);
    });

    test('a title one character over the limit is rejected', () {
      final controller = buildController();

      final card = controller.createMemoryCard(
        type: MemoryCardType.current,
        title: '가' * (kMemoryCardTitleMaxLength + 1),
        body: '짧은 내용',
      );

      expect(card, isNull);
    });

    test('a title under the minimum is rejected', () {
      final controller = buildController();

      final card = controller.createMemoryCard(
        type: MemoryCardType.current,
        title: '가',
        body: '짧은 내용',
      );

      expect(card, isNull);
    });

    test('correction text keeps its own shorter limit', () {
      expect(
        kMemoryCardCorrectionMaxLength,
        lessThan(kMemoryCardBodyMaxLength),
      );
    });
  });
}
