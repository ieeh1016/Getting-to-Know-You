import 'package:flutter/material.dart';

import '../domain/alagagi_controller.dart';
import '../shared/ui_style.dart';
import 'test_keys.dart';

class AlagagiScreenScroll extends StatelessWidget {
  const AlagagiScreenScroll({
    super.key,
    required this.children,
    this.bottomNavigation,
    this.padding = const EdgeInsets.fromLTRB(28, 34, 28, 112),
  });

  final List<Widget> children;
  final Widget? bottomNavigation;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = bottomNavigation == null
        ? padding.bottom
        : padding.bottom > 72
        ? 24.0
        : padding.bottom;
    final effectivePadding = padding.copyWith(bottom: bottomPadding);

    final scrollable = ListView(
      padding: EdgeInsets.zero,
      children: [
        Padding(
          padding: effectivePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ],
    );

    if (bottomNavigation == null) {
      return scrollable;
    }

    return Column(
      children: [
        Expanded(child: scrollable),
        bottomNavigation!,
      ],
    );
  }
}

class AlagagiBottomNav extends StatelessWidget {
  const AlagagiBottomNav({super.key, required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: bottomNavigationKey,
      decoration: BoxDecoration(
        color: AlagagiColors.paper.withValues(alpha: 0.94),
        border: const Border(top: BorderSide(color: AlagagiColors.line)),
      ),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
      child: Row(
        children: [
          Expanded(
            child: _NavItem(
              icon: Icons.home_outlined,
              label: '홈',
              selected: controller.state.route == AlagagiRoute.home,
              onTap: () => controller.goTo(AlagagiRoute.home),
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.menu_book_outlined,
              label: '질문',
              selected:
                  controller.state.route == AlagagiRoute.archive ||
                  controller.state.route == AlagagiRoute.records,
              onTap: () => controller.goTo(AlagagiRoute.archive),
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.music_note_outlined,
              label: '음악',
              selected: controller.state.route == AlagagiRoute.music,
              showBadge:
                  controller.unreadCountForFeature(
                    UnreadActivityFeature.music,
                  ) >
                  0,
              onTap: () => controller.goTo(AlagagiRoute.music),
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.event_available_outlined,
              label: '약속',
              selected: controller.state.route == AlagagiRoute.meetings,
              showBadge:
                  controller.unreadCountForFeature(
                    UnreadActivityFeature.meetings,
                  ) >
                  0,
              onTap: () => controller.goTo(AlagagiRoute.meetings),
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.favorite_border_rounded,
              label: '만남',
              selected: controller.state.route == AlagagiRoute.meetingPlans,
              showBadge:
                  controller.unreadCountForFeature(
                    UnreadActivityFeature.meetings,
                  ) >
                  0,
              onTap: () => controller.goTo(AlagagiRoute.meetingPlans),
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.place_outlined,
              label: '장소',
              selected: controller.state.route == AlagagiRoute.places,
              showBadge:
                  controller.unreadCountForFeature(
                    UnreadActivityFeature.places,
                  ) >
                  0,
              onTap: () => controller.goTo(AlagagiRoute.places),
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.person_outline_rounded,
              label: '마이',
              selected: controller.state.route == AlagagiRoute.my,
              onTap: () => controller.goTo(AlagagiRoute.my),
            ),
          ),
        ],
      ),
    );
  }
}

class AlagagiTopBar extends StatelessWidget {
  const AlagagiTopBar({
    super.key,
    required this.title,
    required this.trailing,
    this.onBack,
  });

  final String title;
  final String trailing;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 56,
          child: Align(
            alignment: Alignment.centerLeft,
            child: onBack == null
                ? const SizedBox.shrink()
                : _BackButton(onTap: onBack!),
          ),
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: serif(
              context,
              size: 18,
              weight: FontWeight.w700,
              color: AlagagiColors.ink,
            ),
          ),
        ),
        SizedBox(
          width: 56,
          child: Text(
            trailing,
            textAlign: TextAlign.right,
            style: serif(
              context,
              size: 13,
              color: AlagagiColors.sageDeep,
              weight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.showBadge = false,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  size: 19,
                  color: selected ? AlagagiColors.ink : AlagagiColors.muted,
                ),
                if (showBadge)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFB18472),
                        border: Border.all(
                          color: AlagagiColors.paper,
                          width: 1.2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: sans(
                size: 10,
                weight: selected ? FontWeight.w700 : FontWeight.w400,
                color: selected ? AlagagiColors.ink : AlagagiColors.muted,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: selected ? 16 : 0,
              height: 4,
              decoration: BoxDecoration(
                color: selected ? AlagagiColors.sageDeep : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '뒤로',
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(19),
        child: InkWell(
          key: subScreenBackButtonKey,
          borderRadius: BorderRadius.circular(19),
          onTap: onTap,
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AlagagiColors.paper,
              border: Border.all(color: AlagagiColors.line),
              borderRadius: BorderRadius.circular(19),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A505046),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.chevron_left_rounded,
              size: 21,
              color: Color(0xFF656D5E),
            ),
          ),
        ),
      ),
    );
  }
}
