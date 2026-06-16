import 'package:flutter/material.dart';

import '../../app/app_shell.dart';
import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/readable_detail_sheet.dart';
import '../../shared/ui_components.dart';
import '../../shared/ui_style.dart';

class StockStoryScreen extends StatelessWidget {
  const StockStoryScreen({super.key, required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final activeTab = controller.state.stockStoryTab;
    return AlagagiScreenScroll(
      bottomNavigation: AlagagiBottomNav(controller: controller),
      children: [
        AlagagiTopBar(
          title: '주식 이야기',
          trailing: '',
          onBack: () => controller.goTo(AlagagiRoute.home),
        ),
        const SizedBox(height: 4),
        Text(
          '관심 종목과 걱정 포인트를 조심히 나눠요',
          style: sans(size: 12.5, color: AlagagiColors.muted),
        ),
        const SizedBox(height: 16),
        const _StockStoryHeroCard(),
        const SizedBox(height: 14),
        _StockStoryTabs(controller: controller),
        const SizedBox(height: 16),
        if (activeTab == StockStoryTab.stories)
          _StockStoriesPane(controller: controller)
        else
          _StockHoldingsPane(controller: controller),
      ],
    );
  }
}

class _StockStoryTabs extends StatelessWidget {
  const _StockStoryTabs({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final activeTab = controller.state.stockStoryTab;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFCFCFA),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          Expanded(
            child: _StockStoryTabButton(
              buttonKey: stockStoryTabStoriesKey,
              label: '이야기',
              selected: activeTab == StockStoryTab.stories,
              onTap: () => controller.setStockStoryTab(StockStoryTab.stories),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: _StockStoryTabButton(
              buttonKey: stockStoryTabHoldingsKey,
              label: '보유',
              selected: activeTab == StockStoryTab.holdings,
              onTap: () => controller.setStockStoryTab(StockStoryTab.holdings),
            ),
          ),
        ],
      ),
    );
  }
}

class _StockStoryTabButton extends StatelessWidget {
  const _StockStoryTabButton({
    required this.buttonKey,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final Key buttonKey;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AlagagiColors.sageDeep : Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        key: buttonKey,
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: SizedBox(
          height: 38,
          child: Center(
            child: Text(
              label,
              style: sans(
                size: 12.5,
                weight: FontWeight.w800,
                color: selected ? Colors.white : AlagagiColors.muted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StockStoriesPane extends StatelessWidget {
  const _StockStoriesPane({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final stories = controller.visibleStockStories;
    final totalCount = controller.stockStories.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (controller.state.stockStoryDraftVisible) ...[
          _StockStoryDraftCard(controller: controller),
          const SizedBox(height: 18),
        ],
        Row(
          children: [
            const Expanded(child: AlagagiSectionLabel('같이 볼 이야기')),
            if (!controller.state.stockStoryDraftVisible)
              _StockStoryAddButton(controller: controller),
          ],
        ),
        if (totalCount > 0) ...[
          const SizedBox(height: 12),
          _StockStorySummaryCard(controller: controller),
          const SizedBox(height: 10),
          _StockStoryFilterBar(controller: controller),
        ],
        const SizedBox(height: 12),
        if (totalCount == 0)
          const AlagagiEmptyStateCard(text: '관심 가는 종목을 하나만 가볍게 남겨볼까요?')
        else if (stories.isEmpty)
          const AlagagiEmptyStateCard(text: '이 조건에 맞는 이야기는 아직 없어요.')
        else
          for (final story in stories) ...[
            _StockStoryCard(controller: controller, story: story),
            const SizedBox(height: 12),
          ],
      ],
    );
  }
}

class _StockStorySummaryCard extends StatelessWidget {
  const _StockStorySummaryCard({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final stories = controller.stockStories;
    final replyNeededCount = stories
        .where(
          (story) =>
              story.createdByProfileId == controller.state.partner.id &&
              !story.hasReply,
        )
        .length;
    final repliedCount = stories.where((story) => story.hasReply).length;
    return AlagagiPaperCard(
      radius: 18,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Expanded(
            child: AlagagiQuietMetric(
              label: '전체 이야기',
              value: '${stories.length}',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AlagagiQuietMetric(
              label: '답장 필요',
              value: '$replyNeededCount',
              muted: replyNeededCount == 0,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AlagagiQuietMetric(
              label: '답장 있음',
              value: '$repliedCount',
              muted: repliedCount == 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _StockStoryFilterBar extends StatelessWidget {
  const _StockStoryFilterBar({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final selected = controller.state.stockStoryListFilter;
    final filters = [
      (StockStoryListFilter.all, '전체'),
      (StockStoryListFilter.mine, '내가 남김'),
      (StockStoryListFilter.partner, '상대가 남김'),
      (StockStoryListFilter.needsReply, '답장 필요'),
      (StockStoryListFilter.replied, '답장 있음'),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final filter in filters) ...[
            AlagagiFilterPill(
              key: stockStoryListFilterButtonKey(filter.$1.name),
              label: filter.$2,
              selected: selected == filter.$1,
              onTap: () => controller.setStockStoryListFilter(filter.$1),
            ),
            if (filter != filters.last) const SizedBox(width: 7),
          ],
        ],
      ),
    );
  }
}

class _StockStoryHeroCard extends StatelessWidget {
  const _StockStoryHeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2F2F2B),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '관점 노트',
            style: sans(
              size: 10.5,
              weight: FontWeight.w800,
              color: const Color(0xFFC9C9C2),
              letterSpacing: 1.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '신호보다,\n서로의 생각을 남겨요.',
            style: serif(
              context,
              size: 22,
              weight: FontWeight.w800,
              color: Colors.white,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            '좋아 보이는 점과 조심할 점을 같이 적어두면 판단이 조금 더 차분해져요.',
            style: sans(
              size: 12.5,
              color: const Color(0xFFD8D8D1),
              height: 1.58,
            ),
          ),
        ],
      ),
    );
  }
}

class _StockStoryAddButton extends StatelessWidget {
  const _StockStoryAddButton({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: OutlinedButton.icon(
        key: stockStoryAddButtonKey,
        onPressed: controller.startStockStoryDraft,
        icon: const Icon(Icons.add_rounded, size: 16),
        label: const Text('이야기 남기기'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AlagagiColors.sageDeep,
          side: const BorderSide(color: Color(0x338A9A7E)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          textStyle: sans(size: 12, weight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _StockStoryDraftCard extends StatelessWidget {
  const _StockStoryDraftCard({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return AlagagiPaperCard(
      radius: 22,
      padding: const EdgeInsets.all(18),
      highlightedBorder: AlagagiColors.sage,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '같이 살펴볼 이야기를\n가볍게 남겨요.',
            style: serif(
              context,
              size: 20,
              weight: FontWeight.w800,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            '결론보다 이유와 걱정을 함께 남기면 충분해요.',
            style: sans(size: 12.5, color: AlagagiColors.muted, height: 1.6),
          ),
          const SizedBox(height: 16),
          AlagagiTextField(
            fieldKey: stockStoryNameFieldKey,
            label: '종목명',
            hint: '예: 삼성전자, Apple',
            initialValue: controller.state.stockStoryDraftName,
            maxLength: 40,
            onChanged: (value) => controller.updateStockStoryDraft(name: value),
          ),
          const SizedBox(height: 10),
          AlagagiTextField(
            fieldKey: stockStoryReasonFieldKey,
            label: '관심 이유',
            hint: '왜 같이 보고 싶은지',
            initialValue: controller.state.stockStoryDraftReason,
            maxLength: 120,
            maxLines: 2,
            onChanged: (value) =>
                controller.updateStockStoryDraft(reason: value),
          ),
          const SizedBox(height: 10),
          AlagagiTextField(
            fieldKey: stockStoryUpsideFieldKey,
            label: '기대 포인트',
            hint: '좋아 보이는 점',
            initialValue: controller.state.stockStoryDraftUpside,
            maxLength: 80,
            onChanged: (value) =>
                controller.updateStockStoryDraft(upside: value),
          ),
          const SizedBox(height: 10),
          AlagagiTextField(
            fieldKey: stockStoryRiskFieldKey,
            label: '걱정 포인트',
            hint: '조심해서 볼 점',
            initialValue: controller.state.stockStoryDraftRisk,
            maxLength: 80,
            onChanged: (value) => controller.updateStockStoryDraft(risk: value),
          ),
          const SizedBox(height: 10),
          AlagagiTextField(
            fieldKey: stockStoryQuestionFieldKey,
            label: '궁금한 점',
            hint: '상대에게 묻고 싶은 것',
            initialValue: controller.state.stockStoryDraftQuestion,
            maxLength: 100,
            maxLines: 2,
            onChanged: (value) =>
                controller.updateStockStoryDraft(question: value),
          ),
          if (controller.state.stockStoryDraftError != null) ...[
            const SizedBox(height: 10),
            Text(
              controller.state.stockStoryDraftError!,
              style: sans(size: 12, color: AlagagiColors.sageDeep),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton(
                onPressed: controller.cancelStockStoryDraft,
                child: Text(
                  '취소',
                  style: sans(size: 13, color: AlagagiColors.muted),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AlagagiPrimaryButton(
                  label: '이야기 남기기',
                  onPressed: controller.submitStockStoryDraft,
                  color: AlagagiColors.sageDeep,
                  buttonKey: stockStorySubmitButtonKey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StockStoryCard extends StatelessWidget {
  const _StockStoryCard({required this.controller, required this.story});

  final AlagagiController controller;
  final StockStory story;

  @override
  Widget build(BuildContext context) {
    final isMine = story.createdByProfileId == controller.state.me.id;
    final creator = isMine
        ? controller.state.me.nickname
        : controller.state.partner.nickname;
    final detailBody = [
      '관심 이유\n${story.reason}',
      '기대 포인트\n${story.upside}',
      '걱정 포인트\n${story.risk}',
      '궁금한 점\n${story.question}',
      if (story.hasReply) '${story.replyTone ?? '답장'}\n${story.reply!.trim()}',
    ].join('\n\n');
    return GestureDetector(
      key: stockStoryCardKey(story.id),
      behavior: HitTestBehavior.opaque,
      onTap: () => showReadableDetailSheet(
        context,
        label: '주식 이야기',
        title: story.name,
        meta: '$creator · ${story.createdLabel}',
        body: detailBody,
      ),
      child: AlagagiPaperCard(
        radius: 19,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StockStoryMark(name: story.name, isMine: isMine),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              story.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: sans(
                                size: 14.2,
                                weight: FontWeight.w800,
                                color: const Color(0xFF33332F),
                              ),
                            ),
                          ),
                          AlagagiSmallBadge(
                            label: story.hasReply ? '답장 있음' : '기다리는 중',
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        creator,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: sans(size: 11.6, color: AlagagiColors.muted),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        story.reason,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: sans(
                          size: 12.3,
                          color: const Color(0xFF6F6C65),
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StockStoryMiniBox(label: '기대', body: story.upside),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StockStoryMiniBox(label: '걱정', body: story.risk),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _StockStoryQuestion(text: story.question),
            if (story.hasReply) ...[
              const SizedBox(height: 10),
              _StockStoryReplyBlock(story: story),
            ] else if (!isMine) ...[
              const SizedBox(height: 12),
              _StockStoryReplyComposer(controller: controller, story: story),
            ],
            if (controller.state.stockStoryReplyError != null && !isMine) ...[
              const SizedBox(height: 8),
              Text(
                controller.state.stockStoryReplyError!,
                style: sans(size: 12, color: AlagagiColors.sageDeep),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StockStoryMark extends StatelessWidget {
  const _StockStoryMark({required this.name, required this.isMine});

  final String name;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: isMine ? AlagagiColors.softSage : const Color(0xFFF5EFEA),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Text(
        name.characters.first.toUpperCase(),
        style: sans(
          size: 15,
          weight: FontWeight.w900,
          color: isMine ? AlagagiColors.sageDeep : const Color(0xFFB18472),
        ),
      ),
    );
  }
}

class _StockStoryMiniBox extends StatelessWidget {
  const _StockStoryMiniBox({required this.label, required this.body});

  final String label;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 70),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F4),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: sans(
              size: 10.5,
              weight: FontWeight.w800,
              color: AlagagiColors.sageDeep,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: sans(size: 11.5, color: AlagagiColors.ink, height: 1.38),
          ),
        ],
      ),
    );
  }
}

class _StockStoryQuestion extends StatelessWidget {
  const _StockStoryQuestion({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AlagagiColors.ink,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '궁금한 점',
            style: sans(
              size: 10.5,
              weight: FontWeight.w800,
              color: const Color(0xFFC9C9C2),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            text,
            style: sans(size: 12.3, color: Colors.white, height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _StockStoryReplyBlock extends StatelessWidget {
  const _StockStoryReplyBlock({required this.story});

  final StockStory story;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2EA),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            story.replyTone ?? '답장',
            style: sans(
              size: 10.5,
              weight: FontWeight.w800,
              color: AlagagiColors.sageDeep,
            ),
          ),
          const SizedBox(height: 5),
          Text(story.reply ?? '', style: sans(size: 12.5, height: 1.5)),
        ],
      ),
    );
  }
}

class _StockStoryReplyComposer extends StatelessWidget {
  const _StockStoryReplyComposer({
    required this.controller,
    required this.story,
  });

  final AlagagiController controller;
  final StockStory story;

  @override
  Widget build(BuildContext context) {
    final selectedTone = controller.stockStoryReplyToneFor(story.id);
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEFA),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(17),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '내 관점 남기기',
            style: sans(
              size: 11.5,
              weight: FontWeight.w800,
              color: AlagagiColors.sageDeep,
            ),
          ),
          const SizedBox(height: 9),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              for (final tone in stockStoryReplyToneOptions)
                AlagagiFilterPill(
                  key: stockStoryReplyToneKey(story.id, tone),
                  label: tone,
                  selected: selectedTone == tone,
                  onTap: () =>
                      controller.setStockStoryReplyTone(story.id, tone),
                ),
            ],
          ),
          const SizedBox(height: 9),
          TextField(
            key: stockStoryReplyFieldKey(story.id),
            minLines: 2,
            maxLines: 3,
            maxLength: 160,
            onChanged: (value) => controller.updateStockStoryReplyDraft(
              storyId: story.id,
              value: value,
            ),
            decoration: InputDecoration(
              hintText: '숫자 하나나 확인할 점만 남겨도 괜찮아요.',
              hintStyle: sans(size: 12.2, color: AlagagiColors.muted),
              counterText: '',
              filled: true,
              fillColor: const Color(0xFFF8F8F4),
              contentPadding: const EdgeInsets.all(12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AlagagiColors.line),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AlagagiColors.sageDeep),
              ),
            ),
            style: sans(size: 13, height: 1.45),
          ),
          const SizedBox(height: 9),
          AlagagiPrimaryButton(
            label: '관점 남기기',
            buttonKey: stockStoryReplySubmitButtonKey(story.id),
            onPressed: () => controller.submitStockStoryReply(story.id),
            color: AlagagiColors.sageDeep,
          ),
        ],
      ),
    );
  }
}

class _StockHoldingsPane extends StatelessWidget {
  const _StockHoldingsPane({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final holdings = controller.visibleStockHoldings;
    final allHoldings = controller.stockHoldings;
    final mineCount = allHoldings
        .where(
          (holding) => holding.createdByProfileId == controller.state.me.id,
        )
        .length;
    final partnerCount = allHoldings.length - mineCount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (controller.state.stockHoldingDraftVisible) ...[
          _StockHoldingDraftCard(controller: controller),
          const SizedBox(height: 18),
        ],
        Row(
          children: [
            const Expanded(child: AlagagiSectionLabel('공유한 보유 종목')),
            if (!controller.state.stockHoldingDraftVisible)
              _StockHoldingAddButton(controller: controller),
          ],
        ),
        const SizedBox(height: 12),
        _StockHoldingSummaryCard(
          controller: controller,
          mineCount: mineCount,
          partnerCount: partnerCount,
        ),
        if (allHoldings.isNotEmpty) ...[
          const SizedBox(height: 10),
          _StockHoldingFilterBar(controller: controller),
        ],
        const SizedBox(height: 12),
        if (allHoldings.isEmpty)
          const AlagagiEmptyStateCard(text: '들고 있는 종목을 부담 없이 하나만 공유해볼까요?')
        else if (holdings.isEmpty)
          const AlagagiEmptyStateCard(text: '이 조건에 맞는 보유 종목은 아직 없어요.')
        else
          for (final holding in holdings) ...[
            _StockHoldingCard(controller: controller, holding: holding),
            const SizedBox(height: 12),
          ],
      ],
    );
  }
}

class _StockHoldingSummaryCard extends StatelessWidget {
  const _StockHoldingSummaryCard({
    required this.controller,
    required this.mineCount,
    required this.partnerCount,
  });

  final AlagagiController controller;
  final int mineCount;
  final int partnerCount;

  @override
  Widget build(BuildContext context) {
    final replyNeededCount = controller.stockHoldings
        .where(
          (holding) =>
              holding.createdByProfileId == controller.state.partner.id &&
              !holding.hasReply,
        )
        .length;
    return AlagagiPaperCard(
      radius: 18,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Expanded(
            child: AlagagiQuietMetric(label: '내 종목', value: '$mineCount'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AlagagiQuietMetric(label: '상대 종목', value: '$partnerCount'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AlagagiQuietMetric(
              label: '답장 필요',
              value: '$replyNeededCount',
              muted: replyNeededCount == 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _StockHoldingFilterBar extends StatelessWidget {
  const _StockHoldingFilterBar({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final selected = controller.state.stockHoldingListFilter;
    final filters = [
      (StockHoldingListFilter.all, '전체'),
      (StockHoldingListFilter.mine, '내 종목'),
      (StockHoldingListFilter.partner, '상대 종목'),
      (StockHoldingListFilter.needsReply, '답장 필요'),
      (StockHoldingListFilter.shared, '함께 보유'),
      (StockHoldingListFilter.holding, '보유 중'),
      (StockHoldingListFilter.considering, '정리 고민'),
      (StockHoldingListFilter.closed, '최근 정리'),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final filter in filters) ...[
            AlagagiFilterPill(
              key: stockHoldingListFilterButtonKey(filter.$1.name),
              label: filter.$2,
              selected: selected == filter.$1,
              onTap: () => controller.setStockHoldingListFilter(filter.$1),
            ),
            if (filter != filters.last) const SizedBox(width: 7),
          ],
        ],
      ),
    );
  }
}

class _StockHoldingAddButton extends StatelessWidget {
  const _StockHoldingAddButton({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: OutlinedButton.icon(
        key: stockHoldingAddButtonKey,
        onPressed: controller.startStockHoldingDraft,
        icon: const Icon(Icons.add_rounded, size: 16),
        label: const Text('보유 공유'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AlagagiColors.sageDeep,
          side: const BorderSide(color: Color(0x338A9A7E)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          textStyle: sans(size: 12, weight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _StockHoldingDraftCard extends StatelessWidget {
  const _StockHoldingDraftCard({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
    final isEditing = state.editingStockHoldingId != null;
    return AlagagiPaperCard(
      radius: 22,
      padding: const EdgeInsets.all(18),
      highlightedBorder: AlagagiColors.sage,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            isEditing ? '보유 종목을\n다시 정리해요.' : '들고 있는 이유를\n숫자보다 먼저 나눠요.',
            style: serif(
              context,
              size: 20,
              weight: FontWeight.w800,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            isEditing
                ? '처음 남긴 답장과 기록은 유지하고, 내가 적은 내용만 고칠 수 있어요.'
                : '수량이나 금액 없이도 보유 상태와 지켜볼 점만 공유할 수 있어요.',
            style: sans(size: 12.5, color: AlagagiColors.muted, height: 1.6),
          ),
          const SizedBox(height: 16),
          AlagagiTextField(
            fieldKey: stockHoldingNameFieldKey,
            label: '종목명',
            hint: '예: 삼성전자, Apple',
            initialValue: state.stockHoldingDraftName,
            maxLength: 40,
            onChanged: (value) =>
                controller.updateStockHoldingDraft(name: value),
          ),
          const SizedBox(height: 12),
          _StockHoldingChoiceGroup(
            label: '보유 상태',
            options: stockHoldingStatusOptions,
            selected: state.stockHoldingDraftStatus,
            keyBuilder: stockHoldingStatusKey,
            onSelected: (value) =>
                controller.updateStockHoldingDraft(status: value),
          ),
          const SizedBox(height: 12),
          _StockHoldingChoiceGroup(
            label: '비중 느낌',
            options: stockHoldingWeightOptions,
            selected: state.stockHoldingDraftWeightLabel,
            keyBuilder: stockHoldingWeightKey,
            onSelected: (value) =>
                controller.updateStockHoldingDraft(weightLabel: value),
          ),
          const SizedBox(height: 10),
          AlagagiTextField(
            fieldKey: stockHoldingReasonFieldKey,
            label: '보유 이유',
            hint: '왜 들고 있는지',
            initialValue: state.stockHoldingDraftReason,
            maxLength: 120,
            maxLines: 2,
            onChanged: (value) =>
                controller.updateStockHoldingDraft(reason: value),
          ),
          const SizedBox(height: 10),
          AlagagiTextField(
            fieldKey: stockHoldingWatchFieldKey,
            label: '보고 싶은 점',
            hint: '앞으로 확인할 지점',
            initialValue: state.stockHoldingDraftWatchPoint,
            maxLength: 80,
            onChanged: (value) =>
                controller.updateStockHoldingDraft(watchPoint: value),
          ),
          const SizedBox(height: 10),
          AlagagiTextField(
            fieldKey: stockHoldingConcernFieldKey,
            label: '걱정 포인트',
            hint: '조심해서 볼 점',
            initialValue: state.stockHoldingDraftConcern,
            maxLength: 80,
            onChanged: (value) =>
                controller.updateStockHoldingDraft(concern: value),
          ),
          const SizedBox(height: 10),
          AlagagiTextField(
            fieldKey: stockHoldingQuestionFieldKey,
            label: '물어보고 싶은 점',
            hint: '상대에게 묻고 싶은 것',
            initialValue: state.stockHoldingDraftQuestion,
            maxLength: 100,
            maxLines: 2,
            onChanged: (value) =>
                controller.updateStockHoldingDraft(question: value),
          ),
          if (state.stockHoldingDraftError != null) ...[
            const SizedBox(height: 10),
            Text(
              state.stockHoldingDraftError!,
              style: sans(size: 12, color: AlagagiColors.sageDeep),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton(
                onPressed: controller.cancelStockHoldingDraft,
                child: Text(
                  '취소',
                  style: sans(size: 13, color: AlagagiColors.muted),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AlagagiPrimaryButton(
                  label: isEditing ? '수정 저장' : '보유 공유하기',
                  onPressed: controller.submitStockHoldingDraft,
                  color: AlagagiColors.sageDeep,
                  buttonKey: stockHoldingSubmitButtonKey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StockHoldingChoiceGroup extends StatelessWidget {
  const _StockHoldingChoiceGroup({
    required this.label,
    required this.options,
    required this.selected,
    required this.keyBuilder,
    required this.onSelected,
  });

  final String label;
  final List<String> options;
  final String selected;
  final Key Function(String value) keyBuilder;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: sans(
            size: 10.5,
            weight: FontWeight.w800,
            color: AlagagiColors.sageDeep,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: [
            for (final option in options)
              AlagagiFilterPill(
                key: keyBuilder(option),
                label: option,
                selected: selected == option,
                onTap: () => onSelected(option),
              ),
          ],
        ),
      ],
    );
  }
}

class _StockHoldingCard extends StatelessWidget {
  const _StockHoldingCard({required this.controller, required this.holding});

  final AlagagiController controller;
  final StockHolding holding;

  @override
  Widget build(BuildContext context) {
    final isMine = holding.createdByProfileId == controller.state.me.id;
    final creator = isMine
        ? controller.state.me.nickname
        : controller.state.partner.nickname;
    final isShared = controller.stockHoldingSharedByBoth(holding.name);
    final detailBody = [
      '보유 이유\n${holding.reason}',
      '보고 싶은 점\n${holding.watchPoint}',
      '걱정 포인트\n${holding.concern}',
      '물어보고 싶은 점\n${holding.question}',
      if (holding.hasReply)
        '${holding.replyTone ?? '답장'}\n${holding.reply!.trim()}',
    ].join('\n\n');
    return GestureDetector(
      key: stockHoldingCardKey(holding.id),
      behavior: HitTestBehavior.opaque,
      onTap: () => showReadableDetailSheet(
        context,
        label: '보유 주식',
        title: holding.name,
        meta: '$creator · ${holding.status} · ${holding.weightLabel}',
        body: detailBody,
      ),
      child: AlagagiPaperCard(
        radius: 19,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StockStoryMark(name: holding.name, isMine: isMine),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              holding.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: sans(
                                size: 14.2,
                                weight: FontWeight.w800,
                                color: const Color(0xFF33332F),
                              ),
                            ),
                          ),
                          if (isShared)
                            const AlagagiSmallBadge(label: '함께 보유 중')
                          else
                            AlagagiSmallBadge(label: holding.status),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$creator · ${holding.weightLabel}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: sans(size: 11.6, color: AlagagiColors.muted),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        holding.reason,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: sans(
                          size: 12.3,
                          color: const Color(0xFF6F6C65),
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StockStoryMiniBox(
                    label: '볼 점',
                    body: holding.watchPoint,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StockStoryMiniBox(label: '걱정', body: holding.concern),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _StockStoryQuestion(text: holding.question),
            if (holding.hasReply) ...[
              const SizedBox(height: 10),
              _StockHoldingReplyBlock(holding: holding),
            ] else if (!isMine) ...[
              const SizedBox(height: 12),
              _StockHoldingReplyComposer(
                controller: controller,
                holding: holding,
              ),
            ],
            if (controller.state.stockHoldingReplyError != null && !isMine) ...[
              const SizedBox(height: 8),
              Text(
                controller.state.stockHoldingReplyError!,
                style: sans(size: 12, color: AlagagiColors.sageDeep),
              ),
            ],
            if (isMine) ...[
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    key: stockHoldingEditButtonKey(holding.id),
                    onPressed: () =>
                        controller.startStockHoldingEdit(holding.id),
                    icon: const Icon(Icons.edit_outlined, size: 15),
                    label: const Text('수정'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AlagagiColors.sageDeep,
                      side: const BorderSide(color: Color(0x338A9A7E)),
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      textStyle: sans(size: 12, weight: FontWeight.w800),
                    ),
                  ),
                  OutlinedButton.icon(
                    key: stockHoldingDeleteButtonKey(holding.id),
                    onPressed: () => controller.deleteStockHolding(holding.id),
                    icon: const Icon(Icons.delete_outline_rounded, size: 15),
                    label: const Text('삭제'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF9A5A45),
                      side: const BorderSide(color: Color(0x339A5A45)),
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      textStyle: sans(size: 12, weight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StockHoldingReplyBlock extends StatelessWidget {
  const _StockHoldingReplyBlock({required this.holding});

  final StockHolding holding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2EA),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            holding.replyTone ?? '답장',
            style: sans(
              size: 10.5,
              weight: FontWeight.w800,
              color: AlagagiColors.sageDeep,
            ),
          ),
          const SizedBox(height: 5),
          Text(holding.reply ?? '', style: sans(size: 12.5, height: 1.5)),
        ],
      ),
    );
  }
}

class _StockHoldingReplyComposer extends StatelessWidget {
  const _StockHoldingReplyComposer({
    required this.controller,
    required this.holding,
  });

  final AlagagiController controller;
  final StockHolding holding;

  @override
  Widget build(BuildContext context) {
    final selectedTone = controller.stockHoldingReplyToneFor(holding.id);
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEFA),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(17),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '내 관점 남기기',
            style: sans(
              size: 11.5,
              weight: FontWeight.w800,
              color: AlagagiColors.sageDeep,
            ),
          ),
          const SizedBox(height: 9),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              for (final tone in stockStoryReplyToneOptions)
                AlagagiFilterPill(
                  key: stockHoldingReplyToneKey(holding.id, tone),
                  label: tone,
                  selected: selectedTone == tone,
                  onTap: () =>
                      controller.setStockHoldingReplyTone(holding.id, tone),
                ),
            ],
          ),
          const SizedBox(height: 9),
          TextField(
            key: stockHoldingReplyFieldKey(holding.id),
            minLines: 2,
            maxLines: 3,
            maxLength: 160,
            onChanged: (value) => controller.updateStockHoldingReplyDraft(
              holdingId: holding.id,
              value: value,
            ),
            decoration: InputDecoration(
              hintText: '같이 볼 숫자나 걱정되는 점만 남겨도 괜찮아요.',
              hintStyle: sans(size: 12.2, color: AlagagiColors.muted),
              counterText: '',
              filled: true,
              fillColor: const Color(0xFFF8F8F4),
              contentPadding: const EdgeInsets.all(12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AlagagiColors.line),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AlagagiColors.sageDeep),
              ),
            ),
            style: sans(size: 13, height: 1.45),
          ),
          const SizedBox(height: 9),
          AlagagiPrimaryButton(
            label: '관점 남기기',
            buttonKey: stockHoldingReplySubmitButtonKey(holding.id),
            onPressed: () => controller.submitStockHoldingReply(holding.id),
            color: AlagagiColors.sageDeep,
          ),
        ],
      ),
    );
  }
}
