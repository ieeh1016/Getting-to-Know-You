import 'package:flutter/material.dart';

import '../app/test_keys.dart';
import 'ui_style.dart';

/// 날짜와 시각을 손으로 타이핑하지 않고 고르게 하는 공용 bottom sheet.
///
/// `2026-09-12`나 `09:30`을 직접 적게 하면 형식을 틀리기 쉽고 앱처럼 느껴지지
/// 않는다. 값의 모양은 그대로 두되 고르는 방법만 바꾼다.
Future<T?> _showPickerSheet<T>(
  BuildContext context, {
  required String title,
  required Widget Function(BuildContext sheetContext) builder,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          decoration: BoxDecoration(
            color: AlagagiColors.paper,
            border: Border.all(color: AlagagiColors.line),
            borderRadius: BorderRadius.circular(26),
            boxShadow: const [
              BoxShadow(
                color: Color(0x2E2C2B25),
                blurRadius: 40,
                offset: Offset(0, 16),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD7D0BD),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: serif(
                          sheetContext,
                          size: 17,
                          weight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: '닫기',
                      onPressed: () => Navigator.of(sheetContext).pop(),
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(
                        Icons.close_rounded,
                        size: 19,
                        color: AlagagiColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(child: builder(sheetContext)),
              ),
              const SizedBox(height: 14),
            ],
          ),
        ),
      );
    },
  );
}

String alagagiDateKey(DateTime date) {
  String pad(int value) => value.toString().padLeft(2, '0');
  return '${date.year}-${pad(date.month)}-${pad(date.day)}';
}

const _weekdayLabels = ['일', '월', '화', '수', '목', '금', '토'];

/// 달력에서 날짜 하나를 고른다. 범위 밖 날짜는 누를 수 없다.
Future<DateTime?> showAlagagiDatePicker(
  BuildContext context, {
  required String title,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) {
  return _showPickerSheet<DateTime>(
    context,
    title: title,
    builder: (sheetContext) => _MonthCalendar(
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      onPick: (date) => Navigator.of(sheetContext).pop(date),
    ),
  );
}

class _MonthCalendar extends StatefulWidget {
  const _MonthCalendar({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onPick,
  });

  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime> onPick;

  @override
  State<_MonthCalendar> createState() => _MonthCalendarState();
}

class _MonthCalendarState extends State<_MonthCalendar> {
  late DateTime _visibleMonth;

  @override
  void initState() {
    super.initState();
    final anchor = widget.initialDate ?? widget.firstDate ?? DateTime.now();
    _visibleMonth = DateTime(anchor.year, anchor.month);
  }

  bool _isSelectable(DateTime date) {
    final first = widget.firstDate;
    final last = widget.lastDate;
    if (first != null && date.isBefore(DateTime(first.year, first.month, first.day))) {
      return false;
    }
    if (last != null && date.isAfter(DateTime(last.year, last.month, last.day))) {
      return false;
    }
    return true;
  }

  void _shiftMonth(int delta) {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + delta);
    });
  }

  @override
  Widget build(BuildContext context) {
    final firstOfMonth = DateTime(_visibleMonth.year, _visibleMonth.month);
    final daysInMonth = DateTime(
      _visibleMonth.year,
      _visibleMonth.month + 1,
      0,
    ).day;
    final leading = firstOfMonth.weekday % 7;
    final selected = widget.initialDate;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _MonthArrow(
                buttonKey: datePickerPreviousMonthButtonKey,
                icon: Icons.chevron_left_rounded,
                onTap: () => _shiftMonth(-1),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    '${_visibleMonth.year}년 ${_visibleMonth.month}월',
                    style: sans(size: 13.5, weight: FontWeight.w800),
                  ),
                ),
              ),
              _MonthArrow(
                buttonKey: datePickerNextMonthButtonKey,
                icon: Icons.chevron_right_rounded,
                onTap: () => _shiftMonth(1),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (final label in _weekdayLabels)
                Expanded(
                  child: Center(
                    child: Text(
                      label,
                      style: sans(size: 11, color: AlagagiColors.muted),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            // 폭이 넓어도 줄 높이는 그대로 둔다. 정사각 비율로 두면 넓은
            // 화면에서 달력이 세로로 넘친다.
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              mainAxisExtent: 42,
            ),
            itemCount: leading + daysInMonth,
            itemBuilder: (context, index) {
              if (index < leading) {
                return const SizedBox.shrink();
              }
              final day = index - leading + 1;
              final date = DateTime(
                _visibleMonth.year,
                _visibleMonth.month,
                day,
              );
              final selectable = _isSelectable(date);
              final isSelected =
                  selected != null &&
                  selected.year == date.year &&
                  selected.month == date.month &&
                  selected.day == date.day;

              return _CalendarDay(
                dateKey: alagagiDateKey(date),
                day: day,
                selected: isSelected,
                enabled: selectable,
                onTap: selectable ? () => widget.onPick(date) : null,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MonthArrow extends StatelessWidget {
  const _MonthArrow({
    required this.buttonKey,
    required this.icon,
    required this.onTap,
  });

  final Key buttonKey;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: buttonKey,
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AlagagiColors.skyPanel,
          shape: BoxShape.circle,
          border: Border.all(color: AlagagiColors.line),
        ),
        child: Icon(icon, size: 18, color: AlagagiColors.sageDeep),
      ),
    );
  }
}

class _CalendarDay extends StatelessWidget {
  const _CalendarDay({
    required this.dateKey,
    required this.day,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final String dateKey;
  final int day;
  final bool selected;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: datePickerDayButtonKey(dateKey),
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Center(
        child: Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AlagagiColors.sageDeep : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Text(
            '$day',
            style: sans(
              size: 12.5,
              weight: selected ? FontWeight.w800 : FontWeight.w600,
              color: selected
                  ? AlagagiColors.appBackground
                  : enabled
                  ? AlagagiColors.ink
                  : const Color(0xFFC9C3B4),
            ),
          ),
        ),
      ),
    );
  }
}

/// 시각을 `HH:mm`으로 고른다. 분은 5분 단위다.
Future<String?> showAlagagiTimePicker(
  BuildContext context, {
  required String title,
  String? initialLabel,
}) {
  return _showPickerSheet<String>(
    context,
    title: title,
    builder: (sheetContext) => _TimeWheel(
      initialLabel: initialLabel,
      onPick: (label) => Navigator.of(sheetContext).pop(label),
    ),
  );
}

class _TimeWheel extends StatefulWidget {
  const _TimeWheel({required this.initialLabel, required this.onPick});

  final String? initialLabel;
  final ValueChanged<String> onPick;

  @override
  State<_TimeWheel> createState() => _TimeWheelState();
}

class _TimeWheelState extends State<_TimeWheel> {
  static const List<int> _minutes = [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55];

  late int _hour;
  late int _minute;

  @override
  void initState() {
    super.initState();
    final parts = (widget.initialLabel ?? '').split(':');
    final parsedHour = parts.length == 2 ? int.tryParse(parts.first) : null;
    final parsedMinute = parts.length == 2 ? int.tryParse(parts.last) : null;
    _hour = parsedHour != null && parsedHour >= 0 && parsedHour <= 23
        ? parsedHour
        : 9;
    // 5분 단위로 맞춰 둔다. 어긋난 값이 들어와도 가장 가까운 칸을 고른다.
    final minute = parsedMinute != null && parsedMinute >= 0 && parsedMinute <= 59
        ? parsedMinute
        : 0;
    _minute = _minutes.reduce(
      (a, b) => (a - minute).abs() <= (b - minute).abs() ? a : b,
    );
  }

  String get _label {
    String pad(int value) => value.toString().padLeft(2, '0');
    return '${pad(_hour)}:${pad(_minute)}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _label,
          key: timePickerPreviewKey,
          style: serif(context, size: 30, weight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 190,
          child: Row(
            children: [
              Expanded(
                child: _WheelColumn(
                  key: timePickerHourColumnKey,
                  label: '시',
                  values: List<int>.generate(24, (index) => index),
                  selected: _hour,
                  keyBuilder: timePickerHourButtonKey,
                  onSelected: (value) => setState(() => _hour = value),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _WheelColumn(
                  key: timePickerMinuteColumnKey,
                  label: '분',
                  values: _minutes,
                  selected: _minute,
                  keyBuilder: timePickerMinuteButtonKey,
                  onSelected: (value) => setState(() => _minute = value),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              key: timePickerConfirmButtonKey,
              onPressed: () => widget.onPick(_label),
              style: FilledButton.styleFrom(
                backgroundColor: AlagagiColors.ink,
                foregroundColor: AlagagiColors.appBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 13),
                textStyle: sans(size: 12.5, weight: FontWeight.w800),
              ),
              child: const Text('이 시각으로'),
            ),
          ),
        ),
      ],
    );
  }
}

class _WheelColumn extends StatefulWidget {
  const _WheelColumn({
    super.key,
    required this.label,
    required this.values,
    required this.selected,
    required this.keyBuilder,
    required this.onSelected,
  });

  /// 한 칸 높이. 열 때 현재 값으로 스크롤을 맞추려면 고정 높이가 필요하다.
  static const double itemExtent = 38;

  final String label;
  final List<int> values;
  final int selected;
  final Key Function(int value) keyBuilder;
  final ValueChanged<int> onSelected;

  @override
  State<_WheelColumn> createState() => _WheelColumnState();
}

class _WheelColumnState extends State<_WheelColumn> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    // 늘 00부터 보여주면 지금 값을 찾으러 매번 스크롤해야 한다.
    // 현재 값이 위쪽에 걸치도록 열어 둔다.
    final index = widget.values.indexOf(widget.selected);
    final offset = index < 0
        ? 0.0
        : (index * _WheelColumn.itemExtent - 60).clamp(
            0.0,
            double.infinity,
          );
    _scrollController = ScrollController(initialScrollOffset: offset);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.label;
    final values = widget.values;
    final selected = widget.selected;
    final keyBuilder = widget.keyBuilder;
    final onSelected = widget.onSelected;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: sans(size: 11, color: AlagagiColors.muted),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AlagagiColors.skyPanel,
              border: Border.all(color: AlagagiColors.line),
              borderRadius: BorderRadius.circular(14),
            ),
            clipBehavior: Clip.antiAlias,
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemExtent: _WheelColumn.itemExtent,
              itemCount: values.length,
              itemBuilder: (context, index) {
                final value = values[index];
                final isSelected = value == selected;
                return InkWell(
                  key: keyBuilder(value),
                  onTap: () => onSelected(value),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AlagagiColors.sageDeep
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Text(
                      value.toString().padLeft(2, '0'),
                      style: sans(
                        size: 13,
                        weight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected
                            ? AlagagiColors.appBackground
                            : AlagagiColors.ink,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
