import 'package:flutter/material.dart';

import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/ui_components.dart';
import '../../shared/ui_style.dart';

class HomeProgressSummaryCard extends StatelessWidget {
  const HomeProgressSummaryCard({super.key, required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final summary = controller.homeProgressSummary;
    return _HomeSummaryCardContainer(
      key: homeProgressSummaryKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AlagagiColors.midnight,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.fromLTRB(15, 14, 14, 14),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.route_rounded,
                    size: 18,
                    color: Color(0xFFEFD797),
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Text(
                    '오늘의 작은 흐름',
                    style: serif(
                      context,
                      size: 17,
                      weight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                AlagagiSmallBadge(label: '우리 상태판', dark: true),
              ],
            ),
          ),
          const SizedBox(height: 14),
          for (var index = 0; index < summary.items.length; index++) ...[
            if (index > 0) const SizedBox(height: 8),
            _HomeProgressSummaryRow(
              item: summary.items[index],
              isLast: index == summary.items.length - 1,
            ),
          ],
          if (summary.primaryAction != null) ...[
            const SizedBox(height: 10),
            _SecondaryActionButton(
              key: homeProgressSummaryCtaKey,
              label: summary.primaryAction!.label,
              icon: Icons.arrow_forward_rounded,
              onPressed: controller.activateHomeProgressSummaryAction,
            ),
          ],
        ],
      ),
    );
  }
}

class _HomeSummaryCardContainer extends StatelessWidget {
  const _HomeSummaryCardContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AlagagiColors.creamPanel, AlagagiColors.paper],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0x33B99856)),
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F2F2E2A),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
      child: child,
    );
  }
}

class _HomeProgressSummaryRow extends StatelessWidget {
  const _HomeProgressSummaryRow({required this.item, required this.isLast});

  final HomeProgressSummaryItem item;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = _summaryToneColor(item.tone);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(11, 11, 12, 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: _summaryToneFill(item.tone),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: AlagagiColors.line),
                ),
                alignment: Alignment.center,
                child: Icon(_summaryIcon(item.id), size: 17, color: color),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 18,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: sans(size: 10.5, color: AlagagiColors.muted),
                ),
                const SizedBox(height: 3),
                Text(
                  item.stateText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: sans(
                    size: 13,
                    weight: FontWeight.w500,
                    color: const Color(0xFF4C4B46),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Icon(Icons.chevron_right_rounded, size: 18, color: color),
        ],
      ),
    );
  }
}

IconData _summaryIcon(String id) {
  return switch (id) {
    'todayQuestion' => Icons.notes_rounded,
    'bothAnswered' => Icons.lock_open_rounded,
    'music' => Icons.music_note_rounded,
    _ => Icons.circle_outlined,
  };
}

Color _summaryToneColor(HomeProgressSummaryTone tone) {
  return switch (tone) {
    HomeProgressSummaryTone.ready => AlagagiColors.sageDeep,
    HomeProgressSummaryTone.waiting => const Color(0xFFB18472),
    HomeProgressSummaryTone.calm => const Color(0xFFC7C3BA),
  };
}

Color _summaryToneFill(HomeProgressSummaryTone tone) {
  return switch (tone) {
    HomeProgressSummaryTone.ready => AlagagiColors.sagePanel,
    HomeProgressSummaryTone.waiting => const Color(0xFFF5F1E9),
    HomeProgressSummaryTone.calm => const Color(0xFFF8F8F4),
  };
}

class _SecondaryActionButton extends StatelessWidget {
  const _SecondaryActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 15),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: AlagagiColors.sageDeep,
          side: const BorderSide(color: Color(0x338A9A7E)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: serif(context, size: 13.5, weight: FontWeight.w800),
        ),
      ),
    );
  }
}
