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

    test('correction text can be as long as the body it may replace', () {
      // 수정 제안은 반영되면 그대로 본문이 된다. 본문보다 짧으면 긴 카드를
      // 통째로 고쳐 제안할 수 없고, 길면 반영 시 본문 한도를 넘긴다.
      expect(kMemoryCardCorrectionMaxLength, kMemoryCardBodyMaxLength);
    });

    test('a full length correction can be applied to the card body', () {
      final owner = buildController();
      final card = owner.createMemoryCard(
        type: MemoryCardType.likes,
        title: '고칠 카드',
        body: '짧게 적어둔 기억',
      );
      expect(card, isNotNull);

      // 상대가 카드 본문 한도만큼 긴 수정 제안을 남긴다.
      final partner = AlagagiController.forSession(
        AlagagiSession(
          spaceId: 'main',
          me: const AppProfile(
            id: 'minyoungUid',
            nickname: '민영',
            avatar: '🪻',
            isMe: true,
          ),
          partner: const AppProfile(
            id: 'youngwooUid',
            nickname: '영우',
            avatar: '🌿',
            isMe: false,
          ),
          data: AlagagiSpaceData(memoryCards: [card!]),
        ),
      );
      final longCorrection = '나' * kMemoryCardBodyMaxLength;

      final response = partner.respondToMemoryCard(
        card.id,
        MemoryCardReaction.correction,
        correctionText: longCorrection,
      );

      expect(response, isNotNull);
      expect(response!.correctionText.length, kMemoryCardBodyMaxLength);
    });

    test('a correction over the limit is rejected', () {
      final owner = buildController();
      final card = owner.createMemoryCard(
        type: MemoryCardType.likes,
        title: '고칠 카드',
        body: '짧게 적어둔 기억',
      );

      final partner = AlagagiController.forSession(
        AlagagiSession(
          spaceId: 'main',
          me: const AppProfile(
            id: 'minyoungUid',
            nickname: '민영',
            avatar: '🪻',
            isMe: true,
          ),
          partner: const AppProfile(
            id: 'youngwooUid',
            nickname: '영우',
            avatar: '🌿',
            isMe: false,
          ),
          data: AlagagiSpaceData(memoryCards: [card!]),
        ),
      );

      final response = partner.respondToMemoryCard(
        card.id,
        MemoryCardReaction.correction,
        correctionText: '나' * (kMemoryCardBodyMaxLength + 1),
      );

      expect(response, isNull);
    });
  });
}
