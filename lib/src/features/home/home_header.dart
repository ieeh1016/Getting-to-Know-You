import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/ui_components.dart';
import '../../shared/ui_style.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.controller,
    required this.brandKicker,
    required this.onOpenMenu,
  });

  final AlagagiController controller;
  final String brandKicker;
  final VoidCallback onOpenMenu;

  @override
  Widget build(BuildContext context) {
    final unreadCount = controller.totalUnreadActivityCount;
    return Row(
      children: [
        Expanded(
          child: Semantics(
            key: homeBrandLogoKey,
            label: '${controller.state.personalization.appTitle} 로고',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const AlagagiBrandLeafMark(),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Text(
                        controller.state.personalization.appTitle,
                        style: serif(
                          context,
                          size: 24,
                          weight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Padding(
                  padding: const EdgeInsets.only(left: 53),
                  child: Text(
                    brandKicker,
                    style: sans(
                      size: 10.5,
                      weight: FontWeight.w800,
                      color: AlagagiColors.sageDeep,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Tooltip(
          message: '조금씩 메뉴',
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                key: homeMenuButtonKey,
                onPressed: onOpenMenu,
                icon: const Icon(Icons.menu_rounded, size: 20),
                color: AlagagiColors.sageDeep,
                style: IconButton.styleFrom(
                  backgroundColor: AlagagiColors.paper,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: AlagagiColors.line),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  fixedSize: const Size(42, 42),
                ),
              ),
              if (unreadCount > 0)
                Positioned(
                  right: -2,
                  top: -4,
                  child: _UnreadCountBadge(count: unreadCount),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class HomeProgressStrip extends StatelessWidget {
  const HomeProgressStrip({super.key, required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AlagagiColors.ink,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DAY ${controller.todayQuestion.day} · 서로의 ${controller.todayQuestion.number}번째 질문',
                  style: sans(
                    size: 11,
                    color: const Color(0xFFB8B6AD),
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  controller.state.personalization.homeLine,
                  style: serif(
                    context,
                    size: 16,
                    weight: FontWeight.w700,
                    color: AlagagiColors.appBackground,
                  ),
                ),
              ],
            ),
          ),
          AlagagiAvatarStack(
            meAvatar: controller.state.me.avatar,
            partnerAvatar: controller.state.partner.avatar,
          ),
        ],
      ),
    );
  }
}

void showHomeMenuSheet({
  required BuildContext context,
  required AlagagiController controller,
  required VoidCallback onOpenCuriosity,
  required VoidCallback onOpenGuideBook,
  Future<void> Function()? onRefresh,
  bool isRefreshing = false,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      final maxHeight = MediaQuery.sizeOf(sheetContext).height * 0.88;
      return SafeArea(
        child: Container(
          key: homeMenuSheetKey,
          margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          constraints: BoxConstraints(maxHeight: maxHeight),
          decoration: BoxDecoration(
            color: AlagagiColors.paper,
            border: Border.all(color: AlagagiColors.line),
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Color(0x2E2C2B25),
                blurRadius: 44,
                offset: Offset(0, 18),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(18, 11, 18, 18),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD7D5CC),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 17),
                Text(
                  '기능 모아보기',
                  style: serif(context, size: 21, weight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  '오늘 질문을 방해하지 않는 선에서, 가끔 꺼내볼 기능을 한곳에 모았어요.',
                  style: sans(
                    size: 12.3,
                    color: AlagagiColors.muted,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 14),
                if (onRefresh != null) ...[
                  _HomeMenuRow(
                    rowKey: homeMenuRefreshButtonKey,
                    icon: isRefreshing
                        ? Icons.hourglass_top_rounded
                        : Icons.refresh_rounded,
                    title: isRefreshing ? '최신 내용 확인 중' : '최신 내용 확인',
                    subtitle: '상대가 새로 남긴 내용을 다시 불러오기',
                    onTap: isRefreshing
                        ? null
                        : () {
                            Navigator.of(sheetContext).pop();
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              unawaited(onRefresh());
                            });
                          },
                  ),
                  const SizedBox(height: 12),
                ],
                _HomeMenuRow(
                  rowKey: homeMenuCuriosityButtonKey,
                  icon: Icons.question_answer_outlined,
                  title: '궁금함 한 장',
                  subtitle: '상대에게 짧게 물어보기',
                  badgeCount: controller.unreadCountForFeature(
                    UnreadActivityFeature.curiosity,
                  ),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    controller.markFeatureSeen(UnreadActivityFeature.curiosity);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      onOpenCuriosity();
                    });
                  },
                ),
                const SizedBox(height: 8),
                _HomeMenuRow(
                  rowKey: homeMenuStockStoryButtonKey,
                  icon: Icons.bar_chart_rounded,
                  title: '주식 이야기',
                  subtitle: '관심 종목과 걱정 포인트를 함께 보기',
                  badgeCount: controller.unreadCountForFeature(
                    UnreadActivityFeature.stocks,
                  ),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    controller.goTo(AlagagiRoute.stockStory);
                  },
                ),
                const SizedBox(height: 8),
                _HomeMenuRow(
                  rowKey: homeMenuImprovementButtonKey,
                  icon: Icons.rate_review_outlined,
                  title: '건의함',
                  subtitle: '개선 아이디어와 추가 요청 남기기',
                  badgeCount: controller.unreadCountForFeature(
                    UnreadActivityFeature.improvements,
                  ),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    controller.goTo(AlagagiRoute.improvements);
                  },
                ),
                const SizedBox(height: 8),
                _HomeMenuRow(
                  rowKey: homeMenuBalanceButtonKey,
                  icon: Icons.swap_horiz_rounded,
                  title: '취향 매치',
                  subtitle: '둘 중 하나를 고르고 서로의 취향 보기',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    controller.goTo(AlagagiRoute.balance);
                  },
                ),
                const SizedBox(height: 8),
                _HomeMenuRow(
                  rowKey: homeMenuProfileCardButtonKey,
                  icon: Icons.badge_outlined,
                  title: '소개 카드',
                  subtitle: '취향과 대화 방식을 편한 만큼 채우기',
                  badgeCount: controller.unreadCountForFeature(
                    UnreadActivityFeature.profileCard,
                  ),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    if (controller.unreadCountForFeature(
                          UnreadActivityFeature.profileCard,
                        ) >
                        0) {
                      controller.setProfileCardTab(ProfileCardTab.partner);
                    } else {
                      controller.setProfileCardTab(ProfileCardTab.me);
                    }
                    controller.goTo(AlagagiRoute.profileCard);
                  },
                ),
                const SizedBox(height: 8),
                _HomeMenuRow(
                  rowKey: homeMenuWishlistButtonKey,
                  icon: Icons.bookmark_add_outlined,
                  title: '언젠가, 같이',
                  subtitle: '같이 해보고 싶은 일을 조용히 담기',
                  badgeCount: controller.unreadCountForFeature(
                    UnreadActivityFeature.wishlist,
                  ),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    controller.goTo(AlagagiRoute.wishlist);
                  },
                ),
                const SizedBox(height: 8),
                _HomeMenuRow(
                  rowKey: homeMenuGuideButtonKey,
                  icon: Icons.info_outline_rounded,
                  title: '처음 안내',
                  subtitle: '조금씩 사용하는 방법 다시 보기',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      onOpenGuideBook();
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _HomeMenuRow extends StatelessWidget {
  const _HomeMenuRow({
    required this.rowKey,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.badgeCount = 0,
  });

  final Key rowKey;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: rowKey,
        borderRadius: BorderRadius.circular(17),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 64),
          decoration: BoxDecoration(
            color: enabled ? const Color(0xFFF8F8F4) : const Color(0xFFF1F0EB),
            border: Border.all(color: AlagagiColors.line),
            borderRadius: BorderRadius.circular(17),
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2EA),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  size: 19,
                  color: enabled
                      ? AlagagiColors.sageDeep
                      : const Color(0xFF9A988E),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: sans(
                        size: 13.1,
                        weight: FontWeight.w800,
                        color: enabled
                            ? const Color(0xFF46443F)
                            : const Color(0xFF77746C),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: sans(
                        size: 11.2,
                        color: AlagagiColors.muted,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              if (badgeCount > 0) ...[
                const SizedBox(width: 8),
                _UnreadCountBadge(count: badgeCount),
              ],
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AlagagiColors.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UnreadCountBadge extends StatelessWidget {
  const _UnreadCountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      constraints: const BoxConstraints(minWidth: 22),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFB18472),
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: Text(
        count > 9 ? '9+' : '$count',
        style: sans(size: 10.5, weight: FontWeight.w900, color: Colors.white),
      ),
    );
  }
}
