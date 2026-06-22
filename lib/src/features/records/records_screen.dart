import 'package:flutter/material.dart';

import '../../app/app_shell.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/ui_components.dart';
import '../../shared/ui_style.dart';
import '../questions/question_view_switch.dart';

class RecordsScreen extends StatelessWidget {
  const RecordsScreen({super.key, required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final insight = controller.insight;
    final isEmpty = insight.questionCount == 0;
    return AlagagiScreenScroll(
      bottomNavigation: AlagagiBottomNav(controller: controller),
      children: [
        Text('질문', style: serif(context, size: 23, weight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(
          '답변에서 보이는 작은 공통점',
          style: sans(size: 12.5, color: AlagagiColors.muted),
        ),
        const SizedBox(height: 16),
        QuestionViewSwitch(controller: controller),
        const SizedBox(height: 18),
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AlagagiColors.softSage, AlagagiColors.sagePanel],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.all(26),
          child: Column(
            children: [
              AlagagiAvatarStack(
                meAvatar: controller.state.me.avatar,
                partnerAvatar: controller.state.partner.avatar,
              ),
              const SizedBox(height: 12),
              Text(
                '함께 답한 질문',
                style: sans(
                  size: 11,
                  weight: FontWeight.w800,
                  color: const Color(0xFF5A6650),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 5),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: '${insight.matchCount}'),
                    TextSpan(
                      text: '개',
                      style: serif(
                        context,
                        size: 18,
                        weight: FontWeight.w700,
                        color: const Color(0xFF5A6650),
                      ),
                    ),
                  ],
                ),
                style: serif(
                  context,
                  size: 46,
                  weight: FontWeight.w800,
                  color: AlagagiColors.sageDeep,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isEmpty ? '기록은 답이 쌓이면 자연스럽게 만들어져요.' : '답변 속 공통점이 조금씩 보여요',
                style: sans(size: 12, color: const Color(0xFF5A6650)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const AlagagiSectionLabel('겹치는 키워드'),
        const SizedBox(height: 12),
        if (insight.matchedKeywords.isEmpty)
          const AlagagiEmptyStateCard(
            text: '아직 닮은 키워드는 없어요. 답이 쌓이면 여기에 보여드릴게요.',
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: insight.matchedKeywords
                .map(
                  (keyword) => AlagagiKeywordChip(label: keyword, leaf: true),
                )
                .toList(),
          ),
        const SizedBox(height: 24),
        const AlagagiSectionLabel('숫자로 보는 대화'),
        const SizedBox(height: 12),
        _StatsGrid(insight: insight),
        const SizedBox(height: 24),
        const AlagagiSectionLabel('우리의 발자취'),
        const SizedBox(height: 12),
        if (insight.timeline.isEmpty)
          const AlagagiEmptyStateCard(text: '아직 남겨진 발자취가 없어요.')
        else
          _Timeline(events: insight.timeline),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.insight});

  final RelationshipInsight insight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: '기록된 날',
                value: '${insight.daysTogether}',
                suffix: '일',
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _StatCard(
                title: '주고받은 질문',
                value: '${insight.questionCount}',
                suffix: '개',
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: '닮은 답',
                value: '${insight.matchCount}',
                suffix: '번',
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _StatCard(
                title: '가장 긴 답',
                value: '${insight.longestAnswerLength}',
                suffix: '자',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.suffix,
  });

  final String title;
  final String value;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    return AlagagiPaperCard(
      radius: 18,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: sans(size: 11, color: AlagagiColors.muted)),
          const SizedBox(height: 6),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: value),
                TextSpan(
                  text: suffix,
                  style: serif(context, size: 12, color: AlagagiColors.muted),
                ),
              ],
            ),
            style: serif(context, size: 28, weight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.events});

  final List<TimelineEvent> events;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: events.map((event) {
        return Padding(
          padding: const EdgeInsets.only(left: 6, bottom: 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: AlagagiColors.sage,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.dateLabel,
                      style: sans(size: 11, color: AlagagiColors.muted),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      event.description,
                      style: sans(size: 13.5, height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
