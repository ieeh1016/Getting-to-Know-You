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
    final nextDate = controller.nextMeetingDayEntry;
    final nextDateKey = nextDate?.dateKey;
    final planCount = nextDateKey == null
        ? 0
        : controller.meetingPlanItemCountFor(nextDateKey);
    final myAnswer = controller.todayMyAnswer;
    final partnerAnswer = controller.todayPartnerAnswer;
    final dayCount = controller.relationshipDayCount;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF315F7A), AlagagiColors.blue, AlagagiColors.sky],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0x332F2E2A)),
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x23302F2A),
            blurRadius: 26,
            offset: Offset(0, 16),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const Positioned(right: 22, top: 20, child: _HeroStripe(width: 74)),
          const Positioned(right: 38, top: 34, child: _HeroStripe(width: 44)),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        controller.relationshipStartedLabel,
                        style: sans(
                          size: 11,
                          weight: FontWeight.w800,
                          color: const Color(0xFFEDE8DA),
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                    _HeroProfilePill(
                      meAvatar: controller.state.me.avatar,
                      partnerAvatar: controller.state.partner.avatar,
                    ),
                  ],
                ),
                const SizedBox(height: 26),
                Text(
                  '우리의 시간',
                  style: sans(
                    size: 12,
                    weight: FontWeight.w800,
                    color: const Color(0xFFD7D0BD),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  dayCount == null
                      ? controller.relationshipDayLabel
                      : '$dayCount일째',
                  style: serif(
                    context,
                    size: 42,
                    weight: FontWeight.w800,
                    color: AlagagiColors.paper,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  controller.state.personalization.homeLine,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: sans(
                    size: 13,
                    color: const Color(0xFFF0ECE2),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _HeroSignalTile(
                        label: '오늘 질문',
                        value: 'DAY ${controller.todayQuestion.day}',
                        detail: _questionSignalText(myAnswer, partnerAnswer),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _HeroSignalTile(
                        label: '다음 데이트',
                        value: _dateSignalText(nextDateKey),
                        detail: planCount == 0 ? '계획 채우기' : '계획 $planCount개',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _HeroSignalTile(
                        label: '우리 기록',
                        value: '${controller.insight.questionCount}개',
                        detail: '주고받은 질문',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroStripe extends StatelessWidget {
  const _HeroStripe({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 3,
      decoration: BoxDecoration(
        color: const Color(0x55FFFEFA),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _HeroProfilePill extends StatelessWidget {
  const _HeroProfilePill({required this.meAvatar, required this.partnerAvatar});

  final String meAvatar;
  final String partnerAvatar;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x26FFFEFA),
        border: Border.all(color: const Color(0x35FFFEFA)),
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.fromLTRB(8, 5, 9, 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(meAvatar, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 2),
          Text(partnerAvatar, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 6),
          Text(
            '우리 둘',
            style: sans(
              size: 10.5,
              weight: FontWeight.w800,
              color: AlagagiColors.paper,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSignalTile extends StatelessWidget {
  const _HeroSignalTile({
    required this.label,
    required this.value,
    required this.detail,
  });

  final String label;
  final String value;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      decoration: BoxDecoration(
        color: const Color(0x22FFFEFA),
        border: Border.all(color: const Color(0x2EFFFEFA)),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: sans(
              size: 10.2,
              weight: FontWeight.w700,
              color: const Color(0xFFD7D0BD),
            ),
          ),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: serif(
              context,
              size: 17,
              weight: FontWeight.w800,
              color: AlagagiColors.paper,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            detail,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: sans(size: 10.5, color: const Color(0xFFEDE8DA)),
          ),
        ],
      ),
    );
  }
}

String _questionSignalText(Answer? myAnswer, Answer? partnerAnswer) {
  if (myAnswer == null || myAnswer.skipped) {
    return '내 답 기다림';
  }
  if (partnerAnswer == null) {
    return '상대 답 기다림';
  }
  return '함께 열림';
}

String _dateSignalText(String? dateKey) {
  if (dateKey == null) {
    return '정하는 중';
  }
  final date = DateTime.tryParse(dateKey);
  if (date == null) {
    return dateKey;
  }
  return '${date.month}.${date.day}';
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
                  '우리 메뉴',
                  style: serif(context, size: 21, weight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  '둘이 자주 꺼내볼 기록과 계획을 한곳에 모았어요.',
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
                  rowKey: homeMenuMemoryButtonKey,
                  icon: Icons.bookmark_added_outlined,
                  title: '서로의 기억',
                  subtitle: '잊고 싶지 않은 대화 내용을 직접 카드로 남기기',
                  badgeCount: controller.unreadCountForFeature(
                    UnreadActivityFeature.memoryCards,
                  ),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    controller.goTo(AlagagiRoute.memoryCards);
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
                  title: '우리 선택',
                  subtitle: '다음 데이트 힌트가 되는 선택 남기기',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    controller.goTo(AlagagiRoute.balance);
                  },
                ),
                const SizedBox(height: 8),
                _HomeMenuRow(
                  rowKey: homeMenuProfileCardButtonKey,
                  icon: Icons.badge_outlined,
                  title: '서로 노트',
                  subtitle: '취향과 마음을 편한 만큼 채우기',
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
