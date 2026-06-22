import 'package:flutter/material.dart';

import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
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
          Row(
            children: [
              Expanded(
                child: Text(
                  '오늘 우리 흐름',
                  style: serif(context, size: 16, weight: FontWeight.w800),
                ),
              ),
              Text('가볍게 확인', style: sans(size: 11, color: AlagagiColors.muted)),
            ],
          ),
          const SizedBox(height: 8),
          for (var index = 0; index < summary.items.length; index++) ...[
            if (index > 0) const Divider(height: 1, color: AlagagiColors.line),
            _HomeProgressSummaryRow(item: summary.items[index]),
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
        color: AlagagiColors.paper,
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(22),
      ),
      padding: const EdgeInsets.fromLTRB(17, 16, 17, 14),
      child: child,
    );
  }
}

class _HomeProgressSummaryRow extends StatelessWidget {
  const _HomeProgressSummaryRow({required this.item});

  final HomeProgressSummaryItem item;

  @override
  Widget build(BuildContext context) {
    final color = _summaryToneColor(item.tone);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _summaryToneFill(item.tone),
              border: Border.all(color: AlagagiColors.line),
            ),
            alignment: Alignment.center,
            child: Icon(_summaryIcon(item.id), size: 17, color: color),
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
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
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
