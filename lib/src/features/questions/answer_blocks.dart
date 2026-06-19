import 'package:flutter/material.dart';

import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/readable_detail_sheet.dart';
import '../../shared/ui_components.dart';
import '../../shared/ui_style.dart';

class QuestionSupportBlock extends StatelessWidget {
  const QuestionSupportBlock({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F4),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(17),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: serif(
              context,
              size: 13,
              weight: FontWeight.w800,
              color: AlagagiColors.sageDeep,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            body,
            style: sans(size: 12.5, color: AlagagiColors.muted, height: 1.55),
          ),
        ],
      ),
    );
  }
}

class AnswerCommentBox extends StatelessWidget {
  const AnswerCommentBox({
    super.key,
    required this.controller,
    required this.questionId,
    required this.answerOwnerProfileId,
    this.readOnly = false,
  });

  final AlagagiController controller;
  final String questionId;
  final String answerOwnerProfileId;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final existingComment = controller.commentForAnswer(
      questionId,
      answerOwnerProfileId,
      controller.state.me.id,
    );
    final inputValue = controller.commentInputValueForAnswer(
      questionId,
      answerOwnerProfileId,
    );
    final hasDraft = controller.hasCommentDraftForAnswer(
      questionId,
      answerOwnerProfileId,
    );
    final showEditor = !readOnly && (hasDraft || existingComment == null);
    final showEditButton = !readOnly && existingComment != null && !hasDraft;
    if (readOnly && existingComment == null) {
      return const SizedBox.shrink();
    }
    final isSaveTarget = controller.isCommentSaveTarget(
      questionId: questionId,
      answerOwnerProfileId: answerOwnerProfileId,
    );
    final isSaving =
        isSaveTarget && controller.state.commentSaveStatus == SaveStatus.saving;
    final inputLength = inputValue.length;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEFA),
        border: Border.all(
          color: showEditor ? const Color(0x5C6F7F63) : AlagagiColors.line,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: showEditor
            ? const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 22,
                  offset: Offset(0, 10),
                ),
              ]
            : null,
      ),
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2EB),
                  border: Border.all(color: AlagagiColors.line),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 14,
                  color: AlagagiColors.sageDeep,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      showEditor
                          ? existingComment == null
                                ? '댓글 남기기'
                                : '댓글 다듬기'
                          : '내 댓글',
                      style: serif(
                        context,
                        size: 13,
                        weight: FontWeight.w800,
                        color: AlagagiColors.sageDeep,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      showEditor ? '저장 전까지는 내 화면에서만 바뀌어요' : '상대 답에 남긴 짧은 코멘트',
                      style: sans(size: 10.5, color: AlagagiColors.muted),
                    ),
                  ],
                ),
              ),
              if (showEditButton)
                _CommentIconButton(
                  key: answerCommentEditButtonKey,
                  tooltip: '댓글 수정',
                  icon: Icons.edit_outlined,
                  onPressed: () => controller.updateAnswerCommentDraft(
                    questionId: questionId,
                    answerOwnerProfileId: answerOwnerProfileId,
                    value: existingComment.body,
                  ),
                ),
            ],
          ),
          if (existingComment != null && !showEditor) ...[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 36),
              child: Builder(
                builder: (context) {
                  final showReadableCue = showsReadableCue(
                    existingComment.body,
                  );
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => showReadableDetailSheet(
                          context,
                          label: '내 댓글',
                          title: '상대 답에 남긴 댓글',
                          body: existingComment.body,
                          actionLabel: readOnly ? null : '수정하기',
                          onAction: readOnly
                              ? null
                              : () => controller.updateAnswerCommentDraft(
                                  questionId: questionId,
                                  answerOwnerProfileId: answerOwnerProfileId,
                                  value: existingComment.body,
                                ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              existingComment.body,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: sans(
                                size: 13,
                                color: AlagagiColors.ink,
                                height: 1.55,
                              ),
                            ),
                            if (showReadableCue) ...[
                              const SizedBox(height: 5),
                              const AlagagiFullTextCue(),
                            ],
                          ],
                        ),
                      ),
                      if (existingComment.edited) ...[
                        const SizedBox(height: 8),
                        const _EditedBadge(),
                      ],
                    ],
                  );
                },
              ),
            ),
          ],
          if (showEditor) ...[
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F4),
                border: Border.all(color: const Color(0x336F7F63)),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AlagagiColors.line),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextFormField(
                      key: answerCommentFieldKey,
                      initialValue: inputValue,
                      maxLength: 120,
                      minLines: 1,
                      maxLines: 3,
                      onChanged: (value) => controller.updateAnswerCommentDraft(
                        questionId: questionId,
                        answerOwnerProfileId: answerOwnerProfileId,
                        value: value,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        hintText: existingComment == null
                            ? '이 답에 짧게 남겨볼까요?'
                            : '댓글을 다듬어볼까요?',
                      ),
                      style: sans(size: 13, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '짧고 편한 말투로 남겨요',
                          style: sans(size: 10.5, color: AlagagiColors.muted),
                        ),
                      ),
                      Text(
                        '$inputLength / 120',
                        style: sans(size: 10.5, color: AlagagiColors.muted),
                      ),
                    ],
                  ),
                  if (controller.state.commentError != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 14,
                          color: Color(0xFFB18472),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            controller.state.commentError!,
                            style: sans(
                              size: 11,
                              color: const Color(0xFFB18472),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (existingComment != null) ...[
                        SizedBox(
                          width: 88,
                          child: _CommentSecondaryButton(
                            key: answerCommentCancelButtonKey,
                            label: '취소',
                            onPressed: isSaving
                                ? null
                                : () => controller.cancelAnswerCommentDraft(
                                    questionId: questionId,
                                    answerOwnerProfileId: answerOwnerProfileId,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 9),
                      ],
                      Expanded(
                        flex: existingComment == null ? 1 : 2,
                        child: _CommentPrimaryButton(
                          key: answerCommentSubmitButtonKey,
                          label: isSaving
                              ? '저장 중'
                              : existingComment == null
                              ? '댓글 남기기'
                              : '수정 저장',
                          onPressed: isSaving
                              ? null
                              : () => controller.submitAnswerComment(
                                  questionId: questionId,
                                  answerOwnerProfileId: answerOwnerProfileId,
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          if (isSaveTarget) ...[
            const SizedBox(height: 10),
            _CommentSaveStatus(
              controller: controller,
              questionId: questionId,
              answerOwnerProfileId: answerOwnerProfileId,
            ),
          ],
        ],
      ),
    );
  }
}

class _CommentSaveStatus extends StatelessWidget {
  const _CommentSaveStatus({
    required this.controller,
    required this.questionId,
    required this.answerOwnerProfileId,
  });

  final AlagagiController controller;
  final String questionId;
  final String answerOwnerProfileId;

  @override
  Widget build(BuildContext context) {
    if (!controller.isCommentSaveTarget(
      questionId: questionId,
      answerOwnerProfileId: answerOwnerProfileId,
    )) {
      return const SizedBox.shrink();
    }

    final state = controller.state;
    final status = state.commentSaveStatus;
    final message = switch (status) {
      SaveStatus.saving => '댓글 저장 중이에요...',
      SaveStatus.saved => state.commentSaveFeedback,
      SaveStatus.failed => state.commentError,
      SaveStatus.idle => null,
    };
    if (message == null || message.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            message,
            style: sans(
              size: 11.5,
              color: status == SaveStatus.failed
                  ? AlagagiColors.sageDeep
                  : AlagagiColors.muted,
              height: 1.45,
            ),
          ),
        ),
        if (status == SaveStatus.failed)
          AlagagiInlineTextAction(
            label: '댓글 저장 다시 시도',
            onPressed: controller.retryAnswerCommentSave,
          ),
      ],
    );
  }
}

class _CommentIconButton extends StatelessWidget {
  const _CommentIconButton({
    super.key,
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        color: AlagagiColors.sageDeep,
        constraints: const BoxConstraints.tightFor(width: 34, height: 34),
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: AlagagiColors.line),
        ),
      ),
    );
  }
}

class _CommentSecondaryButton extends StatelessWidget {
  const _CommentSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AlagagiColors.ink,
          side: const BorderSide(color: AlagagiColors.line),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: serif(context, size: 13.5, weight: FontWeight.w800),
        ),
        child: Text(label, softWrap: false),
      ),
    );
  }
}

class _CommentPrimaryButton extends StatelessWidget {
  const _CommentPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AlagagiColors.sageDeep,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: serif(context, size: 13.5, weight: FontWeight.w800),
        ),
        child: Text(label),
      ),
    );
  }
}

class _EditedBadge extends StatelessWidget {
  const _EditedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F4),
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text('수정됨', style: sans(size: 10.5, color: AlagagiColors.muted)),
    );
  }
}

class AnswerPreviewBlock extends StatelessWidget {
  const AnswerPreviewBlock({
    super.key,
    required this.label,
    required this.body,
    this.accentColor = AlagagiColors.sageDeep,
    this.action,
    this.expanded = false,
    this.onToggle,
    this.onOpenFull,
  });

  final String label;
  final String body;
  final Color accentColor;
  final Widget? action;
  final bool expanded;
  final VoidCallback? onToggle;
  final VoidCallback? onOpenFull;

  @override
  Widget build(BuildContext context) {
    final isLong = body.length > alagagiReadablePreviewLength;
    final showReadableCue = showsReadableCue(body, expanded: expanded);
    final visibleBody = isLong && !expanded
        ? '${body.substring(0, alagagiReadablePreviewLength).trimRight()}...'
        : body;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onOpenFull,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F4),
          border: Border.all(color: AlagagiColors.line),
          borderRadius: BorderRadius.circular(17),
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: serif(
                      context,
                      size: 13,
                      weight: FontWeight.w800,
                      color: accentColor,
                    ),
                  ),
                ),
                ?action,
              ],
            ),
            const SizedBox(height: 8),
            Text(
              visibleBody,
              style: sans(
                size: 13.5,
                color: const Color(0xFF4A4A46),
                height: 1.62,
              ),
            ),
            if ((isLong && onToggle != null) ||
                (showReadableCue && onOpenFull != null)) ...[
              const SizedBox(height: 6),
              Wrap(
                spacing: 14,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (isLong && onToggle != null)
                    AlagagiInlineTextAction(
                      label: expanded ? '접기' : '더 보기',
                      onPressed: onToggle,
                    ),
                  if (showReadableCue && onOpenFull != null)
                    const AlagagiFullTextCue(),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AnswerLine extends StatelessWidget {
  const AnswerLine({
    super.key,
    required this.tag,
    required this.tagColor,
    required this.body,
    this.expanded = false,
    this.onToggle,
    this.onOpenFull,
  });

  final String tag;
  final Color tagColor;
  final String body;
  final bool expanded;
  final VoidCallback? onToggle;
  final VoidCallback? onOpenFull;

  @override
  Widget build(BuildContext context) {
    final isLong = body.length > alagagiReadablePreviewLength;
    final showReadableCue = showsReadableCue(body, expanded: expanded);
    final visibleBody = isLong && !expanded
        ? '${body.substring(0, alagagiReadablePreviewLength).trimRight()}...'
        : body;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onOpenFull,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 48,
            child: Text(
              tag,
              style: serif(
                context,
                size: 13,
                weight: FontWeight.w700,
                color: tagColor,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  visibleBody,
                  style: sans(
                    size: 14,
                    color: const Color(0xFF4A4A46),
                    height: 1.65,
                  ),
                ),
                if ((isLong && onToggle != null) ||
                    (showReadableCue && onOpenFull != null)) ...[
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (isLong && onToggle != null)
                        AlagagiInlineTextAction(
                          label: expanded ? '접기' : '더 보기',
                          onPressed: onToggle,
                        ),
                      if (showReadableCue && onOpenFull != null)
                        const AlagagiFullTextCue(),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReceivedAnswerCommentBlock extends StatelessWidget {
  const ReceivedAnswerCommentBlock({
    super.key,
    required this.controller,
    required this.comment,
    required this.label,
    this.onOpenFull,
  });

  final AlagagiController controller;
  final AnswerComment comment;
  final String label;
  final VoidCallback? onOpenFull;

  @override
  Widget build(BuildContext context) {
    final showReadableCue = showsReadableCue(comment.body);
    final canReply =
        comment.answerOwnerProfileId == controller.state.me.id &&
        comment.commenterProfileId != controller.state.me.id;
    final hasReplyDraft = controller.hasCommentReplyDraftForComment(comment);
    final showReplyEditor = canReply && hasReplyDraft;
    final replyInputValue = controller.commentReplyInputValueForComment(
      comment,
    );
    final replyLength = showReplyEditor
        ? replyInputValue.length
        : comment.replyBody.length;
    final isSaveTarget = controller.isCommentSaveTarget(
      questionId: comment.questionId,
      answerOwnerProfileId: comment.answerOwnerProfileId,
    );
    final isSaving =
        isSaveTarget && controller.state.commentSaveStatus == SaveStatus.saving;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onOpenFull,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: sans(size: 11, color: AlagagiColors.muted)),
                const SizedBox(height: 4),
                Text(
                  comment.body,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: sans(size: 13, height: 1.5),
                ),
                if (showReadableCue && onOpenFull != null) ...[
                  const SizedBox(height: 5),
                  const AlagagiFullTextCue(),
                ],
              ],
            ),
          ),
          if (canReply) ...[
            const SizedBox(height: 11),
            if (showReplyEditor)
              _AnswerCommentReplyEditor(
                controller: controller,
                comment: comment,
                inputValue: replyInputValue,
                inputLength: replyLength,
                isSaving: isSaving,
              )
            else if (comment.hasReply)
              _AnswerCommentReplyPreview(
                controller: controller,
                comment: comment,
                isSaving: isSaving,
              )
            else
              AlagagiInlineTextAction(
                label: '답장하기',
                onPressed: isSaving
                    ? null
                    : () => controller.updateAnswerCommentReplyDraft(
                        questionId: comment.questionId,
                        answerOwnerProfileId: comment.answerOwnerProfileId,
                        commenterProfileId: comment.commenterProfileId,
                        value: '',
                      ),
              ),
            if (isSaveTarget) ...[
              const SizedBox(height: 8),
              _CommentSaveStatus(
                controller: controller,
                questionId: comment.questionId,
                answerOwnerProfileId: comment.answerOwnerProfileId,
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _AnswerCommentReplyPreview extends StatelessWidget {
  const _AnswerCommentReplyPreview({
    required this.controller,
    required this.comment,
    required this.isSaving,
  });

  final AlagagiController controller;
  final AnswerComment comment;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F4),
        border: Border.all(color: const Color(0x336F7F63)),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.fromLTRB(11, 10, 9, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.subdirectory_arrow_right_rounded,
            size: 17,
            color: AlagagiColors.sageDeep,
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '내 답장',
                  style: sans(
                    size: 10.5,
                    color: AlagagiColors.sageDeep,
                    weight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  comment.replyBody,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: sans(size: 12.5, height: 1.45),
                ),
                if (comment.replyEdited) ...[
                  const SizedBox(height: 7),
                  const _EditedBadge(),
                ],
              ],
            ),
          ),
          const SizedBox(width: 6),
          _CommentIconButton(
            key: answerCommentReplyEditButtonKey,
            tooltip: '답장 수정',
            icon: Icons.edit_outlined,
            onPressed: isSaving
                ? null
                : () => controller.updateAnswerCommentReplyDraft(
                    questionId: comment.questionId,
                    answerOwnerProfileId: comment.answerOwnerProfileId,
                    commenterProfileId: comment.commenterProfileId,
                    value: comment.replyBody,
                  ),
          ),
        ],
      ),
    );
  }
}

class _AnswerCommentReplyEditor extends StatelessWidget {
  const _AnswerCommentReplyEditor({
    required this.controller,
    required this.comment,
    required this.inputValue,
    required this.inputLength,
    required this.isSaving,
  });

  final AlagagiController controller;
  final AnswerComment comment;
  final String inputValue;
  final int inputLength;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F4),
        border: Border.all(color: const Color(0x336F7F63)),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AlagagiColors.line),
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextFormField(
              key: answerCommentReplyFieldKey,
              initialValue: inputValue,
              maxLength: 120,
              minLines: 1,
              maxLines: 3,
              enabled: !isSaving,
              onChanged: (value) => controller.updateAnswerCommentReplyDraft(
                questionId: comment.questionId,
                answerOwnerProfileId: comment.answerOwnerProfileId,
                commenterProfileId: comment.commenterProfileId,
                value: value,
              ),
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
                hintText: '이 댓글에 짧게 답장해볼까요?',
              ),
              style: sans(size: 13, height: 1.5),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  '상대 댓글 아래에 한 번만 이어져요',
                  style: sans(size: 10.5, color: AlagagiColors.muted),
                ),
              ),
              Text(
                '$inputLength / 120',
                style: sans(size: 10.5, color: AlagagiColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              SizedBox(
                width: 88,
                child: _CommentSecondaryButton(
                  key: answerCommentReplyCancelButtonKey,
                  label: '취소',
                  onPressed: isSaving
                      ? null
                      : () => controller.cancelAnswerCommentReplyDraft(
                          questionId: comment.questionId,
                          answerOwnerProfileId: comment.answerOwnerProfileId,
                          commenterProfileId: comment.commenterProfileId,
                        ),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: _CommentPrimaryButton(
                  key: answerCommentReplySubmitButtonKey,
                  label: isSaving
                      ? '저장 중'
                      : comment.hasReply
                      ? '답장 수정'
                      : '답장 저장',
                  onPressed: isSaving
                      ? null
                      : () => controller.submitAnswerCommentReply(
                          questionId: comment.questionId,
                          answerOwnerProfileId: comment.answerOwnerProfileId,
                          commenterProfileId: comment.commenterProfileId,
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ReadOnlyCommentBlock extends StatelessWidget {
  const ReadOnlyCommentBlock({
    super.key,
    required this.label,
    required this.body,
    this.onOpenFull,
  });

  final String label;
  final String body;
  final VoidCallback? onOpenFull;

  @override
  Widget build(BuildContext context) {
    final showReadableCue = showsReadableCue(body);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onOpenFull,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: AlagagiColors.line),
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: sans(size: 11, color: AlagagiColors.muted)),
            const SizedBox(height: 4),
            Text(
              body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: sans(size: 13, height: 1.5),
            ),
            if (showReadableCue && onOpenFull != null) ...[
              const SizedBox(height: 5),
              const AlagagiFullTextCue(),
            ],
          ],
        ),
      ),
    );
  }
}
