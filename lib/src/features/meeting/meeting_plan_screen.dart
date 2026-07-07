import 'package:flutter/material.dart';

import '../../app/app_shell.dart';
import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/ui_components.dart';
import '../../shared/ui_style.dart';
import '../place/place_common.dart';
import 'meeting_common.dart';

class MeetingPlanScreen extends StatelessWidget {
  const MeetingPlanScreen({super.key, required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final entries = controller.upcomingMeetingDayEntries;
    final pastEntries = controller.pastMeetingDayEntries;
    final selectedEntry = controller.selectedMeetingPlanEntry;
    return AlagagiScreenScroll(
      bottomNavigation: AlagagiBottomNav(controller: controller),
      children: [
        AlagagiTopBar(title: '계획', trailing: ''),
        const SizedBox(height: 4),
        Text(
          '정해진 날만 모아서 뭐하고 어디 갈지 정리해요',
          style: sans(size: 12.5, color: AlagagiColors.muted),
        ),
        const SizedBox(height: 16),
        if (pastEntries.isNotEmpty) ...[
          _PastMeetingsButton(
            count: pastEntries.length,
            onPressed: () => _showPastMeetingsSheet(context, controller),
          ),
          const SizedBox(height: 14),
        ],
        if (entries.isEmpty)
          _MeetingPlanEmptyState(
            controller: controller,
            hasPastMeetings: pastEntries.isNotEmpty,
          )
        else ...[
          _MeetingPlanHeroCard(
            controller: controller,
            entry: selectedEntry ?? entries.first,
          ),
          const SizedBox(height: 14),
          _MeetingPlanDateStrip(controller: controller, entries: entries),
          const SizedBox(height: 14),
          if (selectedEntry != null)
            _MeetingPlanDetailCard(
              key: ValueKey('meeting-plan-detail-${selectedEntry.dateKey}'),
              controller: controller,
              entry: selectedEntry,
            ),
        ],
      ],
    );
  }
}

void _showPastMeetingsSheet(
  BuildContext context,
  AlagagiController controller,
) {
  final entries = controller.pastMeetingDayEntries;
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) =>
        _PastMeetingsSheet(controller: controller, entries: entries),
  );
}

class _PastMeetingsButton extends StatelessWidget {
  const _PastMeetingsButton({required this.count, required this.onPressed});

  final int count;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: OutlinedButton.icon(
        key: meetingPastMeetingsButtonKey,
        onPressed: onPressed,
        icon: const Icon(Icons.history_rounded, size: 18),
        label: Text('지난 만남 $count개 보기'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AlagagiColors.sageDeep,
          side: const BorderSide(color: Color(0x338A9A7E)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: sans(size: 13, weight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _PastMeetingsSheet extends StatelessWidget {
  const _PastMeetingsSheet({required this.controller, required this.entries});

  final AlagagiController controller;
  final List<ScheduleEntry> entries;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: FractionallySizedBox(
        heightFactor: 0.82,
        child: Container(
          key: meetingPastMeetingsSheetKey,
          decoration: const BoxDecoration(
            color: AlagagiColors.appBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDAD6CA),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '지난 만남',
                      style: serif(context, size: 22, weight: FontWeight.w800),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    tooltip: '닫기',
                    color: AlagagiColors.muted,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '지나간 날짜는 따로 모아서 시간, 메모, 계획, 장소를 가볍게 확인해요.',
                style: sans(
                  size: 12.5,
                  color: AlagagiColors.muted,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 22),
                  itemCount: entries.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return _PastMeetingCard(
                      controller: controller,
                      entry: entry,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PastMeetingCard extends StatelessWidget {
  const _PastMeetingCard({required this.controller, required this.entry});

  final AlagagiController controller;
  final ScheduleEntry entry;

  @override
  Widget build(BuildContext context) {
    final timeLabel = entry.meetingTimeLabel.trim();
    final note = entry.meetingNote.trim();
    final planItems = controller.meetingPlanItemsFor(entry.dateKey);
    final places = controller.placesForMeetingPlan(entry.dateKey);
    return AlagagiPaperCard(
      key: meetingPastMeetingCardKey(entry.dateKey),
      radius: 20,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2EB),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.event_available_rounded,
                  size: 20,
                  color: AlagagiColors.sageDeep,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meetingDateLabel(entry.dateKey),
                      style: serif(context, size: 18, weight: FontWeight.w800),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      timeLabel.isEmpty ? '시간 메모 없음' : timeLabel,
                      style: sans(size: 12, color: AlagagiColors.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (note.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              note,
              style: sans(
                size: 12.5,
                color: const Color(0xFF5F5D57),
                height: 1.45,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AlagagiSmallBadge(
                label: planItems.isEmpty ? '계획 없음' : '계획 ${planItems.length}개',
              ),
              AlagagiSmallBadge(
                label: places.isEmpty ? '장소 없음' : '장소 ${places.length}곳',
              ),
            ],
          ),
          if (planItems.isNotEmpty) ...[
            const SizedBox(height: 13),
            _PastMeetingMiniList(
              icon: Icons.playlist_add_check_rounded,
              title: '정했던 계획',
              items: planItems,
              collapsedLimit: 3,
              moreButtonKey: meetingPastMeetingPlansMoreButtonKey(
                entry.dateKey,
              ),
            ),
          ],
          if (places.isNotEmpty) ...[
            const SizedBox(height: 11),
            _PastMeetingMiniList(
              icon: Icons.place_outlined,
              title: '붙여둔 장소',
              items: places.map((place) => place.name).toList(),
              collapsedLimit: 2,
              moreButtonKey: meetingPastMeetingPlacesMoreButtonKey(
                entry.dateKey,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PastMeetingMiniList extends StatefulWidget {
  const _PastMeetingMiniList({
    required this.icon,
    required this.title,
    required this.items,
    required this.collapsedLimit,
    required this.moreButtonKey,
  });

  final IconData icon;
  final String title;
  final List<String> items;
  final int collapsedLimit;
  final Key moreButtonKey;

  @override
  State<_PastMeetingMiniList> createState() => _PastMeetingMiniListState();
}

class _PastMeetingMiniListState extends State<_PastMeetingMiniList> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final hiddenCount = widget.items.length - widget.collapsedLimit;
    final canExpand = hiddenCount > 0;
    final lines = _expanded || !canExpand
        ? widget.items
        : widget.items.take(widget.collapsedLimit).toList();
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F4),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(widget.icon, size: 18, color: AlagagiColors.sageDeep),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: sans(
                    size: 11.5,
                    color: AlagagiColors.muted,
                    weight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                for (final line in lines) ...[
                  Text(
                    line,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: sans(size: 12.5, height: 1.45),
                  ),
                ],
                if (canExpand) ...[
                  const SizedBox(height: 7),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      key: widget.moreButtonKey,
                      onPressed: () {
                        setState(() => _expanded = !_expanded);
                      },
                      icon: Icon(
                        _expanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        size: 17,
                      ),
                      label: Text(_expanded ? '접기' : '$hiddenCount개 더 보기'),
                      style: TextButton.styleFrom(
                        foregroundColor: AlagagiColors.sageDeep,
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        textStyle: sans(size: 12, weight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MeetingPlanEmptyState extends StatelessWidget {
  const _MeetingPlanEmptyState({
    required this.controller,
    required this.hasPastMeetings,
  });

  final AlagagiController controller;
  final bool hasPastMeetings;

  @override
  Widget build(BuildContext context) {
    return AlagagiPaperCard(
      key: meetingPlanScreenKey,
      radius: 24,
      padding: const EdgeInsets.all(20),
      dashed: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(
            Icons.favorite_border_rounded,
            size: 28,
            color: AlagagiColors.sageDeep,
          ),
          const SizedBox(height: 12),
          Text(
            hasPastMeetings ? '다가오는 만남이 없어요' : '아직 정해진 만나는 날이 없어요',
            textAlign: TextAlign.center,
            style: serif(context, size: 20, weight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            hasPastMeetings
                ? '지난 만남은 따로 모아두고, 다음 만나는 날이 생기면 여기에 바로 보여줄게요.'
                : '데이트 탭에서 서로 가능한 날짜를 만나는 날로 정하면 여기에 계획 공간이 열려요.',
            textAlign: TextAlign.center,
            style: sans(size: 12.5, color: AlagagiColors.muted, height: 1.55),
          ),
          const SizedBox(height: 16),
          AlagagiPrimaryButton(
            label: '데이트에서 날짜 정하기',
            onPressed: () => controller.goTo(AlagagiRoute.meetings),
            color: AlagagiColors.sageDeep,
          ),
        ],
      ),
    );
  }
}

class _MeetingPlanHeroCard extends StatelessWidget {
  const _MeetingPlanHeroCard({required this.controller, required this.entry});

  final AlagagiController controller;
  final ScheduleEntry entry;

  @override
  Widget build(BuildContext context) {
    final timeLabel = entry.meetingTimeLabel.trim();
    final note = entry.meetingNote.trim();
    final planCount = controller.meetingPlanItemCountFor(entry.dateKey);
    return AlagagiPaperCard(
      key: meetingPlanScreenKey,
      radius: 24,
      padding: const EdgeInsets.all(20),
      highlightedBorder: const Color(0x22E1C77A),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AlagagiColors.ink,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.favorite_rounded,
                  color: Color(0xFFE1C77A),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meetingDateLabel(entry.dateKey),
                      style: serif(context, size: 20, weight: FontWeight.w800),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      timeLabel.isEmpty ? '시간은 편하게 다시 정해도 괜찮아요.' : timeLabel,
                      style: sans(size: 12, color: AlagagiColors.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (note.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              note,
              style: sans(
                size: 12.5,
                height: 1.5,
                color: const Color(0xFF5F5D57),
              ),
            ),
          ],
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AlagagiSmallBadge(
                label: planCount == 0 ? '계획 비어 있음' : '계획 $planCount개',
              ),
              const AlagagiSmallBadge(label: '확정 날짜'),
            ],
          ),
        ],
      ),
    );
  }
}

class _MeetingPlanDateStrip extends StatelessWidget {
  const _MeetingPlanDateStrip({
    required this.controller,
    required this.entries,
  });

  final AlagagiController controller;
  final List<ScheduleEntry> entries;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 82,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: entries.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final entry = entries[index];
          final selected =
              entry.dateKey == controller.selectedMeetingPlanDateKey;
          return _MeetingPlanDateCard(
            controller: controller,
            entry: entry,
            selected: selected,
            onTap: () => controller.selectMeetingPlanDate(entry.dateKey),
          );
        },
      ),
    );
  }
}

class _MeetingPlanDateCard extends StatelessWidget {
  const _MeetingPlanDateCard({
    required this.controller,
    required this.entry,
    required this.selected,
    required this.onTap,
  });

  final AlagagiController controller;
  final ScheduleEntry entry;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(entry.dateKey);
    final day = date?.day.toString() ?? entry.dateKey;
    final month = date == null ? '' : '${date.month}월';
    final planCount = controller.meetingPlanItemCountFor(entry.dateKey);
    return SizedBox(
      width: 78,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: meetingPlanDateButtonKey(entry.dateKey),
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: selected ? AlagagiColors.ink : AlagagiColors.paper,
              border: Border.all(
                color: selected ? AlagagiColors.ink : AlagagiColors.line,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  month,
                  style: sans(
                    size: 10.5,
                    color: selected ? Colors.white70 : AlagagiColors.muted,
                  ),
                ),
                const Spacer(),
                Text(
                  day,
                  style: sans(
                    size: 21,
                    weight: FontWeight.w800,
                    color: selected ? Colors.white : AlagagiColors.ink,
                  ),
                ),
                Text(
                  planCount == 0 ? '비어 있음' : '$planCount개',
                  style: sans(
                    size: 10.5,
                    color: selected
                        ? const Color(0xFFE1C77A)
                        : AlagagiColors.sageDeep,
                    weight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MeetingPlanDetailCard extends StatefulWidget {
  const _MeetingPlanDetailCard({
    super.key,
    required this.controller,
    required this.entry,
  });

  final AlagagiController controller;
  final ScheduleEntry entry;

  @override
  State<_MeetingPlanDetailCard> createState() => _MeetingPlanDetailCardState();
}

class _MeetingPlanDetailCardState extends State<_MeetingPlanDetailCard> {
  bool _showAllBoardPlaces = false;

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final entry = widget.entry;
    final linkedPlaces = controller.placesForMeetingPlan(entry.dateKey);
    final boardPlaces =
        controller.sharedPlaces
            .where((place) => !place.isLinkedToMeetingDate(entry.dateKey))
            .toList()
          ..sort((a, b) {
            if (a.isMutual != b.isMutual) {
              return a.isMutual ? -1 : 1;
            }
            return a.name.compareTo(b.name);
          });
    final hiddenBoardPlaceCount = boardPlaces.length > 4
        ? boardPlaces.length - 4
        : 0;
    final visibleBoardPlaces = _showAllBoardPlaces
        ? boardPlaces
        : boardPlaces.take(4).toList();
    final pairPlanTitle = _meetingPlanPairTitle(controller);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AlagagiPaperCard(
          radius: 24,
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF5D2),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0x33D9B34F)),
                    ),
                    alignment: Alignment.center,
                    child: const Text('📝', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pairPlanTitle,
                          style: serif(
                            context,
                            size: 20,
                            weight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '같이 하고 싶은 것들을 편하게 모아요.',
                          style: sans(
                            size: 11.5,
                            color: AlagagiColors.muted,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  AlagagiSmallBadge(
                    label: meetingDateShortLabel(entry.dateKey),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _MeetingPlanTaskList(controller: controller),
              const SizedBox(height: 12),
              _MeetingPlanTaskComposer(controller: controller),
              if (controller.state.meetingDraftError != null &&
                  controller.state.meetingSaveStatus != SaveStatus.failed) ...[
                const SizedBox(height: 9),
                Text(
                  controller.state.meetingDraftError!,
                  style: sans(size: 12, color: AlagagiColors.sageDeep),
                ),
              ],
              const SizedBox(height: 12),
              AlagagiPrimaryButton(
                label: '계획 저장',
                buttonKey: meetingPlanSaveButtonKey,
                onPressed: controller.submitMeetingPlanDraft,
                color: AlagagiColors.ink,
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 40,
                child: OutlinedButton.icon(
                  key: meetingDayCancelButtonKey,
                  onPressed: () => confirmCancelMeetingDay(
                    context,
                    controller,
                    entry.dateKey,
                  ),
                  icon: const Icon(Icons.event_busy_rounded, size: 16),
                  label: const Text('만남 취소'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF8F5C4D),
                    side: const BorderSide(color: Color(0x33B18472)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    textStyle: sans(size: 12.5, weight: FontWeight.w800),
                  ),
                ),
              ),
              MeetingSaveStatus(controller: controller),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            const Expanded(child: AlagagiSectionLabel('이 날 장소 후보')),
            AlagagiSmallBadge(label: '${linkedPlaces.length}곳'),
          ],
        ),
        PlaceSaveStatus(controller: controller),
        const SizedBox(height: 10),
        if (linkedPlaces.isEmpty)
          const AlagagiEmptyStateCard(text: '장소 탭에서 저장한 곳을 이 날 후보로 붙여볼 수 있어요.')
        else
          _MeetingPlanLinkedPlaceList(
            controller: controller,
            places: linkedPlaces,
            selectedDateKey: entry.dateKey,
          ),
        if (boardPlaces.isNotEmpty) ...[
          const SizedBox(height: 12),
          const AlagagiSectionLabel('장소 보드에서 가져오기'),
          const SizedBox(height: 10),
          for (final place in visibleBoardPlaces) ...[
            _MeetingPlanPlaceRow(
              controller: controller,
              place: place,
              selectedDateKey: entry.dateKey,
              linked: false,
            ),
            const SizedBox(height: 10),
          ],
          if (boardPlaces.length > 4)
            _MeetingPlanMorePlacesButton(
              expanded: _showAllBoardPlaces,
              hiddenCount: hiddenBoardPlaceCount,
              onPressed: () {
                setState(() => _showAllBoardPlaces = !_showAllBoardPlaces);
              },
            ),
        ],
      ],
    );
  }
}

class _MeetingPlanTaskList extends StatelessWidget {
  const _MeetingPlanTaskList({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final items = controller.meetingPlanDraftItems;
    if (items.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F4),
          border: Border.all(color: AlagagiColors.line),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Row(
          children: [
            Icon(
              Icons.playlist_add_check_rounded,
              size: 20,
              color: AlagagiColors.sageDeep,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '둘이 같이 하고 싶은 걸 하나씩 적어두면 좋아요.',
                style: sans(
                  size: 12.2,
                  color: AlagagiColors.muted,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      buildDefaultDragHandles: false,
      itemCount: items.length,
      // ignore: deprecated_member_use
      onReorder: controller.reorderMeetingPlanDraftItem,
      itemBuilder: (context, index) {
        return Padding(
          key: ValueKey(_meetingPlanTaskKey(items, index)),
          padding: EdgeInsets.only(bottom: index == items.length - 1 ? 0 : 8),
          child: _MeetingPlanTaskRow(
            index: index,
            label: items[index],
            editing: controller.state.editingMeetingPlanItemIndex == index,
            dragHandle: ReorderableDragStartListener(
              index: index,
              child: SizedBox(
                key: meetingPlanItemDragHandleKey(index),
                width: 30,
                height: 34,
                child: Tooltip(
                  message: '순서 변경',
                  child: Icon(
                    Icons.drag_indicator_rounded,
                    size: 19,
                    color: AlagagiColors.muted.withValues(alpha: 0.82),
                  ),
                ),
              ),
            ),
            onEdit: () => controller.startEditingMeetingPlanDraftItem(index),
            onRemove: () => controller.removeMeetingPlanDraftItem(index),
          ),
        );
      },
    );
  }
}

String _meetingPlanTaskKey(List<String> items, int index) {
  final label = items[index];
  var occurrence = 0;
  for (var cursor = 0; cursor < index; cursor++) {
    if (items[cursor] == label) {
      occurrence += 1;
    }
  }
  return 'meeting-plan-task-$label-$occurrence';
}

class _MeetingPlanTaskRow extends StatelessWidget {
  const _MeetingPlanTaskRow({
    required this.index,
    required this.label,
    required this.editing,
    required this.dragHandle,
    required this.onEdit,
    required this.onRemove,
  });

  final int index;
  final String label;
  final bool editing;
  final Widget dragHandle;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: editing ? const Color(0xFFF0F2EB) : const Color(0xFFF8F8F4),
        border: Border.all(
          color: editing ? const Color(0x668A9A7E) : AlagagiColors.line,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
      child: Row(
        children: [
          dragHandle,
          const SizedBox(width: 4),
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Color(0xFFF0F2EB),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${index + 1}',
              style: sans(
                size: 11,
                weight: FontWeight.w800,
                color: AlagagiColors.sageDeep,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: sans(size: 13, weight: FontWeight.w700, height: 1.35),
            ),
          ),
          SizedBox(
            width: 34,
            height: 34,
            child: IconButton(
              key: meetingPlanItemEditButtonKey(index),
              onPressed: onEdit,
              icon: const Icon(Icons.edit_rounded, size: 16),
              color: editing ? AlagagiColors.sageDeep : AlagagiColors.muted,
              tooltip: '수정',
              padding: EdgeInsets.zero,
            ),
          ),
          SizedBox(
            width: 34,
            height: 34,
            child: IconButton(
              key: meetingPlanItemRemoveButtonKey(index),
              onPressed: onRemove,
              icon: const Icon(Icons.close_rounded, size: 17),
              color: AlagagiColors.muted,
              tooltip: '삭제',
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}

class _MeetingPlanTaskComposer extends StatelessWidget {
  const _MeetingPlanTaskComposer({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final editingIndex = controller.state.editingMeetingPlanItemIndex;
    final isEditing = editingIndex != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: MeetingTextField(
                fieldKey: meetingPlanDraftFieldKey,
                label: isEditing ? '${editingIndex + 1}번째 계획 수정' : '추가할 계획',
                hint: isEditing ? '계획을 고쳐 적어주세요' : '예: 전시 보기',
                initialValue: controller.state.meetingPlanItemDraft,
                maxLength: 40,
                helperText: isEditing ? '완료를 누르면 목록에 반영돼요.' : '',
                minLines: 1,
                maxLines: 1,
                onChanged: controller.updateMeetingPlanItemDraft,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 56,
              child: OutlinedButton.icon(
                key: meetingPlanItemAddButtonKey,
                onPressed: controller.addMeetingPlanDraftItem,
                icon: Icon(
                  isEditing ? Icons.check_rounded : Icons.add_rounded,
                  size: 17,
                ),
                label: Text(isEditing ? '완료' : '추가'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AlagagiColors.sageDeep,
                  side: const BorderSide(color: Color(0x338A9A7E)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  textStyle: sans(size: 12.5, weight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
        if (isEditing) ...[
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: controller.cancelEditingMeetingPlanDraftItem,
              icon: const Icon(Icons.close_rounded, size: 15),
              label: const Text('수정 취소'),
              style: TextButton.styleFrom(
                foregroundColor: AlagagiColors.muted,
                textStyle: sans(size: 12, weight: FontWeight.w800),
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

String _meetingPlanPairTitle(AlagagiController controller) {
  final me = controller.state.me.nickname.trim();
  final partner = controller.state.partner.nickname.trim();
  if ({me, partner}.containsAll(const ['영우', '민영'])) {
    return '영우·민영의 계획';
  }
  final names = [
    if (me.isNotEmpty) me,
    if (partner.isNotEmpty && partner != me) partner,
  ];
  if (names.length >= 2) {
    return '${names.take(2).join('·')}의 계획';
  }
  if (names.length == 1) {
    return '${names.single}의 계획';
  }
  return '우리의 계획';
}

class _MeetingPlanLinkedPlaceList extends StatelessWidget {
  const _MeetingPlanLinkedPlaceList({
    required this.controller,
    required this.places,
    required this.selectedDateKey,
  });

  final AlagagiController controller;
  final List<SharedPlace> places;
  final String selectedDateKey;

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      buildDefaultDragHandles: false,
      itemCount: places.length,
      // ignore: deprecated_member_use
      onReorder: (oldIndex, newIndex) {
        controller.reorderMeetingPlanPlaces(
          selectedDateKey,
          oldIndex,
          newIndex,
        );
      },
      itemBuilder: (context, index) {
        final place = places[index];
        return Padding(
          key: ValueKey('meeting-plan-place-$selectedDateKey-${place.id}'),
          padding: EdgeInsets.only(bottom: index == places.length - 1 ? 0 : 10),
          child: _MeetingPlanPlaceRow(
            controller: controller,
            place: place,
            selectedDateKey: selectedDateKey,
            linked: true,
            dragHandle: ReorderableDragStartListener(
              index: index,
              child: SizedBox(
                key: meetingPlanPlaceDragHandleKey(place.id),
                width: 28,
                height: 34,
                child: Tooltip(
                  message: '장소 순서 변경',
                  child: Icon(
                    Icons.drag_indicator_rounded,
                    size: 19,
                    color: AlagagiColors.muted.withValues(alpha: 0.82),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MeetingPlanMorePlacesButton extends StatelessWidget {
  const _MeetingPlanMorePlacesButton({
    required this.expanded,
    required this.hiddenCount,
    required this.onPressed,
  });

  final bool expanded;
  final int hiddenCount;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: OutlinedButton.icon(
        key: meetingPlanPlaceMoreButtonKey,
        onPressed: onPressed,
        icon: Icon(
          expanded ? Icons.keyboard_arrow_up_rounded : Icons.more_horiz_rounded,
          size: 18,
        ),
        label: Text(expanded ? '접기' : '$hiddenCount곳 더 보기'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AlagagiColors.sageDeep,
          side: const BorderSide(color: Color(0x338A9A7E)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          textStyle: sans(size: 12.5, weight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _MeetingPlanPlaceRow extends StatelessWidget {
  const _MeetingPlanPlaceRow({
    required this.controller,
    required this.place,
    required this.selectedDateKey,
    required this.linked,
    this.dragHandle,
  });

  final AlagagiController controller;
  final SharedPlace place;
  final String selectedDateKey;
  final bool linked;
  final Widget? dragHandle;

  @override
  Widget build(BuildContext context) {
    final busy =
        controller.state.placeSaveStatus == SaveStatus.saving &&
        controller.isPlaceSaveTarget(place.id);
    final link = place.meetingPlanLinkFor(selectedDateKey);
    final reservationTime = link?.reservationTimeLabel.trim() ?? '';
    final details = [
      placeCategoryLabel(place.category),
      if (place.isMutual) '서로 관심',
      if (place.address.isNotEmpty) place.address,
    ].join(' · ');
    return AlagagiPaperCard(
      radius: 18,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              if (dragHandle != null) ...[
                dragHandle!,
                const SizedBox(width: 4),
              ],
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: linked
                      ? const Color(0xFFF4EEDC)
                      : const Color(0xFFF0F2EB),
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                child: Icon(
                  placeCategoryIcon(place.category),
                  size: 21,
                  color: linked
                      ? const Color(0xFF8A6F2D)
                      : AlagagiColors.sageDeep,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: sans(size: 13.5, weight: FontWeight.w800),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      details,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: sans(size: 11.2, color: AlagagiColors.muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 32,
                child: OutlinedButton(
                  key: meetingPlanPlaceLinkButtonKey(place.id),
                  onPressed: busy
                      ? null
                      : () {
                          if (controller.selectedMeetingPlanDateKey !=
                              selectedDateKey) {
                            controller.selectMeetingPlanDate(selectedDateKey);
                          }
                          controller.linkPlaceToSelectedMeetingPlan(place.id);
                        },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: linked
                        ? const Color(0xFF8A6F2D)
                        : AlagagiColors.sageDeep,
                    disabledForegroundColor: AlagagiColors.muted,
                    side: BorderSide(
                      color: linked
                          ? const Color(0x33C8AD6D)
                          : const Color(0x338A9A7E),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                    textStyle: sans(size: 11.5, weight: FontWeight.w800),
                  ),
                  child: Text(linked ? '빼기' : '담기'),
                ),
              ),
            ],
          ),
          if (linked) ...[
            if (reservationTime.isNotEmpty) ...[
              const SizedBox(height: 11),
              _MeetingPlanPlaceReservationBadge(
                placeId: place.id,
                reservationTime: reservationTime,
              ),
            ],
            const SizedBox(height: 10),
            _MeetingPlanPlaceReservationEditor(
              controller: controller,
              place: place,
              selectedDateKey: selectedDateKey,
              initialValue: reservationTime,
            ),
          ],
        ],
      ),
    );
  }
}

class _MeetingPlanPlaceReservationBadge extends StatelessWidget {
  const _MeetingPlanPlaceReservationBadge({
    required this.placeId,
    required this.reservationTime,
  });

  final String placeId;
  final String reservationTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E9),
        border: Border.all(color: const Color(0x33C8AD6D)),
        borderRadius: BorderRadius.circular(13),
      ),
      padding: const EdgeInsets.fromLTRB(10, 8, 12, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.schedule_rounded,
            size: 16,
            color: Color(0xFF8A6F2D),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              '예약 $reservationTime',
              key: meetingPlanPlaceReservationBadgeKey(placeId),
              softWrap: true,
              style: sans(
                size: 12,
                height: 1.35,
                weight: FontWeight.w800,
                color: const Color(0xFF7A6227),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MeetingPlanPlaceReservationEditor extends StatefulWidget {
  const _MeetingPlanPlaceReservationEditor({
    required this.controller,
    required this.place,
    required this.selectedDateKey,
    required this.initialValue,
  });

  final AlagagiController controller;
  final SharedPlace place;
  final String selectedDateKey;
  final String initialValue;

  @override
  State<_MeetingPlanPlaceReservationEditor> createState() =>
      _MeetingPlanPlaceReservationEditorState();
}

class _MeetingPlanPlaceReservationEditorState
    extends State<_MeetingPlanPlaceReservationEditor> {
  late final TextEditingController _controller;
  late String _savedValue;
  String? _pendingValue;

  @override
  void initState() {
    super.initState();
    _savedValue = widget.initialValue;
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant _MeetingPlanPlaceReservationEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    final status = widget.controller.state.placeSaveStatus;
    final isTarget = widget.controller.isPlaceSaveTarget(widget.place.id);
    if (_pendingValue != null && isTarget && status == SaveStatus.saved) {
      _savedValue = _pendingValue!;
      _pendingValue = null;
    } else if (_pendingValue != null &&
        isTarget &&
        status == SaveStatus.failed) {
      _pendingValue = null;
    }
    if (oldWidget.initialValue != widget.initialValue &&
        _pendingValue == null) {
      _savedValue = widget.initialValue;
      if (_controller.text != widget.initialValue) {
        _controller.text = widget.initialValue;
        _controller.selection = TextSelection.collapsed(
          offset: widget.initialValue.length,
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final value = _controller.text.trim();
    if (value == _savedValue && _pendingValue == null) {
      return;
    }
    setState(() => _pendingValue = value);
    final saved = widget.controller.updateMeetingPlaceReservationTime(
      dateKey: widget.selectedDateKey,
      placeId: widget.place.id,
      reservationTimeLabel: value,
    );
    if (!saved && mounted) {
      setState(() => _pendingValue = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final changed = _controller.text.trim() != _savedValue;
    final busy =
        widget.controller.state.placeSaveStatus == SaveStatus.saving &&
        widget.controller.isPlaceSaveTarget(widget.place.id);
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F4),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.fromLTRB(12, 7, 8, 7),
      child: Row(
        children: [
          const Icon(
            Icons.schedule_rounded,
            size: 17,
            color: AlagagiColors.sageDeep,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              key: meetingPlanPlaceReservationFieldKey(widget.place.id),
              controller: _controller,
              maxLength: 30,
              minLines: 1,
              maxLines: 2,
              enabled: !busy,
              textInputAction: TextInputAction.done,
              onChanged: (_) => setState(() {}),
              onFieldSubmitted: (_) => _save(),
              decoration: const InputDecoration(
                hintText: '예약 시간 입력',
                counterText: '',
                isDense: true,
                border: InputBorder.none,
              ),
              style: sans(size: 12.5, height: 1.35),
            ),
          ),
          if (changed) ...[
            const SizedBox(width: 8),
            SizedBox(
              height: 30,
              child: TextButton(
                key: meetingPlanPlaceReservationSaveButtonKey(widget.place.id),
                onPressed: busy ? null : _save,
                style: TextButton.styleFrom(
                  foregroundColor: AlagagiColors.sageDeep,
                  padding: const EdgeInsets.symmetric(horizontal: 9),
                  minimumSize: const Size(0, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textStyle: sans(size: 11.5, weight: FontWeight.w800),
                ),
                child: Text(busy ? '저장 중' : '저장'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
