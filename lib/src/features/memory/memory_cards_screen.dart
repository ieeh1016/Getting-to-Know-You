import 'package:flutter/material.dart';

import '../../app/app_shell.dart';
import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/ui_components.dart';
import '../../shared/ui_style.dart';

class MemoryCardsScreen extends StatefulWidget {
  const MemoryCardsScreen({super.key, required this.controller});

  final AlagagiController controller;

  @override
  State<MemoryCardsScreen> createState() => _MemoryCardsScreenState();
}

class _MemoryCardsScreenState extends State<MemoryCardsScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _correctionController = TextEditingController();
  String? _selectedOwnerId;
  MemoryCardType? _filterType;
  MemoryCardType _draftType = MemoryCardType.likes;
  MemoryCardVisibility _draftVisibility = MemoryCardVisibility.shared;
  String? _draftError;
  String? _draftFeedback;
  String? _editingCorrectionCardId;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _correctionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final selectedOwnerId = _selectedOwnerId ?? controller.state.me.id;
    final selectedCards = _filteredCards(
      controller.memoryCardsForOwner(selectedOwnerId),
    );
    final showingMySpace = selectedOwnerId == controller.state.me.id;

    return AlagagiScreenScroll(
      key: memoryCardsScreenKey,
      bottomNavigation: AlagagiBottomNav(controller: controller),
      children: [
        AlagagiTopBar(
          title: '서로의 기억',
          trailing: '직접 기록',
          onBack: () => controller.goTo(AlagagiRoute.home),
        ),
        const SizedBox(height: 4),
        Text(
          '대화 중 오래 기억하고 싶은 내용을 카드로 남겨요',
          style: sans(size: 12.5, color: AlagagiColors.muted),
        ),
        const SizedBox(height: 16),
        _MemoryHero(controller: controller),
        const SizedBox(height: 16),
        _OwnerTabs(
          controller: controller,
          selectedOwnerId: selectedOwnerId,
          onChanged: (ownerId) {
            setState(() {
              _selectedOwnerId = ownerId;
              _editingCorrectionCardId = null;
              _correctionController.clear();
            });
          },
        ),
        const SizedBox(height: 14),
        if (showingMySpace) ...[
          _MemoryDraftCard(
            titleController: _titleController,
            bodyController: _bodyController,
            selectedType: _draftType,
            selectedVisibility: _draftVisibility,
            error: _draftError,
            feedback: _draftFeedback,
            onTypeChanged: (type) => setState(() => _draftType = type),
            onVisibilityChanged: (visibility) {
              setState(() => _draftVisibility = visibility);
            },
            onSubmit: _submitDraft,
          ),
          const SizedBox(height: 18),
        ] else
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              '${controller.state.partner.nickname}의 공간은 상대가 직접 남긴 공유 카드만 보여요.',
              style: sans(size: 12.2, color: AlagagiColors.muted, height: 1.5),
            ),
          ),
        _MemoryFilterBar(
          selected: _filterType,
          onChanged: (type) => setState(() => _filterType = type),
        ),
        const SizedBox(height: 14),
        if (selectedCards.isEmpty)
          AlagagiEmptyStateCard(
            text: showingMySpace
                ? '내 공간에 아직 기억 카드가 없어요. 한 장만 남겨볼까요?'
                : '아직 공유된 기억 카드가 없어요.',
          )
        else
          for (final card in selectedCards) ...[
            _MemoryCardTile(
              controller: controller,
              card: card,
              editingCorrection: _editingCorrectionCardId == card.id,
              correctionController: _correctionController,
              onToggleCorrection: () => _toggleCorrection(card),
              onSubmitCorrection: () => _submitCorrection(card),
              onRespond: (reaction) => _respond(card, reaction),
              onApplyCorrection: (responderId) =>
                  _applyCorrection(card, responderId),
            ),
            const SizedBox(height: 12),
          ],
      ],
    );
  }

  List<MemoryCard> _filteredCards(List<MemoryCard> cards) {
    final type = _filterType;
    if (type == null) {
      return cards;
    }
    return cards.where((card) => card.type == type).toList();
  }

  void _submitDraft() {
    final card = widget.controller.createMemoryCard(
      type: _draftType,
      title: _titleController.text,
      body: _bodyController.text,
      visibility: _draftVisibility,
    );
    if (card == null) {
      setState(() {
        _draftError = '제목은 2자 이상, 내용은 240자 안으로 남겨주세요.';
        _draftFeedback = null;
      });
      return;
    }
    setState(() {
      _selectedOwnerId = widget.controller.state.me.id;
      _filterType = null;
      _draftError = null;
      _draftFeedback = '기억 카드를 저장했어요.';
      _titleController.clear();
      _bodyController.clear();
      _draftType = MemoryCardType.likes;
      _draftVisibility = MemoryCardVisibility.shared;
    });
  }

  void _respond(MemoryCard card, MemoryCardReaction reaction) {
    final response = widget.controller.respondToMemoryCard(card.id, reaction);
    if (response == null) {
      return;
    }
    setState(() {
      _editingCorrectionCardId = null;
      _correctionController.clear();
    });
  }

  void _toggleCorrection(MemoryCard card) {
    setState(() {
      if (_editingCorrectionCardId == card.id) {
        _editingCorrectionCardId = null;
        _correctionController.clear();
      } else {
        final existing = widget.controller.memoryResponseForCard(card.id);
        _editingCorrectionCardId = card.id;
        _correctionController.text =
            existing?.reaction == MemoryCardReaction.correction
            ? existing!.correctionText
            : card.body;
      }
    });
  }

  void _submitCorrection(MemoryCard card) {
    final response = widget.controller.respondToMemoryCard(
      card.id,
      MemoryCardReaction.correction,
      correctionText: _correctionController.text,
    );
    if (response == null) {
      return;
    }
    setState(() {
      _editingCorrectionCardId = null;
      _correctionController.clear();
    });
  }

  void _applyCorrection(MemoryCard card, String responderId) {
    final updated = widget.controller.applyMemoryCardCorrection(
      card.id,
      responderProfileId: responderId,
    );
    if (updated == null) {
      return;
    }
    setState(() {
      _draftFeedback = '수정 제안을 카드에 반영했어요.';
    });
  }
}

class _MemoryHero extends StatelessWidget {
  const _MemoryHero({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final me = controller.state.me;
    final partner = controller.state.partner;
    final total = controller.visibleMemoryCards.length;
    final unreadCount = controller.unreadCountForFeature(
      UnreadActivityFeature.memoryCards,
    );
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AlagagiColors.paper, Color(0xFFEFF8FD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'MEMORY CARDS',
                  style: sans(
                    size: 10.5,
                    color: AlagagiColors.sageDeep,
                    weight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
              ),
              if (unreadCount > 0) AlagagiSmallBadge(label: '새 $unreadCount'),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '말로 지나간 것을\n작게 붙잡아 두는 공간',
            style: serif(
              context,
              size: 22,
              weight: FontWeight.w800,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '자동 분석 없이 직접 남긴 카드만 쌓여요. 공유 카드는 서로 확인하고, 나만 보기 카드는 내 공간에만 남습니다.',
            style: sans(size: 12.5, color: AlagagiColors.muted, height: 1.65),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _HeroMetric(
                  label: '${me.nickname}의 공간',
                  value: '${controller.memoryCardCountForOwner(me.id)}',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _HeroMetric(
                  label: '${partner.nickname}의 공간',
                  value: '${controller.memoryCardCountForOwner(partner.id)}',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _HeroMetric(label: '전체', value: '$total'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xBFFFFFFA),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: serif(context, size: 18, weight: FontWeight.w800)),
          const SizedBox(height: 3),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: sans(size: 10.2, color: AlagagiColors.muted),
          ),
        ],
      ),
    );
  }
}

class _OwnerTabs extends StatelessWidget {
  const _OwnerTabs({
    required this.controller,
    required this.selectedOwnerId,
    required this.onChanged,
  });

  final AlagagiController controller;
  final String selectedOwnerId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final profiles = [controller.state.me, controller.state.partner];
    return Row(
      children: [
        for (final profile in profiles) ...[
          Expanded(
            child: AlagagiSegmentButton(
              key: memoryOwnerTabKey(profile.id),
              label: '${profile.nickname}의 공간',
              selected: selectedOwnerId == profile.id,
              onTap: () => onChanged(profile.id),
            ),
          ),
          if (profile != profiles.last) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _MemoryDraftCard extends StatelessWidget {
  const _MemoryDraftCard({
    required this.titleController,
    required this.bodyController,
    required this.selectedType,
    required this.selectedVisibility,
    required this.error,
    required this.feedback,
    required this.onTypeChanged,
    required this.onVisibilityChanged,
    required this.onSubmit,
  });

  final TextEditingController titleController;
  final TextEditingController bodyController;
  final MemoryCardType selectedType;
  final MemoryCardVisibility selectedVisibility;
  final String? error;
  final String? feedback;
  final ValueChanged<MemoryCardType> onTypeChanged;
  final ValueChanged<MemoryCardVisibility> onVisibilityChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return AlagagiPaperCard(
      radius: 22,
      padding: const EdgeInsets.all(18),
      highlightedBorder: AlagagiColors.sage,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '기억 카드 만들기',
            style: serif(context, size: 18, weight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            '한 문장이어도 괜찮아요. 나중에 다시 보고 싶은 내용만 남겨요.',
            style: sans(size: 12.2, color: AlagagiColors.muted, height: 1.5),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              for (final type in memoryCardTypeOptions)
                AlagagiFilterPill(
                  key: memoryCardTypeButtonKey(type.storageKey),
                  label: type.label,
                  selected: selectedType == type,
                  onTap: () => onTypeChanged(type),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              for (final visibility in MemoryCardVisibility.values)
                AlagagiFilterPill(
                  key: memoryVisibilityButtonKey(visibility.storageKey),
                  label: visibility.label,
                  selected: selectedVisibility == visibility,
                  onTap: () => onVisibilityChanged(visibility),
                ),
            ],
          ),
          const SizedBox(height: 14),
          _MemoryTextField(
            fieldKey: memoryCardTitleFieldKey,
            controller: titleController,
            label: '제목',
            hint: '예: 조용한 카페 자리',
            maxLength: 48,
            maxLines: 1,
          ),
          const SizedBox(height: 10),
          _MemoryTextField(
            fieldKey: memoryCardBodyFieldKey,
            controller: bodyController,
            label: '내용',
            hint: '기억하고 싶은 내용을 직접 적어두기',
            maxLength: 240,
            maxLines: 4,
          ),
          if (error != null) ...[
            const SizedBox(height: 8),
            Text(error!, style: sans(size: 12, color: const Color(0xFFC06455))),
          ],
          if (feedback != null) ...[
            const SizedBox(height: 8),
            Text(
              feedback!,
              style: sans(size: 12, color: AlagagiColors.sageDeep),
            ),
          ],
          const SizedBox(height: 14),
          AlagagiPrimaryButton(
            label: '기억 카드 저장',
            onPressed: onSubmit,
            buttonKey: memoryCardSubmitButtonKey,
          ),
        ],
      ),
    );
  }
}

class _MemoryFilterBar extends StatelessWidget {
  const _MemoryFilterBar({required this.selected, required this.onChanged});

  final MemoryCardType? selected;
  final ValueChanged<MemoryCardType?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          AlagagiFilterPill(
            key: memoryCardTypeButtonKey('all'),
            label: '전체',
            selected: selected == null,
            onTap: () => onChanged(null),
          ),
          const SizedBox(width: 7),
          for (final type in memoryCardTypeOptions) ...[
            AlagagiFilterPill(
              key: memoryCardTypeButtonKey('filter-${type.storageKey}'),
              label: type.label,
              selected: selected == type,
              onTap: () => onChanged(type),
            ),
            if (type != memoryCardTypeOptions.last) const SizedBox(width: 7),
          ],
        ],
      ),
    );
  }
}

class _MemoryCardTile extends StatelessWidget {
  const _MemoryCardTile({
    required this.controller,
    required this.card,
    required this.editingCorrection,
    required this.correctionController,
    required this.onToggleCorrection,
    required this.onSubmitCorrection,
    required this.onRespond,
    required this.onApplyCorrection,
  });

  final AlagagiController controller;
  final MemoryCard card;
  final bool editingCorrection;
  final TextEditingController correctionController;
  final VoidCallback onToggleCorrection;
  final VoidCallback onSubmitCorrection;
  final ValueChanged<MemoryCardReaction> onRespond;
  final ValueChanged<String> onApplyCorrection;

  @override
  Widget build(BuildContext context) {
    final authorIsMe = card.createdByProfileId == controller.state.me.id;
    final author = authorIsMe
        ? controller.state.me.nickname
        : controller.state.partner.nickname;
    final myResponse = controller.memoryResponseForCard(card.id);
    final partnerResponse = controller.memoryResponseForCard(
      card.id,
      responderProfileId: controller.state.partner.id,
    );

    return AlagagiPaperCard(
      key: memoryCardKey(card.id),
      radius: 18,
      padding: const EdgeInsets.fromLTRB(17, 17, 17, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              AlagagiSmallBadge(label: card.type.label),
              AlagagiSmallBadge(label: card.visibility.label),
              AlagagiSmallBadge(label: '$author · ${card.createdLabel}'),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            card.title,
            style: serif(context, size: 18, weight: FontWeight.w800),
          ),
          const SizedBox(height: 7),
          Text(
            card.body,
            style: sans(size: 13.3, height: 1.65, color: AlagagiColors.ink),
          ),
          if (authorIsMe) ...[
            const SizedBox(height: 12),
            _MemoryOwnerActions(controller: controller, card: card),
            if (partnerResponse != null) ...[
              const SizedBox(height: 12),
              _MemoryResponseBlock(
                response: partnerResponse,
                responderName: controller.state.partner.nickname,
                onApplyCorrection: partnerResponse.hasCorrection
                    ? () =>
                          onApplyCorrection(partnerResponse.responderProfileId)
                    : null,
              ),
            ],
          ] else ...[
            const SizedBox(height: 12),
            _MemoryResponseActions(
              card: card,
              response: myResponse,
              editingCorrection: editingCorrection,
              correctionController: correctionController,
              onRespond: onRespond,
              onToggleCorrection: onToggleCorrection,
              onSubmitCorrection: onSubmitCorrection,
            ),
          ],
        ],
      ),
    );
  }
}

class _MemoryOwnerActions extends StatelessWidget {
  const _MemoryOwnerActions({required this.controller, required this.card});

  final AlagagiController controller;
  final MemoryCard card;

  @override
  Widget build(BuildContext context) {
    final nextVisibility = card.visibility == MemoryCardVisibility.shared
        ? MemoryCardVisibility.private
        : MemoryCardVisibility.shared;
    return Align(
      alignment: Alignment.centerLeft,
      child: OutlinedButton.icon(
        key: memoryVisibilityButtonKey(
          '${card.id}-${nextVisibility.storageKey}',
        ),
        onPressed: () =>
            controller.setMemoryCardVisibility(card.id, nextVisibility),
        icon: Icon(
          nextVisibility == MemoryCardVisibility.shared
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          size: 16,
        ),
        label: Text(
          nextVisibility == MemoryCardVisibility.shared ? '공유하기' : '나만 보기로',
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AlagagiColors.sageDeep,
          side: const BorderSide(color: Color(0x338A9A7E)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          textStyle: sans(size: 12, weight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _MemoryResponseActions extends StatelessWidget {
  const _MemoryResponseActions({
    required this.card,
    required this.response,
    required this.editingCorrection,
    required this.correctionController,
    required this.onRespond,
    required this.onToggleCorrection,
    required this.onSubmitCorrection,
  });

  final MemoryCard card;
  final MemoryCardResponse? response;
  final bool editingCorrection;
  final TextEditingController correctionController;
  final ValueChanged<MemoryCardReaction> onRespond;
  final VoidCallback onToggleCorrection;
  final VoidCallback onSubmitCorrection;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (response != null) ...[
          Text(
            response!.reaction == MemoryCardReaction.correction
                ? '내 수정 제안이 남아 있어요.'
                : '내 반응: ${response!.reaction.label}',
            style: sans(size: 12, color: AlagagiColors.sageDeep),
          ),
          const SizedBox(height: 8),
        ],
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: [
            _ResponseButton(
              key: memoryResponseButtonKey(
                card.id,
                MemoryCardReaction.agree.storageKey,
              ),
              icon: Icons.check_circle_outline_rounded,
              label: '맞아요',
              selected: response?.reaction == MemoryCardReaction.agree,
              onTap: () => onRespond(MemoryCardReaction.agree),
            ),
            _ResponseButton(
              key: memoryResponseButtonKey(
                card.id,
                MemoryCardReaction.liked.storageKey,
              ),
              icon: Icons.thumb_up_alt_outlined,
              label: '좋아요',
              selected: response?.reaction == MemoryCardReaction.liked,
              onTap: () => onRespond(MemoryCardReaction.liked),
            ),
            _ResponseButton(
              key: memoryResponseButtonKey(
                card.id,
                MemoryCardReaction.correction.storageKey,
              ),
              icon: Icons.edit_note_rounded,
              label: '조금 수정',
              selected: response?.reaction == MemoryCardReaction.correction,
              onTap: onToggleCorrection,
            ),
          ],
        ),
        if (editingCorrection) ...[
          const SizedBox(height: 10),
          _MemoryTextField(
            fieldKey: memoryCorrectionFieldKey,
            controller: correctionController,
            label: '수정 제안',
            hint: '이렇게 기억해주면 더 가까워요',
            maxLength: 240,
            maxLines: 4,
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              key: memoryCorrectionSaveButtonKey(card.id),
              onPressed: onSubmitCorrection,
              style: FilledButton.styleFrom(
                backgroundColor: AlagagiColors.ink,
                foregroundColor: AlagagiColors.appBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 13),
                textStyle: sans(size: 12.5, weight: FontWeight.w800),
              ),
              child: const Text('수정 제안 남기기'),
            ),
          ),
        ],
      ],
    );
  }
}

class _MemoryResponseBlock extends StatelessWidget {
  const _MemoryResponseBlock({
    required this.response,
    required this.responderName,
    required this.onApplyCorrection,
  });

  final MemoryCardResponse response;
  final String responderName;
  final VoidCallback? onApplyCorrection;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF3FBFF),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$responderName의 반응',
            style: sans(
              size: 11.5,
              weight: FontWeight.w800,
              color: AlagagiColors.sageDeep,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            response.reaction.label,
            style: serif(context, size: 16, weight: FontWeight.w800),
          ),
          if (response.hasCorrection) ...[
            const SizedBox(height: 6),
            Text(
              response.correctionText,
              style: sans(size: 12.5, height: 1.55),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                key: memoryCorrectionApplyButtonKey(
                  response.cardId,
                  response.responderProfileId,
                ),
                onPressed: onApplyCorrection,
                icon: const Icon(Icons.done_rounded, size: 16),
                label: const Text('카드에 반영'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AlagagiColors.sageDeep,
                  side: const BorderSide(color: Color(0x338A9A7E)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  textStyle: sans(size: 12, weight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ResponseButton extends StatelessWidget {
  const _ResponseButton({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: selected
            ? AlagagiColors.appBackground
            : AlagagiColors.sageDeep,
        backgroundColor: selected ? AlagagiColors.ink : Colors.white,
        side: BorderSide(
          color: selected ? AlagagiColors.ink : const Color(0x338A9A7E),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        textStyle: sans(size: 12, weight: FontWeight.w700),
      ),
    );
  }
}

class _MemoryTextField extends StatelessWidget {
  const _MemoryTextField({
    required this.fieldKey,
    required this.controller,
    required this.label,
    required this.hint,
    required this.maxLength,
    required this.maxLines,
  });

  final Key fieldKey;
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLength;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5FCFF),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.fromLTRB(14, 7, 14, 7),
      child: TextField(
        key: fieldKey,
        controller: controller,
        maxLength: maxLength,
        minLines: maxLines,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          counterText: '',
          border: InputBorder.none,
        ),
        style: sans(size: 13.5, height: 1.5),
      ),
    );
  }
}
