import 'package:flutter/material.dart';

import '../../app/app_shell.dart';
import '../../app/test_keys.dart';
import '../../data/trip_photo_picker.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/readable_detail_sheet.dart';
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
  String? _photoNotice;
  String? _packingNotice;
  String? _photoDayFilter;
  bool _photoBusy = false;
  bool _photoNewestFirst = true;
  String _tripQuery = '';

  /// 날짜별 자리표. 날짜 이동 pill과 '오늘' 자동 스크롤이 같이 쓴다.
  final Map<String, GlobalKey> _dayAnchors = {};

  late final TripPhotoPicker _photoPicker;

  @override
  void initState() {
    super.initState();
    _photoPicker = createDefaultTripPhotoPicker();
    // 홈 카드에서 여행을 지목해 들어오면 목록을 거치지 않고 그 여행을 편다.
    final pendingTripId = widget.controller.consumePendingTripId();
    if (pendingTripId != null) {
      final trip = widget.controller.tripById(pendingTripId);
      if (trip != null) {
        _openTripId = trip.id;
        widget.controller.ensureTripPhotosLoaded(trip.id);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _scrollToTodayIfOngoing(trip);
          }
        });
      }
    }
  }

  /// 여행 하나를 연다. 사진은 이때 그 여행 것만 읽는다.
  void _openTrip(Trip trip) {
    setState(() {
      _openTripId = trip.id;
      _tab = TripDetailTab.timeline;
      _photoDayFilter = null;
      _packingNotice = null;
      _photoNotice = null;
      _dayAnchors.clear();
    });
    widget.controller.ensureTripPhotosLoaded(trip.id);
    _scrollToTodayIfOngoing(trip);
  }

  /// 새 여행을 만들면 목록으로 돌아가지 않고 그 여행 안으로 들어간다.
  /// 방금 만든 여행에 일정을 적는 것이 다음에 할 일이기 때문이다.
  Future<void> _openTripForm({Trip? trip}) async {
    final savedTripId = await showTripFormSheet(
      context,
      controller: widget.controller,
      trip: trip,
    );
    if (!mounted || trip != null || savedTripId == null) {
      return;
    }
    final saved = widget.controller.tripById(savedTripId);
    if (saved != null) {
      _openTrip(saved);
    }
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
  Future<void> _copyPacking(Trip trip) async {
    final sourceTripId = await showTripPackingSourceSheet(
      context,
      controller: widget.controller,
      tripId: trip.id,
    );
    if (sourceTripId == null || !mounted) {
      return;
    }
    final copied = widget.controller.copyTripPacking(
      fromTripId: sourceTripId,
      toTripId: trip.id,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _tab = TripDetailTab.packing;
      _packingNotice = copied == 0
          ? '이미 다 담겨 있어요.'
          : '$copied개 가져왔어요.';
    });
  }

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

  /// 여행 사진은 한 번에 여러 장 담는다. 한 장이 실패해도 나머지는 담고,
  /// 무엇이 안 됐는지만 남긴다.
  Future<void> _pickPhoto(Trip trip) async {
    if (_photoBusy) {
      return;
    }
    setState(() {
      _photoBusy = true;
      _photoError = null;
      _photoNotice = null;
    });
    String? error;
    String? notice;
    try {
      final picked = await _photoPicker.pickImages();
      var saved = 0;
      for (final photo in picked) {
        final result = widget.controller.saveTripPhoto(
          tripId: trip.id,
          // 사진을 붙일 날짜가 눈앞에 걸려 있으면 그 날 것으로 본다.
          dateKey: _photoDayFilter,
          imageDataUrl: photo.dataUrl,
        );
        if (result == null) {
          saved += 1;
        } else {
          error ??= result;
        }
      }
      if (saved > 1) {
        notice = '$saved장 담았어요.';
      }
    } finally {
      if (mounted) {
        setState(() {
          _photoBusy = false;
          _photoError = error;
          _photoNotice = notice;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final openTrip = _openTripId == null
        ? null
        : widget.controller.tripById(_openTripId!);

    final showDayRail =
        openTrip != null &&
        _tab == TripDetailTab.timeline &&
        openTrip.dateKeys.length >= 3;

    return AlagagiScreenScroll(
      key: tripsScreenKey,
      bottomNavigation: AlagagiBottomNav(controller: widget.controller),
      // 여행 상세는 아래로 길다. tab과 날짜 이동은 늘 손 닿는 곳에 둔다.
      pinnedHeader: openTrip == null
          ? null
          : _TripPinnedBar(
              tab: _tab,
              photoCount: widget.controller.tripPhotoCount(openTrip.id),
              onSelected: (tab) => setState(() {
                _tab = tab;
                _photoError = null;
                _photoNotice = null;
                _packingNotice = null;
              }),
              dateKeys: showDayRail ? openTrip.dateKeys : const [],
              todayDateKey: widget.controller.todayDateKey,
              onSelectDay: _scrollToDay,
            ),
      pinnedHeaderHeight: openTrip == null
          ? null
          : showDayRail
          ? 104
          : 64,
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
        _TripSaveStatus(controller: widget.controller),
        if (openTrip == null)
          ..._buildTripList()
        else
          ..._buildTripDetail(openTrip),
      ],
    );
  }

  List<Widget> _buildTripList() {
    final query = _tripQuery.trim().toLowerCase();
    bool matches(Trip trip) =>
        query.isEmpty ||
        trip.title.toLowerCase().contains(query) ||
        trip.destination.toLowerCase().contains(query);
    final planning = widget.controller
        .tripsWithStatus(TripStatus.planning)
        .where(matches)
        .toList();
    final done = widget.controller
        .tripsWithStatus(TripStatus.done)
        .where(matches)
        .toList();
    final totalTrips = widget.controller.trips.length;

    return [
      Text(
        '같이 갈 여행을 하나씩 정리해요',
        style: sans(size: 12.5, color: AlagagiColors.muted),
      ),
      const SizedBox(height: 14),
      _AddTripBanner(onTap: () => _openTripForm()),
      // 여행이 쌓이면 목록만으로는 찾기 어렵다.
      if (totalTrips >= 5) ...[
        const SizedBox(height: 12),
        _TripSearchField(
          value: _tripQuery,
          onChanged: (value) => setState(() => _tripQuery = value),
        ),
      ],
      const SizedBox(height: 18),
      if (planning.isEmpty && done.isEmpty)
        AlagagiEmptyStateCard(
          text: query.isEmpty
              ? '아직 계획한 여행이 없어요. 가고 싶은 곳이 생기면 하나 만들어봐요.'
              : '\'$_tripQuery\'와 맞는 여행이 없어요.',
        ),
      if (planning.isNotEmpty) ...[
        const AlagagiSectionLabel('계획 중'),
        const SizedBox(height: 10),
        for (final trip in planning) ...[
          _TripCard(
            trip: trip,
            controller: widget.controller,
            onOpen: () => _openTrip(trip),
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
            onOpen: () => _openTrip(trip),
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
      if (trip.note.trim().isNotEmpty) ...[
        const SizedBox(height: 10),
        _TripNoteCard(title: trip.title, note: trip.note.trim()),
      ],
      if (widget.controller.tripTotalCost(trip.id) > 0) ...[
        const SizedBox(height: 10),
        _TripBudgetCard(trip: trip, controller: widget.controller),
      ],
      if (widget.controller.tripNeedsStatusNudge(trip)) ...[
        const SizedBox(height: 12),
        _TripStatusNudge(
          onConfirm: () => widget.controller.setTripStatus(
            trip.id,
            TripStatus.done,
          ),
        ),
      ],
      const SizedBox(height: 10),
      const AlagagiPinnedScrollHeader(),
      const SizedBox(height: 4),
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

  GlobalKey _anchorFor(String dateKey) =>
      _dayAnchors.putIfAbsent(dateKey, GlobalKey.new);

  /// 여행 중이면 1일차부터 훑지 않도록 오늘 자리에서 열어준다.
  void _scrollToTodayIfOngoing(Trip trip) {
    if (widget.controller.tripTimingFor(trip).phase != TripPhase.ongoing) {
      return;
    }
    _scrollToDay(widget.controller.todayDateKey);
  }

  void _scrollToDay(String dateKey) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final anchorContext = _dayAnchors[dateKey]?.currentContext;
      if (anchorContext == null) {
        return;
      }
      Scrollable.ensureVisible(
        anchorContext,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        // 고정된 tab 줄 아래로 날짜 머리가 딱 걸리게 둔다.
        alignment: 0.14,
      );
    });
  }

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
        anchorKeyFor: (day) =>
            day.isUndated ? null : _anchorFor(day.dateKey),
        onTapItem: (item) => _editItem(trip, item),
        onTapPhoto: (photo) => showTripPhotoViewer(
          context,
          controller: widget.controller,
          tripId: trip.id,
          initialPhotoId: photo.id,
          visiblePhotoIds: photo.dateKey == null
              ? null
              : [
                  for (final item in widget.controller.tripPhotosForDate(
                    trip.id,
                    photo.dateKey!,
                  ))
                    item.id,
                ],
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
    // 여러 숙소를 옮겨 다니면 체크인 날짜로 묶어야 흐름이 읽힌다.
    final days = widget.controller.tripDaysForKind(trip.id, TripItemKind.stay);
    final stays = widget.controller.tripItemsFor(
      trip.id,
      kind: TripItemKind.stay,
    );

    return [
      if (stays.isEmpty)
        AlagagiEmptyStateCard(text: TripItemKind.stay.emptyText)
      else ...[
        for (final day in days) ...[
          Padding(
            key: tripStayDayGroupKey(day.isUndated ? 'undated' : day.dateKey),
            padding: const EdgeInsets.only(bottom: 9),
            child: Row(
              children: [
                Text(
                  day.isUndated ? '날짜 미정' : day.dayLabel,
                  style: sans(
                    size: 11,
                    weight: FontWeight.w800,
                    color: AlagagiColors.sageDeep,
                    letterSpacing: 1.1,
                  ),
                ),
                if (!day.isUndated) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      day.dateLabel,
                      style: sans(size: 12, color: AlagagiColors.muted),
                    ),
                  ),
                ],
              ],
            ),
          ),
          for (final stay in day.items) ...[
            _TripItemCard(
              item: stay,
              controller: widget.controller,
              onEdit: () => _editItem(trip, stay),
              onDelete: () => _confirmItemDelete(stay),
            ),
            const SizedBox(height: 9),
          ],
          const SizedBox(height: 6),
        ],
      ],
    ];
  }

  List<Widget> _buildPackingTab(Trip trip) {
    final items = widget.controller.tripItemsFor(
      trip.id,
      kind: TripItemKind.packing,
    );
    final checked = widget.controller.tripPackingCheckedCount(trip.id);
    final hasSource = widget.controller
        .tripsWithPackingExcept(trip.id)
        .isNotEmpty;

    return [
      if (items.isNotEmpty) ...[
        Text(
          '챙긴 것 $checked / ${items.length}',
          style: sans(size: 12, color: AlagagiColors.muted),
        ),
        const SizedBox(height: 12),
      ],
      if (hasSource) ...[
        SizedBox(
          height: 44,
          child: OutlinedButton.icon(
            key: tripPackingCopyButtonKey,
            onPressed: () => _copyPacking(trip),
            icon: const Icon(Icons.content_copy_outlined, size: 16),
            label: const Text('지난 여행에서 가져오기'),
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
        const SizedBox(height: 12),
      ],
      if (_packingNotice != null) ...[
        Text(
          _packingNotice!,
          key: tripPackingNoticeKey,
          style: sans(
            size: 12,
            weight: FontWeight.w700,
            color: AlagagiColors.sageDeep,
          ),
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
    final loaded = widget.controller.tripPhotosFor(trip.id);
    final photos = _photoNewestFirst
        ? loaded
        : (loaded.toList()
            ..sort((first, second) {
              // 날짜를 붙인 사진을 먼저, 그 안에서 이른 날짜부터 본다.
              final firstDate = first.dateKey;
              final secondDate = second.dateKey;
              if (firstDate == secondDate) {
                return 0;
              }
              if (firstDate == null) {
                return 1;
              }
              if (secondDate == null) {
                return -1;
              }
              return firstDate.compareTo(secondDate);
            }));
    final supported = _photoPicker.isSupported;
    final visible = _photoDayFilter == null
        ? photos
        : photos.where((photo) => photo.dateKey == _photoDayFilter).toList();

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
      if (_photoNotice != null) ...[
        const SizedBox(height: 8),
        Text(
          _photoNotice!,
          key: tripPhotoNoticeKey,
          style: sans(
            size: 12,
            weight: FontWeight.w700,
            color: AlagagiColors.sageDeep,
          ),
        ),
      ],
      if (photos.isNotEmpty) ...[
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: AlagagiFilterPill(
            key: tripPhotoSortButtonKey,
            label: _photoNewestFirst ? '최근 담은 순' : '여행 날짜 순',
            selected: !_photoNewestFirst,
            onTap: () =>
                setState(() => _photoNewestFirst = !_photoNewestFirst),
          ),
        ),
        const SizedBox(height: 12),
        _PhotoDayFilter(
          trip: trip,
          selected: _photoDayFilter,
          onSelected: (dateKey) => setState(() => _photoDayFilter = dateKey),
        ),
      ],
      const SizedBox(height: 12),
      if (widget.controller.tripPhotosLoading)
        const AlagagiEmptyStateCard(
          key: tripPhotoLoadingKey,
          text: '사진을 불러오는 중이에요.',
        )
      else if (widget.controller.tripPhotosFailed)
        _PhotoLoadFailed(
          onRetry: () =>
              widget.controller.ensureTripPhotosLoaded(trip.id, force: true),
        )
      else if (photos.isEmpty)
        const AlagagiEmptyStateCard(
          text: '아직 담은 사진이 없어요. 다녀와서 천천히 채워도 괜찮아요.',
        )
      else
        _TripPhotoMosaic(
          photos: visible,
          myProfileId: widget.controller.state.me.id,
          onTagDay: (photo) => _tagPhotoDay(trip, photo),
          onOpen: (photo) => showTripPhotoViewer(
            context,
            controller: widget.controller,
            tripId: trip.id,
            initialPhotoId: photo.id,
            // 걸러 보던 범위와 순서 그대로 넘긴다.
            visiblePhotoIds: [for (final item in visible) item.id],
          ),
        ),
    ];
  }
}

/// 사진을 못 읽었을 때. 빈 여행과 같은 화면을 보여주면 기록이 지워진 것처럼 읽힌다.
class _PhotoLoadFailed extends StatelessWidget {
  const _PhotoLoadFailed({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return AlagagiPaperCard(
      compact: true,
      child: Row(
        children: [
          Expanded(
            child: Text(
              '사진을 불러오지 못했어요.',
              style: sans(size: 12.5, height: 1.5),
            ),
          ),
          SizedBox(
            height: 44,
            child: TextButton(
              key: tripPhotoRetryButtonKey,
              onPressed: onRetry,
              style: TextButton.styleFrom(
                foregroundColor: AlagagiColors.sageDeep,
                textStyle: sans(size: 12.5, weight: FontWeight.w800),
              ),
              child: const Text('다시 불러오기'),
            ),
          ),
        ],
      ),
    );
  }
}

/// 여행 저장 결과를 알리는 줄.
///
/// 다른 기능은 모두 이런 채널을 갖고 있는데 여행만 없어서, write가 실패해도
/// 화면은 성공한 것처럼 보이고 다음 진입에 조용히 되돌아갔다.
class _TripSaveStatus extends StatelessWidget {
  const _TripSaveStatus({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
    final error = state.tripSaveError;
    final feedback = state.tripSaveFeedback;
    if (error == null && feedback == null) {
      return const SizedBox.shrink();
    }
    final failed = error != null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        key: tripSaveStatusKey,
        decoration: BoxDecoration(
          color: failed ? const Color(0x14B35A49) : AlagagiColors.skyPanel,
          border: Border.all(
            color: failed ? const Color(0x33B35A49) : AlagagiColors.line,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.fromLTRB(13, 10, 9, 10),
        child: Row(
          children: [
            Icon(
              failed ? Icons.error_outline_rounded : Icons.check_circle_outline,
              size: 16,
              color: failed
                  ? const Color(0xFFB35A49)
                  : AlagagiColors.sageDeep,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                failed ? error : feedback!,
                style: sans(
                  size: 12.3,
                  height: 1.5,
                  color: failed
                      ? const Color(0xFFB35A49)
                      : AlagagiColors.ink,
                ),
              ),
            ),
            SizedBox(
              height: 40,
              child: failed
                  ? TextButton(
                      key: tripSaveRetryButtonKey,
                      onPressed: controller.retryTripSaves,
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFFB35A49),
                        textStyle: sans(size: 12.5, weight: FontWeight.w800),
                      ),
                      child: const Text('다시 시도'),
                    )
                  : TextButton(
                      onPressed: controller.clearTripSaveFeedback,
                      style: TextButton.styleFrom(
                        foregroundColor: AlagagiColors.muted,
                        textStyle: sans(size: 12.5, weight: FontWeight.w700),
                      ),
                      child: const Text('확인'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 오늘 기준 위치를 강조하는 뱃지.
///
/// 밝은 종이 카드 위에 놓이므로 흰 글씨를 쓰면 보이지 않는다. accent 면에
/// 배경색 글씨를 얹어 대비를 확보한다.
class _TripPhaseBadge extends StatelessWidget {
  const _TripPhaseBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AlagagiColors.sageDeep,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      child: Text(
        label,
        style: sans(
          size: 10.5,
          weight: FontWeight.w800,
          color: AlagagiColors.appBackground,
        ),
      ),
    );
  }
}

/// 여행이 쌓였을 때 이름이나 목적지로 찾는다.
class _TripSearchField extends StatefulWidget {
  const _TripSearchField({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  State<_TripSearchField> createState() => _TripSearchFieldState();
}

class _TripSearchFieldState extends State<_TripSearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
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
        color: AlagagiColors.paper,
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: Row(
        children: [
          const Icon(
            Icons.search_rounded,
            size: 17,
            color: AlagagiColors.muted,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              key: tripListSearchFieldKey,
              controller: _controller,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                hintText: '여행 이름이나 목적지로 찾기',
                hintStyle: sans(size: 12.5, color: AlagagiColors.muted),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
              style: sans(size: 13),
            ),
          ),
        ],
      ),
    );
  }
}

/// 여행 전체에 남겨둔 메모.
class _TripNoteCard extends StatelessWidget {
  const _TripNoteCard({required this.title, required this.note});

  final String title;
  final String note;

  @override
  Widget build(BuildContext context) {
    // 준비 메모는 길어지기 쉽다. 카드에서 잘리면 읽을 길이 없어진다.
    final showsCue = showsReadableCue(note);

    return InkWell(
      key: tripNoteCardKey,
      onTap: showsCue
          ? () => showReadableDetailSheet(
              context,
              label: '여행 메모',
              title: title,
              body: note,
            )
          : null,
      borderRadius: BorderRadius.circular(AlagagiCardGeometry.compactRadius),
      child: AlagagiPaperCard(
        compact: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.sticky_note_2_outlined,
                  size: 16,
                  color: AlagagiColors.sageDeep,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    note,
                    maxLines: showsCue ? 3 : null,
                    overflow: showsCue ? TextOverflow.ellipsis : null,
                    style: sans(
                      size: 12.5,
                      height: 1.65,
                      color: AlagagiColors.ink,
                    ),
                  ),
                ),
              ],
            ),
            if (showsCue) ...[
              const SizedBox(height: 8),
              const Align(
                alignment: Alignment.centerRight,
                child: AlagagiFullTextCue(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 여행에 든 돈 요약. 낸 사람을 적은 것만 사람별로 나눈다.
class _TripBudgetCard extends StatelessWidget {
  const _TripBudgetCard({required this.trip, required this.controller});

  final Trip trip;
  final AlagagiController controller;

  static String _formatAmount(int amount) {
    final digits = amount.toString();
    final buffer = StringBuffer();
    for (var index = 0; index < digits.length; index += 1) {
      if (index > 0 && (digits.length - index) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(digits[index]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final total = controller.tripTotalCost(trip.id);
    final byPayer = controller.tripCostByPayer(trip.id);
    final unattributed = controller.tripUnattributedCost(trip.id);
    final settlement = controller.tripSettlement(trip.id);
    final me = controller.state.me;
    final partner = controller.state.partner;

    return AlagagiPaperCard(
      key: tripBudgetSummaryKey,
      compact: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.receipt_long_outlined,
                size: 16,
                color: AlagagiColors.sageDeep,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '든 돈',
                  style: sans(size: 12.5, weight: FontWeight.w800),
                ),
              ),
              Text(
                '${_formatAmount(total)}${trip.currencyLabel}',
                style: serif(context, size: 16, weight: FontWeight.w800),
              ),
            ],
          ),
          if (byPayer.isNotEmpty || unattributed > 0) ...[
            const SizedBox(height: 9),
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: [
                for (final profile in [me, partner])
                  if ((byPayer[profile.id] ?? 0) > 0)
                    Text(
                      '${profile.nickname} '
                      '${_formatAmount(byPayer[profile.id]!)}'
                      '${trip.currencyLabel}',
                      style: sans(size: 11.5, color: AlagagiColors.muted),
                    ),
                // 합계와 사람별 합이 안 맞아 보이는 이유를 남긴다.
                if (unattributed > 0)
                  Text(
                    key: tripBudgetUnattributedKey,
                    '아직 안 적음 '
                    '${_formatAmount(unattributed)}${trip.currencyLabel}',
                    style: sans(size: 11.5, color: AlagagiColors.muted),
                  ),
              ],
            ),
          ],
          if (settlement != null) ...[
            const SizedBox(height: 9),
            Container(
              key: tripBudgetSettlementKey,
              decoration: BoxDecoration(
                color: AlagagiColors.skyPanel,
                borderRadius: BorderRadius.circular(11),
              ),
              padding: const EdgeInsets.fromLTRB(11, 8, 11, 8),
              child: Text(
                // 정산을 재촉하지 않는다. 사실만 적는다.
                '${settlement.payerProfileId == me.id ? me.nickname : partner.nickname}'
                '이(가) ${_formatAmount(settlement.amount)}'
                '${trip.currencyLabel} 더 냈어요',
                style: sans(
                  size: 11.5,
                  weight: FontWeight.w700,
                  color: AlagagiColors.sageDeep,
                ),
              ),
            ),
          ],
        ],
      ),
    );
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
                    _TripPhaseBadge(label: timing.label),
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
/// 상세 화면 위에 붙어 있는 줄. tab과, 긴 여행이면 날짜 이동까지 함께 든다.
class _TripPinnedBar extends StatelessWidget {
  const _TripPinnedBar({
    required this.tab,
    required this.photoCount,
    required this.onSelected,
    required this.dateKeys,
    required this.todayDateKey,
    required this.onSelectDay,
  });

  final TripDetailTab tab;
  final int photoCount;
  final ValueChanged<TripDetailTab> onSelected;
  final List<String> dateKeys;
  final String todayDateKey;
  final ValueChanged<String> onSelectDay;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TripTabBar(
          selected: tab,
          photoCount: photoCount,
          onSelected: onSelected,
        ),
        if (dateKeys.isNotEmpty) ...[
          const SizedBox(height: 8),
          SizedBox(
            height: 32,
            child: ListView.separated(
              key: tripDayRailKey,
              scrollDirection: Axis.horizontal,
              itemCount: dateKeys.length,
              separatorBuilder: (_, _) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                final dateKey = dateKeys[index];
                return _TripDayJumpPill(
                  pillKey: tripDayJumpButtonKey(dateKey),
                  label: '${index + 1}일차',
                  isToday: dateKey == todayDateKey,
                  onTap: () => onSelectDay(dateKey),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _TripDayJumpPill extends StatelessWidget {
  const _TripDayJumpPill({
    required this.pillKey,
    required this.label,
    required this.isToday,
    required this.onTap,
  });

  final Key pillKey;
  final String label;
  final bool isToday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: pillKey,
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 13),
        decoration: BoxDecoration(
          color: isToday ? AlagagiColors.sageDeep : AlagagiColors.skyPanel,
          border: Border.all(
            color: isToday ? AlagagiColors.sageDeep : AlagagiColors.line,
          ),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Text(
          isToday ? '오늘' : label,
          style: sans(
            size: 11.5,
            weight: FontWeight.w700,
            color: isToday ? AlagagiColors.paper : AlagagiColors.muted,
          ),
        ),
      ),
    );
  }
}

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
              key: tripItemEditButtonKey(item.id),
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
