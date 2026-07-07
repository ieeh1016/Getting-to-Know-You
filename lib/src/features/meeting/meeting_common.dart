import 'package:flutter/material.dart';

import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/ui_style.dart';

String dateKeyForUi(DateTime date) {
  String twoDigits(int value) => value.toString().padLeft(2, '0');
  return '${date.year}-${twoDigits(date.month)}-${twoDigits(date.day)}';
}

String meetingDateLabel(String dateKey) {
  final date = DateTime.tryParse(dateKey);
  if (date == null) {
    return dateKey;
  }
  const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
  return '${date.month}월 ${date.day}일 ${weekdays[date.weekday - 1]}요일';
}

String meetingDateShortLabel(String dateKey) {
  final date = DateTime.tryParse(dateKey);
  if (date == null) {
    return dateKey;
  }
  return '${date.month}월 ${date.day}일';
}

String meetingAvailabilityLabel(MeetingAvailability? availability) {
  return switch (availability) {
    MeetingAvailability.available => '가능',
    MeetingAvailability.maybe => '조율 필요',
    MeetingAvailability.busy => '어려움',
    null => '아직 없음',
  };
}

String meetingTimeSlotLabel(MeetingTimeSlot slot) {
  return switch (slot) {
    MeetingTimeSlot.morning => '오전',
    MeetingTimeSlot.afternoon => '오후',
    MeetingTimeSlot.evening => '저녁',
  };
}

String meetingTimeBlockLabel(ScheduleTimeBlock block) {
  return '${block.timeLabel} · ${block.title}';
}

Future<void> confirmCancelMeetingDay(
  BuildContext context,
  AlagagiController controller,
  String dateKey,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('만남을 취소할까요?', style: serif(context, size: 20)),
      content: Text(
        '${meetingDateLabel(dateKey)} 만남이 계획 탭에서 빠져요.',
        style: sans(size: 13, height: 1.45, color: AlagagiColors.muted),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('아니요', style: sans(size: 13, weight: FontWeight.w800)),
        ),
        FilledButton(
          key: meetingDayCancelConfirmButtonKey,
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF8F5C4D),
            foregroundColor: Colors.white,
          ),
          child: Text('만남 취소', style: sans(size: 13, weight: FontWeight.w800)),
        ),
      ],
    ),
  );
  if (confirmed == true && context.mounted) {
    controller.cancelMeetingDay(dateKey);
  }
}

class MeetingSaveStatus extends StatelessWidget {
  const MeetingSaveStatus({super.key, required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
    final status = state.meetingSaveStatus;
    final message = switch (status) {
      SaveStatus.saving => '일정을 저장하고 있어요.',
      SaveStatus.saved => state.meetingSaveFeedback,
      SaveStatus.failed => state.meetingDraftError,
      SaveStatus.idle => null,
    };
    if (message == null || message.isEmpty) {
      return const SizedBox.shrink();
    }
    final failed = status == SaveStatus.failed;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(
          color: failed ? const Color(0xFFFFF7F3) : const Color(0xFFF3FBFF),
          border: Border.all(
            color: failed ? const Color(0x33B18472) : const Color(0x338A9A7E),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(
              failed
                  ? Icons.error_outline_rounded
                  : status == SaveStatus.saving
                  ? Icons.sync_rounded
                  : Icons.check_circle_outline_rounded,
              size: 16,
              color: failed ? const Color(0xFFB18472) : AlagagiColors.sageDeep,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: sans(
                  size: 12,
                  color: failed
                      ? const Color(0xFFB18472)
                      : AlagagiColors.sageDeep,
                  weight: FontWeight.w700,
                ),
              ),
            ),
            if (failed && controller.canRetryMeetingSave)
              TextButton(
                key: meetingRetryButtonKey,
                onPressed: controller.retryMeetingSave,
                child: Text(
                  '다시 시도',
                  style: sans(size: 12, weight: FontWeight.w800),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class MeetingTextField extends StatefulWidget {
  const MeetingTextField({
    super.key,
    required this.fieldKey,
    required this.label,
    required this.hint,
    required this.initialValue,
    required this.maxLength,
    required this.helperText,
    required this.onChanged,
    this.minLines = 2,
    this.maxLines = 3,
    this.keyboardType,
  });

  final Key fieldKey;
  final String label;
  final String hint;
  final String initialValue;
  final int maxLength;
  final String helperText;
  final ValueChanged<String> onChanged;
  final int minLines;
  final int maxLines;
  final TextInputType? keyboardType;

  @override
  State<MeetingTextField> createState() => _MeetingTextFieldState();
}

class _MeetingTextFieldState extends State<MeetingTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant MeetingTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue &&
        _controller.text != widget.initialValue) {
      _controller.text = widget.initialValue;
      _controller.selection = TextSelection.collapsed(
        offset: widget.initialValue.length,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5FCFF),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.fromLTRB(14, 7, 14, 7),
      child: TextFormField(
        key: widget.fieldKey,
        controller: _controller,
        maxLength: widget.maxLength,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          helperText: widget.helperText.isEmpty ? null : widget.helperText,
          counterText: '',
          isDense: true,
          border: InputBorder.none,
        ),
        style: sans(size: 13, height: 1.45),
      ),
    );
  }
}
