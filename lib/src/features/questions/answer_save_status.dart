import 'package:flutter/material.dart';

import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/ui_components.dart';
import '../../shared/ui_style.dart';

class AnswerSaveStatus extends StatelessWidget {
  const AnswerSaveStatus({
    super.key,
    required this.controller,
    this.questionId,
  });

  final AlagagiController controller;
  final String? questionId;

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
    final status = state.answerSaveStatus;
    if (questionId != null && state.answerSaveQuestionId != questionId) {
      return const SizedBox.shrink();
    }
    final message = switch (status) {
      SaveStatus.saving => '저장 중이에요...',
      SaveStatus.saved => state.answerSaveFeedback,
      SaveStatus.failed => state.answerError,
      SaveStatus.idle => null,
    };
    if (message == null || message.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              message,
              style: sans(
                size: 12,
                color: status == SaveStatus.failed
                    ? AlagagiColors.sageDeep
                    : AlagagiColors.muted,
                height: 1.5,
              ),
            ),
          ),
          if (status == SaveStatus.failed)
            AlagagiInlineTextAction(
              key: answerRetryButtonKey,
              label: '다시 시도',
              onPressed: controller.retryAnswerSave,
            ),
        ],
      ),
    );
  }
}
