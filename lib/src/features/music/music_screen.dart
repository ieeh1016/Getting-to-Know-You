import 'package:flutter/material.dart';

import '../../app/app_shell.dart';
import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/ui_components.dart';
import '../../shared/ui_style.dart';

const _compactReadablePreviewLength = 64;

typedef MusicReadableDetailOpener =
    void Function({
      required String label,
      required String title,
      required String body,
      String? meta,
      String? actionLabel,
      VoidCallback? onAction,
    });

class MusicScreen extends StatelessWidget {
  const MusicScreen({
    super.key,
    required this.controller,
    required this.onOpenExternalLink,
    required this.onOpenReadableDetail,
  });

  final AlagagiController controller;
  final ValueChanged<String> onOpenExternalLink;
  final MusicReadableDetailOpener onOpenReadableDetail;

  @override
  Widget build(BuildContext context) {
    final notes = controller.visibleMusicNotes;
    final totalCount = controller.musicNotes.length;
    return AlagagiScreenScroll(
      bottomNavigation: AlagagiBottomNav(controller: controller),
      children: [
        Text('음악 노트', style: serif(context, size: 23, weight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(
          '각자의 요즘을 한 곡씩 조용히 남겨요',
          style: sans(size: 12.5, color: AlagagiColors.muted),
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
        const SizedBox(height: 18),
        Row(
          children: [
            const Expanded(child: AlagagiSectionLabel('들어볼 곡')),
            if (!controller.state.musicDraftVisible)
              _MusicAddInlineButton(controller: controller),
          ],
        ),
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
              onOpenReadableDetail: onOpenReadableDetail,
            ),
            const SizedBox(height: 12),
          ],
      ],
    );
  }
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
              _OverlapCover(color: Color(0xFFC8AD6D)),
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
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final mood in musicMoodOptions)
                AlagagiFilterPill(
                  label: mood,
                  selected: controller.state.musicDraftMood == mood,
                  onTap: () => controller.setMusicDraftMood(mood),
                ),
            ],
          ),
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

class _MusicTextField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F4),
        border: Border.all(color: AlagagiColors.line),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.fromLTRB(14, 7, 14, 7),
      child: TextFormField(
        key: fieldKey,
        initialValue: initialValue,
        maxLength: maxLength,
        minLines: minLines,
        maxLines: maxLines,
        onChanged: onChanged,
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

class _MusicNoteCard extends StatelessWidget {
  const _MusicNoteCard({
    required this.controller,
    required this.note,
    required this.onOpenExternalLink,
    required this.onOpenReadableDetail,
  });

  final AlagagiController controller;
  final MusicNote note;
  final ValueChanged<String> onOpenExternalLink;
  final MusicReadableDetailOpener onOpenReadableDetail;

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
    return GestureDetector(
      key: musicNoteCardKey(note.id),
      behavior: HitTestBehavior.opaque,
      onTap: () => onOpenReadableDetail(
        label: '음악 노트',
        title: note.title,
        meta: '$creator · ${note.artist} · ${note.mood}',
        body: detailBody.isEmpty ? '남겨둔 메모는 아직 없어요.' : detailBody,
        actionLabel: isMine ? '수정하기' : null,
        onAction: isMine ? () => controller.startMusicEdit(note.id) : null,
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
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
                ? const Color(0xFFF1F4EC)
                : const Color(0xFFF8F8F4),
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

class _MusicCover extends StatelessWidget {
  const _MusicCover({required this.color, this.darkBorder = false});

  final Color color;
  final bool darkBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
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
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(
        Icons.music_note_rounded,
        size: 22,
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
