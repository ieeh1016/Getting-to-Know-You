import 'package:flutter/material.dart';

import '../../domain/alagagi_controller.dart';
import '../../shared/ui_components.dart';
import '../../shared/ui_style.dart';

/// 여행 화면과 여행 sheet가 함께 쓰는 입력 조각들.

class TripPickerRow extends StatelessWidget {
  const TripPickerRow({
    super.key,
    required this.rowKey,
    required this.label,
    required this.value,
    required this.placeholder,
    required this.icon,
    required this.onTap,
    this.onClear,
    this.clearKey,
  });

  final Key rowKey;
  final String label;
  final String? value;
  final String placeholder;
  final IconData icon;
  final VoidCallback onTap;

  /// 값이 있을 때만 보이는 지우기. 한번 고른 시각을 되돌릴 길이 없으면
  /// 항목을 지웠다가 다시 담는 수밖에 없다.
  final VoidCallback? onClear;
  final Key? clearKey;

  @override
  Widget build(BuildContext context) {
    final filled = value != null && value!.isNotEmpty;

    return InkWell(
      key: rowKey,
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: AlagagiColors.skyPanel,
          border: Border.all(color: AlagagiColors.line),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.fromLTRB(13, 9, 11, 9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: sans(size: 10.8, color: AlagagiColors.muted)),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    filled ? value! : placeholder,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: sans(
                      size: 13,
                      weight: filled ? FontWeight.w700 : FontWeight.w500,
                      color: filled
                          ? AlagagiColors.ink
                          : AlagagiColors.muted,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                if (filled && onClear != null)
                  InkWell(
                    key: clearKey,
                    onTap: onClear,
                    borderRadius: BorderRadius.circular(9),
                    child: const Padding(
                      padding: EdgeInsets.all(3),
                      child: Icon(
                        Icons.close_rounded,
                        size: 15,
                        color: AlagagiColors.muted,
                      ),
                    ),
                  )
                else
                  Icon(icon, size: 15, color: AlagagiColors.sageDeep),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TripFieldLabel extends StatelessWidget {
  const TripFieldLabel({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: sans(size: 11.5, color: AlagagiColors.muted));
  }
}

/// 여행 기간 안의 날짜를 `1일차`처럼 순서로 고르게 한다.
class TripDayPicker extends StatelessWidget {
  const TripDayPicker({
    super.key,
    required this.trip,
    required this.selectedDateKey,
    required this.keyBuilder,
    required this.onSelected,
    this.allowsUndecided = false,
    this.enabledFrom,
  });

  final Trip trip;
  final String? selectedDateKey;
  final Key Function(String dateKey) keyBuilder;
  final ValueChanged<String?> onSelected;
  final bool allowsUndecided;

  /// 이 날짜보다 뒤에 오는 날만 고를 수 있게 한다.
  final String? enabledFrom;

  @override
  Widget build(BuildContext context) {
    final dateKeys = trip.dateKeys;

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        if (allowsUndecided)
          AlagagiFilterPill(
            key: keyBuilder('none'),
            label: '미정',
            selected: selectedDateKey == null,
            onTap: () => onSelected(null),
          ),
        for (var index = 0; index < dateKeys.length; index += 1)
          if (enabledFrom == null || dateKeys[index].compareTo(enabledFrom!) > 0)
            AlagagiFilterPill(
              key: keyBuilder(dateKeys[index]),
              label: '${index + 1}일차',
              selected: selectedDateKey == dateKeys[index],
              onTap: () => onSelected(dateKeys[index]),
            ),
      ],
    );
  }
}

class TripTextField extends StatelessWidget {
  const TripTextField({
    super.key,
    required this.fieldKey,
    required this.controller,
    required this.label,
    required this.hint,
    required this.maxLength,
    this.maxLines = 1,
    this.keyboardType,
  });

  final Key fieldKey;
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLength;
  final int maxLines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AlagagiColors.skyPanel,
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.fromLTRB(14, 7, 14, 7),
      child: TextField(
        key: fieldKey,
        controller: controller,
        maxLength: maxLength,
        minLines: maxLines,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          counterText: '',
          border: InputBorder.none,
        ),
        style: sans(size: 13.5, height: 1.5),
      ),
    );
  }
}

/// sheet 아래에 놓이는 주 action. 손가락 높이를 넉넉히 잡는다.
class TripPrimaryButton extends StatelessWidget {
  const TripPrimaryButton({
    super.key,
    required this.buttonKey,
    required this.label,
    required this.onPressed,
  });

  final Key buttonKey;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: FilledButton(
        key: buttonKey,
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AlagagiColors.ink,
          foregroundColor: AlagagiColors.appBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          textStyle: sans(size: 13, weight: FontWeight.w800),
        ),
        child: Text(label),
      ),
    );
  }
}
