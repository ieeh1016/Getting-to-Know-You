import 'package:flutter/material.dart';

import '../../app/app_shell.dart';
import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/text_editing_sync.dart';
import '../../shared/ui_components.dart';
import '../../shared/ui_style.dart';
import '../questions/question_formatters.dart';

class AnswerScreen extends StatefulWidget {
  const AnswerScreen({super.key, required this.controller});

  final AlagagiController controller;

  @override
  State<AnswerScreen> createState() => _AnswerScreenState();
}

class _AnswerScreenState extends State<AnswerScreen> {
  late final ImeSafeTextEditingController _answerController;
  late final FocusNode _answerFocusNode;
  late final VoidCallback _detachFocusDispatch;
  late String _lastQuestionId;

  @override
  void initState() {
    super.initState();
    _answerController = ImeSafeTextEditingController(
      text: widget.controller.state.draftAnswer,
      onCommittedChanged: widget.controller.updateDraftAnswer,
    );
    _answerFocusNode = FocusNode();
    _detachFocusDispatch = dispatchTextOnFocusLost(
      _answerController,
      _answerFocusNode,
    );
    _lastQuestionId = widget.controller.activeAnswerQuestion.id;
  }

  @override
  void didUpdateWidget(covariant AnswerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _answerController.onCommittedChanged = widget.controller.updateDraftAnswer;
    final questionId = widget.controller.activeAnswerQuestion.id;
    final questionChanged = _lastQuestionId != questionId;
    if (questionChanged) {
      _answerController.syncText(
        widget.controller.state.draftAnswer,
        focusNode: _answerFocusNode,
        force: true,
      );
      _lastQuestionId = questionId;
    }
  }

  @override
  void dispose() {
    _detachFocusDispatch();
    _answerFocusNode.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _submitAnswer() {
    _answerController.dispatchCurrentText();
    widget.controller.submitActiveAnswer();
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.controller.activeAnswerQuestion;
    final state = widget.controller.state;
    final count = state.draftAnswer.length;
    final isSaving = state.answerSaveStatus == SaveStatus.saving;
    final isEditing = state.editingAnswer;
    final isToday = widget.controller.isActiveAnswerToday;
    final hasTodayPartnerAnswer = widget.controller.todayPartnerAnswer != null;
    final selectedDateContext = isToday
        ? null
        : questionDateContext(state.selectedArchiveDateKey, question);

    return Stack(
      children: [
        AlagagiScreenScroll(
          padding: const EdgeInsets.fromLTRB(28, 34, 28, 166),
          children: [
            AlagagiTopBar(
              title: isToday ? '오늘의 질문' : '늦게 답하기',
              trailing: 'DAY ${question.day}',
              onBack: () => widget.controller.goTo(
                isToday ? AlagagiRoute.home : AlagagiRoute.archive,
              ),
            ),
            if (selectedDateContext != null) ...[
              const SizedBox(height: 10),
              Text(
                selectedDateContext,
                textAlign: TextAlign.center,
                style: serif(
                  context,
                  size: 14,
                  weight: FontWeight.w700,
                  color: AlagagiColors.sageDeep,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              '${question.number}',
              style: serif(
                context,
                size: 64,
                weight: FontWeight.w800,
                color: const Color(0xFFEAF7FD),
              ),
            ),
            Text(
              isToday ? 'TODAY\'S QUESTION' : 'PAST QUESTION',
              style: sans(
                size: 11,
                color: AlagagiColors.sageDeep,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              question.text,
              style: serif(
                context,
                size: 24,
                weight: FontWeight.w700,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            AlagagiPaperCard(
              radius: 20,
              padding: const EdgeInsets.all(20),
              child: TextField(
                key: answerFieldKey,
                controller: _answerController,
                focusNode: _answerFocusNode,
                minLines: 5,
                maxLines: 7,
                maxLength: 300,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                  hintText: '떠오르는 대로 적어볼까요...',
                ),
                style: sans(size: 15, height: 1.7),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '$count / 300자',
                style: sans(size: 11, color: AlagagiColors.muted),
              ),
            ),
            const SizedBox(height: 18),
            const _HintBox(),
            const SizedBox(height: 18),
            const _PartnerLockedBox(),
            if (state.answerError != null) ...[
              const SizedBox(height: 12),
              Text(
                state.answerError!,
                style: sans(size: 12, color: AlagagiColors.sageDeep),
                textAlign: TextAlign.center,
              ),
              if (state.answerSaveStatus == SaveStatus.failed) ...[
                const SizedBox(height: 8),
                AlagagiInlineTextAction(
                  key: answerRetryButtonKey,
                  label: '저장 다시 시도',
                  onPressed: widget.controller.retryAnswerSave,
                ),
              ],
            ],
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(28, 18, 28, 26),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0x00F4F3EF), AlagagiColors.appBackground],
                begin: Alignment.topCenter,
                end: Alignment.center,
              ),
            ),
            child: Column(
              children: [
                if (isToday && !isEditing)
                  TextButton(
                    onPressed: isSaving ? null : widget.controller.skipToday,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '오늘은 답하기 어렵나요? ',
                            style: sans(size: 12, color: AlagagiColors.muted),
                          ),
                          TextSpan(
                            text: '내일 다시 보기',
                            style: sans(
                              size: 12,
                              color: AlagagiColors.sageDeep,
                              weight: FontWeight.w500,
                            ).copyWith(decoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                    ),
                  ),
                AlagagiPrimaryButton(
                  label: isEditing
                      ? '수정 저장하기'
                      : !isToday
                      ? '저장하기'
                      : hasTodayPartnerAnswer
                      ? '답 남기고 ${state.partner.nickname}님 답 열어보기'
                      : '답 남기기',
                  onPressed: isSaving ? null : _submitAnswer,
                  color: AlagagiColors.sageDeep,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HintBox extends StatelessWidget {
  const _HintBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEAF7FD),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        children: [
          const Icon(
            Icons.eco_outlined,
            size: 17,
            color: AlagagiColors.sageDeep,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '정답은 없어요. 떠오르는 대로, 솔직한 한 줄이면 충분해요.',
              style: sans(
                size: 12,
                color: const Color(0xFF5A5A54),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PartnerLockedBox extends StatelessWidget {
  const _PartnerLockedBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AlagagiColors.line, width: 1.5),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Icon(
            Icons.lock_outline_rounded,
            size: 22,
            color: AlagagiColors.muted,
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: '상대 답은 내 답을 남기면\n'),
                TextSpan(
                  text: '같이 열려요',
                  style: sans(
                    size: 12.5,
                    color: AlagagiColors.lavender,
                    weight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            style: sans(size: 12.5, color: AlagagiColors.muted, height: 1.5),
          ),
        ],
      ),
    );
  }
}
