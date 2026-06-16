import 'package:flutter/material.dart';

import '../../app/app_shell.dart';
import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/readable_detail_sheet.dart';
import '../../shared/ui_components.dart';
import '../../shared/ui_style.dart';

class ProfileCardScreen extends StatefulWidget {
  const ProfileCardScreen({super.key, required this.controller});

  final AlagagiController controller;

  @override
  State<ProfileCardScreen> createState() => _ProfileCardScreenState();
}

class _ProfileCardScreenState extends State<ProfileCardScreen> {
  String? _editingSlotId;
  String _slotDraft = '';
  String _selectedCategory = '전체';
  bool _customCardDraftVisible = false;

  AlagagiController get controller => widget.controller;

  void _startEditing(ProfileSlot slot) {
    setState(() {
      _editingSlotId = slot.id;
      _slotDraft = slot.value ?? '';
    });
  }

  void _cancelEditing() {
    setState(() {
      _editingSlotId = null;
      _slotDraft = '';
    });
  }

  void _saveSlot(ProfileSlot slot, [String? draftOverride]) {
    final value = (draftOverride ?? _slotDraft).trim();
    if (value.isEmpty) {
      return;
    }
    controller.fillProfileSlot(slot.id, value);
    setState(() {
      _editingSlotId = null;
      _slotDraft = '';
    });
  }

  void _skipSlot(ProfileSlot slot) {
    controller.skipProfileSlot(slot.id);
    if (_editingSlotId == slot.id) {
      _cancelEditing();
    }
  }

  void _hideSlot(ProfileSlot slot) {
    controller.hideProfileSlot(slot.id);
    if (_editingSlotId == slot.id) {
      _cancelEditing();
    }
  }

  void _restoreSlot(ProfileSlot slot) {
    controller.restoreProfileSlot(slot.id);
  }

  void _deleteSlot(ProfileSlot slot) {
    controller.deleteCustomProfileSlot(slot.id);
    if (_editingSlotId == slot.id) {
      _cancelEditing();
    }
  }

  String? _saveCustomCard(String title, String body, String category) {
    final error = controller.addCustomProfileSlot(
      title: title,
      value: body,
      category: category,
    );
    if (error == null) {
      setState(() => _customCardDraftVisible = false);
    }
    return error;
  }

  void _selectCategory(String category) {
    setState(() => _selectedCategory = category);
  }

  @override
  Widget build(BuildContext context) {
    final card = controller.activeProfileCard;
    final isMine = card.profile.isMe;
    final selectedSlot = isMine && _editingSlotId != null
        ? _slotById(card.slots, _editingSlotId!)
        : null;
    final filteredSlots = _filteredSlots(card.slots);
    final filledSlots = _filledSlots(filteredSlots);
    final pendingSlots = _pendingSlots(filteredSlots);
    final recommendedSlot = _recommendedSlot(card);
    return AlagagiScreenScroll(
      bottomNavigation: AlagagiBottomNav(controller: controller),
      children: [
        AlagagiTopBar(
          title: '소개 카드',
          trailing: '',
          onBack: () => controller.goTo(AlagagiRoute.home),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AlagagiSegmentButton(
                label: '${controller.state.partner.nickname}님 카드',
                selected:
                    controller.state.profileCardTab == ProfileCardTab.partner,
                onTap: () {
                  _cancelEditing();
                  controller.setProfileCardTab(ProfileCardTab.partner);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AlagagiSegmentButton(
                label: '내 카드',
                selected: controller.state.profileCardTab == ProfileCardTab.me,
                onTap: () {
                  _cancelEditing();
                  controller.setProfileCardTab(ProfileCardTab.me);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _ProfileSummaryCard(card: card),
        if (isMine) ...[
          const SizedBox(height: 14),
          _ProfileCustomCardEntry(
            customCount: card.customCount,
            onTap: () {
              _cancelEditing();
              setState(() => _customCardDraftVisible = true);
            },
          ),
          if (_customCardDraftVisible) ...[
            const SizedBox(height: 12),
            _ProfileCustomCardPanel(
              onSave: _saveCustomCard,
              onCancel: () => setState(() => _customCardDraftVisible = false),
            ),
          ],
          const SizedBox(height: 16),
          _ProfileCategoryChips(
            selectedCategory: _selectedCategory,
            onSelected: _selectCategory,
          ),
          if (selectedSlot != null) ...[
            const SizedBox(height: 14),
            _ProfileEditorPanel(
              slot: selectedSlot,
              draft: _slotDraft,
              onChanged: (value) => setState(() => _slotDraft = value),
              onSave: (value) => _saveSlot(selectedSlot, value),
              onCancel: _cancelEditing,
            ),
          ],
          const SizedBox(height: 18),
          _ProfileSectionHeader(
            title: _selectedCategory == '전체'
                ? '작성한 카드'
                : '$_selectedCategory에 남긴 카드',
            meta: filledSlots.isEmpty ? '아직 비어 있어요' : '최근 카드 먼저',
          ),
          const SizedBox(height: 10),
          _ProfileSlotList(
            slots: filledSlots,
            editingSlotId: _editingSlotId,
            emptyText: _selectedCategory == '전체'
                ? '아직 작성한 카드가 없어요. 편한 질문 하나부터 남겨봐요.'
                : '이 분류에는 아직 작성한 카드가 없어요.',
            onEdit: _startEditing,
            onSkip: _skipSlot,
            onHide: _hideSlot,
            onRestore: _restoreSlot,
            onDelete: _deleteSlot,
          ),
          const SizedBox(height: 18),
          _ProfileSectionHeader(
            title: '편한 질문',
            meta: pendingSlots.isEmpty
                ? '모두 정리됨'
                : '${pendingSlots.length}개 남음',
          ),
          const SizedBox(height: 10),
          _ProfileRecommendCard(
            slot: recommendedSlot,
            onUse: _startEditing,
            onSkip: _skipSlot,
          ),
          if (pendingSlots.isNotEmpty) ...[
            const SizedBox(height: 10),
            _ProfileSlotGrid(
              slots: pendingSlots,
              editingSlotId: _editingSlotId,
              onEdit: _startEditing,
              onSkip: _skipSlot,
              onHide: _hideSlot,
              onRestore: _restoreSlot,
              onDelete: _deleteSlot,
            ),
          ],
          if (_hiddenSlots(card.slots).isNotEmpty) ...[
            const SizedBox(height: 16),
            _ProfileHiddenSlotsPanel(
              slots: _hiddenSlots(card.slots),
              onRestore: _restoreSlot,
            ),
          ],
        ] else ...[
          const SizedBox(height: 14),
          _ProfileCategoryChips(
            selectedCategory: _selectedCategory,
            onSelected: _selectCategory,
          ),
          const SizedBox(height: 14),
          _ProfileSectionHeader(
            title: _selectedCategory == '전체'
                ? '모든 답변'
                : '$_selectedCategory 답변',
            meta: filteredSlots.where((slot) => slot.value != null).isEmpty
                ? '아직 없음'
                : '${filteredSlots.where((slot) => slot.value != null).length}개',
          ),
          const SizedBox(height: 10),
          _ProfilePartnerReadList(slots: filteredSlots),
        ],
      ],
    );
  }

  List<ProfileSlot> _filteredSlots(List<ProfileSlot> slots) {
    final visibleSlots = slots.where((slot) => !slot.hidden);
    if (_selectedCategory == '전체') {
      return visibleSlots.toList();
    }
    return visibleSlots
        .where((slot) => slot.category == _selectedCategory)
        .toList();
  }

  List<ProfileSlot> _filledSlots(List<ProfileSlot> slots) {
    final filled = slots.where((slot) => slot.value != null).toList();
    filled.sort((a, b) {
      if (a.custom != b.custom) {
        return a.custom ? -1 : 1;
      }
      final aUpdatedAt = a.updatedAt;
      final bUpdatedAt = b.updatedAt;
      if (aUpdatedAt != null && bUpdatedAt != null) {
        return bUpdatedAt.compareTo(aUpdatedAt);
      }
      return 0;
    });
    return filled;
  }

  List<ProfileSlot> _pendingSlots(List<ProfileSlot> slots) {
    return slots.where((slot) => slot.value == null).toList();
  }

  List<ProfileSlot> _hiddenSlots(List<ProfileSlot> slots) {
    return slots.where((slot) => slot.hidden && !slot.custom).toList();
  }

  ProfileSlot? _recommendedSlot(ProfileCardData card) {
    final filteredEmpty = _filteredSlots(
      card.slots,
    ).where((slot) => slot.value == null && !slot.skipped).toList();
    if (filteredEmpty.isNotEmpty) {
      return filteredEmpty.first;
    }
    return _firstEmptySlot(card.slots);
  }

  ProfileSlot? _slotById(List<ProfileSlot> slots, String slotId) {
    for (final slot in slots) {
      if (slot.id == slotId) {
        return slot;
      }
    }
    return null;
  }

  ProfileSlot? _firstEmptySlot(List<ProfileSlot> slots) {
    for (final slot in slots) {
      if (slot.value == null && !slot.skipped && !slot.hidden) {
        return slot;
      }
    }
    return null;
  }
}

class _ProfileSlotList extends StatelessWidget {
  const _ProfileSlotList({
    required this.slots,
    required this.editingSlotId,
    required this.emptyText,
    required this.onEdit,
    required this.onSkip,
    required this.onHide,
    required this.onRestore,
    required this.onDelete,
  });

  final List<ProfileSlot> slots;
  final String? editingSlotId;
  final String emptyText;
  final ValueChanged<ProfileSlot> onEdit;
  final ValueChanged<ProfileSlot> onSkip;
  final ValueChanged<ProfileSlot> onHide;
  final ValueChanged<ProfileSlot> onRestore;
  final ValueChanged<ProfileSlot> onDelete;

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) {
      return AlagagiInlineEmptyState(text: emptyText);
    }
    return Column(
      children: [
        for (final slot in slots) ...[
          _ProfileSlotCard(
            slot: slot,
            selected: editingSlotId == slot.id,
            onEdit: () => onEdit(slot),
            onSkip: () => onSkip(slot),
            onHide: () => onHide(slot),
            onRestore: () => onRestore(slot),
            onDelete: () => onDelete(slot),
          ),
          if (slot != slots.last) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _ProfileSummaryCard extends StatelessWidget {
  const _ProfileSummaryCard({required this.card});

  final ProfileCardData card;

  @override
  Widget build(BuildContext context) {
    final isMine = card.profile.isMe;
    final progress = card.totalCount == 0
        ? 0.0
        : card.filledCount / card.totalCount;
    final customFilledCount = card.slots
        .where((slot) => !slot.hidden && slot.custom && slot.value != null)
        .length;
    final title = isMine ? '내 소개 서랍' : '${card.profile.nickname}님이 남긴 소개';
    final subtitle = isMine ? '편한 만큼 남기고, 애매한 질문은 숨겨두기' : '채워진 답만 보여요';
    final dark = !isMine;
    return Container(
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF2F2F2B) : null,
        gradient: dark
            ? null
            : const LinearGradient(
                colors: [AlagagiColors.paper, Color(0xFFF3F5EE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        border: Border.all(
          color: dark ? const Color(0x332F2F2B) : AlagagiColors.line,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: dark ? const Color(0x2A2F2F2B) : const Color(0x08000000),
            blurRadius: dark ? 34 : 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      padding: const EdgeInsets.all(19),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: isMine
                      ? AlagagiColors.softSage
                      : const Color(0xFFF0EDF4),
                  borderRadius: BorderRadius.circular(19),
                ),
                alignment: Alignment.center,
                child: Text(
                  card.profile.avatar,
                  style: const TextStyle(fontSize: 25),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: serif(
                        context,
                        size: 21,
                        weight: FontWeight.w800,
                        color: dark ? Colors.white : AlagagiColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: sans(
                        size: 12.2,
                        color: dark
                            ? const Color(0xFFD5D3CB)
                            : AlagagiColors.muted,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              if (isMine)
                Container(
                  height: 31,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2F2F2B),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    '${card.filledCount} / ${card.totalCount}',
                    style: sans(
                      size: 11,
                      color: Colors.white,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: dark
                  ? const Color(0x24FFFFFF)
                  : const Color(0xFFE6E9DF),
              valueColor: AlwaysStoppedAnimation<Color>(
                dark ? const Color(0xFFF4ECD9) : AlagagiColors.lavender,
              ),
            ),
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: _ProfileSummaryStatCell(
                  value: '${card.filledCount}',
                  label: isMine ? '작성함' : '답변',
                  dark: dark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ProfileSummaryStatCell(
                  value: '$customFilledCount',
                  label: '직접 카드',
                  dark: dark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ProfileSummaryStatCell(
                  value: isMine ? '${card.hiddenCount}' : '${card.totalCount}',
                  label: isMine ? '숨김' : '전체 카드',
                  dark: dark,
                ),
              ),
            ],
          ),
          if (!isMine) ...[
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                color: const Color(0x1AFFFFFF),
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              child: Row(
                children: [
                  const Icon(
                    Icons.mark_chat_read_outlined,
                    size: 18,
                    color: Color(0xFFF4ECD9),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      customFilledCount > 0
                          ? '직접 만든 카드도 함께 올라와 있어요'
                          : '상대가 채운 카드만 조용히 보여줘요',
                      style: sans(
                        size: 11.5,
                        color: const Color(0xFFD5D3CB),
                        height: 1.45,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProfileSummaryStatCell extends StatelessWidget {
  const _ProfileSummaryStatCell({
    required this.value,
    required this.label,
    required this.dark,
  });

  final String value;
  final String label;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 54),
      decoration: BoxDecoration(
        color: dark
            ? const Color(0x14FFFFFF)
            : Colors.white.withValues(alpha: 0.5),
        border: Border.all(
          color: dark ? const Color(0x16FFFFFF) : AlagagiColors.line,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: sans(
              size: 17,
              weight: FontWeight.w800,
              color: dark ? Colors.white : AlagagiColors.ink,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: sans(
              size: 10.8,
              weight: FontWeight.w700,
              color: dark ? const Color(0xFFCFCBC1) : AlagagiColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCustomCardEntry extends StatelessWidget {
  const _ProfileCustomCardEntry({
    required this.customCount,
    required this.onTap,
  });

  final int customCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: profileCustomCardAddButtonKey,
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2F2F2B),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x242F2F2B),
              blurRadius: 28,
              offset: Offset(0, 16),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0x1FFFFFFF),
                borderRadius: BorderRadius.circular(999),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.add_rounded,
                size: 21,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '내 질문으로 카드 추가',
                    style: sans(
                      size: 13.5,
                      color: Colors.white,
                      weight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '기본 질문이 애매하면 직접 만들어 남겨요',
                    style: sans(size: 11.5, color: const Color(0xFFD9D7CF)),
                  ),
                ],
              ),
            ),
            Container(
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: customCount > 0
                    ? const Color(0xFFF4ECD9)
                    : const Color(0x1FFFFFFF),
                borderRadius: BorderRadius.circular(999),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                '$customCount개',
                style: sans(
                  size: 11.5,
                  color: customCount > 0
                      ? const Color(0xFF8B6E31)
                      : const Color(0xFFD9D7CF),
                  weight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCustomCardPanel extends StatefulWidget {
  const _ProfileCustomCardPanel({required this.onSave, required this.onCancel});

  final String? Function(String title, String body, String category) onSave;
  final VoidCallback onCancel;

  @override
  State<_ProfileCustomCardPanel> createState() =>
      _ProfileCustomCardPanelState();
}

class _ProfileCustomCardPanelState extends State<_ProfileCustomCardPanel> {
  static const categories = ['직접', '취향', '하루', '대화', '함께'];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  String _selectedCategory = '직접';
  String? _error;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _submit() {
    final error = widget.onSave(
      _titleController.text,
      _bodyController.text,
      _selectedCategory,
    );
    if (error != null) {
      setState(() => _error = error);
    }
  }

  OutlineInputBorder _inputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(17),
      borderSide: BorderSide(color: color),
    );
  }

  Widget _fieldLabel(String label, String trailing) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: sans(
            size: 11.5,
            color: AlagagiColors.muted,
            weight: FontWeight.w800,
          ),
        ),
        Text(
          trailing,
          style: sans(
            size: 11.5,
            color: AlagagiColors.muted,
            weight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleLength = _titleController.text.characters.length;
    final bodyLength = _bodyController.text.characters.length;
    return Container(
      key: profileCustomCardPanelKey,
      decoration: BoxDecoration(
        color: AlagagiColors.paper,
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AlagagiColors.paper, Color(0xFFEEF2E8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border(bottom: BorderSide(color: AlagagiColors.line)),
            ),
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CARD STUDIO',
                  style: sans(
                    size: 10.5,
                    color: AlagagiColors.sageDeep,
                    weight: FontWeight.w800,
                    letterSpacing: 1.8,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '내가 편한 질문으로\n소개를 남겨요',
                  style: serif(
                    context,
                    size: 21,
                    weight: FontWeight.w800,
                    height: 1.34,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  '답변이 저장된 뒤에만 상대 카드에 보여요. 작성 중인 내용은 공유되지 않아요.',
                  style: sans(
                    size: 12.5,
                    color: AlagagiColors.muted,
                    height: 1.58,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 15, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _fieldLabel('카드 제목', '$titleLength / 32'),
                const SizedBox(height: 7),
                TextField(
                  key: profileCustomTitleFieldKey,
                  controller: _titleController,
                  maxLength: 32,
                  onChanged: (_) => setState(() => _error = null),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: '예: 요즘 내가 자주 하는 생각',
                    filled: true,
                    fillColor: Colors.white,
                    border: _inputBorder(AlagagiColors.line),
                    enabledBorder: _inputBorder(AlagagiColors.line),
                    focusedBorder: _inputBorder(AlagagiColors.sageDeep),
                  ),
                  style: sans(size: 13.5),
                ),
                const SizedBox(height: 12),
                _fieldLabel('답변', '$bodyLength / 120'),
                const SizedBox(height: 7),
                TextField(
                  key: profileCustomBodyFieldKey,
                  controller: _bodyController,
                  maxLength: 120,
                  minLines: 4,
                  maxLines: 6,
                  onChanged: (_) => setState(() => _error = null),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: '내가 공유하고 싶은 답변을 편하게 적어주세요',
                    filled: true,
                    fillColor: Colors.white,
                    border: _inputBorder(AlagagiColors.line),
                    enabledBorder: _inputBorder(AlagagiColors.line),
                    focusedBorder: _inputBorder(AlagagiColors.sageDeep),
                  ),
                  style: sans(size: 13.5, height: 1.65),
                ),
                const SizedBox(height: 12),
                _fieldLabel('분류', '상대 카드에서도 표시'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final category in categories)
                      _ProfileCustomCategoryChip(
                        category: category,
                        selected: _selectedCategory == category,
                        onTap: () => setState(() {
                          _selectedCategory = category;
                          _error = null;
                        }),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F2E7),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    '저장하면 상대의 카드 화면에 새 카드로 올라가고, 새로 도착한 것에도 표시됩니다.',
                    style: sans(
                      size: 11.8,
                      color: const Color(0xFF816A39),
                      height: 1.52,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    _error!,
                    style: sans(
                      size: 12,
                      color: const Color(0xFFB3605C),
                      weight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                SizedBox(
                  width: 88,
                  height: 48,
                  child: OutlinedButton(
                    key: profileCustomCancelButtonKey,
                    onPressed: widget.onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AlagagiColors.muted,
                      side: const BorderSide(color: AlagagiColors.line),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: sans(size: 13, weight: FontWeight.w800),
                    ),
                    child: const Text('취소'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      key: profileCustomSubmitButtonKey,
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AlagagiColors.sageDeep,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: sans(size: 13, weight: FontWeight.w900),
                      ),
                      child: const Text('카드 저장'),
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

class _ProfileCustomCategoryChip extends StatelessWidget {
  const _ProfileCustomCategoryChip({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final String category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: profileCustomCategoryChipKey(category),
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AlagagiColors.softSage : const Color(0xFFF8F8F4),
          border: Border.all(
            color: selected ? const Color(0x338A9A7E) : AlagagiColors.line,
          ),
          borderRadius: BorderRadius.circular(999),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 11),
        child: Text(
          category,
          style: sans(
            size: 12,
            color: selected ? AlagagiColors.sageDeep : AlagagiColors.muted,
            weight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _ProfileCategoryChips extends StatelessWidget {
  const _ProfileCategoryChips({
    required this.selectedCategory,
    required this.onSelected,
  });

  final String selectedCategory;
  final ValueChanged<String> onSelected;

  static const categories = ['전체', '직접', '취향', '하루', '대화', '함께'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final category in categories) ...[
            _ProfileCategoryChip(
              category: category,
              selected: selectedCategory == category,
              onTap: () => onSelected(category),
            ),
            if (category != categories.last) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _ProfileCategoryChip extends StatelessWidget {
  const _ProfileCategoryChip({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final String category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: profileCategoryChipKey(category),
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        height: 34,
        decoration: BoxDecoration(
          color: selected ? AlagagiColors.softSage : AlagagiColors.paper,
          border: Border.all(
            color: selected ? const Color(0x338A9A7E) : AlagagiColors.line,
          ),
          borderRadius: BorderRadius.circular(999),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: selected ? AlagagiColors.sageDeep : AlagagiColors.muted,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              category,
              style: sans(
                size: 12,
                color: selected ? AlagagiColors.sageDeep : AlagagiColors.muted,
                weight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileRecommendCard extends StatelessWidget {
  const _ProfileRecommendCard({
    required this.slot,
    required this.onUse,
    required this.onSkip,
  });

  final ProfileSlot? slot;
  final ValueChanged<ProfileSlot> onUse;
  final ValueChanged<ProfileSlot> onSkip;

  @override
  Widget build(BuildContext context) {
    final slot = this.slot;
    if (slot == null) {
      return const AlagagiEmptyStateCard(text: '지금 보이는 카드팩은 모두 채워졌어요.');
    }
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2E8),
        border: Border.all(color: const Color(0x338A9A7E)),
        borderRadius: BorderRadius.circular(22),
      ),
      padding: const EdgeInsets.all(17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TODAY PICK',
            style: sans(
              size: 10.5,
              color: AlagagiColors.sageDeep,
              weight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            slot.label,
            style: serif(
              context,
              size: 18,
              weight: FontWeight.w800,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            slot.inputHint,
            style: sans(
              size: 12.5,
              color: const Color(0xFF7F8876),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 13),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              TextButton.icon(
                key: profileRecommendedSlotButtonKey,
                onPressed: () => onUse(slot),
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('이 질문 쓰기'),
                style: TextButton.styleFrom(
                  backgroundColor: AlagagiColors.sageDeep,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 10,
                  ),
                  textStyle: sans(size: 12, weight: FontWeight.w700),
                ),
              ),
              TextButton(
                key: profileRecommendedSlotSkipButtonKey,
                onPressed: () => onSkip(slot),
                style: TextButton.styleFrom(
                  foregroundColor: AlagagiColors.muted,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  textStyle: sans(size: 12, weight: FontWeight.w700),
                ),
                child: const Text('오늘은 넘기기'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileEditorPanel extends StatefulWidget {
  const _ProfileEditorPanel({
    required this.slot,
    required this.draft,
    required this.onChanged,
    required this.onSave,
    required this.onCancel,
  });

  final ProfileSlot slot;
  final String draft;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSave;
  final VoidCallback onCancel;

  @override
  State<_ProfileEditorPanel> createState() => _ProfileEditorPanelState();
}

class _ProfileEditorPanelState extends State<_ProfileEditorPanel> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.draft);
  }

  @override
  void didUpdateWidget(covariant _ProfileEditorPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.slot.id != widget.slot.id) {
      _controller.text = widget.draft;
      _controller.selection = TextSelection.collapsed(
        offset: _controller.text.length,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final draftLength = _controller.text.characters.length;
    return Container(
      key: profileEditorPanelKey,
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
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFAFAF5), Color(0xFFEEF2E8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border(bottom: BorderSide(color: AlagagiColors.line)),
            ),
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.slot.category.toUpperCase(),
                  style: sans(
                    size: 10.5,
                    color: AlagagiColors.sageDeep,
                    weight: FontWeight.w700,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.slot.label,
                  style: serif(
                    context,
                    size: 20,
                    weight: FontWeight.w800,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  '너무 설명하려고 하지 않아도 돼요. 떠오르는 장면 하나만 적어도 충분합니다.',
                  style: sans(
                    size: 12.5,
                    color: AlagagiColors.muted,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final suggestion in _suggestionsForSlot(widget.slot))
                  Container(
                    height: 31,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8F4),
                      border: Border.all(color: AlagagiColors.line),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      suggestion,
                      style: sans(
                        size: 11.5,
                        color: AlagagiColors.muted,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AlagagiColors.line),
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: TextFormField(
                key: profileSlotFieldKey(widget.slot.id),
                controller: _controller,
                maxLength: 120,
                minLines: 4,
                maxLines: 6,
                onChanged: (value) {
                  setState(() {});
                  widget.onChanged(value);
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                  hintText: widget.slot.inputHint,
                ),
                style: sans(size: 13.5, height: 1.7),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '한 줄이어도 괜찮아요',
                  style: sans(size: 11.5, color: AlagagiColors.muted),
                ),
                Text(
                  '$draftLength / 120',
                  style: sans(size: 11.5, color: AlagagiColors.muted),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
            child: Row(
              children: [
                SizedBox(
                  width: 92,
                  height: 48,
                  child: OutlinedButton(
                    key: profileSlotCancelButtonKey(widget.slot.id),
                    onPressed: widget.onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AlagagiColors.muted,
                      side: const BorderSide(color: AlagagiColors.line),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('취소'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      key: profileSlotSaveButtonKey(widget.slot.id),
                      onPressed: _controller.text.trim().isEmpty
                          ? null
                          : () => widget.onSave(_controller.text),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AlagagiColors.sageDeep,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: const Color(0xFFE2E0D8),
                        disabledForegroundColor: AlagagiColors.muted,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: sans(size: 13.5, weight: FontWeight.w700),
                      ),
                      child: const Text('카드 저장'),
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

  List<String> _suggestionsForSlot(ProfileSlot slot) {
    return switch (slot.id) {
      'rest' || 'comfort' => ['퇴근 후 조용한 시간', '커피 한 잔', '걷는 시간', '정리된 방'],
      'cafe' => ['창가 자리', '조용한 음악', '넓은 테이블', '따뜻한 조명'],
      'walk' || 'neighborhood' => ['강변', '공원', '낯선 동네', '해 질 때'],
      'talk_style' || 'pace' => ['조금 천천히', '생각할 시간', '짧은 답도 편하게', '부담 없이'],
      _ => ['요즘 떠오른 것', '가볍게 한 줄', '작은 장면', '편한 만큼'],
    };
  }
}

class _ProfileSectionHeader extends StatelessWidget {
  const _ProfileSectionHeader({required this.title, required this.meta});

  final String title;
  final String meta;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: serif(context, size: 16, weight: FontWeight.w800),
          ),
        ),
        Text(meta, style: sans(size: 11.5, color: AlagagiColors.muted)),
      ],
    );
  }
}

class _ProfileSlotGrid extends StatelessWidget {
  const _ProfileSlotGrid({
    required this.slots,
    required this.editingSlotId,
    required this.onEdit,
    required this.onSkip,
    required this.onHide,
    required this.onRestore,
    required this.onDelete,
  });

  final List<ProfileSlot> slots;
  final String? editingSlotId;
  final ValueChanged<ProfileSlot> onEdit;
  final ValueChanged<ProfileSlot> onSkip;
  final ValueChanged<ProfileSlot> onHide;
  final ValueChanged<ProfileSlot> onRestore;
  final ValueChanged<ProfileSlot> onDelete;

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) {
      return const AlagagiEmptyStateCard(text: '이 카테고리에는 아직 카드가 없어요.');
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 10) / 2;
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final slot in slots)
              SizedBox(
                width: cardWidth,
                child: _ProfileSlotCard(
                  slot: slot,
                  selected: editingSlotId == slot.id,
                  onEdit: () => onEdit(slot),
                  onSkip: () => onSkip(slot),
                  onHide: () => onHide(slot),
                  onRestore: () => onRestore(slot),
                  onDelete: () => onDelete(slot),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ProfileHiddenSlotsPanel extends StatelessWidget {
  const _ProfileHiddenSlotsPanel({
    required this.slots,
    required this.onRestore,
  });

  final List<ProfileSlot> slots;
  final ValueChanged<ProfileSlot> onRestore;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: profileHiddenSlotsPanelKey,
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAF5),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '숨긴 질문',
            style: sans(
              size: 13,
              color: const Color(0xFF45443F),
              weight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '기본 질문은 삭제 대신 숨겨두고, 필요하면 다시 꺼낼 수 있어요.',
            style: sans(size: 12, color: AlagagiColors.muted, height: 1.5),
          ),
          const SizedBox(height: 10),
          for (final slot in slots) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    slot.label,
                    style: sans(
                      size: 12.5,
                      color: const Color(0xFF45443F),
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
                TextButton(
                  key: profileSlotRestoreButtonKey(slot.id),
                  onPressed: () => onRestore(slot),
                  style: TextButton.styleFrom(
                    foregroundColor: AlagagiColors.sageDeep,
                    textStyle: sans(size: 12, weight: FontWeight.w700),
                  ),
                  child: const Text('다시 보기'),
                ),
              ],
            ),
            if (slot != slots.last)
              const Divider(height: 14, color: AlagagiColors.line),
          ],
        ],
      ),
    );
  }
}

class _ProfileSlotCard extends StatelessWidget {
  const _ProfileSlotCard({
    required this.slot,
    required this.selected,
    required this.onEdit,
    required this.onSkip,
    required this.onHide,
    required this.onRestore,
    required this.onDelete,
  });

  final ProfileSlot slot;
  final bool selected;
  final VoidCallback onEdit;
  final VoidCallback onSkip;
  final VoidCallback onHide;
  final VoidCallback onRestore;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final filled = slot.value != null;
    final skipped = slot.skipped && !filled;
    final accent = filled && slot.custom;
    final mutedBody = !filled;
    final badgeLabel = slot.custom
        ? '직접 카드'
        : filled
        ? '기본 카드'
        : skipped
        ? '넘겨둠'
        : '비어 있음';
    final badgeBackground = slot.custom
        ? const Color(0xFFF0EDF4)
        : filled
        ? const Color(0xFFF8F8F4)
        : skipped
        ? const Color(0xFFECEAE2)
        : const Color(0xFFF4ECD9);
    final badgeColor = slot.custom
        ? const Color(0xFF7D688F)
        : skipped
        ? const Color(0xFF8A8175)
        : filled
        ? AlagagiColors.muted
        : const Color(0xFF8B6E31);
    void openFull() => showReadableDetailSheet(
      context,
      label: '소개 카드',
      title: slot.label,
      body: slot.value!,
      actionLabel: '수정하기',
      onAction: onEdit,
    );
    return InkWell(
      key: profileSlotCardKey(slot.id),
      borderRadius: BorderRadius.circular(21),
      onTap: filled
          ? openFull
          : skipped
          ? onRestore
          : onEdit,
      child: Container(
        constraints: BoxConstraints(minHeight: filled ? 0 : 126),
        decoration: BoxDecoration(
          color: accent
              ? const Color(0xFFFBFDF8)
              : skipped
              ? const Color(0xFFF8F8F4)
              : AlagagiColors.paper,
          border: Border.all(
            color: selected
                ? AlagagiColors.sageDeep
                : accent
                ? const Color(0x3D6F7F63)
                : AlagagiColors.line,
          ),
          borderRadius: BorderRadius.circular(21),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProfileSlotIcon(slotId: slot.id),
                const SizedBox(width: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      slot.custom ? '직접 만든 카드' : slot.category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: sans(
                        size: 11.5,
                        color: AlagagiColors.muted,
                        weight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                if (filled) ...[
                  AlagagiOpenReadableIconButton(
                    key: profileSlotReadButtonKey(slot.id),
                    onPressed: openFull,
                  ),
                  const SizedBox(width: 2),
                ],
                Container(
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: badgeBackground,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    badgeLabel,
                    style: sans(
                      size: 10.5,
                      color: badgeColor,
                      weight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              slot.label,
              style: sans(
                size: filled ? 14 : 13,
                color: const Color(0xFF45443F),
                weight: FontWeight.w800,
                height: 1.42,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              filled
                  ? slot.value!
                  : skipped
                  ? '지금은 넘겨둔 질문이에요'
                  : slot.inputHint,
              maxLines: filled ? 4 : 3,
              overflow: TextOverflow.ellipsis,
              style:
                  sans(
                    size: filled ? 12.7 : 11.8,
                    color: mutedBody
                        ? AlagagiColors.muted
                        : const Color(0xFF45443F),
                    height: filled ? 1.62 : 1.48,
                    weight: filled ? FontWeight.w500 : null,
                  ).copyWith(
                    fontStyle: mutedBody ? FontStyle.italic : FontStyle.normal,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                AlagagiInlineTextAction(
                  key: skipped
                      ? profileSlotRestoreButtonKey(slot.id)
                      : profileSlotEditButtonKey(slot.id),
                  label: skipped
                      ? '다시 보기'
                      : filled
                      ? '수정'
                      : '작성',
                  onPressed: skipped ? onRestore : onEdit,
                ),
                if (slot.custom)
                  AlagagiInlineTextAction(
                    key: profileSlotDeleteButtonKey(slot.id),
                    label: '삭제',
                    onPressed: onDelete,
                  )
                else
                  AlagagiInlineTextAction(
                    key: profileSlotHideButtonKey(slot.id),
                    label: '숨기기',
                    onPressed: onHide,
                  ),
                if (!filled && !skipped)
                  AlagagiInlineTextAction(
                    key: profileSlotSkipButtonKey(slot.id),
                    label: '나중에',
                    onPressed: onSkip,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfilePartnerReadList extends StatelessWidget {
  const _ProfilePartnerReadList({required this.slots});

  final List<ProfileSlot> slots;

  @override
  Widget build(BuildContext context) {
    final filledSlots = slots.where((slot) => slot.value != null).toList()
      ..sort((a, b) {
        if (a.custom != b.custom) {
          return a.custom ? -1 : 1;
        }
        final aUpdatedAt = a.updatedAt;
        final bUpdatedAt = b.updatedAt;
        if (aUpdatedAt != null && bUpdatedAt != null) {
          return bUpdatedAt.compareTo(aUpdatedAt);
        }
        return 0;
      });
    if (filledSlots.isEmpty) {
      return const AlagagiInlineEmptyState(
        text: '아직 채워진 카드가 없어요. 천천히 기다려도 괜찮아요.',
      );
    }
    return Column(
      children: [
        for (final slot in filledSlots) ...[
          _ProfileReadCard(slot: slot, featured: slot.custom),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _ProfileReadCard extends StatelessWidget {
  const _ProfileReadCard({required this.slot, required this.featured});

  final ProfileSlot slot;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    void openFull() => showReadableDetailSheet(
      context,
      label: '소개 카드',
      title: slot.label,
      body: slot.value!,
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: openFull,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: featured ? const Color(0xFFFDFBFE) : AlagagiColors.paper,
          border: Border.all(
            color: featured ? const Color(0x3DB9A8C9) : AlagagiColors.line,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _ProfileSlotIcon(slotId: slot.id),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    slot.label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: sans(
                      size: 13.5,
                      color: const Color(0xFF45443F),
                      weight: FontWeight.w800,
                      height: 1.3,
                    ),
                  ),
                ),
                Container(
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: featured
                        ? const Color(0xFFF0EDF4)
                        : const Color(0xFFF8F8F4),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    featured ? '직접 카드' : slot.category,
                    style: sans(
                      size: 10.5,
                      color: featured
                          ? const Color(0xFF7D688F)
                          : AlagagiColors.muted,
                      weight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                AlagagiOpenReadableIconButton(
                  key: profileSlotReadButtonKey(slot.id),
                  onPressed: openFull,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              slot.value!,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: sans(
                size: 13.5,
                color: const Color(0xFF45443F),
                height: 1.7,
                weight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSlotIcon extends StatelessWidget {
  const _ProfileSlotIcon({required this.slotId});

  final String slotId;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: AlagagiColors.softSage,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Icon(
        _iconForSlot(slotId),
        size: 15,
        color: AlagagiColors.sageDeep,
      ),
    );
  }

  IconData _iconForSlot(String id) {
    return switch (id) {
      'food' || 'shared_food' => Icons.restaurant_outlined,
      'song' => Icons.music_note_outlined,
      'rest' || 'weekend' => Icons.weekend_outlined,
      'cafe' => Icons.local_cafe_outlined,
      'walk' || 'neighborhood' || 'photo_walk' => Icons.directions_walk_rounded,
      'comfort' || 'recharge' => Icons.eco_outlined,
      'promise' => Icons.event_available_outlined,
      'kindness' => Icons.volunteer_activism_outlined,
      'pace' || 'morning_night' || 'focus_time' => Icons.schedule_rounded,
      'wish_scene' || 'rainy_day' => Icons.near_me_outlined,
      'talk_style' || 'question_style' => Icons.chat_bubble_outline_rounded,
      'careful_words' => Icons.edit_note_rounded,
      'small_taste' || 'object' || 'small_hobby' => Icons.lightbulb_outline,
      _ => Icons.notes_outlined,
    };
  }
}

class _TodaySlotCard extends StatefulWidget {
  const _TodaySlotCard({required this.controller});

  final AlagagiController controller;

  @override
  State<_TodaySlotCard> createState() => _TodaySlotCardState();
}

class _TodaySlotCardState extends State<_TodaySlotCard> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slot = widget.controller.todayFillableProfileSlot;
    if (slot == null) {
      return const AlagagiEmptyStateCard(text: '소개 카드가 모두 채워졌어요.');
    }

    return AlagagiPaperCard(
      radius: 20,
      padding: const EdgeInsets.all(20),
      highlightedBorder: AlagagiColors.softSage,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFEEF1E8),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Text(
              '비어 있는 칸',
              style: sans(
                size: 11,
                color: AlagagiColors.sageDeep,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '나의 ‘${slot.label}’을 적어볼까요?',
            style: serif(context, size: 17, weight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            '부담 없는 한 줄이면 충분해요.',
            style: sans(size: 12.5, color: AlagagiColors.muted),
          ),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AlagagiColors.line),
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.fromLTRB(14, 4, 6, 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '한 줄로 적어볼까요…',
                    ),
                    style: sans(size: 13),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      widget.controller.fillTodayProfileSlot(_controller.text),
                  style: TextButton.styleFrom(
                    backgroundColor: AlagagiColors.sageDeep,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('채우기'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
