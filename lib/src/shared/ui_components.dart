import 'package:flutter/material.dart';

import 'ui_style.dart';

class AlagagiSectionLabel extends StatelessWidget {
  const AlagagiSectionLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 2,
          decoration: BoxDecoration(
            color: AlagagiColors.rose,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: sans(
              size: 10.8,
              color: const Color(0xFF6F6A60),
              weight: FontWeight.w900,
              letterSpacing: 2.2,
            ),
          ),
        ),
      ],
    );
  }
}

class AlagagiHeroStat {
  const AlagagiHeroStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}

class AlagagiFeatureHero extends StatelessWidget {
  const AlagagiFeatureHero({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.stats = const [],
    this.gradient = const [AlagagiColors.midnight, AlagagiColors.moss],
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<AlagagiHeroStat> stats;
  final List<Color> gradient;

  @override
  Widget build(BuildContext context) {
    final visibleStats = stats.take(3).toList();
    return Container(
      decoration: BoxDecoration(
        color: gradient.first,
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F2F2E2A),
            blurRadius: 24,
            offset: Offset(0, 14),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.14),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 6,
                ),
                child: Text(
                  eyebrow,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: sans(
                    size: 10.2,
                    weight: FontWeight.w900,
                    color: const Color(0xFFFFF4DF),
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 21, color: const Color(0xFFEFD797)),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: serif(
              context,
              size: 24,
              weight: FontWeight.w800,
              height: 1.32,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            subtitle,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: sans(
              size: 12.5,
              color: Colors.white.withValues(alpha: 0.72),
              height: 1.55,
            ),
          ),
          if (visibleStats.isNotEmpty) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                for (var index = 0; index < visibleStats.length; index++) ...[
                  if (index > 0) const SizedBox(width: 8),
                  Expanded(child: _AlagagiFeatureHeroStat(visibleStats[index])),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _AlagagiFeatureHeroStat extends StatelessWidget {
  const _AlagagiFeatureHeroStat(this.stat);

  final AlagagiHeroStat stat;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '${stat.label} ${stat.value}',
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.13),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.13)),
        ),
        padding: const EdgeInsets.fromLTRB(9, 8, 9, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(stat.icon, size: 14, color: const Color(0xFFEFD797)),
            const Spacer(),
            Text(
              stat.value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: sans(
                size: 12.2,
                weight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
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
            colors: [AlagagiColors.roseSoft, AlagagiColors.goldSoft],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.favorite_border_rounded,
          size: iconSize,
          color: AlagagiColors.rose,
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
              color: AlagagiColors.lavenderSoft,
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
    this.color = AlagagiColors.sageDeep,
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
        color: dashed ? Colors.transparent : AlagagiColors.pearl,
        border: Border.all(
          color: highlightedBorder ?? AlagagiColors.line,
          width: dashed ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(radius),
        boxShadow: dashed
            ? null
            : const [
                BoxShadow(
                  color: Color(0x0F2F2E2A),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
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
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFBF7EF),
        border: Border.all(color: const Color(0x33B99856)),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.fromLTRB(18, 17, 18, 17),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.auto_awesome_rounded,
              size: 17,
              color: AlagagiColors.gold,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: sans(
                size: 12.8,
                color: const Color(0xFF706A5F),
                height: 1.55,
                weight: FontWeight.w700,
              ),
            ),
          ),
        ],
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
          color: selected ? AlagagiColors.midnight : Colors.white,
          border: Border.all(
            color: selected ? AlagagiColors.midnight : AlagagiColors.line,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: Color(0x172F2E2A),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ]
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          label,
          style: sans(
            size: 12.5,
            weight: selected ? FontWeight.w700 : FontWeight.w500,
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
        color: leaf ? AlagagiColors.creamPanel : AlagagiColors.paper,
        border: Border.all(
          color: leaf ? const Color(0x33B99856) : AlagagiColors.line,
        ),
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
            : const Color(0xFFF4ECD9),
        border: dark ? null : Border.all(color: const Color(0x22B99856)),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      child: Text(
        label,
        style: sans(
          size: 10.5,
          weight: FontWeight.w800,
          color: dark ? Colors.white : const Color(0xFF7A6227),
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
        color: muted ? const Color(0xFFF8F8F4) : const Color(0xFFF4ECD9),
        border: Border.all(
          color: muted ? AlagagiColors.line : const Color(0x22B99856),
        ),
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
              color: muted ? AlagagiColors.muted : const Color(0xFF7A6227),
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
        color: const Color(0xFFF4ECD9),
        border: Border.all(color: const Color(0x22B99856)),
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
          color: selected ? AlagagiColors.sageDeep : Colors.white,
          border: Border.all(
            color: selected ? AlagagiColors.sageDeep : AlagagiColors.line,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(vertical: 9),
        alignment: Alignment.center,
        child: Text(
          label,
          style: sans(
            size: 12.5,
            weight: selected ? FontWeight.w700 : FontWeight.w500,
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

class AlagagiInlineEmptyState extends StatelessWidget {
  const AlagagiInlineEmptyState({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(16),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: sans(size: 12.5, color: AlagagiColors.muted, height: 1.5),
      ),
    );
  }
}

class AlagagiInlineTextAction extends StatelessWidget {
  const AlagagiInlineTextAction({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AlagagiColors.sageDeep,
        minimumSize: const Size(0, 30),
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(label, style: sans(size: 12, weight: FontWeight.w700)),
    );
  }
}

class AlagagiTextField extends StatelessWidget {
  const AlagagiTextField({
    super.key,
    required this.fieldKey,
    required this.label,
    required this.hint,
    required this.initialValue,
    required this.maxLength,
    required this.onChanged,
    this.maxLines = 1,
  });

  final Key fieldKey;
  final String label;
  final String hint;
  final String initialValue;
  final int maxLength;
  final ValueChanged<String> onChanged;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F4),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.fromLTRB(14, 7, 14, 7),
      child: TextFormField(
        key: fieldKey,
        initialValue: initialValue,
        maxLength: maxLength,
        minLines: maxLines,
        maxLines: maxLines,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          counterText: '',
          border: InputBorder.none,
        ),
        style: sans(size: 13.5, height: 1.5),
      ),
    );
  }
}
