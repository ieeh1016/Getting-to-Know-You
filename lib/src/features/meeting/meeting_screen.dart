import 'package:flutter/material.dart';

import '../../app/app_shell.dart';
import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/ui_components.dart';
import '../../shared/ui_style.dart';
import 'meeting_common.dart';

class MeetingScreen extends StatefulWidget {
  const MeetingScreen({super.key, required this.controller});

  final AlagagiController controller;

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  bool _showAllCandidates = false;

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final candidates = controller.meetingCandidates;
    final meetingDayEntry = controller.nextMeetingDayEntry;
    final visibleCandidates = _showAllCandidates
        ? candidates
        : candidates.take(3).toList();
    final hiddenCandidateCount = candidates.length - visibleCandidates.length;
    return AlagagiScreenScroll(
      bottomNavigation: AlagagiBottomNav(controller: controller),
      children: [
        AlagagiTopBar(title: '만날 수 있는 날', trailing: ''),
        const SizedBox(height: 4),
        Text(
          '각자의 일정 내용은 지키면서 겹치는 여유만 맞춰요',
          style: sans(size: 12.5, color: AlagagiColors.muted),
        ),
        const SizedBox(height: 16),
        _MeetingHeroCard(
          controller: controller,
          candidateCount: candidates.length,
          meetingDayEntry: meetingDayEntry,
        ),
        const SizedBox(height: 14),
        _MeetingCalendar(controller: controller),
        const SizedBox(height: 14),
        _MeetingDetailCard(
          key: ValueKey('meeting-detail-${controller.selectedMeetingDateKey}'),
          controller: controller,
        ),
        const SizedBox(height: 18),
        const AlagagiSectionLabel('서로 괜찮은 후보'),
        const SizedBox(height: 10),
        if (candidates.isEmpty)
          const AlagagiEmptyStateCard(text: '둘 다 가능하다고 남긴 날이 생기면 여기에 모여요.')
        else ...[
          for (final candidate in visibleCandidates) ...[
            _MeetingCandidateCard(
              candidate: candidate,
              onTap: () => controller.selectMeetingDate(candidate.dateKey),
            ),
            const SizedBox(height: 10),
          ],
          if (candidates.length > 3)
            _MeetingCandidateMoreButton(
              expanded: _showAllCandidates,
              hiddenCount: hiddenCandidateCount,
              onPressed: () =>
                  setState(() => _showAllCandidates = !_showAllCandidates),
            ),
        ],
      ],
    );
  }
}

class _MeetingHeroCard extends StatelessWidget {
  const _MeetingHeroCard({
    required this.controller,
    required this.candidateCount,
    required this.meetingDayEntry,
  });

  final AlagagiController controller;
  final int candidateCount;
  final ScheduleEntry? meetingDayEntry;

  @override
  Widget build(BuildContext context) {
    final meetingTimeLabel = meetingDayEntry?.meetingTimeLabel.trim() ?? '';
    final meetingPlanCount = meetingDayEntry == null
        ? 0
        : controller.meetingPlanItemCountFor(meetingDayEntry!.dateKey);
    final heroTitle = meetingDayEntry != null
        ? '${meetingDateShortLabel(meetingDayEntry!.dateKey)}\n만나는 날이에요'
        : candidateCount == 0
        ? '가능한 날을\n하나씩 남겨볼까요?'
        : '이번 달엔\n$candidateCount일이 서로 괜찮아요';
    final heroSubtitle = meetingDayEntry != null
        ? [
            if (meetingTimeLabel.isEmpty)
              '시간은 편할 때 다시 적어도 괜찮아요.'
            else
              '$meetingTimeLabel에 만나기로 했어요.',
            if (meetingPlanCount > 0) '만남 탭에 그날 계획이 정리돼 있어요.',
          ].join(' ')
        : '상대에게 보여도 괜찮은 일정과 만날 수 있는 여유만 남겨요.';
    return AlagagiPaperCard(
      radius: 24,
      padding: const EdgeInsets.all(20),
      highlightedBorder: const Color(0x228A9A7E),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NEXT MEETING',
            style: sans(
              size: 10.5,
              weight: FontWeight.w800,
              color: AlagagiColors.sageDeep,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            heroTitle,
            style: serif(
              context,
              size: 22,
              weight: FontWeight.w800,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            heroSubtitle,
            style: sans(size: 12.5, color: AlagagiColors.muted, height: 1.6),
          ),
        ],
      ),
    );
  }
}

class _MeetingCalendar extends StatelessWidget {
  const _MeetingCalendar({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final selectedDate =
        DateTime.tryParse(controller.selectedMeetingDateKey) ?? DateTime.now();
    final firstDay = DateTime(selectedDate.year, selectedDate.month);
    final daysInMonth = DateTime(
      selectedDate.year,
      selectedDate.month + 1,
      0,
    ).day;
    final leading = firstDay.weekday % 7;
    final cells = <DateTime?>[
      for (var i = 0; i < leading; i++) null,
      for (var day = 1; day <= daysInMonth; day++)
        DateTime(selectedDate.year, selectedDate.month, day),
    ];

    return AlagagiPaperCard(
      radius: 22,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _MeetingMonthButton(
                buttonKey: meetingCalendarPreviousButtonKey,
                icon: Icons.chevron_left_rounded,
                tooltip: '이전 달',
                onPressed: () =>
                    _selectMeetingMonth(controller, selectedDate, -1),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${selectedDate.year}년 ${selectedDate.month}월',
                  textAlign: TextAlign.center,
                  style: serif(context, size: 18, weight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: 8),
              _MeetingMonthButton(
                buttonKey: meetingCalendarNextButtonKey,
                icon: Icons.chevron_right_rounded,
                tooltip: '다음 달',
                onPressed: () =>
                    _selectMeetingMonth(controller, selectedDate, 1),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            '앞뒤 한 달씩 넘겨 가까운 약속을 추가하거나 수정할 수 있어요.',
            textAlign: TextAlign.center,
            style: sans(size: 11.2, color: AlagagiColors.muted),
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              for (final label in const ['일', '월', '화', '수', '목', '금', '토'])
                Expanded(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: sans(
                      size: 10.5,
                      color: AlagagiColors.muted,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 7),
          GridView.builder(
            key: meetingCalendarKey,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cells.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              childAspectRatio: 0.92,
            ),
            itemBuilder: (context, index) {
              final date = cells[index];
              if (date == null) {
                return const SizedBox.shrink();
              }
              final dateKey = dateKeyForUi(date);
              final myEntry = controller.scheduleEntryFor(
                controller.state.me.id,
                dateKey,
              );
              final partnerEntry = controller.scheduleEntryFor(
                controller.state.partner.id,
                dateKey,
              );
              final selected = dateKey == controller.selectedMeetingDateKey;
              final mutual =
                  myEntry?.canMeet == true &&
                  partnerEntry?.canMeet == true &&
                  myEntry!.timeSlots
                      .intersection(partnerEntry!.timeSlots)
                      .isNotEmpty;
              final meetingDay = controller.meetingDayEntryFor(dateKey) != null;
              final busy = myEntry?.availability == MeetingAvailability.busy;
              final hasMyEntry = myEntry != null;
              final hasMyDetails = myEntry?.timeBlocks.isNotEmpty ?? false;
              return _MeetingDateCell(
                dateKey: dateKey,
                day: date.day,
                selected: selected,
                meetingDay: meetingDay,
                mutual: mutual,
                busy: busy,
                hasMyEntry: hasMyEntry,
                hasMyDetails: hasMyDetails,
                hasPartner: partnerEntry != null,
                onTap: () => controller.selectMeetingDate(dateKey),
              );
            },
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: const [
              _LegendDot(color: Color(0xFFE1C77A), label: '만나는 날'),
              _LegendDot(color: AlagagiColors.sageDeep, label: '서로 가능'),
              _LegendDot(color: AlagagiColors.sage, label: '내 입력'),
              _LegendDot(color: Color(0xFFC8AD6D), label: '내 상세 일정'),
              _LegendDot(color: Color(0xFFB18472), label: '상대 표시'),
            ],
          ),
        ],
      ),
    );
  }

  void _selectMeetingMonth(
    AlagagiController controller,
    DateTime selectedDate,
    int monthOffset,
  ) {
    final targetMonth = DateTime(
      selectedDate.year,
      selectedDate.month + monthOffset,
    );
    final targetMonthLastDay = DateTime(
      targetMonth.year,
      targetMonth.month + 1,
      0,
    ).day;
    final targetDay = selectedDate.day.clamp(1, targetMonthLastDay).toInt();
    controller.selectMeetingDate(
      dateKeyForUi(DateTime(targetMonth.year, targetMonth.month, targetDay)),
    );
  }
}

class _MeetingMonthButton extends StatelessWidget {
  const _MeetingMonthButton({
    required this.buttonKey,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final Key buttonKey;
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        key: buttonKey,
        onPressed: onPressed,
        icon: Icon(icon, size: 19),
        style: IconButton.styleFrom(
          fixedSize: const Size(36, 36),
          minimumSize: const Size(36, 36),
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: const Color(0xFFF8F8F4),
          foregroundColor: AlagagiColors.sageDeep,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
            side: const BorderSide(color: AlagagiColors.line),
          ),
        ),
      ),
    );
  }
}

class _MeetingDateCell extends StatelessWidget {
  const _MeetingDateCell({
    required this.dateKey,
    required this.day,
    required this.selected,
    required this.meetingDay,
    required this.mutual,
    required this.busy,
    required this.hasMyEntry,
    required this.hasMyDetails,
    required this.hasPartner,
    required this.onTap,
  });

  final String dateKey;
  final int day;
  final bool selected;
  final bool meetingDay;
  final bool mutual;
  final bool busy;
  final bool hasMyEntry;
  final bool hasMyDetails;
  final bool hasPartner;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const meetingDayFill = Color(0xFFFFF5D2);
    const meetingDayBorder = Color(0xFFD9B34F);
    const meetingDayForeground = Color(0xFF6F5518);
    final background = selected
        ? AlagagiColors.ink
        : meetingDay
        ? meetingDayFill
        : mutual
        ? const Color(0xFFEEF2E8)
        : busy || hasMyDetails
        ? const Color(0xFFF4EEDC)
        : hasMyEntry
        ? const Color(0xFFF5F8EF)
        : Colors.white;
    final foreground = selected
        ? Colors.white
        : meetingDay
        ? meetingDayForeground
        : mutual
        ? AlagagiColors.sageDeep
        : busy || hasMyDetails
        ? const Color(0xFF8A6F2D)
        : hasMyEntry
        ? AlagagiColors.sageDeep
        : const Color(0xFF4D4B45);
    final borderColor = selected
        ? AlagagiColors.ink
        : meetingDay
        ? meetingDayBorder
        : mutual
        ? const Color(0x668A9A7E)
        : hasMyEntry
        ? const Color(0x338A9A7E)
        : AlagagiColors.line;
    final indicators = <Widget>[
      if (mutual)
        _TinyDot(
          key: meetingMutualIndicatorKey(dateKey),
          color: selected ? Colors.white : AlagagiColors.sageDeep,
        ),
      if (hasMyEntry)
        _TinyDot(
          key: meetingMyEntryIndicatorKey(dateKey),
          color: selected ? const Color(0xFFB8C8A5) : AlagagiColors.sage,
        ),
      if (hasMyDetails)
        _TinyDot(
          color: selected ? const Color(0xFFE1C77A) : const Color(0xFFC8AD6D),
        ),
      if (hasPartner)
        _TinyDot(
          key: meetingPartnerEntryIndicatorKey(dateKey),
          color: selected ? const Color(0xFFD3A28F) : const Color(0xFFB18472),
        ),
    ];
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: meetingDateButtonKey(dateKey),
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: background,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Text(
                  '$day',
                  style: sans(
                    size: 12,
                    weight: FontWeight.w800,
                    color: foreground,
                  ),
                ),
              ),
              if (meetingDay)
                Positioned(
                  bottom: 5,
                  left: 0,
                  right: 0,
                  child: Semantics(
                    label: '만나는 날',
                    child: Center(
                      child: Container(
                        key: meetingDayIndicatorKey(dateKey),
                        width: 18,
                        height: 3.5,
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xFFE1C77A)
                              : const Color(0xFFD9B34F),
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x22000000),
                              blurRadius: 3,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              if (!meetingDay)
                Positioned(
                  bottom: 4,
                  left: 4,
                  right: 4,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (
                          var index = 0;
                          index < indicators.length;
                          index++
                        ) ...[
                          if (index > 0) const SizedBox(width: 3),
                          indicators[index],
                        ],
                      ],
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

class _MeetingTimePreset {
  const _MeetingTimePreset({
    required this.id,
    required this.label,
    required this.start,
    required this.end,
    required this.title,
  });

  final String id;
  final String label;
  final String start;
  final String end;
  final String title;
}

const _meetingTimePresets = [
  _MeetingTimePreset(
    id: 'morning',
    label: '오전 일정',
    start: '10:00',
    end: '12:00',
    title: '오전 일정',
  ),
  _MeetingTimePreset(
    id: 'lunch',
    label: '점심 약속',
    start: '12:00',
    end: '13:30',
    title: '점심 약속',
  ),
  _MeetingTimePreset(
    id: 'afternoon',
    label: '오후 일정',
    start: '14:00',
    end: '17:00',
    title: '오후 일정',
  ),
  _MeetingTimePreset(
    id: 'evening',
    label: '저녁 약속',
    start: '19:00',
    end: '21:00',
    title: '저녁 약속',
  ),
];

class _MeetingDetailCard extends StatelessWidget {
  const _MeetingDetailCard({super.key, required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final myEntry = controller.mySelectedScheduleEntry;
    final partnerEntry = controller.partnerSelectedScheduleEntry;
    final meetingDayEntry = controller.meetingDayEntryFor(
      controller.selectedMeetingDateKey,
    );
    final sharedSlots =
        myEntry?.timeSlots.intersection(
          partnerEntry?.timeSlots ?? const <MeetingTimeSlot>{},
        ) ??
        const <MeetingTimeSlot>{};
    final mutual =
        myEntry?.canMeet == true &&
        partnerEntry?.canMeet == true &&
        sharedSlots.isNotEmpty;
    final showMeetingDayPanel = mutual || meetingDayEntry != null;
    return AlagagiPaperCard(
      radius: 24,
      padding: const EdgeInsets.all(18),
      highlightedBorder: AlagagiColors.sage,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  meetingDateLabel(controller.selectedMeetingDateKey),
                  style: serif(context, size: 21, weight: FontWeight.w800),
                ),
              ),
              AlagagiSmallBadge(
                label: meetingAvailabilityLabel(myEntry?.availability),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _MeetingPersonRow(
            name: controller.state.me.nickname,
            avatar: controller.state.me.avatar,
            entry: myEntry,
            isMe: true,
          ),
          const SizedBox(height: 8),
          _MeetingPersonRow(
            name: controller.state.partner.nickname,
            avatar: controller.state.partner.avatar,
            entry: partnerEntry,
            isMe: false,
          ),
          if (showMeetingDayPanel) ...[
            const SizedBox(height: 14),
            _MeetingDayPanel(
              controller: controller,
              alreadyMeetingDay: meetingDayEntry != null,
              sharedSlots: sharedSlots,
            ),
          ],
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AlagagiFilterPill(
                label: '가능해요',
                selected:
                    controller.state.meetingDraftAvailability ==
                    MeetingAvailability.available,
                onTap: () => controller.setMeetingAvailability(
                  MeetingAvailability.available,
                ),
              ),
              AlagagiFilterPill(
                label: '조율 필요',
                selected:
                    controller.state.meetingDraftAvailability ==
                    MeetingAvailability.maybe,
                onTap: () => controller.setMeetingAvailability(
                  MeetingAvailability.maybe,
                ),
              ),
              AlagagiFilterPill(
                label: '어려워요',
                selected:
                    controller.state.meetingDraftAvailability ==
                    MeetingAvailability.busy,
                onTap: () =>
                    controller.setMeetingAvailability(MeetingAvailability.busy),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('대략 가능한 시간', style: sans(size: 11.5, weight: FontWeight.w800)),
          const SizedBox(height: 7),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final slot in MeetingTimeSlot.values)
                AlagagiFilterPill(
                  key: meetingTimeSlotButtonKey(slot.name),
                  label: meetingTimeSlotLabel(slot),
                  selected: controller.state.meetingDraftTimeSlots.contains(
                    slot,
                  ),
                  onTap: () => controller.toggleMeetingTimeSlot(slot),
                ),
            ],
          ),
          const SizedBox(height: 16),
          _MeetingTimeBlockSection(
            key: ValueKey(
              'meeting-time-block-${controller.selectedMeetingDateKey}',
            ),
            controller: controller,
          ),
          const SizedBox(height: 14),
          MeetingTextField(
            fieldKey: meetingSharedMemoFieldKey,
            label: '상대에게 남길 한마디',
            hint: '예: 19:30 이후면 편해요',
            initialValue: controller.state.meetingDraftSharedMemo,
            maxLength: 120,
            helperText: '시간표에 덧붙일 짧은 조율 메시지예요.',
            onChanged: (value) =>
                controller.updateMeetingDraft(sharedMemo: value),
          ),
          if (controller.state.meetingDraftError != null &&
              controller.state.meetingSaveStatus != SaveStatus.failed) ...[
            const SizedBox(height: 9),
            Text(
              controller.state.meetingDraftError!,
              style: sans(size: 12, color: AlagagiColors.sageDeep),
            ),
          ],
          const SizedBox(height: 14),
          AlagagiPrimaryButton(
            label: '일정 저장하기',
            buttonKey: meetingSubmitButtonKey,
            onPressed: controller.submitMeetingDraft,
            color: AlagagiColors.sageDeep,
          ),
          MeetingSaveStatus(controller: controller),
        ],
      ),
    );
  }
}

class _MeetingDayPanel extends StatelessWidget {
  const _MeetingDayPanel({
    required this.controller,
    required this.alreadyMeetingDay,
    required this.sharedSlots,
  });

  final AlagagiController controller;
  final bool alreadyMeetingDay;
  final Set<MeetingTimeSlot> sharedSlots;

  @override
  Widget build(BuildContext context) {
    final slotLabel = sharedSlots.isEmpty
        ? '겹치는 시간을 확인하고 있어요.'
        : '${sharedSlots.map(meetingTimeSlotLabel).join(', ')}에 서로 괜찮아요.';
    return Container(
      decoration: BoxDecoration(
        color: alreadyMeetingDay ? AlagagiColors.ink : const Color(0xFFF3F6EE),
        border: Border.all(
          color: alreadyMeetingDay
              ? AlagagiColors.ink
              : const Color(0x338A9A7E),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  alreadyMeetingDay ? '만나는 날' : '둘 다 가능한 날이에요',
                  style: serif(
                    context,
                    size: 18,
                    weight: FontWeight.w800,
                    color: alreadyMeetingDay ? Colors.white : AlagagiColors.ink,
                  ),
                ),
              ),
              AlagagiSmallBadge(
                label: alreadyMeetingDay ? '정해짐' : '후보',
                dark: alreadyMeetingDay,
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            alreadyMeetingDay
                ? '시간이나 메모는 정해진 형식 없이 편하게 다시 적어둘 수 있어요.'
                : '$slotLabel 시간은 편한 말로 바로 적어도 괜찮아요.',
            style: sans(
              size: 12,
              height: 1.55,
              color: alreadyMeetingDay
                  ? Colors.white.withValues(alpha: 0.72)
                  : AlagagiColors.muted,
            ),
          ),
          const SizedBox(height: 12),
          MeetingTextField(
            fieldKey: meetingDayTimeFieldKey,
            label: '만나는 시간',
            hint: '예: 19:00-21:00, 저녁 7시쯤',
            initialValue: controller.state.meetingDraftMeetingTimeLabel,
            maxLength: 40,
            helperText: '딱 맞춘 형식이 아니어도 괜찮아요.',
            minLines: 1,
            maxLines: 1,
            onChanged: (value) =>
                controller.updateMeetingDayDraft(timeLabel: value),
          ),
          const SizedBox(height: 9),
          MeetingTextField(
            fieldKey: meetingDayNoteFieldKey,
            label: '만나는 날 메모',
            hint: '예: 장소는 성수 쪽으로 천천히 보기',
            initialValue: controller.state.meetingDraftMeetingNote,
            maxLength: 80,
            helperText: '',
            minLines: 1,
            maxLines: 2,
            onChanged: (value) => controller.updateMeetingDayDraft(note: value),
          ),
          const SizedBox(height: 11),
          AlagagiPrimaryButton(
            label: alreadyMeetingDay ? '만나는 날 수정 저장' : '만나는 날로 저장하기',
            buttonKey: meetingDaySaveButtonKey,
            onPressed: controller.submitMeetingDayDraft,
            color: alreadyMeetingDay
                ? AlagagiColors.sageDeep
                : AlagagiColors.ink,
          ),
          if (alreadyMeetingDay) ...[
            const SizedBox(height: 9),
            SizedBox(
              height: 38,
              child: OutlinedButton.icon(
                onPressed: () => controller.goTo(AlagagiRoute.meetingPlans),
                icon: const Icon(Icons.favorite_border_rounded, size: 16),
                label: const Text('만남에서 계획하기'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.28)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: sans(size: 12.5, weight: FontWeight.w800),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 38,
              child: OutlinedButton.icon(
                key: meetingDayCancelButtonKey,
                onPressed: () => confirmCancelMeetingDay(
                  context,
                  controller,
                  controller.selectedMeetingDateKey,
                ),
                icon: const Icon(Icons.event_busy_rounded, size: 16),
                label: const Text('만남 취소'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFFDDD2),
                  side: const BorderSide(color: Color(0x55FFD6CB)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: sans(size: 12.5, weight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MeetingTimeBlockSection extends StatefulWidget {
  const _MeetingTimeBlockSection({super.key, required this.controller});

  final AlagagiController controller;

  @override
  State<_MeetingTimeBlockSection> createState() =>
      _MeetingTimeBlockSectionState();
}

class _MeetingTimeBlockSectionState extends State<_MeetingTimeBlockSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final blocks = controller.state.meetingDraftTimeBlocks;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F4),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AlagagiColors.softSage,
                  borderRadius: BorderRadius.circular(13),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.event_note_outlined,
                  size: 18,
                  color: AlagagiColors.sageDeep,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '상대에게 보이는 일정',
                      style: sans(size: 12.2, weight: FontWeight.w800),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      blocks.isEmpty
                          ? '약속이나 예약이 있는 날만 선택해서 공유해요.'
                          : '${blocks.length}개의 상세 일정이 공유돼요.',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: sans(size: 11, color: AlagagiColors.muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 34,
                child: OutlinedButton.icon(
                  key: meetingTimeBlockToggleButtonKey,
                  onPressed: () => setState(() => _expanded = !_expanded),
                  icon: Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 16,
                  ),
                  label: Text(_expanded ? '접기' : '작성'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AlagagiColors.sageDeep,
                    side: const BorderSide(color: Color(0x338A9A7E)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    textStyle: sans(size: 11.5, weight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
          if (!_expanded && blocks.isNotEmpty) ...[
            const SizedBox(height: 10),
            for (final block in blocks.take(3))
              _MeetingTimeBlockSummaryRow(block: block),
            if (blocks.length > 3)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '외 ${blocks.length - 3}개 더 있어요.',
                  style: sans(size: 11, color: AlagagiColors.muted),
                ),
              ),
          ],
          if (_expanded) ...[
            const SizedBox(height: 12),
            Text(
              '24시간 표기로 적거나, 자주 쓰는 시간대를 먼저 골라요.',
              style: sans(size: 11.2, color: AlagagiColors.muted),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final preset in _meetingTimePresets)
                  AlagagiFilterPill(
                    key: meetingTimeBlockPresetButtonKey(preset.id),
                    label: preset.label,
                    selected: false,
                    onTap: () => controller.updateMeetingTimeBlockDraft(
                      start: preset.start,
                      end: preset.end,
                      title: preset.title,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: MeetingTextField(
                    fieldKey: meetingTimeBlockStartFieldKey,
                    label: '시작',
                    hint: '14:00',
                    initialValue: controller.state.meetingBlockStartDraft,
                    maxLength: 5,
                    helperText: '예: 09:30',
                    minLines: 1,
                    maxLines: 1,
                    keyboardType: TextInputType.datetime,
                    onChanged: (value) =>
                        controller.updateMeetingTimeBlockDraft(start: value),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: MeetingTextField(
                    fieldKey: meetingTimeBlockEndFieldKey,
                    label: '종료',
                    hint: '16:00',
                    initialValue: controller.state.meetingBlockEndDraft,
                    maxLength: 5,
                    helperText: '예: 18:00',
                    minLines: 1,
                    maxLines: 1,
                    keyboardType: TextInputType.datetime,
                    onChanged: (value) =>
                        controller.updateMeetingTimeBlockDraft(end: value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            MeetingTextField(
              fieldKey: meetingTimeBlockTitleFieldKey,
              label: '일정 내용',
              hint: '예: 병원 예약, 친구 약속',
              initialValue: controller.state.meetingBlockTitleDraft,
              maxLength: 40,
              helperText: '',
              minLines: 1,
              maxLines: 1,
              onChanged: (value) =>
                  controller.updateMeetingTimeBlockDraft(title: value),
            ),
            const SizedBox(height: 9),
            SizedBox(
              height: 38,
              child: OutlinedButton.icon(
                key: meetingTimeBlockAddButtonKey,
                onPressed: controller.addMeetingTimeBlock,
                icon: const Icon(Icons.add_rounded, size: 17),
                label: const Text('상세 일정 추가'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AlagagiColors.sageDeep,
                  side: const BorderSide(color: Color(0x338A9A7E)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: sans(size: 12.5, weight: FontWeight.w800),
                ),
              ),
            ),
            if (blocks.isNotEmpty) ...[
              const SizedBox(height: 10),
              Column(
                children: [
                  for (final block in blocks)
                    _MeetingTimeBlockRow(
                      block: block,
                      onRemove: () =>
                          controller.removeMeetingTimeBlock(block.id),
                    ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _MeetingTimeBlockSummaryRow extends StatelessWidget {
  const _MeetingTimeBlockSummaryRow({required this.block});

  final ScheduleTimeBlock block;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          const Icon(
            Icons.schedule_rounded,
            size: 14,
            color: AlagagiColors.sageDeep,
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              meetingTimeBlockLabel(block),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: sans(size: 11.5, color: const Color(0xFF56544D)),
            ),
          ),
        ],
      ),
    );
  }
}

class _MeetingPersonRow extends StatelessWidget {
  const _MeetingPersonRow({
    required this.name,
    required this.avatar,
    required this.entry,
    required this.isMe,
  });

  final String name;
  final String avatar;
  final ScheduleEntry? entry;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final status = meetingAvailabilityLabel(entry?.availability);
    final sharedMemo = entry?.sharedMemo.trim() ?? '';
    final meetingTimeLabel = entry?.meetingTimeLabel.trim() ?? '';
    final meetingNote = entry?.meetingNote.trim() ?? '';
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F4),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(11),
      child: Row(
        children: [
          _AvatarBubble(label: avatar),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: sans(size: 12.5, weight: FontWeight.w800)),
                const SizedBox(height: 3),
                Text(
                  [
                    status,
                    if (entry != null && entry!.timeSlots.isNotEmpty)
                      entry!.timeSlots.map(meetingTimeSlotLabel).join(', '),
                  ].join(' · '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: sans(
                    size: 11.2,
                    color: AlagagiColors.muted,
                    height: 1.4,
                  ),
                ),
                if (entry != null && entry!.timeBlocks.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  for (final block in entry!.timeBlocks.take(3))
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        meetingTimeBlockLabel(block),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: sans(
                          size: 11,
                          color: const Color(0xFF6B675F),
                          height: 1.35,
                        ),
                      ),
                    ),
                ],
                if (sharedMemo.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  Text(
                    isMe ? '상대에게: $sharedMemo' : sharedMemo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: sans(
                      size: 11,
                      color: const Color(0xFF6B675F),
                      height: 1.35,
                    ),
                  ),
                ],
                if (entry?.isMeetingDay == true) ...[
                  const SizedBox(height: 5),
                  Text(
                    [
                      '만나는 날',
                      if (meetingTimeLabel.isNotEmpty) meetingTimeLabel,
                      if (meetingNote.isNotEmpty) meetingNote,
                    ].join(' · '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: sans(
                      size: 11,
                      color: AlagagiColors.sageDeep,
                      weight: FontWeight.w800,
                      height: 1.35,
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

class _MeetingTimeBlockRow extends StatelessWidget {
  const _MeetingTimeBlockRow({required this.block, required this.onRemove});

  final ScheduleTimeBlock block;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F4),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.fromLTRB(11, 8, 6, 8),
      child: Row(
        children: [
          Icon(Icons.schedule_rounded, size: 16, color: AlagagiColors.sageDeep),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              meetingTimeBlockLabel(block),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: sans(size: 12.2, color: const Color(0xFF56544D)),
            ),
          ),
          SizedBox(
            width: 30,
            height: 30,
            child: IconButton(
              key: meetingTimeBlockRemoveButtonKey(block.id),
              onPressed: onRemove,
              icon: const Icon(Icons.close_rounded, size: 16),
              color: AlagagiColors.muted,
              padding: EdgeInsets.zero,
              tooltip: '삭제',
            ),
          ),
        ],
      ),
    );
  }
}

class _MeetingCandidateMoreButton extends StatelessWidget {
  const _MeetingCandidateMoreButton({
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
        key: meetingCandidateMoreButtonKey,
        onPressed: onPressed,
        icon: Icon(
          expanded ? Icons.keyboard_arrow_up_rounded : Icons.more_horiz_rounded,
          size: 18,
        ),
        label: Text(expanded ? '접기' : '$hiddenCount일 더 보기'),
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

class _MeetingCandidateCard extends StatelessWidget {
  const _MeetingCandidateCard({required this.candidate, required this.onTap});

  final MeetingCandidate candidate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final detailCount =
        (candidate.myEntry?.timeBlocks.length ?? 0) +
        (candidate.partnerEntry?.timeBlocks.length ?? 0);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: meetingCandidateCardKey(candidate.dateKey),
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AlagagiPaperCard(
          radius: 18,
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AlagagiColors.ink,
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                child: Text(
                  DateTime.tryParse(candidate.dateKey)?.day.toString() ?? '',
                  style: sans(
                    size: 15,
                    weight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meetingDateLabel(candidate.dateKey),
                      style: sans(size: 13.5, weight: FontWeight.w800),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      [
                        '${candidate.sharedSlots.map(meetingTimeSlotLabel).join(', ')}에 겹쳐요',
                        if (detailCount > 0) '상세 일정 $detailCount개',
                      ].join(' · '),
                      style: sans(size: 11.5, color: AlagagiColors.muted),
                    ),
                  ],
                ),
              ),
              const AlagagiSmallBadge(label: '보기'),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _TinyDot(color: color),
        const SizedBox(width: 5),
        Text(label, style: sans(size: 10.8, color: AlagagiColors.muted)),
      ],
    );
  }
}

class _TinyDot extends StatelessWidget {
  const _TinyDot({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _AvatarBubble extends StatelessWidget {
  const _AvatarBubble({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        color: AlagagiColors.sagePanel,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(label, style: sans(size: 13)),
    );
  }
}
