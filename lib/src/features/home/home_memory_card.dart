import 'package:flutter/material.dart';

import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/ui_components.dart';
import '../../shared/ui_style.dart';

class HomeMemoryCard extends StatelessWidget {
  const HomeMemoryCard({super.key, required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
    final latest = controller.latestVisibleMemoryCard;
    final unreadCount = controller.unreadCountForFeature(
      UnreadActivityFeature.memoryCards,
    );
    return AlagagiPaperCard(
      key: homeMemoryCardKey,
      radius: 22,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      highlightedBorder: unreadCount > 0 ? AlagagiColors.sage : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2EB),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.bookmark_added_outlined,
                  size: 22,
                  color: AlagagiColors.sageDeep,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '서로의 기억',
                      style: serif(context, size: 19, weight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '까먹고 싶지 않은 이야기를 직접 남겨요',
                      style: sans(
                        size: 12.2,
                        color: AlagagiColors.muted,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              if (unreadCount > 0) AlagagiSmallBadge(label: '새 $unreadCount'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _MemoryCountTile(
                  label: '${state.me.nickname}의 공간',
                  count: controller.memoryCardCountForOwner(state.me.id),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MemoryCountTile(
                  label: '${state.partner.nickname}의 공간',
                  count: controller.memoryCardCountForOwner(state.partner.id),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (latest == null)
            Text(
              '아직 남긴 기억 카드가 없어요. 대화 중 오래 기억하고 싶은 내용을 짧게 적어둘 수 있어요.',
              style: sans(size: 12.5, color: AlagagiColors.muted, height: 1.6),
            )
          else
            _LatestMemoryPreview(controller: controller, card: latest),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  key: homeMemoryOpenButtonKey,
                  onPressed: () => controller.goTo(AlagagiRoute.memoryCards),
                  icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                  label: const Text('기억 보기'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AlagagiColors.sageDeep,
                    side: const BorderSide(color: Color(0x338A9A7E)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    textStyle: sans(size: 12.3, weight: FontWeight.w800),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.icon(
                  key: homeMemoryCreateButtonKey,
                  onPressed: () => controller.goTo(AlagagiRoute.memoryCards),
                  icon: const Icon(Icons.add_rounded, size: 17),
                  label: const Text('카드 만들기'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AlagagiColors.ink,
                    foregroundColor: AlagagiColors.appBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    textStyle: sans(size: 12.3, weight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MemoryCountTile extends StatelessWidget {
  const _MemoryCountTile({required this.label, required this.count});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F2),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: sans(size: 10.8, color: AlagagiColors.muted)),
          const SizedBox(height: 4),
          Text(
            '$count장',
            style: serif(context, size: 19, weight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _LatestMemoryPreview extends StatelessWidget {
  const _LatestMemoryPreview({required this.controller, required this.card});

  final AlagagiController controller;
  final MemoryCard card;

  @override
  Widget build(BuildContext context) {
    final author = card.createdByProfileId == controller.state.me.id
        ? controller.state.me.nickname
        : controller.state.partner.nickname;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            AlagagiSmallBadge(label: card.type.label),
            if (card.visibility == MemoryCardVisibility.private)
              const AlagagiSmallBadge(label: '나만 보기'),
          ],
        ),
        const SizedBox(height: 9),
        Text(
          card.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: serif(context, size: 17, weight: FontWeight.w800),
        ),
        const SizedBox(height: 5),
        Text(
          card.body,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: sans(size: 12.5, color: AlagagiColors.ink, height: 1.55),
        ),
        const SizedBox(height: 6),
        Text(
          '$author · ${card.createdLabel}',
          style: sans(size: 11.2, color: AlagagiColors.muted),
        ),
      ],
    );
  }
}
