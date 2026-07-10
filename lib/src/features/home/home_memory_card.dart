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
    final meCount = controller.memoryCardCountForOwner(state.me.id);
    final partnerCount = controller.memoryCardCountForOwner(state.partner.id);
    return AlagagiPaperCard(
      key: homeMemoryCardKey,
      radius: 22,
      padding: const EdgeInsets.fromLTRB(20, 19, 20, 18),
      highlightedBorder: unreadCount > 0 ? AlagagiColors.sage : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MEMORY',
                      style: sans(
                        size: 10.5,
                        color: AlagagiColors.sageDeep,
                        weight: FontWeight.w800,
                        letterSpacing: 1.8,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '서로의 기억',
                      style: serif(context, size: 19, weight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              if (unreadCount > 0) ...[
                AlagagiSmallBadge(label: '새 $unreadCount'),
                const SizedBox(width: 8),
              ],
              _MemoryIconButton(
                buttonKey: homeMemoryCreateButtonKey,
                tooltip: '새 기억 카드 만들기',
                icon: Icons.add_rounded,
                onPressed: () => controller.goTo(AlagagiRoute.memoryCards),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (latest == null)
            _EmptyMemoryPreview(controller: controller)
          else
            _LatestMemoryPreview(controller: controller, card: latest),
          const SizedBox(height: 13),
          _MemorySpaceBar(
            meLabel: '${state.me.nickname}의 공간',
            meCount: meCount,
            partnerLabel: '${state.partner.nickname}의 공간',
            partnerCount: partnerCount,
          ),
          const SizedBox(height: 13),
          AlagagiPrimaryButton(
            buttonKey: homeMemoryOpenButtonKey,
            label: latest == null ? '첫 기억 남기기' : '기억 열어보기',
            onPressed: () => controller.goTo(AlagagiRoute.memoryCards),
            color: AlagagiColors.sageDeep,
          ),
        ],
      ),
    );
  }
}

class _MemoryIconButton extends StatelessWidget {
  const _MemoryIconButton({
    required this.buttonKey,
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final Key buttonKey;
  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        key: buttonKey,
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        color: AlagagiColors.sageDeep,
        constraints: const BoxConstraints.tightFor(width: 40, height: 40),
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0x338A9A7E)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

class _EmptyMemoryPreview extends StatelessWidget {
  const _EmptyMemoryPreview({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '아직 남긴 기억이 없어요.',
            style: serif(context, size: 17, weight: FontWeight.w800),
          ),
          const SizedBox(height: 7),
          Text(
            '대화 중 오래 기억하고 싶은 말, 편하게 대해주고 싶은 포인트, 다음에 챙겨주고 싶은 취향을 한 장으로 남겨둘 수 있어요.',
            style: sans(size: 12.5, color: AlagagiColors.muted, height: 1.6),
          ),
          const SizedBox(height: 13),
          _MemoryStarterLine(
            label: '예: 좋아하는 자리',
            body:
                '${controller.state.partner.nickname}님은 조용하고 오래 앉기 편한 곳을 좋아해요.',
          ),
        ],
      ),
    );
  }
}

class _MemoryStarterLine extends StatelessWidget {
  const _MemoryStarterLine({required this.label, required this.body});

  final String label;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5FCFF),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 25,
            height: 25,
            decoration: const BoxDecoration(
              color: AlagagiColors.goldSoft,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '1',
              style: sans(
                size: 11,
                color: AlagagiColors.gold,
                weight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: sans(
                    size: 12,
                    color: AlagagiColors.ink,
                    weight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  body,
                  style: sans(
                    size: 11.5,
                    color: AlagagiColors.muted,
                    height: 1.45,
                  ),
                ),
              ],
            ),
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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    AlagagiSmallBadge(label: card.type.label),
                    AlagagiSmallBadge(label: card.visibility.label),
                  ],
                ),
              ),
              Text(
                '$author · ${card.createdLabel}',
                style: sans(size: 11, color: AlagagiColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            card.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: serif(
              context,
              size: 18,
              weight: FontWeight.w800,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            card.body,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: sans(size: 13, color: AlagagiColors.ink, height: 1.58),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFCFE6F1))),
            ),
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              _memoryRelationLabel(controller, card),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: sans(size: 11.5, color: AlagagiColors.muted),
            ),
          ),
        ],
      ),
    );
  }
}

class _MemorySpaceBar extends StatelessWidget {
  const _MemorySpaceBar({
    required this.meLabel,
    required this.meCount,
    required this.partnerLabel,
    required this.partnerCount,
  });

  final String meLabel;
  final int meCount;
  final String partnerLabel;
  final int partnerCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5FCFF),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: _MemorySpaceItem(
              color: AlagagiColors.gold,
              label: meLabel,
              count: meCount,
            ),
          ),
          Container(width: 1, height: 28, color: AlagagiColors.line),
          Expanded(
            child: _MemorySpaceItem(
              color: AlagagiColors.lavender,
              label: partnerLabel,
              count: partnerCount,
            ),
          ),
        ],
      ),
    );
  }
}

class _MemorySpaceItem extends StatelessWidget {
  const _MemorySpaceItem({
    required this.color,
    required this.label,
    required this.count,
  });

  final Color color;
  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: sans(size: 11.2, color: AlagagiColors.muted),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '$count',
            style: sans(
              size: 12,
              color: AlagagiColors.ink,
              weight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

String _memoryRelationLabel(AlagagiController controller, MemoryCard card) {
  final creator = card.createdByProfileId == controller.state.me.id
      ? '내가'
      : '${controller.state.partner.nickname}님이';
  final subject = card.subjectProfileId == controller.state.me.id
      ? '나'
      : controller.state.partner.nickname;
  return '$creator 기억하는 $subject';
}
