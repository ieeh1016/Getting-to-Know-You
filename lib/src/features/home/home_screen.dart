import 'package:flutter/material.dart';

import '../../app/app_shell.dart';
import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/readable_detail_sheet.dart';
import '../../shared/ui_components.dart';
import '../../shared/ui_style.dart';
import '../questions/answer_blocks.dart';
import '../questions/answer_save_status.dart';
import 'curiosity_menu_sheet.dart';
import 'home_header.dart';
import 'home_insight_grid.dart';
import 'home_memory_card.dart';
import 'home_plus_grid.dart';
import 'home_progress_summary_card.dart';
import 'unread_activity_panel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.controller,
    required this.brandKicker,
    required this.onOpenGuideBook,
    this.onRefresh,
    this.isRefreshing = false,
  });

  final AlagagiController controller;
  final String brandKicker;
  final VoidCallback onOpenGuideBook;
  final Future<void> Function()? onRefresh;
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    return AlagagiScreenScroll(
      onRefresh: onRefresh,
      bottomNavigation: AlagagiBottomNav(controller: controller),
      children: [
        HomeHeader(
          controller: controller,
          brandKicker: brandKicker,
          onOpenMenu: () => showHomeMenuSheet(
            context: context,
            controller: controller,
            onOpenCuriosity: () => showCuriosityMenuSheet(context, controller),
            onOpenGuideBook: onOpenGuideBook,
            onRefresh: onRefresh,
            isRefreshing: isRefreshing,
          ),
        ),
        const SizedBox(height: 18),
        HomeProgressStrip(controller: controller),
        UnreadActivityPanel(
          controller: controller,
          onOpenCuriosity: (context) =>
              showCuriosityMenuSheet(context, controller),
        ),
        const SizedBox(height: 22),
        _HomeTodayBoard(controller: controller),
        const SizedBox(height: 22),
        HomeProgressSummaryCard(controller: controller),
        const SizedBox(height: 22),
        const AlagagiSectionLabel('오늘의 질문'),
        const SizedBox(height: 12),
        _QuestionCard(controller: controller),
        const SizedBox(height: 22),
        const AlagagiSectionLabel('서로의 기억'),
        const SizedBox(height: 12),
        HomeMemoryCard(controller: controller),
        const SizedBox(height: 22),
        const AlagagiSectionLabel('우리 기록'),
        const SizedBox(height: 12),
        HomeInsightGrid(controller: controller),
        const SizedBox(height: 24),
        const AlagagiSectionLabel('같이 해보는 것들'),
        const SizedBox(height: 12),
        HomePlusGrid(controller: controller),
      ],
    );
  }
}

class _HomeTodayBoard extends StatelessWidget {
  const _HomeTodayBoard({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final nextDate = controller.nextMeetingDayEntry;
    final nextDateKey = nextDate?.dateKey;
    final planCount = nextDateKey == null
        ? 0
        : controller.meetingPlanItemCountFor(nextDateKey);
    final needsAnswer =
        controller.todayMyAnswer == null ||
        controller.todayMyAnswer?.skipped == true;
    final latestMemory = controller.latestVisibleMemoryCard;

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
          const Positioned(
            right: -34,
            top: -42,
            child: _HomeBoardGlow(size: 142, color: Color(0x33D8A49A)),
          ),
          const Positioned(
            left: -46,
            bottom: -58,
            child: _HomeBoardGlow(size: 148, color: Color(0x336F8B66)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'COUPLE DASHBOARD',
                            style: sans(
                              size: 10.2,
                              weight: FontWeight.w900,
                              color: const Color(0xFFEFD797),
                              letterSpacing: 1.7,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            '오늘의 우리 보드',
                            style: serif(
                              context,
                              size: 21,
                              weight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            '${controller.state.me.nickname}와 ${controller.state.partner.nickname}의 기록, 답, 계획을 한 화면에서 이어가요.',
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
                    const SizedBox(width: 12),
                    _HomeBoardDayPill(label: controller.relationshipDayLabel),
                  ],
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final tileWidth = (constraints.maxWidth - 9) / 2;
                    return Wrap(
                      spacing: 9,
                      runSpacing: 9,
                      children: [
                        SizedBox(
                          width: tileWidth,
                          child: _HomeBoardActionTile(
                            icon: Icons.edit_note_rounded,
                            title: needsAnswer ? '답 시작하기' : '질문함 보기',
                            body: needsAnswer
                                ? 'DAY ${controller.todayQuestion.day} 기다림'
                                : '오늘 답이 열렸어요',
                            tone: const Color(0xFFEFD797),
                            onTap: controller.activateHomeProgressSummaryAction,
                          ),
                        ),
                        SizedBox(
                          width: tileWidth,
                          child: _HomeBoardActionTile(
                            icon: Icons.bookmarks_outlined,
                            title: '기억 카드',
                            body: latestMemory == null
                                ? '처음 남겨보기'
                                : latestMemory.title,
                            tone: const Color(0xFFBFD0B8),
                            onTap: () =>
                                controller.goTo(AlagagiRoute.memoryCards),
                          ),
                        ),
                        SizedBox(
                          width: tileWidth,
                          child: _HomeBoardActionTile(
                            icon: Icons.event_note_rounded,
                            title: '데이트 계획',
                            body: nextDateKey == null
                                ? '다음 날 정하기'
                                : '계획 $planCount개 준비',
                            tone: const Color(0xFFE0A89D),
                            onTap: () =>
                                controller.goTo(AlagagiRoute.meetingPlans),
                          ),
                        ),
                        SizedBox(
                          width: tileWidth,
                          child: _HomeBoardActionTile(
                            icon: Icons.swap_horiz_rounded,
                            title: '선택 카드',
                            body: '취향 힌트 남기기',
                            tone: const Color(0xFFB9A8C9),
                            onTap: () => controller.goTo(AlagagiRoute.balance),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeBoardGlow extends StatelessWidget {
  const _HomeBoardGlow({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _HomeBoardDayPill extends StatelessWidget {
  const _HomeBoardDayPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 104),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
        borderRadius: BorderRadius.circular(17),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.favorite_rounded,
            size: 15,
            color: Color(0xFFEFD797),
          ),
          const SizedBox(height: 7),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: sans(
              size: 11.2,
              weight: FontWeight.w900,
              color: Colors.white,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeBoardActionTile extends StatelessWidget {
  const _HomeBoardActionTile({
    required this.icon,
    required this.title,
    required this.body,
    required this.tone,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String body;
  final Color tone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.09),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          height: 112,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.fromLTRB(13, 12, 13, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: tone.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    alignment: Alignment.center,
                    child: Icon(icon, size: 18, color: tone),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_outward_rounded, size: 16, color: tone),
                ],
              ),
              const Spacer(),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: sans(
                  size: 13.2,
                  weight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                body,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: sans(
                  size: 11.1,
                  color: Colors.white.withValues(alpha: 0.68),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final question = controller.todayQuestion;
    final myAnswer = controller.todayMyAnswer;
    final partnerAnswer = controller.todayPartnerAnswer;
    final receivedComment = myAnswer == null
        ? null
        : controller.commentForAnswer(
            question.id,
            myAnswer.profileId,
            controller.state.partner.id,
          );
    final isSkipped = myAnswer?.skipped ?? false;

    return AlagagiPaperCard(
      key: homeQuestionCardKey,
      radius: 22,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 21),
      highlightedBorder: AlagagiColors.roseSoft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AlagagiColors.ink, AlagagiColors.sageDeep],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Today\'s Question',
                    style: sans(
                      size: 10.5,
                      color: AlagagiColors.paper,
                      letterSpacing: 1.2,
                      weight: FontWeight.w800,
                    ),
                  ),
                ),
                _DayChip(label: 'DAY ${question.day}'),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            question.text,
            style: serif(
              context,
              size: 22,
              weight: FontWeight.w800,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          if (isSkipped)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const QuestionSupportBlock(
                  title: '오늘은 잠시 넘겨뒀어요.',
                  body: '다시 답하고 싶어지면 여기서 바로 이어갈 수 있어요.',
                ),
                const SizedBox(height: 16),
                AlagagiPrimaryButton(
                  label: '다시 답하기',
                  onPressed: controller.answerTodayAfterSkip,
                  color: AlagagiColors.sageDeep,
                ),
                AnswerSaveStatus(
                  controller: controller,
                  questionId: question.id,
                ),
              ],
            )
          else if (myAnswer == null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QuestionSupportBlock(
                  title: '아직 내 답을 남기지 않았어요.',
                  body:
                      '답을 남기면 ${controller.state.partner.nickname}님의 답도 함께 열려요.',
                ),
                const SizedBox(height: 16),
                AlagagiPrimaryButton(
                  buttonKey: homeQuestionAnswerButtonKey,
                  label: '답 남기기',
                  onPressed: () => controller.goTo(AlagagiRoute.answer),
                  color: AlagagiColors.sageDeep,
                ),
              ],
            )
          else ...[
            AnswerPreviewBlock(
              key: answerPreviewBlockKey(
                myAnswer.questionId,
                myAnswer.profileId,
              ),
              label: '내 답',
              body: myAnswer.body,
              onOpenFull: () => showReadableDetailSheet(
                context,
                label: '내 답',
                title: question.text,
                body: myAnswer.body,
                actionLabel: '수정하기',
                onAction: controller.editTodayAnswer,
              ),
              action: AlagagiInlineTextAction(
                key: editAnswerButtonKey,
                label: '수정하기',
                onPressed: controller.editTodayAnswer,
              ),
              expanded: controller.isAnswerExpanded(
                myAnswer.questionId,
                myAnswer.profileId,
              ),
              onToggle: () => controller.toggleAnswerExpanded(
                myAnswer.questionId,
                myAnswer.profileId,
              ),
            ),
            if (receivedComment != null) ...[
              const SizedBox(height: 10),
              ReceivedAnswerCommentBlock(
                controller: controller,
                comment: receivedComment,
                label: '${controller.state.partner.nickname}님의 댓글',
                onOpenFull: () => showReadableDetailSheet(
                  context,
                  label: '${controller.state.partner.nickname}님의 댓글',
                  title: '내 답에 남겨진 댓글',
                  body: receivedComment.body,
                ),
              ),
            ],
            const SizedBox(height: 16),
            if (partnerAnswer == null)
              QuestionSupportBlock(
                title: '${controller.state.partner.nickname}님 답은 기다리는 중이에요.',
                body: '상대 답이 준비되면 이 자리에서 이어서 볼 수 있어요.',
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnswerPreviewBlock(
                    key: answerPreviewBlockKey(
                      partnerAnswer.questionId,
                      partnerAnswer.profileId,
                    ),
                    label: '${controller.state.partner.nickname}님 답',
                    accentColor: AlagagiColors.lavender,
                    body: partnerAnswer.body,
                    onOpenFull: () => showReadableDetailSheet(
                      context,
                      label: '${controller.state.partner.nickname}님 답',
                      title: question.text,
                      body: partnerAnswer.body,
                    ),
                    expanded: controller.isAnswerExpanded(
                      partnerAnswer.questionId,
                      partnerAnswer.profileId,
                    ),
                    onToggle: () => controller.toggleAnswerExpanded(
                      partnerAnswer.questionId,
                      partnerAnswer.profileId,
                    ),
                  ),
                  const SizedBox(height: 14),
                  AnswerCommentBox(
                    controller: controller,
                    questionId: partnerAnswer.questionId,
                    answerOwnerProfileId: partnerAnswer.profileId,
                  ),
                ],
              ),
            AnswerSaveStatus(controller: controller, questionId: question.id),
          ],
        ],
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 28),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2EB),
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      child: Text(
        label,
        style: sans(
          size: 11,
          color: AlagagiColors.sageDeep,
          weight: FontWeight.w700,
        ),
      ),
    );
  }
}
