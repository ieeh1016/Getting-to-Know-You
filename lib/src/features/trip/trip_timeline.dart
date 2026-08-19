import 'package:flutter/material.dart';

import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
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
    required this.onTapItem,
  });

  final List<TripDay> days;
  final List<TripItem> Function(String dateKey) staysForNight;
  final List<TripItem> Function(String dateKey) staysCheckingOut;
  final SharedPlace? Function(TripItem item) placeFor;
  final ValueChanged<TripItem> onTapItem;

  bool get _isEmpty =>
      days.every((day) => day.items.isEmpty) &&
      days.every(
        (day) => day.isUndated || staysForNight(day.dateKey).isEmpty,
      );

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
            onTapItem: onTapItem,
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
    required this.onTapItem,
  });

  final TripDay day;
  final bool isLast;
  final List<TripItem> stays;
  final List<TripItem> checkOuts;
  final SharedPlace? Function(TripItem item) placeFor;
  final ValueChanged<TripItem> onTapItem;

  @override
  Widget build(BuildContext context) {
    final isBlank = day.items.isEmpty && stays.isEmpty && checkOuts.isEmpty;

    return Column(
      key: tripTimelineDayKey(day.isUndated ? 'undated' : day.dateKey),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TripDayHeader(day: day, entryCount: day.items.length),
        const SizedBox(height: 9),
        for (final stay in checkOuts)
          _TripStayBand(
            dateKey: day.dateKey,
            stay: stay,
            mode: _StayBandMode.checkOut,
            onTap: () => onTapItem(stay),
          ),
        for (final stay in stays)
          _TripStayBand(
            dateKey: day.dateKey,
            stay: stay,
            mode: stay.dateKey == day.dateKey
                ? _StayBandMode.checkIn
                : _StayBandMode.staying,
            onTap: () => onTapItem(stay),
          ),
        if (isBlank)
          Padding(
            padding: const EdgeInsets.only(left: 34, bottom: 16),
            child: Text(
              '이날은 아직 비어 있어요',
              style: sans(size: 12, color: AlagagiColors.muted),
            ),
          )
        else
          for (var index = 0; index < day.items.length; index += 1)
            _TripTimelineEntry(
              item: day.items[index],
              place: placeFor(day.items[index]),
              isLastInDay: index == day.items.length - 1 && isLast,
              onTap: () => onTapItem(day.items[index]),
            ),
        if (!isLast) const SizedBox(height: 8),
      ],
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
    required this.onTap,
  });

  final String dateKey;
  final TripItem stay;
  final _StayBandMode mode;
  final VoidCallback onTap;

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
          child: Row(
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
        ),
      ),
    );
  }
}

class _TripDayHeader extends StatelessWidget {
  const _TripDayHeader({required this.day, required this.entryCount});

  final TripDay day;
  final int entryCount;

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
              Text(
                day.dayLabel,
                style: sans(
                  size: 11,
                  weight: FontWeight.w800,
                  color: AlagagiColors.sageDeep,
                  letterSpacing: 1.1,
                ),
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
    required this.item,
    required this.place,
    required this.isLastInDay,
    required this.onTap,
  });

  final TripItem item;
  final SharedPlace? place;
  final bool isLastInDay;
  final VoidCallback onTap;

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
                  width: 9,
                  height: 9,
                  margin: const EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                    color: AlagagiColors.paper,
                    border: Border.all(color: AlagagiColors.sky, width: 2),
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
                      AlagagiSymbolMark(
                        icon: icon,
                        size: 30,
                        iconSize: 15,
                        tone: AlagagiColors.skyPanel,
                        iconColor: AlagagiColors.sageDeep,
                        radius: 11,
                      ),
                      const SizedBox(width: 10),
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
            color: start == null
                ? AlagagiColors.muted
                : AlagagiColors.sageDeep,
          ),
        ),
        const SizedBox(width: 7),
        Text(kindText, style: sans(size: 11, color: AlagagiColors.muted)),
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
      child: Row(
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
          if (place.address.isNotEmpty) ...[
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                place.address,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: sans(size: 11.5, color: AlagagiColors.muted),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
