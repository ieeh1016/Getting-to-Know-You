import 'package:flutter/material.dart';

import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/ui_components.dart';
import '../../shared/ui_style.dart';

IconData tripItemKindIcon(TripItemKind kind) => switch (kind) {
  TripItemKind.stay => Icons.bed_outlined,
  TripItemKind.transport => Icons.flight_takeoff_rounded,
  TripItemKind.packing => Icons.backpack_outlined,
  TripItemKind.plan => Icons.explore_outlined,
};

/// 여행 하루를 세로 rail로 이어 보여주는 타임라인.
///
/// 날짜가 정해진 항목은 시간순으로, 시간이 없으면 그날 끝에 놓인다.
/// 준비물은 시간 흐름이 아니라 목록이라 여기 오지 않는다.
class TripTimeline extends StatelessWidget {
  const TripTimeline({
    super.key,
    required this.days,
    required this.onTapItem,
  });

  final List<TripDay> days;
  final ValueChanged<TripItem> onTapItem;

  @override
  Widget build(BuildContext context) {
    if (days.every((day) => day.items.isEmpty)) {
      return const AlagagiEmptyStateCard(
        text: '아직 정한 일정이 없어요. 숙소나 이동부터 하나씩 담아봐요.',
      );
    }

    return Column(
      key: tripTimelineKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < days.length; index += 1) ...[
          _TripTimelineDay(
            day: days[index],
            isLast: index == days.length - 1,
            onTapItem: onTapItem,
          ),
        ],
      ],
    );
  }
}

class _TripTimelineDay extends StatelessWidget {
  const _TripTimelineDay({
    required this.day,
    required this.isLast,
    required this.onTapItem,
  });

  final TripDay day;
  final bool isLast;
  final ValueChanged<TripItem> onTapItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: tripTimelineDayKey(day.isUndated ? 'undated' : day.dateKey),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TripDayHeader(day: day),
        const SizedBox(height: 10),
        if (day.items.isEmpty)
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
              isLastInDay: index == day.items.length - 1 && isLast,
              onTap: () => onTapItem(day.items[index]),
            ),
        if (!isLast) const SizedBox(height: 8),
      ],
    );
  }
}

class _TripDayHeader extends StatelessWidget {
  const _TripDayHeader({required this.day});

  final TripDay day;

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
        if (day.items.isNotEmpty)
          Text(
            '${day.items.length}개',
            style: sans(size: 11.5, color: AlagagiColors.muted),
          ),
      ],
    );
  }
}

class _TripTimelineEntry extends StatelessWidget {
  const _TripTimelineEntry({
    required this.item,
    required this.isLastInDay,
    required this.onTap,
  });

  final TripItem item;
  final bool isLastInDay;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
                        icon: tripItemKindIcon(item.kind),
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
                            Row(
                              children: [
                                Text(
                                  item.timeLabel ?? '시간 미정',
                                  style: sans(
                                    size: 11.5,
                                    weight: FontWeight.w800,
                                    color: item.timeLabel == null
                                        ? AlagagiColors.muted
                                        : AlagagiColors.sageDeep,
                                  ),
                                ),
                                const SizedBox(width: 7),
                                Text(
                                  item.kind.label,
                                  style: sans(
                                    size: 11,
                                    color: AlagagiColors.muted,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              item.title,
                              style: sans(
                                size: 13.5,
                                weight: FontWeight.w700,
                              ),
                            ),
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
