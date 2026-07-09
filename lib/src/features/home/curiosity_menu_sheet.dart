import 'package:flutter/material.dart';

import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/text_editing_sync.dart';
import '../../shared/ui_components.dart';
import '../../shared/ui_style.dart';

void showCuriosityMenuSheet(
  BuildContext context,
  AlagagiController controller,
) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return DraggableScrollableSheet(
        initialChildSize: 0.72,
        minChildSize: 0.42,
        maxChildSize: 0.86,
        expand: false,
        builder: (_, scrollController) {
          return AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              return _CuriositySheetContent(
                controller: controller,
                scrollController: scrollController,
              );
            },
          );
        },
      );
    },
  );
}

class _CuriositySheetContent extends StatelessWidget {
  const _CuriositySheetContent({
    required this.controller,
    required this.scrollController,
  });

  final AlagagiController controller;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final received = controller.latestReceivedCuriosityCard;
    final sent =
        controller.pendingSentCuriosityCard ??
        controller.latestSentCuriosityCard;
    final receivedCount = controller.unansweredReceivedCuriosityCount;
    final badge = receivedCount > 0
        ? '받은 질문 $receivedCount'
        : sent != null && !sent.hasReply
        ? '답장 기다림'
        : '새 질문';
    final isSaving = controller.state.curiositySaveStatus == SaveStatus.saving;

    return SafeArea(
      child: Container(
        key: homeCuriositySheetKey,
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        decoration: BoxDecoration(
          color: AlagagiColors.paper,
          border: Border.all(color: AlagagiColors.line),
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [
            BoxShadow(
              color: Color(0x2E2C2B25),
              blurRadius: 44,
              offset: Offset(0, 18),
            ),
          ],
        ),
        child: SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(18, 11, 18, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD7D5CC),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 17),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF7FD),
                      border: Border.all(color: const Color(0x336F7F63)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.question_answer_outlined,
                      size: 20,
                      color: AlagagiColors.sageDeep,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '궁금함 한 장',
                          style: serif(
                            context,
                            size: 20,
                            weight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '서로에게 따로 남기는 작은 질문',
                          style: sans(
                            size: 12,
                            color: AlagagiColors.muted,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _CuriosityBadge(label: badge),
                ],
              ),
              const SizedBox(height: 15),
              _ReceivedCuriosityPanel(controller: controller, card: received),
              if (sent != null) ...[
                const SizedBox(height: 10),
                _SentCuriosityPanel(controller: controller, card: sent),
              ],
              const SizedBox(height: 10),
              _CuriosityComposePanel(
                controller: controller,
                isSaving: isSaving,
              ),
              _CuriositySaveStatus(controller: controller),
              const SizedBox(height: 10),
              _CuriosityHistoryPanel(controller: controller),
              const SizedBox(height: 8),
              _SheetOutlineAction(
                label: '나중에 보기',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CuriosityBadge extends StatelessWidget {
  const _CuriosityBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 26),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF7FD),
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        label,
        style: sans(
          size: 10.5,
          weight: FontWeight.w800,
          color: AlagagiColors.sageDeep,
        ),
      ),
    );
  }
}

class _ReceivedCuriosityPanel extends StatelessWidget {
  const _ReceivedCuriosityPanel({required this.controller, required this.card});

  final AlagagiController controller;
  final CuriosityCard? card;

  @override
  Widget build(BuildContext context) {
    final card = this.card;
    final partnerName = controller.state.partner.nickname;
    if (card == null) {
      return _CuriosityPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '받은 질문',
              style: sans(
                size: 10.5,
                weight: FontWeight.w800,
                color: AlagagiColors.sageDeep,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              '아직 받은 궁금함은 없어요.',
              style: serif(context, size: 15, weight: FontWeight.w800),
            ),
          ],
        ),
      );
    }

    final hasReply = card.hasReply;
    final isSaving =
        controller.state.curiositySaveStatus == SaveStatus.saving &&
        controller.isCuriositySaveTarget(card.id);
    return _CuriosityPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$partnerName님이 물었어요',
            style: sans(
              size: 10.5,
              weight: FontWeight.w800,
              color: AlagagiColors.sageDeep,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            card.question,
            style: serif(
              context,
              size: 15.5,
              weight: FontWeight.w800,
              height: 1.42,
            ),
          ),
          const SizedBox(height: 12),
          if (hasReply)
            _CuriosityReadBlock(label: '내 답장', body: card.reply!)
          else ...[
            _CuriosityTextField(
              fieldKey: curiosityReplyFieldKey,
              value: controller.curiosityReplyDraftFor(card.id),
              hintText: '짧게 답해도 괜찮아요.',
              maxLines: 3,
              onChanged: (value) => controller.updateCuriosityReplyDraft(
                cardId: card.id,
                value: value,
              ),
            ),
            const SizedBox(height: 10),
            AlagagiPrimaryButton(
              label: isSaving ? '저장 중...' : '답장 저장하기',
              buttonKey: curiosityReplySubmitButtonKey,
              onPressed: isSaving
                  ? null
                  : () => controller.submitCuriosityReply(card.id),
              color: AlagagiColors.sageDeep,
            ),
          ],
        ],
      ),
    );
  }
}

class _SentCuriosityPanel extends StatelessWidget {
  const _SentCuriosityPanel({required this.controller, required this.card});

  final AlagagiController controller;
  final CuriosityCard card;

  @override
  Widget build(BuildContext context) {
    final partnerName = controller.state.partner.nickname;
    return _CuriosityPanel(
      backgroundColor: const Color(0xFFF5FCFF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '내가 남긴 질문',
            style: sans(
              size: 10.5,
              weight: FontWeight.w800,
              color: AlagagiColors.sageDeep,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            card.question,
            style: serif(
              context,
              size: 15,
              weight: FontWeight.w800,
              height: 1.42,
            ),
          ),
          const SizedBox(height: 9),
          if (card.hasReply)
            _CuriosityReadBlock(label: '$partnerName님 답장', body: card.reply!)
          else
            Text(
              '$partnerName님 답장을 기다리는 중이에요.',
              style: sans(size: 12, color: AlagagiColors.muted, height: 1.45),
            ),
        ],
      ),
    );
  }
}

class _CuriosityComposePanel extends StatelessWidget {
  const _CuriosityComposePanel({
    required this.controller,
    required this.isSaving,
  });

  final AlagagiController controller;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    final partnerName = controller.state.partner.nickname;
    final pendingSent = controller.pendingSentCuriosityCard;
    final targetId = controller.state.curiositySaveTargetId;
    final savingQuestion =
        isSaving && (targetId == null || targetId.startsWith('curiosity_'));
    if (pendingSent != null) {
      return _CuriosityPanel(
        backgroundColor: const Color(0xFFF7FCFF),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '답장을 기다리는 질문이 있어요',
              style: sans(
                size: 10.5,
                weight: FontWeight.w800,
                color: AlagagiColors.sageDeep,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '한 장이 열린 동안에는 새 질문을 잠시 쉬어가요.',
              style: sans(size: 12, color: AlagagiColors.muted, height: 1.45),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 42,
              child: OutlinedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.hourglass_empty_rounded, size: 15),
                label: const Text('답장 기다리는 중'),
                style: OutlinedButton.styleFrom(
                  disabledForegroundColor: AlagagiColors.muted,
                  side: const BorderSide(color: AlagagiColors.line),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: sans(size: 12, weight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return _CuriosityPanel(
      backgroundColor: const Color(0xFFF7FCFF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$partnerName님에게 궁금한 것',
            style: sans(
              size: 10.5,
              weight: FontWeight.w800,
              color: AlagagiColors.sageDeep,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 9),
          _CuriosityTextField(
            fieldKey: curiosityQuestionFieldKey,
            value: controller.state.curiosityQuestionDraft,
            hintText: '예: 이번 주에 기대되는 일이 있어요?',
            maxLines: 2,
            onChanged: controller.updateCuriosityQuestionDraft,
          ),
          const SizedBox(height: 10),
          AlagagiPrimaryButton(
            label: savingQuestion ? '보내는 중...' : '질문 보내기',
            buttonKey: curiosityQuestionSubmitButtonKey,
            onPressed: savingQuestion
                ? null
                : controller.submitCuriosityQuestion,
            color: AlagagiColors.ink,
          ),
        ],
      ),
    );
  }
}

class _CuriosityHistoryPanel extends StatelessWidget {
  const _CuriosityHistoryPanel({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final cards = controller.curiosityCards;
    final visibleCards = cards.take(6).toList();
    final totalCount = cards.length;
    final repliedCount = cards.where((card) => card.hasReply).length;
    final waitingCount = totalCount - repliedCount;
    final receivedCount = cards
        .where((card) => card.toProfileId == controller.state.me.id)
        .length;
    final sentCount = cards
        .where((card) => card.fromProfileId == controller.state.me.id)
        .length;

    return _CuriosityPanel(
      backgroundColor: const Color(0xFFF5FCFF),
      child: Column(
        key: curiosityHistoryPanelKey,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF7FD),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.history_rounded,
                  size: 17,
                  color: AlagagiColors.sageDeep,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '궁금함 기록',
                      style: serif(context, size: 16, weight: FontWeight.w800),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      totalCount == 0
                          ? '질문을 주고받으면 여기에 차곡차곡 모여요.'
                          : '지금까지 $totalCount장을 주고받았어요.',
                      style: sans(
                        size: 11.5,
                        color: AlagagiColors.muted,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _CuriosityMetricChip(label: '전체 $totalCount장'),
              _CuriosityMetricChip(label: '받은 $receivedCount장'),
              _CuriosityMetricChip(label: '보낸 $sentCount장'),
              _CuriosityMetricChip(label: '완료 $repliedCount장'),
              _CuriosityMetricChip(label: '대기 $waitingCount장'),
            ],
          ),
          if (visibleCards.isEmpty) ...[
            const SizedBox(height: 12),
            Text(
              '아직 쌓인 궁금함은 없어요.',
              style: sans(size: 12, color: AlagagiColors.muted, height: 1.45),
            ),
          ] else ...[
            const SizedBox(height: 12),
            for (var index = 0; index < visibleCards.length; index++) ...[
              _CuriosityHistoryRow(
                controller: controller,
                card: visibleCards[index],
              ),
              if (index != visibleCards.length - 1)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 9),
                  child: Divider(height: 1, color: AlagagiColors.line),
                ),
            ],
            if (cards.length > visibleCards.length) ...[
              const SizedBox(height: 10),
              Text(
                '외 ${cards.length - visibleCards.length}장이 더 쌓여 있어요.',
                style: sans(
                  size: 11.5,
                  color: AlagagiColors.muted,
                  weight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _CuriosityMetricChip extends StatelessWidget {
  const _CuriosityMetricChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFCFE6F1)),
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      child: Text(
        label,
        style: sans(
          size: 10.5,
          weight: FontWeight.w800,
          color: AlagagiColors.sageDeep,
        ),
      ),
    );
  }
}

class _CuriosityHistoryRow extends StatelessWidget {
  const _CuriosityHistoryRow({required this.controller, required this.card});

  final AlagagiController controller;
  final CuriosityCard card;

  @override
  Widget build(BuildContext context) {
    final partnerName = controller.state.partner.nickname;
    final isMine = card.fromProfileId == controller.state.me.id;
    final relation = isMine ? '$partnerName님에게 물었어요' : '$partnerName님이 물었어요';
    final statusLabel = card.hasReply ? '답장 완료' : '답장 대기';
    final statusColor = card.hasReply
        ? AlagagiColors.sageDeep
        : const Color(0xFFB18472);
    final replyText = card.hasReply
        ? card.reply!.trim()
        : isMine
        ? '$partnerName님 답장을 기다리는 중이에요.'
        : '내가 답장할 차례예요.';

    return Row(
      key: curiosityHistoryItemKey(card.id),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      relation,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: sans(
                        size: 10.5,
                        color: AlagagiColors.muted,
                        weight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    statusLabel,
                    style: sans(
                      size: 10.5,
                      color: statusColor,
                      weight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                card.question,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: sans(size: 13, weight: FontWeight.w800, height: 1.35),
              ),
              const SizedBox(height: 4),
              Text(
                replyText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: sans(
                  size: 11.5,
                  color: AlagagiColors.muted,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CuriosityPanel extends StatelessWidget {
  const _CuriosityPanel({
    required this.child,
    this.backgroundColor = const Color(0xFFF7FCFF),
  });

  final Widget child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(14),
      child: child,
    );
  }
}

class _CuriosityReadBlock extends StatelessWidget {
  const _CuriosityReadBlock({required this.label, required this.body});

  final String label;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFEAF7FD),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: sans(
              size: 10.5,
              weight: FontWeight.w800,
              color: AlagagiColors.sageDeep,
            ),
          ),
          const SizedBox(height: 5),
          Text(body, style: sans(size: 13, height: 1.5)),
        ],
      ),
    );
  }
}

class _CuriosityTextField extends StatefulWidget {
  const _CuriosityTextField({
    required this.fieldKey,
    required this.value,
    required this.hintText,
    required this.maxLines,
    required this.onChanged,
  });

  final Key fieldKey;
  final String value;
  final String hintText;
  final int maxLines;
  final ValueChanged<String> onChanged;

  @override
  State<_CuriosityTextField> createState() => _CuriosityTextFieldState();
}

class _CuriosityTextFieldState extends State<_CuriosityTextField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant _CuriosityTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    syncTextEditingControllerText(
      _controller,
      widget.value,
      focusNode: _focusNode,
      force: oldWidget.fieldKey != widget.fieldKey || widget.value.isEmpty,
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: widget.fieldKey,
      controller: _controller,
      focusNode: _focusNode,
      minLines: widget.maxLines,
      maxLines: widget.maxLines,
      maxLength: widget.fieldKey == curiosityQuestionFieldKey ? 80 : 160,
      onChanged: widget.onChanged,
      style: sans(size: 13, height: 1.45),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: sans(size: 12.5, color: AlagagiColors.muted),
        counterText: '',
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AlagagiColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AlagagiColors.sageDeep),
        ),
      ),
    );
  }
}

class _CuriositySaveStatus extends StatelessWidget {
  const _CuriositySaveStatus({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final error = controller.state.curiosityError;
    final feedback = controller.state.curiositySaveFeedback;
    const errorColor = Color(0xFFB18472);
    if (error == null && feedback == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Icon(
            error == null
                ? Icons.check_circle_outline_rounded
                : Icons.error_outline_rounded,
            size: 16,
            color: error == null ? AlagagiColors.sageDeep : errorColor,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              error ?? feedback ?? '',
              style: sans(
                size: 12,
                color: error == null ? AlagagiColors.sageDeep : errorColor,
                weight: FontWeight.w700,
              ),
            ),
          ),
          if (error != null &&
              controller.state.curiositySaveStatus == SaveStatus.failed)
            TextButton(
              onPressed: controller.retryCuriositySave,
              child: Text(
                '다시 시도',
                style: sans(size: 12, weight: FontWeight.w800),
              ),
            ),
        ],
      ),
    );
  }
}

class _SheetOutlineAction extends StatelessWidget {
  const _SheetOutlineAction({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AlagagiColors.sageDeep,
          side: const BorderSide(color: Color(0x338A9A7E)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          textStyle: sans(size: 12, weight: FontWeight.w800),
        ),
        child: Text(label, textAlign: TextAlign.center),
      ),
    );
  }
}
