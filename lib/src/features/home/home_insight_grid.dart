import 'package:flutter/material.dart';

import '../../domain/alagagi_controller.dart';
import '../../shared/ui_style.dart';

class HomeInsightGrid extends StatelessWidget {
  const HomeInsightGrid({super.key, required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final insight = controller.insight;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _InsightBox(
                title: '같이 연 질문',
                value: '${insight.matchCount}',
                suffix: '개',
                highlighted: true,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _InsightBox(
                title: '쌓인 이야기',
                value: '${insight.questionCount}',
                suffix: '개',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InsightBox extends StatelessWidget {
  const _InsightBox({
    required this.title,
    required this.value,
    required this.suffix,
    this.highlighted = false,
  });

  final String title;
  final String value;
  final String suffix;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: highlighted ? null : AlagagiColors.paper,
        gradient: highlighted
            ? const LinearGradient(
                colors: [AlagagiColors.softSage, AlagagiColors.sagePanel],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        border: highlighted ? null : Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: sans(size: 11, color: AlagagiColors.muted)),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: value),
                TextSpan(
                  text: suffix,
                  style: serif(
                    context,
                    size: 13,
                    color: AlagagiColors.muted,
                    weight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            style: serif(
              context,
              size: 30,
              weight: FontWeight.w800,
              color: highlighted ? AlagagiColors.sageDeep : AlagagiColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
