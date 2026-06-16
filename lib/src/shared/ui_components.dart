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

class AlagagiBrandLeafMark extends StatelessWidget {
  const AlagagiBrandLeafMark({super.key, this.size = 42, this.iconSize = 20});

  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AlagagiColors.paper,
        border: Border.all(color: AlagagiColors.line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F57624C),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Container(
        width: size * 0.62,
        height: size * 0.62,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFFEEF2EA), Color(0xFFFCFCFA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.eco_outlined,
          size: iconSize,
          color: AlagagiColors.sageDeep,
        ),
      ),
    );
  }
}

class AlagagiAvatarStack extends StatelessWidget {
  const AlagagiAvatarStack({
    super.key,
    required this.meAvatar,
    required this.partnerAvatar,
  });

  final String meAvatar;
  final String partnerAvatar;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 36,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: _AlagagiSmallAvatar(
              avatar: meAvatar,
              color: AlagagiColors.sagePanel,
            ),
          ),
          Positioned(
            left: 26,
            child: _AlagagiSmallAvatar(
              avatar: partnerAvatar,
              color: const Color(0xFFD8CCE2),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlagagiSmallAvatar extends StatelessWidget {
  const _AlagagiSmallAvatar({required this.avatar, required this.color});

  final String avatar;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: AlagagiColors.ink, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(avatar, style: const TextStyle(fontSize: 15)),
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

class AlagagiSmallBadge extends StatelessWidget {
  const AlagagiSmallBadge({super.key, required this.label, this.dark = false});

  final String label;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: dark
            ? Colors.white.withValues(alpha: 0.14)
            : const Color(0xFFF0F2EB),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      child: Text(
        label,
        style: sans(
          size: 10.5,
          color: dark ? Colors.white : AlagagiColors.sageDeep,
        ),
      ),
    );
  }
}

class AlagagiQuietMetric extends StatelessWidget {
  const AlagagiQuietMetric({
    super.key,
    required this.label,
    required this.value,
    this.muted = false,
  });

  final String label;
  final String value;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: muted ? const Color(0xFFF8F8F4) : const Color(0xFFF1F4EC),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: sans(size: 10.5, color: AlagagiColors.muted)),
          const SizedBox(height: 4),
          Text(
            value,
            style: serif(
              context,
              size: 19,
              weight: FontWeight.w800,
              color: muted ? AlagagiColors.muted : AlagagiColors.sageDeep,
            ),
          ),
        ],
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

class AlagagiFullTextCue extends StatelessWidget {
  const AlagagiFullTextCue({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '전체 보기',
      button: true,
      child: Container(
        constraints: const BoxConstraints(minHeight: 30),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F4ED),
          border: Border.all(color: const Color(0x336F7F63)),
          borderRadius: BorderRadius.circular(999),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '펼쳐 읽기',
              style: sans(
                size: 11.5,
                weight: FontWeight.w800,
                color: AlagagiColors.sageDeep,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right_rounded,
              size: 15,
              color: AlagagiColors.sageDeep,
            ),
          ],
        ),
      ),
    );
  }
}
