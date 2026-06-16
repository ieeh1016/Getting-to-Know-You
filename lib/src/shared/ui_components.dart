import 'package:flutter/material.dart';

import 'ui_style.dart';

class AlagagiSectionLabel extends StatelessWidget {
  const AlagagiSectionLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: sans(size: 11, color: AlagagiColors.muted, letterSpacing: 3),
    );
  }
}

class AlagagiPrimaryButton extends StatelessWidget {
  const AlagagiPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = AlagagiColors.ink,
    this.buttonKey,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final Key? buttonKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        key: buttonKey,
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: AlagagiColors.appBackground,
          padding: const EdgeInsets.symmetric(vertical: 17),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: serif(context, size: 15, weight: FontWeight.w700),
        ),
        child: Text(label, textAlign: TextAlign.center),
      ),
    );
  }
}

class AlagagiPaperCard extends StatelessWidget {
  const AlagagiPaperCard({
    super.key,
    required this.child,
    required this.radius,
    required this.padding,
    this.dashed = false,
    this.highlightedBorder,
  });

  final Widget child;
  final double radius;
  final EdgeInsets padding;
  final bool dashed;
  final Color? highlightedBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: dashed ? Colors.transparent : AlagagiColors.paper,
        border: Border.all(
          color: highlightedBorder ?? AlagagiColors.line,
          width: dashed ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(radius),
      ),
      padding: padding,
      child: child,
    );
  }
}

class AlagagiEmptyStateCard extends StatelessWidget {
  const AlagagiEmptyStateCard({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return AlagagiPaperCard(
      radius: 18,
      padding: const EdgeInsets.all(18),
      dashed: true,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: sans(size: 13, color: AlagagiColors.muted, height: 1.6),
      ),
    );
  }
}

class AlagagiFilterPill extends StatelessWidget {
  const AlagagiFilterPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? AlagagiColors.ink : Colors.white,
          border: Border.all(
            color: selected ? AlagagiColors.ink : AlagagiColors.line,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          label,
          style: sans(
            size: 12.5,
            color: selected ? AlagagiColors.appBackground : AlagagiColors.muted,
          ),
        ),
      ),
    );
  }
}

class AlagagiKeywordChip extends StatelessWidget {
  const AlagagiKeywordChip({super.key, required this.label, this.leaf = false});

  final String label;
  final bool leaf;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AlagagiColors.paper,
        border: leaf ? Border.all(color: AlagagiColors.line) : null,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Text(
        label,
        style: sans(size: 11.5, color: const Color(0xFF5A5A54)),
      ),
    );
  }
}

class AlagagiSimilarityBadge extends StatelessWidget {
  const AlagagiSimilarityBadge({super.key, required this.keyword});

  final String keyword;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEEF1E8),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: Text(
        '둘 다 ‘$keyword’ 취향',
        style: sans(size: 11, color: AlagagiColors.sageDeep),
      ),
    );
  }
}

class AlagagiSegmentButton extends StatelessWidget {
  const AlagagiSegmentButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? AlagagiColors.ink : Colors.white,
          border: Border.all(
            color: selected ? AlagagiColors.ink : AlagagiColors.line,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(vertical: 9),
        alignment: Alignment.center,
        child: Text(
          label,
          style: sans(
            size: 12.5,
            color: selected ? AlagagiColors.appBackground : AlagagiColors.muted,
          ),
        ),
      ),
    );
  }
}

class AlagagiProgressDots extends StatelessWidget {
  const AlagagiProgressDots({
    super.key,
    required this.activeIndex,
    required this.count,
  });

  final int activeIndex;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final active = activeIndex == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: active ? 20 : 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: active ? AlagagiColors.sageDeep : const Color(0xFFD5D3CA),
            borderRadius: BorderRadius.circular(6),
          ),
        );
      }),
    );
  }
}
