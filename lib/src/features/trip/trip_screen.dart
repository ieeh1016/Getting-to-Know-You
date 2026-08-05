import 'package:flutter/material.dart';

import '../../app/app_shell.dart';
import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/text_editing_sync.dart';
import '../../shared/ui_components.dart';
import '../../shared/ui_style.dart';
import 'trip_timeline.dart';

/// 여행 계획 화면. 여행 목록과 여행 하나의 상세를 같은 화면에서 전환한다.
class TripScreen extends StatefulWidget {
  const TripScreen({super.key, required this.controller});

  final AlagagiController controller;

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  String? _openTripId;
  bool _draftVisible = false;
  String? _editingTripId;
  /// null이면 일정 타임라인 탭이다.
  TripItemKind? _selectedKind;
  String? _editingItemId;
  String? _itemDateKey;
  String? _tripError;
  String? _itemError;

  late final ImeSafeTextEditingController _titleController;
  late final ImeSafeTextEditingController _destinationController;
  late final ImeSafeTextEditingController _startController;
  late final ImeSafeTextEditingController _endController;
  late final ImeSafeTextEditingController _itemTitleController;
  late final ImeSafeTextEditingController _itemNoteController;
  late final ImeSafeTextEditingController _itemTimeController;

  @override
  void initState() {
    super.initState();
    _titleController = ImeSafeTextEditingController();
    _destinationController = ImeSafeTextEditingController();
    _startController = ImeSafeTextEditingController();
    _endController = ImeSafeTextEditingController();
    _itemTitleController = ImeSafeTextEditingController();
    _itemNoteController = ImeSafeTextEditingController();
    _itemTimeController = ImeSafeTextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _destinationController.dispose();
    _startController.dispose();
    _endController.dispose();
    _itemTitleController.dispose();
    _itemNoteController.dispose();
    _itemTimeController.dispose();
    super.dispose();
  }

  void _openDraft({Trip? trip}) {
    setState(() {
      _draftVisible = true;
      _editingTripId = trip?.id;
      _tripError = null;
      _titleController.text = trip?.title ?? '';
      _destinationController.text = trip?.destination ?? '';
      _startController.text = trip?.startDateKey ?? '';
      _endController.text = trip?.endDateKey ?? '';
    });
  }

  void _closeDraft() {
    setState(() {
      _draftVisible = false;
      _editingTripId = null;
      _tripError = null;
    });
  }

  void _submitTrip() {
    final error = widget.controller.saveTrip(
      tripId: _editingTripId,
      title: _titleController.text,
      destination: _destinationController.text,
      startDateKey: _startController.text.trim(),
      endDateKey: _endController.text.trim(),
    );
    setState(() {
      _tripError = error;
      if (error == null) {
        _draftVisible = false;
        _editingTripId = null;
      }
    });
  }

  void _submitItem(Trip trip, TripItemKind kind) {
    final error = widget.controller.saveTripItem(
      tripId: trip.id,
      itemId: _editingItemId,
      kind: kind,
      title: _itemTitleController.text,
      note: _itemNoteController.text,
      dateKey: _itemDateKey,
      timeLabel: _itemTimeController.text,
    );
    setState(() {
      _itemError = error;
      if (error == null) {
        _clearItemDraft();
      }
    });
  }

  void _clearItemDraft() {
    _editingItemId = null;
    _itemTitleController.text = '';
    _itemNoteController.text = '';
    _itemTimeController.text = '';
    _itemDateKey = null;
  }

  /// 타임라인에서 항목을 누르면 그 종류 탭으로 옮겨가 바로 고칠 수 있게 한다.
  void _editItem(TripItem item) {
    setState(() {
      _selectedKind = item.kind;
      _editingItemId = item.id;
      _itemTitleController.text = item.title;
      _itemNoteController.text = item.note;
      _itemTimeController.text = item.timeLabel ?? '';
      _itemDateKey = item.dateKey;
      _itemError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final openTrip = _openTripId == null
        ? null
        : widget.controller.tripById(_openTripId!);

    return AlagagiScreenScroll(
      key: tripsScreenKey,
      bottomNavigation: AlagagiBottomNav(controller: widget.controller),
      children: [
        AlagagiTopBar(
          title: openTrip == null ? '여행 계획' : openTrip.title,
          trailing: '',
          onBack: () {
            if (openTrip != null) {
              setState(() => _openTripId = null);
              return;
            }
            widget.controller.goTo(AlagagiRoute.home);
          },
        ),
        const SizedBox(height: 4),
        if (openTrip == null)
          ..._buildTripList()
        else
          ..._buildTripDetail(openTrip),
      ],
    );
  }

  List<Widget> _buildTripList() {
    final planning = widget.controller.tripsWithStatus(TripStatus.planning);
    final done = widget.controller.tripsWithStatus(TripStatus.done);

    return [
      Text(
        '같이 갈 여행을 하나씩 정리해요',
        style: sans(size: 12.5, color: AlagagiColors.muted),
      ),
      const SizedBox(height: 12),
      Align(
        alignment: Alignment.centerLeft,
        child: OutlinedButton.icon(
          key: tripDraftToggleButtonKey,
          onPressed: () => _draftVisible ? _closeDraft() : _openDraft(),
          icon: Icon(
            _draftVisible ? Icons.close_rounded : Icons.add_rounded,
            size: 17,
          ),
          label: Text(_draftVisible ? '접기' : '여행 만들기'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AlagagiColors.sageDeep,
            side: const BorderSide(color: AlagagiColors.line),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
            textStyle: sans(size: 12.5, weight: FontWeight.w700),
          ),
        ),
      ),
      if (_draftVisible) ...[const SizedBox(height: 14), _buildTripDraft()],
      const SizedBox(height: 18),
      if (planning.isEmpty && done.isEmpty)
        const AlagagiEmptyStateCard(
          text: '아직 계획한 여행이 없어요. 가고 싶은 곳이 생기면 하나 만들어봐요.',
        ),
      if (planning.isNotEmpty) ...[
        const AlagagiSectionLabel('계획 중'),
        const SizedBox(height: 10),
        for (final trip in planning) ...[
          _TripCard(
            trip: trip,
            controller: widget.controller,
            onOpen: () => setState(() => _openTripId = trip.id),
          ),
          const SizedBox(height: 10),
        ],
      ],
      if (done.isNotEmpty) ...[
        const SizedBox(height: 8),
        const AlagagiSectionLabel('다녀옴'),
        const SizedBox(height: 10),
        for (final trip in done) ...[
          _TripCard(
            trip: trip,
            controller: widget.controller,
            onOpen: () => setState(() => _openTripId = trip.id),
          ),
          const SizedBox(height: 10),
        ],
      ],
    ];
  }

  Widget _buildTripDraft() {
    return AlagagiPaperCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _editingTripId == null ? '새 여행' : '여행 고치기',
            style: serif(context, size: 16, weight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          _TripField(
            fieldKey: tripTitleFieldKey,
            controller: _titleController,
            label: '여행 이름',
            hint: '예: 가을 제주',
            maxLength: 60,
          ),
          const SizedBox(height: 10),
          _TripField(
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
                child: _TripField(
                  fieldKey: tripStartDateFieldKey,
                  controller: _startController,
                  label: '떠나는 날',
                  hint: '2026-09-12',
                  maxLength: 10,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _TripField(
                  fieldKey: tripEndDateFieldKey,
                  controller: _endController,
                  label: '돌아오는 날',
                  hint: '2026-09-14',
                  maxLength: 10,
                ),
              ),
            ],
          ),
          if (_tripError != null) ...[
            const SizedBox(height: 8),
            Text(
              _tripError!,
              style: sans(size: 12, color: const Color(0xFFB35A49)),
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              key: tripSubmitButtonKey,
              onPressed: _submitTrip,
              style: FilledButton.styleFrom(
                backgroundColor: AlagagiColors.ink,
                foregroundColor: AlagagiColors.appBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 13),
                textStyle: sans(size: 12.5, weight: FontWeight.w800),
              ),
              child: const Text('여행 저장하기'),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTripDetail(Trip trip) {
    final kind = _selectedKind;
    final packingTotal = widget.controller
        .tripItemsFor(trip.id, kind: TripItemKind.packing)
        .length;
    final packingChecked = widget.controller.tripPackingCheckedCount(trip.id);

    return [
      Text(
        trip.destination.isEmpty
            ? trip.durationLabel
            : '${trip.destination} · ${trip.durationLabel}',
        style: sans(size: 12.5, color: AlagagiColors.muted),
      ),
      const SizedBox(height: 12),
      _TripSummaryCard(
        trip: trip,
        controller: widget.controller,
        onEdit: () => _openDraft(trip: trip),
        onDelete: () {
          widget.controller.deleteTrip(trip.id);
          setState(() => _openTripId = null);
        },
      ),
      if (_draftVisible) ...[const SizedBox(height: 12), _buildTripDraft()],
      const SizedBox(height: 16),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            AlagagiFilterPill(
              key: tripKindTabKey('timeline'),
              label: '일정',
              selected: kind == null,
              onTap: () => setState(() {
                _selectedKind = null;
                _clearItemDraft();
                _itemError = null;
              }),
            ),
            const SizedBox(width: 7),
            for (final option in tripItemKindOptions) ...[
              AlagagiFilterPill(
                key: tripKindTabKey(option.storageKey),
                label: option.label,
                selected: kind == option,
                onTap: () => setState(() {
                  _selectedKind = option;
                  _clearItemDraft();
                  _itemError = null;
                }),
              ),
              if (option != tripItemKindOptions.last) const SizedBox(width: 7),
            ],
          ],
        ),
      ),
      const SizedBox(height: 14),
      if (kind == null)
        ..._buildTimelineTab(trip)
      else
        ..._buildKindTab(trip, kind, packingChecked, packingTotal),
    ];
  }

  /// 일정 탭은 읽기 중심이다. 항목을 누르면 해당 종류 탭으로 옮겨가 고친다.
  List<Widget> _buildTimelineTab(Trip trip) {
    return [
      TripTimeline(
        days: widget.controller.tripTimelineDays(trip.id),
        onTapItem: _editItem,
      ),
    ];
  }

  List<Widget> _buildKindTab(
    Trip trip,
    TripItemKind kind,
    int packingChecked,
    int packingTotal,
  ) {
    final days = widget.controller.tripDaysForKind(trip.id, kind);
    final packingItems = kind.usesCheck
        ? widget.controller.tripItemsFor(trip.id, kind: kind)
        : const <TripItem>[];

    return [
      if (kind.usesCheck && packingTotal > 0) ...[
        Text(
          '챙긴 것 $packingChecked / $packingTotal',
          style: sans(size: 12, color: AlagagiColors.muted),
        ),
        const SizedBox(height: 12),
      ],
      _buildItemDraft(trip),
      const SizedBox(height: 16),
      if (kind.usesCheck) ...[
        if (packingItems.isEmpty)
          AlagagiEmptyStateCard(text: kind.emptyText)
        else
          for (final item in packingItems) ...[
            _TripItemCard(
              item: item,
              controller: widget.controller,
              onEdit: () => _editItem(item),
              onDelete: () => setState(() {
                widget.controller.deleteTripItem(item.id);
              }),
            ),
            const SizedBox(height: 9),
          ],
      ] else ...[
        if (days.isEmpty)
          AlagagiEmptyStateCard(text: kind.emptyText)
        else
          for (final day in days) ...[
            Padding(
              key: tripDayGroupKey(day.isUndated ? 'undated' : day.dateKey),
              padding: const EdgeInsets.only(bottom: 9),
              child: Row(
                children: [
                  Text(
                    day.dayLabel,
                    style: sans(
                      size: 11,
                      weight: FontWeight.w800,
                      color: AlagagiColors.sageDeep,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      day.dateLabel,
                      style: sans(size: 12, color: AlagagiColors.muted),
                    ),
                  ),
                ],
              ),
            ),
            for (final item in day.items) ...[
              _TripItemCard(
                item: item,
                controller: widget.controller,
                onEdit: () => _editItem(item),
                onDelete: () => setState(() {
                  widget.controller.deleteTripItem(item.id);
                }),
              ),
              const SizedBox(height: 9),
            ],
            const SizedBox(height: 6),
          ],
      ],
    ];
  }

  Widget _buildItemDraft(Trip trip) {
    final kind = _selectedKind ?? TripItemKind.plan;
    final editing = _editingItemId != null;

    return AlagagiPaperCard(
      compact: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  editing ? '${kind.label} 고치기' : '${kind.label} 추가',
                  style: sans(size: 13, weight: FontWeight.w800),
                ),
              ),
              if (editing)
                TextButton(
                  onPressed: () => setState(_clearItemDraft),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: AlagagiColors.muted,
                    textStyle: sans(size: 12, weight: FontWeight.w700),
                  ),
                  child: const Text('새로 추가'),
                ),
            ],
          ),
          const SizedBox(height: 10),
          _TripField(
            fieldKey: tripItemTitleFieldKey,
            controller: _itemTitleController,
            label: kind.label,
            hint: kind.titleHint,
            maxLength: 80,
          ),
          const SizedBox(height: 9),
          _TripField(
            fieldKey: tripItemNoteFieldKey,
            controller: _itemNoteController,
            label: '메모',
            hint: kind.noteHint,
            maxLength: 500,
            maxLines: 3,
          ),
          if (kind.appearsOnTimeline) ...[
            const SizedBox(height: 10),
            Text('언제', style: sans(size: 11.5, color: AlagagiColors.muted)),
            const SizedBox(height: 7),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                AlagagiFilterPill(
                  key: tripItemDateButtonKey('none'),
                  label: '미정',
                  selected: _itemDateKey == null,
                  onTap: () => setState(() => _itemDateKey = null),
                ),
                for (var index = 0; index < trip.dateKeys.length; index += 1)
                  AlagagiFilterPill(
                    key: tripItemDateButtonKey(trip.dateKeys[index]),
                    label: '${index + 1}일차',
                    selected: _itemDateKey == trip.dateKeys[index],
                    onTap: () =>
                        setState(() => _itemDateKey = trip.dateKeys[index]),
                  ),
              ],
            ),
            if (_itemDateKey != null) ...[
              const SizedBox(height: 9),
              _TripField(
                fieldKey: tripItemTimeFieldKey,
                controller: _itemTimeController,
                label: '몇 시 (선택)',
                hint: '09:30',
                maxLength: 5,
              ),
            ],
          ],
          if (_itemError != null) ...[
            const SizedBox(height: 8),
            Text(
              _itemError!,
              style: sans(size: 12, color: const Color(0xFFB35A49)),
            ),
          ],
          const SizedBox(height: 11),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              key: tripItemSubmitButtonKey,
              onPressed: () => _submitItem(trip, kind),
              style: FilledButton.styleFrom(
                backgroundColor: AlagagiColors.ink,
                foregroundColor: AlagagiColors.appBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: sans(size: 12, weight: FontWeight.w800),
              ),
              child: Text(editing ? '고친 내용 저장하기' : '${kind.label} 저장하기'),
            ),
          ),
        ],
      ),
    );
  }
}

/// 여행 상세 위쪽 요약 카드. 기간, 상태 전환, 편집/삭제 action을 모은다.
class _TripSummaryCard extends StatelessWidget {
  const _TripSummaryCard({
    required this.trip,
    required this.controller,
    required this.onEdit,
    required this.onDelete,
  });

  final Trip trip;
  final AlagagiController controller;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return AlagagiPaperCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              AlagagiSmallBadge(label: trip.status.label),
              AlagagiSmallBadge(label: trip.durationLabel),
              AlagagiSmallBadge(
                label: '${trip.startDateKey} ~ ${trip.endDateKey}',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              for (final status in TripStatus.values)
                AlagagiFilterPill(
                  key: tripStatusButtonKey(trip.id, status.storageKey),
                  label: status.label,
                  selected: trip.status == status,
                  onTap: () => controller.setTripStatus(trip.id, status),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              TextButton(
                onPressed: onEdit,
                child: const Text('여행 정보 고치기'),
              ),
              if (trip.createdByProfileId == controller.state.me.id) ...[
                const SizedBox(width: 4),
                TextButton(
                  onPressed: onDelete,
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFB35A49),
                  ),
                  child: const Text('여행 지우기'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  const _TripCard({
    required this.trip,
    required this.controller,
    required this.onOpen,
  });

  final Trip trip;
  final AlagagiController controller;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final packingTotal = controller
        .tripItemsFor(trip.id, kind: TripItemKind.packing)
        .length;
    final planTotal = controller
        .tripItemsFor(trip.id, kind: TripItemKind.plan)
        .length;

    return AlagagiPaperCard(
      key: tripCardKey(trip.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              AlagagiSmallBadge(label: trip.durationLabel),
              if (trip.destination.isNotEmpty)
                AlagagiSmallBadge(label: trip.destination),
            ],
          ),
          const SizedBox(height: 11),
          Text(
            trip.title,
            style: serif(context, size: 17, weight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            '${trip.startDateKey} ~ ${trip.endDateKey}',
            style: sans(size: 12, color: AlagagiColors.muted),
          ),
          const SizedBox(height: 10),
          Text(
            '계획 $planTotal · 준비물 $packingTotal',
            style: sans(size: 12, color: AlagagiColors.muted),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              key: tripOpenButtonKey(trip.id),
              onPressed: onOpen,
              style: OutlinedButton.styleFrom(
                foregroundColor: AlagagiColors.sageDeep,
                side: const BorderSide(color: AlagagiColors.line),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                padding: const EdgeInsets.symmetric(vertical: 11),
                textStyle: sans(size: 12.5, weight: FontWeight.w700),
              ),
              child: const Text('여행 열어보기'),
            ),
          ),
        ],
      ),
    );
  }
}

class _TripItemCard extends StatelessWidget {
  const _TripItemCard({
    required this.item,
    required this.controller,
    required this.onEdit,
    required this.onDelete,
  });

  final TripItem item;
  final AlagagiController controller;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final mine = item.createdByProfileId == controller.state.me.id;

    return AlagagiPaperCard(
      key: tripItemCardKey(item.id),
      compact: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.kind.usesCheck) ...[
            InkWell(
              key: tripItemCheckButtonKey(item.id),
              onTap: () => controller.toggleTripItemCheck(item.id),
              borderRadius: BorderRadius.circular(999),
              child: Padding(
                padding: const EdgeInsets.only(right: 10, top: 1),
                child: Icon(
                  item.checked
                      ? Icons.check_circle_rounded
                      : Icons.circle_outlined,
                  size: 20,
                  color: item.checked
                      ? AlagagiColors.sageDeep
                      : AlagagiColors.muted,
                ),
              ),
            ),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: sans(
                    size: 13.5,
                    weight: FontWeight.w700,
                    color: item.checked
                        ? AlagagiColors.muted
                        : AlagagiColors.ink,
                  ),
                ),
                if (item.dateKey != null) ...[
                  const SizedBox(height: 5),
                  Text(
                    item.timeLabel == null
                        ? item.dateKey!
                        : '${item.dateKey!} · ${item.timeLabel!}',
                    style: sans(size: 11.5, color: AlagagiColors.sageDeep),
                  ),
                ],
                if (item.note.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    item.note,
                    style: sans(
                      size: 12.5,
                      height: 1.6,
                      color: AlagagiColors.muted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            tooltip: '고치기',
            onPressed: onEdit,
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.edit_outlined,
              size: 17,
              color: AlagagiColors.muted,
            ),
          ),
          if (mine)
            IconButton(
              tooltip: '지우기',
              onPressed: onDelete,
              visualDensity: VisualDensity.compact,
              icon: const Icon(
                Icons.delete_outline_rounded,
                size: 18,
                color: AlagagiColors.muted,
              ),
            ),
        ],
      ),
    );
  }
}

class _TripField extends StatelessWidget {
  const _TripField({
    required this.fieldKey,
    required this.controller,
    required this.label,
    required this.hint,
    required this.maxLength,
    this.maxLines = 1,
  });

  final Key fieldKey;
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLength;
  final int maxLines;

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
