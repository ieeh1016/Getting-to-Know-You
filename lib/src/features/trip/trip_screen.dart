import 'package:flutter/material.dart';

import '../../app/app_shell.dart';
import '../../app/test_keys.dart';
import '../../data/trip_photo_picker.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/text_editing_sync.dart';
import '../../shared/ui_components.dart';
import '../../shared/ui_style.dart';
import 'trip_photo_viewer.dart';
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
  /// 상세 화면의 tab. 일정 타임라인, 종류별 편집, 사진 세 갈래다.
  _TripDetailTab _detailTab = _TripDetailTab.timeline;
  TripItemKind _selectedKind = TripItemKind.plan;
  String? _editingItemId;
  String? _itemDateKey;
  String? _itemEndDateKey;
  TripTransportMode _transportMode = TripTransportMode.flight;
  String? _tripError;
  String? _itemError;
  String? _photoError;
  bool _photoBusy = false;

  late final ImeSafeTextEditingController _titleController;
  late final ImeSafeTextEditingController _destinationController;
  late final ImeSafeTextEditingController _startController;
  late final ImeSafeTextEditingController _endController;
  late final ImeSafeTextEditingController _itemTitleController;
  late final ImeSafeTextEditingController _itemNoteController;
  late final ImeSafeTextEditingController _itemTimeController;
  late final ImeSafeTextEditingController _itemEndTimeController;
  late final ImeSafeTextEditingController _itemFromController;
  late final ImeSafeTextEditingController _itemToController;
  late final TripPhotoPicker _photoPicker;

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
    _itemEndTimeController = ImeSafeTextEditingController();
    _itemFromController = ImeSafeTextEditingController();
    _itemToController = ImeSafeTextEditingController();
    _photoPicker = createDefaultTripPhotoPicker();
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
    _itemEndTimeController.dispose();
    _itemFromController.dispose();
    _itemToController.dispose();
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
      endDateKey: kind.usesDateRange ? _itemEndDateKey : null,
      endTimeLabel: _itemEndTimeController.text,
      transportMode: kind.usesRoute ? _transportMode : null,
      fromLabel: _itemFromController.text,
      toLabel: _itemToController.text,
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
    _itemEndTimeController.text = '';
    _itemFromController.text = '';
    _itemToController.text = '';
    _itemDateKey = null;
    _itemEndDateKey = null;
    _transportMode = TripTransportMode.flight;
  }

  /// 타임라인에서 항목을 누르면 그 종류 탭으로 옮겨가 바로 고칠 수 있게 한다.
  void _editItem(TripItem item) {
    setState(() {
      _detailTab = _TripDetailTab.items;
      _selectedKind = item.kind;
      _editingItemId = item.id;
      _itemTitleController.text = item.title;
      _itemNoteController.text = item.note;
      _itemTimeController.text = item.timeLabel ?? '';
      _itemEndTimeController.text = item.endTimeLabel ?? '';
      _itemFromController.text = item.fromLabel ?? '';
      _itemToController.text = item.toLabel ?? '';
      _itemDateKey = item.dateKey;
      _itemEndDateKey = item.endDateKey;
      _transportMode = item.transportMode ?? TripTransportMode.flight;
      _itemError = null;
    });
  }

  Future<void> _pickPhoto(Trip trip) async {
    if (_photoBusy) {
      return;
    }
    setState(() {
      _photoBusy = true;
      _photoError = null;
    });
    String? error;
    try {
      final picked = await _photoPicker.pickImage();
      if (picked != null) {
        error = widget.controller.saveTripPhoto(
          tripId: trip.id,
          imageDataUrl: picked.dataUrl,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _photoBusy = false;
          _photoError = error;
        });
      }
    }
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
      _buildDetailTabs(trip),
      const SizedBox(height: 14),
      ...switch (_detailTab) {
        _TripDetailTab.timeline => _buildTimelineTab(trip),
        _TripDetailTab.items => _buildKindTab(trip, _selectedKind),
        _TripDetailTab.photos => _buildPhotoTab(trip),
      },
    ];
  }

  Widget _buildDetailTabs(Trip trip) {
    final photoCount = widget.controller.tripPhotoCount(trip.id);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          AlagagiFilterPill(
            key: tripKindTabKey('timeline'),
            label: '일정',
            selected: _detailTab == _TripDetailTab.timeline,
            onTap: () => setState(() {
              _detailTab = _TripDetailTab.timeline;
              _clearItemDraft();
              _itemError = null;
            }),
          ),
          const SizedBox(width: 7),
          for (final option in tripItemKindOptions) ...[
            AlagagiFilterPill(
              key: tripKindTabKey(option.storageKey),
              label: option.label,
              selected:
                  _detailTab == _TripDetailTab.items && _selectedKind == option,
              onTap: () => setState(() {
                _detailTab = _TripDetailTab.items;
                _selectedKind = option;
                _clearItemDraft();
                _itemError = null;
              }),
            ),
            const SizedBox(width: 7),
          ],
          AlagagiFilterPill(
            key: tripKindTabKey('photos'),
            label: photoCount == 0 ? '사진' : '사진 $photoCount',
            selected: _detailTab == _TripDetailTab.photos,
            onTap: () => setState(() {
              _detailTab = _TripDetailTab.photos;
              _photoError = null;
            }),
          ),
        ],
      ),
    );
  }

  /// 일정 탭은 읽기 중심이다. 항목을 누르면 해당 종류 탭으로 옮겨가 고친다.
  List<Widget> _buildTimelineTab(Trip trip) {
    return [
      TripTimeline(
        days: widget.controller.tripTimelineDays(trip.id),
        staysForNight: (dateKey) =>
            widget.controller.tripStaysForNight(trip.id, dateKey),
        staysCheckingOut: (dateKey) =>
            widget.controller.tripStaysCheckingOut(trip.id, dateKey),
        onTapItem: _editItem,
      ),
    ];
  }

  List<Widget> _buildPhotoTab(Trip trip) {
    final photos = widget.controller.tripPhotosFor(trip.id);
    final supported = _photoPicker.isSupported;

    return [
      // 담기 action은 한 줄로 줄이고 사진에 자리를 내준다.
      Row(
        children: [
          Expanded(
            child: Text(
              photos.isEmpty
                  ? '둘이 남긴 여행 사진'
                  : '둘이 남긴 여행 사진 ${photos.length}장',
              style: sans(size: 13, weight: FontWeight.w800),
            ),
          ),
          OutlinedButton.icon(
            key: tripPhotoAddButtonKey,
            onPressed: supported && !_photoBusy ? () => _pickPhoto(trip) : null,
            icon: Icon(
              _photoBusy
                  ? Icons.hourglass_empty_rounded
                  : Icons.add_photo_alternate_outlined,
              size: 16,
            ),
            label: Text(_photoBusy ? '담는 중' : '사진 담기'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AlagagiColors.sageDeep,
              side: const BorderSide(color: AlagagiColors.line),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 13),
              textStyle: sans(size: 12, weight: FontWeight.w700),
            ),
          ),
        ],
      ),
      if (!supported) ...[
        const SizedBox(height: 8),
        Text(
          '이 환경에서는 갤러리를 열 수 없어요. 휴대폰 브라우저에서 열어주세요.',
          style: sans(size: 12, height: 1.5, color: AlagagiColors.muted),
        ),
      ],
      if (_photoError != null) ...[
        const SizedBox(height: 8),
        Text(
          _photoError!,
          style: sans(size: 12, color: const Color(0xFFB35A49)),
        ),
      ],
      const SizedBox(height: 12),
      if (photos.isEmpty)
        const AlagagiEmptyStateCard(
          text: '아직 담은 사진이 없어요. 다녀와서 천천히 채워도 괜찮아요.',
        )
      else
        _TripPhotoMosaic(
          photos: photos,
          myProfileId: widget.controller.state.me.id,
          onOpen: (photo) => showTripPhotoViewer(
            context,
            controller: widget.controller,
            tripId: trip.id,
            initialPhotoId: photo.id,
          ),
        ),
    ];
  }

  List<Widget> _buildKindTab(Trip trip, TripItemKind kind) {
    final days = widget.controller.tripDaysForKind(trip.id, kind);
    final flatItems = widget.controller.tripItemsFor(trip.id, kind: kind);
    final packingTotal = kind.usesCheck ? flatItems.length : 0;
    final packingChecked = kind.usesCheck
        ? widget.controller.tripPackingCheckedCount(trip.id)
        : 0;

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
      // 준비물과 숙소는 날짜 흐름보다 목록으로 읽는 편이 자연스럽다.
      if (kind.usesCheck || kind.usesDateRange) ...[
        if (flatItems.isEmpty)
          AlagagiEmptyStateCard(text: kind.emptyText)
        else
          for (final item in flatItems) ...[
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
    final kind = _selectedKind;
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
          if (kind.usesRoute) ...[
            _TripFieldLabel(text: '무엇으로'),
            const SizedBox(height: 7),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final mode in tripTransportModeOptions)
                  AlagagiFilterPill(
                    key: tripTransportModeButtonKey(mode.storageKey),
                    label: mode.label,
                    selected: _transportMode == mode,
                    onTap: () => setState(() => _transportMode = mode),
                  ),
              ],
            ),
            const SizedBox(height: 11),
            Row(
              children: [
                Expanded(
                  child: _TripField(
                    fieldKey: tripItemFromFieldKey,
                    controller: _itemFromController,
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
                  child: _TripField(
                    fieldKey: tripItemToFieldKey,
                    controller: _itemToController,
                    label: '어디로',
                    hint: '예: 제주공항',
                    maxLength: 40,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 9),
          ],
          _TripField(
            fieldKey: tripItemTitleFieldKey,
            controller: _itemTitleController,
            label: kind.usesRoute ? '편명이나 노선' : kind.label,
            hint: kind.usesRoute ? _transportMode.titleHint : kind.titleHint,
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
          if (kind.usesDateRange) ..._buildStayDateFields(trip),
          if (kind.usesRoute || kind == TripItemKind.plan)
            ..._buildScheduleFields(trip, kind),
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

  /// 숙소는 하루가 아니라 체크인~체크아웃 범위를 갖는다.
  List<Widget> _buildStayDateFields(Trip trip) {
    final nights = _stayNightPreview(trip);

    return [
      const SizedBox(height: 11),
      _TripFieldLabel(text: '체크인'),
      const SizedBox(height: 7),
      _TripDayPicker(
        trip: trip,
        selectedDateKey: _itemDateKey,
        keyBuilder: tripItemDateButtonKey,
        onSelected: (dateKey) => setState(() {
          _itemDateKey = dateKey;
          // 체크인이 체크아웃과 같거나 뒤면 범위를 다시 고르게 비운다.
          final end = _itemEndDateKey;
          if (dateKey == null ||
              (end != null && end.compareTo(dateKey) <= 0)) {
            _itemEndDateKey = null;
          }
        }),
      ),
      if (_itemDateKey != null) ...[
        const SizedBox(height: 9),
        _TripField(
          fieldKey: tripItemTimeFieldKey,
          controller: _itemTimeController,
          label: '체크인 시각 (선택)',
          hint: '15:00',
          maxLength: 5,
        ),
        const SizedBox(height: 11),
        _TripFieldLabel(text: '체크아웃'),
        const SizedBox(height: 7),
        _TripDayPicker(
          trip: trip,
          selectedDateKey: _itemEndDateKey,
          keyBuilder: tripStayCheckOutDateButtonKey,
          // 체크아웃은 체크인 다음 날부터다.
          enabledFrom: _itemDateKey,
          onSelected: (dateKey) =>
              setState(() => _itemEndDateKey = dateKey),
        ),
        if (_itemEndDateKey != null) ...[
          const SizedBox(height: 9),
          _TripField(
            fieldKey: tripItemEndTimeFieldKey,
            controller: _itemEndTimeController,
            label: '체크아웃 시각 (선택)',
            hint: '11:00',
            maxLength: 5,
          ),
        ],
        if (nights > 0) ...[
          const SizedBox(height: 9),
          Text(
            '$nights박 머물러요',
            style: sans(
              size: 11.5,
              weight: FontWeight.w800,
              color: AlagagiColors.sageDeep,
            ),
          ),
        ],
      ],
    ];
  }

  int _stayNightPreview(Trip trip) {
    final start = DateTime.tryParse(_itemDateKey ?? '');
    final end = DateTime.tryParse(_itemEndDateKey ?? '');
    if (start == null || end == null) {
      return 0;
    }
    final nights = end.difference(start).inDays;
    return nights < 0 ? 0 : nights;
  }

  /// 이동과 계획은 하루 안의 시각을 갖는다. 이동은 도착 시각까지 받는다.
  List<Widget> _buildScheduleFields(Trip trip, TripItemKind kind) {
    return [
      const SizedBox(height: 11),
      _TripFieldLabel(text: '언제'),
      const SizedBox(height: 7),
      _TripDayPicker(
        trip: trip,
        selectedDateKey: _itemDateKey,
        keyBuilder: tripItemDateButtonKey,
        allowsUndecided: true,
        onSelected: (dateKey) => setState(() => _itemDateKey = dateKey),
      ),
      if (_itemDateKey != null) ...[
        const SizedBox(height: 9),
        Row(
          children: [
            Expanded(
              child: _TripField(
                fieldKey: tripItemTimeFieldKey,
                controller: _itemTimeController,
                label: kind.usesRoute ? '출발' : '몇 시 (선택)',
                hint: '09:30',
                maxLength: 5,
              ),
            ),
            if (kind.usesRoute) ...[
              const SizedBox(width: 10),
              Expanded(
                child: _TripField(
                  fieldKey: tripItemEndTimeFieldKey,
                  controller: _itemEndTimeController,
                  label: '도착',
                  hint: '10:45',
                  maxLength: 5,
                ),
              ),
            ],
          ],
        ),
      ],
    ];
  }
}

enum _TripDetailTab { timeline, items, photos }

class _TripFieldLabel extends StatelessWidget {
  const _TripFieldLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: sans(size: 11.5, color: AlagagiColors.muted));
  }
}

/// 여행 기간 안의 날짜를 `1일차`처럼 순서로 고르게 한다.
class _TripDayPicker extends StatelessWidget {
  const _TripDayPicker({
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

/// 담아둔 여행 사진 배치.
///
/// 같은 크기 조각만 늘어놓으면 앨범이라기보다 목록에 가깝다. 가장 최근
/// 사진을 넓게 두고 나머지를 두 칸으로 이어 붙여 앨범처럼 읽히게 한다.
class _TripPhotoMosaic extends StatelessWidget {
  const _TripPhotoMosaic({
    required this.photos,
    required this.myProfileId,
    required this.onOpen,
  });

  static const double _gap = 8;

  final List<TripPhoto> photos;
  final String myProfileId;
  final ValueChanged<TripPhoto> onOpen;

  @override
  Widget build(BuildContext context) {
    final rest = photos.length > 1 ? photos.sublist(1) : const <TripPhoto>[];

    return LayoutBuilder(
      key: tripPhotoGridKey,
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final tileWidth = (width - _gap) / 2;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TripPhotoTile(
              photo: photos.first,
              mine: photos.first.createdByProfileId == myProfileId,
              // 최근 사진은 넓게 두어 앨범의 표지처럼 읽히게 한다.
              aspectRatio: 4 / 3,
              onTap: () => onOpen(photos.first),
            ),
            if (rest.isNotEmpty) ...[
              const SizedBox(height: _gap),
              Wrap(
                spacing: _gap,
                runSpacing: _gap,
                children: [
                  for (final photo in rest)
                    SizedBox(
                      width: tileWidth,
                      child: _TripPhotoTile(
                        photo: photo,
                        mine: photo.createdByProfileId == myProfileId,
                        aspectRatio: 1,
                        onTap: () => onOpen(photo),
                      ),
                    ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}

class _TripPhotoTile extends StatelessWidget {
  const _TripPhotoTile({
    required this.photo,
    required this.mine,
    required this.aspectRatio,
    required this.onTap,
  });

  final TripPhoto photo;
  final bool mine;
  final double aspectRatio;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AlagagiCardGeometry.compactRadius);

    return InkWell(
      key: tripPhotoCardKey(photo.id),
      onTap: onTap,
      borderRadius: radius,
      child: Container(
        decoration: BoxDecoration(
          color: AlagagiColors.paper,
          border: Border.all(color: AlagagiColors.line),
          borderRadius: radius,
        ),
        clipBehavior: Clip.antiAlias,
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                photo.imageDataUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AlagagiColors.skyPanel,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    size: 20,
                    color: AlagagiColors.muted,
                  ),
                ),
              ),
              // 설명은 조각 높이를 흔들지 않도록 사진 위에 얹는다.
              if (photo.caption.isNotEmpty)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x00000000), Color(0x99000000)],
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(10, 16, 10, 8),
                    child: Text(
                      photo.caption,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: sans(
                        size: 11.5,
                        height: 1.4,
                        weight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              if (mine)
                Positioned(
                  top: 7,
                  right: 7,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.38),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    child: Text(
                      '내가 담음',
                      style: sans(
                        size: 9.5,
                        weight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
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

/// 목록 카드에 보여줄 날짜/시각 한 줄.
///
/// 숙소는 체크인~체크아웃 범위와 박 수를, 이동은 출발~도착 구간을 보여준다.
String? _itemScheduleLabel(TripItem item) {
  final dateKey = item.dateKey;
  if (dateKey == null) {
    return null;
  }
  if (item.kind.usesDateRange) {
    final checkIn = item.timeLabel == null
        ? dateKey
        : '$dateKey ${item.timeLabel}';
    final endDateKey = item.endDateKey;
    if (endDateKey == null) {
      return '$checkIn 체크인';
    }
    final checkOut = item.endTimeLabel == null
        ? endDateKey
        : '$endDateKey ${item.endTimeLabel}';
    return '$checkIn → $checkOut · ${item.stayNightCount}박';
  }
  final start = item.timeLabel;
  if (start == null) {
    return dateKey;
  }
  final end = item.endTimeLabel;
  return end == null ? '$dateKey $start' : '$dateKey $start → $end';
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
          if (!item.kind.usesCheck) ...[
            AlagagiSymbolMark(
              icon: item.transportMode == null
                  ? tripItemKindIcon(item.kind)
                  : tripTransportModeIcon(item.transportMode!),
              size: 28,
              iconSize: 14,
              tone: AlagagiColors.skyPanel,
              iconColor: AlagagiColors.sageDeep,
              radius: 10,
            ),
            const SizedBox(width: 10),
          ],
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
                if (_itemScheduleLabel(item) != null) ...[
                  const SizedBox(height: 5),
                  Text(
                    _itemScheduleLabel(item)!,
                    style: sans(
                      size: 11.5,
                      weight: FontWeight.w700,
                      color: AlagagiColors.sageDeep,
                    ),
                  ),
                ],
                if (item.kind.usesRoute &&
                    (item.fromLabel != null || item.toLabel != null)) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${item.fromLabel ?? '출발지 미정'} → ${item.toLabel ?? '도착지 미정'}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: sans(size: 12, color: AlagagiColors.muted),
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
