import 'package:flutter/material.dart';

import '../../app/app_shell.dart';
import '../../app/test_keys.dart';
import '../../data/trip_photo_picker.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/ui_components.dart';
import '../../shared/ui_style.dart';
import '../place/place_common.dart';
import 'trip_photo_viewer.dart';
import 'trip_sheets.dart';
import 'trip_timeline.dart';

/// 여행 상세의 갈래.
///
/// 종류마다 tab을 두면 여섯 칸이 되어 가로로 밀린다. 시간 흐름은 `일정`
/// 하나로 모으고, 성격이 다른 숙소/준비물/사진만 따로 둔다.
enum TripDetailTab { timeline, stay, packing, photos }

extension TripDetailTabMeta on TripDetailTab {
  String get storageKey => switch (this) {
    TripDetailTab.timeline => 'timeline',
    TripDetailTab.stay => 'stay',
    TripDetailTab.packing => 'packing',
    TripDetailTab.photos => 'photos',
  };

  String get label => switch (this) {
    TripDetailTab.timeline => '일정',
    TripDetailTab.stay => '숙소',
    TripDetailTab.packing => '준비물',
    TripDetailTab.photos => '사진',
  };
}

/// 여행 계획 화면. 여행 목록과 여행 하나의 상세를 같은 화면에서 전환한다.
class TripScreen extends StatefulWidget {
  const TripScreen({super.key, required this.controller});

  final AlagagiController controller;

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  String? _openTripId;
  TripDetailTab _tab = TripDetailTab.timeline;
  String? _photoError;
  String? _photoDayFilter;
  bool _photoBusy = false;

  late final TripPhotoPicker _photoPicker;

  @override
  void initState() {
    super.initState();
    _photoPicker = createDefaultTripPhotoPicker();
  }

  Future<void> _openTripForm({Trip? trip}) {
    return showTripFormSheet(
      context,
      controller: widget.controller,
      trip: trip,
    );
  }

  Future<void> _addItem(Trip trip) async {
    final kind = await showTripKindPickerSheet(context);
    if (kind == null || !mounted) {
      return;
    }
    await showTripItemFormSheet(
      context,
      controller: widget.controller,
      trip: trip,
      kind: kind,
    );
    if (mounted) {
      setState(() => _tab = _tabForKind(kind));
    }
  }

  TripDetailTab _tabForKind(TripItemKind kind) => switch (kind) {
    TripItemKind.stay => TripDetailTab.stay,
    TripItemKind.packing => TripDetailTab.packing,
    _ => TripDetailTab.timeline,
  };

  Future<void> _editItem(Trip trip, TripItem item) {
    return showTripItemFormSheet(
      context,
      controller: widget.controller,
      trip: trip,
      kind: item.kind,
      item: item,
    );
  }

  /// 사진을 여행의 어느 날 것으로 묶을지 고른다.
  Future<void> _tagPhotoDay(Trip trip, TripPhoto photo) async {
    final picked = await showTripPhotoDaySheet(
      context,
      trip: trip,
      selectedDateKey: photo.dateKey,
    );
    if (picked == null || !mounted) {
      return;
    }
    final error = widget.controller.setTripPhotoDateKey(
      photo.id,
      picked.isEmpty ? null : picked,
    );
    setState(() => _photoError = error);
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
      const SizedBox(height: 14),
      _AddTripBanner(onTap: () => _openTripForm()),
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
            onOpen: () => setState(() {
              _openTripId = trip.id;
              _tab = TripDetailTab.timeline;
            }),
          ),
          const SizedBox(height: 11),
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
            onOpen: () => setState(() {
              _openTripId = trip.id;
              _tab = TripDetailTab.timeline;
            }),
          ),
          const SizedBox(height: 11),
        ],
      ],
    ];
  }

  List<Widget> _buildTripDetail(Trip trip) {
    return [
      _TripDetailHeader(
        trip: trip,
        controller: widget.controller,
        onMore: () => _openTripActions(trip),
      ),
      if (widget.controller.tripNeedsStatusNudge(trip)) ...[
        const SizedBox(height: 12),
        _TripStatusNudge(
          onConfirm: () => widget.controller.setTripStatus(
            trip.id,
            TripStatus.done,
          ),
        ),
      ],
      const SizedBox(height: 14),
      _TripTabBar(
        selected: _tab,
        photoCount: widget.controller.tripPhotoCount(trip.id),
        onSelected: (tab) => setState(() {
          _tab = tab;
          _photoError = null;
        }),
      ),
      const SizedBox(height: 14),
      if (_tab != TripDetailTab.photos) ...[
        _AddItemButton(onTap: () => _addItem(trip)),
        const SizedBox(height: 14),
      ],
      ...switch (_tab) {
        TripDetailTab.timeline => _buildTimelineTab(trip),
        TripDetailTab.stay => _buildStayTab(trip),
        TripDetailTab.packing => _buildPackingTab(trip),
        TripDetailTab.photos => _buildPhotoTab(trip),
      },
    ];
  }

  /// 여행 정보 고치기와 지우기를 한곳에 모은다.
  Future<void> _openTripActions(Trip trip) async {
    final action = await showTripActionsSheet(
      context,
      canDelete: trip.createdByProfileId == widget.controller.state.me.id,
    );
    if (action == null || !mounted) {
      return;
    }
    if (action == TripAction.edit) {
      await _openTripForm(trip: trip);
      return;
    }
    final confirmed = await _confirmTripDelete(trip);
    if (!confirmed || !mounted) {
      return;
    }
    widget.controller.deleteTrip(trip.id);
    setState(() => _openTripId = null);
  }

  Future<bool> _confirmTripDelete(Trip trip) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _ConfirmSheet(
        title: '이 여행을 지울까요?',
        body: '${trip.title}에 담아둔 일정과 사진도 함께 사라져요.',
        confirmLabel: '여행 지우기',
        confirmKey: tripDeleteConfirmButtonKey,
        onConfirm: () => Navigator.of(sheetContext).pop(true),
        onCancel: () => Navigator.of(sheetContext).pop(false),
      ),
    );
    return result ?? false;
  }

  Future<void> _confirmItemDelete(TripItem item) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _ConfirmSheet(
        title: '${item.title}을 지울까요?',
        body: '지우면 되돌릴 수 없어요.',
        confirmLabel: '지우기',
        confirmKey: tripItemDeleteConfirmButtonKey(item.id),
        onConfirm: () => Navigator.of(sheetContext).pop(true),
        onCancel: () => Navigator.of(sheetContext).pop(false),
      ),
    );
    if (result == true && mounted) {
      setState(() => widget.controller.deleteTripItem(item.id));
    }
  }

  /// 일정 탭은 읽기 중심이다. 항목을 누르면 그 자리에서 고친다.
  List<Widget> _buildTimelineTab(Trip trip) {
    return [
      TripTimeline(
        days: widget.controller.tripTimelineDays(trip.id),
        staysForNight: (dateKey) =>
            widget.controller.tripStaysForNight(trip.id, dateKey),
        staysCheckingOut: (dateKey) =>
            widget.controller.tripStaysCheckingOut(trip.id, dateKey),
        placeFor: widget.controller.placeForTripItem,
        photosForDate: (dateKey) =>
            widget.controller.tripPhotosForDate(trip.id, dateKey),
        todayDateKey: widget.controller.todayDateKey,
        onTapItem: (item) => _editItem(trip, item),
        onTapPhoto: (photo) => showTripPhotoViewer(
          context,
          controller: widget.controller,
          tripId: trip.id,
          initialPhotoId: photo.id,
        ),
        onReorder: (dateKey, oldIndex, newIndex) => setState(() {
          widget.controller.reorderTripDayItems(
            trip.id,
            dateKey,
            oldIndex,
            newIndex,
          );
        }),
      ),
    ];
  }

  List<Widget> _buildStayTab(Trip trip) {
    final stays = widget.controller.tripItemsFor(
      trip.id,
      kind: TripItemKind.stay,
    );

    return [
      if (stays.isEmpty)
        AlagagiEmptyStateCard(text: TripItemKind.stay.emptyText)
      else
        for (final stay in stays) ...[
          _TripItemCard(
            item: stay,
            controller: widget.controller,
            onEdit: () => _editItem(trip, stay),
            onDelete: () => _confirmItemDelete(stay),
          ),
          const SizedBox(height: 9),
        ],
    ];
  }

  List<Widget> _buildPackingTab(Trip trip) {
    final items = widget.controller.tripItemsFor(
      trip.id,
      kind: TripItemKind.packing,
    );
    final checked = widget.controller.tripPackingCheckedCount(trip.id);

    return [
      if (items.isNotEmpty) ...[
        Text(
          '챙긴 것 $checked / ${items.length}',
          style: sans(size: 12, color: AlagagiColors.muted),
        ),
        const SizedBox(height: 12),
      ],
      if (items.isEmpty)
        AlagagiEmptyStateCard(text: TripItemKind.packing.emptyText)
      else
        for (final item in items) ...[
          _TripItemCard(
            item: item,
            controller: widget.controller,
            onEdit: () => _editItem(trip, item),
            onDelete: () => _confirmItemDelete(item),
            onAssign: (profileId) => setState(() {
              widget.controller.setTripItemAssignee(item.id, profileId);
            }),
          ),
          const SizedBox(height: 9),
        ],
    ];
  }

  List<Widget> _buildPhotoTab(Trip trip) {
    final photos = widget.controller.tripPhotosFor(trip.id);
    final supported = _photoPicker.isSupported;

    return [
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
          SizedBox(
            height: 44,
            child: OutlinedButton.icon(
              key: tripPhotoAddButtonKey,
              onPressed: supported && !_photoBusy
                  ? () => _pickPhoto(trip)
                  : null,
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
                padding: const EdgeInsets.symmetric(horizontal: 15),
                textStyle: sans(size: 12, weight: FontWeight.w700),
              ),
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
      if (photos.isNotEmpty) ...[
        const SizedBox(height: 12),
        _PhotoDayFilter(
          trip: trip,
          selected: _photoDayFilter,
          onSelected: (dateKey) => setState(() => _photoDayFilter = dateKey),
        ),
      ],
      const SizedBox(height: 12),
      if (photos.isEmpty)
        const AlagagiEmptyStateCard(
          text: '아직 담은 사진이 없어요. 다녀와서 천천히 채워도 괜찮아요.',
        )
      else
        _TripPhotoMosaic(
          photos: _photoDayFilter == null
              ? photos
              : photos
                    .where((photo) => photo.dateKey == _photoDayFilter)
                    .toList(),
          myProfileId: widget.controller.state.me.id,
          onTagDay: (photo) => _tagPhotoDay(trip, photo),
          onOpen: (photo) => showTripPhotoViewer(
            context,
            controller: widget.controller,
            tripId: trip.id,
            initialPhotoId: photo.id,
          ),
        ),
    ];
  }
}

/// 목록 맨 위의 만들기 줄. 버튼 하나보다 다음 행동이 또렷하다.
class _AddTripBanner extends StatelessWidget {
  const _AddTripBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: tripAddButtonKey,
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        constraints: const BoxConstraints(minHeight: 62),
        decoration: BoxDecoration(
          color: AlagagiColors.skyPanel,
          border: Border.all(color: AlagagiColors.line),
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.fromLTRB(15, 12, 15, 12),
        child: Row(
          children: [
            AlagagiSymbolMark(
              icon: Icons.luggage_outlined,
              size: 36,
              iconSize: 18,
              tone: AlagagiColors.paper,
              iconColor: AlagagiColors.sageDeep,
              radius: 13,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '새 여행 만들기',
                    style: sans(size: 13.5, weight: FontWeight.w800),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '이름과 기간만 정하면 시작할 수 있어요',
                    style: sans(size: 11.5, color: AlagagiColors.muted),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.add_rounded,
              size: 20,
              color: AlagagiColors.sageDeep,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddItemButton extends StatelessWidget {
  const _AddItemButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        key: tripItemAddButtonKey,
        onPressed: onTap,
        icon: const Icon(Icons.add_rounded, size: 18),
        label: const Text('일정 담기'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AlagagiColors.sageDeep,
          side: const BorderSide(color: AlagagiColors.line),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          textStyle: sans(size: 13, weight: FontWeight.w800),
        ),
      ),
    );
  }
}

/// 상세 상단. 표지 사진이 있으면 그 위에 기간과 D-day를 얹는다.
class _TripDetailHeader extends StatelessWidget {
  const _TripDetailHeader({
    required this.trip,
    required this.controller,
    required this.onMore,
  });

  final Trip trip;
  final AlagagiController controller;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    final timing = controller.tripTimingFor(trip);

    return AlagagiPaperCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    AlagagiSmallBadge(label: timing.label, dark: true),
                    AlagagiSmallBadge(label: trip.durationLabel),
                    if (trip.destination.isNotEmpty)
                      AlagagiSmallBadge(label: trip.destination),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // 고치기와 지우기를 맨몸 text로 두면 눌러야 하는 것인지
              // 읽히지 않는다. 한 자리로 모아 sheet에서 고르게 한다.
              SizedBox(
                width: 40,
                height: 40,
                child: IconButton(
                  key: tripMoreButtonKey,
                  onPressed: onMore,
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(
                    Icons.more_horiz_rounded,
                    size: 20,
                    color: AlagagiColors.muted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          Text(
            '${trip.startDateKey} ~ ${trip.endDateKey}',
            style: sans(size: 12.5, color: AlagagiColors.muted),
          ),
          const SizedBox(height: 13),
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
        ],
      ),
    );
  }
}

/// 상세의 네 갈래. 390px에서 가로 스크롤 없이 들어간다.
class _TripTabBar extends StatelessWidget {
  const _TripTabBar({
    required this.selected,
    required this.photoCount,
    required this.onSelected,
  });

  final TripDetailTab selected;
  final int photoCount;
  final ValueChanged<TripDetailTab> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AlagagiColors.skyPanel,
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          for (final tab in TripDetailTab.values)
            Expanded(
              child: _TabButton(
                tab: tab,
                selected: selected == tab,
                badge: tab == TripDetailTab.photos && photoCount > 0
                    ? photoCount
                    : null,
                onTap: () => onSelected(tab),
              ),
            ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.tab,
    required this.selected,
    required this.badge,
    required this.onTap,
  });

  final TripDetailTab tab;
  final bool selected;
  final int? badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: tripKindTabKey(tab.storageKey),
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: Container(
        // 탭 줄도 손가락 높이를 지킨다.
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AlagagiColors.paper : Colors.transparent,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: selected ? AlagagiColors.line : Colors.transparent,
          ),
        ),
        child: Text(
          badge == null ? tab.label : '${tab.label} $badge',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: sans(
            size: 12.5,
            weight: selected ? FontWeight.w800 : FontWeight.w600,
            color: selected ? AlagagiColors.ink : AlagagiColors.muted,
          ),
        ),
      ),
    );
  }
}

/// 되돌릴 수 없는 동작은 확인 sheet를 거친다.
///
/// 아이콘 하나로 지우게 두면 손가락으로 스치기만 해도 사라진다. tooltip은
/// 마우스에서만 보여 모바일에서는 설명이 되지 않는다.
class _ConfirmSheet extends StatelessWidget {
  const _ConfirmSheet({
    required this.title,
    required this.body,
    required this.confirmLabel,
    required this.confirmKey,
    required this.onConfirm,
    required this.onCancel,
  });

  final String title;
  final String body;
  final String confirmLabel;
  final Key confirmKey;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        decoration: BoxDecoration(
          color: AlagagiColors.paper,
          border: Border.all(color: AlagagiColors.line),
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: serif(context, size: 17, weight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(
              body,
              style: sans(size: 12.5, height: 1.6, color: AlagagiColors.muted),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: onCancel,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AlagagiColors.muted,
                        side: const BorderSide(color: AlagagiColors.line),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: sans(size: 13, weight: FontWeight.w700),
                      ),
                      child: const Text('그대로 두기'),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: FilledButton(
                      key: confirmKey,
                      onPressed: onConfirm,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFB35A49),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: sans(size: 13, weight: FontWeight.w800),
                      ),
                      child: Text(confirmLabel),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 날짜가 지났는데 아직 `계획 중`인 여행에 조용히 물어본다.
///
/// 날짜만 보고 자동으로 바꾸지 않는다. 일정이 밀렸을 수도 있어서다.
class _TripStatusNudge extends StatelessWidget {
  const _TripStatusNudge({required this.onConfirm});

  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: tripStatusNudgeKey,
      decoration: BoxDecoration(
        color: AlagagiColors.skyPanel,
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '여행 날짜가 지났어요. 다녀온 여행으로 옮겨둘까요?',
              style: sans(size: 12.5, height: 1.5),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 40,
            child: FilledButton(
              key: tripStatusNudgeConfirmButtonKey,
              onPressed: onConfirm,
              style: FilledButton.styleFrom(
                backgroundColor: AlagagiColors.ink,
                foregroundColor: AlagagiColors.appBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                textStyle: sans(size: 12, weight: FontWeight.w800),
              ),
              child: const Text('옮기기'),
            ),
          ),
        ],
      ),
    );
  }
}

/// 사진을 여행의 날짜로 좁혀 본다.
class _PhotoDayFilter extends StatelessWidget {
  const _PhotoDayFilter({
    required this.trip,
    required this.selected,
    required this.onSelected,
  });

  final Trip trip;
  final String? selected;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final dateKeys = trip.dateKeys;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          AlagagiFilterPill(
            key: tripPhotoDayButtonKey('all'),
            label: '전체',
            selected: selected == null,
            onTap: () => onSelected(null),
          ),
          const SizedBox(width: 7),
          for (var index = 0; index < dateKeys.length; index += 1) ...[
            AlagagiFilterPill(
              key: tripPhotoDayButtonKey(dateKeys[index]),
              label: '${index + 1}일차',
              selected: selected == dateKeys[index],
              onTap: () => onSelected(dateKeys[index]),
            ),
            if (index != dateKeys.length - 1) const SizedBox(width: 7),
          ],
        ],
      ),
    );
  }
}

/// 담아둔 여행 사진 배치.
class _TripPhotoMosaic extends StatelessWidget {
  const _TripPhotoMosaic({
    required this.photos,
    required this.myProfileId,
    required this.onOpen,
    required this.onTagDay,
  });

  static const double _gap = 8;

  final List<TripPhoto> photos;
  final String myProfileId;
  final ValueChanged<TripPhoto> onOpen;
  final ValueChanged<TripPhoto> onTagDay;

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) {
      return const AlagagiEmptyStateCard(text: '이 날짜에 담은 사진이 없어요.');
    }
    final rest = photos.length > 1 ? photos.sublist(1) : const <TripPhoto>[];

    return LayoutBuilder(
      key: tripPhotoGridKey,
      builder: (context, constraints) {
        final tileWidth = (constraints.maxWidth - _gap) / 2;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TripPhotoTile(
              photo: photos.first,
              mine: photos.first.createdByProfileId == myProfileId,
              aspectRatio: 4 / 3,
              onTap: () => onOpen(photos.first),
              onTagDay: () => onTagDay(photos.first),
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
                        onTagDay: () => onTagDay(photo),
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
    required this.onTagDay,
  });

  final TripPhoto photo;
  final bool mine;
  final double aspectRatio;
  final VoidCallback onTap;
  final VoidCallback onTagDay;

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
                  top: 5,
                  right: 5,
                  child: InkWell(
                    key: tripPhotoDayTagButtonKey(photo.id),
                    onTap: onTagDay,
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 28),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.42),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 9),
                      child: Text(
                        photo.dateKey == null ? '날짜 정하기' : photo.dateKey!,
                        style: sans(
                          size: 9.5,
                          weight: FontWeight.w700,
                          color: Colors.white,
                        ),
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

/// 준비물을 누가 챙길지 고르는 줄.
///
/// 정하지 않아도 된다. 같은 사람을 다시 누르면 담당이 풀린다.
class _AssigneeRow extends StatelessWidget {
  const _AssigneeRow({
    required this.item,
    required this.controller,
    required this.onAssign,
  });

  final TripItem item;
  final AlagagiController controller;
  final ValueChanged<String?> onAssign;

  @override
  Widget build(BuildContext context) {
    final me = controller.state.me;
    final partner = controller.state.partner;

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final profile in [me, partner])
          AlagagiFilterPill(
            key: tripItemAssigneeButtonKey(item.id, profile.id),
            label: profile.nickname,
            selected: item.assigneeProfileId == profile.id,
            onTap: () => onAssign(profile.id),
          ),
        // 둘 다 챙겨야 하는 것도 있다.
        AlagagiFilterPill(
          key: tripItemAssigneeButtonKey(item.id, kTripSharedAssigneeId),
          label: '함께',
          selected: item.assigneeProfileId == kTripSharedAssigneeId,
          onTap: () => onAssign(kTripSharedAssigneeId),
        ),
      ],
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

/// 여행 목록의 카드. 담아둔 사진이 있으면 표지로 쓴다.
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
    final photos = controller.tripPhotosFor(trip.id);
    final cover = photos.isEmpty ? null : photos.first;
    final timing = controller.tripTimingFor(trip);
    final planCount = controller
        .tripItemsFor(trip.id, kind: TripItemKind.plan)
        .length;
    final packingCount = controller
        .tripItemsFor(trip.id, kind: TripItemKind.packing)
        .length;
    final radius = BorderRadius.circular(AlagagiCardGeometry.radius);

    return InkWell(
      key: tripCardKey(trip.id),
      onTap: onOpen,
      borderRadius: radius,
      child: Container(
        decoration: BoxDecoration(
          color: AlagagiColors.paper,
          border: Border.all(color: AlagagiColors.line),
          borderRadius: radius,
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F2F2E2A),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TripCardCover(cover: cover, timing: timing, trip: trip),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 12, 15, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${trip.startDateKey} ~ ${trip.endDateKey}',
                    style: sans(size: 11.5, color: AlagagiColors.muted),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _TripCardMetric(
                        icon: Icons.explore_outlined,
                        label: '계획 $planCount',
                      ),
                      const SizedBox(width: 12),
                      _TripCardMetric(
                        icon: Icons.backpack_outlined,
                        label: '준비물 $packingCount',
                      ),
                      const SizedBox(width: 12),
                      _TripCardMetric(
                        icon: Icons.photo_outlined,
                        label: '사진 ${photos.length}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TripCardCover extends StatelessWidget {
  const _TripCardCover({
    required this.cover,
    required this.timing,
    required this.trip,
  });

  final TripPhoto? cover;
  final TripTiming timing;
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final photo = cover;

    return SizedBox(
      height: 132,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (photo != null)
            Image.network(
              photo.imageDataUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const _TripCoverFallback(),
            )
          else
            const _TripCoverFallback(),
          // 사진 위 글씨가 묻히지 않게 어둡게 깔아준다.
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x22000000), Color(0xB3000000)],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 12, 15, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    child: Text(
                      timing.label,
                      style: sans(
                        size: 10.5,
                        weight: FontWeight.w800,
                        color: AlagagiColors.ink,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  trip.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: serif(
                    context,
                    size: 19,
                    weight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  trip.destination.isEmpty
                      ? trip.durationLabel
                      : '${trip.destination} · ${trip.durationLabel}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: sans(
                    size: 11.5,
                    weight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.88),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TripCoverFallback extends StatelessWidget {
  const _TripCoverFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AlagagiColors.sky, AlagagiColors.sageDeep],
        ),
      ),
    );
  }
}

class _TripCardMetric extends StatelessWidget {
  const _TripCardMetric({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AlagagiColors.muted),
        const SizedBox(width: 4),
        Text(label, style: sans(size: 11.5, color: AlagagiColors.muted)),
      ],
    );
  }
}

class _TripItemCard extends StatelessWidget {
  const _TripItemCard({
    required this.item,
    required this.controller,
    required this.onEdit,
    required this.onDelete,
    this.onAssign,
  });

  final TripItem item;
  final AlagagiController controller;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  /// 준비물에서만 쓴다. 챙길 사람을 고르는 콜백이다.
  final ValueChanged<String?>? onAssign;

  @override
  Widget build(BuildContext context) {
    final mine = item.createdByProfileId == controller.state.me.id;
    final schedule = _itemScheduleLabel(item);

    return AlagagiPaperCard(
      key: tripItemCardKey(item.id),
      compact: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.kind.usesCheck)
            SizedBox(
              width: 44,
              height: 44,
              child: InkWell(
                key: tripItemCheckButtonKey(item.id),
                onTap: () => controller.toggleTripItemCheck(item.id),
                borderRadius: BorderRadius.circular(999),
                child: Icon(
                  item.checked
                      ? Icons.check_circle_rounded
                      : Icons.circle_outlined,
                  size: 21,
                  color: item.checked
                      ? AlagagiColors.sageDeep
                      : AlagagiColors.muted,
                ),
              ),
            )
          else ...[
            AlagagiSymbolMark(
              icon: item.transportMode == null
                  ? tripItemKindIcon(item.kind)
                  : tripTransportModeIcon(item.transportMode!),
              size: 30,
              iconSize: 15,
              tone: AlagagiColors.skyPanel,
              iconColor: AlagagiColors.sageDeep,
              radius: 11,
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
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
                  if (schedule != null) ...[
                    const SizedBox(height: 5),
                    Text(
                      schedule,
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
                  if (controller.placeForTripItem(item) != null) ...[
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          placeCategoryIcon(
                            controller.placeForTripItem(item)!.category,
                          ),
                          size: 13,
                          color: AlagagiColors.sageDeep,
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            controller.placeForTripItem(item)!.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: sans(size: 12, weight: FontWeight.w700),
                          ),
                        ),
                      ],
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
                  if (onAssign != null) ...[
                    const SizedBox(height: 8),
                    _AssigneeRow(
                      item: item,
                      controller: controller,
                      onAssign: onAssign!,
                    ),
                  ],
                ],
              ),
            ),
          ),
          SizedBox(
            width: 44,
            height: 44,
            child: IconButton(
              onPressed: onEdit,
              icon: const Icon(
                Icons.edit_outlined,
                size: 17,
                color: AlagagiColors.muted,
              ),
            ),
          ),
          if (mine)
            SizedBox(
              width: 44,
              height: 44,
              child: IconButton(
                onPressed: onDelete,
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  size: 18,
                  color: AlagagiColors.muted,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
