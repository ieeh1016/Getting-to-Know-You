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
    final entries = controller.meetingDayEntries;
    final selectedEntry = controller.selectedMeetingPlanEntry;
    return AlagagiScreenScroll(
      bottomNavigation: AlagagiBottomNav(controller: controller),
      children: [
        AlagagiTopBar(title: '만남', trailing: ''),
        const SizedBox(height: 4),
        Text(
          '정해진 날만 모아서 뭐하고 어디 갈지 정리해요',
          style: sans(size: 12.5, color: AlagagiColors.muted),
        ),
        const SizedBox(height: 16),
        if (entries.isEmpty)
          _MeetingPlanEmptyState(controller: controller)
        else ...[
          _MeetingPlanHeroCard(entry: selectedEntry ?? entries.first),
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

class _MeetingPlanEmptyState extends StatelessWidget {
  const _MeetingPlanEmptyState({required this.controller});

  final AlagagiController controller;

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
            '아직 정해진 만나는 날이 없어요',
            textAlign: TextAlign.center,
            style: serif(context, size: 20, weight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            '약속 탭에서 서로 가능한 날짜를 만나는 날로 정하면 여기에 계획 공간이 열려요.',
            textAlign: TextAlign.center,
            style: sans(size: 12.5, color: AlagagiColors.muted, height: 1.55),
          ),
          const SizedBox(height: 16),
          AlagagiPrimaryButton(
            label: '약속에서 날짜 정하기',
            onPressed: () => controller.goTo(AlagagiRoute.meetings),
            color: AlagagiColors.sageDeep,
          ),
        ],
      ),
    );
  }
}

class _MeetingPlanHeroCard extends StatelessWidget {
  const _MeetingPlanHeroCard({required this.entry});

  final ScheduleEntry entry;

  @override
  Widget build(BuildContext context) {
    final timeLabel = entry.meetingTimeLabel.trim();
    final note = entry.meetingNote.trim();
    final planCount = entry.meetingPlanItems.length;
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
    required this.entry,
    required this.selected,
    required this.onTap,
  });

  final ScheduleEntry entry;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(entry.dateKey);
    final day = date?.day.toString() ?? entry.dateKey;
    final month = date == null ? '' : '${date.month}월';
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
                  entry.meetingPlanItems.isEmpty
                      ? '비어 있음'
                      : '${entry.meetingPlanItems.length}개',
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
            .where((place) => place.linkedDateKey != entry.dateKey)
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
                label: '만남 계획 저장',
                buttonKey: meetingPlanSaveButtonKey,
                onPressed: controller.submitMeetingPlanDraft,
                color: AlagagiColors.ink,
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
          for (final place in linkedPlaces) ...[
            _MeetingPlanPlaceRow(
              controller: controller,
              place: place,
              selectedDateKey: entry.dateKey,
              linked: true,
            ),
            const SizedBox(height: 10),
          ],
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
    return Column(
      children: [
        for (var index = 0; index < items.length; index++) ...[
          _MeetingPlanTaskRow(
            index: index,
            label: items[index],
            onRemove: () => controller.removeMeetingPlanDraftItem(index),
          ),
          if (index != items.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _MeetingPlanTaskRow extends StatelessWidget {
  const _MeetingPlanTaskRow({
    required this.index,
    required this.label,
    required this.onRemove,
  });

  final int index;
  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F4),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
      child: Row(
        children: [
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: MeetingTextField(
            fieldKey: meetingPlanDraftFieldKey,
            label: '추가할 계획',
            hint: '예: 전시 보기',
            initialValue: controller.state.meetingPlanItemDraft,
            maxLength: 40,
            helperText: '',
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
            icon: const Icon(Icons.add_rounded, size: 17),
            label: const Text('추가'),
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
  });

  final AlagagiController controller;
  final SharedPlace place;
  final String selectedDateKey;
  final bool linked;

  @override
  Widget build(BuildContext context) {
    final busy =
        controller.state.placeSaveStatus == SaveStatus.saving &&
        controller.isPlaceSaveTarget(place.id);
    return AlagagiPaperCard(
      radius: 18,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: linked ? const Color(0xFFF4EEDC) : const Color(0xFFF0F2EB),
              borderRadius: BorderRadius.circular(15),
            ),
            alignment: Alignment.center,
            child: Icon(
              placeCategoryIcon(place.category),
              size: 21,
              color: linked ? const Color(0xFF8A6F2D) : AlagagiColors.sageDeep,
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
                  [
                    placeCategoryLabel(place.category),
                    if (place.isMutual) '서로 관심',
                    if (place.address.isNotEmpty) place.address,
                  ].join(' · '),
                  maxLines: 1,
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
    );
  }
}
