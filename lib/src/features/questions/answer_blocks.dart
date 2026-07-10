import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/readable_detail_sheet.dart';
import '../../shared/text_editing_sync.dart';
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
        color: const Color(0xFFF5FCFF),
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
    final showEditor = !readOnly && hasDraft;
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

    final content = showEditor
        ? _AnswerCommentEditorShelf(
            controller: controller,
            questionId: questionId,
            answerOwnerProfileId: answerOwnerProfileId,
            existingComment: existingComment,
            inputValue: inputValue,
            inputLength: inputLength,
            isSaving: isSaving,
          )
        : existingComment == null
        ? _CollapsedAnswerCommentComposer(
            onPressed: () => controller.updateAnswerCommentDraft(
              questionId: questionId,
              answerOwnerProfileId: answerOwnerProfileId,
              value: '',
            ),
          )
        : _SavedAnswerCommentShelf(
            controller: controller,
            comment: existingComment,
            showEditButton: showEditButton,
            readOnly: readOnly,
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        content,
        if (isSaveTarget) ...[
          const SizedBox(height: 8),
          _CommentSaveStatus(
            controller: controller,
            questionId: questionId,
            answerOwnerProfileId: answerOwnerProfileId,
          ),
        ],
      ],
    );
  }
}

class _CollapsedAnswerCommentComposer extends StatelessWidget {
  const _CollapsedAnswerCommentComposer({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return _CommentShelfFrame(
      child: InkWell(
        key: answerCommentStartButtonKey,
        borderRadius: BorderRadius.circular(14),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
          child: Row(
            children: [
              _CommentAvatar(label: '나', color: AlagagiColors.gold),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  '이 답에 댓글 남기기',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: sans(size: 12.5, color: AlagagiColors.muted),
                ),
              ),
              const SizedBox(width: 9),
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: AlagagiColors.sageDeep,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SavedAnswerCommentShelf extends StatelessWidget {
  const _SavedAnswerCommentShelf({
    required this.controller,
    required this.comment,
    required this.showEditButton,
    required this.readOnly,
  });

  final AlagagiController controller;
  final AnswerComment comment;
  final bool showEditButton;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final showReadableCue = showsReadableCue(comment.body);
    return _CommentShelfFrame(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CommentAvatar(
            label: _profileShortLabel(controller, comment.commenterProfileId),
            color: AlagagiColors.gold,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => showReadableDetailSheet(
                context,
                label: '내 댓글',
                title: '상대 답에 남긴 댓글',
                body: comment.body,
                actionLabel: readOnly ? null : '수정하기',
                onAction: readOnly
                    ? null
                    : () => controller.updateAnswerCommentDraft(
                        questionId: comment.questionId,
                        answerOwnerProfileId: comment.answerOwnerProfileId,
                        value: comment.body,
                      ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CommentShelfTitle(
                    title: '내 댓글',
                    trailing: comment.edited ? '수정됨' : comment.createdLabel,
                    color: AlagagiColors.sageDeep,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    comment.body,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: sans(
                      size: 12.5,
                      color: const Color(0xFF435864),
                      height: 1.56,
                    ),
                  ),
                  if (showReadableCue) ...[
                    const SizedBox(height: 5),
                    const AlagagiFullTextCue(),
                  ],
                ],
              ),
            ),
          ),
          if (showEditButton) ...[
            const SizedBox(width: 6),
            _CommentIconButton(
              key: answerCommentEditButtonKey,
              tooltip: '댓글 수정',
              icon: Icons.edit_outlined,
              onPressed: () => controller.updateAnswerCommentDraft(
                questionId: comment.questionId,
                answerOwnerProfileId: comment.answerOwnerProfileId,
                value: comment.body,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AnswerCommentEditorShelf extends StatelessWidget {
  const _AnswerCommentEditorShelf({
    required this.controller,
    required this.questionId,
    required this.answerOwnerProfileId,
    required this.existingComment,
    required this.inputValue,
    required this.inputLength,
    required this.isSaving,
  });

  final AlagagiController controller;
  final String questionId;
  final String answerOwnerProfileId;
  final AnswerComment? existingComment;
  final String inputValue;
  final int inputLength;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    return _CommentShelfFrame(
      borderColor: const Color(0x5C6F7F63),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  existingComment == null ? '내 댓글' : '내 댓글 수정',
                  style: sans(
                    size: 12,
                    color: AlagagiColors.sageDeep,
                    weight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '$inputLength / 120',
                style: sans(size: 10.5, color: AlagagiColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AlagagiColors.line),
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _ImeSafeCommentTextField(
              fieldKey: answerCommentFieldKey,
              syncKey: '$questionId:$answerOwnerProfileId',
              initialValue: inputValue,
              hintText: existingComment == null
                  ? '이 답에 짧게 남겨볼까요?'
                  : '댓글을 다듬어볼까요?',
              onChanged: (value) => controller.updateAnswerCommentDraft(
                questionId: questionId,
                answerOwnerProfileId: answerOwnerProfileId,
                value: value,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '저장 전까지는 내 화면에서만 바뀌어요',
            style: sans(size: 10.5, color: AlagagiColors.muted),
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
              SizedBox(
                width: 84,
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
              Expanded(
                child: _CommentPrimaryButton(
                  key: answerCommentSubmitButtonKey,
                  label: isSaving
                      ? '저장 중'
                      : existingComment == null
                      ? '저장'
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
    );
  }
}

class _CommentShelfFrame extends StatelessWidget {
  const _CommentShelfFrame({
    required this.child,
    this.borderColor = AlagagiColors.line,
  });

  final Widget child;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Colors.white;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 21,
          top: -5,
          child: Transform.rotate(
            angle: math.pi / 4,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: backgroundColor,
                border: Border(
                  left: BorderSide(color: borderColor),
                  top: BorderSide(color: borderColor),
                ),
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
          child: child,
        ),
      ],
    );
  }
}

class _CommentAvatar extends StatelessWidget {
  const _CommentAvatar({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: sans(size: 10, color: color, weight: FontWeight.w800),
      ),
    );
  }
}

class _CommentShelfTitle extends StatelessWidget {
  const _CommentShelfTitle({
    required this.title,
    required this.trailing,
    required this.color,
  });

  final String title;
  final String trailing;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: sans(size: 11.5, color: color, weight: FontWeight.w800),
          ),
        ),
        if (trailing.isNotEmpty) ...[
          const SizedBox(width: 8),
          Text(trailing, style: sans(size: 10.5, color: AlagagiColors.muted)),
        ],
      ],
    );
  }
}

String _profileShortLabel(AlagagiController controller, String profileId) {
  final nickname = profileId == controller.state.me.id
      ? controller.state.me.nickname
      : profileId == controller.state.partner.id
      ? controller.state.partner.nickname
      : '';
  final trimmed = nickname.trim();
  if (trimmed.isEmpty) {
    return '?';
  }
  return String.fromCharCode(trimmed.runes.first);
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
        color: const Color(0xFFF5FCFF),
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
    this.footer,
    this.expanded = false,
    this.onToggle,
    this.onOpenFull,
  });

  final String label;
  final String body;
  final Color accentColor;
  final Widget? action;
  final Widget? footer;
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

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF5FCFF),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(17),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onOpenFull,
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
          if (footer != null) ...[const SizedBox(height: 13), footer!],
        ],
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

    return _CommentShelfFrame(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CommentAvatar(
            label: _profileShortLabel(controller, comment.commenterProfileId),
            color: AlagagiColors.lavender,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onOpenFull,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CommentShelfTitle(
                        title: label,
                        trailing: comment.edited ? '수정됨' : comment.createdLabel,
                        color: AlagagiColors.lavender,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        comment.body,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: sans(
                          size: 12.5,
                          color: const Color(0xFF435864),
                          height: 1.56,
                        ),
                      ),
                      if (showReadableCue && onOpenFull != null) ...[
                        const SizedBox(height: 5),
                        const AlagagiFullTextCue(),
                      ],
                    ],
                  ),
                ),
                if (canReply) ...[
                  const SizedBox(height: 10),
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
                              answerOwnerProfileId:
                                  comment.answerOwnerProfileId,
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
          ),
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
        color: const Color(0xFFF5FCFF),
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
        color: const Color(0xFFF5FCFF),
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
            child: _ImeSafeCommentTextField(
              fieldKey: answerCommentReplyFieldKey,
              syncKey:
                  '${comment.questionId}:${comment.answerOwnerProfileId}:${comment.commenterProfileId}',
              initialValue: inputValue,
              enabled: !isSaving,
              hintText: '이 댓글에 짧게 답장해볼까요?',
              onChanged: (value) => controller.updateAnswerCommentReplyDraft(
                questionId: comment.questionId,
                answerOwnerProfileId: comment.answerOwnerProfileId,
                commenterProfileId: comment.commenterProfileId,
                value: value,
              ),
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

class _ImeSafeCommentTextField extends StatefulWidget {
  const _ImeSafeCommentTextField({
    required this.fieldKey,
    required this.syncKey,
    required this.initialValue,
    required this.hintText,
    required this.onChanged,
    this.enabled = true,
  });

  final Key fieldKey;
  final String syncKey;
  final String initialValue;
  final String hintText;
  final ValueChanged<String> onChanged;
  final bool enabled;

  @override
  State<_ImeSafeCommentTextField> createState() =>
      _ImeSafeCommentTextFieldState();
}

class _ImeSafeCommentTextFieldState extends State<_ImeSafeCommentTextField> {
  late final ImeSafeTextEditingController _controller;
  late final FocusNode _focusNode;
  late final VoidCallback _detachFocusDispatch;

  @override
  void initState() {
    super.initState();
    _controller = ImeSafeTextEditingController(
      text: widget.initialValue,
      onCommittedChanged: widget.onChanged,
    );
    _focusNode = FocusNode();
    _detachFocusDispatch = dispatchTextOnFocusLost(_controller, _focusNode);
  }

  @override
  void didUpdateWidget(covariant _ImeSafeCommentTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.onCommittedChanged = widget.onChanged;
    final targetChanged = oldWidget.syncKey != widget.syncKey;
    if (targetChanged || oldWidget.initialValue != widget.initialValue) {
      _controller.syncText(
        widget.initialValue,
        focusNode: _focusNode,
        force: targetChanged || widget.initialValue.isEmpty,
      );
    }
  }

  @override
  void dispose() {
    _detachFocusDispatch();
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.fieldKey,
      controller: _controller,
      focusNode: _focusNode,
      maxLength: 120,
      minLines: 1,
      maxLines: 3,
      enabled: widget.enabled,
      decoration: InputDecoration(
        counterText: '',
        border: InputBorder.none,
        hintText: widget.hintText,
      ),
      style: sans(size: 13, height: 1.5),
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
