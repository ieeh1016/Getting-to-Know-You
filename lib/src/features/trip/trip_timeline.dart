import 'package:flutter/material.dart';

import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/openable_link.dart';
import '../../shared/readable_detail_sheet.dart';
import '../../shared/ui_components.dart';
import '../../shared/ui_style.dart';
import '../place/place_common.dart';

IconData tripItemKindIcon(TripItemKind kind) => switch (kind) {
  TripItemKind.stay => Icons.bed_outlined,
  TripItemKind.transport => Icons.swap_horiz_rounded,
  TripItemKind.packing => Icons.backpack_outlined,
  TripItemKind.plan => Icons.explore_outlined,
};

IconData tripTransportModeIcon(TripTransportMode mode) => switch (mode) {
  TripTransportMode.flight => Icons.flight_takeoff_rounded,
  TripTransportMode.train => Icons.train_outlined,
  TripTransportMode.bus => Icons.directions_bus_outlined,
  TripTransportMode.car => Icons.directions_car_outlined,
  TripTransportMode.ship => Icons.directions_boat_outlined,
  TripTransportMode.walk => Icons.directions_walk_rounded,
};

/// 여행 하루를 세로 rail로 이어 보여주는 타임라인.
///
/// 숙소는 하룻밤을 통째로 차지하므로 시각 흐름에 끼우지 않고 하루 머리의
/// 머무는 곳 띠로 보여준다. 준비물도 시간과 무관해 여기 오지 않는다.
class TripTimeline extends StatelessWidget {
  const TripTimeline({
    super.key,
    required this.days,
    required this.staysForNight,
    required this.staysCheckingOut,
    required this.placeFor,
    required this.photosForDate,
    required this.todayDateKey,
    required this.anchorKeyFor,
    required this.onTapItem,
    required this.onTapPhoto,
    required this.onAddForDay,
    required this.onOpenExternalLink,
    required this.nextItemId,
    required this.photosLoaded,
    required this.onLoadPhotos,
    required this.showDoneToggle,
    required this.onToggleDone,
  });

  final List<TripDay> days;
  final List<TripItem> Function(String dateKey) staysForNight;
  final List<TripItem> Function(String dateKey) staysCheckingOut;
  final SharedPlace? Function(TripItem item) placeFor;
  final List<TripPhoto> Function(String dateKey) photosForDate;
  final String todayDateKey;

  /// 날짜 이동 pill과 '오늘' 자동 스크롤이 잡을 자리.
  final GlobalKey? Function(TripDay day) anchorKeyFor;
  final ValueChanged<TripItem> onTapItem;
  final ValueChanged<TripPhoto> onTapPhoto;

  /// 그 날 자리에서 바로 담기. 날짜를 폼에서 다시 고르지 않게 한다.
  final void Function(String? dateKey) onAddForDay;

  /// 예약 링크와 지도를 밖으로 여는 통로.
  final ValueChanged<String> onOpenExternalLink;

  /// 여행 중일 때 지금 다음에 오는 항목. 없으면 null.
  final String? nextItemId;

  /// 사진을 아직 읽지 않았으면 날짜별 띠 대신 불러오기 한 줄만 둔다.
  /// 개수를 모르니 어느 날에 붙일지도 고를 수 없다.
  final bool photosLoaded;
  final VoidCallback onLoadPhotos;

  /// 다녀온 여행에서만 계획에 `했다` 표시를 보여준다. 계획 중 화면을
  /// 체크박스로 어지럽히지 않는다.
  final bool showDoneToggle;
  final ValueChanged<TripItem> onToggleDone;

  bool get _isEmpty =>
      days.every((day) => day.items.isEmpty) &&
      days.every((day) => day.isUndated || staysForNight(day.dateKey).isEmpty);

  @override
  Widget build(BuildContext context) {
    if (_isEmpty) {
      return const AlagagiEmptyStateCard(
        text: '아직 정한 일정이 없어요. 숙소나 이동부터 하나씩 담아봐요.',
      );
    }

    return Column(
      key: tripTimelineKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < days.length; index += 1)
          _TripTimelineDay(
            day: days[index],
            isLast: index == days.length - 1,
            stays: days[index].isUndated
                ? const []
                : staysForNight(days[index].dateKey),
            checkOuts: days[index].isUndated
                ? const []
                : staysCheckingOut(days[index].dateKey),
            placeFor: placeFor,
            photos: days[index].isUndated
                ? const []
                : photosForDate(days[index].dateKey),
            isToday:
                !days[index].isUndated && days[index].dateKey == todayDateKey,
            anchorKey: anchorKeyFor(days[index]),
            onTapItem: onTapItem,
            onTapPhoto: onTapPhoto,
            onAddForDay: onAddForDay,
            onOpenExternalLink: onOpenExternalLink,
            nextItemId: nextItemId,
            showDoneToggle: showDoneToggle,
            onToggleDone: onToggleDone,
          ),
        if (!photosLoaded)
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 4),
            child: InkWell(
              key: tripTimelineLoadPhotosKey,
              onTap: onLoadPhotos,
              borderRadius: BorderRadius.circular(999),
              child: Container(
                constraints: const BoxConstraints(minHeight: 40),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.photo_outlined,
                      size: 14,
                      color: AlagagiColors.sageDeep,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '이 여행 사진 불러오기',
                      style: sans(
                        size: 11.5,
                        weight: FontWeight.w800,
                        color: AlagagiColors.sageDeep,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _TripTimelineDay extends StatelessWidget {
  const _TripTimelineDay({
    required this.day,
    required this.isLast,
    required this.stays,
    required this.checkOuts,
    required this.placeFor,
    required this.photos,
    required this.isToday,
    required this.anchorKey,
    required this.onTapItem,
    required this.onTapPhoto,
    required this.onAddForDay,
    required this.onOpenExternalLink,
    required this.nextItemId,
    required this.showDoneToggle,
    required this.onToggleDone,
  });

  final TripDay day;
  final bool isLast;
  final List<TripItem> stays;
  final List<TripItem> checkOuts;
  final SharedPlace? Function(TripItem item) placeFor;
  final List<TripPhoto> photos;
  final bool isToday;
  final GlobalKey? anchorKey;
  final ValueChanged<TripItem> onTapItem;
  final ValueChanged<TripPhoto> onTapPhoto;
  final void Function(String? dateKey) onAddForDay;
  final ValueChanged<String> onOpenExternalLink;
  final String? nextItemId;
  final bool showDoneToggle;
  final ValueChanged<TripItem> onToggleDone;

  @override
  Widget build(BuildContext context) {
    final isBlank =
        day.items.isEmpty &&
        stays.isEmpty &&
        checkOuts.isEmpty &&
        photos.isEmpty;

    return Column(
      key: tripTimelineDayKey(day.isUndated ? 'undated' : day.dateKey),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TripDayHeader(
          key: anchorKey,
          day: day,
          entryCount: day.items.length,
          isToday: isToday,
        ),
        const SizedBox(height: 9),
        for (final stay in checkOuts)
          _TripStayBand(
            dateKey: day.dateKey,
            stay: stay,
            mode: _StayBandMode.checkOut,
            place: placeFor(stay),
            onTap: () => onTapItem(stay),
            onOpenExternalLink: onOpenExternalLink,
          ),
        for (final stay in stays)
          _TripStayBand(
            dateKey: day.dateKey,
            stay: stay,
            mode: stay.dateKey == day.dateKey
                ? _StayBandMode.checkIn
                : _StayBandMode.staying,
            place: placeFor(stay),
            onTap: () => onTapItem(stay),
            onOpenExternalLink: onOpenExternalLink,
          ),
        // 순서는 시각이 정한다. 끌어서 바꾸는 길은 두지 않는다.
        for (final item in day.items)
          _TripTimelineEntry(
            key: ValueKey(item.id),
            item: item,
            place: placeFor(item),
            // 아래에 담기 줄이 늘 붙으므로 여기서 rail을 끊으면 담기 줄이
            // 세로선 밖에 떠 보인다. 종단은 담기 줄이 그린다.
            isLastInDay: false,
            onTap: () => onTapItem(item),
            onOpenExternalLink: onOpenExternalLink,
            isNext: item.id == nextItemId,
            showDoneToggle: showDoneToggle,
            onToggleDone: onToggleDone,
          ),
        if (photos.isNotEmpty) ...[
          _TripDayPhotoStrip(photos: photos, onTapPhoto: onTapPhoto),
          const SizedBox(height: 6),
        ],
        // 그 날 끝에서 바로 담는다. 3일차 일정 하나 적으려고 맨 위로
        // 올라갔다가 폼에서 날짜를 다시 고르게 하지 않는다.
        _TripDayAddRow(
          rowKey: tripDayAddKey(day.isUndated ? 'undated' : day.dateKey),
          isBlank: isBlank,
          drawsRail: !isLast,
          onTap: () => onAddForDay(day.isUndated ? null : day.dateKey),
        ),
        if (!isLast) const SizedBox(height: 8),
      ],
    );
  }
}

/// 하루 끝에 붙는 담기 줄. 비어 있는 날에는 비어 있다는 사실도 함께 읽힌다.
class _TripDayAddRow extends StatelessWidget {
  const _TripDayAddRow({
    required this.rowKey,
    required this.isBlank,
    required this.drawsRail,
    required this.onTap,
  });

  final Key rowKey;
  final bool isBlank;

  /// 마지막 날이 아니면 세로 rail 선이 다음 날로 이어져야 한다.
  final bool drawsRail;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 30,
            child: Center(
              child: Container(
                width: 1,
                color: drawsRail ? AlagagiColors.line : Colors.transparent,
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              key: rowKey,
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                constraints: const BoxConstraints(minHeight: 44),
                padding: const EdgeInsets.fromLTRB(4, 6, 8, 10),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const Icon(
                      Icons.add_rounded,
                      size: 15,
                      color: AlagagiColors.muted,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        isBlank ? '이날은 아직 비어 있어요 · 담기' : '이 날에 담기',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: sans(size: 12, color: AlagagiColors.muted),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _StayBandMode { checkIn, staying, checkOut }

/// 그날 머무는 곳을 하루 머리에 얇은 띠로 보여준다.
///
/// 숙소를 시각 항목으로 끼우면 "저녁 식사" 사이에 "호텔"이 껴 있는 것처럼
/// 읽혀 어색하다. 하룻밤을 감싸는 배경에 가깝게 다룬다.
class _TripStayBand extends StatelessWidget {
  const _TripStayBand({
    required this.dateKey,
    required this.stay,
    required this.mode,
    required this.place,
    required this.onTap,
    required this.onOpenExternalLink,
  });

  final String dateKey;
  final TripItem stay;
  final _StayBandMode mode;

  /// 붙여둔 장소. 공항이나 택시에서 실제로 보는 화면이 여기다.
  final SharedPlace? place;
  final VoidCallback onTap;
  final ValueChanged<String> onOpenExternalLink;

  String get _leadLabel => switch (mode) {
    _StayBandMode.checkIn => '체크인',
    _StayBandMode.staying => '머무는 곳',
    _StayBandMode.checkOut => '체크아웃',
  };

  String get _modeKey => switch (mode) {
    _StayBandMode.checkIn => 'checkin',
    _StayBandMode.staying => 'staying',
    _StayBandMode.checkOut => 'checkout',
  };

  String? get _timeLabel => switch (mode) {
    _StayBandMode.checkIn => stay.timeLabel,
    _StayBandMode.staying => null,
    _StayBandMode.checkOut => stay.endTimeLabel,
  };

  @override
  Widget build(BuildContext context) {
    final nights = stay.stayNightCount;
    final time = _timeLabel;

    return Padding(
      padding: const EdgeInsets.only(left: 30, bottom: 8),
      child: InkWell(
        key: tripStayBandKey('$dateKey-${stay.id}-$_modeKey'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          decoration: BoxDecoration(
            color: AlagagiColors.skyPanel,
            border: Border.all(color: AlagagiColors.line),
            borderRadius: BorderRadius.circular(13),
          ),
          padding: const EdgeInsets.fromLTRB(11, 9, 11, 9),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.bed_outlined,
                    size: 15,
                    color: AlagagiColors.sageDeep,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _leadLabel,
                    style: sans(
                      size: 10.8,
                      weight: FontWeight.w800,
                      color: AlagagiColors.sageDeep,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      stay.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: sans(size: 12.5, weight: FontWeight.w700),
                    ),
                  ),
                  if (time != null) ...[
                    const SizedBox(width: 6),
                    Text(
                      time,
                      style: sans(
                        size: 11.5,
                        weight: FontWeight.w800,
                        color: AlagagiColors.sageDeep,
                      ),
                    ),
                  ] else if (nights > 0 && mode == _StayBandMode.staying) ...[
                    const SizedBox(width: 6),
                    Text(
                      '$nights박',
                      style: sans(size: 11, color: AlagagiColors.muted),
                    ),
                  ],
                ],
              ),
              // 주소를 같은 줄에 끼우면 390px에서 제목이 밀린다. 아래 줄로 푼다.
              if (place != null) ...[
                const SizedBox(height: 7),
                if (place!.address.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 23, bottom: 6),
                    child: Text(
                      place!.address,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: sans(
                        size: 12,
                        height: 1.45,
                        color: AlagagiColors.ink,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(left: 21),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      height: 32,
                      child: OutlinedButton.icon(
                        key: tripStayMapButtonKey(stay.id),
                        onPressed: () =>
                            onOpenExternalLink(place!.googleMapsUrl),
                        icon: const Icon(Icons.map_outlined, size: 13),
                        label: const Text('지도'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AlagagiColors.sageDeep,
                          side: const BorderSide(color: Color(0x339A7A2A)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 11),
                          textStyle: sans(size: 11, weight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TripDayHeader extends StatelessWidget {
  const _TripDayHeader({
    super.key,
    required this.day,
    required this.entryCount,
    required this.isToday,
  });

  final TripDay day;
  final int entryCount;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: day.isUndated ? AlagagiColors.paper : AlagagiColors.sageDeep,
            border: Border.all(
              color: day.isUndated
                  ? AlagagiColors.line
                  : AlagagiColors.sageDeep,
            ),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            day.isUndated ? '·' : '${day.dayNumber}',
            style: sans(
              size: 12,
              weight: FontWeight.w800,
              color: day.isUndated
                  ? AlagagiColors.muted
                  : AlagagiColors.appBackground,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                  if (isToday) ...[
                    const SizedBox(width: 6),
                    Container(
                      key: tripTodayMarkerKey(day.dateKey),
                      decoration: BoxDecoration(
                        color: AlagagiColors.sageDeep,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      child: Text(
                        '오늘',
                        style: sans(
                          size: 9.5,
                          weight: FontWeight.w800,
                          color: AlagagiColors.appBackground,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                day.dateLabel,
                style: serif(context, size: 15.5, weight: FontWeight.w800),
              ),
            ],
          ),
        ),
        if (entryCount > 0)
          Text(
            '$entryCount개',
            style: sans(size: 11.5, color: AlagagiColors.muted),
          ),
      ],
    );
  }
}

class _TripTimelineEntry extends StatelessWidget {
  const _TripTimelineEntry({
    super.key,
    required this.item,
    required this.place,
    required this.isLastInDay,
    required this.onTap,
    required this.onOpenExternalLink,
    required this.isNext,
    required this.showDoneToggle,
    required this.onToggleDone,
  });

  final TripItem item;
  final SharedPlace? place;
  final bool isLastInDay;
  final VoidCallback onTap;
  final ValueChanged<String> onOpenExternalLink;

  /// 여행 중일 때 지금 다음에 오는 항목인가.
  final bool isNext;
  final bool showDoneToggle;
  final ValueChanged<TripItem> onToggleDone;

  bool get _showsDone => showDoneToggle && item.kind.usesDoneToggle;

  /// 열 수 없는 값이면 죽은 button을 만들지 않는다.
  String? get _openableLink => normalizedOpenableLink(item.link ?? '');

  @override
  Widget build(BuildContext context) {
    final mode = item.transportMode;
    final icon = mode == null
        ? tripItemKindIcon(item.kind)
        : tripTransportModeIcon(mode);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 세로 rail: 시간 흐름이 이어진다는 것만 조용히 보여준다.
          SizedBox(
            width: 30,
            child: Column(
              children: [
                Container(
                  key: isNext ? tripNextItemDotKey(item.id) : null,
                  width: 9,
                  height: 9,
                  margin: const EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                    // 지금 다음에 오는 것만 점을 채운다.
                    color: isNext
                        ? AlagagiColors.sageDeep
                        : AlagagiColors.paper,
                    border: Border.all(
                      color: isNext
                          ? AlagagiColors.sageDeep
                          : AlagagiColors.sky,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                if (!isLastInDay)
                  Expanded(
                    child: Container(width: 1.5, color: AlagagiColors.line),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: InkWell(
                key: tripTimelineEntryKey(item.id),
                onTap: onTap,
                borderRadius: BorderRadius.circular(
                  AlagagiCardGeometry.compactRadius,
                ),
                child: AlagagiPaperCard(
                  compact: true,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 다녀온 여행에서만 계획에 '했다'를 표시한다.
                      if (_showsDone)
                        SizedBox(
                          width: 44,
                          height: 44,
                          child: InkWell(
                            key: tripItemCheckButtonKey(item.id),
                            onTap: () => onToggleDone(item),
                            borderRadius: BorderRadius.circular(999),
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
                        )
                      else ...[
                        AlagagiSymbolMark(
                          icon: icon,
                          size: 30,
                          iconSize: 15,
                          tone: AlagagiColors.skyPanel,
                          iconColor: AlagagiColors.sageDeep,
                          radius: 11,
                        ),
                        const SizedBox(width: 10),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _TripEntryMeta(item: item),
                            const SizedBox(height: 5),
                            Text(
                              item.title,
                              style: sans(
                                size: 13.5,
                                weight: FontWeight.w700,
                                color: _showsDone && item.checked
                                    ? AlagagiColors.muted
                                    : AlagagiColors.ink,
                              ),
                            ),
                            if (item.kind.usesRoute) _TripRouteLine(item: item),
                            if (place != null) _TripPlaceLine(place: place!),
                            if (item.note.isNotEmpty) ...[
                              const SizedBox(height: 5),
                              Text(
                                item.note,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: sans(
                                  size: 12.3,
                                  height: 1.55,
                                  color: AlagagiColors.muted,
                                ),
                              ),
                              // 두 줄에서 잘린 메모는 잘린 줄 모르고 지나친다.
                              if (showsReadableCue(item.note)) ...[
                                const SizedBox(height: 6),
                                InkWell(
                                  key: tripItemNoteCueKey(item.id),
                                  onTap: () => showReadableDetailSheet(
                                    context,
                                    label: item.kind.label,
                                    title: item.title,
                                    body: item.note,
                                  ),
                                  borderRadius: BorderRadius.circular(999),
                                  child: const Align(
                                    alignment: Alignment.centerLeft,
                                    child: AlagagiFullTextCue(),
                                  ),
                                ),
                              ],
                            ],
                            if (_openableLink != null) ...[
                              const SizedBox(height: 6),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: SizedBox(
                                  height: 32,
                                  child: OutlinedButton.icon(
                                    key: tripItemLinkButtonKey(item.id),
                                    onPressed: () =>
                                        onOpenExternalLink(_openableLink!),
                                    icon: const Icon(
                                      Icons.open_in_new_rounded,
                                      size: 13,
                                    ),
                                    label: const Text('예약 열기'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AlagagiColors.sageDeep,
                                      side: const BorderSide(
                                        color: Color(0x339A7A2A),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 11,
                                      ),
                                      textStyle: sans(
                                        size: 11,
                                        weight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 시각과 종류를 한 줄로. 이동은 `08:20 → 09:35`처럼 구간으로 보여준다.
class _TripEntryMeta extends StatelessWidget {
  const _TripEntryMeta({required this.item});

  final TripItem item;

  @override
  Widget build(BuildContext context) {
    final start = item.timeLabel;
    final end = item.endTimeLabel;
    final timeText = start == null
        ? '시간 미정'
        : end == null
        ? start
        : '$start → $end';
    final kindText = item.transportMode?.label ?? item.kind.label;

    return Row(
      children: [
        Text(
          timeText,
          style: sans(
            size: 11.5,
            weight: FontWeight.w800,
            color: start == null ? AlagagiColors.muted : AlagagiColors.sageDeep,
          ),
        ),
        const SizedBox(width: 7),
        // 끌기 손잡이가 자리를 가져가 좁아져도 넘치지 않게 한다.
        Flexible(
          child: Text(
            kindText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: sans(size: 11, color: AlagagiColors.muted),
          ),
        ),
      ],
    );
  }
}

/// 출발지와 도착지를 화살표로 잇는 한 줄.
class _TripRouteLine extends StatelessWidget {
  const _TripRouteLine({required this.item});

  final TripItem item;

  @override
  Widget build(BuildContext context) {
    final from = item.fromLabel;
    final to = item.toLabel;
    if (from == null && to == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        children: [
          Flexible(
            child: Text(
              from ?? '출발지 미정',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: sans(
                size: 12,
                weight: FontWeight.w700,
                color: from == null ? AlagagiColors.muted : AlagagiColors.ink,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Icon(
              Icons.arrow_right_alt_rounded,
              size: 16,
              color: AlagagiColors.sageDeep,
            ),
          ),
          Flexible(
            child: Text(
              to ?? '도착지 미정',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: sans(
                size: 12,
                weight: FontWeight.w700,
                color: to == null ? AlagagiColors.muted : AlagagiColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 일정에 붙은 장소 한 줄. 분류 icon과 이름, 주소를 보여준다.
class _TripPlaceLine extends StatelessWidget {
  const _TripPlaceLine({required this.place});

  final SharedPlace place;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                placeCategoryIcon(place.category),
                size: 14,
                color: AlagagiColors.sageDeep,
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  place.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: sans(size: 12, weight: FontWeight.w700),
                ),
              ),
            ],
          ),
          // 이름과 주소가 한 줄에서 폭을 나눠 가지면 둘 다 잘린다.
          if (place.address.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2, left: 19),
              child: Text(
                place.address,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: sans(
                  size: 11.5,
                  height: 1.4,
                  color: AlagagiColors.muted,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 그날 담은 사진을 하루 끝에 가로로 이어 보여준다.
class _TripDayPhotoStrip extends StatelessWidget {
  const _TripDayPhotoStrip({required this.photos, required this.onTapPhoto});

  final List<TripPhoto> photos;
  final ValueChanged<TripPhoto> onTapPhoto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40, bottom: 4),
      child: SizedBox(
        height: 72,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: photos.length,
          separatorBuilder: (_, _) => const SizedBox(width: 7),
          itemBuilder: (context, index) {
            final photo = photos[index];
            return InkWell(
              key: tripTimelinePhotoKey(photo.id),
              onTap: () => onTapPhoto(photo),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 72,
                decoration: BoxDecoration(
                  border: Border.all(color: AlagagiColors.line),
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  photo.imageDataUrl,
                  fit: BoxFit.cover,
                  // 72dp 띠에 원본 해상도를 디코딩할 이유가 없다.
                  cacheWidth: 200,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AlagagiColors.skyPanel,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      size: 16,
                      color: AlagagiColors.muted,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
