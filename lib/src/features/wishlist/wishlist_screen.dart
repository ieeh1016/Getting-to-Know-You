import 'package:flutter/material.dart';

import '../../app/app_shell.dart';
import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/ui_components.dart';
import '../../shared/ui_style.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key, required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final wishes = controller.visibleWishes;
    final mutualWishes = wishes
        .where((wish) => wish.isMutual && !wish.done)
        .toList();
    final quietWishes = wishes
        .where((wish) => !wish.isMutual && !wish.done)
        .toList();
    final doneWishes = wishes.where((wish) => wish.done).toList();

    return AlagagiScreenScroll(
      bottomNavigation: AlagagiBottomNav(controller: controller),
      children: [
        AlagagiTopBar(
          title: '언젠가, 같이',
          trailing: '',
          onBack: () => controller.goTo(AlagagiRoute.home),
        ),
        const SizedBox(height: 4),
        Text(
          '언젠가 해볼 만한 것을 가볍게 적어둬요',
          style: sans(size: 12.5, color: AlagagiColors.muted),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: _WishlistAddButton(controller: controller),
        ),
        if (controller.state.wishDraftVisible) ...[
          const SizedBox(height: 14),
          _WishDraftCard(controller: controller),
        ],
        const SizedBox(height: 16),
        _WishlistHero(
          mutualCount: mutualWishes.length,
          totalCount: wishes.length,
          doneCount: doneWishes.length,
        ),
        const SizedBox(height: 14),
        _WishlistFilters(controller: controller),
        const SizedBox(height: 18),
        _WishlistBoard(
          wishes: wishes,
          mutualWishes: mutualWishes,
          quietWishes: quietWishes,
          doneWishes: doneWishes,
          controller: controller,
        ),
      ],
    );
  }
}

class _WishlistHero extends StatelessWidget {
  const _WishlistHero({
    required this.mutualCount,
    required this.totalCount,
    required this.doneCount,
  });

  final int mutualCount;
  final int totalCount;
  final int doneCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AlagagiColors.paper, Color(0xFFF3F5EE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'QUIET BOARD',
            style: sans(
              size: 10.5,
              color: AlagagiColors.sageDeep,
              weight: FontWeight.w700,
              letterSpacing: 2.2,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            '같이 해볼 일을\n가볍게 모아둬요',
            style: serif(
              context,
              size: 22,
              weight: FontWeight.w800,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            '바로 약속을 정하지 않아도 괜찮아요. 서로 관심이 겹치면 다음에 꺼내기 쉬워집니다.',
            style: sans(size: 12.5, color: AlagagiColors.muted, height: 1.65),
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              Expanded(
                child: _WishlistSummaryTile(
                  value: '$mutualCount',
                  label: '서로 관심',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _WishlistSummaryTile(
                  value: '$totalCount',
                  label: '담아둔 것',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _WishlistSummaryTile(value: '$doneCount', label: '함께함'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WishlistSummaryTile extends StatelessWidget {
  const _WishlistSummaryTile({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xBFFFFFFA),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: sans(
              size: 15,
              color: AlagagiColors.ink,
              weight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: sans(size: 10.5, color: AlagagiColors.muted, height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _WishlistAddButton extends StatelessWidget {
  const _WishlistAddButton({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: OutlinedButton.icon(
        key: wishAddButtonKey,
        onPressed: controller.startWishDraft,
        icon: const Icon(Icons.add_rounded, size: 16),
        label: const Text('하고 싶은 것 담기'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AlagagiColors.sageDeep,
          side: const BorderSide(color: Color(0x338A9A7E)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          textStyle: sans(size: 12, weight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _WishlistBoard extends StatelessWidget {
  const _WishlistBoard({
    required this.wishes,
    required this.mutualWishes,
    required this.quietWishes,
    required this.doneWishes,
    required this.controller,
  });

  final List<WishItem> wishes;
  final List<WishItem> mutualWishes;
  final List<WishItem> quietWishes;
  final List<WishItem> doneWishes;
  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    if (wishes.isEmpty) {
      return const AlagagiEmptyStateCard(text: '같이 해보고 싶은 걸 하나만 담아볼까요?');
    }
    return Column(
      key: wishlistBoardKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _WishlistLane(
          title: '서로 관심 있어요',
          meta: '다음에 꺼내기 좋은 것',
          wishes: mutualWishes,
          emptyText: '서로 관심이 겹친 항목은 여기에 모여요.',
          controller: controller,
        ),
        const SizedBox(height: 18),
        _WishlistLane(
          title: '조용한 제안',
          meta: '관심 표시 전',
          wishes: quietWishes,
          emptyText: '아직 한 명만 담아둔 제안이 없어요.',
          controller: controller,
        ),
        const SizedBox(height: 18),
        _WishlistLane(
          title: '함께했어요',
          meta: '가볍게 남은 기록',
          wishes: doneWishes,
          emptyText: '함께한 뒤에는 여기에 조용히 쌓여요.',
          controller: controller,
        ),
      ],
    );
  }
}

class _WishlistLane extends StatelessWidget {
  const _WishlistLane({
    required this.title,
    required this.meta,
    required this.wishes,
    required this.emptyText,
    required this.controller,
  });

  final String title;
  final String meta;
  final List<WishItem> wishes;
  final String emptyText;
  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: serif(context, size: 16, weight: FontWeight.w800),
              ),
            ),
            Text(meta, style: sans(size: 11.5, color: AlagagiColors.muted)),
          ],
        ),
        const SizedBox(height: 10),
        if (wishes.isEmpty)
          AlagagiInlineEmptyState(text: emptyText)
        else
          for (final wish in wishes) ...[
            _WishCard(
              wish: wish,
              meId: controller.state.me.id,
              partnerId: controller.state.partner.id,
              partnerName: controller.state.partner.nickname,
              onInterest: () => controller.toggleWishLike(wish.id),
            ),
            const SizedBox(height: 10),
          ],
      ],
    );
  }
}

class _WishDraftCard extends StatelessWidget {
  const _WishDraftCard({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return AlagagiPaperCard(
      radius: 18,
      padding: const EdgeInsets.all(16),
      highlightedBorder: AlagagiColors.sage,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '새 위시 담기',
            style: serif(context, size: 17, weight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            '언젠가 같이 해보고 싶은 걸 한 줄로 적어봐요.',
            style: sans(size: 12.5, color: AlagagiColors.muted),
          ),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AlagagiColors.line),
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: TextField(
              key: wishTitleFieldKey,
              maxLength: 60,
              onChanged: controller.updateWishDraftTitle,
              decoration: const InputDecoration(
                border: InputBorder.none,
                counterText: '',
                hintText: '예: 한강에서 같이 산책하기',
              ),
              style: sans(size: 13.5),
            ),
          ),
          if (controller.state.wishDraftError != null) ...[
            const SizedBox(height: 8),
            Text(
              controller.state.wishDraftError!,
              style: sans(size: 12, color: AlagagiColors.sageDeep),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AlagagiFilterPill(
                label: '가고 싶은 곳',
                selected: controller.state.wishDraftKind == WishKind.place,
                onTap: () => controller.setWishDraftKind(WishKind.place),
              ),
              AlagagiFilterPill(
                label: '해보고 싶은 것',
                selected: controller.state.wishDraftKind == WishKind.activity,
                onTap: () => controller.setWishDraftKind(WishKind.activity),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton(
                onPressed: controller.cancelWishDraft,
                child: Text(
                  '취소',
                  style: sans(size: 13, color: AlagagiColors.muted),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AlagagiPrimaryButton(
                  label: '담기',
                  onPressed: controller.submitWishDraft,
                  color: AlagagiColors.sageDeep,
                  buttonKey: wishSubmitButtonKey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WishlistFilters extends StatelessWidget {
  const _WishlistFilters({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        AlagagiFilterPill(
          label: '전체',
          selected: controller.state.wishlistFilter == WishlistFilter.all,
          onTap: () => controller.setWishlistFilter(WishlistFilter.all),
        ),
        AlagagiFilterPill(
          label: '서로 관심',
          selected: controller.state.wishlistFilter == WishlistFilter.mutual,
          onTap: () => controller.setWishlistFilter(WishlistFilter.mutual),
        ),
        AlagagiFilterPill(
          label: '가고 싶은 곳',
          selected: controller.state.wishlistFilter == WishlistFilter.places,
          onTap: () => controller.setWishlistFilter(WishlistFilter.places),
        ),
        AlagagiFilterPill(
          label: '해보고 싶은 것',
          selected:
              controller.state.wishlistFilter == WishlistFilter.activities,
          onTap: () => controller.setWishlistFilter(WishlistFilter.activities),
        ),
      ],
    );
  }
}

class _WishCard extends StatelessWidget {
  const _WishCard({
    required this.wish,
    required this.meId,
    required this.partnerId,
    required this.partnerName,
    required this.onInterest,
  });

  final WishItem wish;
  final String meId;
  final String partnerId;
  final String partnerName;
  final VoidCallback onInterest;

  @override
  Widget build(BuildContext context) {
    final likedByMe = wish.likedByProfileIds.contains(meId);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onInterest,
        child: Container(
          decoration: BoxDecoration(
            color: wish.isMutual ? null : AlagagiColors.paper,
            gradient: wish.isMutual
                ? const LinearGradient(
                    colors: [Color(0xFFEEF1E8), Color(0xFFE6ECDC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            border: Border.all(
              color: wish.isMutual ? AlagagiColors.sage : AlagagiColors.line,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2EB),
                  borderRadius: BorderRadius.circular(13),
                ),
                alignment: Alignment.center,
                child: _WishKindIcon(kind: wish.kind, done: wish.done),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wish.title,
                      style:
                          sans(
                            size: 14.5,
                            weight: FontWeight.w500,
                            color: wish.done
                                ? AlagagiColors.muted
                                : const Color(0xFF33332F),
                          ).copyWith(
                            decoration: wish.done
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      wish.isMutual
                          ? '둘 다 표시함'
                          : wish.createdByProfileId == partnerId
                          ? '$partnerName님이 담음'
                          : '내가 담음',
                      style: sans(size: 11, color: AlagagiColors.muted),
                    ),
                  ],
                ),
              ),
              _InterestBadge(
                label: wish.done
                    ? '완료'
                    : likedByMe
                    ? '관심 표시됨'
                    : '관심 표시',
                selected: likedByMe || wish.done,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WishKindIcon extends StatelessWidget {
  const _WishKindIcon({required this.kind, required this.done});

  final WishKind kind;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Icon(
      kind == WishKind.place
          ? Icons.place_outlined
          : Icons.lightbulb_outline_rounded,
      size: 22,
      color: done ? AlagagiColors.muted : AlagagiColors.sageDeep,
    );
  }
}

class _InterestBadge extends StatelessWidget {
  const _InterestBadge({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 42),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: selected ? AlagagiColors.sageDeep : Colors.white,
        border: Border.all(
          color: selected ? AlagagiColors.sageDeep : AlagagiColors.line,
        ),
        borderRadius: BorderRadius.circular(999),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: sans(
          size: 11,
          weight: FontWeight.w700,
          color: selected ? Colors.white : AlagagiColors.sageDeep,
        ),
      ),
    );
  }
}
