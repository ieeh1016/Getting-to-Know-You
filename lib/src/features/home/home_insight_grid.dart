import 'package:flutter/material.dart';

import '../../domain/alagagi_controller.dart';
import '../../shared/ui_style.dart';

class HomeInsightGrid extends StatelessWidget {
  const HomeInsightGrid({super.key, required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final insight = controller.insight;
    final daysTogether =
        controller.relationshipDayCount ?? insight.daysTogether;

    return Container(
      decoration: BoxDecoration(
        color: AlagagiColors.ink,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '우리 기록 보드',
                  style: serif(
                    context,
                    size: 18,
                    weight: FontWeight.w800,
                    color: AlagagiColors.paper,
                  ),
                ),
              ),
              Text(
                controller.relationshipStartedLabel,
                style: sans(
                  size: 10.8,
                  weight: FontWeight.w800,
                  color: const Color(0xFFD7D0BD),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _InsightBox(
                  title: '함께한 날',
                  value: '$daysTogether',
                  suffix: '일',
                  tone: AlagagiColors.goldSoft,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _InsightBox(
                  title: '함께 답한 질문',
                  value: '${insight.matchCount}',
                  suffix: '개',
                  tone: AlagagiColors.sageSoft,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _InsightBox(
                  title: '주고받은 질문',
                  value: '${insight.questionCount}',
                  suffix: '개',
                  tone: AlagagiColors.lavenderSoft,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InsightBox extends StatelessWidget {
  const _InsightBox({
    required this.title,
    required this.value,
    required this.suffix,
    required this.tone,
  });

  final String title;
  final String value;
  final String suffix;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 116,
      decoration: BoxDecoration(
        color: tone,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(10, 11, 9, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: sans(
              size: 10.5,
              weight: FontWeight.w700,
              color: AlagagiColors.muted,
            ),
          ),
          const Spacer(),
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
              size: 24,
              weight: FontWeight.w800,
              color: AlagagiColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
