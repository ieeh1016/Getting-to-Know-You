import 'package:flutter/material.dart';

import '../../app/app_shell.dart';
import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/text_editing_sync.dart';
import '../../shared/ui_components.dart';
import '../../shared/ui_style.dart';

const _compactReadablePreviewLength = 64;

class MusicScreen extends StatelessWidget {
  const MusicScreen({
    super.key,
    required this.controller,
    required this.onOpenExternalLink,
  });

  final AlagagiController controller;
  final ValueChanged<String> onOpenExternalLink;

  @override
  Widget build(BuildContext context) {
    final notes = controller.visibleMusicNotes;
    final totalCount = controller.musicNotes.length;
    return AlagagiScreenScroll(
      bottomNavigation: AlagagiBottomNav(controller: controller),
      children: [
        AlagagiFeatureHero(
          eyebrow: 'OUR PLAYLIST',
          title: '음악 노트',
          subtitle: '각자의 요즘을 한 곡씩 남기고, 둘 다 들은 순간을 작은 플레이리스트로 쌓아요.',
          icon: Icons.graphic_eq_rounded,
          gradient: const [
            AlagagiColors.midnight,
            Color(0xFF718EA1),
            Color(0xFFB78378),
          ],
          stats: [
            AlagagiHeroStat(
              icon: Icons.library_music_rounded,
              label: '전체 노트',
              value: '$totalCount곡',
            ),
            AlagagiHeroStat(
              icon: Icons.headphones_rounded,
              label: '아직 들을 곡',
              value: '${controller.unlistenedMusicNoteCount}곡',
            ),
            AlagagiHeroStat(
              icon: Icons.favorite_rounded,
              label: '둘 다 들음',
              value: '${controller.mutualListenedMusicNoteCount}곡',
            ),
          ],
        ),
        if (totalCount == 0) ...[
          const SizedBox(height: 18),
          const _MusicHeroCard(),
        ],
        if (controller.state.musicDraftVisible) ...[
          const SizedBox(height: 16),
          _MusicDraftCard(
            key: ValueKey(
              controller.state.editingMusicNoteId ?? 'new-music-note',
            ),
            controller: controller,
          ),
        ],
        _MusicSaveStatus(controller: controller),
        const SizedBox(height: 18),
        Row(
          children: [
            const Expanded(child: AlagagiSectionLabel('들어볼 곡')),
            if (!controller.state.musicDraftVisible)
              _MusicAddInlineButton(controller: controller),
          ],
        ),
        const SizedBox(height: 12),
        _MusicListeningDeck(controller: controller),
        if (totalCount > 0) ...[
          const SizedBox(height: 12),
          _MusicLibrarySummaryCard(controller: controller),
          const SizedBox(height: 10),
          _MusicFilterBar(controller: controller),
        ],
        const SizedBox(height: 12),
        if (totalCount == 0)
          const AlagagiEmptyStateCard(text: '요즘 듣는 노래를 한 곡만 가볍게 남겨볼까요?')
        else if (notes.isEmpty)
          const AlagagiEmptyStateCard(text: '이 조건에 맞는 곡은 아직 없어요.')
        else
          for (final note in notes) ...[
            _MusicNoteCard(
              controller: controller,
              note: note,
              onOpenExternalLink: onOpenExternalLink,
            ),
            const SizedBox(height: 12),
          ],
      ],
    );
  }
}

class _MusicListeningDeck extends StatelessWidget {
  const _MusicListeningDeck({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final totalCount = controller.musicNotes.length;
    final unlistenedCount = controller.unlistenedMusicNoteCount;
    final mutualCount = controller.mutualListenedMusicNoteCount;
    final latest = controller.musicNotes.isEmpty
        ? null
        : controller.musicNotes.first;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF262723),
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F2F2E2A),
            blurRadius: 26,
            offset: Offset(0, 14),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _MusicWavePainter())),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'LISTENING ROOM',
                            style: sans(
                              size: 10.2,
                              weight: FontWeight.w900,
                              color: const Color(0xFFBEE4F7),
                              letterSpacing: 1.7,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            '둘의 플레이리스트',
                            style: serif(
                              context,
                              size: 22,
                              weight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            latest == null
                                ? '처음 남기는 한 곡이 둘의 분위기를 만들어요.'
                                : '최근에는 ${latest.title}이 둘의 큐에 올라와 있어요.',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: sans(
                              size: 12.2,
                              color: Colors.white.withValues(alpha: 0.68),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Row(
                      children: const [
                        _MusicCover(
                          color: AlagagiColors.sage,
                          size: 52,
                          darkBorder: true,
                        ),
                        _DeckOverlapCover(color: AlagagiColors.lavender),
                        _DeckOverlapCover(color: Color(0xFFB18472)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _MusicDeckMetric(
                        label: '남긴 곡',
                        value: '$totalCount',
                        color: const Color(0xFFBEE4F7),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _MusicDeckMetric(
                        label: '아직 큐',
                        value: '$unlistenedCount',
                        color: const Color(0xFFBFD0B8),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _MusicDeckMetric(
                        label: '같이 들음',
                        value: '$mutualCount',
                        color: const Color(0xFFE0A89D),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DeckOverlapCover extends StatelessWidget {
  const _DeckOverlapCover({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(-12, 0),
      child: _MusicCover(color: color, size: 52, darkBorder: true),
    );
  }
}

class _MusicDeckMetric extends StatelessWidget {
  const _MusicDeckMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.09),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        borderRadius: BorderRadius.circular(17),
      ),
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: sans(
              size: 10.6,
              color: Colors.white.withValues(alpha: 0.63),
              weight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: serif(
              context,
              size: 25,
              weight: FontWeight.w800,
              color: color,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _MusicWavePainter extends CustomPainter {
  const _MusicWavePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = Colors.white.withValues(alpha: 0.08);
    for (var index = 0; index < 7; index++) {
      final path = Path();
      final y = 34.0 + (index * 24);
      path.moveTo(-20, y);
      path.cubicTo(
        size.width * 0.28,
        y - 24,
        size.width * 0.58,
        y + 24,
        size.width + 20,
        y - 4,
      );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MusicWavePainter oldDelegate) => false;
}

class _MusicLibrarySummaryCard extends StatelessWidget {
  const _MusicLibrarySummaryCard({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final totalCount = controller.musicNotes.length;
    final unlistenedCount = controller.unlistenedMusicNoteCount;
    final mutualCount = controller.mutualListenedMusicNoteCount;
    return AlagagiPaperCard(
      radius: 18,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Expanded(
            child: AlagagiQuietMetric(
              label: '아직 들을 곡',
              value: '$unlistenedCount',
              muted: unlistenedCount == 0,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AlagagiQuietMetric(label: '전체 노트', value: '$totalCount'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AlagagiQuietMetric(
              label: '둘 다 들음',
              value: '$mutualCount',
              muted: mutualCount == 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _MusicFilterBar extends StatelessWidget {
  const _MusicFilterBar({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final selected = controller.state.musicListFilter;
    final filters = [
      (MusicListFilter.all, '전체'),
      (MusicListFilter.unlistened, '아직'),
      (MusicListFilter.listened, '들었어요'),
      (MusicListFilter.mine, '내가 남김'),
      (MusicListFilter.partner, '상대가 남김'),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final filter in filters) ...[
            AlagagiFilterPill(
              key: musicListFilterButtonKey(filter.$1.name),
              label: filter.$2,
              selected: selected == filter.$1,
              onTap: () => controller.setMusicListFilter(filter.$1),
            ),
            if (filter != filters.last) const SizedBox(width: 7),
          ],
        ],
      ),
    );
  }
}

class _MusicAddInlineButton extends StatelessWidget {
  const _MusicAddInlineButton({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: OutlinedButton.icon(
        key: musicAddButtonKey,
        onPressed: controller.startMusicDraft,
        icon: const Icon(Icons.add_rounded, size: 16),
        label: const Text('한 곡 남기기'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AlagagiColors.sageDeep,
          side: const BorderSide(color: Color(0x338A9A7E)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          textStyle: sans(size: 12, weight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _MusicHeroCard extends StatelessWidget {
  const _MusicHeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2F2F2B),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MUSIC NOTE',
            style: sans(
              size: 10.5,
              weight: FontWeight.w700,
              color: const Color(0xFFC9C9C2),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '각자의 요즘을\n노래로 조금씩 남겨요.',
            style: serif(
              context,
              size: 22,
              weight: FontWeight.w800,
              color: Colors.white,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            '많이 설명하지 않아도, 한 곡이면 분위기가 전해질 때가 있어요.',
            style: sans(
              size: 12.5,
              color: const Color(0xFFD8D8D1),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: const [
              _MusicCover(color: AlagagiColors.sage, darkBorder: true),
              _OverlapCover(color: AlagagiColors.lavender),
              _OverlapCover(color: Color(0xFFB18472)),
              _OverlapCover(color: Color(0xFF5B9DBF)),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverlapCover extends StatelessWidget {
  const _OverlapCover({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(-10, 0),
      child: _MusicCover(color: color, darkBorder: true),
    );
  }
}

class _MusicDraftCard extends StatelessWidget {
  const _MusicDraftCard({super.key, required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.state.editingMusicNoteId != null;
    return AlagagiPaperCard(
      radius: 22,
      padding: const EdgeInsets.all(18),
      highlightedBorder: AlagagiColors.sage,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            isEditing ? '음악 노트 다듬기' : '요즘의 한 곡을\n가볍게 건네요.',
            style: serif(
              context,
              size: 20,
              weight: FontWeight.w800,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            isEditing
                ? '처음 남긴 분위기는 유지하면서 필요한 부분만 고쳐요.'
                : '정성스러운 소개보다, 떠오른 이유 한 줄이면 충분해요.',
            style: sans(size: 12.5, color: AlagagiColors.muted, height: 1.6),
          ),
          const SizedBox(height: 16),
          _MusicTextField(
            fieldKey: musicTitleFieldKey,
            label: '곡 제목',
            hint: '예: 밤 산책',
            initialValue: controller.state.musicDraftTitle,
            maxLength: 60,
            onChanged: (value) => controller.updateMusicDraft(title: value),
          ),
          const SizedBox(height: 10),
          _MusicTextField(
            fieldKey: musicArtistFieldKey,
            label: '아티스트',
            hint: '아티스트 이름',
            initialValue: controller.state.musicDraftArtist,
            maxLength: 60,
            onChanged: (value) => controller.updateMusicDraft(artist: value),
          ),
          const SizedBox(height: 10),
          _MusicTextField(
            fieldKey: musicLinkFieldKey,
            label: '링크',
            hint: 'https://...',
            initialValue: controller.state.musicDraftLink,
            maxLength: 180,
            onChanged: (value) => controller.updateMusicDraft(link: value),
          ),
          const SizedBox(height: 10),
          _MusicTextField(
            fieldKey: musicNoteFieldKey,
            label: '짧은 메모',
            hint: '왜 건네고 싶은 곡인지 한 줄로',
            initialValue: controller.state.musicDraftNote,
            maxLength: 80,
            minLines: 2,
            maxLines: 3,
            onChanged: (value) => controller.updateMusicDraft(note: value),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('분위기', style: sans(size: 12.5, weight: FontWeight.w800)),
              const SizedBox(width: 8),
              Text(
                '고르거나 직접 적을 수 있어요',
                style: sans(size: 11.5, color: AlagagiColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final mood in musicMoodOptions)
                AlagagiFilterPill(
                  label: mood,
                  selected: controller.state.musicDraftMood.trim() == mood,
                  onTap: () => controller.setMusicDraftMood(mood),
                ),
            ],
          ),
          const SizedBox(height: 10),
          _MusicMoodInput(controller: controller),
          if (controller.state.musicDraftError != null) ...[
            const SizedBox(height: 10),
            Text(
              controller.state.musicDraftError!,
              style: sans(size: 12, color: AlagagiColors.sageDeep),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton(
                onPressed: controller.cancelMusicDraft,
                child: Text(
                  '취소',
                  style: sans(size: 13, color: AlagagiColors.muted),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AlagagiPrimaryButton(
                  label: isEditing ? '수정 저장' : '노래 남기기',
                  onPressed: controller.submitMusicDraft,
                  color: AlagagiColors.sageDeep,
                  buttonKey: musicSubmitButtonKey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MusicSaveStatus extends StatelessWidget {
  const _MusicSaveStatus({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
    final status = state.musicSaveStatus;
    if (status == SaveStatus.idle &&
        state.musicSaveFeedback == null &&
        state.musicDraftError == null) {
      return const SizedBox.shrink();
    }
    final failed = status == SaveStatus.failed;
    final saving = status == SaveStatus.saving;
    final message = saving
        ? '음악 노트를 저장하는 중이에요.'
        : failed
        ? state.musicDraftError ?? '음악 노트를 저장하지 못했어요.'
        : state.musicSaveFeedback ?? '저장됐어요.';
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(
          color: failed ? const Color(0xFFFFF7ED) : const Color(0xFFF3FBFF),
          border: Border.all(
            color: failed ? const Color(0xFFEBC9A2) : AlagagiColors.line,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(
              failed
                  ? Icons.error_outline_rounded
                  : saving
                  ? Icons.sync_rounded
                  : Icons.check_circle_outline_rounded,
              size: 17,
              color: failed ? const Color(0xFF9A5A1F) : AlagagiColors.sageDeep,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: sans(
                  size: 12.2,
                  color: failed
                      ? const Color(0xFF8C511E)
                      : AlagagiColors.sageDeep,
                  weight: FontWeight.w700,
                ),
              ),
            ),
            if (failed && controller.canRetryMusicSave)
              TextButton(
                key: musicRetryButtonKey,
                onPressed: controller.retryMusicSave,
                child: Text(
                  '다시 시도',
                  style: sans(size: 12, weight: FontWeight.w800),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MusicMoodInput extends StatefulWidget {
  const _MusicMoodInput({required this.controller});

  final AlagagiController controller;

  @override
  State<_MusicMoodInput> createState() => _MusicMoodInputState();
}

class _MusicMoodInputState extends State<_MusicMoodInput> {
  late final ImeSafeTextEditingController _controller;
  late final FocusNode _focusNode;
  late final VoidCallback _detachFocusDispatch;

  @override
  void initState() {
    super.initState();
    _controller = ImeSafeTextEditingController(
      text: widget.controller.state.musicDraftMood,
      onCommittedChanged: widget.controller.setMusicDraftMood,
    );
    _focusNode = FocusNode();
    _detachFocusDispatch = dispatchTextOnFocusLost(_controller, _focusNode);
  }

  @override
  void didUpdateWidget(covariant _MusicMoodInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    final mood = widget.controller.state.musicDraftMood;
    _controller.onCommittedChanged = widget.controller.setMusicDraftMood;
    _controller.syncText(mood, focusNode: _focusNode, force: mood.isEmpty);
  }

  @override
  void dispose() {
    _detachFocusDispatch();
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5FCFF),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.fromLTRB(14, 7, 14, 7),
      child: TextFormField(
        key: musicMoodFieldKey,
        controller: _controller,
        focusNode: _focusNode,
        maxLength: 16,
        decoration: const InputDecoration(
          labelText: '직접 입력',
          hintText: '예: 드라이브, 운동, 위로',
          counterText: '',
          border: InputBorder.none,
        ),
        style: sans(size: 13.5, height: 1.5),
      ),
    );
  }
}

class _MusicTextField extends StatefulWidget {
  const _MusicTextField({
    required this.fieldKey,
    required this.label,
    required this.hint,
    required this.initialValue,
    required this.maxLength,
    required this.onChanged,
    this.minLines = 1,
    this.maxLines = 1,
  });

  final Key fieldKey;
  final String label;
  final String hint;
  final String initialValue;
  final int maxLength;
  final ValueChanged<String> onChanged;
  final int minLines;
  final int maxLines;

  @override
  State<_MusicTextField> createState() => _MusicTextFieldState();
}

class _MusicTextFieldState extends State<_MusicTextField> {
  late final ImeSafeTextEditingController _controller;
  late final FocusNode _focusNode;
  late final VoidCallback _detachFocusDispatch;

  @override
  void initState() {
    super.initState();
    _controller = ImeSafeTextEditingController(
      text: widget.initialValue,
      onCommittedChanged: widget.onChanged,
    );
    _focusNode = FocusNode();
    _detachFocusDispatch = dispatchTextOnFocusLost(_controller, _focusNode);
  }

  @override
  void didUpdateWidget(covariant _MusicTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.onCommittedChanged = widget.onChanged;
    final fieldChanged = oldWidget.fieldKey != widget.fieldKey;
    if (fieldChanged || oldWidget.initialValue != widget.initialValue) {
      _controller.syncText(
        widget.initialValue,
        focusNode: _focusNode,
        force: fieldChanged || widget.initialValue.isEmpty,
      );
    }
  }

  @override
  void dispose() {
    _detachFocusDispatch();
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5FCFF),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.fromLTRB(14, 7, 14, 7),
      child: TextFormField(
        key: widget.fieldKey,
        controller: _controller,
        focusNode: _focusNode,
        maxLength: widget.maxLength,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          counterText: '',
          border: InputBorder.none,
        ),
        style: sans(size: 13.5, height: 1.5),
      ),
    );
  }
}

class _MusicNoteCard extends StatelessWidget {
  const _MusicNoteCard({
    required this.controller,
    required this.note,
    required this.onOpenExternalLink,
  });

  final AlagagiController controller;
  final MusicNote note;
  final ValueChanged<String> onOpenExternalLink;

  @override
  Widget build(BuildContext context) {
    final isMine = note.createdByProfileId == controller.state.me.id;
    final creator = isMine
        ? controller.state.me.nickname
        : controller.state.partner.nickname;
    final detailBody = [
      if (note.note.trim().isNotEmpty) note.note.trim(),
      if (note.link.trim().isNotEmpty) '링크\n${note.link.trim()}',
    ].join('\n\n');
    final showReadableCue =
        note.link.trim().isNotEmpty || _showsCompactReadableCue(detailBody);
    final openableLink = _normalizedOpenableLink(note.link);
    final listened = note.isListenedBy(controller.state.me.id);
    final commentCount = controller.musicCommentCountForNote(note.id);
    final latestComment = controller.latestMusicCommentForNote(note.id);
    return GestureDetector(
      key: musicNoteCardKey(note.id),
      behavior: HitTestBehavior.opaque,
      onTap: () => _showMusicNoteDetailSheet(
        context,
        controller: controller,
        noteId: note.id,
        onOpenExternalLink: onOpenExternalLink,
      ),
      child: AlagagiPaperCard(
        radius: 19,
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MusicCover(
              color: isMine ? AlagagiColors.sage : AlagagiColors.lavender,
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
                          note.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: sans(
                            size: 14,
                            weight: FontWeight.w700,
                            color: const Color(0xFF33332F),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      AlagagiSmallBadge(label: note.mood),
                      if (isMine) ...[
                        const SizedBox(width: 4),
                        Tooltip(
                          message: '음악 노트 수정',
                          child: IconButton(
                            key: musicEditButtonKey(note.id),
                            onPressed: () => controller.startMusicEdit(note.id),
                            icon: const Icon(Icons.edit_rounded, size: 17),
                            color: AlagagiColors.sageDeep,
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints.tightFor(
                              width: 32,
                              height: 32,
                            ),
                          ),
                        ),
                        Tooltip(
                          message: '음악 노트 삭제',
                          child: IconButton(
                            key: musicDeleteButtonKey(note.id),
                            onPressed: () =>
                                controller.deleteMusicNote(note.id),
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              size: 17,
                            ),
                            color: const Color(0xFFB35A49),
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints.tightFor(
                              width: 32,
                              height: 32,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$creator · ${note.artist}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: sans(size: 11.6, color: AlagagiColors.muted),
                  ),
                  if (note.note.isNotEmpty) ...[
                    const SizedBox(height: 7),
                    Text(
                      note.note,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: sans(
                        size: 12.3,
                        color: const Color(0xFF6F6C65),
                        height: 1.45,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _MusicListenedButton(
                        note: note,
                        listened: listened,
                        onPressed: () =>
                            controller.toggleMusicNoteListened(note.id),
                      ),
                      if (note.link.isNotEmpty)
                        if (openableLink == null)
                          Text(
                            '링크가 저장되어 있어요',
                            style: sans(
                              size: 11,
                              color: AlagagiColors.sageDeep,
                            ),
                          )
                        else
                          _MusicLinkButton(
                            key: musicLinkButtonKey(note.id),
                            onPressed: () => onOpenExternalLink(openableLink),
                          ),
                      if (showReadableCue) const AlagagiFullTextCue(),
                      _MusicCommentCountChip(
                        count: commentCount,
                        onPressed: () => _showMusicNoteDetailSheet(
                          context,
                          controller: controller,
                          noteId: note.id,
                          onOpenExternalLink: onOpenExternalLink,
                        ),
                      ),
                    ],
                  ),
                  if (latestComment != null) ...[
                    const SizedBox(height: 9),
                    _MusicCommentPreview(
                      controller: controller,
                      comment: latestComment,
                      count: commentCount,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MusicCommentCountChip extends StatelessWidget {
  const _MusicCommentCountChip({required this.count, required this.onPressed});

  final int count;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.chat_bubble_outline_rounded, size: 13),
        label: Text(count == 0 ? '댓글 남기기' : '댓글 $count', softWrap: false),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF756684),
          backgroundColor: const Color(0xFFF6F2F8),
          minimumSize: const Size(0, 30),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          side: const BorderSide(color: Color(0x33B9A8C9)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 9),
          textStyle: sans(size: 11.5, weight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _MusicCommentPreview extends StatelessWidget {
  const _MusicCommentPreview({
    required this.controller,
    required this.comment,
    required this.count,
  });

  final AlagagiController controller;
  final MusicNoteComment comment;
  final int count;

  @override
  Widget build(BuildContext context) {
    final author = comment.createdByProfileId == controller.state.me.id
        ? '내 댓글'
        : '${controller.state.partner.nickname}님의 댓글';
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAF8FB),
        border: Border.all(color: const Color(0x1FB9A8C9)),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Color(0xFFF0EDF5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              size: 13,
              color: Color(0xFF756684),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: sans(
                    size: 11.3,
                    weight: FontWeight.w800,
                    color: const Color(0xFF5F5667),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  comment.body,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: sans(size: 11.4, color: AlagagiColors.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            constraints: const BoxConstraints(minWidth: 26),
            height: 24,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF8FD),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '$count',
              style: sans(
                size: 10.8,
                weight: FontWeight.w900,
                color: const Color(0xFF315F7A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MusicListenedButton extends StatelessWidget {
  const _MusicListenedButton({
    required this.note,
    required this.listened,
    required this.onPressed,
  });

  final MusicNote note;
  final bool listened;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final bothListened = note.listenedByProfileIds.length >= 2;
    final label = bothListened
        ? '둘 다 들음'
        : listened
        ? '들었어요'
        : '아직';
    return Tooltip(
      message: listened ? '들은 표시 취소' : '들었어요 표시',
      child: SizedBox(
        height: 30,
        child: OutlinedButton(
          key: musicListenedButtonKey(note.id),
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: listened
                ? const Color(0xFFEFF8FD)
                : const Color(0xFFF5FCFF),
            foregroundColor: listened
                ? AlagagiColors.sageDeep
                : AlagagiColors.muted,
            side: BorderSide(
              color: listened
                  ? const Color(0x668A9A7E)
                  : const Color(0x22000000),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            minimumSize: const Size(0, 30),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            textStyle: sans(size: 11.4, weight: FontWeight.w800),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(listened ? '🎧' : '👀', style: sans(size: 12)),
              const SizedBox(width: 5),
              Text(label, softWrap: false),
            ],
          ),
        ),
      ),
    );
  }
}

class _MusicLinkButton extends StatelessWidget {
  const _MusicLinkButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.open_in_new_rounded, size: 13),
        label: const Text('링크 열기', softWrap: false),
        style: OutlinedButton.styleFrom(
          foregroundColor: AlagagiColors.sageDeep,
          minimumSize: const Size(0, 30),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          side: const BorderSide(color: Color(0x336F7F63)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 9),
          textStyle: sans(size: 11.5, weight: FontWeight.w800),
        ),
      ),
    );
  }
}

void _showMusicNoteDetailSheet(
  BuildContext context, {
  required AlagagiController controller,
  required String noteId,
  required ValueChanged<String> onOpenExternalLink,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final note = controller.musicNotes.cast<MusicNote?>().firstWhere(
            (candidate) => candidate?.id == noteId,
            orElse: () => null,
          );
          if (note == null) {
            return const SizedBox.shrink();
          }
          return _MusicNoteDetailSheet(
            controller: controller,
            note: note,
            onOpenExternalLink: onOpenExternalLink,
          );
        },
      );
    },
  );
}

class _MusicNoteDetailSheet extends StatelessWidget {
  const _MusicNoteDetailSheet({
    required this.controller,
    required this.note,
    required this.onOpenExternalLink,
  });

  final AlagagiController controller;
  final MusicNote note;
  final ValueChanged<String> onOpenExternalLink;

  @override
  Widget build(BuildContext context) {
    final isMine = note.createdByProfileId == controller.state.me.id;
    final creator = isMine
        ? controller.state.me.nickname
        : controller.state.partner.nickname;
    final openableLink = _normalizedOpenableLink(note.link);
    final comments = controller.musicCommentsForNote(note.id);
    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.42,
      maxChildSize: 0.92,
      expand: false,
      builder: (_, scrollController) {
        return SafeArea(
          child: Container(
            key: readableDetailSheetKey,
            margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            decoration: BoxDecoration(
              color: AlagagiColors.paper,
              border: Border.all(color: AlagagiColors.line),
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x2E2C2B25),
                  blurRadius: 44,
                  offset: Offset(0, 18),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD7D5CC),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                _MusicDetailHeader(
                  note: note,
                  creator: creator,
                  isMine: isMine,
                  onClose: () => Navigator.of(context).pop(),
                  onEdit: isMine
                      ? () {
                          Navigator.of(context).pop();
                          controller.startMusicEdit(note.id);
                        }
                      : null,
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    children: [
                      _MusicDetailBodyCard(note: note),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 7,
                        children: [
                          _MusicListenedButton(
                            note: note,
                            listened: note.isListenedBy(controller.state.me.id),
                            onPressed: () =>
                                controller.toggleMusicNoteListened(note.id),
                          ),
                          if (note.link.isNotEmpty)
                            if (openableLink == null)
                              Text(
                                '링크가 저장되어 있어요',
                                style: sans(
                                  size: 11.5,
                                  color: AlagagiColors.sageDeep,
                                ),
                              )
                            else
                              _MusicLinkButton(
                                onPressed: () =>
                                    onOpenExternalLink(openableLink),
                              ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      _MusicCommentSectionTitle(count: comments.length),
                      const SizedBox(height: 10),
                      if (comments.isEmpty)
                        const _MusicCommentEmptyState()
                      else
                        for (final comment in comments) ...[
                          _MusicCommentTile(
                            controller: controller,
                            comment: comment,
                          ),
                          const SizedBox(height: 11),
                        ],
                      _MusicCommentComposer(
                        controller: controller,
                        noteId: note.id,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MusicDetailHeader extends StatelessWidget {
  const _MusicDetailHeader({
    required this.note,
    required this.creator,
    required this.isMine,
    required this.onClose,
    required this.onEdit,
  });

  final MusicNote note;
  final String creator;
  final bool isMine;
  final VoidCallback onClose;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFEFF8FD), AlagagiColors.paper],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MusicCover(
            color: isMine ? AlagagiColors.sage : AlagagiColors.lavender,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '음악 노트',
                  style: sans(
                    size: 10.5,
                    weight: FontWeight.w800,
                    color: AlagagiColors.sageDeep,
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  note.title,
                  style: serif(
                    context,
                    size: 19.5,
                    weight: FontWeight.w800,
                    height: 1.38,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: [
                    AlagagiSmallBadge(label: '$creator · ${note.artist}'),
                    AlagagiSmallBadge(label: note.mood),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (onEdit != null)
            Tooltip(
              message: '음악 노트 수정',
              child: IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_rounded, size: 18),
                color: AlagagiColors.sageDeep,
              ),
            ),
          Tooltip(
            message: '닫기',
            child: IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close_rounded, size: 20),
              color: AlagagiColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _MusicDetailBodyCard extends StatelessWidget {
  const _MusicDetailBodyCard({required this.note});

  final MusicNote note;

  @override
  Widget build(BuildContext context) {
    final body = note.note.trim().isEmpty
        ? '남겨둔 메모는 아직 없어요.'
        : note.note.trim();
    final link = note.link.trim();
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7FCFF),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            body,
            style: sans(
              size: 13.1,
              color: const Color(0xFF5F5D56),
              height: 1.62,
            ),
          ),
          if (link.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF3FBFF),
                borderRadius: BorderRadius.circular(13),
              ),
              padding: const EdgeInsets.all(11),
              child: Text(
                link,
                style: sans(
                  size: 11.8,
                  color: AlagagiColors.sageDeep,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MusicCommentSectionTitle extends StatelessWidget {
  const _MusicCommentSectionTitle({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            count == 0 ? '댓글 없음' : '댓글 $count',
            style: sans(
              size: 13.3,
              weight: FontWeight.w900,
              color: const Color(0xFF3E3D39),
            ),
          ),
        ),
        Text(
          '최근 댓글이 위로 올라와요',
          style: sans(size: 10.8, color: AlagagiColors.muted),
        ),
      ],
    );
  }
}

class _MusicCommentEmptyState extends StatelessWidget {
  const _MusicCommentEmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FCFF),
        border: Border.all(color: const Color(0x338A9A7E)),
        borderRadius: BorderRadius.circular(17),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      child: Column(
        children: [
          const Icon(
            Icons.chat_bubble_outline_rounded,
            size: 19,
            color: AlagagiColors.sageDeep,
          ),
          const SizedBox(height: 7),
          Text(
            '아직 남긴 말이 없어요',
            style: sans(size: 12.8, weight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            '들어본 뒤 짧은 감상을 하나만 붙여도 이 곡의 기억이 더 선명해져요.',
            textAlign: TextAlign.center,
            style: sans(size: 11.6, color: AlagagiColors.muted, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _MusicCommentTile extends StatelessWidget {
  const _MusicCommentTile({required this.controller, required this.comment});

  final AlagagiController controller;
  final MusicNoteComment comment;

  @override
  Widget build(BuildContext context) {
    final isMine = comment.createdByProfileId == controller.state.me.id;
    final author = isMine
        ? controller.state.me.nickname
        : controller.state.partner.nickname;
    final editing = controller.hasMusicCommentEditDraft(comment.id);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: isMine ? const Color(0xFFF0EDF5) : const Color(0xFFEFF8FD),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            author.isEmpty ? '?' : author.substring(0, 1),
            style: sans(
              size: 12,
              weight: FontWeight.w900,
              color: isMine ? const Color(0xFF756684) : AlagagiColors.sageDeep,
            ),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: sans(size: 12.3, weight: FontWeight.w900),
                    ),
                  ),
                  Text(
                    comment.edited
                        ? '${comment.createdLabel} · 수정됨'
                        : comment.createdLabel,
                    style: sans(size: 10.6, color: AlagagiColors.muted),
                  ),
                  if (isMine && !editing) ...[
                    const SizedBox(width: 4),
                    Tooltip(
                      message: '댓글 수정',
                      child: IconButton(
                        key: musicCommentEditButtonKey(comment.id),
                        onPressed: () =>
                            controller.startMusicCommentEdit(comment.id),
                        icon: const Icon(Icons.edit_rounded, size: 15),
                        color: AlagagiColors.sageDeep,
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints.tightFor(
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ),
                    Tooltip(
                      message: '댓글 삭제',
                      child: IconButton(
                        key: musicCommentDeleteButtonKey(comment.id),
                        onPressed: () =>
                            controller.deleteMusicComment(comment.id),
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          size: 15,
                        ),
                        color: const Color(0xFFB35A49),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints.tightFor(
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              if (editing)
                _MusicCommentEditPanel(controller: controller, comment: comment)
              else
                Text(
                  comment.body,
                  style: sans(
                    size: 12.6,
                    color: const Color(0xFF67635D),
                    height: 1.55,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MusicCommentComposer extends StatefulWidget {
  const _MusicCommentComposer({required this.controller, required this.noteId});

  final AlagagiController controller;
  final String noteId;

  @override
  State<_MusicCommentComposer> createState() => _MusicCommentComposerState();
}

class _MusicCommentComposerState extends State<_MusicCommentComposer> {
  late final ImeSafeTextEditingController _textController;
  late final FocusNode _focusNode;
  late final VoidCallback _detachFocusDispatch;

  @override
  void initState() {
    super.initState();
    _textController = ImeSafeTextEditingController(
      text: widget.controller.musicCommentDraftForNote(widget.noteId),
      onCommittedChanged: _updateDraft,
    );
    _focusNode = FocusNode();
    _detachFocusDispatch = dispatchTextOnFocusLost(_textController, _focusNode);
  }

  @override
  void didUpdateWidget(covariant _MusicCommentComposer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _textController.onCommittedChanged = _updateDraft;
    final draft = widget.controller.musicCommentDraftForNote(widget.noteId);
    _textController.syncText(
      draft,
      focusNode: _focusNode,
      force: oldWidget.noteId != widget.noteId || draft.isEmpty,
    );
  }

  @override
  void dispose() {
    _detachFocusDispatch();
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _updateDraft(String value) {
    widget.controller.updateMusicCommentDraft(widget.noteId, value);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.controller.state;
    final saving = state.musicCommentSaveStatus == SaveStatus.saving;
    final failed = state.musicCommentSaveStatus == SaveStatus.failed;
    return Container(
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FCFF),
        border: Border.all(color: const Color(0x338A9A7E)),
        borderRadius: BorderRadius.circular(17),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '감상 남기기',
                  style: sans(
                    size: 11.7,
                    weight: FontWeight.w900,
                    color: AlagagiColors.sageDeep,
                  ),
                ),
              ),
              Text(
                '${_textController.text.length} / 180',
                style: sans(size: 10.6, color: AlagagiColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            key: musicCommentFieldKey(widget.noteId),
            controller: _textController,
            focusNode: _focusNode,
            minLines: 2,
            maxLines: 4,
            maxLength: 180,
            decoration: InputDecoration(
              hintText: '이 곡을 듣고 떠오른 말을 짧게 남겨요.',
              counterText: '',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AlagagiColors.line),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AlagagiColors.line),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AlagagiColors.sage),
              ),
            ),
            style: sans(size: 12.5, height: 1.5),
          ),
          if (state.musicCommentError != null) ...[
            const SizedBox(height: 8),
            Text(
              state.musicCommentError!,
              style: sans(size: 11.6, color: const Color(0xFFB35A49)),
            ),
          ] else if (state.musicCommentSaveFeedback != null) ...[
            const SizedBox(height: 8),
            Text(
              state.musicCommentSaveFeedback!,
              style: sans(size: 11.6, color: AlagagiColors.sageDeep),
            ),
          ],
          const SizedBox(height: 9),
          Row(
            children: [
              Expanded(
                child: Text(
                  '저장은 버튼을 눌렀을 때만',
                  style: sans(size: 10.8, color: AlagagiColors.muted),
                ),
              ),
              if (failed && widget.controller.canRetryMusicCommentSave)
                TextButton(
                  key: state.musicCommentSaveTargetId == null
                      ? null
                      : musicCommentRetryButtonKey(
                          state.musicCommentSaveTargetId!,
                        ),
                  onPressed: widget.controller.retryMusicCommentSave,
                  child: const Text('다시 시도'),
                ),
              const SizedBox(width: 8),
              SizedBox(
                width: 38,
                height: 38,
                child: ElevatedButton(
                  key: musicCommentSubmitButtonKey(widget.noteId),
                  onPressed: saving
                      ? null
                      : () =>
                            widget.controller.submitMusicComment(widget.noteId),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AlagagiColors.sageDeep,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                    shape: const CircleBorder(),
                  ),
                  child: Icon(
                    saving ? Icons.sync_rounded : Icons.send_rounded,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MusicCommentEditPanel extends StatefulWidget {
  const _MusicCommentEditPanel({
    required this.controller,
    required this.comment,
  });

  final AlagagiController controller;
  final MusicNoteComment comment;

  @override
  State<_MusicCommentEditPanel> createState() => _MusicCommentEditPanelState();
}

class _MusicCommentEditPanelState extends State<_MusicCommentEditPanel> {
  late final ImeSafeTextEditingController _textController;
  late final FocusNode _focusNode;
  late final VoidCallback _detachFocusDispatch;

  @override
  void initState() {
    super.initState();
    _textController = ImeSafeTextEditingController(
      text: widget.controller.musicCommentEditDraftForComment(
        widget.comment.id,
      ),
      onCommittedChanged: _updateDraft,
    );
    _focusNode = FocusNode();
    _detachFocusDispatch = dispatchTextOnFocusLost(_textController, _focusNode);
  }

  @override
  void didUpdateWidget(covariant _MusicCommentEditPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    _textController.onCommittedChanged = _updateDraft;
    final draft = widget.controller.musicCommentEditDraftForComment(
      widget.comment.id,
    );
    _textController.syncText(
      draft,
      focusNode: _focusNode,
      force: oldWidget.comment.id != widget.comment.id || draft.isEmpty,
    );
  }

  @override
  void dispose() {
    _detachFocusDispatch();
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _updateDraft(String value) {
    widget.controller.updateMusicCommentEditDraft(widget.comment.id, value);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final saving =
        widget.controller.state.musicCommentSaveStatus == SaveStatus.saving &&
        widget.controller.isMusicCommentSaveTarget(widget.comment.id);
    return Container(
      margin: const EdgeInsets.only(top: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F6FA),
        border: Border.all(color: const Color(0x33B9A8C9)),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            key: musicCommentEditFieldKey(widget.comment.id),
            controller: _textController,
            focusNode: _focusNode,
            minLines: 2,
            maxLines: 4,
            maxLength: 180,
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(color: AlagagiColors.line),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(color: AlagagiColors.line),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(color: Color(0xFFB9A8C9)),
              ),
            ),
            style: sans(size: 12.5, height: 1.5),
          ),
          if (widget.controller.state.musicCommentError != null) ...[
            const SizedBox(height: 8),
            Text(
              widget.controller.state.musicCommentError!,
              style: sans(size: 11.5, color: const Color(0xFFB35A49)),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                key: musicCommentCancelButtonKey(widget.comment.id),
                onPressed: saving
                    ? null
                    : () => widget.controller.cancelMusicCommentEdit(
                        widget.comment.id,
                      ),
                child: const Text('취소'),
              ),
              const SizedBox(width: 6),
              ElevatedButton(
                key: musicCommentSaveButtonKey(widget.comment.id),
                onPressed: saving
                    ? null
                    : () => widget.controller.submitMusicCommentEdit(
                        widget.comment.id,
                      ),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color(0xFF756684),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  textStyle: sans(size: 12, weight: FontWeight.w800),
                ),
                child: Text(saving ? '저장 중' : '저장'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MusicCover extends StatelessWidget {
  const _MusicCover({
    required this.color,
    this.darkBorder = false,
    this.size = 50,
  });

  final Color color;
  final bool darkBorder;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, Color.alphaBlend(Colors.white54, color)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: darkBorder ? const Color(0xFF2F2F2B) : AlagagiColors.line,
          width: darkBorder ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Icon(
        Icons.music_note_rounded,
        size: size * 0.44,
        color: darkBorder ? Colors.white : AlagagiColors.sageDeep,
      ),
    );
  }
}

bool _showsCompactReadableCue(String body) {
  return body.trim().length > _compactReadablePreviewLength;
}

String? _normalizedOpenableLink(String rawLink) {
  final trimmed = rawLink.trim();
  if (trimmed.isEmpty) {
    return null;
  }

  final hasScheme = RegExp(r'^[a-zA-Z][a-zA-Z0-9+.-]*:').hasMatch(trimmed);
  final candidate = hasScheme ? trimmed : 'https://$trimmed';
  final uri = Uri.tryParse(candidate);
  if (uri == null || uri.host.trim().isEmpty) {
    return null;
  }

  final scheme = uri.scheme.toLowerCase();
  if (scheme != 'http' && scheme != 'https') {
    return null;
  }

  return uri.toString();
}
