import 'package:flutter/material.dart';

import '../../app/app_shell.dart';
import '../../app/test_keys.dart';
import '../../domain/alagagi_controller.dart';
import '../../shared/ui_components.dart';
import '../../shared/ui_style.dart';

const _compactReadablePreviewLength = 64;

typedef MyReadableDetailOpener =
    void Function({
      required String label,
      required String title,
      required String body,
      String? meta,
    });

class MyScreen extends StatelessWidget {
  const MyScreen({
    super.key,
    required this.controller,
    required this.onOpenGuideBook,
    required this.onOpenReadableDetail,
    this.onSignOut,
  });

  final AlagagiController controller;
  final VoidCallback onOpenGuideBook;
  final MyReadableDetailOpener onOpenReadableDetail;
  final VoidCallback? onSignOut;

  @override
  Widget build(BuildContext context) {
    final answeredItems = controller.archiveItems
        .where((item) => item.myAnswer != null && !item.myAnswer!.skipped)
        .toList();
    final myProfileCard = controller.myProfileCard;
    final myMusicNotes = controller.musicNotes
        .where((note) => note.createdByProfileId == controller.state.me.id)
        .toList();
    final recentAnswer = answeredItems.isEmpty
        ? null
        : answeredItems.first.myAnswer;
    final recentQuestion = answeredItems.isEmpty
        ? null
        : answeredItems.first.question;
    final recentMusic = myMusicNotes.isEmpty ? null : myMusicNotes.first;
    final todayAnswer = controller.todayMyAnswer;
    final needsTodayAnswer = todayAnswer == null || todayAnswer.skipped;
    final musicActionLabel = myMusicNotes.isEmpty ? '노래 남기기' : '내 노래 다듬기';
    final musicActionState = myMusicNotes.isEmpty ? '아직 없음' : '최근 1곡';

    return AlagagiScreenScroll(
      bottomNavigation: AlagagiBottomNav(controller: controller),
      children: [
        const AlagagiTopBar(title: '내 기록', trailing: ''),
        const SizedBox(height: 18),
        Column(
          key: myDashboardKey,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _MyProfileSummaryCard(controller: controller),
            const SizedBox(height: 16),
            const _MySectionHeader(title: '내 기록', trailing: '최근 기준'),
            Row(
              children: [
                Expanded(
                  child: _MyStatCard(
                    value: '${answeredItems.length}',
                    label: '남긴\n질문 답',
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: _MyStatCard(
                    value: '${myProfileCard.filledCount}',
                    label: '채운\n프로필',
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: _MyStatCard(
                    value: '${myMusicNotes.length}',
                    label: '남긴\n노래',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const _MySectionHeader(title: '다음에 해볼 것', trailing: '가볍게 하나씩'),
            _MyPrimaryNextCard(
              buttonKey: myNextPrimaryButtonKey,
              label: needsTodayAnswer ? '오늘 질문 답하기' : '우리 기록 이어보기',
              description: needsTodayAnswer
                  ? '아직 내 답이 비어 있어요. 짧게 남겨도 충분해요.'
                  : '지나온 질문들을 조용히 다시 볼 수 있어요.',
              meta: needsTodayAnswer
                  ? 'DAY ${controller.todayQuestion.day}'
                  : '우리 기록',
              progress: needsTodayAnswer ? 0.64 : 1,
              onTap: needsTodayAnswer
                  ? controller.activateHomeProgressSummaryAction
                  : () => controller.goTo(AlagagiRoute.archive),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _MyNextTile(
                    buttonKey: myProfileCardActionButtonKey,
                    icon: Icons.badge_outlined,
                    label: '우리 프로필 한 칸 채우기',
                    state:
                        '${myProfileCard.filledCount} / ${myProfileCard.totalCount}',
                    description: '대화할 때 편한 방식을 적어볼 수 있어요.',
                    tone: const Color(0xFFF0EDF4),
                    iconColor: const Color(0xFF7E6D91),
                    onTap: () {
                      controller.setProfileCardTab(ProfileCardTab.me);
                      controller.goTo(AlagagiRoute.profileCard);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MyNextTile(
                    buttonKey: myMusicActionButtonKey,
                    icon: Icons.music_note_rounded,
                    label: musicActionLabel,
                    state: musicActionState,
                    description: myMusicNotes.isEmpty
                        ? '요즘 듣는 한 곡을 남겨볼 수 있어요.'
                        : '최근 남긴 곡을 다시 수정할 수 있어요.',
                    tone: const Color(0xFFF6F0DF),
                    iconColor: const Color(0xFF8D7847),
                    onTap: () {
                      if (myMusicNotes.isEmpty) {
                        controller.startMusicDraft();
                      } else {
                        controller.startMusicEdit(myMusicNotes.first.id);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const _MySectionHeader(title: '최근 내 흔적', trailing: '읽기 전용'),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _MyTraceCard(
                    key: myTraceCardKey('question'),
                    label: 'QUESTION',
                    title: recentQuestion?.text ?? '아직 남긴 답이 없어요',
                    body: recentAnswer?.body ?? '오늘 질문부터 천천히 시작해요.',
                    onTap: () => onOpenReadableDetail(
                      label: '최근 질문 답변',
                      title: recentQuestion?.text ?? '아직 남긴 답이 없어요',
                      body: recentAnswer?.body ?? '오늘 질문부터 천천히 시작해요.',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MyTraceCard(
                    key: myTraceCardKey('music'),
                    label: 'MUSIC',
                    title: recentMusic?.title ?? '아직 담긴 노래가 없어요',
                    body: recentMusic?.note.isNotEmpty == true
                        ? recentMusic!.note
                        : '요즘의 한 곡을 가볍게 남겨볼 수 있어요.',
                    onTap: () => onOpenReadableDetail(
                      label: '최근 노래',
                      title: recentMusic?.title ?? '아직 담긴 노래가 없어요',
                      body: recentMusic?.note.isNotEmpty == true
                          ? recentMusic!.note
                          : '요즘의 한 곡을 가볍게 남겨볼 수 있어요.',
                      meta: recentMusic == null
                          ? null
                          : '${recentMusic.artist} · ${recentMusic.mood}',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _MyHelpCard(onOpenGuide: onOpenGuideBook),
            const SizedBox(height: 16),
            _MyAccountCard(onSignOut: onSignOut),
          ],
        ),
      ],
    );
  }
}

class _MyProfileSummaryCard extends StatelessWidget {
  const _MyProfileSummaryCard({required this.controller});

  final AlagagiController controller;

  @override
  Widget build(BuildContext context) {
    return AlagagiPaperCard(
      radius: 22,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AlagagiColors.sage,
                      Color.alphaBlend(Colors.white60, AlagagiColors.sage),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Text(
                  _profileInitial(controller.state.me.nickname),
                  style: serif(
                    context,
                    size: 22,
                    weight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.state.me.nickname,
                      style: serif(context, size: 21, weight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${controller.state.partner.nickname}과 함께 쓰는 둘만의 공간에 들어와 있어요.',
                      style: sans(
                        size: 12.5,
                        color: AlagagiColors.muted,
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _MyStatusChip(label: '로그인됨'),
              _MyStatusChip(label: '조용한 속도'),
              _MyStatusChip(label: '2명 공간'),
            ],
          ),
        ],
      ),
    );
  }

  static String _profileInitial(String nickname) {
    if (nickname.isEmpty) {
      return '?';
    }
    return nickname.substring(0, 1);
  }
}

class _MyStatusChip extends StatelessWidget {
  const _MyStatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2EA),
        border: Border.all(color: const Color(0x338A9A7E)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AlagagiColors.sage,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: sans(
              size: 11.5,
              weight: FontWeight.w700,
              color: AlagagiColors.sageDeep,
            ),
          ),
        ],
      ),
    );
  }
}

class _MySectionHeader extends StatelessWidget {
  const _MySectionHeader({required this.title, required this.trailing});

  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              title,
              style: serif(context, size: 18, weight: FontWeight.w800),
            ),
          ),
          Text(trailing, style: sans(size: 11.5, color: AlagagiColors.muted)),
        ],
      ),
    );
  }
}

class _MyStatCard extends StatelessWidget {
  const _MyStatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return AlagagiPaperCard(
      radius: 18,
      padding: const EdgeInsets.fromLTRB(11, 13, 11, 13),
      child: SizedBox(
        height: 72,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: serif(context, size: 24, weight: FontWeight.w800),
            ),
            const SizedBox(height: 7),
            Text(
              label,
              style: sans(size: 11.5, color: AlagagiColors.muted, height: 1.2),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyPrimaryNextCard extends StatelessWidget {
  const _MyPrimaryNextCard({
    required this.buttonKey,
    required this.label,
    required this.description,
    required this.meta,
    required this.progress,
    required this.onTap,
  });

  final Key buttonKey;
  final String label;
  final String description;
  final String meta;
  final double progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: buttonKey,
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AlagagiColors.paper, Color(0xFFEEF2EA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: const Color(0x428A9A7E)),
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0F4A4841),
                blurRadius: 24,
                offset: Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 23,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.72),
                        border: Border.all(color: const Color(0x2E6F7F63)),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'NEXT STEP',
                        style: sans(
                          size: 10,
                          weight: FontWeight.w800,
                          color: AlagagiColors.sageDeep,
                        ),
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      label,
                      style: sans(
                        size: 15,
                        weight: FontWeight.w800,
                        color: const Color(0xFF46443F),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style: sans(
                        size: 12,
                        color: AlagagiColors.muted,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 13),
                    Row(
                      children: [
                        Container(
                          height: 25,
                          padding: const EdgeInsets.symmetric(horizontal: 9),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            meta,
                            style: sans(
                              size: 10.8,
                              weight: FontWeight.w800,
                              color: AlagagiColors.sageDeep,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: LinearProgressIndicator(
                              value: progress.clamp(0, 1),
                              minHeight: 5,
                              backgroundColor: const Color(0x2E8A9A7E),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AlagagiColors.sage,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: AlagagiColors.sageDeep,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MyNextTile extends StatelessWidget {
  const _MyNextTile({
    required this.buttonKey,
    required this.icon,
    required this.label,
    required this.state,
    required this.description,
    required this.tone,
    required this.iconColor,
    required this.onTap,
  });

  final Key buttonKey;
  final IconData icon;
  final String label;
  final String state;
  final String description;
  final Color tone;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: buttonKey,
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AlagagiPaperCard(
          radius: 20,
          padding: const EdgeInsets.all(13),
          child: SizedBox(
            height: 98,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: tone,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(icon, size: 18, color: iconColor),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state,
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: sans(
                          size: 10.5,
                          weight: FontWeight.w700,
                          color: AlagagiColors.muted,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: sans(
                    size: 13,
                    height: 1.35,
                    weight: FontWeight.w800,
                    color: const Color(0xFF46443F),
                  ),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: sans(
                      size: 11.3,
                      color: AlagagiColors.muted,
                      height: 1.45,
                    ),
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

class _MyTraceCard extends StatelessWidget {
  const _MyTraceCard({
    super.key,
    required this.label,
    required this.title,
    required this.body,
    required this.onTap,
  });

  final String label;
  final String title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final showReadableCue = body.trim().length > _compactReadablePreviewLength;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AlagagiPaperCard(
        radius: 20,
        padding: const EdgeInsets.all(14),
        child: SizedBox(
          height: 104,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: sans(
                  size: 10,
                  weight: FontWeight.w800,
                  color: AlagagiColors.sageDeep,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: sans(
                  size: 13.6,
                  weight: FontWeight.w800,
                  color: const Color(0xFF46443F),
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 7),
              Expanded(
                child: Text(
                  body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: sans(
                    size: 11.6,
                    color: AlagagiColors.muted,
                    height: 1.45,
                  ),
                ),
              ),
              if (showReadableCue) ...[
                const SizedBox(height: 4),
                const AlagagiFullTextCue(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MyHelpCard extends StatelessWidget {
  const _MyHelpCard({required this.onOpenGuide});

  final VoidCallback onOpenGuide;

  @override
  Widget build(BuildContext context) {
    return AlagagiPaperCard(
      radius: 20,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '도움말',
            style: sans(
              size: 13.2,
              weight: FontWeight.w800,
              color: const Color(0xFF46443F),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '헷갈릴 때만 조용히 열어볼 수 있어요. 읽어도 상대에게 알림이 가지 않습니다.',
            style: sans(size: 11.7, color: AlagagiColors.muted, height: 1.55),
          ),
          const SizedBox(height: 12),
          Material(
            color: Colors.transparent,
            child: InkWell(
              key: myFirstVisitGuideButtonKey,
              borderRadius: BorderRadius.circular(18),
              onTap: onOpenGuide,
              child: Container(
                decoration: BoxDecoration(
                  color: AlagagiColors.paper,
                  border: Border.all(color: AlagagiColors.line),
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: const EdgeInsets.all(13),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2EA),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        Icons.menu_book_outlined,
                        size: 19,
                        color: AlagagiColors.sageDeep,
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '처음 안내 다시 보기',
                            style: sans(
                              size: 12.8,
                              weight: FontWeight.w800,
                              color: const Color(0xFF46443F),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '짧은 기능 안내를 다시 확인해요.',
                            style: sans(
                              size: 11.2,
                              color: AlagagiColors.muted,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 9),
                    Container(
                      width: 26,
                      height: 26,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEEF2EA),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: AlagagiColors.sageDeep,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MyAccountCard extends StatelessWidget {
  const _MyAccountCard({required this.onSignOut});

  final VoidCallback? onSignOut;

  @override
  Widget build(BuildContext context) {
    return AlagagiPaperCard(
      radius: 20,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '계정',
            style: sans(
              size: 13.2,
              weight: FontWeight.w800,
              color: const Color(0xFF46443F),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            onSignOut == null
                ? '이 기기에서 이어가는 조용한 공간이에요.'
                : '이 기기에서 잠시 나가고 싶을 때만 로그아웃하면 돼요.',
            style: sans(size: 11.7, color: AlagagiColors.muted, height: 1.55),
          ),
          if (onSignOut != null) ...[
            const SizedBox(height: 13),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton(
                onPressed: onSignOut,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AlagagiColors.sageDeep,
                  side: const BorderSide(color: Color(0x336F7F63)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: sans(size: 13, weight: FontWeight.w800),
                ),
                child: const Text('로그아웃'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
