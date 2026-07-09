import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/app_shell.dart';
import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/text_editing_sync.dart';
import '../../shared/ui_components.dart';
import '../../shared/ui_style.dart';

enum _BalanceRecordFilter { all, withReason, noReason }

enum _BalanceTab { choose, results, notes }

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key, required this.controller});

  final AlagagiController controller;

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  _BalanceTab _activeTab = _BalanceTab.choose;
  _BalanceRecordFilter _filter = _BalanceRecordFilter.all;
  String? _visibleResultQuestionId;
  final Set<String> _expandedReasonQuestionIds = {};

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final question = controller.activeBalanceQuestion;
    final selected = controller.activeBalanceSelection;
    final partnerChoice = controller.activePartnerBalanceSelection;
    final progressLabel =
        '${controller.state.activeBalanceIndex + 1} / ${controller.balanceQuestions.length}';

    return AlagagiScreenScroll(
      padding: const EdgeInsets.fromLTRB(24, 34, 24, 44),
      bottomNavigation: AlagagiBottomNav(controller: controller),
      children: [
        AlagagiTopBar(
          title: '우리 선택',
          trailing: progressLabel,
          onBack: () => controller.goTo(AlagagiRoute.home),
        ),
        const SizedBox(height: 16),
        _BalanceTodayCard(
          completedCount: controller.balanceCompletedCount,
          revealedCount: controller.balanceRevealedCount,
          totalCount: controller.balanceQuestions.length,
        ),
        const SizedBox(height: 12),
        _BalanceTabBar(
          activeTab: _activeTab,
          resultCount: controller.balanceResolvedCount,
          noteCount: controller.balanceCompletedCount,
          onChanged: (tab) {
            setState(() {
              _activeTab = tab;
              _visibleResultQuestionId = null;
            });
          },
        ),
        const SizedBox(height: 16),
        if (_activeTab == _BalanceTab.choose) ...[
          _BalanceDeckCard(
            question: question,
            selected: selected,
            activeIndex: controller.state.activeBalanceIndex,
            count: controller.balanceQuestions.length,
            onSelect: (optionId) {
              controller.selectBalanceOption(optionId);
              setState(() => _visibleResultQuestionId = null);
            },
          ),
          if (selected != null) ...[
            const SizedBox(height: 14),
            _BalanceReasonCard(
              question: question,
              selected: selected,
              initialReason: controller.activeBalanceReason ?? '',
              expanded: _expandedReasonQuestionIds.contains(question.id),
              onToggle: () {
                setState(() {
                  if (!_expandedReasonQuestionIds.add(question.id)) {
                    _expandedReasonQuestionIds.remove(question.id);
                  }
                });
              },
              onSave: controller.saveBalanceReason,
            ),
            const SizedBox(height: 14),
            _BalanceRevealCard(
              question: question,
              selected: selected,
              partnerChoice: partnerChoice,
              partnerName: controller.state.partner.nickname,
              resultVisible: _visibleResultQuestionId == question.id,
              resultRevealed: controller.isBalanceResultRevealedFor(question),
              onToggleResult: partnerChoice == null
                  ? null
                  : () {
                      if (!controller.isBalanceResultRevealedFor(question)) {
                        controller.revealBalanceResult(question);
                      }
                      setState(() {
                        _visibleResultQuestionId =
                            _visibleResultQuestionId == question.id
                            ? null
                            : question.id;
                      });
                    },
            ),
          ],
          if (selected != null && _visibleResultQuestionId == question.id) ...[
            const SizedBox(height: 14),
            _BalanceResultCard(
              question: question,
              selected: selected,
              partnerChoice: partnerChoice,
              myName: controller.state.me.nickname,
              partnerName: controller.state.partner.nickname,
              onOpenMeetings: () => controller.goTo(AlagagiRoute.meetingPlans),
              onOpenPlaces: () => controller.goTo(AlagagiRoute.places),
              onOpenMusic: () => controller.goTo(AlagagiRoute.music),
            ),
          ],
          const SizedBox(height: 18),
          AlagagiProgressDots(
            activeIndex: controller.state.activeBalanceIndex,
            count: controller.balanceQuestions.length,
          ),
          const SizedBox(height: 16),
          AlagagiPrimaryButton(
            label: selected == null
                ? '먼저 하나를 골라주세요'
                : controller.isLastBalanceQuestion
                ? '완료'
                : '다음 취향',
            onPressed: selected == null ? null : controller.nextBalanceQuestion,
            color: selected == null
                ? const Color(0xFFC7C3BA)
                : AlagagiColors.sageDeep,
          ),
        ] else if (_activeTab == _BalanceTab.results) ...[
          _BalanceResultBoxSection(
            controller: controller,
            expandedResultQuestionId: _visibleResultQuestionId,
            onRevealResult: controller.revealBalanceResult,
            onOpenMeetings: () => controller.goTo(AlagagiRoute.meetingPlans),
            onOpenPlaces: () => controller.goTo(AlagagiRoute.places),
            onOpenMusic: () => controller.goTo(AlagagiRoute.music),
          ),
        ] else ...[
          _BalanceRecordSection(
            controller: controller,
            filter: _filter,
            onFilterChanged: (filter) => setState(() => _filter = filter),
          ),
        ],
      ],
    );
  }
}

class _BalanceTodayCard extends StatelessWidget {
  const _BalanceTodayCard({
    required this.completedCount,
    required this.revealedCount,
    required this.totalCount,
  });

  final int completedCount;
  final int revealedCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final progress = totalCount == 0 ? 0.0 : completedCount / totalCount;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2F2F2B),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'TODAY TASTE',
                style: sans(
                  size: 10.5,
                  color: const Color(0xFFC9C9C2),
                  weight: FontWeight.w700,
                  letterSpacing: 2.2,
                ),
              ),
              const Spacer(),
              Container(
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0x22FFFFFF),
                  borderRadius: BorderRadius.circular(999),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '$completedCount/$totalCount',
                  style: sans(
                    size: 11,
                    color: Colors.white,
                    weight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '둘 중 하나만 골라도\n취향 기록이 쌓여요',
            style: serif(
              context,
              size: 22,
              weight: FontWeight.w800,
              height: 1.45,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            '결과는 내가 열어보기 전까지 조용히 잠겨 있어요.',
            style: sans(
              size: 12.5,
              color: const Color(0xFFE3E2DC),
              height: 1.65,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 7,
              value: progress.clamp(0.0, 1.0).toDouble(),
              color: const Color(0xFFBEE4F7),
              backgroundColor: const Color(0x33FFFFFF),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _BalanceMiniPill(label: '내가 고른 카드 $completedCount개'),
              _BalanceMiniPill(label: '열어본 결과 $revealedCount개'),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceMiniPill extends StatelessWidget {
  const _BalanceMiniPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0x22FFFFFF),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0x22FFFFFF)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(label, style: sans(size: 11, color: const Color(0xFFEFEFE8))),
    );
  }
}

class _BalanceTabBar extends StatelessWidget {
  const _BalanceTabBar({
    required this.activeTab,
    required this.resultCount,
    required this.noteCount,
    required this.onChanged,
  });

  final _BalanceTab activeTab;
  final int resultCount;
  final int noteCount;
  final ValueChanged<_BalanceTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AlagagiColors.paper,
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(5),
      child: Row(
        children: _BalanceTab.values.map((tab) {
          final selected = tab == activeTab;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: _BalanceTabButton(
                tab: tab,
                selected: selected,
                count: switch (tab) {
                  _BalanceTab.choose => null,
                  _BalanceTab.results => resultCount,
                  _BalanceTab.notes => noteCount,
                },
                onTap: () => onChanged(tab),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _BalanceTabButton extends StatelessWidget {
  const _BalanceTabButton({
    required this.tab,
    required this.selected,
    required this.count,
    required this.onTap,
  });

  final _BalanceTab tab;
  final bool selected;
  final int? count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.white : AlagagiColors.muted;
    final label = _balanceTabLabel(tab);
    final count = this.count;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: balanceTabButtonKey(tab.name),
        borderRadius: BorderRadius.circular(14),
        onTap: selected ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF2F2F2B) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_balanceTabIcon(tab), size: 15, color: color),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: sans(size: 12, color: color, weight: FontWeight.w800),
                ),
              ),
              if (count != null) ...[
                const SizedBox(width: 4),
                Text(
                  '$count',
                  style: sans(
                    size: 10.5,
                    color: color.withValues(alpha: .82),
                    weight: FontWeight.w800,
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

class _BalanceDeckCard extends StatelessWidget {
  const _BalanceDeckCard({
    required this.question,
    required this.selected,
    required this.activeIndex,
    required this.count,
    required this.onSelect,
  });

  final BalanceQuestion question;
  final String? selected;
  final int activeIndex;
  final int count;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: balanceDeckKey,
      decoration: BoxDecoration(
        color: AlagagiColors.paper,
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AlagagiColors.softSage,
                  borderRadius: BorderRadius.circular(999),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '취향 카드 ${activeIndex + 1}',
                  style: sans(
                    size: 11,
                    color: AlagagiColors.sageDeep,
                    weight: FontWeight.w800,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${activeIndex + 1} / $count',
                style: sans(
                  size: 11.5,
                  color: AlagagiColors.muted,
                  weight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            question.prompt,
            textAlign: TextAlign.center,
            style: serif(
              context,
              size: 22,
              weight: FontWeight.w800,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            selected == null
                ? '지금 더 끌리는 쪽을 바로 골라주세요.'
                : '선택한 카드를 한 번 더 누르면 취소돼요.',
            textAlign: TextAlign.center,
            style: sans(size: 12, color: AlagagiColors.muted, height: 1.5),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 188,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _BalanceDeckOption(
                        option: question.left,
                        selectedByMe: selected == question.left.id,
                        onTap: () => onSelect(question.left.id),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _BalanceDeckOption(
                        option: question.right,
                        selectedByMe: selected == question.right.id,
                        onTap: () => onSelect(question.right.id),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2F2F2B),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'VS',
                    style: serif(
                      context,
                      size: 13,
                      weight: FontWeight.w800,
                      color: Colors.white,
                    ),
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

class _BalanceDeckOption extends StatelessWidget {
  const _BalanceDeckOption({
    required this.option,
    required this.selectedByMe,
    required this.onTap,
  });

  final BalanceOption option;
  final bool selectedByMe;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          constraints: const BoxConstraints(minHeight: 178),
          decoration: BoxDecoration(
            color: selectedByMe
                ? const Color(0xFFEAF7FD)
                : const Color(0xFFF5FCFF),
            border: Border.all(
              color: selectedByMe ? AlagagiColors.sageDeep : AlagagiColors.line,
              width: selectedByMe ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _BalanceOptionIcon(
                    optionId: option.id,
                    selected: selectedByMe,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.label,
                    style: serif(
                      context,
                      size: 18,
                      weight: FontWeight.w800,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    selectedByMe ? '다시 누르면 취소' : '끌리는 쪽 고르기',
                    style: sans(
                      size: 11.5,
                      color: AlagagiColors.muted,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 25,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selectedByMe
                        ? const Color(0xFF2F2F2B)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 9),
                  child: Text(
                    selectedByMe ? '취소 가능' : '고르기',
                    style: sans(
                      size: 10.5,
                      color: selectedByMe
                          ? Colors.white
                          : AlagagiColors.sageDeep,
                      weight: FontWeight.w800,
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

class _BalanceReasonCard extends StatelessWidget {
  const _BalanceReasonCard({
    required this.question,
    required this.selected,
    required this.initialReason,
    required this.expanded,
    required this.onToggle,
    required this.onSave,
  });

  final BalanceQuestion question;
  final String selected;
  final String initialReason;
  final bool expanded;
  final VoidCallback onToggle;
  final ValueChanged<String> onSave;

  @override
  Widget build(BuildContext context) {
    final selectedLabel = _balanceOptionLabel(question, selected);
    final hasReason = initialReason.trim().isNotEmpty;
    return Container(
      decoration: BoxDecoration(
        color: AlagagiColors.paper,
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(22),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: hasReason
                      ? AlagagiColors.softSage
                      : const Color(0xFFF5FCFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(
                  hasReason
                      ? Icons.check_circle_outline_rounded
                      : Icons.edit_note_rounded,
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
                      '선택 이유 한 줄',
                      style: serif(context, size: 16, weight: FontWeight.w800),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      hasReason ? '저장된 이유가 있어요.' : '이유 없이 넘어가도 괜찮아요.',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: sans(size: 11.8, color: AlagagiColors.muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 34,
                child: OutlinedButton.icon(
                  key: balanceReasonToggleButtonKey,
                  onPressed: onToggle,
                  icon: Icon(
                    expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 16,
                  ),
                  label: Text(
                    expanded
                        ? '접기'
                        : hasReason
                        ? '수정'
                        : '쓰기',
                  ),
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
          if (!expanded && hasReason) ...[
            const SizedBox(height: 10),
            Text(
              initialReason.trim(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: sans(
                size: 12.5,
                color: const Color(0xFF5F5D57),
                height: 1.5,
              ),
            ),
          ],
          if (expanded) ...[
            const SizedBox(height: 12),
            Text(
              '$selectedLabel 쪽을 고른 이유를 짧게 남기면 나중에 더 잘 기억나요.',
              style: sans(size: 12, color: AlagagiColors.muted, height: 1.55),
            ),
            const SizedBox(height: 12),
            _BalanceReasonField(
              syncKey: question.id,
              initialValue: initialReason,
              onSave: onSave,
            ),
          ],
        ],
      ),
    );
  }
}

class _BalanceReasonField extends StatefulWidget {
  const _BalanceReasonField({
    required this.syncKey,
    required this.initialValue,
    required this.onSave,
  });

  final String syncKey;
  final String initialValue;
  final ValueChanged<String> onSave;

  @override
  State<_BalanceReasonField> createState() => _BalanceReasonFieldState();
}

class _BalanceReasonFieldState extends State<_BalanceReasonField> {
  late final ImeSafeTextEditingController _controller;
  late final FocusNode _focusNode;
  late final VoidCallback _detachFocusDispatch;
  Timer? _saveDebounce;
  late String _lastSavedValue;
  bool _hasPendingSave = false;

  @override
  void initState() {
    super.initState();
    _controller = ImeSafeTextEditingController(
      text: widget.initialValue,
      onCommittedChanged: _scheduleSave,
    );
    _focusNode = FocusNode();
    _detachFocusDispatch = dispatchTextOnFocusLost(_controller, _focusNode);
    _lastSavedValue = widget.initialValue.trim();
  }

  @override
  void didUpdateWidget(covariant _BalanceReasonField oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.onCommittedChanged = _scheduleSave;
    if ((oldWidget.syncKey != widget.syncKey ||
            oldWidget.initialValue != widget.initialValue) &&
        _controller.text != widget.initialValue) {
      final synced = _controller.syncText(
        widget.initialValue,
        focusNode: _focusNode,
        force:
            oldWidget.syncKey != widget.syncKey || widget.initialValue.isEmpty,
      );
      if (synced) {
        _saveDebounce?.cancel();
        _lastSavedValue = widget.initialValue.trim();
        _hasPendingSave = false;
      }
    }
  }

  @override
  void dispose() {
    _saveDebounce?.cancel();
    _detachFocusDispatch();
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _scheduleSave(String value) {
    _saveDebounce?.cancel();
    if (value.trim() == _lastSavedValue) {
      if (_hasPendingSave) {
        setState(() => _hasPendingSave = false);
      }
      return;
    }
    if (!_hasPendingSave) {
      setState(() => _hasPendingSave = true);
    }
    _saveDebounce = Timer(const Duration(milliseconds: 650), _flushSave);
  }

  void _flushSave() {
    final value = _controller.text;
    final trimmed = value.trim();
    if (trimmed == _lastSavedValue) {
      if (mounted) {
        setState(() => _hasPendingSave = false);
      }
      return;
    }
    widget.onSave(value);
    if (mounted) {
      setState(() {
        _lastSavedValue = trimmed;
        _hasPendingSave = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasSavedReason = _lastSavedValue.isNotEmpty;
    final statusText = _hasPendingSave
        ? '잠시 후 자동 저장돼요'
        : hasSavedReason
        ? '이유가 자동 저장됐어요'
        : '이유 없이 선택만 저장해도 괜찮아요';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          key: balanceReasonFieldKey,
          controller: _controller,
          focusNode: _focusNode,
          minLines: 1,
          maxLines: 2,
          maxLength: 80,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) {
            _saveDebounce?.cancel();
            _controller.dispatchCurrentText();
            _flushSave();
          },
          decoration: InputDecoration(
            counterText: '',
            hintText: '예: 요즘 조용한 곳이 더 끌려요',
            hintStyle: sans(size: 12, color: const Color(0xFFAAA69A)),
            filled: true,
            fillColor: const Color(0xFFF5FCFF),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AlagagiColors.line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AlagagiColors.line),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AlagagiColors.sageDeep),
            ),
          ),
          style: sans(size: 13, color: const Color(0xFF3A3934), height: 1.45),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Icon(
              _hasPendingSave
                  ? Icons.more_horiz_rounded
                  : Icons.check_circle_outline_rounded,
              size: 16,
              color: _hasPendingSave
                  ? AlagagiColors.muted
                  : AlagagiColors.sageDeep,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                statusText,
                style: sans(
                  size: 11.5,
                  color: AlagagiColors.muted,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BalanceRevealCard extends StatelessWidget {
  const _BalanceRevealCard({
    required this.question,
    required this.selected,
    required this.partnerChoice,
    required this.partnerName,
    required this.resultVisible,
    required this.resultRevealed,
    required this.onToggleResult,
  });

  final BalanceQuestion question;
  final String selected;
  final String? partnerChoice;
  final String partnerName;
  final bool resultVisible;
  final bool resultRevealed;
  final VoidCallback? onToggleResult;

  @override
  Widget build(BuildContext context) {
    final selectedLabel = _balanceOptionLabel(question, selected);
    final hasPartnerChoice = partnerChoice != null;
    return Container(
      decoration: BoxDecoration(
        color: AlagagiColors.paper,
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(22),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: hasPartnerChoice
                      ? AlagagiColors.softSage
                      : const Color(0xFFF5FCFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(
                  hasPartnerChoice
                      ? Icons.lock_open_rounded
                      : Icons.hourglass_empty_rounded,
                  size: 18,
                  color: AlagagiColors.sageDeep,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '내 선택이 저장됐어요',
                      style: serif(context, size: 16, weight: FontWeight.w800),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$selectedLabel 쪽으로 남겨둘게요.',
                      style: sans(
                        size: 12,
                        color: AlagagiColors.muted,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            hasPartnerChoice
                ? resultRevealed
                      ? '이미 열어본 결과예요. 원할 때 다시 펼쳐볼 수 있어요.'
                      : '서로의 선택이 준비됐어요. 결과는 버튼을 눌렀을 때만 열립니다.'
                : '$partnerName님 선택이 생기면 결과가 열려요. 지금은 내 취향만 조용히 저장해둘게요.',
            style: sans(size: 12.5, color: AlagagiColors.muted, height: 1.6),
          ),
          if (hasPartnerChoice) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 42,
              child: OutlinedButton(
                key: balanceResultToggleButtonKey,
                onPressed: onToggleResult,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AlagagiColors.sageDeep,
                  side: const BorderSide(color: Color(0x338A9A7E)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  resultVisible
                      ? '결과 접기'
                      : resultRevealed
                      ? '결과 다시 보기'
                      : '결과 열어보기',
                  style: sans(size: 13, weight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BalanceResultCard extends StatelessWidget {
  const _BalanceResultCard({
    required this.question,
    required this.selected,
    required this.partnerChoice,
    required this.myName,
    required this.partnerName,
    required this.onOpenMeetings,
    required this.onOpenPlaces,
    required this.onOpenMusic,
  });

  final BalanceQuestion question;
  final String? selected;
  final String? partnerChoice;
  final String myName;
  final String partnerName;
  final VoidCallback onOpenMeetings;
  final VoidCallback onOpenPlaces;
  final VoidCallback onOpenMusic;

  @override
  Widget build(BuildContext context) {
    final selected = this.selected;
    final partnerChoice = this.partnerChoice;
    final hasPartnerChoice = selected != null && partnerChoice != null;
    final sameChoice = hasPartnerChoice && selected == partnerChoice;
    final title = selected == null
        ? '오늘의 카드를 골라볼까요?'
        : partnerChoice == null
        ? '$partnerName님 선택을 기다리는 중'
        : sameChoice
        ? '같은 취향이 열렸어요'
        : '다른 취향이 이야기로 남았어요';
    final body = selected == null
        ? '내가 먼저 고르기 전에는 상대 선택을 보여주지 않아요.'
        : partnerChoice == null
        ? '$partnerName님 선택이 생기면 결과가 열려요. 지금은 내 취향만 조용히 저장해둘게요.'
        : sameChoice
        ? '둘 다 ${_balanceOptionLabel(question, selected)} 쪽을 골랐어요. 다음 만남이나 장소를 정할 때 바로 참고하기 좋아요.'
        : '$myName님은 ${_balanceOptionLabel(question, selected)}, $partnerName님은 ${_balanceOptionLabel(question, partnerChoice)} 쪽이에요. 서로 다른 선택도 자연스러운 대화거리가 됩니다.';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2F2F2B),
        borderRadius: BorderRadius.circular(22),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            selected == null
                ? 'READY'
                : partnerChoice == null
                ? 'WAITING'
                : 'RESULT',
            style: sans(
              size: 10.5,
              color: const Color(0xFFC9C9C2),
              weight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: serif(
              context,
              size: 19,
              weight: FontWeight.w800,
              color: Colors.white,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: sans(size: 13, color: const Color(0xFFF2F1EB), height: 1.65),
          ),
          if (selected != null) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _BalanceResultChoice(
                    label: '$myName 선택',
                    value: _balanceOptionLabel(question, selected),
                    highlighted: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _BalanceResultChoice(
                    label: '$partnerName 선택',
                    value: partnerChoice == null
                        ? '아직 기다리는 중'
                        : _balanceOptionLabel(question, partnerChoice),
                    highlighted: sameChoice,
                  ),
                ),
              ],
            ),
          ],
          if (hasPartnerChoice) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _BalanceRouteChip(
                  icon: Icons.event_note_outlined,
                  label: '만남 계획',
                  onTap: onOpenMeetings,
                ),
                _BalanceRouteChip(
                  icon: Icons.place_outlined,
                  label: '장소 보기',
                  onTap: onOpenPlaces,
                ),
                _BalanceRouteChip(
                  icon: Icons.music_note_outlined,
                  label: '음악 노트',
                  onTap: onOpenMusic,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _BalanceResultChoice extends StatelessWidget {
  const _BalanceResultChoice({
    required this.label,
    required this.value,
    required this.highlighted,
  });

  final String label;
  final String value;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: highlighted ? const Color(0x335B9DBF) : const Color(0x14FFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x18FFFFFF)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: sans(size: 10.5, color: const Color(0xFFC9C9C2)),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: sans(
              size: 12.5,
              color: Colors.white,
              weight: FontWeight.w800,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceRouteChip extends StatelessWidget {
  const _BalanceRouteChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0x1FFFFFFF),
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 11),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15, color: const Color(0xFFEFEFE8)),
              const SizedBox(width: 5),
              Text(
                label,
                style: sans(
                  size: 11.5,
                  color: const Color(0xFFEFEFE8),
                  weight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BalanceResultBoxSection extends StatelessWidget {
  const _BalanceResultBoxSection({
    required this.controller,
    required this.expandedResultQuestionId,
    required this.onRevealResult,
    required this.onOpenMeetings,
    required this.onOpenPlaces,
    required this.onOpenMusic,
  });

  final AlagagiController controller;
  final String? expandedResultQuestionId;
  final ValueChanged<BalanceQuestion> onRevealResult;
  final VoidCallback onOpenMeetings;
  final VoidCallback onOpenPlaces;
  final VoidCallback onOpenMusic;

  @override
  Widget build(BuildContext context) {
    final items = controller.balanceQuestions.where((question) {
      return controller.balanceSelectionFor(question) != null;
    }).toList();
    final revealableCount = items.where((question) {
      return controller.isBalanceResultReadyFor(question) &&
          !controller.isBalanceResultRevealedFor(question);
    }).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '결과함',
                style: serif(context, size: 17, weight: FontWeight.w800),
              ),
            ),
            Text(
              revealableCount == 0 ? '잠긴 결과 없음' : '열 수 있음 $revealableCount개',
              style: sans(size: 11.5, color: AlagagiColors.muted),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '서로의 선택은 내가 직접 열어본 카드에서만 보여요.',
          style: sans(size: 12, color: AlagagiColors.muted, height: 1.5),
        ),
        const SizedBox(height: 10),
        if (items.isEmpty)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AlagagiColors.paper,
              border: Border.all(color: AlagagiColors.line),
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.all(15),
            child: Text(
              '아직 결과함에 들어간 카드가 없어요. 오늘의 취향을 하나 고르면 결과 상태를 여기서 볼 수 있습니다.',
              style: sans(size: 12.5, color: AlagagiColors.muted, height: 1.6),
            ),
          )
        else
          Column(
            children: items.map((question) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _BalanceResultBoxTile(
                  question: question,
                  selected: controller.balanceSelectionFor(question)!,
                  partnerChoice: controller.partnerBalanceSelectionFor(
                    question,
                  ),
                  revealed: controller.isBalanceResultRevealedFor(question),
                  suppressInlineResult: expandedResultQuestionId == question.id,
                  myName: controller.state.me.nickname,
                  partnerName: controller.state.partner.nickname,
                  onReveal: () => onRevealResult(question),
                  onOpenMeetings: onOpenMeetings,
                  onOpenPlaces: onOpenPlaces,
                  onOpenMusic: onOpenMusic,
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}

class _BalanceResultBoxTile extends StatelessWidget {
  const _BalanceResultBoxTile({
    required this.question,
    required this.selected,
    required this.partnerChoice,
    required this.revealed,
    required this.suppressInlineResult,
    required this.myName,
    required this.partnerName,
    required this.onReveal,
    required this.onOpenMeetings,
    required this.onOpenPlaces,
    required this.onOpenMusic,
  });

  final BalanceQuestion question;
  final String selected;
  final String? partnerChoice;
  final bool revealed;
  final bool suppressInlineResult;
  final String myName;
  final String partnerName;
  final VoidCallback onReveal;
  final VoidCallback onOpenMeetings;
  final VoidCallback onOpenPlaces;
  final VoidCallback onOpenMusic;

  @override
  Widget build(BuildContext context) {
    final ready = partnerChoice != null;
    final statusLabel = !ready
        ? '기다림'
        : revealed
        ? '열어본 결과'
        : '결과 잠금';
    final statusColor = revealed
        ? const Color(0xFF2F2F2B)
        : ready
        ? const Color(0xFFEAF7FD)
        : const Color(0xFFF5FCFF);
    final statusTextColor = revealed
        ? Colors.white
        : ready
        ? const Color(0xFF315F7A)
        : AlagagiColors.muted;
    final copy = !ready
        ? '$partnerName님 선택을 기다리는 중이에요. 내 선택은 조용히 저장돼 있어요.'
        : revealed
        ? '이미 열어본 결과예요. 비교 내용과 다음 액션을 다시 볼 수 있어요.'
        : '서로의 선택이 준비됐어요. 결과를 열기 전까지 비교 내용은 숨겨둘게요.';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AlagagiColors.paper,
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  question.prompt,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: sans(
                    size: 13,
                    color: const Color(0xFF45443F),
                    weight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(999),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 9),
                child: Text(
                  statusLabel,
                  style: sans(
                    size: 10.5,
                    color: statusTextColor,
                    weight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            copy,
            style: sans(size: 11.8, color: AlagagiColors.muted, height: 1.55),
          ),
          if (!revealed) ...[
            const SizedBox(height: 9),
            _BalanceRecordValue(
              label: '내 선택',
              value: _balanceOptionLabel(question, selected),
            ),
          ],
          if (ready && !revealed) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: OutlinedButton(
                onPressed: onReveal,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AlagagiColors.sageDeep,
                  side: const BorderSide(color: Color(0x338A9A7E)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  '결과 열어보기',
                  style: sans(size: 12.5, weight: FontWeight.w800),
                ),
              ),
            ),
          ],
          if (revealed && partnerChoice != null && !suppressInlineResult) ...[
            const SizedBox(height: 11),
            _BalanceInlineResultSummary(
              question: question,
              selected: selected,
              partnerChoice: partnerChoice!,
              myName: myName,
              partnerName: partnerName,
              onOpenMeetings: onOpenMeetings,
              onOpenPlaces: onOpenPlaces,
              onOpenMusic: onOpenMusic,
            ),
          ] else if (revealed && suppressInlineResult) ...[
            const SizedBox(height: 9),
            _BalanceRecordValue(label: '상세', value: '위에 열려 있어요'),
          ],
        ],
      ),
    );
  }
}

class _BalanceInlineResultSummary extends StatelessWidget {
  const _BalanceInlineResultSummary({
    required this.question,
    required this.selected,
    required this.partnerChoice,
    required this.myName,
    required this.partnerName,
    required this.onOpenMeetings,
    required this.onOpenPlaces,
    required this.onOpenMusic,
  });

  final BalanceQuestion question;
  final String selected;
  final String partnerChoice;
  final String myName;
  final String partnerName;
  final VoidCallback onOpenMeetings;
  final VoidCallback onOpenPlaces;
  final VoidCallback onOpenMusic;

  @override
  Widget build(BuildContext context) {
    final sameChoice = selected == partnerChoice;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2F2F2B),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sameChoice ? '같은 취향이 열렸어요' : '다른 취향이 이야기로 남았어요',
            style: serif(
              context,
              size: 15,
              weight: FontWeight.w800,
              color: Colors.white,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              Expanded(
                child: _BalanceResultChoice(
                  label: '$myName 선택',
                  value: _balanceOptionLabel(question, selected),
                  highlighted: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _BalanceResultChoice(
                  label: '$partnerName 선택',
                  value: _balanceOptionLabel(question, partnerChoice),
                  highlighted: sameChoice,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _BalanceRouteChip(
                icon: Icons.event_note_outlined,
                label: '만남 계획',
                onTap: onOpenMeetings,
              ),
              _BalanceRouteChip(
                icon: Icons.place_outlined,
                label: '장소 보기',
                onTap: onOpenPlaces,
              ),
              _BalanceRouteChip(
                icon: Icons.music_note_outlined,
                label: '음악 노트',
                onTap: onOpenMusic,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceRecordSection extends StatelessWidget {
  const _BalanceRecordSection({
    required this.controller,
    required this.filter,
    required this.onFilterChanged,
  });

  final AlagagiController controller;
  final _BalanceRecordFilter filter;
  final ValueChanged<_BalanceRecordFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final records = controller.balanceQuestions.where((question) {
      final selected = controller.balanceSelectionFor(question);
      if (selected == null) {
        return false;
      }
      final hasReason = (controller.balanceReasonFor(question) ?? '')
          .trim()
          .isNotEmpty;
      return switch (filter) {
        _BalanceRecordFilter.all => true,
        _BalanceRecordFilter.withReason => hasReason,
        _BalanceRecordFilter.noReason => !hasReason,
      };
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '내 취향 노트',
                style: serif(context, size: 17, weight: FontWeight.w800),
              ),
            ),
            Text(
              '${records.length}개',
              style: sans(size: 11.5, color: AlagagiColors.muted),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _BalanceRecordFilter.values.map((item) {
              final selected = item == filter;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _BalanceFilterChip(
                  filter: item,
                  selected: selected,
                  onTap: () => onFilterChanged(item),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 10),
        if (records.isEmpty)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AlagagiColors.paper,
              border: Border.all(color: AlagagiColors.line),
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.all(15),
            child: Text(
              _emptyRecordCopy(filter),
              style: sans(size: 12.5, color: AlagagiColors.muted, height: 1.6),
            ),
          )
        else
          Column(
            children: records.map((question) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _BalanceRecordTile(
                  question: question,
                  selected: controller.balanceSelectionFor(question)!,
                  reason: controller.balanceReasonFor(question),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}

class _BalanceFilterChip extends StatelessWidget {
  const _BalanceFilterChip({
    required this.filter,
    required this.selected,
    required this.onTap,
  });

  final _BalanceRecordFilter filter;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: balanceRecordFilterButtonKey(filter.name),
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF2F2F2B) : AlagagiColors.paper,
            border: Border.all(
              color: selected ? const Color(0xFF2F2F2B) : AlagagiColors.line,
            ),
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            _filterLabel(filter),
            style: sans(
              size: 12,
              color: selected ? Colors.white : AlagagiColors.muted,
              weight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _BalanceRecordTile extends StatelessWidget {
  const _BalanceRecordTile({
    required this.question,
    required this.selected,
    required this.reason,
  });

  final BalanceQuestion question;
  final String selected;
  final String? reason;

  @override
  Widget build(BuildContext context) {
    final reason = this.reason?.trim();
    final hasReason = reason != null && reason.isNotEmpty;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AlagagiColors.paper,
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  question.prompt,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: sans(
                    size: 13,
                    color: const Color(0xFF45443F),
                    weight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5FCFF),
                  borderRadius: BorderRadius.circular(999),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 9),
                child: Text(
                  hasReason ? '메모 있음' : '선택만 저장',
                  style: sans(
                    size: 10.5,
                    color: AlagagiColors.muted,
                    weight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              _BalanceRecordValue(
                label: '내 선택',
                value: _balanceOptionLabel(question, selected),
              ),
              const _BalanceRecordValue(label: '결과', value: '결과함에서만 공개'),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            hasReason ? reason : '아직 이유를 남기지 않았어요.',
            style: sans(size: 11.5, color: AlagagiColors.muted, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _BalanceRecordValue extends StatelessWidget {
  const _BalanceRecordValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5FCFF),
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      child: Text(
        '$label · $value',
        style: sans(
          size: 11,
          color: const Color(0xFF57564E),
          weight: FontWeight.w700,
        ),
      ),
    );
  }
}

String _balanceOptionLabel(BalanceQuestion question, String? optionId) {
  if (optionId == question.left.id) {
    return question.left.label;
  }
  if (optionId == question.right.id) {
    return question.right.label;
  }
  return '아직 선택 전';
}

String _balanceTabLabel(_BalanceTab tab) {
  return switch (tab) {
    _BalanceTab.choose => '오늘',
    _BalanceTab.results => '결과함',
    _BalanceTab.notes => '내 노트',
  };
}

IconData _balanceTabIcon(_BalanceTab tab) {
  return switch (tab) {
    _BalanceTab.choose => Icons.style_outlined,
    _BalanceTab.results => Icons.lock_open_outlined,
    _BalanceTab.notes => Icons.sticky_note_2_outlined,
  };
}

String _filterLabel(_BalanceRecordFilter filter) {
  return switch (filter) {
    _BalanceRecordFilter.all => '전체',
    _BalanceRecordFilter.withReason => '이유 있음',
    _BalanceRecordFilter.noReason => '메모 없음',
  };
}

String _emptyRecordCopy(_BalanceRecordFilter filter) {
  return switch (filter) {
    _BalanceRecordFilter.all => '아직 남긴 취향이 없어요. 오늘의 카드를 하나 골라보면 기록이 시작됩니다.',
    _BalanceRecordFilter.withReason => '아직 이유를 남긴 취향이 없어요. 짧게 한 줄만 적어도 충분합니다.',
    _BalanceRecordFilter.noReason => '메모 없이 저장된 취향이 없어요.',
  };
}

class _BalanceOptionIcon extends StatelessWidget {
  const _BalanceOptionIcon({required this.optionId, required this.selected});

  final String optionId;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AlagagiSymbolMark(
      icon: _iconForOption(optionId),
      size: 58,
      iconSize: 28,
      tone: selected ? AlagagiColors.skyPanel : AlagagiColors.skySoft,
      iconColor: selected ? const Color(0xFF315F7A) : const Color(0xFF5B7D91),
      radius: 19,
      selected: selected,
    );
  }

  IconData _iconForOption(String id) {
    return switch (id) {
      'sea' => Icons.water_drop_outlined,
      'forest' || 'mountain' => Icons.landscape_outlined,
      'home' => Icons.home_outlined,
      'walk' || 'outside' => Icons.directions_walk_rounded,
      'quiet' => Icons.local_cafe_outlined,
      'dessert' => Icons.cake_outlined,
      'calm' => Icons.movie_outlined,
      'funny' => Icons.mood_outlined,
      'brunch' || 'familiar' => Icons.restaurant_outlined,
      'evening' => Icons.nights_stay_outlined,
      'reserved' => Icons.event_available_outlined,
      'spontaneous' || 'new' => Icons.explore_outlined,
      'deep' => Icons.forum_outlined,
      'light' => Icons.chat_bubble_outline_rounded,
      _ => Icons.tune_rounded,
    };
  }
}
