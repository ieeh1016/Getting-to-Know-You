import 'package:flutter/material.dart';

import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/picker_sheets.dart';
import '../../shared/text_editing_sync.dart';
import '../../shared/ui_components.dart';
import '../../shared/ui_style.dart';
import '../place/manual_place_sheet.dart';
import '../place/place_common.dart';
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
  bool scrollBody = true,
  bool keepsInput = false,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    // 적던 내용이 쌓이는 폼은 당겨 닫히지 않게 한다. drag dismiss는
    // Navigator.pop을 직접 불러 막을 길이 없고, 손이 스쳐도 닫힌다.
    // 닫기는 44px 닫기 button으로 한다.
    enableDrag: !keepsInput,
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
                // 폼이 길면 저장 button이 화면 밖으로 밀린다. 그런 sheet는
                // 스스로 스크롤 영역과 고정 footer를 나눠 배치한다.
                Flexible(
                  child: scrollBody
                      ? SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(18, 4, 18, 16),
                          child: builder(sheetContext),
                        )
                      : builder(sheetContext),
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
/// 저장한 여행의 id를 돌려준다. 새로 만든 여행이면 곧바로 그 여행을 열 수 있다.
Future<String?> showTripFormSheet(
  BuildContext context, {
  required AlagagiController controller,
  Trip? trip,
}) {
  return _showFormSheet<String>(
    context,
    keepsInput: true,
    sheetKey: tripFormSheetKey,
    title: trip == null ? '새 여행' : '여행 고치기',
    subtitle: trip == null ? '이름과 기간만 있으면 시작할 수 있어요' : null,
    scrollBody: false,
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
  late final ImeSafeTextEditingController _noteController;
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
    _noteController = ImeSafeTextEditingController(
      text: widget.trip?.note ?? '',
    );
    _startDateKey = widget.trip?.startDateKey;
    _endDateKey = widget.trip?.endDateKey;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _destinationController.dispose();
    _noteController.dispose();
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
      note: _noteController.text,
    );
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    Navigator.of(widget.sheetContext).pop(widget.controller.lastSavedTripId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 6),
            child: Column(
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
        const SizedBox(height: 10),
        TripTextField(
          fieldKey: tripNoteFieldKey,
          controller: _noteController,
          label: '메모 (선택)',
          hint: '같이 기억해둘 것',
          maxLength: 500,
          maxLines: 3,
        ),
        if (_error != null) ...[
          const SizedBox(height: 10),
          _FormError(message: _error!),
        ],
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
        child: TripPrimaryButton(
          buttonKey: tripSubmitButtonKey,
          label: widget.trip == null ? '여행 만들기' : '고친 내용 저장하기',
          onPressed: _submit,
        ),
      ),
      ],
    );
  }
}

/// 여행 상세에서 고를 수 있는 관리 동작.
enum TripAction { edit, delete }

/// 여행 정보 고치기와 지우기를 sheet 한 장으로 모은다.
Future<TripAction?> showTripActionsSheet(
  BuildContext context, {
  required bool canDelete,
}) {
  return _showFormSheet<TripAction>(
    context,
    sheetKey: tripMoreSheetKey,
    title: '이 여행',
    builder: (sheetContext) => Column(
      children: [
        _ActionRow(
          rowKey: tripEditActionKey,
          icon: Icons.edit_outlined,
          label: '여행 정보 고치기',
          hint: '이름, 목적지, 기간을 바꿔요',
          onTap: () => Navigator.of(sheetContext).pop(TripAction.edit),
        ),
        if (canDelete) ...[
          const SizedBox(height: 8),
          _ActionRow(
            rowKey: tripDeleteActionKey,
            icon: Icons.delete_outline_rounded,
            label: '여행 지우기',
            hint: '담아둔 일정과 사진도 함께 사라져요',
            danger: true,
            onTap: () => Navigator.of(sheetContext).pop(TripAction.delete),
          ),
        ],
      ],
    ),
  );
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.rowKey,
    required this.icon,
    required this.label,
    required this.hint,
    required this.onTap,
    this.danger = false,
  });

  final Key rowKey;
  final IconData icon;
  final String label;
  final String hint;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final tone = danger ? const Color(0xFFB35A49) : AlagagiColors.sageDeep;

    return InkWell(
      key: rowKey,
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        constraints: const BoxConstraints(minHeight: 60),
        decoration: BoxDecoration(
          color: AlagagiColors.paper,
          border: Border.all(color: AlagagiColors.line),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.fromLTRB(13, 11, 13, 11),
        child: Row(
          children: [
            AlagagiSymbolMark(
              icon: icon,
              size: 34,
              iconSize: 17,
              tone: AlagagiColors.skyPanel,
              iconColor: tone,
              radius: 12,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: sans(
                      size: 13.5,
                      weight: FontWeight.w800,
                      color: danger ? tone : AlagagiColors.ink,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    hint,
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

/// 여행 일정에 붙일 장소를 장소 보드에서 고른다.
///
/// 식당이나 카페는 이미 장소 보드에 모아두고 있다. 여행에서 이름을 다시
/// 적게 하면 같은 곳이 두 군데 따로 쌓인다.
Future<String?> showTripPlacePickerSheet(
  BuildContext context, {
  required AlagagiController controller,
  required ValueChanged<String> onOpenExternalLink,
  String? selectedPlaceId,
  String draftTitle = '',
}) {
  return _showFormSheet<String>(
    context,
    sheetKey: tripPlacePickerSheetKey,
    title: '어디에서',
    subtitle: '보드에 없으면 직접 담아서 고를 수 있어요',
    builder: (sheetContext) => _PlacePicker(
      controller: controller,
      selectedPlaceId: selectedPlaceId,
      draftTitle: draftTitle,
      onPick: (placeId) => Navigator.of(sheetContext).pop(placeId),
      onOpenExternalLink: onOpenExternalLink,
    ),
  );
}

class _PlacePicker extends StatefulWidget {
  const _PlacePicker({
    required this.controller,
    required this.selectedPlaceId,
    required this.draftTitle,
    required this.onPick,
    required this.onOpenExternalLink,
  });

  final AlagagiController controller;
  final String? selectedPlaceId;
  final ValueChanged<String> onOpenExternalLink;

  /// 폼에 적던 제목. 직접 담기로 넘어갈 때 그대로 옮긴다.
  final String draftTitle;
  final ValueChanged<String> onPick;

  @override
  State<_PlacePicker> createState() => _PlacePickerState();
}

class _PlacePickerState extends State<_PlacePicker> {
  PlaceCategory? _category;

  /// 카카오 검색은 국내만 된다. 해외 여행이면 거의 모든 장소가 이 경로다.
  Future<void> _addManualPlace() async {
    final created = await showManualPlaceSheet(
      context,
      controller: widget.controller,
      onOpenExternalLink: widget.onOpenExternalLink,
      initialName: widget.draftTitle.trim(),
    );
    widget.controller.clearLastSavedPlaceId();
    if (created == null || !mounted) {
      return;
    }
    widget.onPick(created);
  }

  Widget _manualRow() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 42,
        child: OutlinedButton.icon(
          key: tripPlaceManualButtonKey,
          onPressed: _addManualPlace,
          icon: const Icon(Icons.edit_location_alt_outlined, size: 15),
          label: const Text('해외거나 검색에 없으면 직접 담기'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AlagagiColors.sageDeep,
            side: const BorderSide(color: AlagagiColors.line),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: sans(size: 12.5, weight: FontWeight.w700),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final places = widget.controller.sharedPlaces
        .where((place) => _category == null || place.category == _category)
        .toList();

    if (widget.controller.sharedPlaces.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AlagagiEmptyStateCard(
            text: '장소 보드에 담아둔 곳이 아직 없어요. 여기서 바로 담아도 돼요.',
          ),
          const SizedBox(height: 12),
          _manualRow(),
          const SizedBox(height: 4),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              AlagagiFilterPill(
                key: tripPlacePickerCategoryKey('all'),
                label: '전체',
                selected: _category == null,
                onTap: () => setState(() => _category = null),
              ),
              const SizedBox(width: 7),
              for (final category in PlaceCategory.values) ...[
                AlagagiFilterPill(
                  key: tripPlacePickerCategoryKey(category.name),
                  label: placeCategoryLabel(category),
                  selected: _category == category,
                  onTap: () => setState(() => _category = category),
                ),
                if (category != PlaceCategory.values.last)
                  const SizedBox(width: 7),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        _manualRow(),
        if (places.isEmpty)
          const AlagagiEmptyStateCard(text: '이 분류에는 담아둔 곳이 없어요.')
        else
          for (final place in places) ...[
            _PlaceOption(
              place: place,
              selected: place.id == widget.selectedPlaceId,
              onTap: () => widget.onPick(place.id),
            ),
            const SizedBox(height: 8),
          ],
        if (widget.selectedPlaceId != null) ...[
          const SizedBox(height: 4),
          SizedBox(
            height: 46,
            child: OutlinedButton(
              key: tripPlacePickerClearButtonKey,
              onPressed: () => widget.onPick(''),
              style: OutlinedButton.styleFrom(
                foregroundColor: AlagagiColors.muted,
                side: const BorderSide(color: AlagagiColors.line),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: sans(size: 12.5, weight: FontWeight.w700),
              ),
              child: const Text('장소 지우기'),
            ),
          ),
        ],
      ],
    );
  }
}

class _PlaceOption extends StatelessWidget {
  const _PlaceOption({
    required this.place,
    required this.selected,
    required this.onTap,
  });

  final SharedPlace place;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: tripPlacePickerOptionKey(place.id),
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        constraints: const BoxConstraints(minHeight: 58),
        decoration: BoxDecoration(
          color: selected ? AlagagiColors.skyPanel : AlagagiColors.paper,
          border: Border.all(
            color: selected ? AlagagiColors.sageDeep : AlagagiColors.line,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Row(
          children: [
            AlagagiSymbolMark(
              icon: placeCategoryIcon(place.category),
              size: 32,
              iconSize: 16,
              tone: AlagagiColors.skyPanel,
              iconColor: AlagagiColors.sageDeep,
              radius: 11,
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: sans(size: 13, weight: FontWeight.w800),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    place.address.isEmpty
                        ? placeCategoryLabel(place.category)
                        : '${placeCategoryLabel(place.category)} · ${place.address}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: sans(size: 11.5, color: AlagagiColors.muted),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle_rounded,
                size: 19,
                color: AlagagiColors.sageDeep,
              ),
          ],
        ),
      ),
    );
  }
}

/// 사진을 여행의 어느 날 것으로 묶을지 고른다.
///
/// 빈 문자열을 돌려주면 날짜를 지운다는 뜻이다.
Future<String?> showTripPhotoDaySheet(
  BuildContext context, {
  required Trip trip,
  String? selectedDateKey,
}) {
  return _showFormSheet<String>(
    context,
    sheetKey: tripPhotoDaySheetKey,
    title: '언제 찍은 사진인가요',
    subtitle: trip.title,
    builder: (sheetContext) {
      final dateKeys = trip.dateKeys;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < dateKeys.length; index += 1) ...[
            _PhotoDayOption(
              dateKey: dateKeys[index],
              dayNumber: index + 1,
              selected: selectedDateKey == dateKeys[index],
              onTap: () => Navigator.of(sheetContext).pop(dateKeys[index]),
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 4),
          SizedBox(
            height: 46,
            child: OutlinedButton(
              key: tripPhotoDayClearButtonKey,
              onPressed: () => Navigator.of(sheetContext).pop(''),
              style: OutlinedButton.styleFrom(
                foregroundColor: AlagagiColors.muted,
                side: const BorderSide(color: AlagagiColors.line),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: sans(size: 12.5, weight: FontWeight.w700),
              ),
              child: const Text('날짜 없이 두기'),
            ),
          ),
        ],
      );
    },
  );
}

class _PhotoDayOption extends StatelessWidget {
  const _PhotoDayOption({
    required this.dateKey,
    required this.dayNumber,
    required this.selected,
    required this.onTap,
  });

  final String dateKey;
  final int dayNumber;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(dateKey);

    return InkWell(
      key: tripPhotoDaySheetOptionKey(dateKey),
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        constraints: const BoxConstraints(minHeight: 52),
        decoration: BoxDecoration(
          color: selected ? AlagagiColors.skyPanel : AlagagiColors.paper,
          border: Border.all(
            color: selected ? AlagagiColors.sageDeep : AlagagiColors.line,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.fromLTRB(14, 11, 14, 11),
        child: Row(
          children: [
            Text(
              '$dayNumber일차',
              style: sans(
                size: 12,
                weight: FontWeight.w800,
                color: AlagagiColors.sageDeep,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                date == null
                    ? dateKey
                    : '${date.month}월 ${date.day}일 (${tripWeekdayLabel(date)})',
                style: sans(size: 13, weight: FontWeight.w700),
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle_rounded,
                size: 19,
                color: AlagagiColors.sageDeep,
              ),
          ],
        ),
      ),
    );
  }
}

/// 준비물을 지난 여행에서 통째로 가져온다. 챙길 것은 여행마다 크게 다르지
/// 않아, 매번 처음부터 적게 하면 꼭 하나씩 빠뜨린다.
Future<String?> showTripPackingSourceSheet(
  BuildContext context, {
  required AlagagiController controller,
  required String tripId,
}) {
  final sources = controller.tripsWithPackingExcept(tripId);

  return _showFormSheet<String>(
    context,
    sheetKey: tripPackingSourceSheetKey,
    title: '지난 여행에서 가져오기',
    subtitle: '챙긴 표시는 빼고 목록만 가져와요',
    builder: (sheetContext) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final trip in sources) ...[
          InkWell(
            key: tripPackingSourceOptionKey(trip.id),
            onTap: () => Navigator.of(sheetContext).pop(trip.id),
            borderRadius: BorderRadius.circular(15),
            child: Container(
              constraints: const BoxConstraints(minHeight: 56),
              decoration: BoxDecoration(
                color: AlagagiColors.paper,
                border: Border.all(color: AlagagiColors.line),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.fromLTRB(14, 11, 14, 11),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: sans(size: 13, weight: FontWeight.w800),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '준비물 '
                          '${controller.tripItemsFor(trip.id, kind: TripItemKind.packing).length}개',
                          style: sans(size: 11.5, color: AlagagiColors.muted),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 19,
                    color: AlagagiColors.muted,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ],
    ),
  );
}

/// 여행 항목을 만들거나 고친다. 종류에 따라 묻는 것이 달라진다.
///
/// 저장한 종류를 돌려준다. 폼 안에서 종류를 바꿔 저장할 수 있어, 부른 쪽이
/// 처음 고른 종류를 그대로 믿으면 엉뚱한 tab을 연다.
Future<TripItemKind?> showTripItemFormSheet(
  BuildContext context, {
  required AlagagiController controller,
  required Trip trip,
  required TripItemKind kind,
  required ValueChanged<String> onOpenExternalLink,
  TripItem? item,
  String? initialDateKey,
}) {
  return _showFormSheet<TripItemKind>(
    context,
    keepsInput: true,
    sheetKey: tripItemFormSheetKey,
    title: item == null ? '${kind.label} 추가' : '${kind.label} 고치기',
    subtitle: trip.title,
    scrollBody: false,
    builder: (sheetContext) => _TripItemForm(
      controller: controller,
      trip: trip,
      kind: kind,
      item: item,
      initialDateKey: initialDateKey,
      onOpenExternalLink: onOpenExternalLink,
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
    required this.onOpenExternalLink,
    this.initialDateKey,
  });

  final AlagagiController controller;
  final ValueChanged<String> onOpenExternalLink;
  final Trip trip;
  final TripItemKind kind;
  final TripItem? item;
  final BuildContext sheetContext;

  /// 타임라인의 그 날에서 담기를 눌러 들어온 경우의 날짜.
  final String? initialDateKey;

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
  String? _placeId;
  late final ImeSafeTextEditingController _linkController;
  String? _assigneeProfileId;
  late TripTransportMode _mode;
  late TripItemKind _kind;
  String? _error;
  String? _keepAddingNotice;

  /// 이어 적을 때 칸은 비우되, 시각 sheet는 방금 고른 자리 근처에서 연다.
  String? _lastPickedTimeLabel;

  /// 지난번에 닫힌 폼에 남아 있던 내용. 자동으로 채우지 않는다.
  /// 다른 항목을 적으려고 연 경우에는 방해가 되기 때문이다.
  TripItemDraft? _restorableDraft;

  bool _saved = false;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _titleController = ImeSafeTextEditingController(text: item?.title ?? '');
    _noteController = ImeSafeTextEditingController(text: item?.note ?? '');
    _fromController = ImeSafeTextEditingController(text: item?.fromLabel ?? '');
    _toController = ImeSafeTextEditingController(text: item?.toLabel ?? '');
    // 고치는 중이면 원래 날짜를 지킨다. 들어온 날짜로 덮으면 목록에서
    // 연 항목이 엉뚱한 날로 옮겨진다.
    _dateKey = item == null ? widget.initialDateKey : item.dateKey;
    _endDateKey = item?.endDateKey;
    _timeLabel = item?.timeLabel;
    _endTimeLabel = item?.endTimeLabel;
    _placeId = item?.placeId;
    _linkController = ImeSafeTextEditingController(text: item?.link ?? '');
    _assigneeProfileId = item?.assigneeProfileId;
    _mode = item?.transportMode ?? TripTransportMode.flight;
    _kind = widget.kind;
    _lastPickedTimeLabel = item?.timeLabel;
    if (item == null) {
      _restorableDraft = widget.controller.tripItemDraftFor(
        widget.trip.id,
        widget.kind,
      );
    }
  }

  TripItemDraft _currentDraft() => TripItemDraft(
    kind: _kind,
    title: _titleController.text,
    note: _noteController.text,
    link: _linkController.text,
    fromLabel: _fromController.text,
    toLabel: _toController.text,
    dateKey: _dateKey,
    timeLabel: _timeLabel,
    endDateKey: _endDateKey,
    endTimeLabel: _endTimeLabel,
    placeId: _placeId,
    assigneeProfileId: _assigneeProfileId,
    transportMode: _mode,
  );

  void _restoreDraft() {
    final draft = _restorableDraft;
    if (draft == null) {
      return;
    }
    setState(() {
      _kind = draft.kind;
      _titleController.text = draft.title;
      _noteController.text = draft.note;
      _linkController.text = draft.link;
      _fromController.text = draft.fromLabel;
      _toController.text = draft.toLabel;
      _dateKey = draft.dateKey;
      _timeLabel = draft.timeLabel;
      _endDateKey = draft.endDateKey;
      _endTimeLabel = draft.endTimeLabel;
      _placeId = draft.placeId;
      _assigneeProfileId = draft.assigneeProfileId;
      _mode = draft.transportMode;
      _restorableDraft = null;
      _error = null;
    });
  }

  @override
  void dispose() {
    // 닫히면서 적던 내용을 기기 안에만 남긴다. 저장했으면 남길 이유가 없다.
    if (widget.item == null && !_saved) {
      widget.controller.rememberTripItemDraft(widget.trip.id, _currentDraft());
    }
    _titleController.dispose();
    _noteController.dispose();
    _fromController.dispose();
    _toController.dispose();
    _linkController.dispose();
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
      // 이어 적는 중이면 칸은 비어 있어도 손이 굴러갈 거리는 줄인다.
      initialLabel: current ?? _lastPickedTimeLabel,
    );
    if (picked == null) {
      return;
    }
    setState(() {
      onPicked(picked);
      _lastPickedTimeLabel = picked;
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

  String? _save() {
    return widget.controller.saveTripItem(
      tripId: widget.trip.id,
      itemId: widget.item?.id,
      kind: _kind,
      title: _titleController.text,
      note: _noteController.text,
      dateKey: _dateKey,
      timeLabel: _timeLabel,
      endDateKey: _kind.usesDateRange ? _endDateKey : null,
      endTimeLabel: _endTimeLabel,
      transportMode: _kind.usesRoute ? _mode : null,
      fromLabel: _fromController.text,
      toLabel: _toController.text,
      placeId: _placeId,
      link: _linkController.text,
      // 넘기지 않으면 controller가 기존 담당을 지운다.
      assigneeProfileId: _kind.usesCheck ? _assigneeProfileId : null,
    );
  }

  void _submit() {
    final error = _save();
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    _saved = true;
    widget.controller.clearTripItemDraft(widget.trip.id, widget.kind);
    Navigator.of(widget.sheetContext).pop(_kind);
  }

  /// 준비물이나 계획은 보통 한 번에 여러 개를 적는다. 매번 sheet를 닫고
  /// 다시 여는 대신, 날짜와 종류는 남긴 채 내용만 비운다.
  void _submitAndKeepAdding() {
    final error = _save();
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    _saved = true;
    widget.controller.clearTripItemDraft(widget.trip.id, widget.kind);
    final savedTitle = _titleController.text.trim();
    // 이동을 이어 담는 건 거의 언제나 돌아오는 편이다. 두 칸을 비우면
    // 방금 적은 값을 자리만 바꿔 다시 타이핑하게 된다.
    final previousFrom = _fromController.text.trim();
    final previousTo = _toController.text.trim();
    final flipped =
        _kind.usesRoute && (previousFrom.isNotEmpty || previousTo.isNotEmpty);
    setState(() {
      _titleController.text = '';
      _noteController.text = '';
      _linkController.text = '';
      _fromController.text = flipped ? previousTo : '';
      _toController.text = flipped ? previousFrom : '';
      _placeId = null;
      _timeLabel = null;
      _endTimeLabel = null;
      _error = null;
      // 다구간 이동이면 뒤집힌 값이 틀릴 수 있다. 뒤집었다고 말해줘야
      // 잘못 채워진 칸을 눈치챈다.
      _keepAddingNotice = flipped
          ? '\'$savedTitle\' 담았어요. 돌아오는 편으로 뒤집어 뒀어요.'
          : '\'$savedTitle\' 담았어요. 이어서 적어요.';
    });
  }

  void _swapRoute() {
    final from = _fromController.text;
    setState(() {
      _fromController.text = _toController.text;
      _toController.text = from;
      _error = null;
    });
  }

  Future<void> _changeKind() async {
    final picked = await showTripKindPickerSheet(context);
    if (picked == null || !mounted || picked == _kind) {
      return;
    }
    setState(() {
      _kind = picked;
      // 종류가 바뀌면 앞 종류에서만 쓰던 값은 흐름에 맞지 않는다.
      if (!picked.usesDateRange) {
        _endDateKey = null;
      }
      if (!picked.usesRoute) {
        _endTimeLabel = null;
      }
      if (!picked.usesCheck) {
        _assigneeProfileId = null;
      }
      if (!picked.usesPlace) {
        _placeId = null;
      }
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final kind = _kind;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
        // 자동으로 채우지 않는다. 다른 항목을 적으려고 연 경우에는 방해가 된다.
        if (_restorableDraft != null) ...[
          _DraftRestoreRow(
            title: _restorableDraft!.title.trim(),
            onRestore: _restoreDraft,
            onDismiss: () {
              widget.controller.clearTripItemDraft(widget.trip.id, _kind);
              setState(() => _restorableDraft = null);
            },
          ),
          const SizedBox(height: 10),
        ],
        // 고르고 나서야 종류를 잘못 골랐다는 걸 아는 일이 잦다.
        TripPickerRow(
          rowKey: tripItemKindFieldKey,
          label: '종류',
          value: kind.label,
          placeholder: '종류 고르기',
          icon: Icons.unfold_more_rounded,
          onTap: _changeKind,
        ),
        const SizedBox(height: 10),
        if (kind.usesRoute) ..._routeFields(),
        TripTextField(
          fieldKey: tripItemTitleFieldKey,
          controller: _titleController,
          label: kind.usesRoute ? '편명이나 노선' : kind.label,
          hint: kind.usesRoute ? _mode.titleHint : kind.titleHint,
          maxLength: 80,
        ),
        // 언제·몇 시가 제목 바로 다음에 온다. 키보드가 올라오면 sheet 본문이
        // 300px 안팎으로 줄어, 가장 자주 채우는 칸이 아래에 있으면 항목마다
        // 키보드를 내리고 스크롤하게 된다.
        if (kind.usesDateRange) ..._stayFields(),
        if (kind.usesRoute || kind == TripItemKind.plan) ..._scheduleFields(),
        const SizedBox(height: 10),
        TripTextField(
          fieldKey: tripItemNoteFieldKey,
          controller: _noteController,
          label: '메모',
          hint: kind.noteHint,
          maxLength: 500,
          maxLines: 3,
        ),
        if (kind.usesPlace) ..._placeFields(),
        const SizedBox(height: 10),
        TripTextField(
          fieldKey: tripItemLinkFieldKey,
          controller: _linkController,
          label: '링크 (선택)',
          hint: '예약 페이지나 지도 링크',
          maxLength: 500,
        ),
        if (kind.usesCheck) ..._assigneeFields(),
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 폼이 길어도 담기 결과는 button과 같은 고정 자리에 보인다.
            // 스크롤 끝에 두면 화면 밖에 그려져 button이 고장난 것처럼 보인다.
            if (_keepAddingNotice != null) ...[
              _FormNotice(message: _keepAddingNotice!),
              const SizedBox(height: 8),
            ],
            if (_error != null) ...[
              _FormError(key: tripItemFormErrorKey, message: _error!),
              const SizedBox(height: 8),
            ],
            TripPrimaryButton(
              buttonKey: tripItemSubmitButtonKey,
              label: widget.item == null ? '${kind.label} 담기' : '고친 내용 저장하기',
              onPressed: _submit,
            ),
            if (widget.item == null) ...[
              const SizedBox(height: 8),
              SizedBox(
                height: 44,
                child: OutlinedButton(
                  key: tripItemKeepAddingButtonKey,
                  onPressed: _submitAndKeepAdding,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AlagagiColors.sageDeep,
                    side: const BorderSide(color: AlagagiColors.line),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: sans(size: 12.5, weight: FontWeight.w700),
                  ),
                  child: const Text('담고 계속 적기'),
                ),
              ),
            ],
          ],
        ),
      ),
      ],
    );
  }

  /// 준비물을 누가 챙길지. 목록에서도 바꿀 수 있지만 담을 때 함께 정할 수 있어야
  /// 하고, 무엇보다 폼이 값을 들고 있지 않으면 저장할 때 기존 담당이 지워진다.
  List<Widget> _assigneeFields() {
    final me = widget.controller.state.me;
    final partner = widget.controller.state.partner;

    return [
      const SizedBox(height: 12),
      const TripFieldLabel(text: '누가 챙길까요 (선택)'),
      const SizedBox(height: 8),
      Wrap(
        spacing: 7,
        runSpacing: 7,
        children: [
          for (final profile in [me, partner])
            AlagagiFilterPill(
              key: tripItemAssigneeButtonKey(
                widget.item?.id ?? 'draft',
                profile.id,
              ),
              label: profile.nickname,
              selected: _assigneeProfileId == profile.id,
              onTap: () => setState(() {
                _assigneeProfileId = _assigneeProfileId == profile.id
                    ? null
                    : profile.id;
              }),
            ),
          AlagagiFilterPill(
            key: tripItemAssigneeButtonKey(
              widget.item?.id ?? 'draft',
              kTripSharedAssigneeId,
            ),
            label: '함께',
            selected: _assigneeProfileId == kTripSharedAssigneeId,
            onTap: () => setState(() {
              _assigneeProfileId = _assigneeProfileId == kTripSharedAssigneeId
                  ? null
                  : kTripSharedAssigneeId;
            }),
          ),
        ],
      ),
    ];
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
          Material(
            color: Colors.transparent,
            child: InkWell(
              key: tripItemRouteSwapButtonKey,
              onTap: _swapRoute,
              borderRadius: BorderRadius.circular(22),
              child: const SizedBox(
                width: 44,
                height: 44,
                child: Icon(
                  Icons.swap_horiz_rounded,
                  size: 18,
                  color: AlagagiColors.sageDeep,
                ),
              ),
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

  /// 식당이나 카페는 장소 보드에서 골라 붙인다.
  List<Widget> _placeFields() {
    final place = _placeId == null
        ? null
        : widget.controller.sharedPlaces
              .where((candidate) => candidate.id == _placeId)
              .firstOrNull;

    return [
      const SizedBox(height: 10),
      TripPickerRow(
        rowKey: tripItemPlaceFieldKey,
        label: '어디에서',
        value: place == null
            ? null
            : '${place.name} · ${placeCategoryLabel(place.category)}',
        placeholder: '장소 보드에서 고르기',
        icon: Icons.place_outlined,
        onTap: () async {
          final picked = await showTripPlacePickerSheet(
            context,
            controller: widget.controller,
            onOpenExternalLink: widget.onOpenExternalLink,
            selectedPlaceId: _placeId,
            draftTitle: _titleController.text,
          );
          if (picked == null) {
            return;
          }
          setState(() {
            _placeId = picked.isEmpty ? null : picked;
            _error = null;
          });
        },
      ),
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
        // 숙소는 알아보는 중일 때가 많다. 날짜가 정해지기 전에도 담아둔다.
        allowsUndecided: true,
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
          clearKey: tripItemTimeClearButtonKey,
          onClear: () => setState(() => _timeLabel = null),
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
            clearKey: tripItemEndTimeClearButtonKey,
            onClear: () => setState(() => _endTimeLabel = null),
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
    final kind = _kind;

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
                clearKey: tripItemTimeClearButtonKey,
                onClear: () => setState(() => _timeLabel = null),
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
                  clearKey: tripItemEndTimeClearButtonKey,
                  onClear: () => setState(() => _endTimeLabel = null),
                ),
              ),
            ],
          ],
        ),
      ],
    ];
  }
}

/// 닫힌 폼에 남아 있던 내용을 이어서 쓸지 묻는 줄.
class _DraftRestoreRow extends StatelessWidget {
  const _DraftRestoreRow({
    required this.title,
    required this.onRestore,
    required this.onDismiss,
  });

  final String title;
  final VoidCallback onRestore;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: tripItemDraftRestoreKey,
      decoration: BoxDecoration(
        color: AlagagiColors.skyPanel,
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(13),
      ),
      padding: const EdgeInsets.fromLTRB(12, 9, 8, 9),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title.isEmpty ? '적던 내용이 있어요' : '적던 내용이 있어요 · $title',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: sans(size: 12, height: 1.5, color: AlagagiColors.muted),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            height: 34,
            child: TextButton(
              key: tripItemDraftRestoreButtonKey,
              onPressed: onRestore,
              style: TextButton.styleFrom(
                foregroundColor: AlagagiColors.sageDeep,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                textStyle: sans(size: 12, weight: FontWeight.w800),
              ),
              child: const Text('이어서 쓰기'),
            ),
          ),
          SizedBox(
            width: 34,
            height: 34,
            child: IconButton(
              key: tripItemDraftDismissButtonKey,
              onPressed: onDismiss,
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.close_rounded,
                size: 15,
                color: AlagagiColors.muted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 계속 적기로 하나 담았을 때 조용히 알려주는 줄.
class _FormNotice extends StatelessWidget {
  const _FormNotice({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: tripItemKeepAddingNoticeKey,
      decoration: BoxDecoration(
        color: AlagagiColors.skyPanel,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            size: 16,
            color: AlagagiColors.sageDeep,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: sans(
                size: 12,
                height: 1.5,
                weight: FontWeight.w700,
                color: AlagagiColors.sageDeep,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormError extends StatelessWidget {
  const _FormError({super.key, required this.message});

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
