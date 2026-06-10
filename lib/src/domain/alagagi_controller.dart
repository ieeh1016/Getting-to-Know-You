import 'dart:async';

import 'package:flutter/foundation.dart';

enum AlagagiRoute {
  invite,
  home,
  answer,
  archive,
  records,
  music,
  balance,
  profileCard,
  wishlist,
  my,
}

enum ArchiveFilter { all, bothAnswered, similar }

enum ProfileCardTab { partner, me }

enum WishlistFilter { all, mutual, places, activities }

enum WishKind { place, activity }

const musicMoodOptions = ['차분한', '산책', '카페', '밤', '가벼운', '집중'];

enum QuestionDepth { light, daily, beliefs, inner }

enum SaveStatus { idle, saving, saved, failed }

enum HomeProgressSummaryTone { calm, waiting, ready }

enum QuestionCalendarStatus {
  future,
  unanswered,
  myAnswerOnly,
  partnerAnswerOnly,
  bothAnswered,
  skippedByMe,
  catalogEnded,
}

String firebaseEmailForLoginId(String loginId) {
  final normalized = loginId.trim().toLowerCase();
  if (normalized.contains('@')) {
    return normalized;
  }
  return '$normalized@gettoknow.local';
}

class AlagagiAuthUser {
  const AlagagiAuthUser({
    required this.uid,
    required this.loginId,
    required this.email,
  });

  final String uid;
  final String loginId;
  final String email;
}

class AlagagiAuthException implements Exception {
  const AlagagiAuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

abstract class AlagagiAuthRepository {
  Stream<AlagagiAuthUser?> authStateChanges();

  Future<AlagagiAuthUser> signInWithIdAndPassword({
    required String loginId,
    required String password,
  });

  Future<void> signOut();
}

class AlagagiSession {
  const AlagagiSession({
    required this.spaceId,
    required this.me,
    required this.partner,
    this.data = const AlagagiSpaceData(),
  });

  final String spaceId;
  final AppProfile me;
  final AppProfile partner;
  final AlagagiSpaceData data;
}

class AlagagiSpaceData {
  const AlagagiSpaceData({
    this.answers = const [],
    this.answerComments = const [],
    this.balanceSelections = const [],
    this.profileSlots = const [],
    this.wishes = const [],
    this.musicNotes = const [],
    this.dailyProgress,
    this.personalization = const SpacePersonalization(),
  });

  final List<Answer> answers;
  final List<AnswerComment> answerComments;
  final List<BalanceSelection> balanceSelections;
  final List<ProfileSlotValue> profileSlots;
  final List<WishItem> wishes;
  final List<MusicNote> musicNotes;
  final DailyQuestionProgress? dailyProgress;
  final SpacePersonalization personalization;
}

class BalanceSelection {
  const BalanceSelection({
    required this.questionId,
    required this.profileId,
    required this.optionId,
  });

  final String questionId;
  final String profileId;
  final String optionId;
}

class ProfileSlotValue {
  const ProfileSlotValue({required this.profileId, required this.slot});

  final String profileId;
  final ProfileSlot slot;
}

abstract class AlagagiDataRepository {
  Future<AlagagiSession?> loadSession(AlagagiAuthUser user);

  Future<void> saveAnswer(String spaceId, Answer answer);

  Future<void> saveAnswerComment(String spaceId, AnswerComment comment);

  Future<void> saveDailyQuestionProgress(
    String spaceId,
    DailyQuestionProgress progress,
  );

  Future<void> saveSpacePersonalization(
    String spaceId,
    SpacePersonalization personalization,
  );

  Future<void> saveBalanceSelection(String spaceId, BalanceSelection selection);

  Future<void> saveProfileSlot(
    String spaceId,
    String profileId,
    ProfileSlot slot,
  );

  Future<void> saveWish(String spaceId, WishItem wish);

  Future<void> saveMusicNote(String spaceId, MusicNote note);
}

class AppProfile {
  const AppProfile({
    required this.id,
    required this.nickname,
    required this.avatar,
    required this.isMe,
  });

  final String id;
  final String nickname;
  final String avatar;
  final bool isMe;

  AppProfile copyWith({String? nickname, String? avatar}) {
    return AppProfile(
      id: id,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      isMe: isMe,
    );
  }
}

class DailyQuestion {
  const DailyQuestion({
    required this.id,
    required this.day,
    required this.number,
    required this.depth,
    required this.text,
    required this.highlightedText,
  });

  final String id;
  final int day;
  final int number;
  final QuestionDepth depth;
  final String text;
  final String highlightedText;
}

class Answer {
  const Answer({
    required this.questionId,
    required this.profileId,
    required this.body,
    required this.createdLabel,
    this.skipped = false,
    this.edited = false,
  });

  final String questionId;
  final String profileId;
  final String body;
  final String createdLabel;
  final bool skipped;
  final bool edited;

  Answer copyWith({
    String? questionId,
    String? profileId,
    String? body,
    String? createdLabel,
    bool? skipped,
    bool? edited,
  }) {
    return Answer(
      questionId: questionId ?? this.questionId,
      profileId: profileId ?? this.profileId,
      body: body ?? this.body,
      createdLabel: createdLabel ?? this.createdLabel,
      skipped: skipped ?? this.skipped,
      edited: edited ?? this.edited,
    );
  }
}

class AnswerComment {
  const AnswerComment({
    required this.questionId,
    required this.answerOwnerProfileId,
    required this.commenterProfileId,
    required this.body,
    required this.createdLabel,
    this.edited = false,
  });

  final String questionId;
  final String answerOwnerProfileId;
  final String commenterProfileId;
  final String body;
  final String createdLabel;
  final bool edited;
}

class DailyQuestionProgress {
  const DailyQuestionProgress({
    String? startedDateKey,
    required this.currentQuestionId,
    required this.openedDateKey,
    this.catalogVersion = 'v1',
  }) : startedDateKey = startedDateKey ?? openedDateKey;

  final String startedDateKey;
  final String currentQuestionId;
  final String openedDateKey;
  final String catalogVersion;

  DailyQuestionProgress copyWith({
    String? startedDateKey,
    String? currentQuestionId,
    String? openedDateKey,
    String? catalogVersion,
  }) {
    return DailyQuestionProgress(
      startedDateKey: startedDateKey ?? this.startedDateKey,
      currentQuestionId: currentQuestionId ?? this.currentQuestionId,
      openedDateKey: openedDateKey ?? this.openedDateKey,
      catalogVersion: catalogVersion ?? this.catalogVersion,
    );
  }
}

class SpacePersonalization {
  const SpacePersonalization({
    this.appTitle = '조금씩',
    this.homeLine = '오늘도 한 가지를 알아가요',
    this.inviteLine = '하루에 하나씩, 조용히 알아가요',
    this.accentEmoji = '🌿',
  });

  final String appTitle;
  final String homeLine;
  final String inviteLine;
  final String accentEmoji;

  SpacePersonalization copyWith({
    String? appTitle,
    String? homeLine,
    String? inviteLine,
    String? accentEmoji,
  }) {
    return SpacePersonalization(
      appTitle: appTitle ?? this.appTitle,
      homeLine: homeLine ?? this.homeLine,
      inviteLine: inviteLine ?? this.inviteLine,
      accentEmoji: accentEmoji ?? this.accentEmoji,
    );
  }
}

SpacePersonalization _normalizeBrandPersonalization(
  SpacePersonalization personalization,
) {
  const defaults = SpacePersonalization();
  final appTitle = personalization.appTitle.trim();
  if (appTitle.isEmpty || appTitle == '알아가기') {
    return personalization.copyWith(appTitle: defaults.appTitle);
  }
  return personalization;
}

class ArchiveItem {
  const ArchiveItem({
    required this.question,
    this.myAnswer,
    this.partnerAnswer,
    this.matchedKeywords = const [],
  });

  final DailyQuestion question;
  final Answer? myAnswer;
  final Answer? partnerAnswer;
  final List<String> matchedKeywords;

  bool get bothAnswered =>
      myAnswer != null &&
      partnerAnswer != null &&
      !myAnswer!.skipped &&
      !partnerAnswer!.skipped;

  bool get similar => matchedKeywords.isNotEmpty;
}

class QuestionCalendarDay {
  const QuestionCalendarDay({
    required this.dateKey,
    required this.question,
    required this.status,
    required this.isInDisplayedMonth,
    required this.isToday,
    required this.isSelected,
    required this.canLateAnswer,
  });

  final String dateKey;
  final DailyQuestion? question;
  final QuestionCalendarStatus status;
  final bool isInDisplayedMonth;
  final bool isToday;
  final bool isSelected;
  final bool canLateAnswer;
}

class TimelineEvent {
  const TimelineEvent({
    required this.dateLabel,
    required this.description,
    this.highlight,
  });

  final String dateLabel;
  final String description;
  final String? highlight;
}

class RelationshipInsight {
  const RelationshipInsight({
    required this.daysTogether,
    required this.questionCount,
    required this.matchCount,
    required this.longestAnswerLength,
    required this.similarityPercent,
    required this.matchedKeywords,
    required this.timeline,
  });

  final int daysTogether;
  final int questionCount;
  final int matchCount;
  final int longestAnswerLength;
  final int similarityPercent;
  final List<String> matchedKeywords;
  final List<TimelineEvent> timeline;
}

class BalanceOption {
  const BalanceOption({
    required this.id,
    required this.icon,
    required this.label,
  });

  final String id;
  final String icon;
  final String label;
}

class BalanceQuestion {
  const BalanceQuestion({
    required this.id,
    required this.prompt,
    required this.left,
    required this.right,
    this.partnerChoiceId,
  });

  final String id;
  final String prompt;
  final BalanceOption left;
  final BalanceOption right;
  final String? partnerChoiceId;
}

class ProfileSlot {
  const ProfileSlot({
    required this.id,
    required this.label,
    required this.icon,
    this.category = '취향',
    this.inputHint = '편한 만큼 적어두기',
    this.value,
    this.locked = false,
    this.unlockHint,
  });

  final String id;
  final String label;
  final String icon;
  final String category;
  final String inputHint;
  final String? value;
  final bool locked;
  final String? unlockHint;

  ProfileSlot copyWith({
    String? value,
    bool? locked,
    String? unlockHint,
    String? category,
    String? inputHint,
  }) {
    return ProfileSlot(
      id: id,
      label: label,
      icon: icon,
      category: category ?? this.category,
      inputHint: inputHint ?? this.inputHint,
      value: value ?? this.value,
      locked: locked ?? this.locked,
      unlockHint: unlockHint ?? this.unlockHint,
    );
  }
}

class ProfileCardData {
  const ProfileCardData({
    required this.profile,
    required this.subtitle,
    required this.slots,
  });

  final AppProfile profile;
  final String subtitle;
  final List<ProfileSlot> slots;

  int get filledCount => slots.where((slot) => slot.value != null).length;

  int get totalCount => slots.length;

  ProfileCardData copyWith({List<ProfileSlot>? slots, AppProfile? profile}) {
    return ProfileCardData(
      profile: profile ?? this.profile,
      subtitle: subtitle,
      slots: slots ?? this.slots,
    );
  }
}

const profileSlotCatalogV2 = [
  ProfileSlot(
    id: 'song',
    icon: 'music',
    label: '요즘 노래',
    category: '취향',
    inputHint: '요즘 자주 듣는 노래',
  ),
  ProfileSlot(
    id: 'food',
    icon: 'food',
    label: '먹고 싶은 음식',
    category: '취향',
    inputHint: '요즘 먹고 싶은 음식',
  ),
  ProfileSlot(
    id: 'rest',
    icon: 'rest',
    label: '쉬는 방식',
    category: '하루',
    inputHint: '쉬고 싶을 때 하는 일',
  ),
  ProfileSlot(
    id: 'cafe',
    icon: 'cafe',
    label: '카페 취향',
    category: '취향',
    inputHint: '좋아하는 카페 분위기',
  ),
  ProfileSlot(
    id: 'walk',
    icon: 'walk',
    label: '산책 취향',
    category: '취향',
    inputHint: '걷고 싶은 길',
  ),
  ProfileSlot(
    id: 'small_taste',
    icon: 'taste',
    label: '요즘 꽂힌 작은 취향',
    category: '취향',
    inputHint: '노래, 음식, 물건, 장소 무엇이든',
  ),
  ProfileSlot(
    id: 'object',
    icon: 'object',
    label: '자주 손이 가는 물건',
    category: '취향',
    inputHint: '요즘 자주 쓰는 작은 물건',
  ),
  ProfileSlot(
    id: 'comfort',
    icon: 'comfort',
    label: '편해지는 순간',
    category: '하루',
    inputHint: '나를 편하게 하는 것',
  ),
  ProfileSlot(
    id: 'morning_night',
    icon: 'time',
    label: '아침과 밤 중 편한 쪽',
    category: '하루',
    inputHint: '더 편한 시간대',
  ),
  ProfileSlot(
    id: 'focus_time',
    icon: 'focus',
    label: '집중이 잘 되는 시간',
    category: '하루',
    inputHint: '잘 몰입되는 시간',
  ),
  ProfileSlot(
    id: 'weekend',
    icon: 'weekend',
    label: '주말의 밀도',
    category: '하루',
    inputHint: '꽉 찬 주말 또는 느슨한 주말',
  ),
  ProfileSlot(
    id: 'recharge',
    icon: 'recharge',
    label: '충전되는 방식',
    category: '하루',
    inputHint: '에너지가 돌아오는 방식',
  ),
  ProfileSlot(
    id: 'promise',
    icon: 'promise',
    label: '약속에서 중요한 것',
    category: '대화',
    inputHint: '은근히 중요하게 보는 것',
  ),
  ProfileSlot(
    id: 'kindness',
    icon: 'kindness',
    label: '기억나는 다정함',
    category: '대화',
    inputHint: '오래 남는 다정함',
  ),
  ProfileSlot(
    id: 'pace',
    icon: 'pace',
    label: '나에게 맞는 속도',
    category: '대화',
    inputHint: '요즘 필요한 속도',
  ),
  ProfileSlot(
    id: 'talk_style',
    icon: 'talk',
    label: '대화할 때 편한 방식',
    category: '대화',
    inputHint: '편하게 느끼는 대화 흐름',
  ),
  ProfileSlot(
    id: 'careful_words',
    icon: 'words',
    label: '조심스러운 표현',
    category: '대화',
    inputHint: '천천히 말하고 싶은 것',
  ),
  ProfileSlot(
    id: 'question_style',
    icon: 'question',
    label: '좋아하는 질문 방식',
    category: '대화',
    inputHint: '편하게 답할 수 있는 질문',
  ),
  ProfileSlot(
    id: 'wish_scene',
    icon: 'scene',
    label: '같이 해보고 싶은 장면',
    category: '함께',
    inputHint: '언젠가 같이 해보고 싶은 것',
  ),
  ProfileSlot(
    id: 'neighborhood',
    icon: 'map',
    label: '가보고 싶은 동네',
    category: '함께',
    inputHint: '함께 걸어보고 싶은 동네',
  ),
  ProfileSlot(
    id: 'shared_food',
    icon: 'shared_food',
    label: '같이 먹고 싶은 것',
    category: '함께',
    inputHint: '같이 먹으면 좋을 음식',
  ),
  ProfileSlot(
    id: 'small_hobby',
    icon: 'hobby',
    label: '가볍게 해보고 싶은 취미',
    category: '함께',
    inputHint: '부담 없는 작은 활동',
  ),
  ProfileSlot(
    id: 'rainy_day',
    icon: 'rain',
    label: '비 오는 날 하고 싶은 것',
    category: '함께',
    inputHint: '날씨가 흐릴 때 좋은 장면',
  ),
  ProfileSlot(
    id: 'photo_walk',
    icon: 'photo',
    label: '사진 남기기 좋은 순간',
    category: '함께',
    inputHint: '가볍게 찍어보고 싶은 장면',
  ),
];

class WishItem {
  const WishItem({
    required this.id,
    required this.icon,
    required this.title,
    required this.kind,
    required this.likedByProfileIds,
    this.createdByProfileId = 'me',
    this.done = false,
  });

  final String id;
  final String icon;
  final String title;
  final WishKind kind;
  final String createdByProfileId;
  final Set<String> likedByProfileIds;
  final bool done;

  bool get isMutual => likedByProfileIds.length >= 2;

  WishItem copyWith({
    String? createdByProfileId,
    Set<String>? likedByProfileIds,
    bool? done,
  }) {
    return WishItem(
      id: id,
      icon: icon,
      title: title,
      kind: kind,
      createdByProfileId: createdByProfileId ?? this.createdByProfileId,
      likedByProfileIds: likedByProfileIds ?? this.likedByProfileIds,
      done: done ?? this.done,
    );
  }
}

class MusicNote {
  const MusicNote({
    required this.id,
    required this.title,
    required this.artist,
    required this.link,
    required this.note,
    required this.mood,
    required this.createdByProfileId,
    required this.createdLabel,
    this.updatedAt,
  });

  final String id;
  final String title;
  final String artist;
  final String link;
  final String note;
  final String mood;
  final String createdByProfileId;
  final String createdLabel;
  final DateTime? updatedAt;

  MusicNote copyWith({
    String? title,
    String? artist,
    String? link,
    String? note,
    String? mood,
    String? createdByProfileId,
    String? createdLabel,
    DateTime? updatedAt,
  }) {
    return MusicNote(
      id: id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      link: link ?? this.link,
      note: note ?? this.note,
      mood: mood ?? this.mood,
      createdByProfileId: createdByProfileId ?? this.createdByProfileId,
      createdLabel: createdLabel ?? this.createdLabel,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class HomeProgressSummary {
  const HomeProgressSummary({required this.items, this.primaryAction});

  final List<HomeProgressSummaryItem> items;
  final HomeProgressSummaryAction? primaryAction;
}

class HomeProgressSummaryItem {
  const HomeProgressSummaryItem({
    required this.id,
    required this.label,
    required this.stateText,
    required this.tone,
  });

  final String id;
  final String label;
  final String stateText;
  final HomeProgressSummaryTone tone;
}

class HomeProgressSummaryAction {
  const HomeProgressSummaryAction({required this.label, required this.route});

  final String label;
  final AlagagiRoute route;
}

abstract class MusicNoteSeenStore {
  DateTime? readLastSeenMusicNoteAt(String spaceId, String profileId);

  void writeLastSeenMusicNoteAt(
    String spaceId,
    String profileId,
    DateTime timestamp,
  );
}

class MemoryMusicNoteSeenStore implements MusicNoteSeenStore {
  final Map<String, DateTime> _values = {};

  @override
  DateTime? readLastSeenMusicNoteAt(String spaceId, String profileId) {
    return _values[_key(spaceId, profileId)];
  }

  @override
  void writeLastSeenMusicNoteAt(
    String spaceId,
    String profileId,
    DateTime timestamp,
  ) {
    _values[_key(spaceId, profileId)] = timestamp;
  }

  static String _key(String spaceId, String profileId) {
    return 'alagagi:lastSeenMusicNoteAt:$spaceId:$profileId';
  }
}

abstract class FirstVisitGuideStore {
  bool hasSeenFirstVisitGuide(String spaceId, String profileId);

  void markFirstVisitGuideSeen(String spaceId, String profileId);
}

class MemoryFirstVisitGuideStore implements FirstVisitGuideStore {
  final Set<String> _seenKeys = {};

  @override
  bool hasSeenFirstVisitGuide(String spaceId, String profileId) {
    return _seenKeys.contains(_key(spaceId, profileId));
  }

  @override
  void markFirstVisitGuideSeen(String spaceId, String profileId) {
    _seenKeys.add(_key(spaceId, profileId));
  }

  static String _key(String spaceId, String profileId) {
    return 'jogeumssik:onboardingSeen:$spaceId:$profileId';
  }
}

@immutable
class AlagagiState {
  const AlagagiState({
    required this.me,
    required this.partner,
    this.route = AlagagiRoute.invite,
    this.archiveFilter = ArchiveFilter.all,
    this.profileCardTab = ProfileCardTab.partner,
    this.wishlistFilter = WishlistFilter.all,
    this.activeBalanceIndex = 0,
    this.wishDraftVisible = false,
    this.wishDraftTitle = '',
    this.wishDraftKind = WishKind.activity,
    this.musicDraftVisible = false,
    this.musicDraftTitle = '',
    this.musicDraftArtist = '',
    this.musicDraftLink = '',
    this.musicDraftNote = '',
    this.musicDraftMood = '차분한',
    this.editingMusicNoteId,
    this.draftAnswer = '',
    this.inviteError,
    this.answerError,
    this.commentError,
    this.answerSaveStatus = SaveStatus.idle,
    this.answerSaveFeedback,
    this.answerSaveQuestionId,
    this.commentSaveStatus = SaveStatus.idle,
    this.commentSaveFeedback,
    this.commentSaveTargetKey,
    this.commentDraftsByAnswerKey = const {},
    this.personalization = const SpacePersonalization(),
    this.personalizationDraft = const SpacePersonalization(),
    this.personalizationError,
    this.wishDraftError,
    this.musicDraftError,
    this.skippedToday = false,
    this.editingAnswer = false,
    this.expandedAnswerKeys = const {},
    this.activeAnswerQuestionId,
    this.selectedArchiveDateKey,
    this.firstVisitGuideVisible = false,
  });

  final AppProfile me;
  final AppProfile partner;
  final AlagagiRoute route;
  final ArchiveFilter archiveFilter;
  final ProfileCardTab profileCardTab;
  final WishlistFilter wishlistFilter;
  final int activeBalanceIndex;
  final bool wishDraftVisible;
  final String wishDraftTitle;
  final WishKind wishDraftKind;
  final bool musicDraftVisible;
  final String musicDraftTitle;
  final String musicDraftArtist;
  final String musicDraftLink;
  final String musicDraftNote;
  final String musicDraftMood;
  final String? editingMusicNoteId;
  final String draftAnswer;
  final String? inviteError;
  final String? answerError;
  final String? commentError;
  final SaveStatus answerSaveStatus;
  final String? answerSaveFeedback;
  final String? answerSaveQuestionId;
  final SaveStatus commentSaveStatus;
  final String? commentSaveFeedback;
  final String? commentSaveTargetKey;
  final Map<String, String> commentDraftsByAnswerKey;
  final SpacePersonalization personalization;
  final SpacePersonalization personalizationDraft;
  final String? personalizationError;
  final String? wishDraftError;
  final String? musicDraftError;
  final bool skippedToday;
  final bool editingAnswer;
  final Set<String> expandedAnswerKeys;
  final String? activeAnswerQuestionId;
  final String? selectedArchiveDateKey;
  final bool firstVisitGuideVisible;

  AlagagiState copyWith({
    AppProfile? me,
    AppProfile? partner,
    AlagagiRoute? route,
    ArchiveFilter? archiveFilter,
    ProfileCardTab? profileCardTab,
    WishlistFilter? wishlistFilter,
    int? activeBalanceIndex,
    bool? wishDraftVisible,
    String? wishDraftTitle,
    WishKind? wishDraftKind,
    bool? musicDraftVisible,
    String? musicDraftTitle,
    String? musicDraftArtist,
    String? musicDraftLink,
    String? musicDraftNote,
    String? musicDraftMood,
    String? editingMusicNoteId,
    bool clearEditingMusicNoteId = false,
    String? draftAnswer,
    String? inviteError,
    bool clearInviteError = false,
    String? answerError,
    bool clearAnswerError = false,
    String? commentError,
    bool clearCommentError = false,
    SaveStatus? answerSaveStatus,
    String? answerSaveFeedback,
    bool clearAnswerSaveFeedback = false,
    String? answerSaveQuestionId,
    bool clearAnswerSaveQuestionId = false,
    SaveStatus? commentSaveStatus,
    String? commentSaveFeedback,
    bool clearCommentSaveFeedback = false,
    String? commentSaveTargetKey,
    bool clearCommentSaveTargetKey = false,
    Map<String, String>? commentDraftsByAnswerKey,
    SpacePersonalization? personalization,
    SpacePersonalization? personalizationDraft,
    String? personalizationError,
    bool clearPersonalizationError = false,
    String? wishDraftError,
    bool clearWishDraftError = false,
    String? musicDraftError,
    bool clearMusicDraftError = false,
    bool? skippedToday,
    bool? editingAnswer,
    Set<String>? expandedAnswerKeys,
    String? activeAnswerQuestionId,
    bool clearActiveAnswerQuestion = false,
    String? selectedArchiveDateKey,
    bool? firstVisitGuideVisible,
  }) {
    return AlagagiState(
      me: me ?? this.me,
      partner: partner ?? this.partner,
      route: route ?? this.route,
      archiveFilter: archiveFilter ?? this.archiveFilter,
      profileCardTab: profileCardTab ?? this.profileCardTab,
      wishlistFilter: wishlistFilter ?? this.wishlistFilter,
      activeBalanceIndex: activeBalanceIndex ?? this.activeBalanceIndex,
      wishDraftVisible: wishDraftVisible ?? this.wishDraftVisible,
      wishDraftTitle: wishDraftTitle ?? this.wishDraftTitle,
      wishDraftKind: wishDraftKind ?? this.wishDraftKind,
      musicDraftVisible: musicDraftVisible ?? this.musicDraftVisible,
      musicDraftTitle: musicDraftTitle ?? this.musicDraftTitle,
      musicDraftArtist: musicDraftArtist ?? this.musicDraftArtist,
      musicDraftLink: musicDraftLink ?? this.musicDraftLink,
      musicDraftNote: musicDraftNote ?? this.musicDraftNote,
      musicDraftMood: musicDraftMood ?? this.musicDraftMood,
      editingMusicNoteId: clearEditingMusicNoteId
          ? null
          : editingMusicNoteId ?? this.editingMusicNoteId,
      draftAnswer: draftAnswer ?? this.draftAnswer,
      inviteError: clearInviteError ? null : inviteError ?? this.inviteError,
      answerError: clearAnswerError ? null : answerError ?? this.answerError,
      commentError: clearCommentError
          ? null
          : commentError ?? this.commentError,
      answerSaveStatus: answerSaveStatus ?? this.answerSaveStatus,
      answerSaveFeedback: clearAnswerSaveFeedback
          ? null
          : answerSaveFeedback ?? this.answerSaveFeedback,
      answerSaveQuestionId: clearAnswerSaveQuestionId
          ? null
          : answerSaveQuestionId ?? this.answerSaveQuestionId,
      commentSaveStatus: commentSaveStatus ?? this.commentSaveStatus,
      commentSaveFeedback: clearCommentSaveFeedback
          ? null
          : commentSaveFeedback ?? this.commentSaveFeedback,
      commentSaveTargetKey: clearCommentSaveTargetKey
          ? null
          : commentSaveTargetKey ?? this.commentSaveTargetKey,
      commentDraftsByAnswerKey:
          commentDraftsByAnswerKey ?? this.commentDraftsByAnswerKey,
      personalization: personalization ?? this.personalization,
      personalizationDraft: personalizationDraft ?? this.personalizationDraft,
      personalizationError: clearPersonalizationError
          ? null
          : personalizationError ?? this.personalizationError,
      wishDraftError: clearWishDraftError
          ? null
          : wishDraftError ?? this.wishDraftError,
      musicDraftError: clearMusicDraftError
          ? null
          : musicDraftError ?? this.musicDraftError,
      skippedToday: skippedToday ?? this.skippedToday,
      editingAnswer: editingAnswer ?? this.editingAnswer,
      expandedAnswerKeys: expandedAnswerKeys ?? this.expandedAnswerKeys,
      activeAnswerQuestionId: clearActiveAnswerQuestion
          ? null
          : activeAnswerQuestionId ?? this.activeAnswerQuestionId,
      selectedArchiveDateKey:
          selectedArchiveDateKey ?? this.selectedArchiveDateKey,
      firstVisitGuideVisible:
          firstVisitGuideVisible ?? this.firstVisitGuideVisible,
    );
  }
}

class AlagagiController extends ChangeNotifier {
  AlagagiController({
    AlagagiDataRepository? repository,
    MusicNoteSeenStore? musicNoteSeenStore,
    FirstVisitGuideStore? firstVisitGuideStore,
  }) : _repository = repository,
       _musicNoteSeenStore = musicNoteSeenStore ?? MemoryMusicNoteSeenStore(),
       _firstVisitGuideStore = firstVisitGuideStore,
       _spaceId = null,
       _usesDemoData = true,
       _todayQuestion = seedQuestions.first,
       _dailyProgress = const DailyQuestionProgress(
         startedDateKey: '2026-06-08',
         currentQuestionId: 'q12',
         openedDateKey: '2026-06-08',
       ),
       questions = seedQuestions,
       balanceQuestions = seedBalanceQuestions,
       _state = const AlagagiState(
         me: AppProfile(id: 'me', nickname: '나', avatar: '🌿', isMe: true),
         partner: AppProfile(
           id: 'partner',
           nickname: '영우',
           avatar: '🪻',
           isMe: false,
         ),
       ) {
    _applyProfilesToSeedData();
  }

  AlagagiController.forSession(
    AlagagiSession session, {
    AlagagiDataRepository? repository,
    MusicNoteSeenStore? musicNoteSeenStore,
    FirstVisitGuideStore? firstVisitGuideStore,
    String? todayDateKey,
  }) : _repository = repository,
       _musicNoteSeenStore = musicNoteSeenStore ?? MemoryMusicNoteSeenStore(),
       _firstVisitGuideStore = firstVisitGuideStore,
       _spaceId = session.spaceId,
       _usesDemoData = false,
       _dailyProgress = _resolveDailyQuestionProgress(
         questionCatalogV1,
         session.data.dailyProgress,
         todayDateKey: todayDateKey,
       ),
       _todayQuestion = _questionForProgress(
         questionCatalogV1,
         _resolveDailyQuestionProgress(
           questionCatalogV1,
           session.data.dailyProgress,
           todayDateKey: todayDateKey,
         ),
       ),
       questions = questionCatalogV1,
       balanceQuestions = balanceQuestionCatalogV1,
       _state = AlagagiState(
         me: session.me,
         partner: session.partner,
         route: AlagagiRoute.home,
         personalization: _normalizeBrandPersonalization(
           session.data.personalization,
         ),
         personalizationDraft: _normalizeBrandPersonalization(
           session.data.personalization,
         ),
       ) {
    _applySessionData(session.data);
    _persistDailyQuestionProgressIfChanged(session.data.dailyProgress);
    _initializeFirstVisitGuide();
  }

  AlagagiState _state;
  final AlagagiDataRepository? _repository;
  final MusicNoteSeenStore _musicNoteSeenStore;
  final FirstVisitGuideStore? _firstVisitGuideStore;
  final String? _spaceId;
  final bool _usesDemoData;

  final DailyQuestion _todayQuestion;
  final DailyQuestionProgress _dailyProgress;
  final List<DailyQuestion> questions;
  final List<BalanceQuestion> balanceQuestions;

  final Map<String, Answer> _myAnswersByQuestionId = {};
  final Map<String, Answer> _partnerAnswersByQuestionId = {};
  final Set<String> _persistedMyAnswerQuestionIds = {};
  final Map<String, AnswerComment> _answerCommentsByKey = {};
  final Map<String, String> _balanceSelections = {};
  final Map<String, String> _partnerBalanceSelections = {};
  final List<ProfileCardData> _profileCards = [];
  final List<WishItem> _wishes = [];
  final List<MusicNote> _musicNotes = [];
  Answer? _lastFailedAnswer;
  AnswerComment? _lastFailedAnswerComment;

  AlagagiState get state => _state;

  DailyQuestion get todayQuestion => _todayQuestion;

  DailyQuestionProgress get dailyProgress => _dailyProgress;

  DailyQuestion get activeAnswerQuestion {
    final activeQuestionId = _state.activeAnswerQuestionId;
    if (activeQuestionId == null) {
      return todayQuestion;
    }
    return questions.firstWhere(
      (question) => question.id == activeQuestionId,
      orElse: () => todayQuestion,
    );
  }

  bool get isActiveAnswerToday => activeAnswerQuestion.id == todayQuestion.id;

  RelationshipInsight get insight {
    if (_usesDemoData) {
      return seedInsight;
    }
    return _buildRealInsight();
  }

  HomeProgressSummary get homeProgressSummary {
    final myAnswer = todayMyAnswer;
    final partnerAnswer = todayPartnerAnswer;
    final todayItem = myAnswer == null
        ? const HomeProgressSummaryItem(
            id: 'todayQuestion',
            label: '오늘 질문',
            stateText: '아직 내 답을 남기지 않았어요',
            tone: HomeProgressSummaryTone.waiting,
          )
        : myAnswer.skipped
        ? const HomeProgressSummaryItem(
            id: 'todayQuestion',
            label: '오늘 질문',
            stateText: '오늘은 잠시 넘겨뒀어요',
            tone: HomeProgressSummaryTone.waiting,
          )
        : partnerAnswer == null
        ? HomeProgressSummaryItem(
            id: 'todayQuestion',
            label: '오늘 질문',
            stateText: '${_state.partner.nickname}님 답을 기다리는 중이에요',
            tone: HomeProgressSummaryTone.waiting,
          )
        : const HomeProgressSummaryItem(
            id: 'todayQuestion',
            label: '오늘 질문',
            stateText: '오늘 질문이 함께 열렸어요',
            tone: HomeProgressSummaryTone.ready,
          );

    final bothAnsweredCount = insight.matchCount;
    final bothAnsweredItem = HomeProgressSummaryItem(
      id: 'bothAnswered',
      label: '둘 다 답한 질문',
      stateText: bothAnsweredCount == 0
          ? '아직 같이 열린 질문은 없어요'
          : '$bothAnsweredCount개 질문을 같이 열었어요',
      tone: bothAnsweredCount == 0
          ? HomeProgressSummaryTone.calm
          : HomeProgressSummaryTone.ready,
    );

    final hasNewMusic = hasNewPartnerMusicNotes;
    final musicItem = HomeProgressSummaryItem(
      id: 'music',
      label: '음악 노트',
      stateText: hasNewMusic
          ? '새 음악 노트가 있어요'
          : _musicNotes.isEmpty
          ? '아직 음악 노트가 없어요'
          : '최근 음악 노트 ${_musicNotes.length}곡',
      tone: hasNewMusic
          ? HomeProgressSummaryTone.ready
          : HomeProgressSummaryTone.calm,
    );

    final primaryAction = myAnswer == null || myAnswer.skipped
        ? const HomeProgressSummaryAction(
            label: '오늘 답하기',
            route: AlagagiRoute.answer,
          )
        : hasNewMusic
        ? const HomeProgressSummaryAction(
            label: '음악 보기',
            route: AlagagiRoute.music,
          )
        : const HomeProgressSummaryAction(
            label: '질문함 보기',
            route: AlagagiRoute.archive,
          );

    return HomeProgressSummary(
      items: [todayItem, bothAnsweredItem, musicItem],
      primaryAction: primaryAction,
    );
  }

  bool get hasNewPartnerMusicNotes {
    final spaceId = _spaceId;
    if (spaceId == null) {
      return false;
    }
    final lastSeen = _musicNoteSeenStore.readLastSeenMusicNoteAt(
      spaceId,
      _state.me.id,
    );
    return _musicNotes.any((note) {
      if (note.createdByProfileId != _state.partner.id) {
        return false;
      }
      final updatedAt = note.updatedAt;
      if (updatedAt == null) {
        return false;
      }
      return lastSeen == null || updatedAt.isAfter(lastSeen);
    });
  }

  void _applyProfilesToSeedData() {
    _myAnswersByQuestionId
      ..clear()
      ..addEntries(
        seedMyAnswers.map((answer) {
          return MapEntry(
            answer.questionId,
            answer.copyWith(profileId: _state.me.id),
          );
        }),
      );
    _persistedMyAnswerQuestionIds
      ..clear()
      ..addAll(_myAnswersByQuestionId.keys);
    _partnerAnswersByQuestionId
      ..clear()
      ..addEntries(
        seedPartnerAnswers.map((answer) {
          return MapEntry(
            answer.questionId,
            answer.copyWith(profileId: _state.partner.id),
          );
        }),
      );
    _profileCards
      ..clear()
      ..addAll(
        seedProfileCards.map((card) {
          return card.copyWith(
            profile: card.profile.isMe ? _state.me : _state.partner,
            slots: _profileSlotsWithValues(card.slots),
          );
        }),
      );
    _wishes
      ..clear()
      ..addAll(
        seedWishes.map((wish) {
          return wish.copyWith(
            createdByProfileId: _mapSeedProfileId(wish.createdByProfileId),
            likedByProfileIds: _mapSeedProfileIds(wish.likedByProfileIds),
          );
        }),
      );
    _musicNotes
      ..clear()
      ..addAll(
        seedMusicNotes.map((note) {
          return note.copyWith(
            createdByProfileId: _mapSeedProfileId(note.createdByProfileId),
          );
        }),
      );
    _sortMusicNotesByUpdatedAt();
  }

  void _applySessionData(AlagagiSpaceData data) {
    _myAnswersByQuestionId.clear();
    _partnerAnswersByQuestionId.clear();
    _persistedMyAnswerQuestionIds.clear();
    for (final answer in data.answers) {
      if (answer.profileId == _state.me.id) {
        _myAnswersByQuestionId[answer.questionId] = answer;
        _persistedMyAnswerQuestionIds.add(answer.questionId);
      } else if (answer.profileId == _state.partner.id) {
        _partnerAnswersByQuestionId[answer.questionId] = answer;
      }
    }

    _answerCommentsByKey
      ..clear()
      ..addEntries(
        data.answerComments.map((comment) {
          return MapEntry(
            _answerCommentKey(
              comment.questionId,
              comment.answerOwnerProfileId,
              comment.commenterProfileId,
            ),
            comment,
          );
        }),
      );

    _balanceSelections.clear();
    _partnerBalanceSelections.clear();
    for (final selection in data.balanceSelections) {
      if (selection.profileId == _state.me.id) {
        _balanceSelections[selection.questionId] = selection.optionId;
      } else if (selection.profileId == _state.partner.id) {
        _partnerBalanceSelections[selection.questionId] = selection.optionId;
      }
    }

    _profileCards
      ..clear()
      ..addAll(_emptyProfileCardsForSession());
    for (final value in data.profileSlots) {
      final cardIndex = _profileCards.indexWhere(
        (card) => card.profile.id == value.profileId,
      );
      if (cardIndex == -1) {
        continue;
      }
      final card = _profileCards[cardIndex];
      final slots = card.slots.map((slot) {
        if (slot.id != value.slot.id) {
          return slot;
        }
        return slot.copyWith(
          value: value.slot.value,
          locked: false,
          unlockHint: '',
        );
      }).toList();
      _profileCards[cardIndex] = card.copyWith(slots: slots);
    }

    _wishes
      ..clear()
      ..addAll(data.wishes);
    _musicNotes
      ..clear()
      ..addAll(data.musicNotes);
    _sortMusicNotesByUpdatedAt();
  }

  static DailyQuestionProgress _resolveDailyQuestionProgress(
    List<DailyQuestion> catalog,
    DailyQuestionProgress? progress, {
    String? todayDateKey,
  }) {
    final resolvedTodayDateKey = todayDateKey ?? _todayDateKey();
    if (progress == null) {
      return DailyQuestionProgress(
        startedDateKey: resolvedTodayDateKey,
        currentQuestionId: catalog.first.id,
        openedDateKey: resolvedTodayDateKey,
      );
    }
    final startedDateKey = progress.startedDateKey;
    final question = _questionForDateKeys(
      catalog,
      startedDateKey: startedDateKey,
      todayDateKey: resolvedTodayDateKey,
    );
    return progress.copyWith(
      startedDateKey: startedDateKey,
      currentQuestionId: question.id,
      openedDateKey: resolvedTodayDateKey,
    );
  }

  static DailyQuestion _questionForProgress(
    List<DailyQuestion> catalog,
    DailyQuestionProgress progress,
  ) {
    for (final question in catalog) {
      if (question.id == progress.currentQuestionId) {
        return question;
      }
    }
    return _questionForDateKeys(
      catalog,
      startedDateKey: progress.startedDateKey,
      todayDateKey: progress.openedDateKey,
    );
  }

  static DailyQuestion _questionForDateKeys(
    List<DailyQuestion> catalog, {
    required String startedDateKey,
    required String todayDateKey,
  }) {
    final startedDate = DateTime.tryParse(startedDateKey);
    final todayDate = DateTime.tryParse(todayDateKey);
    if (startedDate == null || todayDate == null || catalog.isEmpty) {
      return catalog.first;
    }
    final dayOffset = todayDate.difference(startedDate).inDays;
    final questionIndex = dayOffset.clamp(0, catalog.length - 1);
    return catalog[questionIndex];
  }

  static String _todayDateKey() {
    final koreaNow = DateTime.now().toUtc().add(const Duration(hours: 9));
    return _dateKey(koreaNow);
  }

  static String _dateKey(DateTime date) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${date.year}-${twoDigits(date.month)}-${twoDigits(date.day)}';
  }

  static bool _isSameMonth(DateTime first, DateTime second) {
    return first.year == second.year && first.month == second.month;
  }

  List<ProfileCardData> _emptyProfileCardsForSession() {
    return [
      ProfileCardData(
        profile: _state.partner,
        subtitle: '편한 만큼 채워지는 중',
        slots: _profileSlotCatalog(),
      ),
      ProfileCardData(
        profile: _state.me,
        subtitle: '편한 만큼 채워두는 내 소개 카드',
        slots: _profileSlotCatalog(),
      ),
    ];
  }

  List<ProfileSlot> _profileSlotCatalog() {
    return profileSlotCatalogV2;
  }

  List<ProfileSlot> _profileSlotsWithValues(Iterable<ProfileSlot> values) {
    final valuesById = {for (final slot in values) slot.id: slot};
    return _profileSlotCatalog().map((catalogSlot) {
      final valueSlot = valuesById[catalogSlot.id];
      final value = valueSlot?.value;
      if (value == null || value.trim().isEmpty) {
        return catalogSlot;
      }
      return catalogSlot.copyWith(value: value, locked: false, unlockHint: '');
    }).toList();
  }

  RelationshipInsight _buildRealInsight() {
    final answers = [..._myAnswersByQuestionId.values];
    final partnerAnswers = [..._partnerAnswersByQuestionId.values];
    final allAnswers = [
      ...answers,
      ...partnerAnswers,
    ].where((answer) => !answer.skipped).toList();
    final bothAnsweredCount = questions.where((question) {
      final myAnswer = _myAnswersByQuestionId[question.id];
      final partnerAnswer = _partnerAnswersByQuestionId[question.id];
      return myAnswer != null &&
          partnerAnswer != null &&
          !myAnswer.skipped &&
          !partnerAnswer.skipped;
    }).length;
    final questionCount = {
      ...answers.map((answer) => answer.questionId),
      ...partnerAnswers.map((answer) => answer.questionId),
    }.length;
    final longestAnswerLength = allAnswers.fold<int>(
      0,
      (maxLength, answer) =>
          answer.body.length > maxLength ? answer.body.length : maxLength,
    );

    return RelationshipInsight(
      daysTogether: questionCount == 0 ? 0 : questionCount,
      questionCount: questionCount,
      matchCount: bothAnsweredCount,
      longestAnswerLength: longestAnswerLength,
      similarityPercent: questionCount == 0
          ? 0
          : ((bothAnsweredCount / questionCount) * 100).round(),
      matchedKeywords: const [],
      timeline: questionCount == 0
          ? const []
          : [TimelineEvent(dateLabel: '오늘', description: '실제 답변이 하나씩 쌓이고 있어요')],
    );
  }

  String _mapSeedProfileId(String profileId) {
    return switch (profileId) {
      'me' => _state.me.id,
      'partner' => _state.partner.id,
      _ => profileId,
    };
  }

  Set<String> _mapSeedProfileIds(Set<String> profileIds) {
    return profileIds.map(_mapSeedProfileId).toSet();
  }

  void _persistAnswer(Answer answer) {
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository == null || spaceId == null) {
      _lastFailedAnswer = null;
      _persistedMyAnswerQuestionIds.add(answer.questionId);
      _state = _state.copyWith(
        answerSaveStatus: SaveStatus.saved,
        answerSaveFeedback: '저장됐어요.',
        answerSaveQuestionId: answer.questionId,
        clearAnswerError: true,
      );
      notifyListeners();
      return;
    }
    unawaited(
      repository
          .saveAnswer(spaceId, answer)
          .then<void>((_) {
            _lastFailedAnswer = null;
            _persistedMyAnswerQuestionIds.add(answer.questionId);
            _state = _state.copyWith(
              answerSaveStatus: SaveStatus.saved,
              answerSaveFeedback: '저장됐어요.',
              answerSaveQuestionId: answer.questionId,
              clearAnswerError: true,
            );
            notifyListeners();
          })
          .catchError((Object _) {
            _lastFailedAnswer = answer;
            _persistedMyAnswerQuestionIds.remove(answer.questionId);
            _state = _state.copyWith(
              answerError: '저장하지 못했어요. 다시 시도해 주세요.',
              answerSaveStatus: SaveStatus.failed,
              answerSaveQuestionId: answer.questionId,
              clearAnswerSaveFeedback: true,
            );
            notifyListeners();
          }),
    );
  }

  void _persistBalanceSelection(BalanceSelection selection) {
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository == null || spaceId == null) {
      return;
    }
    unawaited(
      repository.saveBalanceSelection(spaceId, selection).catchError((_) {}),
    );
  }

  void _persistProfileSlot(ProfileSlot slot) {
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository == null || spaceId == null) {
      return;
    }
    unawaited(
      repository
          .saveProfileSlot(spaceId, _state.me.id, slot)
          .catchError((_) {}),
    );
  }

  void _persistWish(WishItem wish) {
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository == null || spaceId == null) {
      return;
    }
    unawaited(repository.saveWish(spaceId, wish).catchError((_) {}));
  }

  void _persistMusicNote(MusicNote note) {
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository == null || spaceId == null) {
      return;
    }
    unawaited(repository.saveMusicNote(spaceId, note).catchError((_) {}));
  }

  void _persistAnswerComment(AnswerComment comment) {
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository == null || spaceId == null) {
      _lastFailedAnswerComment = null;
      _state = _state.copyWith(
        commentSaveStatus: SaveStatus.saved,
        commentSaveFeedback: '댓글을 저장했어요.',
        commentSaveTargetKey: _answerCommentDraftKey(
          comment.questionId,
          comment.answerOwnerProfileId,
        ),
        clearCommentError: true,
      );
      notifyListeners();
      return;
    }
    unawaited(
      repository
          .saveAnswerComment(spaceId, comment)
          .then<void>((_) {
            _lastFailedAnswerComment = null;
            _state = _state.copyWith(
              commentSaveStatus: SaveStatus.saved,
              commentSaveFeedback: '댓글을 저장했어요.',
              commentSaveTargetKey: _answerCommentDraftKey(
                comment.questionId,
                comment.answerOwnerProfileId,
              ),
              clearCommentError: true,
            );
            notifyListeners();
          })
          .catchError((Object _) {
            _lastFailedAnswerComment = comment;
            _state = _state.copyWith(
              commentError: '댓글을 저장하지 못했어요. 다시 시도해 주세요.',
              commentSaveStatus: SaveStatus.failed,
              commentSaveTargetKey: _answerCommentDraftKey(
                comment.questionId,
                comment.answerOwnerProfileId,
              ),
              clearCommentSaveFeedback: true,
            );
            notifyListeners();
          }),
    );
  }

  void _persistSpacePersonalization(SpacePersonalization personalization) {
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository == null || spaceId == null) {
      return;
    }
    unawaited(
      repository
          .saveSpacePersonalization(spaceId, personalization)
          .catchError((_) {}),
    );
  }

  void _persistDailyQuestionProgressIfChanged(
    DailyQuestionProgress? storedProgress,
  ) {
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository == null || spaceId == null) {
      return;
    }
    final shouldWrite =
        storedProgress == null ||
        storedProgress.startedDateKey != _dailyProgress.startedDateKey ||
        storedProgress.currentQuestionId != _dailyProgress.currentQuestionId ||
        storedProgress.openedDateKey != _dailyProgress.openedDateKey ||
        storedProgress.catalogVersion != _dailyProgress.catalogVersion;
    if (!shouldWrite) {
      return;
    }
    unawaited(
      repository
          .saveDailyQuestionProgress(spaceId, _dailyProgress)
          .catchError((_) {}),
    );
  }

  Answer? get todayMyAnswer => _myAnswersByQuestionId[todayQuestion.id];

  Answer? get todayPartnerAnswer =>
      _visiblePartnerAnswerForQuestion(todayQuestion.id);

  Answer? answerForQuestion(String questionId) {
    return _myAnswersByQuestionId[questionId];
  }

  Answer? partnerAnswerForQuestion(String questionId) {
    return _visiblePartnerAnswerForQuestion(questionId);
  }

  Answer? _visiblePartnerAnswerForQuestion(String questionId) {
    if (!_hasVisibleMyAnswerForQuestion(questionId)) {
      return null;
    }
    final partnerAnswer = _partnerAnswersByQuestionId[questionId];
    if (partnerAnswer == null || partnerAnswer.skipped) {
      return null;
    }
    return partnerAnswer;
  }

  bool _hasVisibleMyAnswerForQuestion(String questionId) {
    final myAnswer = _myAnswersByQuestionId[questionId];
    if (myAnswer == null || myAnswer.skipped) {
      return false;
    }
    return _isMyAnswerPersisted(questionId);
  }

  bool _isMyAnswerPersisted(String questionId) {
    return _usesDemoData || _persistedMyAnswerQuestionIds.contains(questionId);
  }

  List<QuestionCalendarDay> get questionCalendarDays {
    final startedDate = DateTime.tryParse(_dailyProgress.startedDateKey);
    final todayDate = DateTime.tryParse(_dailyProgress.openedDateKey);
    if (startedDate == null || todayDate == null) {
      return const [];
    }
    final visibleDayCount = _visibleCalendarDayCount(startedDate, todayDate);
    return List<QuestionCalendarDay>.generate(visibleDayCount, (index) {
      final date = startedDate.add(Duration(days: index));
      return _calendarDayForDate(
        date,
        startedDate: startedDate,
        todayDate: todayDate,
        displayedMonth: date,
      );
    });
  }

  List<QuestionCalendarDay> get visibleQuestionCalendarDays {
    final startedDate = DateTime.tryParse(_dailyProgress.startedDateKey);
    final todayDate = DateTime.tryParse(_dailyProgress.openedDateKey);
    if (startedDate == null || todayDate == null) {
      return const [];
    }
    final anchorDate = _selectedArchiveDate(startedDate, todayDate);
    final monthStart = DateTime(anchorDate.year, anchorDate.month);
    final nextMonthStart = DateTime(anchorDate.year, anchorDate.month + 1);
    final monthEnd = nextMonthStart.subtract(const Duration(days: 1));
    final gridStart = monthStart.subtract(
      Duration(days: monthStart.weekday - 1),
    );
    final gridEnd = monthEnd.add(Duration(days: 7 - monthEnd.weekday));
    final gridDayCount = gridEnd.difference(gridStart).inDays + 1;
    return List<QuestionCalendarDay>.generate(gridDayCount, (index) {
      final date = gridStart.add(Duration(days: index));
      return _calendarDayForDate(
        date,
        startedDate: startedDate,
        todayDate: todayDate,
        displayedMonth: monthStart,
      );
    });
  }

  QuestionCalendarDay? get selectedQuestionCalendarDay {
    final startedDate = DateTime.tryParse(_dailyProgress.startedDateKey);
    final todayDate = DateTime.tryParse(_dailyProgress.openedDateKey);
    if (startedDate == null || todayDate == null) {
      return null;
    }
    final selectedDate = _selectedArchiveDate(startedDate, todayDate);
    return _calendarDayForDate(
      selectedDate,
      startedDate: startedDate,
      todayDate: todayDate,
      displayedMonth: selectedDate,
    );
  }

  int _visibleCalendarDayCount(DateTime startedDate, DateTime todayDate) {
    final elapsedDays = todayDate.difference(startedDate).inDays + 1;
    var minimumDays = elapsedDays < 1 ? 1 : elapsedDays;
    if (questions.length > minimumDays) {
      minimumDays = questions.length;
    }
    final selectedDateKey = _state.selectedArchiveDateKey;
    if (selectedDateKey != null) {
      final selectedDate = DateTime.tryParse(selectedDateKey);
      if (selectedDate != null && !selectedDate.isBefore(startedDate)) {
        final selectedOffset = selectedDate.difference(startedDate).inDays + 1;
        if (selectedOffset > minimumDays) {
          minimumDays = selectedOffset;
        }
      }
    }
    return minimumDays < 1 ? 1 : minimumDays;
  }

  QuestionCalendarDay _calendarDayForDate(
    DateTime date, {
    required DateTime startedDate,
    required DateTime todayDate,
    required DateTime displayedMonth,
  }) {
    final dateKey = _dateKey(date);
    final selectedDateKey =
        _state.selectedArchiveDateKey ??
        _defaultSelectedArchiveDateKey(startedDate, todayDate);
    DailyQuestion? question;
    if (!date.isBefore(startedDate)) {
      final questionIndex = date.difference(startedDate).inDays;
      if (questionIndex >= 0 && questionIndex < questions.length) {
        question = questions[questionIndex];
      }
    }
    final isFuture = date.isAfter(todayDate);
    final status = _calendarStatusFor(question, isFuture: isFuture);
    final myAnswer = question == null
        ? null
        : _myAnswersByQuestionId[question.id];
    final hasPersistedMyAnswer = question != null
        ? _isMyAnswerPersisted(question.id)
        : false;
    final canLateAnswer =
        question != null &&
        date.isBefore(todayDate) &&
        !isFuture &&
        (myAnswer == null || (!myAnswer.skipped && !hasPersistedMyAnswer));
    return QuestionCalendarDay(
      dateKey: dateKey,
      question: question,
      status: status,
      isInDisplayedMonth:
          date.year == displayedMonth.year &&
          date.month == displayedMonth.month,
      isToday: dateKey == _dailyProgress.openedDateKey,
      isSelected: dateKey == selectedDateKey,
      canLateAnswer: canLateAnswer,
    );
  }

  DateTime _selectedArchiveDate(DateTime startedDate, DateTime todayDate) {
    final selectedDateKey =
        _state.selectedArchiveDateKey ??
        _defaultSelectedArchiveDateKey(startedDate, todayDate);
    return DateTime.tryParse(selectedDateKey) ??
        (todayDate.isBefore(startedDate) ? startedDate : todayDate);
  }

  String _defaultSelectedArchiveDateKey(
    DateTime startedDate,
    DateTime todayDate,
  ) {
    return _dateKey(todayDate.isBefore(startedDate) ? startedDate : todayDate);
  }

  QuestionCalendarStatus _calendarStatusFor(
    DailyQuestion? question, {
    required bool isFuture,
  }) {
    if (isFuture) {
      return QuestionCalendarStatus.future;
    }
    if (question == null) {
      return QuestionCalendarStatus.catalogEnded;
    }
    final myAnswer = _myAnswersByQuestionId[question.id];
    final partnerAnswer = _partnerAnswersByQuestionId[question.id];
    final hasPersistedMyAnswer = _isMyAnswerPersisted(question.id);
    if (myAnswer != null && myAnswer.skipped && hasPersistedMyAnswer) {
      return QuestionCalendarStatus.skippedByMe;
    }
    final hasMyAnswer =
        myAnswer != null && !myAnswer.skipped && hasPersistedMyAnswer;
    final hasPartnerAnswer = partnerAnswer != null && !partnerAnswer.skipped;
    if (hasMyAnswer && hasPartnerAnswer) {
      return QuestionCalendarStatus.bothAnswered;
    }
    if (hasMyAnswer) {
      return QuestionCalendarStatus.myAnswerOnly;
    }
    if (hasPartnerAnswer) {
      return QuestionCalendarStatus.partnerAnswerOnly;
    }
    return QuestionCalendarStatus.unanswered;
  }

  static String _answerExpansionKey(String questionId, String profileId) {
    return '$questionId::$profileId';
  }

  static String _answerCommentKey(
    String questionId,
    String answerOwnerProfileId,
    String commenterProfileId,
  ) {
    return '$questionId::$answerOwnerProfileId::$commenterProfileId';
  }

  static String _answerCommentDraftKey(
    String questionId,
    String answerOwnerProfileId,
  ) {
    return '$questionId::$answerOwnerProfileId';
  }

  BalanceQuestion get activeBalanceQuestion =>
      balanceQuestions[_state.activeBalanceIndex];

  bool get isLastBalanceQuestion =>
      _state.activeBalanceIndex >= balanceQuestions.length - 1;

  String? get activeBalanceSelection =>
      _balanceSelections[activeBalanceQuestion.id];

  String? get activePartnerBalanceSelection {
    return _partnerBalanceSelections[activeBalanceQuestion.id] ??
        (_usesDemoData ? activeBalanceQuestion.partnerChoiceId : null);
  }

  ProfileSlot? get todayFillableProfileSlot {
    final myCard = _profileCards.firstWhere((card) => card.profile.isMe);
    for (final slot in myCard.slots) {
      if (slot.value == null) {
        return slot;
      }
    }
    return null;
  }

  ProfileCardData get myProfileCard {
    return _profileCards.firstWhere((card) => card.profile.isMe);
  }

  ProfileCardData get activeProfileCard {
    final isPartner = _state.profileCardTab == ProfileCardTab.partner;
    return _profileCards.firstWhere((card) => card.profile.isMe != isPartner);
  }

  List<WishItem> get visibleWishes {
    return switch (_state.wishlistFilter) {
      WishlistFilter.all => List<WishItem>.unmodifiable(_wishes),
      WishlistFilter.mutual => _wishes.where((wish) => wish.isMutual).toList(),
      WishlistFilter.places =>
        _wishes
            .where((wish) => wish.kind == WishKind.place && !wish.done)
            .toList(),
      WishlistFilter.activities =>
        _wishes
            .where((wish) => wish.kind == WishKind.activity && !wish.done)
            .toList(),
    };
  }

  List<MusicNote> get musicNotes => List<MusicNote>.unmodifiable(_musicNotes);

  List<ArchiveItem> get archiveItems {
    final visibleQuestions = _usesDemoData
        ? questions
        : questions.where((question) {
            return _myAnswersByQuestionId.containsKey(question.id) ||
                _partnerAnswersByQuestionId.containsKey(question.id);
          }).toList();
    final items = visibleQuestions.map((question) {
      return ArchiveItem(
        question: question,
        myAnswer: _myAnswersByQuestionId[question.id],
        partnerAnswer: _visiblePartnerAnswerForQuestion(question.id),
        matchedKeywords: _usesDemoData
            ? seedMatchedKeywordsByQuestionId[question.id] ?? const []
            : const [],
      );
    }).toList();

    return switch (_state.archiveFilter) {
      ArchiveFilter.all => items,
      ArchiveFilter.bothAnswered =>
        items.where((item) => item.bothAnswered).toList(),
      ArchiveFilter.similar => items.where((item) => item.similar).toList(),
    };
  }

  void enterSpace(String nickname) {
    final trimmed = nickname.trim();
    if (trimmed.isEmpty) {
      _state = _state.copyWith(inviteError: '불러줬으면 하는 이름을 한 글자만 적어주세요.');
      notifyListeners();
      return;
    }

    _state = _state.copyWith(
      me: _state.me.copyWith(nickname: trimmed),
      route: AlagagiRoute.home,
      clearInviteError: true,
    );
    notifyListeners();
  }

  void goTo(AlagagiRoute route) {
    if (route == AlagagiRoute.music) {
      _markMusicNotesSeen();
    }
    _state = _state.copyWith(
      route: route,
      editingAnswer: false,
      clearActiveAnswerQuestion: route != AlagagiRoute.answer,
      clearAnswerError: true,
      clearAnswerSaveFeedback: route == AlagagiRoute.answer,
    );
    notifyListeners();
  }

  void completeFirstVisitGuide() {
    _markFirstVisitGuideSeen();
    if (!_state.firstVisitGuideVisible) {
      return;
    }
    _state = _state.copyWith(firstVisitGuideVisible: false);
    notifyListeners();
  }

  void _initializeFirstVisitGuide() {
    final store = _firstVisitGuideStore;
    final spaceId = _spaceId;
    if (store == null || spaceId == null) {
      return;
    }
    if (store.hasSeenFirstVisitGuide(spaceId, _state.me.id)) {
      return;
    }
    _state = _state.copyWith(firstVisitGuideVisible: true);
  }

  void _markFirstVisitGuideSeen() {
    final store = _firstVisitGuideStore;
    final spaceId = _spaceId;
    if (store == null || spaceId == null) {
      return;
    }
    store.markFirstVisitGuideSeen(spaceId, _state.me.id);
  }

  void activateHomeProgressSummaryAction() {
    final action = homeProgressSummary.primaryAction;
    if (action == null) {
      return;
    }
    if (action.route == AlagagiRoute.answer && todayMyAnswer?.skipped == true) {
      answerTodayAfterSkip();
      return;
    }
    goTo(action.route);
  }

  void _markMusicNotesSeen() {
    final spaceId = _spaceId;
    if (spaceId == null) {
      return;
    }
    final latestTimestamp = _latestMusicNoteTimestamp();
    if (latestTimestamp == null) {
      return;
    }
    _musicNoteSeenStore.writeLastSeenMusicNoteAt(
      spaceId,
      _state.me.id,
      latestTimestamp,
    );
  }

  DateTime? _latestMusicNoteTimestamp() {
    DateTime? latest;
    for (final note in _musicNotes) {
      final updatedAt = note.updatedAt;
      if (updatedAt == null) {
        continue;
      }
      if (latest == null || updatedAt.isAfter(latest)) {
        latest = updatedAt;
      }
    }
    return latest;
  }

  void _sortMusicNotesByUpdatedAt() {
    _musicNotes.sort((a, b) {
      final aUpdatedAt = a.updatedAt;
      final bUpdatedAt = b.updatedAt;
      if (aUpdatedAt == null && bUpdatedAt == null) {
        return 0;
      }
      if (aUpdatedAt == null) {
        return 1;
      }
      if (bUpdatedAt == null) {
        return -1;
      }
      return bUpdatedAt.compareTo(aUpdatedAt);
    });
  }

  void updateDraftAnswer(String value) {
    _state = _state.copyWith(draftAnswer: value, clearAnswerError: true);
    notifyListeners();
  }

  AnswerComment? commentForAnswer(
    String questionId,
    String answerOwnerProfileId,
    String commenterProfileId,
  ) {
    return _answerCommentsByKey[_answerCommentKey(
      questionId,
      answerOwnerProfileId,
      commenterProfileId,
    )];
  }

  String commentDraftForAnswer(String questionId, String answerOwnerProfileId) {
    final draftKey = _answerCommentDraftKey(questionId, answerOwnerProfileId);
    return _state.commentDraftsByAnswerKey[draftKey] ??
        commentForAnswer(
          questionId,
          answerOwnerProfileId,
          _state.me.id,
        )?.body ??
        '';
  }

  String commentInputValueForAnswer(
    String questionId,
    String answerOwnerProfileId,
  ) {
    return _state.commentDraftsByAnswerKey[_answerCommentDraftKey(
          questionId,
          answerOwnerProfileId,
        )] ??
        '';
  }

  bool hasCommentDraftForAnswer(
    String questionId,
    String answerOwnerProfileId,
  ) {
    return _state.commentDraftsByAnswerKey.containsKey(
      _answerCommentDraftKey(questionId, answerOwnerProfileId),
    );
  }

  void updateAnswerCommentDraft({
    required String questionId,
    required String answerOwnerProfileId,
    required String value,
  }) {
    final draftKey = _answerCommentDraftKey(questionId, answerOwnerProfileId);
    final drafts = Map<String, String>.of(_state.commentDraftsByAnswerKey)
      ..[draftKey] = value;
    _state = _state.copyWith(
      commentDraftsByAnswerKey: Map<String, String>.unmodifiable(drafts),
      commentSaveStatus: SaveStatus.idle,
      clearCommentError: true,
      clearCommentSaveFeedback: true,
      clearCommentSaveTargetKey: true,
    );
    notifyListeners();
  }

  void cancelAnswerCommentDraft({
    required String questionId,
    required String answerOwnerProfileId,
  }) {
    final drafts = Map<String, String>.of(_state.commentDraftsByAnswerKey)
      ..remove(_answerCommentDraftKey(questionId, answerOwnerProfileId));
    _state = _state.copyWith(
      commentDraftsByAnswerKey: Map<String, String>.unmodifiable(drafts),
      commentSaveStatus: SaveStatus.idle,
      clearCommentError: true,
      clearCommentSaveFeedback: true,
      clearCommentSaveTargetKey: true,
    );
    notifyListeners();
  }

  void submitAnswerComment({
    required String questionId,
    required String answerOwnerProfileId,
  }) {
    if (_state.commentSaveStatus == SaveStatus.saving) {
      return;
    }
    final body = commentDraftForAnswer(questionId, answerOwnerProfileId).trim();
    if (body.isEmpty) {
      _state = _state.copyWith(
        commentError: '한 줄만 남겨도 괜찮아요.',
        commentSaveStatus: SaveStatus.idle,
        clearCommentSaveFeedback: true,
      );
      notifyListeners();
      return;
    }
    if (body.length > 120) {
      _state = _state.copyWith(
        commentError: '댓글은 120자 안으로 남겨주세요.',
        commentSaveStatus: SaveStatus.idle,
        clearCommentSaveFeedback: true,
      );
      notifyListeners();
      return;
    }
    if (answerOwnerProfileId != _state.partner.id) {
      _state = _state.copyWith(
        commentError: '상대 답변에만 댓글을 남길 수 있어요.',
        commentSaveStatus: SaveStatus.idle,
        clearCommentSaveFeedback: true,
      );
      notifyListeners();
      return;
    }
    final partnerAnswer = _visiblePartnerAnswerForQuestion(questionId);
    if (partnerAnswer == null) {
      _state = _state.copyWith(
        commentError: '상대 답이 열린 뒤에 댓글을 남길 수 있어요.',
        commentSaveStatus: SaveStatus.idle,
        clearCommentSaveFeedback: true,
      );
      notifyListeners();
      return;
    }

    final existing = commentForAnswer(
      questionId,
      answerOwnerProfileId,
      _state.me.id,
    );
    final comment = AnswerComment(
      questionId: questionId,
      answerOwnerProfileId: answerOwnerProfileId,
      commenterProfileId: _state.me.id,
      body: body,
      createdLabel: existing?.createdLabel ?? '오늘',
      edited: existing != null,
    );
    _answerCommentsByKey[_answerCommentKey(
          questionId,
          answerOwnerProfileId,
          _state.me.id,
        )] =
        comment;
    _lastFailedAnswerComment = null;
    final drafts = Map<String, String>.of(_state.commentDraftsByAnswerKey)
      ..remove(_answerCommentDraftKey(questionId, answerOwnerProfileId));
    _state = _state.copyWith(
      commentDraftsByAnswerKey: Map<String, String>.unmodifiable(drafts),
      commentSaveStatus: SaveStatus.saving,
      commentSaveTargetKey: _answerCommentDraftKey(
        questionId,
        answerOwnerProfileId,
      ),
      clearCommentError: true,
      clearCommentSaveFeedback: true,
    );
    notifyListeners();
    _persistAnswerComment(comment);
  }

  bool isCommentSaveTarget({
    required String questionId,
    required String answerOwnerProfileId,
  }) {
    return _state.commentSaveTargetKey ==
        _answerCommentDraftKey(questionId, answerOwnerProfileId);
  }

  void retryAnswerCommentSave() {
    final comment = _lastFailedAnswerComment;
    if (comment == null || _state.commentSaveStatus == SaveStatus.saving) {
      return;
    }

    _state = _state.copyWith(
      commentSaveStatus: SaveStatus.saving,
      commentSaveTargetKey: _answerCommentDraftKey(
        comment.questionId,
        comment.answerOwnerProfileId,
      ),
      clearCommentError: true,
      clearCommentSaveFeedback: true,
    );
    notifyListeners();
    _persistAnswerComment(comment);
  }

  void updatePersonalizationDraft({
    String? appTitle,
    String? homeLine,
    String? inviteLine,
    String? accentEmoji,
  }) {
    _state = _state.copyWith(
      personalizationDraft: _state.personalizationDraft.copyWith(
        appTitle: appTitle,
        homeLine: homeLine,
        inviteLine: inviteLine,
        accentEmoji: accentEmoji,
      ),
      clearPersonalizationError: true,
    );
    notifyListeners();
  }

  void savePersonalizationDraft() {
    final appTitle = _state.personalizationDraft.appTitle.trim();
    final homeLine = _state.personalizationDraft.homeLine.trim();
    final inviteLine = _state.personalizationDraft.inviteLine.trim();
    final accentEmoji = _state.personalizationDraft.accentEmoji.trim();
    if (appTitle.isEmpty || appTitle.length > 16) {
      _state = _state.copyWith(personalizationError: '앱 이름은 1-16자로 남겨주세요.');
      notifyListeners();
      return;
    }
    if (homeLine.isEmpty || homeLine.length > 40) {
      _state = _state.copyWith(personalizationError: '홈 문구는 1-40자로 남겨주세요.');
      notifyListeners();
      return;
    }
    final personalization = SpacePersonalization(
      appTitle: appTitle,
      homeLine: homeLine,
      inviteLine: inviteLine.isEmpty
          ? const SpacePersonalization().inviteLine
          : inviteLine,
      accentEmoji: accentEmoji.isEmpty
          ? const SpacePersonalization().accentEmoji
          : accentEmoji,
    );
    _state = _state.copyWith(
      personalization: personalization,
      personalizationDraft: personalization,
      clearPersonalizationError: true,
    );
    notifyListeners();
    _persistSpacePersonalization(personalization);
  }

  void submitTodayAnswer() {
    _state = _state.copyWith(activeAnswerQuestionId: todayQuestion.id);
    submitActiveAnswer();
  }

  void submitActiveAnswer() {
    if (_state.answerSaveStatus == SaveStatus.saving) {
      return;
    }
    final body = _state.draftAnswer.trim();
    if (body.isEmpty) {
      _state = _state.copyWith(answerError: '한 줄만 적어도 괜찮아요.');
      notifyListeners();
      return;
    }
    if (body.length > 300) {
      _state = _state.copyWith(answerError: '300자 안으로 남겨주세요.');
      notifyListeners();
      return;
    }

    final question = activeAnswerQuestion;
    final existingAnswer = _myAnswersByQuestionId[question.id];
    final answer = Answer(
      questionId: question.id,
      profileId: _state.me.id,
      body: body,
      createdLabel: existingAnswer?.createdLabel ?? _createdLabelFor(question),
      edited:
          existingAnswer != null &&
          !existingAnswer.skipped &&
          _isMyAnswerPersisted(question.id),
    );
    _myAnswersByQuestionId[question.id] = answer;
    _persistedMyAnswerQuestionIds.remove(question.id);
    _lastFailedAnswer = null;
    _state = _state.copyWith(
      draftAnswer: '',
      route: isActiveAnswerToday ? AlagagiRoute.home : AlagagiRoute.archive,
      skippedToday: false,
      editingAnswer: false,
      clearActiveAnswerQuestion: true,
      answerSaveStatus: SaveStatus.saving,
      answerSaveQuestionId: question.id,
      clearAnswerError: true,
      clearAnswerSaveFeedback: true,
    );
    notifyListeners();
    _persistAnswer(answer);
  }

  String _createdLabelFor(DailyQuestion question) {
    if (question.id == todayQuestion.id) {
      return '오늘';
    }
    for (final day in questionCalendarDays) {
      if (day.question?.id == question.id) {
        final date = DateTime.tryParse(day.dateKey);
        if (date != null) {
          return '${date.month}월 ${date.day}일';
        }
      }
    }
    return '오늘';
  }

  void skipToday() {
    if (_state.answerSaveStatus == SaveStatus.saving) {
      return;
    }
    final answer = Answer(
      questionId: todayQuestion.id,
      profileId: _state.me.id,
      body: '',
      createdLabel: '오늘',
      skipped: true,
    );
    _myAnswersByQuestionId[todayQuestion.id] = answer;
    _persistedMyAnswerQuestionIds.remove(todayQuestion.id);
    _lastFailedAnswer = null;
    _state = _state.copyWith(
      route: AlagagiRoute.home,
      skippedToday: true,
      draftAnswer: '',
      editingAnswer: false,
      answerSaveStatus: SaveStatus.saving,
      answerSaveQuestionId: todayQuestion.id,
      clearAnswerError: true,
      clearAnswerSaveFeedback: true,
    );
    notifyListeners();
    _persistAnswer(answer);
  }

  void editTodayAnswer() {
    final answer = todayMyAnswer;
    if (answer == null) {
      return;
    }
    if (answer.skipped) {
      answerTodayAfterSkip();
      return;
    }

    _state = _state.copyWith(
      route: AlagagiRoute.answer,
      draftAnswer: answer.body,
      editingAnswer: true,
      activeAnswerQuestionId: todayQuestion.id,
      clearAnswerError: true,
      clearAnswerSaveFeedback: true,
    );
    notifyListeners();
  }

  void answerTodayAfterSkip() {
    _state = _state.copyWith(
      route: AlagagiRoute.answer,
      draftAnswer: '',
      skippedToday: false,
      editingAnswer: true,
      activeAnswerQuestionId: todayQuestion.id,
      clearAnswerError: true,
      clearAnswerSaveFeedback: true,
    );
    notifyListeners();
  }

  void selectArchiveDate(String dateKey) {
    _state = _state.copyWith(selectedArchiveDateKey: dateKey);
    notifyListeners();
  }

  void selectPreviousArchiveMonth() {
    _selectArchiveMonthByOffset(-1);
  }

  void selectNextArchiveMonth() {
    _selectArchiveMonthByOffset(1);
  }

  void selectTodayArchiveMonth() {
    selectArchiveDate(_dailyProgress.openedDateKey);
  }

  void _selectArchiveMonthByOffset(int monthOffset) {
    final startedDate = DateTime.tryParse(_dailyProgress.startedDateKey);
    final todayDate = DateTime.tryParse(_dailyProgress.openedDateKey);
    if (startedDate == null || todayDate == null) {
      return;
    }
    final currentDate = _selectedArchiveDate(startedDate, todayDate);
    final targetMonthStart = DateTime(
      currentDate.year,
      currentDate.month + monthOffset,
    );
    final targetMonthEnd = DateTime(
      targetMonthStart.year,
      targetMonthStart.month + 1,
      0,
    );
    final targetDay = currentDate.day > targetMonthEnd.day
        ? targetMonthEnd.day
        : currentDate.day;
    var targetDate = DateTime(
      targetMonthStart.year,
      targetMonthStart.month,
      targetDay,
    );
    if (_isSameMonth(targetDate, startedDate) &&
        targetDate.isBefore(startedDate)) {
      targetDate = startedDate;
    }
    selectArchiveDate(_dateKey(targetDate));
  }

  void startLateAnswer(String questionId) {
    final question = _questionById(questionId);
    if (question == null) {
      return;
    }
    final calendarDay = _calendarDayForQuestion(questionId);
    if (calendarDay == null || !calendarDay.canLateAnswer) {
      return;
    }
    _state = _state.copyWith(
      route: AlagagiRoute.answer,
      activeAnswerQuestionId: questionId,
      selectedArchiveDateKey: calendarDay.dateKey,
      draftAnswer: '',
      editingAnswer: false,
      clearAnswerError: true,
      clearAnswerSaveFeedback: true,
    );
    notifyListeners();
  }

  DailyQuestion? _questionById(String questionId) {
    for (final question in questions) {
      if (question.id == questionId) {
        return question;
      }
    }
    return null;
  }

  QuestionCalendarDay? _calendarDayForQuestion(String questionId) {
    for (final day in questionCalendarDays) {
      if (day.question?.id == questionId) {
        return day;
      }
    }
    return null;
  }

  void retryAnswerSave() {
    final answer = _lastFailedAnswer;
    if (answer == null || _state.answerSaveStatus == SaveStatus.saving) {
      return;
    }

    _state = _state.copyWith(
      answerSaveStatus: SaveStatus.saving,
      answerSaveQuestionId: answer.questionId,
      clearAnswerError: true,
      clearAnswerSaveFeedback: true,
    );
    notifyListeners();
    _persistAnswer(answer);
  }

  bool isAnswerExpanded(String questionId, String profileId) {
    return _state.expandedAnswerKeys.contains(
      _answerExpansionKey(questionId, profileId),
    );
  }

  void toggleAnswerExpanded(String questionId, String profileId) {
    final key = _answerExpansionKey(questionId, profileId);
    final expandedKeys = Set<String>.of(_state.expandedAnswerKeys);
    if (!expandedKeys.add(key)) {
      expandedKeys.remove(key);
    }
    _state = _state.copyWith(
      expandedAnswerKeys: Set<String>.unmodifiable(expandedKeys),
    );
    notifyListeners();
  }

  void setArchiveFilter(ArchiveFilter filter) {
    _state = _state.copyWith(archiveFilter: filter);
    notifyListeners();
  }

  void selectBalanceOption(String optionId) {
    final question = activeBalanceQuestion;
    if (question.left.id != optionId && question.right.id != optionId) {
      throw ArgumentError.value(optionId, 'optionId');
    }
    final selection = BalanceSelection(
      questionId: question.id,
      profileId: _state.me.id,
      optionId: optionId,
    );
    _balanceSelections[question.id] = optionId;
    _persistBalanceSelection(selection);
    notifyListeners();
  }

  void nextBalanceQuestion() {
    if (isLastBalanceQuestion) {
      _state = _state.copyWith(route: AlagagiRoute.home);
    } else {
      _state = _state.copyWith(
        activeBalanceIndex: _state.activeBalanceIndex + 1,
      );
    }
    notifyListeners();
  }

  void setProfileCardTab(ProfileCardTab tab) {
    _state = _state.copyWith(profileCardTab: tab);
    notifyListeners();
  }

  void fillTodayProfileSlot(String value) {
    final targetSlotId = todayFillableProfileSlot?.id;
    if (targetSlotId == null) {
      return;
    }
    fillProfileSlot(targetSlotId, value);
  }

  void fillProfileSlot(String slotId, String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return;
    }

    final cardIndex = _profileCards.indexWhere((card) => card.profile.isMe);
    if (cardIndex == -1) {
      return;
    }
    final card = _profileCards[cardIndex];
    ProfileSlot? filledSlot;
    final slots = card.slots.map((slot) {
      if (slot.id == slotId) {
        filledSlot = slot.copyWith(
          value: trimmed,
          locked: false,
          unlockHint: '',
        );
        return filledSlot!;
      }
      return slot;
    }).toList();
    if (filledSlot == null) {
      return;
    }
    _profileCards[cardIndex] = card.copyWith(slots: slots);
    _persistProfileSlot(filledSlot!);
    _state = _state.copyWith(profileCardTab: ProfileCardTab.me);
    notifyListeners();
  }

  void saveProfileSlot(String slotId, String value) {
    fillProfileSlot(slotId, value);
  }

  void setWishlistFilter(WishlistFilter filter) {
    _state = _state.copyWith(wishlistFilter: filter);
    notifyListeners();
  }

  void startWishDraft() {
    _state = _state.copyWith(
      wishlistFilter: WishlistFilter.all,
      wishDraftVisible: true,
      wishDraftTitle: '',
      wishDraftKind: WishKind.activity,
      clearWishDraftError: true,
    );
    notifyListeners();
  }

  void cancelWishDraft() {
    _state = _state.copyWith(
      wishDraftVisible: false,
      wishDraftTitle: '',
      wishDraftKind: WishKind.activity,
      clearWishDraftError: true,
    );
    notifyListeners();
  }

  void updateWishDraftTitle(String value) {
    _state = _state.copyWith(wishDraftTitle: value, clearWishDraftError: true);
    notifyListeners();
  }

  void setWishDraftKind(WishKind kind) {
    _state = _state.copyWith(wishDraftKind: kind, clearWishDraftError: true);
    notifyListeners();
  }

  void submitWishDraft() {
    final title = _state.wishDraftTitle.trim();
    if (title.isEmpty) {
      _state = _state.copyWith(wishDraftError: '한 줄만 적어도 괜찮아요.');
      notifyListeners();
      return;
    }
    if (title.length > 60) {
      _state = _state.copyWith(wishDraftError: '60자 안으로 담아주세요.');
      notifyListeners();
      return;
    }

    final wish = WishItem(
      id: 'wish_${_state.me.id}_${DateTime.now().microsecondsSinceEpoch}',
      icon: _wishIconFor(_state.wishDraftKind),
      title: title,
      kind: _state.wishDraftKind,
      createdByProfileId: _state.me.id,
      likedByProfileIds: {_state.me.id},
    );
    _wishes.insert(0, wish);
    _persistWish(wish);
    _state = _state.copyWith(
      wishlistFilter: WishlistFilter.all,
      wishDraftVisible: false,
      wishDraftTitle: '',
      wishDraftKind: WishKind.activity,
      clearWishDraftError: true,
    );
    notifyListeners();
  }

  String _wishIconFor(WishKind kind) {
    return switch (kind) {
      WishKind.place => '📍',
      WishKind.activity => '✨',
    };
  }

  void toggleWishLike(String wishId) {
    final index = _wishes.indexWhere((wish) => wish.id == wishId);
    if (index == -1) {
      throw ArgumentError.value(wishId, 'wishId');
    }
    final wish = _wishes[index];
    final likedBy = Set<String>.from(wish.likedByProfileIds);
    if (likedBy.contains(_state.me.id)) {
      return;
    }
    likedBy.add(_state.me.id);
    final updatedWish = wish.copyWith(likedByProfileIds: likedBy);
    _wishes[index] = updatedWish;
    _persistWish(updatedWish);
    notifyListeners();
  }

  void startMusicDraft() {
    _markMusicNotesSeen();
    _state = _state.copyWith(
      route: AlagagiRoute.music,
      musicDraftVisible: true,
      musicDraftTitle: '',
      musicDraftArtist: '',
      musicDraftLink: '',
      musicDraftNote: '',
      musicDraftMood: musicMoodOptions.first,
      clearEditingMusicNoteId: true,
      clearMusicDraftError: true,
    );
    notifyListeners();
  }

  void startMusicEdit(String noteId) {
    final note = _musicNotes.cast<MusicNote?>().firstWhere(
      (candidate) => candidate?.id == noteId,
      orElse: () => null,
    );
    if (note == null || note.createdByProfileId != _state.me.id) {
      return;
    }
    _markMusicNotesSeen();
    _state = _state.copyWith(
      route: AlagagiRoute.music,
      musicDraftVisible: true,
      musicDraftTitle: note.title,
      musicDraftArtist: note.artist,
      musicDraftLink: note.link,
      musicDraftNote: note.note,
      musicDraftMood: note.mood,
      editingMusicNoteId: note.id,
      clearMusicDraftError: true,
    );
    notifyListeners();
  }

  void cancelMusicDraft() {
    _state = _state.copyWith(
      musicDraftVisible: false,
      musicDraftTitle: '',
      musicDraftArtist: '',
      musicDraftLink: '',
      musicDraftNote: '',
      musicDraftMood: musicMoodOptions.first,
      clearEditingMusicNoteId: true,
      clearMusicDraftError: true,
    );
    notifyListeners();
  }

  void updateMusicDraft({
    String? title,
    String? artist,
    String? link,
    String? note,
  }) {
    _state = _state.copyWith(
      musicDraftTitle: title,
      musicDraftArtist: artist,
      musicDraftLink: link,
      musicDraftNote: note,
      clearMusicDraftError: true,
    );
    notifyListeners();
  }

  void setMusicDraftMood(String mood) {
    if (!musicMoodOptions.contains(mood)) {
      return;
    }
    _state = _state.copyWith(musicDraftMood: mood, clearMusicDraftError: true);
    notifyListeners();
  }

  void submitMusicDraft() {
    final title = _state.musicDraftTitle.trim();
    final artist = _state.musicDraftArtist.trim();
    final link = _state.musicDraftLink.trim();
    final noteBody = _state.musicDraftNote.trim();
    final mood = _state.musicDraftMood;
    if (title.isEmpty) {
      _state = _state.copyWith(musicDraftError: '곡 제목을 한 줄로 남겨주세요.');
      notifyListeners();
      return;
    }
    if (title.length > 60) {
      _state = _state.copyWith(musicDraftError: '곡 제목은 60자 안으로 남겨주세요.');
      notifyListeners();
      return;
    }
    if (artist.isEmpty) {
      _state = _state.copyWith(musicDraftError: '아티스트 이름을 남겨주세요.');
      notifyListeners();
      return;
    }
    if (artist.length > 60) {
      _state = _state.copyWith(musicDraftError: '아티스트는 60자 안으로 남겨주세요.');
      notifyListeners();
      return;
    }
    if (link.length > 180) {
      _state = _state.copyWith(musicDraftError: '링크는 180자 안으로 남겨주세요.');
      notifyListeners();
      return;
    }
    if (noteBody.length > 80) {
      _state = _state.copyWith(musicDraftError: '메모는 80자 안으로 남겨주세요.');
      notifyListeners();
      return;
    }
    if (!musicMoodOptions.contains(mood)) {
      _state = _state.copyWith(musicDraftError: '분위기를 다시 골라주세요.');
      notifyListeners();
      return;
    }

    final now = DateTime.now();
    final editingId = _state.editingMusicNoteId;
    if (editingId != null) {
      final editIndex = _musicNotes.indexWhere(
        (note) =>
            note.id == editingId && note.createdByProfileId == _state.me.id,
      );
      if (editIndex == -1) {
        _state = _state.copyWith(musicDraftError: '수정할 음악 노트를 찾지 못했어요.');
        notifyListeners();
        return;
      }
      final updatedNote = _musicNotes[editIndex].copyWith(
        title: title,
        artist: artist,
        link: link,
        note: noteBody,
        mood: mood,
        updatedAt: now,
      );
      _musicNotes[editIndex] = updatedNote;
      _sortMusicNotesByUpdatedAt();
      _persistMusicNote(updatedNote);
      _state = _state.copyWith(
        musicDraftVisible: false,
        musicDraftTitle: '',
        musicDraftArtist: '',
        musicDraftLink: '',
        musicDraftNote: '',
        musicDraftMood: musicMoodOptions.first,
        clearEditingMusicNoteId: true,
        clearMusicDraftError: true,
      );
      notifyListeners();
      return;
    }

    final note = MusicNote(
      id: 'music_${_state.me.id}_${now.microsecondsSinceEpoch}',
      title: title,
      artist: artist,
      link: link,
      note: noteBody,
      mood: mood,
      createdByProfileId: _state.me.id,
      createdLabel: '오늘',
      updatedAt: now,
    );
    _musicNotes.insert(0, note);
    _sortMusicNotesByUpdatedAt();
    _persistMusicNote(note);
    _state = _state.copyWith(
      musicDraftVisible: false,
      musicDraftTitle: '',
      musicDraftArtist: '',
      musicDraftLink: '',
      musicDraftNote: '',
      musicDraftMood: musicMoodOptions.first,
      clearEditingMusicNoteId: true,
      clearMusicDraftError: true,
    );
    notifyListeners();
  }
}

const seedQuestions = [
  DailyQuestion(
    id: 'q12',
    day: 12,
    number: 12,
    depth: QuestionDepth.daily,
    text: '하루 중 가장 좋아하는 시간은 언제인가요?',
    highlightedText: '좋아하는 시간',
  ),
  DailyQuestion(
    id: 'q11',
    day: 11,
    number: 11,
    depth: QuestionDepth.light,
    text: '요즘 가장 자주 듣는 노래가 있나요?',
    highlightedText: '자주 듣는 노래',
  ),
  DailyQuestion(
    id: 'q10',
    day: 10,
    number: 10,
    depth: QuestionDepth.daily,
    text: '완벽한 주말 아침을 그려본다면?',
    highlightedText: '주말 아침',
  ),
  DailyQuestion(
    id: 'q09',
    day: 9,
    number: 9,
    depth: QuestionDepth.light,
    text: '여행은 계획파인가요, 즉흥파인가요?',
    highlightedText: '여행',
  ),
];

const questionCatalogV1 = [
  DailyQuestion(
    id: 'q001',
    day: 1,
    number: 1,
    depth: QuestionDepth.light,
    text: '하루 중 가장 좋아하는 시간은 언제예요?',
    highlightedText: '좋아하는 시간',
  ),
  DailyQuestion(
    id: 'q002',
    day: 2,
    number: 2,
    depth: QuestionDepth.light,
    text: '요즘 자주 듣는 노래가 있나요?',
    highlightedText: '자주 듣는 노래',
  ),
  DailyQuestion(
    id: 'q003',
    day: 3,
    number: 3,
    depth: QuestionDepth.light,
    text: '쉬는 날 혼자 시간이 생기면 제일 먼저 뭘 하고 싶어요?',
    highlightedText: '쉬는 날',
  ),
  DailyQuestion(
    id: 'q004',
    day: 4,
    number: 4,
    depth: QuestionDepth.light,
    text: '카페를 고를 때 제일 먼저 보는 건 뭐예요?',
    highlightedText: '카페',
  ),
  DailyQuestion(
    id: 'q005',
    day: 5,
    number: 5,
    depth: QuestionDepth.light,
    text: '산책한다면 어떤 분위기의 길이 좋아요?',
    highlightedText: '산책',
  ),
  DailyQuestion(
    id: 'q006',
    day: 6,
    number: 6,
    depth: QuestionDepth.light,
    text: '요즘 유난히 먹고 싶은 음식이 있어요?',
    highlightedText: '먹고 싶은 음식',
  ),
  DailyQuestion(
    id: 'q007',
    day: 7,
    number: 7,
    depth: QuestionDepth.light,
    text: '갑자기 하루가 비면 어디에 가보고 싶어요?',
    highlightedText: '가보고 싶은 곳',
  ),
  DailyQuestion(
    id: 'q008',
    day: 8,
    number: 8,
    depth: QuestionDepth.daily,
    text: '오늘 하루가 괜찮았다고 느끼는 순간은 언제예요?',
    highlightedText: '괜찮았던 순간',
  ),
  DailyQuestion(
    id: 'q009',
    day: 9,
    number: 9,
    depth: QuestionDepth.daily,
    text: '기분 전환이 필요할 때 보통 뭘 해요?',
    highlightedText: '기분 전환',
  ),
  DailyQuestion(
    id: 'q010',
    day: 10,
    number: 10,
    depth: QuestionDepth.daily,
    text: '최근에 나를 웃게 한 작은 일이 있었나요?',
    highlightedText: '웃게 한 일',
  ),
  DailyQuestion(
    id: 'q011',
    day: 11,
    number: 11,
    depth: QuestionDepth.daily,
    text: '완벽한 주말 아침을 그려본다면 어떤 모습이에요?',
    highlightedText: '주말 아침',
  ),
  DailyQuestion(
    id: 'q012',
    day: 12,
    number: 12,
    depth: QuestionDepth.daily,
    text: '일이 끝난 뒤 제일 편해지는 루틴은 뭐예요?',
    highlightedText: '편해지는 루틴',
  ),
  DailyQuestion(
    id: 'q013',
    day: 13,
    number: 13,
    depth: QuestionDepth.daily,
    text: '요즘 새롭게 관심이 생긴 게 있나요?',
    highlightedText: '새로운 관심',
  ),
  DailyQuestion(
    id: 'q014',
    day: 14,
    number: 14,
    depth: QuestionDepth.daily,
    text: '나를 편하게 해주는 말이나 행동은 뭐예요?',
    highlightedText: '편안함',
  ),
  DailyQuestion(
    id: 'q015',
    day: 15,
    number: 15,
    depth: QuestionDepth.beliefs,
    text: '어떤 사람과 있을 때 마음이 편해져요?',
    highlightedText: '마음이 편한 사람',
  ),
  DailyQuestion(
    id: 'q016',
    day: 16,
    number: 16,
    depth: QuestionDepth.beliefs,
    text: '약속에서 은근히 중요하게 생각하는 게 있다면요?',
    highlightedText: '약속',
  ),
  DailyQuestion(
    id: 'q017',
    day: 17,
    number: 17,
    depth: QuestionDepth.beliefs,
    text: '처음엔 잘 안 보이지만 친해지면 드러나는 내 모습은?',
    highlightedText: '친해지면',
  ),
  DailyQuestion(
    id: 'q018',
    day: 18,
    number: 18,
    depth: QuestionDepth.beliefs,
    text: '마음에 드는 공간들은 어떤 공통점이 있어요?',
    highlightedText: '공간',
  ),
  DailyQuestion(
    id: 'q019',
    day: 19,
    number: 19,
    depth: QuestionDepth.beliefs,
    text: '오래 기억에 남는 다정함은 어떤 종류예요?',
    highlightedText: '다정함',
  ),
  DailyQuestion(
    id: 'q020',
    day: 20,
    number: 20,
    depth: QuestionDepth.beliefs,
    text: '요즘 나에게 필요한 속도는 어느 정도인 것 같아요?',
    highlightedText: '필요한 속도',
  ),
  DailyQuestion(
    id: 'q021',
    day: 21,
    number: 21,
    depth: QuestionDepth.beliefs,
    text: '사람들과 친해질 때 천천히 가고 싶은 부분이 있다면요?',
    highlightedText: '서두르지 않기',
  ),
  DailyQuestion(
    id: 'q022',
    day: 22,
    number: 22,
    depth: QuestionDepth.inner,
    text: '힘든 날에는 티가 나는 편이에요, 조용해지는 편이에요?',
    highlightedText: '힘든 날',
  ),
  DailyQuestion(
    id: 'q023',
    day: 23,
    number: 23,
    depth: QuestionDepth.inner,
    text: '마음이 놓인다고 느끼는 순간은 언제예요?',
    highlightedText: '마음이 놓이는 순간',
  ),
  DailyQuestion(
    id: 'q024',
    day: 24,
    number: 24,
    depth: QuestionDepth.inner,
    text: '고마움을 표현할 때 어떤 방식이 편해요?',
    highlightedText: '표현 방식',
  ),
  DailyQuestion(
    id: 'q025',
    day: 25,
    number: 25,
    depth: QuestionDepth.inner,
    text: '요즘 나를 가장 많이 움직이게 하는 건 뭐예요?',
    highlightedText: '움직이게 하는 것',
  ),
  DailyQuestion(
    id: 'q026',
    day: 26,
    number: 26,
    depth: QuestionDepth.inner,
    text: '조금 더 친해지면 알려주고 싶은 내 모습이 있나요?',
    highlightedText: '알려주고 싶은 모습',
  ),
  DailyQuestion(
    id: 'q027',
    day: 27,
    number: 27,
    depth: QuestionDepth.inner,
    text: '언젠가 같이 해보고 싶은 작은 장면이 있다면요?',
    highlightedText: '같이 하고 싶은 장면',
  ),
  DailyQuestion(
    id: 'q028',
    day: 28,
    number: 28,
    depth: QuestionDepth.inner,
    text: '최근 대화에서 기억에 남은 작은 장면이 있다면요?',
    highlightedText: '기억에 남은 장면',
  ),
];

const balanceQuestionCatalogV1 = [
  BalanceQuestion(
    id: 'b001',
    prompt: '여행을 떠난다면?',
    left: BalanceOption(id: 'sea', icon: '🌊', label: '조용한 바다'),
    right: BalanceOption(id: 'forest', icon: '🌲', label: '푸른 숲길'),
  ),
  BalanceQuestion(
    id: 'b002',
    prompt: '쉬는 날엔?',
    left: BalanceOption(id: 'home', icon: '🏡', label: '집에서 충전'),
    right: BalanceOption(id: 'walk', icon: '🚶', label: '밖에서 산책'),
  ),
  BalanceQuestion(
    id: 'b003',
    prompt: '카페를 고른다면?',
    left: BalanceOption(id: 'quiet', icon: '☕', label: '조용한 분위기'),
    right: BalanceOption(id: 'dessert', icon: '🍰', label: '디저트 맛집'),
  ),
  BalanceQuestion(
    id: 'b004',
    prompt: '영화를 본다면?',
    left: BalanceOption(id: 'calm', icon: '🎞️', label: '잔잔한 영화'),
    right: BalanceOption(id: 'funny', icon: '😄', label: '많이 웃는 영화'),
  ),
  BalanceQuestion(
    id: 'b005',
    prompt: '만나기 좋은 시간은?',
    left: BalanceOption(id: 'brunch', icon: '🥐', label: '낮 브런치'),
    right: BalanceOption(id: 'evening', icon: '🌙', label: '저녁 산책'),
  ),
  BalanceQuestion(
    id: 'b006',
    prompt: '약속을 잡는다면?',
    left: BalanceOption(id: 'reserved', icon: '🗓️', label: '미리 예약'),
    right: BalanceOption(id: 'spontaneous', icon: '✨', label: '즉흥 발견'),
  ),
  BalanceQuestion(
    id: 'b007',
    prompt: '대화 분위기는?',
    left: BalanceOption(id: 'deep', icon: '💭', label: '깊은 이야기'),
    right: BalanceOption(id: 'light', icon: '🍃', label: '가벼운 수다'),
  ),
  BalanceQuestion(
    id: 'b008',
    prompt: '메뉴를 고른다면?',
    left: BalanceOption(id: 'familiar', icon: '🍚', label: '익숙한 맛집'),
    right: BalanceOption(id: 'new', icon: '🧭', label: '새로운 곳'),
  ),
];

const seedMyAnswers = [
  Answer(
    questionId: 'q11',
    profileId: 'me',
    body: '비 오는 날엔 늘 잔잔한 재즈를 틀어둬요. 특히 빌 에반스요.',
    createdLabel: '6월 7일',
  ),
  Answer(
    questionId: 'q10',
    profileId: 'me',
    body: '늦잠 자고 일어나 동네 한 바퀴 산책하는 거요.',
    createdLabel: '6월 6일',
  ),
  Answer(
    questionId: 'q09',
    profileId: 'me',
    body: '큰 틀만 정하고 나머진 그때그때 정하는 편이에요.',
    createdLabel: '6월 5일',
  ),
];

const seedPartnerAnswers = [
  Answer(
    questionId: 'q12',
    profileId: 'partner',
    body: '저는 해가 막 지고 공기가 조금 조용해지는 시간이 좋아요. 하루가 부드럽게 정리되는 느낌이라서요.',
    createdLabel: '오늘',
  ),
  Answer(
    questionId: 'q11',
    profileId: 'partner',
    body: '저도 비 오면 음악 찾게 돼요! 저는 주로 어쿠스틱 발라드요.',
    createdLabel: '6월 7일',
  ),
  Answer(
    questionId: 'q10',
    profileId: 'partner',
    body: '저는 창문 열고 커피 내리면서 천천히 시작하는 아침이요.',
    createdLabel: '6월 6일',
  ),
  Answer(
    questionId: 'q09',
    profileId: 'partner',
    body: '저도요! 너무 빡빡하면 오히려 지치더라고요.',
    createdLabel: '6월 5일',
  ),
];

const seedMatchedKeywordsByQuestionId = {
  'q11': ['잔잔한 음악'],
  'q10': ['여유로운 아침'],
  'q09': ['느슨한 계획파'],
};

const seedInsight = RelationshipInsight(
  daysTogether: 12,
  questionCount: 12,
  matchCount: 8,
  longestAnswerLength: 214,
  similarityPercent: 78,
  matchedKeywords: ['잔잔한 음악', '여유로운 아침', '느슨한 계획파', '밤보다 새벽', '따뜻한 차', '산책'],
  timeline: [
    TimelineEvent(
      dateLabel: '6월 7일',
      description: '둘 다 잔잔한 음악을 좋아한다는 걸 알았어요',
      highlight: '잔잔한 음악',
    ),
    TimelineEvent(
      dateLabel: '6월 5일',
      description: '여행은 둘 다 느슨한 계획파였네요',
      highlight: '느슨한 계획파',
    ),
    TimelineEvent(dateLabel: '5월 30일', description: '민영님이 처음 답을 남긴 날'),
    TimelineEvent(dateLabel: '5월 28일', description: '우리, 조금씩 기록을 시작했어요'),
  ],
);

const seedBalanceQuestions = [
  BalanceQuestion(
    id: 'balance_1',
    prompt: '여행을 떠난다면?',
    left: BalanceOption(id: 'sea', icon: '🌊', label: '조용한 바다'),
    right: BalanceOption(id: 'mountain', icon: '⛰️', label: '푸른 산'),
    partnerChoiceId: 'mountain',
  ),
  BalanceQuestion(
    id: 'balance_2',
    prompt: '쉬는 날엔?',
    left: BalanceOption(id: 'home', icon: '🏡', label: '집에서 충전'),
    right: BalanceOption(id: 'outside', icon: '🚶', label: '밖에서 산책'),
    partnerChoiceId: 'outside',
  ),
  BalanceQuestion(
    id: 'balance_3',
    prompt: '카페를 고른다면?',
    left: BalanceOption(id: 'quiet', icon: '☕', label: '조용한 분위기'),
    right: BalanceOption(id: 'dessert', icon: '🍰', label: '디저트 맛집'),
    partnerChoiceId: 'quiet',
  ),
];

const seedProfileCards = [
  ProfileCardData(
    profile: AppProfile(
      id: 'partner',
      nickname: '영우',
      avatar: '🪻',
      isMe: false,
    ),
    subtitle: '알아가는 중 · 12일째',
    slots: [
      ProfileSlot(
        id: 'food',
        icon: '🍙',
        label: '먹고 싶은 음식',
        value: '매콤한 분식이나 따뜻한 국물',
      ),
      ProfileSlot(id: 'song', icon: '🎧', label: '요즘 노래', value: '잔잔한 어쿠스틱'),
      ProfileSlot(id: 'rest', icon: '🏡', label: '쉬는 방식'),
      ProfileSlot(id: 'cafe', icon: '☕', label: '카페 취향', value: '조용하고 햇빛 드는 곳'),
      ProfileSlot(id: 'walk', icon: '🚶', label: '산책 취향'),
      ProfileSlot(id: 'comfort', icon: '🌿', label: '편해지는 순간'),
      ProfileSlot(id: 'promise', icon: '🗓', label: '약속에서 중요한 것'),
      ProfileSlot(id: 'kindness', icon: '🤲', label: '기억나는 다정함'),
      ProfileSlot(id: 'pace', icon: '🕰️', label: '나에게 맞는 속도'),
      ProfileSlot(id: 'wish_scene', icon: '🧭', label: '같이 해보고 싶은 장면'),
    ],
  ),
  ProfileCardData(
    profile: AppProfile(id: 'me', nickname: '나', avatar: '🌿', isMe: true),
    subtitle: '천천히 채우는 중 · 12일째',
    slots: [
      ProfileSlot(id: 'food', icon: '🍙', label: '먹고 싶은 음식', value: '파스타와 커피'),
      ProfileSlot(id: 'song', icon: '🎧', label: '요즘 노래', value: '잔잔한 재즈'),
      ProfileSlot(id: 'rest', icon: '🏡', label: '쉬는 방식'),
      ProfileSlot(id: 'cafe', icon: '☕', label: '카페 취향'),
      ProfileSlot(id: 'walk', icon: '🚶', label: '산책 취향'),
      ProfileSlot(id: 'comfort', icon: '🌿', label: '편해지는 순간'),
      ProfileSlot(id: 'promise', icon: '🗓', label: '약속에서 중요한 것'),
      ProfileSlot(id: 'kindness', icon: '🤲', label: '기억나는 다정함'),
      ProfileSlot(id: 'pace', icon: '🕰️', label: '나에게 맞는 속도'),
      ProfileSlot(id: 'wish_scene', icon: '🧭', label: '같이 해보고 싶은 장면'),
      ProfileSlot(id: 'motto', icon: '💭', label: '작은 다짐'),
    ],
  ),
];

const seedWishes = [
  WishItem(
    id: 'sea_cafe',
    icon: '🌊',
    title: '노을 예쁜 바닷가 카페 가기',
    kind: WishKind.place,
    likedByProfileIds: {'me', 'partner'},
  ),
  WishItem(
    id: 'ramen',
    icon: '🍜',
    title: '늦은 밤 라멘집 같이 가보기',
    kind: WishKind.place,
    likedByProfileIds: {'me', 'partner'},
  ),
  WishItem(
    id: 'movie',
    icon: '🎬',
    title: '심야 영화관에서 영화 보기',
    kind: WishKind.activity,
    likedByProfileIds: {'partner'},
  ),
  WishItem(
    id: 'hike',
    icon: '🥾',
    title: '가벼운 동네 뒷산 산책',
    kind: WishKind.activity,
    likedByProfileIds: {'me'},
  ),
  WishItem(
    id: 'film',
    icon: '📷',
    title: '필름 카메라로 서로 찍어주기',
    kind: WishKind.activity,
    likedByProfileIds: {'partner'},
  ),
  WishItem(
    id: 'first_cafe',
    icon: '☕',
    title: '조용한 카페에서 첫 만남',
    kind: WishKind.place,
    likedByProfileIds: {'me', 'partner'},
    done: true,
  ),
];

const seedMusicNotes = [
  MusicNote(
    id: 'music_1',
    title: '밤 산책',
    artist: '민영의 추천',
    link: 'https://music.example/night-walk',
    note: '퇴근길에 들으면 마음이 조금 차분해져요.',
    mood: '밤',
    createdByProfileId: 'partner',
    createdLabel: '오늘',
  ),
  MusicNote(
    id: 'music_2',
    title: '오후의 문장',
    artist: '영우의 추천',
    link: 'https://music.example/afternoon',
    note: '카페에서 이야기할 때 배경에 있으면 좋을 것 같아서요.',
    mood: '카페',
    createdByProfileId: 'me',
    createdLabel: '오늘',
  ),
];
