import 'package:flutter/material.dart';

import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/picker_sheets.dart';
import '../../shared/text_editing_sync.dart';
import '../../shared/ui_components.dart';
import '../../shared/ui_style.dart';
import 'trip_form_fields.dart';
import 'trip_timeline.dart';

/// 여행 화면의 입력은 모두 bottom sheet로 연다.
///
/// 폼을 목록 위에 늘 펼쳐두면 읽을 자리를 뺏고 화면이 양식처럼 보인다.
/// 만들 때만 올라오고 저장하면 닫히는 편이 앱의 흐름에 맞는다.
Future<T?> _showFormSheet<T>(
  BuildContext context, {
  required Key sheetKey,
  required String title,
  String? subtitle,
  required Widget Function(BuildContext sheetContext) builder,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return Padding(
        // 키보드가 올라와도 입력 칸이 가리지 않게 한다.
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: SafeArea(
          child: Container(
            key: sheetKey,
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(sheetContext).size.height * 0.86,
            ),
            decoration: BoxDecoration(
              color: AlagagiColors.paper,
              border: Border.all(color: AlagagiColors.line),
              borderRadius: BorderRadius.circular(26),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x2E2C2B25),
                  blurRadius: 44,
                  offset: Offset(0, 18),
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
                  padding: const EdgeInsets.fromLTRB(18, 14, 10, 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: serif(
                                sheetContext,
                                size: 18,
                                weight: FontWeight.w800,
                              ),
                            ),
                            if (subtitle != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                subtitle,
                                style: sans(
                                  size: 12,
                                  color: AlagagiColors.muted,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      // 44px 이상이라 손가락으로 눌러도 빗나가지 않는다.
                      SizedBox(
                        width: 44,
                        height: 44,
                        child: IconButton(
                          onPressed: () => Navigator.of(sheetContext).pop(),
                          icon: const Icon(
                            Icons.close_rounded,
                            size: 20,
                            color: AlagagiColors.muted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 4, 18, 16),
                    child: builder(sheetContext),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

/// 여행을 만들거나 고친다.
Future<void> showTripFormSheet(
  BuildContext context, {
  required AlagagiController controller,
  Trip? trip,
}) {
  return _showFormSheet<void>(
    context,
    sheetKey: tripFormSheetKey,
    title: trip == null ? '새 여행' : '여행 고치기',
    subtitle: trip == null ? '이름과 기간만 있으면 시작할 수 있어요' : null,
    builder: (sheetContext) =>
        _TripForm(controller: controller, trip: trip, sheetContext: sheetContext),
  );
}

class _TripForm extends StatefulWidget {
  const _TripForm({
    required this.controller,
    required this.trip,
    required this.sheetContext,
  });

  final AlagagiController controller;
  final Trip? trip;
  final BuildContext sheetContext;

  @override
  State<_TripForm> createState() => _TripFormState();
}

class _TripFormState extends State<_TripForm> {
  late final ImeSafeTextEditingController _titleController;
  late final ImeSafeTextEditingController _destinationController;
  String? _startDateKey;
  String? _endDateKey;
  String? _error;

  @override
  void initState() {
    super.initState();
    _titleController = ImeSafeTextEditingController(
      text: widget.trip?.title ?? '',
    );
    _destinationController = ImeSafeTextEditingController(
      text: widget.trip?.destination ?? '',
    );
    _startDateKey = widget.trip?.startDateKey;
    _endDateKey = widget.trip?.endDateKey;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  String? get _durationLabel {
    final start = DateTime.tryParse(_startDateKey ?? '');
    final end = DateTime.tryParse(_endDateKey ?? '');
    if (start == null || end == null || end.isBefore(start)) {
      return null;
    }
    final nights = end.difference(start).inDays;
    return nights == 0 ? '당일치기' : '$nights박 ${nights + 1}일';
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final start = DateTime.tryParse(_startDateKey ?? '');
    final picked = await showAlagagiDatePicker(
      context,
      title: isStart ? '떠나는 날' : '돌아오는 날',
      initialDate: isStart
          ? start
          : DateTime.tryParse(_endDateKey ?? '') ?? start,
      firstDate: isStart ? DateTime(now.year - 1) : start,
      lastDate: DateTime(now.year + 3),
    );
    if (picked == null) {
      return;
    }
    setState(() {
      final dateKey = alagagiDateKey(picked);
      if (isStart) {
        _startDateKey = dateKey;
        final end = DateTime.tryParse(_endDateKey ?? '');
        if (end != null && end.isBefore(picked)) {
          _endDateKey = null;
        }
      } else {
        _endDateKey = dateKey;
      }
      _error = null;
    });
  }

  void _submit() {
    final error = widget.controller.saveTrip(
      tripId: widget.trip?.id,
      title: _titleController.text,
      destination: _destinationController.text,
      startDateKey: _startDateKey ?? '',
      endDateKey: _endDateKey ?? '',
    );
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    Navigator.of(widget.sheetContext).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TripTextField(
          fieldKey: tripTitleFieldKey,
          controller: _titleController,
          label: '여행 이름',
          hint: '예: 가을 제주',
          maxLength: 60,
        ),
        const SizedBox(height: 10),
        TripTextField(
          fieldKey: tripDestinationFieldKey,
          controller: _destinationController,
          label: '어디로',
          hint: '예: 제주도',
          maxLength: 60,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TripPickerRow(
                rowKey: tripStartDateFieldKey,
                label: '떠나는 날',
                value: _startDateKey,
                placeholder: '날짜 고르기',
                icon: Icons.calendar_today_outlined,
                onTap: () => _pickDate(isStart: true),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TripPickerRow(
                rowKey: tripEndDateFieldKey,
                label: '돌아오는 날',
                value: _endDateKey,
                placeholder: '날짜 고르기',
                icon: Icons.calendar_today_outlined,
                onTap: () => _pickDate(isStart: false),
              ),
            ),
          ],
        ),
        if (_durationLabel != null) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.nights_stay_outlined,
                size: 15,
                color: AlagagiColors.sageDeep,
              ),
              const SizedBox(width: 6),
              Text(
                _durationLabel!,
                style: sans(
                  size: 12.5,
                  weight: FontWeight.w800,
                  color: AlagagiColors.sageDeep,
                ),
              ),
            ],
          ),
        ],
        if (_error != null) ...[
          const SizedBox(height: 10),
          _FormError(message: _error!),
        ],
        const SizedBox(height: 16),
        TripPrimaryButton(
          buttonKey: tripSubmitButtonKey,
          label: widget.trip == null ? '여행 만들기' : '고친 내용 저장하기',
          onPressed: _submit,
        ),
      ],
    );
  }
}

/// 무엇을 추가할지 먼저 고른다. 종류마다 물어보는 것이 달라서다.
Future<TripItemKind?> showTripKindPickerSheet(BuildContext context) {
  return _showFormSheet<TripItemKind>(
    context,
    sheetKey: tripKindPickerSheetKey,
    title: '무엇을 담을까요',
    builder: (sheetContext) => Column(
      children: [
        for (final kind in tripItemKindOptions) ...[
          _KindOption(
            kind: kind,
            onTap: () => Navigator.of(sheetContext).pop(kind),
          ),
          if (kind != tripItemKindOptions.last) const SizedBox(height: 8),
        ],
      ],
    ),
  );
}

class _KindOption extends StatelessWidget {
  const _KindOption({required this.kind, required this.onTap});

  final TripItemKind kind;
  final VoidCallback onTap;

  String get _hint => switch (kind) {
    TripItemKind.stay => '체크인부터 체크아웃까지',
    TripItemKind.transport => '수단과 출발·도착',
    TripItemKind.packing => '챙길 것 목록',
    TripItemKind.plan => '그날 무엇을 할지',
  };

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: tripKindPickerOptionKey(kind.storageKey),
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        // 손가락으로 누르는 줄이라 넉넉히 잡는다.
        constraints: const BoxConstraints(minHeight: 60),
        decoration: BoxDecoration(
          color: AlagagiColors.skyPanel,
          border: Border.all(color: AlagagiColors.line),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.fromLTRB(13, 11, 13, 11),
        child: Row(
          children: [
            AlagagiSymbolMark(
              icon: tripItemKindIcon(kind),
              size: 34,
              iconSize: 17,
              tone: AlagagiColors.paper,
              iconColor: AlagagiColors.sageDeep,
              radius: 12,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kind.label,
                    style: sans(size: 13.5, weight: FontWeight.w800),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _hint,
                    style: sans(size: 11.5, color: AlagagiColors.muted),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AlagagiColors.muted,
            ),
          ],
        ),
      ),
    );
  }
}

/// 여행 항목을 만들거나 고친다. 종류에 따라 묻는 것이 달라진다.
Future<void> showTripItemFormSheet(
  BuildContext context, {
  required AlagagiController controller,
  required Trip trip,
  required TripItemKind kind,
  TripItem? item,
}) {
  return _showFormSheet<void>(
    context,
    sheetKey: tripItemFormSheetKey,
    title: item == null ? '${kind.label} 추가' : '${kind.label} 고치기',
    subtitle: trip.title,
    builder: (sheetContext) => _TripItemForm(
      controller: controller,
      trip: trip,
      kind: kind,
      item: item,
      sheetContext: sheetContext,
    ),
  );
}

class _TripItemForm extends StatefulWidget {
  const _TripItemForm({
    required this.controller,
    required this.trip,
    required this.kind,
    required this.item,
    required this.sheetContext,
  });

  final AlagagiController controller;
  final Trip trip;
  final TripItemKind kind;
  final TripItem? item;
  final BuildContext sheetContext;

  @override
  State<_TripItemForm> createState() => _TripItemFormState();
}

class _TripItemFormState extends State<_TripItemForm> {
  late final ImeSafeTextEditingController _titleController;
  late final ImeSafeTextEditingController _noteController;
  late final ImeSafeTextEditingController _fromController;
  late final ImeSafeTextEditingController _toController;
  String? _dateKey;
  String? _endDateKey;
  String? _timeLabel;
  String? _endTimeLabel;
  late TripTransportMode _mode;
  String? _error;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _titleController = ImeSafeTextEditingController(text: item?.title ?? '');
    _noteController = ImeSafeTextEditingController(text: item?.note ?? '');
    _fromController = ImeSafeTextEditingController(text: item?.fromLabel ?? '');
    _toController = ImeSafeTextEditingController(text: item?.toLabel ?? '');
    _dateKey = item?.dateKey;
    _endDateKey = item?.endDateKey;
    _timeLabel = item?.timeLabel;
    _endTimeLabel = item?.endTimeLabel;
    _mode = item?.transportMode ?? TripTransportMode.flight;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  Future<void> _pickTime({
    required String title,
    required String? current,
    required ValueChanged<String> onPicked,
  }) async {
    final picked = await showAlagagiTimePicker(
      context,
      title: title,
      initialLabel: current,
    );
    if (picked == null) {
      return;
    }
    setState(() {
      onPicked(picked);
      _error = null;
    });
  }

  int get _nightPreview {
    final start = DateTime.tryParse(_dateKey ?? '');
    final end = DateTime.tryParse(_endDateKey ?? '');
    if (start == null || end == null) {
      return 0;
    }
    final nights = end.difference(start).inDays;
    return nights < 0 ? 0 : nights;
  }

  void _submit() {
    final error = widget.controller.saveTripItem(
      tripId: widget.trip.id,
      itemId: widget.item?.id,
      kind: widget.kind,
      title: _titleController.text,
      note: _noteController.text,
      dateKey: _dateKey,
      timeLabel: _timeLabel,
      endDateKey: widget.kind.usesDateRange ? _endDateKey : null,
      endTimeLabel: _endTimeLabel,
      transportMode: widget.kind.usesRoute ? _mode : null,
      fromLabel: _fromController.text,
      toLabel: _toController.text,
    );
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    Navigator.of(widget.sheetContext).pop();
  }

  @override
  Widget build(BuildContext context) {
    final kind = widget.kind;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (kind.usesRoute) ..._routeFields(),
        TripTextField(
          fieldKey: tripItemTitleFieldKey,
          controller: _titleController,
          label: kind.usesRoute ? '편명이나 노선' : kind.label,
          hint: kind.usesRoute ? _mode.titleHint : kind.titleHint,
          maxLength: 80,
        ),
        const SizedBox(height: 10),
        TripTextField(
          fieldKey: tripItemNoteFieldKey,
          controller: _noteController,
          label: '메모',
          hint: kind.noteHint,
          maxLength: 500,
          maxLines: 3,
        ),
        if (kind.usesDateRange) ..._stayFields(),
        if (kind.usesRoute || kind == TripItemKind.plan) ..._scheduleFields(),
        if (_error != null) ...[
          const SizedBox(height: 10),
          _FormError(message: _error!),
        ],
        const SizedBox(height: 16),
        TripPrimaryButton(
          buttonKey: tripItemSubmitButtonKey,
          label: widget.item == null ? '${kind.label} 담기' : '고친 내용 저장하기',
          onPressed: _submit,
        ),
      ],
    );
  }

  List<Widget> _routeFields() {
    return [
      const TripFieldLabel(text: '무엇으로'),
      const SizedBox(height: 8),
      Wrap(
        spacing: 7,
        runSpacing: 7,
        children: [
          for (final mode in tripTransportModeOptions)
            AlagagiFilterPill(
              key: tripTransportModeButtonKey(mode.storageKey),
              label: mode.label,
              selected: _mode == mode,
              onTap: () => setState(() => _mode = mode),
            ),
        ],
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: TripTextField(
              fieldKey: tripItemFromFieldKey,
              controller: _fromController,
              label: '어디서',
              hint: '예: 김포공항',
              maxLength: 40,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 7),
            child: Icon(
              Icons.arrow_right_alt_rounded,
              size: 18,
              color: AlagagiColors.sageDeep,
            ),
          ),
          Expanded(
            child: TripTextField(
              fieldKey: tripItemToFieldKey,
              controller: _toController,
              label: '어디로',
              hint: '예: 제주공항',
              maxLength: 40,
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
    ];
  }

  List<Widget> _stayFields() {
    return [
      const SizedBox(height: 12),
      const TripFieldLabel(text: '체크인'),
      const SizedBox(height: 8),
      TripDayPicker(
        trip: widget.trip,
        selectedDateKey: _dateKey,
        keyBuilder: tripItemDateButtonKey,
        onSelected: (dateKey) => setState(() {
          _dateKey = dateKey;
          final end = _endDateKey;
          if (dateKey == null || (end != null && end.compareTo(dateKey) <= 0)) {
            _endDateKey = null;
          }
          _error = null;
        }),
      ),
      if (_dateKey != null) ...[
        const SizedBox(height: 10),
        TripPickerRow(
          rowKey: tripItemTimeFieldKey,
          label: '체크인 시각',
          value: _timeLabel,
          placeholder: '시각 고르기',
          icon: Icons.schedule_rounded,
          onTap: () => _pickTime(
            title: '체크인 시각',
            current: _timeLabel,
            onPicked: (value) => _timeLabel = value,
          ),
        ),
        const SizedBox(height: 12),
        const TripFieldLabel(text: '체크아웃'),
        const SizedBox(height: 8),
        TripDayPicker(
          trip: widget.trip,
          selectedDateKey: _endDateKey,
          keyBuilder: tripStayCheckOutDateButtonKey,
          enabledFrom: _dateKey,
          onSelected: (dateKey) => setState(() {
            _endDateKey = dateKey;
            _error = null;
          }),
        ),
        if (_endDateKey != null) ...[
          const SizedBox(height: 10),
          TripPickerRow(
            rowKey: tripItemEndTimeFieldKey,
            label: '체크아웃 시각',
            value: _endTimeLabel,
            placeholder: '시각 고르기',
            icon: Icons.schedule_rounded,
            onTap: () => _pickTime(
              title: '체크아웃 시각',
              current: _endTimeLabel,
              onPicked: (value) => _endTimeLabel = value,
            ),
          ),
        ],
        if (_nightPreview > 0) ...[
          const SizedBox(height: 10),
          Text(
            '$_nightPreview박 머물러요',
            style: sans(
              size: 12.5,
              weight: FontWeight.w800,
              color: AlagagiColors.sageDeep,
            ),
          ),
        ],
      ],
    ];
  }

  List<Widget> _scheduleFields() {
    final kind = widget.kind;

    return [
      const SizedBox(height: 12),
      const TripFieldLabel(text: '언제'),
      const SizedBox(height: 8),
      TripDayPicker(
        trip: widget.trip,
        selectedDateKey: _dateKey,
        keyBuilder: tripItemDateButtonKey,
        allowsUndecided: true,
        onSelected: (dateKey) => setState(() {
          _dateKey = dateKey;
          _error = null;
        }),
      ),
      if (_dateKey != null) ...[
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TripPickerRow(
                rowKey: tripItemTimeFieldKey,
                label: kind.usesRoute ? '출발' : '몇 시',
                value: _timeLabel,
                placeholder: '시각 고르기',
                icon: Icons.schedule_rounded,
                onTap: () => _pickTime(
                  title: kind.usesRoute ? '출발 시각' : '시각',
                  current: _timeLabel,
                  onPicked: (value) => _timeLabel = value,
                ),
              ),
            ),
            if (kind.usesRoute) ...[
              const SizedBox(width: 10),
              Expanded(
                child: TripPickerRow(
                  rowKey: tripItemEndTimeFieldKey,
                  label: '도착',
                  value: _endTimeLabel,
                  placeholder: '시각 고르기',
                  icon: Icons.flag_outlined,
                  onTap: () => _pickTime(
                    title: '도착 시각',
                    current: _endTimeLabel,
                    onPicked: (value) => _endTimeLabel = value,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    ];
  }
}

class _FormError extends StatelessWidget {
  const _FormError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x14B35A49),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: Color(0xFFB35A49),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: sans(
                size: 12.3,
                height: 1.5,
                color: const Color(0xFFB35A49),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
