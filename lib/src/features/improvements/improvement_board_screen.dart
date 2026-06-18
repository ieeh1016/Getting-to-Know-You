import 'package:flutter/material.dart';

import '../../app/app_shell.dart';
import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/readable_detail_sheet.dart';
import '../../shared/ui_components.dart';
import '../../shared/ui_style.dart';

enum _ImprovementFilter {
  open,
  resolved,
  mine,
  partner,
  improvement,
  feature,
  friction,
  idea,
}

class ImprovementBoardScreen extends StatefulWidget {
  const ImprovementBoardScreen({super.key, required this.controller});

  final AlagagiController controller;

  @override
  State<ImprovementBoardScreen> createState() => _ImprovementBoardScreenState();
}

class _ImprovementBoardScreenState extends State<ImprovementBoardScreen> {
  _ImprovementFilter _filter = _ImprovementFilter.open;

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final posts = controller.improvementPosts;
    final state = controller.state;
    final visiblePosts = _visiblePosts(controller, posts);
    return AlagagiScreenScroll(
      bottomNavigation: AlagagiBottomNav(controller: controller),
      children: [
        AlagagiTopBar(
          title: '건의함',
          trailing: '',
          onBack: () => controller.goTo(AlagagiRoute.home),
        ),
        const SizedBox(height: 4),
        Text(
          '좋아졌으면 하는 부분을 조용히 모아둬요',
          style: sans(size: 12.5, color: AlagagiColors.muted),
        ),
        const SizedBox(height: 16),
        const _ImprovementHeroCard(),
        if (state.improvementDraftVisible) ...[
          const SizedBox(height: 16),
          _ImprovementDraftCard(
            key: ValueKey(
              state.editingImprovementPostId ?? 'new-improvement-post',
            ),
            controller: controller,
          ),
        ],
        const SizedBox(height: 18),
        Row(
          children: [
            const Expanded(child: AlagagiSectionLabel('남긴 글')),
            if (!state.improvementDraftVisible)
              _ImprovementAddButton(controller: controller),
          ],
        ),
        const SizedBox(height: 12),
        _ImprovementSummaryCard(controller: controller),
        _ImprovementSaveStatus(controller: controller),
        const SizedBox(height: 12),
        if (posts.isNotEmpty) ...[
          _ImprovementFilterBar(
            selected: _filter,
            onChanged: (filter) => setState(() => _filter = filter),
          ),
          const SizedBox(height: 12),
        ],
        if (posts.isEmpty)
          const AlagagiEmptyStateCard(text: '생각나는 개선점이나 추가 요청을 하나만 남겨볼까요?')
        else if (visiblePosts.isEmpty)
          AlagagiEmptyStateCard(text: _improvementFilterEmptyText(_filter))
        else
          for (final post in visiblePosts) ...[
            _ImprovementPostCard(controller: controller, post: post),
            const SizedBox(height: 12),
          ],
      ],
    );
  }

  List<ImprovementPost> _visiblePosts(
    AlagagiController controller,
    List<ImprovementPost> posts,
  ) {
    return switch (_filter) {
      _ImprovementFilter.open => posts.where((post) => !post.resolved).toList(),
      _ImprovementFilter.resolved =>
        posts.where((post) => post.resolved).toList(),
      _ImprovementFilter.mine =>
        posts
            .where((post) => post.createdByProfileId == controller.state.me.id)
            .toList(),
      _ImprovementFilter.partner =>
        posts
            .where(
              (post) => post.createdByProfileId == controller.state.partner.id,
            )
            .toList(),
      _ImprovementFilter.improvement =>
        posts.where((post) => post.category == '개선').toList(),
      _ImprovementFilter.feature =>
        posts.where((post) => post.category == '추가 요청').toList(),
      _ImprovementFilter.friction =>
        posts.where((post) => post.category == '불편함').toList(),
      _ImprovementFilter.idea =>
        posts.where((post) => post.category == '아이디어').toList(),
    };
  }
}

class _ImprovementFilterBar extends StatelessWidget {
  const _ImprovementFilterBar({
    required this.selected,
    required this.onChanged,
  });

  final _ImprovementFilter selected;
  final ValueChanged<_ImprovementFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final filter in _ImprovementFilter.values) ...[
            AlagagiFilterPill(
              key: improvementFilterButtonKey(filter.name),
              label: _improvementFilterLabel(filter),
              selected: selected == filter,
              onTap: () => onChanged(filter),
            ),
            if (filter != _ImprovementFilter.values.last)
              const SizedBox(width: 7),
          ],
        ],
      ),
    );
  }
}

String _improvementFilterLabel(_ImprovementFilter filter) {
  return switch (filter) {
    _ImprovementFilter.open => '진행중',
    _ImprovementFilter.resolved => '개선완료',
    _ImprovementFilter.mine => '내 글',
    _ImprovementFilter.partner => '상대 글',
    _ImprovementFilter.improvement => '개선',
    _ImprovementFilter.feature => '추가 요청',
    _ImprovementFilter.friction => '불편함',
    _ImprovementFilter.idea => '아이디어',
  };
}

String _improvementFilterEmptyText(_ImprovementFilter filter) {
  return switch (filter) {
    _ImprovementFilter.open => '진행중인 건의는 없어요.',
    _ImprovementFilter.resolved => '개선완료된 건의는 아직 없어요.',
    _ImprovementFilter.mine => '내가 남긴 글은 아직 없어요.',
    _ImprovementFilter.partner => '상대가 남긴 글은 아직 없어요.',
    _ImprovementFilter.improvement => '개선으로 남긴 글은 아직 없어요.',
    _ImprovementFilter.feature => '추가 요청으로 남긴 글은 아직 없어요.',
    _ImprovementFilter.friction => '불편함으로 남긴 글은 아직 없어요.',
    _ImprovementFilter.idea => '아이디어로 남긴 글은 아직 없어요.',
  };
}

class _ImprovementHeroCard extends StatelessWidget {
  const _ImprovementHeroCard();

  @override
  Widget build(BuildContext context) {
    return AlagagiPaperCard(
      radius: 22,
      padding: const EdgeInsets.all(18),
      highlightedBorder: AlagagiColors.sage,
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2EA),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.rate_review_outlined,
              size: 24,
              color: AlagagiColors.sageDeep,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '작은 불편함도\n다음 개선 후보가 돼요.',
                  style: serif(
                    context,
                    size: 19,
                    weight: FontWeight.w800,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '둘이 쓰면서 필요한 기능을 가볍게 쌓아둘 수 있어요.',
                  style: sans(
                    size: 12.3,
                    color: AlagagiColors.muted,
                    height: 1.45,
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

class _ImprovementSummaryCard extends StatelessWidget {
  const _ImprovementSummaryCard({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final posts = controller.improvementPosts;
    final openCount = posts.where((post) => !post.resolved).length;
    final resolvedCount = posts.where((post) => post.resolved).length;
    return AlagagiPaperCard(
      radius: 18,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Expanded(
            child: AlagagiQuietMetric(label: '전체', value: '${posts.length}'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AlagagiQuietMetric(label: '진행중', value: '$openCount'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AlagagiQuietMetric(
              label: '개선완료',
              value: '$resolvedCount',
              muted: resolvedCount == 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _ImprovementAddButton extends StatelessWidget {
  const _ImprovementAddButton({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: OutlinedButton.icon(
        key: improvementAddButtonKey,
        onPressed: controller.startImprovementDraft,
        icon: const Icon(Icons.add_rounded, size: 16),
        label: const Text('글 남기기'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AlagagiColors.sageDeep,
          side: const BorderSide(color: Color(0x338A9A7E)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          textStyle: sans(size: 12, weight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _ImprovementDraftCard extends StatelessWidget {
  const _ImprovementDraftCard({super.key, required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
    final isEditing = state.editingImprovementPostId != null;
    return AlagagiPaperCard(
      radius: 22,
      padding: const EdgeInsets.all(18),
      highlightedBorder: AlagagiColors.sage,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            isEditing ? '남긴 건의를\n다시 정리해요.' : '필요한 점을\n짧게 남겨요.',
            style: serif(
              context,
              size: 20,
              weight: FontWeight.w800,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              for (final category in improvementPostCategoryOptions)
                AlagagiFilterPill(
                  key: improvementCategoryKey(category),
                  label: category,
                  selected: state.improvementDraftCategory == category,
                  onTap: () =>
                      controller.updateImprovementDraft(category: category),
                ),
            ],
          ),
          const SizedBox(height: 12),
          AlagagiTextField(
            fieldKey: improvementTitleFieldKey,
            label: '제목',
            hint: '예: 장소 검색 결과 정렬',
            initialValue: state.improvementDraftTitle,
            maxLength: 50,
            onChanged: (value) =>
                controller.updateImprovementDraft(title: value),
          ),
          const SizedBox(height: 10),
          AlagagiTextField(
            fieldKey: improvementBodyFieldKey,
            label: '내용',
            hint: '어떤 점이 바뀌면 좋을지 편하게 적어주세요.',
            initialValue: state.improvementDraftBody,
            maxLength: 300,
            maxLines: 4,
            onChanged: (value) =>
                controller.updateImprovementDraft(body: value),
          ),
          if (state.improvementDraftError != null) ...[
            const SizedBox(height: 10),
            Text(
              state.improvementDraftError!,
              style: sans(size: 12, color: const Color(0xFF9A5A45)),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton(
                onPressed: controller.cancelImprovementDraft,
                child: Text(
                  '취소',
                  style: sans(size: 13, color: AlagagiColors.muted),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AlagagiPrimaryButton(
                  label: isEditing ? '수정 저장' : '건의 남기기',
                  onPressed: controller.submitImprovementDraft,
                  color: AlagagiColors.sageDeep,
                  buttonKey: improvementSubmitButtonKey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ImprovementPostCard extends StatelessWidget {
  const _ImprovementPostCard({required this.controller, required this.post});

  final AlagagiController controller;
  final ImprovementPost post;

  @override
  Widget build(BuildContext context) {
    final isMine = post.createdByProfileId == controller.state.me.id;
    final creator = isMine
        ? controller.state.me.nickname
        : controller.state.partner.nickname;
    return GestureDetector(
      key: improvementCardKey(post.id),
      behavior: HitTestBehavior.opaque,
      onTap: () => showReadableDetailSheet(
        context,
        label: post.resolved ? '개선완료' : post.category,
        title: post.title,
        meta: '$creator · ${post.createdLabel}',
        body: [
          post.body,
          if (post.hasOwnerNote) '영우 답변\n${post.ownerNote}',
        ].join('\n\n'),
      ),
      child: AlagagiPaperCard(
        radius: 19,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isMine
                        ? const Color(0xFFEEF2EA)
                        : const Color(0xFFF1ECF6),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    _improvementCategoryIcon(post.category),
                    size: 20,
                    color: isMine
                        ? AlagagiColors.sageDeep
                        : const Color(0xFF7D6A8E),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              post.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: sans(
                                size: 14.2,
                                weight: FontWeight.w800,
                                color: const Color(0xFF33332F),
                              ),
                            ),
                          ),
                          if (post.resolved) ...[
                            const AlagagiSmallBadge(label: '개선완료'),
                            const SizedBox(width: 6),
                          ],
                          AlagagiSmallBadge(label: post.category),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$creator · ${post.createdLabel}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: sans(size: 11.6, color: AlagagiColors.muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              post.body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: sans(
                size: 12.7,
                color: const Color(0xFF6F6C65),
                height: 1.5,
              ),
            ),
            if (post.hasOwnerNote) ...[
              const SizedBox(height: 12),
              _ImprovementOwnerNote(post: post),
            ],
            if (controller.canManageImprovementPosts) ...[
              const SizedBox(height: 12),
              _ImprovementOwnerActions(controller: controller, post: post),
            ],
            if (isMine) ...[
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    key: improvementEditButtonKey(post.id),
                    onPressed: () => controller.startImprovementEdit(post.id),
                    icon: const Icon(Icons.edit_outlined, size: 15),
                    label: const Text('수정'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AlagagiColors.sageDeep,
                      side: const BorderSide(color: Color(0x338A9A7E)),
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      textStyle: sans(size: 12, weight: FontWeight.w800),
                    ),
                  ),
                  OutlinedButton.icon(
                    key: improvementDeleteButtonKey(post.id),
                    onPressed: () => controller.deleteImprovementPost(post.id),
                    icon: const Icon(Icons.delete_outline_rounded, size: 15),
                    label: const Text('삭제'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF9A5A45),
                      side: const BorderSide(color: Color(0x339A5A45)),
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      textStyle: sans(size: 12, weight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ImprovementOwnerNote extends StatelessWidget {
  const _ImprovementOwnerNote({required this.post});

  final ImprovementPost post;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8F3),
        border: Border.all(color: const Color(0x338A9A7E)),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.task_alt_rounded,
                size: 15,
                color: AlagagiColors.sageDeep,
              ),
              const SizedBox(width: 6),
              Text(
                '영우 답변',
                style: sans(
                  size: 12,
                  weight: FontWeight.w800,
                  color: AlagagiColors.sageDeep,
                ),
              ),
              if (post.ownerNoteLabel.isNotEmpty) ...[
                const SizedBox(width: 6),
                Text(
                  post.ownerNoteLabel,
                  style: sans(size: 11, color: AlagagiColors.muted),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Text(
            post.ownerNote,
            style: sans(
              size: 12.5,
              color: const Color(0xFF555149),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _ImprovementOwnerActions extends StatefulWidget {
  const _ImprovementOwnerActions({
    required this.controller,
    required this.post,
  });

  final AlagagiController controller;
  final ImprovementPost post;

  @override
  State<_ImprovementOwnerActions> createState() =>
      _ImprovementOwnerActionsState();
}

class _ImprovementOwnerActionsState extends State<_ImprovementOwnerActions> {
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.post.ownerNote);
  }

  @override
  void didUpdateWidget(covariant _ImprovementOwnerActions oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post.id != widget.post.id ||
        oldWidget.post.ownerNote != widget.post.ownerNote) {
      _noteController.value = TextEditingValue(
        text: widget.post.ownerNote,
        selection: TextSelection.collapsed(
          offset: widget.post.ownerNote.length,
        ),
      );
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBF7),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('관리 메모', style: sans(size: 12, weight: FontWeight.w800)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F4),
              border: Border.all(color: AlagagiColors.line),
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
            child: TextFormField(
              key: improvementOwnerNoteFieldKey(post.id),
              controller: _noteController,
              maxLength: 160,
              minLines: 1,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: '어떻게 반영했는지 짧게 남기기',
                counterText: '',
                border: InputBorder.none,
              ),
              style: sans(size: 12.5, height: 1.45),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                key: improvementOwnerNoteSaveButtonKey(post.id),
                onPressed: () => widget.controller.saveImprovementOwnerNote(
                  post.id,
                  _noteController.text,
                ),
                icon: const Icon(Icons.chat_bubble_outline_rounded, size: 15),
                label: const Text('답변 저장'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AlagagiColors.sageDeep,
                  side: const BorderSide(color: Color(0x338A9A7E)),
                  visualDensity: VisualDensity.compact,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  textStyle: sans(size: 12, weight: FontWeight.w800),
                ),
              ),
              FilledButton.icon(
                key: improvementResolveButtonKey(post.id),
                onPressed: () =>
                    widget.controller.toggleImprovementResolved(post.id),
                icon: Icon(
                  post.resolved
                      ? Icons.undo_rounded
                      : Icons.check_circle_outline_rounded,
                  size: 15,
                ),
                label: Text(post.resolved ? '완료 해제' : '개선완료'),
                style: FilledButton.styleFrom(
                  backgroundColor: post.resolved
                      ? const Color(0xFF7D6A8E)
                      : AlagagiColors.sageDeep,
                  foregroundColor: Colors.white,
                  visualDensity: VisualDensity.compact,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  textStyle: sans(size: 12, weight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ImprovementSaveStatus extends StatelessWidget {
  const _ImprovementSaveStatus({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
    final message = switch (state.improvementSaveStatus) {
      SaveStatus.saving => '건의를 저장 중이에요...',
      SaveStatus.saved => state.improvementSaveFeedback,
      SaveStatus.failed => state.improvementDraftError,
      SaveStatus.idle => null,
    };
    if (message == null || message.isEmpty) {
      return const SizedBox.shrink();
    }
    final failed = state.improvementSaveStatus == SaveStatus.failed;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(
          color: failed ? const Color(0xFFFFF7F3) : const Color(0xFFF7F8F3),
          border: Border.all(
            color: failed ? const Color(0x33B18472) : const Color(0x338A9A7E),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(
              failed
                  ? Icons.error_outline_rounded
                  : state.improvementSaveStatus == SaveStatus.saving
                  ? Icons.sync_rounded
                  : Icons.check_circle_outline_rounded,
              size: 16,
              color: failed ? const Color(0xFFB18472) : AlagagiColors.sageDeep,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: sans(
                  size: 12,
                  color: failed
                      ? const Color(0xFF9A5A45)
                      : AlagagiColors.sageDeep,
                  height: 1.4,
                ),
              ),
            ),
            if (failed)
              TextButton(
                key: improvementRetryButtonKey,
                onPressed: controller.retryImprovementSave,
                child: Text(
                  '다시 시도',
                  style: sans(
                    size: 12,
                    weight: FontWeight.w800,
                    color: const Color(0xFF9A5A45),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

IconData _improvementCategoryIcon(String category) {
  return switch (category) {
    '추가 요청' => Icons.add_task_outlined,
    '불편함' => Icons.report_problem_outlined,
    '아이디어' => Icons.lightbulb_outline_rounded,
    _ => Icons.tune_rounded,
  };
}
