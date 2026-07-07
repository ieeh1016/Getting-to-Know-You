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
        AlagagiFeatureHero(
          eyebrow: 'OUR CONVERSATION',
          title: '우리 대화 기록',
          subtitle: isEmpty
              ? '답이 쌓이면 공통점과 발자취가 자연스럽게 보여요.'
              : '답변에서 보이는 작은 공통점과 함께한 흐름을 모았어요.',
          icon: Icons.timeline_rounded,
          gradient: const [
            Color(0xFF2F2E2A),
            Color(0xFF718EA1),
            Color(0xFF9F8AB6),
          ],
          stats: [
            AlagagiHeroStat(
              icon: Icons.calendar_month_rounded,
              label: '기록된 날',
              value: '${insight.daysTogether}일',
            ),
            AlagagiHeroStat(
              icon: Icons.question_answer_rounded,
              label: '질문',
              value: '${insight.questionCount}개',
            ),
            AlagagiHeroStat(
              icon: Icons.auto_awesome_rounded,
              label: '닮은 답',
              value: '${insight.matchCount}번',
            ),
          ],
        ),
        const SizedBox(height: 16),
        QuestionViewSwitch(controller: controller),
        const SizedBox(height: 18),
        _RecordsJournalPanel(
          controller: controller,
          insight: insight,
          isEmpty: isEmpty,
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

class _RecordsJournalPanel extends StatelessWidget {
  const _RecordsJournalPanel({
    required this.controller,
    required this.insight,
    required this.isEmpty,
  });

  final AlagagiController controller;
  final RelationshipInsight insight;
  final bool isEmpty;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AlagagiColors.midnight,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F2F2E2A),
            blurRadius: 26,
            offset: Offset(0, 14),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _RecordsGridPainter())),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AlagagiAvatarStack(
                      meAvatar: controller.state.me.avatar,
                      partnerAvatar: controller.state.partner.avatar,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'COUPLE JOURNAL',
                            style: sans(
                              size: 10.2,
                              weight: FontWeight.w900,
                              color: const Color(0xFFEFD797),
                              letterSpacing: 1.7,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '대화가 쌓인 자리',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: serif(
                              context,
                              size: 21,
                              weight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            isEmpty
                                ? '기록은 답이 쌓이면 자연스럽게 만들어져요.'
                                : '답변 속 공통점이 조금씩 보여요',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: sans(
                              size: 12.2,
                              color: Colors.white.withValues(alpha: 0.68),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 17),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.fromLTRB(15, 14, 15, 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '함께 답한 질문',
                              style: sans(
                                size: 11,
                                weight: FontWeight.w900,
                                color: const Color(0xFFEFD797),
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 6),
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
                                      color: Colors.white.withValues(
                                        alpha: 0.72,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              style: serif(
                                context,
                                size: 43,
                                weight: FontWeight.w800,
                                color: Colors.white,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _RecordsMiniMetric(
                            label: '기록된 날',
                            value: '${insight.daysTogether}일',
                          ),
                          const SizedBox(height: 8),
                          _RecordsMiniMetric(
                            label: '주고받은 질문',
                            value: '${insight.questionCount}개',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecordsMiniMetric extends StatelessWidget {
  const _RecordsMiniMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 94),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: sans(size: 10, color: Colors.white.withValues(alpha: 0.58)),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: sans(
              size: 12,
              weight: FontWeight.w900,
              color: const Color(0xFFEFD797),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecordsGridPainter extends CustomPainter {
  const _RecordsGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1;
    for (var x = 18.0; x < size.width; x += 42) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 22.0; y < size.height; y += 42) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RecordsGridPainter oldDelegate) => false;
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
