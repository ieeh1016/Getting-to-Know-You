import 'dart:async';

import 'package:flutter/foundation.dart';

enum AlagagiRoute {
  invite,
  home,
  answer,
  archive,
  records,
  music,
  meetings,
  meetingPlans,
  places,
  stockStory,
  improvements,
  balance,
  profileCard,
  wishlist,
  my,
}

enum UnreadActivityFeature {
  profileCard,
  wishlist,
  meetings,
  places,
  curiosity,
  stocks,
  music,
  improvements,
}

enum ArchiveFilter { all, bothAnswered, similar }

enum ProfileCardTab { partner, me }

enum WishlistFilter { all, mutual, places, activities }

enum WishKind { place, activity }

enum MusicListFilter { all, unlistened, listened, mine, partner }

enum MeetingAvailability { available, maybe, busy }

enum MeetingTimeSlot { morning, afternoon, evening }

enum MapApiProvider { kakao }

enum PlaceCategory { cafe, food, exhibition, walk, activity }

enum StockStoryTab { stories, holdings }

enum StockStoryListFilter { all, mine, partner, needsReply, replied }

enum StockHoldingListFilter {
  all,
  mine,
  partner,
  needsReply,
  shared,
  holding,
  considering,
  closed,
}

const musicMoodOptions = ['차분한', '산책', '카페', '밤', '가벼운', '집중', '신나는', '파이팅'];
const stockStoryReplyToneOptions = ['같이 볼래요', '더 찾아볼게요', '조심해요'];
const stockHoldingStatusOptions = ['보유 중', '정리 고민 중', '최근 정리함'];
const stockHoldingWeightOptions = ['작게', '보통', '크게'];
const improvementPostCategoryOptions = ['개선', '추가 요청', '불편함', '아이디어'];

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
    this.scheduleEntries = const [],
    this.meetingPlans = const [],
    this.sharedPlaces = const [],
    this.curiosityCards = const [],
    this.stockStories = const [],
    this.stockHoldings = const [],
    this.improvementPosts = const [],
    this.dailyProgress,
    this.personalization = const SpacePersonalization(),
  });

  final List<Answer> answers;
  final List<AnswerComment> answerComments;
  final List<BalanceSelection> balanceSelections;
  final List<ProfileSlotValue> profileSlots;
  final List<WishItem> wishes;
  final List<MusicNote> musicNotes;
  final List<ScheduleEntry> scheduleEntries;
  final List<MeetingPlan> meetingPlans;
  final List<SharedPlace> sharedPlaces;
  final List<CuriosityCard> curiosityCards;
  final List<StockStory> stockStories;
  final List<StockHolding> stockHoldings;
  final List<ImprovementPost> improvementPosts;
  final DailyQuestionProgress? dailyProgress;
  final SpacePersonalization personalization;
}

class DiagnosticEvent {
  const DiagnosticEvent({
    required this.id,
    required this.feature,
    required this.action,
    required this.message,
    required this.createdByProfileId,
    this.targetId = '',
    this.detail = '',
    this.createdAt,
  });

  final String id;
  final String feature;
  final String action;
  final String targetId;
  final String message;
  final String detail;
  final String createdByProfileId;
  final DateTime? createdAt;
}

class BalanceSelection {
  const BalanceSelection({
    required this.questionId,
    required this.profileId,
    required this.optionId,
    this.reason,
    this.resultRevealedAt,
  });

  final String questionId;
  final String profileId;
  final String optionId;
  final String? reason;
  final DateTime? resultRevealedAt;
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

  Future<void> deleteBalanceSelection(
    String spaceId,
    String questionId,
    String profileId,
  );

  Future<void> saveProfileSlot(
    String spaceId,
    String profileId,
    ProfileSlot slot,
  );

  Future<void> deleteProfileSlot(
    String spaceId,
    String profileId,
    String slotId,
  );

  Future<void> saveWish(String spaceId, WishItem wish);

  Future<void> deleteWish(String spaceId, String wishId);

  Future<void> saveMusicNote(String spaceId, MusicNote note);

  Future<void> saveMusicNoteListenState(String spaceId, MusicNote note);

  Future<void> deleteMusicNote(String spaceId, String noteId);

  Future<void> saveScheduleEntry(String spaceId, ScheduleEntry entry);

  Future<void> saveMeetingPlan(String spaceId, MeetingPlan plan);

  Future<void> saveSharedPlace(String spaceId, SharedPlace place);

  Future<void> saveSharedPlaceMeetingLinks(String spaceId, SharedPlace place);

  Future<void> deleteSharedPlace(String spaceId, String placeId);

  Future<void> saveDiagnosticEvent(String spaceId, DiagnosticEvent event);

  Future<void> saveCuriosityCard(String spaceId, CuriosityCard card);

  Future<void> saveStockStory(String spaceId, StockStory story);

  Future<void> deleteStockStory(String spaceId, String storyId);

  Future<void> saveStockHolding(String spaceId, StockHolding holding);

  Future<void> deleteStockHolding(String spaceId, String holdingId);

  Future<void> saveImprovementPost(String spaceId, ImprovementPost post);

  Future<void> deleteImprovementPost(String spaceId, String postId);
}

class AppProfile {
  const AppProfile({
    required this.id,
    required this.nickname,
    required this.avatar,
    required this.isMe,
    this.role = '',
  });

  final String id;
  final String nickname;
  final String avatar;
  final bool isMe;
  final String role;

  bool get isOwner =>
      role == 'owner' || id == 'youngwooUid' || nickname == '영우';

  AppProfile copyWith({String? nickname, String? avatar, String? role}) {
    return AppProfile(
      id: id,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      isMe: isMe,
      role: role ?? this.role,
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
    this.skipped = false,
    this.hidden = false,
    this.custom = false,
    this.updatedAt,
    this.updatedByProfileId,
  });

  final String id;
  final String label;
  final String icon;
  final String category;
  final String inputHint;
  final String? value;
  final bool locked;
  final String? unlockHint;
  final bool skipped;
  final bool hidden;
  final bool custom;
  final DateTime? updatedAt;
  final String? updatedByProfileId;

  ProfileSlot copyWith({
    String? label,
    String? icon,
    String? value,
    bool clearValue = false,
    bool? locked,
    String? unlockHint,
    String? category,
    String? inputHint,
    bool? skipped,
    bool? hidden,
    bool? custom,
    DateTime? updatedAt,
    String? updatedByProfileId,
  }) {
    return ProfileSlot(
      id: id,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      inputHint: inputHint ?? this.inputHint,
      value: clearValue ? null : value ?? this.value,
      locked: locked ?? this.locked,
      unlockHint: unlockHint ?? this.unlockHint,
      skipped: skipped ?? this.skipped,
      hidden: hidden ?? this.hidden,
      custom: custom ?? this.custom,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedByProfileId: updatedByProfileId ?? this.updatedByProfileId,
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

  List<ProfileSlot> get visibleSlots =>
      slots.where((slot) => !slot.hidden).toList();

  int get filledCount =>
      slots.where((slot) => !slot.hidden && slot.value != null).length;

  int get skippedCount =>
      slots.where((slot) => !slot.hidden && slot.skipped).length;

  int get hiddenCount => slots.where((slot) => slot.hidden).length;

  int get customCount =>
      slots.where((slot) => !slot.hidden && slot.custom).length;

  int get openCount => slots
      .where((slot) => slot.value == null && !slot.skipped && !slot.hidden)
      .length;

  int get totalCount => slots.where((slot) => !slot.hidden).length;

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
    this.updatedAt,
    this.updatedByProfileId,
  });

  final String id;
  final String icon;
  final String title;
  final WishKind kind;
  final String createdByProfileId;
  final Set<String> likedByProfileIds;
  final bool done;
  final DateTime? updatedAt;
  final String? updatedByProfileId;

  bool get isMutual => likedByProfileIds.length >= 2;

  String get lastChangedByProfileId => updatedByProfileId ?? createdByProfileId;

  WishItem copyWith({
    String? title,
    WishKind? kind,
    String? icon,
    String? createdByProfileId,
    Set<String>? likedByProfileIds,
    bool? done,
    DateTime? updatedAt,
    String? updatedByProfileId,
  }) {
    return WishItem(
      id: id,
      icon: icon ?? this.icon,
      title: title ?? this.title,
      kind: kind ?? this.kind,
      createdByProfileId: createdByProfileId ?? this.createdByProfileId,
      likedByProfileIds: likedByProfileIds ?? this.likedByProfileIds,
      done: done ?? this.done,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedByProfileId: updatedByProfileId ?? this.updatedByProfileId,
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
    this.listenedByProfileIds = const <String>{},
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
  final Set<String> listenedByProfileIds;
  final DateTime? updatedAt;

  bool isListenedBy(String profileId) =>
      listenedByProfileIds.contains(profileId);

  MusicNote copyWith({
    String? title,
    String? artist,
    String? link,
    String? note,
    String? mood,
    String? createdByProfileId,
    String? createdLabel,
    Set<String>? listenedByProfileIds,
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
      listenedByProfileIds: listenedByProfileIds ?? this.listenedByProfileIds,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ScheduleTimeBlock {
  const ScheduleTimeBlock({
    required this.startMinute,
    required this.endMinute,
    required this.title,
  });

  final int startMinute;
  final int endMinute;
  final String title;

  String get id => '$startMinute-$endMinute-$title';

  String get timeLabel =>
      '${minuteLabel(startMinute)}-${minuteLabel(endMinute)}';

  static String minuteLabel(int minuteOfDay) {
    final hour = minuteOfDay ~/ 60;
    final minute = minuteOfDay % 60;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}

class ScheduleEntry {
  const ScheduleEntry({
    required this.dateKey,
    required this.profileId,
    required this.availability,
    required this.timeSlots,
    this.timeBlocks = const [],
    this.sharedMemo = '',
    this.isMeetingDay = false,
    this.meetingTimeLabel = '',
    this.meetingNote = '',
    this.meetingPlanItems = const [],
    this.updatedAt,
  });

  final String dateKey;
  final String profileId;
  final MeetingAvailability availability;
  final Set<MeetingTimeSlot> timeSlots;
  final List<ScheduleTimeBlock> timeBlocks;
  final String sharedMemo;
  final bool isMeetingDay;
  final String meetingTimeLabel;
  final String meetingNote;
  final List<String> meetingPlanItems;
  final DateTime? updatedAt;

  String get id => '${dateKey}_$profileId';

  bool get canMeet =>
      availability == MeetingAvailability.available && timeSlots.isNotEmpty;

  ScheduleEntry copyWith({
    MeetingAvailability? availability,
    Set<MeetingTimeSlot>? timeSlots,
    List<ScheduleTimeBlock>? timeBlocks,
    String? sharedMemo,
    bool? isMeetingDay,
    String? meetingTimeLabel,
    String? meetingNote,
    List<String>? meetingPlanItems,
    DateTime? updatedAt,
  }) {
    return ScheduleEntry(
      dateKey: dateKey,
      profileId: profileId,
      availability: availability ?? this.availability,
      timeSlots: timeSlots ?? this.timeSlots,
      timeBlocks: timeBlocks ?? this.timeBlocks,
      sharedMemo: sharedMemo ?? this.sharedMemo,
      isMeetingDay: isMeetingDay ?? this.isMeetingDay,
      meetingTimeLabel: meetingTimeLabel ?? this.meetingTimeLabel,
      meetingNote: meetingNote ?? this.meetingNote,
      meetingPlanItems: meetingPlanItems ?? this.meetingPlanItems,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class MeetingPlan {
  const MeetingPlan({
    required this.dateKey,
    required this.items,
    required this.updatedByProfileId,
    this.updatedAt,
  });

  final String dateKey;
  final List<String> items;
  final String updatedByProfileId;
  final DateTime? updatedAt;

  String get id => dateKey;

  MeetingPlan copyWith({
    List<String>? items,
    String? updatedByProfileId,
    DateTime? updatedAt,
  }) {
    return MeetingPlan(
      dateKey: dateKey,
      items: items ?? this.items,
      updatedByProfileId: updatedByProfileId ?? this.updatedByProfileId,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class MeetingCandidate {
  const MeetingCandidate({
    required this.dateKey,
    required this.sharedSlots,
    this.myEntry,
    this.partnerEntry,
  });

  final String dateKey;
  final Set<MeetingTimeSlot> sharedSlots;
  final ScheduleEntry? myEntry;
  final ScheduleEntry? partnerEntry;
}

class MeetingPlaceLink {
  const MeetingPlaceLink({
    required this.dateKey,
    required this.order,
    this.reservationTimeLabel = '',
  });

  final String dateKey;
  final int order;
  final String reservationTimeLabel;

  MeetingPlaceLink copyWith({int? order, String? reservationTimeLabel}) {
    return MeetingPlaceLink(
      dateKey: dateKey,
      order: order ?? this.order,
      reservationTimeLabel: reservationTimeLabel ?? this.reservationTimeLabel,
    );
  }
}

class SharedPlace {
  const SharedPlace({
    required this.id,
    required this.name,
    required this.address,
    required this.category,
    required this.provider,
    required this.createdByProfileId,
    required this.interestedByProfileIds,
    this.providerPlaceId = '',
    this.latitude,
    this.longitude,
    this.note = '',
    this.linkedDateKey,
    this.meetingPlanLinks = const [],
    this.updatedAt,
    this.updatedByProfileId,
  });

  final String id;
  final String name;
  final String address;
  final PlaceCategory category;
  final MapApiProvider provider;
  final String providerPlaceId;
  final double? latitude;
  final double? longitude;
  final String note;
  final String createdByProfileId;
  final Set<String> interestedByProfileIds;
  final String? linkedDateKey;
  final List<MeetingPlaceLink> meetingPlanLinks;
  final DateTime? updatedAt;
  final String? updatedByProfileId;

  bool get isMutual => interestedByProfileIds.length >= 2;

  String get lastChangedByProfileId => updatedByProfileId ?? createdByProfileId;

  bool isLinkedToMeetingDate(String dateKey) {
    return linkedDateKey == dateKey || meetingPlanLinkFor(dateKey) != null;
  }

  MeetingPlaceLink? meetingPlanLinkFor(String dateKey) {
    for (final link in meetingPlanLinks) {
      if (link.dateKey == dateKey) {
        return link;
      }
    }
    if (linkedDateKey == dateKey) {
      return MeetingPlaceLink(dateKey: dateKey, order: 0);
    }
    return null;
  }

  List<MeetingPlaceLink> normalizedMeetingPlanLinks() {
    final linksByDate = <String, MeetingPlaceLink>{};
    for (final link in meetingPlanLinks) {
      if (link.dateKey.trim().isEmpty) {
        continue;
      }
      linksByDate[link.dateKey] = link;
    }
    final legacyDateKey = linkedDateKey;
    if (legacyDateKey != null &&
        legacyDateKey.trim().isNotEmpty &&
        !linksByDate.containsKey(legacyDateKey)) {
      linksByDate[legacyDateKey] = MeetingPlaceLink(
        dateKey: legacyDateKey,
        order: 0,
      );
    }
    final links = linksByDate.values.toList()
      ..sort((a, b) {
        final orderComparison = a.order.compareTo(b.order);
        if (orderComparison != 0) {
          return orderComparison;
        }
        return a.dateKey.compareTo(b.dateKey);
      });
    return List<MeetingPlaceLink>.unmodifiable(links);
  }

  SharedPlace upsertMeetingPlanLink(MeetingPlaceLink link) {
    final links = normalizedMeetingPlanLinks().toList();
    final index = links.indexWhere(
      (candidate) => candidate.dateKey == link.dateKey,
    );
    if (index == -1) {
      links.add(link);
    } else {
      links[index] = link;
    }
    return copyWith(
      linkedDateKey: link.dateKey,
      meetingPlanLinks: List<MeetingPlaceLink>.unmodifiable(links),
    );
  }

  SharedPlace removeMeetingPlanLink(String dateKey) {
    final links = normalizedMeetingPlanLinks()
        .where((link) => link.dateKey != dateKey)
        .toList();
    return copyWith(
      linkedDateKey: links.isEmpty ? null : links.first.dateKey,
      clearLinkedDateKey: links.isEmpty,
      meetingPlanLinks: List<MeetingPlaceLink>.unmodifiable(links),
    );
  }

  SharedPlace copyWith({
    String? name,
    String? address,
    PlaceCategory? category,
    MapApiProvider? provider,
    String? providerPlaceId,
    double? latitude,
    double? longitude,
    String? note,
    Set<String>? interestedByProfileIds,
    String? linkedDateKey,
    bool clearLinkedDateKey = false,
    List<MeetingPlaceLink>? meetingPlanLinks,
    DateTime? updatedAt,
    String? updatedByProfileId,
  }) {
    return SharedPlace(
      id: id,
      name: name ?? this.name,
      address: address ?? this.address,
      category: category ?? this.category,
      provider: provider ?? this.provider,
      providerPlaceId: providerPlaceId ?? this.providerPlaceId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      note: note ?? this.note,
      createdByProfileId: createdByProfileId,
      interestedByProfileIds:
          interestedByProfileIds ?? this.interestedByProfileIds,
      linkedDateKey: clearLinkedDateKey
          ? null
          : linkedDateKey ?? this.linkedDateKey,
      meetingPlanLinks: meetingPlanLinks ?? this.meetingPlanLinks,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedByProfileId: updatedByProfileId ?? this.updatedByProfileId,
    );
  }
}

class CuriosityCard {
  const CuriosityCard({
    required this.id,
    required this.fromProfileId,
    required this.toProfileId,
    required this.question,
    required this.createdLabel,
    this.reply,
    this.repliedLabel,
    this.updatedAt,
    this.updatedByProfileId,
  });

  final String id;
  final String fromProfileId;
  final String toProfileId;
  final String question;
  final String createdLabel;
  final String? reply;
  final String? repliedLabel;
  final DateTime? updatedAt;
  final String? updatedByProfileId;

  bool get hasReply => reply != null && reply!.trim().isNotEmpty;

  String get lastChangedByProfileId =>
      updatedByProfileId ?? (hasReply ? toProfileId : fromProfileId);

  CuriosityCard copyWith({
    String? question,
    String? reply,
    String? repliedLabel,
    DateTime? updatedAt,
    String? updatedByProfileId,
  }) {
    return CuriosityCard(
      id: id,
      fromProfileId: fromProfileId,
      toProfileId: toProfileId,
      question: question ?? this.question,
      createdLabel: createdLabel,
      reply: reply ?? this.reply,
      repliedLabel: repliedLabel ?? this.repliedLabel,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedByProfileId: updatedByProfileId ?? this.updatedByProfileId,
    );
  }
}

class ImprovementPost {
  const ImprovementPost({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.createdByProfileId,
    required this.createdLabel,
    this.ownerNote = '',
    this.ownerNoteProfileId = '',
    this.ownerNoteLabel = '',
    this.resolved = false,
    this.resolvedByProfileId = '',
    this.resolvedLabel = '',
    this.updatedAt,
  });

  final String id;
  final String title;
  final String body;
  final String category;
  final String createdByProfileId;
  final String createdLabel;
  final String ownerNote;
  final String ownerNoteProfileId;
  final String ownerNoteLabel;
  final bool resolved;
  final String resolvedByProfileId;
  final String resolvedLabel;
  final DateTime? updatedAt;

  bool get hasOwnerNote => ownerNote.trim().isNotEmpty;

  ImprovementPost copyWith({
    String? title,
    String? body,
    String? category,
    String? ownerNote,
    String? ownerNoteProfileId,
    String? ownerNoteLabel,
    bool? resolved,
    String? resolvedByProfileId,
    String? resolvedLabel,
    DateTime? updatedAt,
  }) {
    return ImprovementPost(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      category: category ?? this.category,
      createdByProfileId: createdByProfileId,
      createdLabel: createdLabel,
      ownerNote: ownerNote ?? this.ownerNote,
      ownerNoteProfileId: ownerNoteProfileId ?? this.ownerNoteProfileId,
      ownerNoteLabel: ownerNoteLabel ?? this.ownerNoteLabel,
      resolved: resolved ?? this.resolved,
      resolvedByProfileId: resolvedByProfileId ?? this.resolvedByProfileId,
      resolvedLabel: resolvedLabel ?? this.resolvedLabel,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class StockStory {
  const StockStory({
    required this.id,
    required this.name,
    required this.reason,
    required this.upside,
    required this.risk,
    required this.question,
    required this.createdByProfileId,
    required this.createdLabel,
    this.replyTone,
    this.reply,
    this.repliedByProfileId,
    this.repliedLabel,
    this.updatedAt,
    this.updatedByProfileId,
  });

  final String id;
  final String name;
  final String reason;
  final String upside;
  final String risk;
  final String question;
  final String createdByProfileId;
  final String createdLabel;
  final String? replyTone;
  final String? reply;
  final String? repliedByProfileId;
  final String? repliedLabel;
  final DateTime? updatedAt;
  final String? updatedByProfileId;

  bool get hasReply => reply != null && reply!.trim().isNotEmpty;

  String get lastChangedByProfileId =>
      updatedByProfileId ?? repliedByProfileId ?? createdByProfileId;

  StockStory copyWith({
    String? name,
    String? reason,
    String? upside,
    String? risk,
    String? question,
    String? replyTone,
    String? reply,
    String? repliedByProfileId,
    String? repliedLabel,
    DateTime? updatedAt,
    String? updatedByProfileId,
  }) {
    return StockStory(
      id: id,
      name: name ?? this.name,
      reason: reason ?? this.reason,
      upside: upside ?? this.upside,
      risk: risk ?? this.risk,
      question: question ?? this.question,
      createdByProfileId: createdByProfileId,
      createdLabel: createdLabel,
      replyTone: replyTone ?? this.replyTone,
      reply: reply ?? this.reply,
      repliedByProfileId: repliedByProfileId ?? this.repliedByProfileId,
      repliedLabel: repliedLabel ?? this.repliedLabel,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedByProfileId: updatedByProfileId ?? this.updatedByProfileId,
    );
  }
}

class StockHolding {
  const StockHolding({
    required this.id,
    required this.name,
    required this.status,
    required this.weightLabel,
    required this.reason,
    required this.watchPoint,
    required this.concern,
    required this.question,
    required this.createdByProfileId,
    required this.createdLabel,
    this.replyTone,
    this.reply,
    this.repliedByProfileId,
    this.repliedLabel,
    this.updatedAt,
    this.updatedByProfileId,
  });

  final String id;
  final String name;
  final String status;
  final String weightLabel;
  final String reason;
  final String watchPoint;
  final String concern;
  final String question;
  final String createdByProfileId;
  final String createdLabel;
  final String? replyTone;
  final String? reply;
  final String? repliedByProfileId;
  final String? repliedLabel;
  final DateTime? updatedAt;
  final String? updatedByProfileId;

  bool get hasReply => reply != null && reply!.trim().isNotEmpty;

  String get lastChangedByProfileId =>
      updatedByProfileId ?? repliedByProfileId ?? createdByProfileId;

  StockHolding copyWith({
    String? name,
    String? status,
    String? weightLabel,
    String? reason,
    String? watchPoint,
    String? concern,
    String? question,
    String? replyTone,
    String? reply,
    String? repliedByProfileId,
    String? repliedLabel,
    DateTime? updatedAt,
    String? updatedByProfileId,
  }) {
    return StockHolding(
      id: id,
      name: name ?? this.name,
      status: status ?? this.status,
      weightLabel: weightLabel ?? this.weightLabel,
      reason: reason ?? this.reason,
      watchPoint: watchPoint ?? this.watchPoint,
      concern: concern ?? this.concern,
      question: question ?? this.question,
      createdByProfileId: createdByProfileId,
      createdLabel: createdLabel,
      replyTone: replyTone ?? this.replyTone,
      reply: reply ?? this.reply,
      repliedByProfileId: repliedByProfileId ?? this.repliedByProfileId,
      repliedLabel: repliedLabel ?? this.repliedLabel,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedByProfileId: updatedByProfileId ?? this.updatedByProfileId,
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

class UnreadActivity {
  const UnreadActivity({
    required this.id,
    required this.feature,
    required this.title,
    required this.description,
    required this.updatedAt,
    required this.route,
  });

  final String id;
  final UnreadActivityFeature feature;
  final String title;
  final String description;
  final DateTime updatedAt;
  final AlagagiRoute route;
}

extension UnreadActivityFeatureMeta on UnreadActivityFeature {
  String get storageKey {
    return switch (this) {
      UnreadActivityFeature.profileCard => 'profileCard',
      UnreadActivityFeature.wishlist => 'wishlist',
      UnreadActivityFeature.meetings => 'meetings',
      UnreadActivityFeature.places => 'places',
      UnreadActivityFeature.curiosity => 'curiosity',
      UnreadActivityFeature.stocks => 'stocks',
      UnreadActivityFeature.music => 'music',
      UnreadActivityFeature.improvements => 'improvements',
    };
  }

  String get label {
    return switch (this) {
      UnreadActivityFeature.profileCard => '소개 카드',
      UnreadActivityFeature.wishlist => '언젠가, 같이',
      UnreadActivityFeature.meetings => '약속',
      UnreadActivityFeature.places => '장소',
      UnreadActivityFeature.curiosity => '궁금함',
      UnreadActivityFeature.stocks => '주식 이야기',
      UnreadActivityFeature.music => '음악 노트',
      UnreadActivityFeature.improvements => '건의함',
    };
  }

  AlagagiRoute get route {
    return switch (this) {
      UnreadActivityFeature.profileCard => AlagagiRoute.profileCard,
      UnreadActivityFeature.wishlist => AlagagiRoute.wishlist,
      UnreadActivityFeature.meetings => AlagagiRoute.meetings,
      UnreadActivityFeature.places => AlagagiRoute.places,
      UnreadActivityFeature.curiosity => AlagagiRoute.home,
      UnreadActivityFeature.stocks => AlagagiRoute.stockStory,
      UnreadActivityFeature.music => AlagagiRoute.music,
      UnreadActivityFeature.improvements => AlagagiRoute.improvements,
    };
  }
}

abstract class MusicNoteSeenStore {
  DateTime? readLastSeenAt(
    String spaceId,
    String profileId,
    UnreadActivityFeature feature,
  );

  void writeLastSeenAt(
    String spaceId,
    String profileId,
    UnreadActivityFeature feature,
    DateTime timestamp,
  );

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
  DateTime? readLastSeenAt(
    String spaceId,
    String profileId,
    UnreadActivityFeature feature,
  ) {
    return _values[_key(spaceId, profileId, feature)];
  }

  @override
  void writeLastSeenAt(
    String spaceId,
    String profileId,
    UnreadActivityFeature feature,
    DateTime timestamp,
  ) {
    _values[_key(spaceId, profileId, feature)] = timestamp;
  }

  @override
  DateTime? readLastSeenMusicNoteAt(String spaceId, String profileId) {
    return readLastSeenAt(spaceId, profileId, UnreadActivityFeature.music);
  }

  @override
  void writeLastSeenMusicNoteAt(
    String spaceId,
    String profileId,
    DateTime timestamp,
  ) {
    writeLastSeenAt(spaceId, profileId, UnreadActivityFeature.music, timestamp);
  }

  static String _key(
    String spaceId,
    String profileId,
    UnreadActivityFeature feature,
  ) {
    return 'alagagi:lastSeen:${feature.storageKey}:$spaceId:$profileId';
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
    this.editingWishId,
    this.wishSaveStatus = SaveStatus.idle,
    this.wishSaveFeedback,
    this.wishSaveTargetId,
    this.musicDraftVisible = false,
    this.musicDraftTitle = '',
    this.musicDraftArtist = '',
    this.musicDraftLink = '',
    this.musicDraftNote = '',
    this.musicDraftMood = '차분한',
    this.musicListFilter = MusicListFilter.all,
    this.editingMusicNoteId,
    this.musicSaveStatus = SaveStatus.idle,
    this.musicSaveFeedback,
    this.musicSaveTargetId,
    this.selectedMeetingDateKey,
    this.selectedMeetingPlanDateKey,
    this.meetingDraftAvailability = MeetingAvailability.available,
    this.meetingDraftTimeSlots = const {MeetingTimeSlot.evening},
    this.meetingDraftTimeBlocks = const [],
    this.meetingBlockStartDraft = '',
    this.meetingBlockEndDraft = '',
    this.meetingBlockTitleDraft = '',
    this.meetingDraftSharedMemo = '',
    this.meetingDraftIsMeetingDay = false,
    this.meetingDraftMeetingTimeLabel = '',
    this.meetingDraftMeetingNote = '',
    this.meetingDraftMeetingPlanText = '',
    this.meetingPlanDraftText = '',
    this.meetingPlanItemDraft = '',
    this.editingMeetingPlanItemIndex,
    this.meetingDraftError,
    this.meetingSaveStatus = SaveStatus.idle,
    this.meetingSaveFeedback,
    this.meetingSaveTargetId,
    this.placeDraftVisible = false,
    this.placeDraftName = '',
    this.placeDraftAddress = '',
    this.placeDraftNote = '',
    this.placeDraftCategory = PlaceCategory.cafe,
    this.placeDraftProvider = MapApiProvider.kakao,
    this.placeDraftProviderPlaceId = '',
    this.placeDraftLatitude,
    this.placeDraftLongitude,
    this.placeDraftError,
    this.editingPlaceId,
    this.placeSaveStatus = SaveStatus.idle,
    this.placeSaveFeedback,
    this.placeSaveTargetId,
    this.placeError,
    this.stockStoryTab = StockStoryTab.stories,
    this.stockStoryListFilter = StockStoryListFilter.all,
    this.stockStoryDraftVisible = false,
    this.stockStoryDraftName = '',
    this.stockStoryDraftReason = '',
    this.stockStoryDraftUpside = '',
    this.stockStoryDraftRisk = '',
    this.stockStoryDraftQuestion = '',
    this.stockStoryDraftError,
    this.stockStorySaveStatus = SaveStatus.idle,
    this.stockStorySaveFeedback,
    this.stockStorySaveTargetId,
    this.stockStoryReplyDraftsByStoryId = const {},
    this.stockStoryReplyTonesByStoryId = const {},
    this.stockStoryReplyError,
    this.stockHoldingDraftVisible = false,
    this.stockHoldingDraftName = '',
    this.stockHoldingDraftStatus = '보유 중',
    this.stockHoldingDraftWeightLabel = '보통',
    this.stockHoldingDraftReason = '',
    this.stockHoldingDraftWatchPoint = '',
    this.stockHoldingDraftConcern = '',
    this.stockHoldingDraftQuestion = '',
    this.stockHoldingDraftError,
    this.editingStockHoldingId,
    this.stockHoldingSaveStatus = SaveStatus.idle,
    this.stockHoldingSaveFeedback,
    this.stockHoldingSaveTargetId,
    this.stockHoldingReplyDraftsByHoldingId = const {},
    this.stockHoldingReplyTonesByHoldingId = const {},
    this.stockHoldingReplyError,
    this.stockHoldingListFilter = StockHoldingListFilter.all,
    this.improvementDraftVisible = false,
    this.improvementDraftTitle = '',
    this.improvementDraftBody = '',
    this.improvementDraftCategory = '개선',
    this.improvementDraftError,
    this.editingImprovementPostId,
    this.improvementSaveStatus = SaveStatus.idle,
    this.improvementSaveFeedback,
    this.improvementSaveTargetId,
    this.curiosityQuestionDraft = '',
    this.curiosityReplyDraftsByCardId = const {},
    this.curiosityError,
    this.curiositySaveStatus = SaveStatus.idle,
    this.curiositySaveFeedback,
    this.curiositySaveTargetId,
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
  final String? editingWishId;
  final SaveStatus wishSaveStatus;
  final String? wishSaveFeedback;
  final String? wishSaveTargetId;
  final bool musicDraftVisible;
  final String musicDraftTitle;
  final String musicDraftArtist;
  final String musicDraftLink;
  final String musicDraftNote;
  final String musicDraftMood;
  final MusicListFilter musicListFilter;
  final String? editingMusicNoteId;
  final SaveStatus musicSaveStatus;
  final String? musicSaveFeedback;
  final String? musicSaveTargetId;
  final String? selectedMeetingDateKey;
  final String? selectedMeetingPlanDateKey;
  final MeetingAvailability meetingDraftAvailability;
  final Set<MeetingTimeSlot> meetingDraftTimeSlots;
  final List<ScheduleTimeBlock> meetingDraftTimeBlocks;
  final String meetingBlockStartDraft;
  final String meetingBlockEndDraft;
  final String meetingBlockTitleDraft;
  final String meetingDraftSharedMemo;
  final bool meetingDraftIsMeetingDay;
  final String meetingDraftMeetingTimeLabel;
  final String meetingDraftMeetingNote;
  final String meetingDraftMeetingPlanText;
  final String meetingPlanDraftText;
  final String meetingPlanItemDraft;
  final int? editingMeetingPlanItemIndex;
  final String? meetingDraftError;
  final SaveStatus meetingSaveStatus;
  final String? meetingSaveFeedback;
  final String? meetingSaveTargetId;
  final bool placeDraftVisible;
  final String placeDraftName;
  final String placeDraftAddress;
  final String placeDraftNote;
  final PlaceCategory placeDraftCategory;
  final MapApiProvider placeDraftProvider;
  final String placeDraftProviderPlaceId;
  final double? placeDraftLatitude;
  final double? placeDraftLongitude;
  final String? placeDraftError;
  final String? editingPlaceId;
  final SaveStatus placeSaveStatus;
  final String? placeSaveFeedback;
  final String? placeSaveTargetId;
  final String? placeError;
  final StockStoryTab stockStoryTab;
  final StockStoryListFilter stockStoryListFilter;
  final bool stockStoryDraftVisible;
  final String stockStoryDraftName;
  final String stockStoryDraftReason;
  final String stockStoryDraftUpside;
  final String stockStoryDraftRisk;
  final String stockStoryDraftQuestion;
  final String? stockStoryDraftError;
  final SaveStatus stockStorySaveStatus;
  final String? stockStorySaveFeedback;
  final String? stockStorySaveTargetId;
  final Map<String, String> stockStoryReplyDraftsByStoryId;
  final Map<String, String> stockStoryReplyTonesByStoryId;
  final String? stockStoryReplyError;
  final bool stockHoldingDraftVisible;
  final String stockHoldingDraftName;
  final String stockHoldingDraftStatus;
  final String stockHoldingDraftWeightLabel;
  final String stockHoldingDraftReason;
  final String stockHoldingDraftWatchPoint;
  final String stockHoldingDraftConcern;
  final String stockHoldingDraftQuestion;
  final String? stockHoldingDraftError;
  final String? editingStockHoldingId;
  final SaveStatus stockHoldingSaveStatus;
  final String? stockHoldingSaveFeedback;
  final String? stockHoldingSaveTargetId;
  final Map<String, String> stockHoldingReplyDraftsByHoldingId;
  final Map<String, String> stockHoldingReplyTonesByHoldingId;
  final String? stockHoldingReplyError;
  final StockHoldingListFilter stockHoldingListFilter;
  final bool improvementDraftVisible;
  final String improvementDraftTitle;
  final String improvementDraftBody;
  final String improvementDraftCategory;
  final String? improvementDraftError;
  final String? editingImprovementPostId;
  final SaveStatus improvementSaveStatus;
  final String? improvementSaveFeedback;
  final String? improvementSaveTargetId;
  final String curiosityQuestionDraft;
  final Map<String, String> curiosityReplyDraftsByCardId;
  final String? curiosityError;
  final SaveStatus curiositySaveStatus;
  final String? curiositySaveFeedback;
  final String? curiositySaveTargetId;
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
    String? editingWishId,
    bool clearEditingWishId = false,
    SaveStatus? wishSaveStatus,
    String? wishSaveFeedback,
    bool clearWishSaveFeedback = false,
    String? wishSaveTargetId,
    bool clearWishSaveTargetId = false,
    bool? musicDraftVisible,
    String? musicDraftTitle,
    String? musicDraftArtist,
    String? musicDraftLink,
    String? musicDraftNote,
    String? musicDraftMood,
    MusicListFilter? musicListFilter,
    String? editingMusicNoteId,
    bool clearEditingMusicNoteId = false,
    SaveStatus? musicSaveStatus,
    String? musicSaveFeedback,
    bool clearMusicSaveFeedback = false,
    String? musicSaveTargetId,
    bool clearMusicSaveTargetId = false,
    String? selectedMeetingDateKey,
    String? selectedMeetingPlanDateKey,
    bool clearSelectedMeetingPlanDateKey = false,
    MeetingAvailability? meetingDraftAvailability,
    Set<MeetingTimeSlot>? meetingDraftTimeSlots,
    List<ScheduleTimeBlock>? meetingDraftTimeBlocks,
    String? meetingBlockStartDraft,
    String? meetingBlockEndDraft,
    String? meetingBlockTitleDraft,
    String? meetingDraftSharedMemo,
    bool? meetingDraftIsMeetingDay,
    String? meetingDraftMeetingTimeLabel,
    String? meetingDraftMeetingNote,
    String? meetingDraftMeetingPlanText,
    String? meetingPlanDraftText,
    String? meetingPlanItemDraft,
    int? editingMeetingPlanItemIndex,
    bool clearEditingMeetingPlanItemIndex = false,
    String? meetingDraftError,
    bool clearMeetingDraftError = false,
    SaveStatus? meetingSaveStatus,
    String? meetingSaveFeedback,
    bool clearMeetingSaveFeedback = false,
    String? meetingSaveTargetId,
    bool clearMeetingSaveTargetId = false,
    bool? placeDraftVisible,
    String? placeDraftName,
    String? placeDraftAddress,
    String? placeDraftNote,
    PlaceCategory? placeDraftCategory,
    MapApiProvider? placeDraftProvider,
    String? placeDraftProviderPlaceId,
    double? placeDraftLatitude,
    double? placeDraftLongitude,
    bool clearPlaceDraftCoordinates = false,
    String? placeDraftError,
    bool clearPlaceDraftError = false,
    String? editingPlaceId,
    bool clearEditingPlaceId = false,
    SaveStatus? placeSaveStatus,
    String? placeSaveFeedback,
    bool clearPlaceSaveFeedback = false,
    String? placeSaveTargetId,
    bool clearPlaceSaveTargetId = false,
    String? placeError,
    bool clearPlaceError = false,
    StockStoryTab? stockStoryTab,
    StockStoryListFilter? stockStoryListFilter,
    bool? stockStoryDraftVisible,
    String? stockStoryDraftName,
    String? stockStoryDraftReason,
    String? stockStoryDraftUpside,
    String? stockStoryDraftRisk,
    String? stockStoryDraftQuestion,
    String? stockStoryDraftError,
    bool clearStockStoryDraftError = false,
    SaveStatus? stockStorySaveStatus,
    String? stockStorySaveFeedback,
    bool clearStockStorySaveFeedback = false,
    String? stockStorySaveTargetId,
    bool clearStockStorySaveTargetId = false,
    Map<String, String>? stockStoryReplyDraftsByStoryId,
    Map<String, String>? stockStoryReplyTonesByStoryId,
    String? stockStoryReplyError,
    bool clearStockStoryReplyError = false,
    bool? stockHoldingDraftVisible,
    String? stockHoldingDraftName,
    String? stockHoldingDraftStatus,
    String? stockHoldingDraftWeightLabel,
    String? stockHoldingDraftReason,
    String? stockHoldingDraftWatchPoint,
    String? stockHoldingDraftConcern,
    String? stockHoldingDraftQuestion,
    String? stockHoldingDraftError,
    bool clearStockHoldingDraftError = false,
    String? editingStockHoldingId,
    bool clearEditingStockHoldingId = false,
    SaveStatus? stockHoldingSaveStatus,
    String? stockHoldingSaveFeedback,
    bool clearStockHoldingSaveFeedback = false,
    String? stockHoldingSaveTargetId,
    bool clearStockHoldingSaveTargetId = false,
    Map<String, String>? stockHoldingReplyDraftsByHoldingId,
    Map<String, String>? stockHoldingReplyTonesByHoldingId,
    String? stockHoldingReplyError,
    bool clearStockHoldingReplyError = false,
    StockHoldingListFilter? stockHoldingListFilter,
    bool? improvementDraftVisible,
    String? improvementDraftTitle,
    String? improvementDraftBody,
    String? improvementDraftCategory,
    String? improvementDraftError,
    bool clearImprovementDraftError = false,
    String? editingImprovementPostId,
    bool clearEditingImprovementPostId = false,
    SaveStatus? improvementSaveStatus,
    String? improvementSaveFeedback,
    bool clearImprovementSaveFeedback = false,
    String? improvementSaveTargetId,
    bool clearImprovementSaveTargetId = false,
    String? curiosityQuestionDraft,
    Map<String, String>? curiosityReplyDraftsByCardId,
    String? curiosityError,
    bool clearCuriosityError = false,
    SaveStatus? curiositySaveStatus,
    String? curiositySaveFeedback,
    bool clearCuriositySaveFeedback = false,
    String? curiositySaveTargetId,
    bool clearCuriositySaveTargetId = false,
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
      editingWishId: clearEditingWishId
          ? null
          : editingWishId ?? this.editingWishId,
      wishSaveStatus: wishSaveStatus ?? this.wishSaveStatus,
      wishSaveFeedback: clearWishSaveFeedback
          ? null
          : wishSaveFeedback ?? this.wishSaveFeedback,
      wishSaveTargetId: clearWishSaveTargetId
          ? null
          : wishSaveTargetId ?? this.wishSaveTargetId,
      musicDraftVisible: musicDraftVisible ?? this.musicDraftVisible,
      musicDraftTitle: musicDraftTitle ?? this.musicDraftTitle,
      musicDraftArtist: musicDraftArtist ?? this.musicDraftArtist,
      musicDraftLink: musicDraftLink ?? this.musicDraftLink,
      musicDraftNote: musicDraftNote ?? this.musicDraftNote,
      musicDraftMood: musicDraftMood ?? this.musicDraftMood,
      musicListFilter: musicListFilter ?? this.musicListFilter,
      editingMusicNoteId: clearEditingMusicNoteId
          ? null
          : editingMusicNoteId ?? this.editingMusicNoteId,
      musicSaveStatus: musicSaveStatus ?? this.musicSaveStatus,
      musicSaveFeedback: clearMusicSaveFeedback
          ? null
          : musicSaveFeedback ?? this.musicSaveFeedback,
      musicSaveTargetId: clearMusicSaveTargetId
          ? null
          : musicSaveTargetId ?? this.musicSaveTargetId,
      selectedMeetingDateKey:
          selectedMeetingDateKey ?? this.selectedMeetingDateKey,
      selectedMeetingPlanDateKey: clearSelectedMeetingPlanDateKey
          ? null
          : selectedMeetingPlanDateKey ?? this.selectedMeetingPlanDateKey,
      meetingDraftAvailability:
          meetingDraftAvailability ?? this.meetingDraftAvailability,
      meetingDraftTimeSlots:
          meetingDraftTimeSlots ?? this.meetingDraftTimeSlots,
      meetingDraftTimeBlocks:
          meetingDraftTimeBlocks ?? this.meetingDraftTimeBlocks,
      meetingBlockStartDraft:
          meetingBlockStartDraft ?? this.meetingBlockStartDraft,
      meetingBlockEndDraft: meetingBlockEndDraft ?? this.meetingBlockEndDraft,
      meetingBlockTitleDraft:
          meetingBlockTitleDraft ?? this.meetingBlockTitleDraft,
      meetingDraftSharedMemo:
          meetingDraftSharedMemo ?? this.meetingDraftSharedMemo,
      meetingDraftIsMeetingDay:
          meetingDraftIsMeetingDay ?? this.meetingDraftIsMeetingDay,
      meetingDraftMeetingTimeLabel:
          meetingDraftMeetingTimeLabel ?? this.meetingDraftMeetingTimeLabel,
      meetingDraftMeetingNote:
          meetingDraftMeetingNote ?? this.meetingDraftMeetingNote,
      meetingDraftMeetingPlanText:
          meetingDraftMeetingPlanText ?? this.meetingDraftMeetingPlanText,
      meetingPlanDraftText: meetingPlanDraftText ?? this.meetingPlanDraftText,
      meetingPlanItemDraft: meetingPlanItemDraft ?? this.meetingPlanItemDraft,
      editingMeetingPlanItemIndex: clearEditingMeetingPlanItemIndex
          ? null
          : editingMeetingPlanItemIndex ?? this.editingMeetingPlanItemIndex,
      meetingDraftError: clearMeetingDraftError
          ? null
          : meetingDraftError ?? this.meetingDraftError,
      meetingSaveStatus: meetingSaveStatus ?? this.meetingSaveStatus,
      meetingSaveFeedback: clearMeetingSaveFeedback
          ? null
          : meetingSaveFeedback ?? this.meetingSaveFeedback,
      meetingSaveTargetId: clearMeetingSaveTargetId
          ? null
          : meetingSaveTargetId ?? this.meetingSaveTargetId,
      placeDraftVisible: placeDraftVisible ?? this.placeDraftVisible,
      placeDraftName: placeDraftName ?? this.placeDraftName,
      placeDraftAddress: placeDraftAddress ?? this.placeDraftAddress,
      placeDraftNote: placeDraftNote ?? this.placeDraftNote,
      placeDraftCategory: placeDraftCategory ?? this.placeDraftCategory,
      placeDraftProvider: placeDraftProvider ?? this.placeDraftProvider,
      placeDraftProviderPlaceId:
          placeDraftProviderPlaceId ?? this.placeDraftProviderPlaceId,
      placeDraftLatitude: clearPlaceDraftCoordinates
          ? null
          : placeDraftLatitude ?? this.placeDraftLatitude,
      placeDraftLongitude: clearPlaceDraftCoordinates
          ? null
          : placeDraftLongitude ?? this.placeDraftLongitude,
      placeDraftError: clearPlaceDraftError
          ? null
          : placeDraftError ?? this.placeDraftError,
      editingPlaceId: clearEditingPlaceId
          ? null
          : editingPlaceId ?? this.editingPlaceId,
      placeSaveStatus: placeSaveStatus ?? this.placeSaveStatus,
      placeSaveFeedback: clearPlaceSaveFeedback
          ? null
          : placeSaveFeedback ?? this.placeSaveFeedback,
      placeSaveTargetId: clearPlaceSaveTargetId
          ? null
          : placeSaveTargetId ?? this.placeSaveTargetId,
      placeError: clearPlaceError ? null : placeError ?? this.placeError,
      stockStoryTab: stockStoryTab ?? this.stockStoryTab,
      stockStoryListFilter: stockStoryListFilter ?? this.stockStoryListFilter,
      stockStoryDraftVisible:
          stockStoryDraftVisible ?? this.stockStoryDraftVisible,
      stockStoryDraftName: stockStoryDraftName ?? this.stockStoryDraftName,
      stockStoryDraftReason:
          stockStoryDraftReason ?? this.stockStoryDraftReason,
      stockStoryDraftUpside:
          stockStoryDraftUpside ?? this.stockStoryDraftUpside,
      stockStoryDraftRisk: stockStoryDraftRisk ?? this.stockStoryDraftRisk,
      stockStoryDraftQuestion:
          stockStoryDraftQuestion ?? this.stockStoryDraftQuestion,
      stockStoryDraftError: clearStockStoryDraftError
          ? null
          : stockStoryDraftError ?? this.stockStoryDraftError,
      stockStorySaveStatus: stockStorySaveStatus ?? this.stockStorySaveStatus,
      stockStorySaveFeedback: clearStockStorySaveFeedback
          ? null
          : stockStorySaveFeedback ?? this.stockStorySaveFeedback,
      stockStorySaveTargetId: clearStockStorySaveTargetId
          ? null
          : stockStorySaveTargetId ?? this.stockStorySaveTargetId,
      stockStoryReplyDraftsByStoryId:
          stockStoryReplyDraftsByStoryId ?? this.stockStoryReplyDraftsByStoryId,
      stockStoryReplyTonesByStoryId:
          stockStoryReplyTonesByStoryId ?? this.stockStoryReplyTonesByStoryId,
      stockStoryReplyError: clearStockStoryReplyError
          ? null
          : stockStoryReplyError ?? this.stockStoryReplyError,
      stockHoldingDraftVisible:
          stockHoldingDraftVisible ?? this.stockHoldingDraftVisible,
      stockHoldingDraftName:
          stockHoldingDraftName ?? this.stockHoldingDraftName,
      stockHoldingDraftStatus:
          stockHoldingDraftStatus ?? this.stockHoldingDraftStatus,
      stockHoldingDraftWeightLabel:
          stockHoldingDraftWeightLabel ?? this.stockHoldingDraftWeightLabel,
      stockHoldingDraftReason:
          stockHoldingDraftReason ?? this.stockHoldingDraftReason,
      stockHoldingDraftWatchPoint:
          stockHoldingDraftWatchPoint ?? this.stockHoldingDraftWatchPoint,
      stockHoldingDraftConcern:
          stockHoldingDraftConcern ?? this.stockHoldingDraftConcern,
      stockHoldingDraftQuestion:
          stockHoldingDraftQuestion ?? this.stockHoldingDraftQuestion,
      stockHoldingDraftError: clearStockHoldingDraftError
          ? null
          : stockHoldingDraftError ?? this.stockHoldingDraftError,
      editingStockHoldingId: clearEditingStockHoldingId
          ? null
          : editingStockHoldingId ?? this.editingStockHoldingId,
      stockHoldingSaveStatus:
          stockHoldingSaveStatus ?? this.stockHoldingSaveStatus,
      stockHoldingSaveFeedback: clearStockHoldingSaveFeedback
          ? null
          : stockHoldingSaveFeedback ?? this.stockHoldingSaveFeedback,
      stockHoldingSaveTargetId: clearStockHoldingSaveTargetId
          ? null
          : stockHoldingSaveTargetId ?? this.stockHoldingSaveTargetId,
      stockHoldingReplyDraftsByHoldingId:
          stockHoldingReplyDraftsByHoldingId ??
          this.stockHoldingReplyDraftsByHoldingId,
      stockHoldingReplyTonesByHoldingId:
          stockHoldingReplyTonesByHoldingId ??
          this.stockHoldingReplyTonesByHoldingId,
      stockHoldingReplyError: clearStockHoldingReplyError
          ? null
          : stockHoldingReplyError ?? this.stockHoldingReplyError,
      stockHoldingListFilter:
          stockHoldingListFilter ?? this.stockHoldingListFilter,
      improvementDraftVisible:
          improvementDraftVisible ?? this.improvementDraftVisible,
      improvementDraftTitle:
          improvementDraftTitle ?? this.improvementDraftTitle,
      improvementDraftBody: improvementDraftBody ?? this.improvementDraftBody,
      improvementDraftCategory:
          improvementDraftCategory ?? this.improvementDraftCategory,
      improvementDraftError: clearImprovementDraftError
          ? null
          : improvementDraftError ?? this.improvementDraftError,
      editingImprovementPostId: clearEditingImprovementPostId
          ? null
          : editingImprovementPostId ?? this.editingImprovementPostId,
      improvementSaveStatus:
          improvementSaveStatus ?? this.improvementSaveStatus,
      improvementSaveFeedback: clearImprovementSaveFeedback
          ? null
          : improvementSaveFeedback ?? this.improvementSaveFeedback,
      improvementSaveTargetId: clearImprovementSaveTargetId
          ? null
          : improvementSaveTargetId ?? this.improvementSaveTargetId,
      curiosityQuestionDraft:
          curiosityQuestionDraft ?? this.curiosityQuestionDraft,
      curiosityReplyDraftsByCardId:
          curiosityReplyDraftsByCardId ?? this.curiosityReplyDraftsByCardId,
      curiosityError: clearCuriosityError
          ? null
          : curiosityError ?? this.curiosityError,
      curiositySaveStatus: curiositySaveStatus ?? this.curiositySaveStatus,
      curiositySaveFeedback: clearCuriositySaveFeedback
          ? null
          : curiositySaveFeedback ?? this.curiositySaveFeedback,
      curiositySaveTargetId: clearCuriositySaveTargetId
          ? null
          : curiositySaveTargetId ?? this.curiositySaveTargetId,
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

enum _FailedPersistenceAction { save, delete }

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

  DailyQuestion _todayQuestion;
  DailyQuestionProgress _dailyProgress;
  final List<DailyQuestion> questions;
  final List<BalanceQuestion> balanceQuestions;

  final Map<String, Answer> _myAnswersByQuestionId = {};
  final Map<String, Answer> _partnerAnswersByQuestionId = {};
  final Set<String> _persistedMyAnswerQuestionIds = {};
  final Map<String, AnswerComment> _answerCommentsByKey = {};
  final Map<String, String> _balanceSelections = {};
  final Map<String, String> _partnerBalanceSelections = {};
  final Map<String, String> _balanceReasons = {};
  final Map<String, String> _partnerBalanceReasons = {};
  final Map<String, DateTime> _balanceResultRevealedAt = {};
  final List<ProfileCardData> _profileCards = [];
  final List<WishItem> _wishes = [];
  final List<MusicNote> _musicNotes = [];
  final List<ScheduleEntry> _scheduleEntries = [];
  final List<MeetingPlan> _meetingPlans = [];
  final List<SharedPlace> _sharedPlaces = [];
  final List<CuriosityCard> _curiosityCards = [];
  final List<StockStory> _stockStories = [];
  final List<StockHolding> _stockHoldings = [];
  final List<ImprovementPost> _improvementPosts = [];
  final Map<String, Future<void>> _sharedPlaceSaveChains = {};
  final Map<String, int> _sharedPlaceSaveVersions = {};
  Answer? _lastFailedAnswer;
  AnswerComment? _lastFailedAnswerComment;
  ScheduleEntry? _lastFailedScheduleEntry;
  String _lastFailedScheduleEntrySuccessFeedback = '일정을 저장했어요.';
  MeetingPlan? _lastFailedMeetingPlan;
  String _lastFailedMeetingPlanSuccessFeedback = '만남 계획을 저장했어요.';
  SharedPlace? _lastFailedSharedPlace;
  bool _lastFailedSharedPlaceWasMeetingLinks = false;
  CuriosityCard? _lastFailedCuriosityCard;
  ImprovementPost? _lastFailedImprovementPost;
  WishItem? _lastFailedWish;
  _FailedPersistenceAction? _lastFailedWishAction;
  MusicNote? _lastFailedMusicNote;
  _FailedPersistenceAction? _lastFailedMusicNoteAction;
  StockStory? _lastFailedStockStory;
  _FailedPersistenceAction? _lastFailedStockStoryAction;
  StockHolding? _lastFailedStockHolding;
  _FailedPersistenceAction? _lastFailedStockHoldingAction;

  AlagagiState get state => _state;

  bool canApplySession(AlagagiSession session) {
    return !_usesDemoData && _spaceId == session.spaceId;
  }

  void refreshFromSession(AlagagiSession session, {String? todayDateKey}) {
    if (!canApplySession(session)) {
      return;
    }
    _dailyProgress = _resolveDailyQuestionProgress(
      questions,
      session.data.dailyProgress,
      todayDateKey: todayDateKey,
    );
    _todayQuestion = _questionForProgress(questions, _dailyProgress);
    final personalization = _normalizeBrandPersonalization(
      session.data.personalization,
    );
    _state = _state.copyWith(
      me: session.me,
      partner: session.partner,
      personalization: personalization,
      personalizationDraft: personalization,
    );
    _applySessionData(session.data);
    if (_state.route == AlagagiRoute.meetingPlans) {
      final dateKey = selectedMeetingPlanDateKey;
      _state = _state.copyWith(
        selectedMeetingPlanDateKey: dateKey,
        meetingPlanDraftText: _meetingPlanTextFromItems(
          meetingPlanItemsFor(dateKey),
        ),
        meetingPlanItemDraft: '',
        clearEditingMeetingPlanItemIndex: true,
      );
    } else if (_state.route == AlagagiRoute.meetings) {
      _state = _state.copyWith(
        meetingDraftMeetingPlanText: _meetingPlanTextFromItems(
          meetingPlanItemsFor(selectedMeetingDateKey),
        ),
      );
    }
    _persistDailyQuestionProgressIfChanged(session.data.dailyProgress);
    notifyListeners();
  }

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

    final hasNewMusic = unreadCountForFeature(UnreadActivityFeature.music) > 0;
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
    return unreadCountForFeature(UnreadActivityFeature.music) > 0;
  }

  List<UnreadActivity> get unreadActivities {
    final activities = <UnreadActivity>[];
    final partnerName = _state.partner.nickname;
    final partnerCard = _profileCards.cast<ProfileCardData?>().firstWhere(
      (card) => card?.profile.id == _state.partner.id,
      orElse: () => null,
    );
    for (final slot in partnerCard?.slots ?? const <ProfileSlot>[]) {
      if (slot.hidden || slot.value == null || slot.value!.trim().isEmpty) {
        continue;
      }
      _addUnreadActivity(
        activities,
        feature: UnreadActivityFeature.profileCard,
        id: 'profile-${slot.id}',
        title: '소개 카드에 새 답이 있어요',
        description: '$partnerName님이 "${slot.label}"에 답했어요.',
        updatedAt: slot.updatedAt,
        actorProfileId: slot.updatedByProfileId ?? _state.partner.id,
      );
    }
    for (final wish in _wishes) {
      final isPartnerWish = wish.createdByProfileId == _state.partner.id;
      final partnerLikedMine =
          wish.createdByProfileId == _state.me.id &&
          wish.likedByProfileIds.contains(_state.partner.id);
      if (!isPartnerWish && !partnerLikedMine) {
        continue;
      }
      final description = partnerLikedMine
          ? '"${wish.title}"에 $partnerName님도 관심을 표시했어요.'
          : wish.isMutual
          ? '"${wish.title}"가 같이 하고 싶은 일로 열렸어요.'
          : '$partnerName님이 "${wish.title}"를 담았어요.';
      _addUnreadActivity(
        activities,
        feature: UnreadActivityFeature.wishlist,
        id: 'wish-${wish.id}',
        title: '언젠가 같이 할 일이 생겼어요',
        description: description,
        updatedAt: wish.updatedAt,
        actorProfileId: wish.lastChangedByProfileId,
      );
    }
    for (final entry in _scheduleEntries) {
      _addUnreadActivity(
        activities,
        feature: UnreadActivityFeature.meetings,
        id: 'meeting-${entry.id}',
        title: '약속 일정이 업데이트됐어요',
        description:
            '$partnerName님이 ${_compactDateLabel(entry.dateKey)} 일정을 남겼어요.',
        updatedAt: entry.updatedAt,
        actorProfileId: entry.profileId,
      );
    }
    for (final plan in _meetingPlans) {
      _addUnreadActivity(
        activities,
        feature: UnreadActivityFeature.meetings,
        id: 'meeting-plan-${plan.dateKey}',
        title: '만남 계획이 업데이트됐어요',
        description:
            '$partnerName님이 ${_compactDateLabel(plan.dateKey)} 계획을 정리했어요.',
        updatedAt: plan.updatedAt,
        actorProfileId: plan.updatedByProfileId,
      );
    }
    for (final place in _sharedPlaces) {
      _addUnreadActivity(
        activities,
        feature: UnreadActivityFeature.places,
        id: 'place-${place.id}',
        title: '새 장소 소식이 있어요',
        description: '$partnerName님이 "${place.name}"를 업데이트했어요.',
        updatedAt: place.updatedAt,
        actorProfileId: place.lastChangedByProfileId,
      );
    }
    for (final card in _curiosityCards) {
      final description = card.hasReply
          ? '$partnerName님이 궁금함에 답했어요.'
          : '$partnerName님이 궁금한 걸 남겼어요.';
      _addUnreadActivity(
        activities,
        feature: UnreadActivityFeature.curiosity,
        id: 'curiosity-${card.id}',
        title: '궁금함 한 장이 업데이트됐어요',
        description: description,
        updatedAt: card.updatedAt,
        actorProfileId: card.lastChangedByProfileId,
      );
    }
    for (final story in _stockStories) {
      final description =
          story.hasReply && story.repliedByProfileId == _state.partner.id
          ? '$partnerName님이 "${story.name}" 이야기에 답했어요.'
          : '$partnerName님이 "${story.name}" 이야기를 남겼어요.';
      _addUnreadActivity(
        activities,
        feature: UnreadActivityFeature.stocks,
        id: 'stock-story-${story.id}',
        title: '주식 이야기가 업데이트됐어요',
        description: description,
        updatedAt: story.updatedAt,
        actorProfileId: story.lastChangedByProfileId,
      );
    }
    for (final holding in _stockHoldings) {
      final description =
          holding.hasReply && holding.repliedByProfileId == _state.partner.id
          ? '$partnerName님이 "${holding.name}" 보유 종목에 답했어요.'
          : '$partnerName님이 "${holding.name}" 보유 종목을 남겼어요.';
      _addUnreadActivity(
        activities,
        feature: UnreadActivityFeature.stocks,
        id: 'stock-holding-${holding.id}',
        title: '보유 종목 이야기가 업데이트됐어요',
        description: description,
        updatedAt: holding.updatedAt,
        actorProfileId: holding.lastChangedByProfileId,
      );
    }
    for (final note in _musicNotes) {
      _addUnreadActivity(
        activities,
        feature: UnreadActivityFeature.music,
        id: 'music-${note.id}',
        title: '새 음악 노트가 있어요',
        description: '$partnerName님이 "${note.title}"를 남겼어요.',
        updatedAt: note.updatedAt,
        actorProfileId: note.createdByProfileId,
      );
    }
    for (final post in _improvementPosts) {
      _addUnreadActivity(
        activities,
        feature: UnreadActivityFeature.improvements,
        id: 'improvement-${post.id}',
        title: '건의함에 새 글이 있어요',
        description: '$partnerName님이 "${post.title}"을 남겼어요.',
        updatedAt: post.updatedAt,
        actorProfileId: post.createdByProfileId,
      );
    }
    activities.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return List<UnreadActivity>.unmodifiable(activities);
  }

  int get totalUnreadActivityCount => unreadActivities.length;

  int unreadCountForFeature(UnreadActivityFeature feature) {
    return unreadActivities
        .where((activity) => activity.feature == feature)
        .length;
  }

  void _addUnreadActivity(
    List<UnreadActivity> activities, {
    required UnreadActivityFeature feature,
    required String id,
    required String title,
    required String description,
    required DateTime? updatedAt,
    required String actorProfileId,
  }) {
    if (updatedAt == null) {
      return;
    }
    if (!_isUnreadActivity(feature, updatedAt, actorProfileId)) {
      return;
    }
    activities.add(
      UnreadActivity(
        id: id,
        feature: feature,
        title: title,
        description: description,
        updatedAt: updatedAt,
        route: feature.route,
      ),
    );
  }

  bool _isUnreadActivity(
    UnreadActivityFeature feature,
    DateTime updatedAt,
    String actorProfileId,
  ) {
    final spaceId = _spaceId;
    if (spaceId == null || actorProfileId != _state.partner.id) {
      return false;
    }
    final lastSeen = _musicNoteSeenStore.readLastSeenAt(
      spaceId,
      _state.me.id,
      feature,
    );
    return lastSeen == null || updatedAt.isAfter(lastSeen);
  }

  String _compactDateLabel(String dateKey) {
    final date = DateTime.tryParse(dateKey);
    if (date == null) {
      return dateKey;
    }
    return '${date.month}/${date.day}';
  }

  void markFeatureSeen(UnreadActivityFeature feature) {
    _markFeatureSeen(feature);
    notifyListeners();
  }

  void markAllUnreadActivitiesSeen() {
    for (final feature in UnreadActivityFeature.values) {
      _markFeatureSeen(feature);
    }
    notifyListeners();
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
          final profileId = card.profile.isMe
              ? _state.me.id
              : _state.partner.id;
          return card.copyWith(
            profile: card.profile.isMe ? _state.me : _state.partner,
            slots: _profileSlotsWithValues(card.slots, profileId),
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
            listenedByProfileIds: _mapSeedProfileIds(note.listenedByProfileIds),
          );
        }),
      );
    _sortMusicNotesByUpdatedAt();
    _scheduleEntries
      ..clear()
      ..addAll(
        seedScheduleEntries.map((entry) {
          return ScheduleEntry(
            dateKey: entry.dateKey,
            profileId: _mapSeedProfileId(entry.profileId),
            availability: entry.availability,
            timeSlots: entry.timeSlots,
            timeBlocks: entry.timeBlocks,
            sharedMemo: entry.sharedMemo,
            isMeetingDay: entry.isMeetingDay,
            meetingTimeLabel: entry.meetingTimeLabel,
            meetingNote: entry.meetingNote,
            updatedAt: entry.updatedAt,
          );
        }),
      );
    _sortScheduleEntriesByDate();
    _meetingPlans.clear();
    _sharedPlaces
      ..clear()
      ..addAll(
        seedSharedPlaces.map((place) {
          return SharedPlace(
            id: place.id,
            name: place.name,
            address: place.address,
            category: place.category,
            provider: place.provider,
            providerPlaceId: place.providerPlaceId,
            latitude: place.latitude,
            longitude: place.longitude,
            note: place.note,
            createdByProfileId: _mapSeedProfileId(place.createdByProfileId),
            interestedByProfileIds: _mapSeedProfileIds(
              place.interestedByProfileIds,
            ),
            linkedDateKey: place.linkedDateKey,
            meetingPlanLinks: place.meetingPlanLinks,
            updatedAt: place.updatedAt,
          );
        }),
      );
    _sortSharedPlacesByUpdatedAt();
    _curiosityCards
      ..clear()
      ..addAll(
        seedCuriosityCards.map((card) {
          return CuriosityCard(
            id: card.id,
            fromProfileId: _mapSeedProfileId(card.fromProfileId),
            toProfileId: _mapSeedProfileId(card.toProfileId),
            question: card.question,
            createdLabel: card.createdLabel,
            reply: card.reply,
            repliedLabel: card.repliedLabel,
            updatedAt: card.updatedAt,
          );
        }),
      );
    _sortCuriosityCardsByUpdatedAt();
    _stockStories
      ..clear()
      ..addAll(
        seedStockStories.map((story) {
          return StockStory(
            id: story.id,
            name: story.name,
            reason: story.reason,
            upside: story.upside,
            risk: story.risk,
            question: story.question,
            createdByProfileId: _mapSeedProfileId(story.createdByProfileId),
            createdLabel: story.createdLabel,
            replyTone: story.replyTone,
            reply: story.reply,
            repliedByProfileId: story.repliedByProfileId == null
                ? null
                : _mapSeedProfileId(story.repliedByProfileId!),
            repliedLabel: story.repliedLabel,
            updatedAt: story.updatedAt,
          );
        }),
      );
    _sortStockStoriesByUpdatedAt();
    _stockHoldings
      ..clear()
      ..addAll(
        seedStockHoldings.map((holding) {
          return StockHolding(
            id: holding.id,
            name: holding.name,
            status: holding.status,
            weightLabel: holding.weightLabel,
            reason: holding.reason,
            watchPoint: holding.watchPoint,
            concern: holding.concern,
            question: holding.question,
            createdByProfileId: _mapSeedProfileId(holding.createdByProfileId),
            createdLabel: holding.createdLabel,
            replyTone: holding.replyTone,
            reply: holding.reply,
            repliedByProfileId: holding.repliedByProfileId == null
                ? null
                : _mapSeedProfileId(holding.repliedByProfileId!),
            repliedLabel: holding.repliedLabel,
            updatedAt: holding.updatedAt,
          );
        }),
      );
    _sortStockHoldingsByUpdatedAt();
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
    _balanceReasons.clear();
    _partnerBalanceReasons.clear();
    _balanceResultRevealedAt.clear();
    for (final selection in data.balanceSelections) {
      if (selection.profileId == _state.me.id) {
        _balanceSelections[selection.questionId] = selection.optionId;
        final reason = selection.reason;
        if (reason != null && reason.isNotEmpty) {
          _balanceReasons[selection.questionId] = reason;
        }
        final resultRevealedAt = selection.resultRevealedAt;
        if (resultRevealedAt != null) {
          _balanceResultRevealedAt[selection.questionId] = resultRevealedAt;
        }
      } else if (selection.profileId == _state.partner.id) {
        _partnerBalanceSelections[selection.questionId] = selection.optionId;
        final reason = selection.reason;
        if (reason != null && reason.isNotEmpty) {
          _partnerBalanceReasons[selection.questionId] = reason;
        }
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
      final slots = [...card.slots];
      final slotIndex = slots.indexWhere((slot) => slot.id == value.slot.id);
      if (slotIndex == -1) {
        if (value.slot.custom) {
          slots.add(_profileSlotFromPersisted(value.slot, value.profileId));
        }
      } else {
        slots[slotIndex] = _profileSlotFromPersisted(
          value.slot,
          value.profileId,
          base: slots[slotIndex],
        );
      }
      _profileCards[cardIndex] = card.copyWith(slots: slots);
    }

    _wishes
      ..clear()
      ..addAll(data.wishes);
    _musicNotes
      ..clear()
      ..addAll(data.musicNotes);
    _sortMusicNotesByUpdatedAt();
    _scheduleEntries
      ..clear()
      ..addAll(data.scheduleEntries);
    _sortScheduleEntriesByDate();
    _meetingPlans
      ..clear()
      ..addAll(data.meetingPlans);
    _sortMeetingPlansByDate();
    _sharedPlaces
      ..clear()
      ..addAll(data.sharedPlaces);
    _sortSharedPlacesByUpdatedAt();
    _curiosityCards
      ..clear()
      ..addAll(data.curiosityCards);
    _sortCuriosityCardsByUpdatedAt();
    _stockStories
      ..clear()
      ..addAll(data.stockStories);
    _sortStockStoriesByUpdatedAt();
    _stockHoldings
      ..clear()
      ..addAll(data.stockHoldings);
    _sortStockHoldingsByUpdatedAt();
    _improvementPosts
      ..clear()
      ..addAll(data.improvementPosts);
    _sortImprovementPostsByUpdatedAt();
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

  static List<String> _parseMeetingPlanItems(String value) {
    final items = value
        .split(RegExp(r'[\n,]'))
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
    return List<String>.unmodifiable(items);
  }

  static String _meetingPlanTextFromItems(List<String> items) {
    return items
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .join('\n');
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

  List<ProfileSlot> _profileSlotsWithValues(
    Iterable<ProfileSlot> values,
    String profileId,
  ) {
    final valuesById = {for (final slot in values) slot.id: slot};
    final catalogIds = _profileSlotCatalog().map((slot) => slot.id).toSet();
    final catalogSlots = _profileSlotCatalog().map((catalogSlot) {
      final valueSlot = valuesById[catalogSlot.id];
      if (valueSlot == null) {
        return catalogSlot;
      }
      return _profileSlotFromPersisted(valueSlot, profileId, base: catalogSlot);
    }).toList();
    final customSlots = values
        .where((slot) => slot.custom && !catalogIds.contains(slot.id))
        .map((slot) => _profileSlotFromPersisted(slot, profileId))
        .toList();
    return [...catalogSlots, ...customSlots];
  }

  ProfileSlot _profileSlotFromPersisted(
    ProfileSlot persisted,
    String profileId, {
    ProfileSlot? base,
  }) {
    final custom = persisted.custom;
    final template = base ?? persisted;
    return ProfileSlot(
      id: persisted.id,
      label: custom ? persisted.label : template.label,
      icon: custom ? persisted.icon : template.icon,
      category: custom ? persisted.category : template.category,
      inputHint: custom ? persisted.inputHint : template.inputHint,
      value: persisted.hidden ? null : persisted.value,
      locked: false,
      unlockHint: '',
      skipped: persisted.hidden ? false : persisted.skipped,
      hidden: persisted.hidden,
      custom: custom,
      updatedAt: persisted.updatedAt,
      updatedByProfileId: persisted.updatedByProfileId ?? profileId,
    );
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

  void _deletePersistedBalanceSelection(String questionId) {
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository == null || spaceId == null) {
      return;
    }
    unawaited(
      repository
          .deleteBalanceSelection(spaceId, questionId, _state.me.id)
          .catchError((_) {}),
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

  void _persistDeletedProfileSlot(String slotId) {
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository == null || spaceId == null) {
      return;
    }
    unawaited(
      repository
          .deleteProfileSlot(spaceId, _state.me.id, slotId)
          .catchError((_) {}),
    );
  }

  void _persistWish(WishItem wish) {
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository == null || spaceId == null) {
      _lastFailedWish = null;
      _lastFailedWishAction = null;
      _state = _state.copyWith(
        wishSaveStatus: SaveStatus.saved,
        wishSaveFeedback: '위시를 저장했어요.',
        wishSaveTargetId: wish.id,
        clearWishDraftError: true,
      );
      notifyListeners();
      return;
    }
    unawaited(
      repository
          .saveWish(spaceId, wish)
          .then<void>((_) {
            _lastFailedWish = null;
            _lastFailedWishAction = null;
            _state = _state.copyWith(
              wishSaveStatus: SaveStatus.saved,
              wishSaveFeedback: '위시를 저장했어요.',
              wishSaveTargetId: wish.id,
              clearWishDraftError: true,
            );
            notifyListeners();
          })
          .catchError((Object _) {
            _lastFailedWish = wish;
            _lastFailedWishAction = _FailedPersistenceAction.save;
            _state = _state.copyWith(
              wishDraftError: '위시를 저장하지 못했어요. 다시 시도해 주세요.',
              wishSaveStatus: SaveStatus.failed,
              wishSaveTargetId: wish.id,
              clearWishSaveFeedback: true,
            );
            notifyListeners();
          }),
    );
  }

  void _deletePersistedWish(WishItem wish, int previousIndex) {
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository == null || spaceId == null) {
      _lastFailedWish = null;
      _lastFailedWishAction = null;
      _state = _state.copyWith(
        wishSaveStatus: SaveStatus.saved,
        wishSaveFeedback: '위시를 삭제했어요.',
        wishSaveTargetId: wish.id,
        clearWishDraftError: true,
      );
      notifyListeners();
      return;
    }
    unawaited(
      repository
          .deleteWish(spaceId, wish.id)
          .then<void>((_) {
            _lastFailedWish = null;
            _lastFailedWishAction = null;
            _state = _state.copyWith(
              wishSaveStatus: SaveStatus.saved,
              wishSaveFeedback: '위시를 삭제했어요.',
              wishSaveTargetId: wish.id,
              clearWishDraftError: true,
            );
            notifyListeners();
          })
          .catchError((Object _) {
            final boundedIndex = previousIndex.clamp(0, _wishes.length).toInt();
            if (!_wishes.any((candidate) => candidate.id == wish.id)) {
              _wishes.insert(boundedIndex, wish);
            }
            _lastFailedWish = wish;
            _lastFailedWishAction = _FailedPersistenceAction.delete;
            _state = _state.copyWith(
              wishDraftError: '위시를 삭제하지 못했어요. 다시 시도해 주세요.',
              wishSaveStatus: SaveStatus.failed,
              wishSaveTargetId: wish.id,
              clearWishSaveFeedback: true,
            );
            notifyListeners();
          }),
    );
  }

  void _persistMusicNote(MusicNote note) {
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository == null || spaceId == null) {
      _lastFailedMusicNote = null;
      _lastFailedMusicNoteAction = null;
      _state = _state.copyWith(
        musicSaveStatus: SaveStatus.saved,
        musicSaveFeedback: '음악 노트를 저장했어요.',
        musicSaveTargetId: note.id,
        clearMusicDraftError: true,
      );
      notifyListeners();
      return;
    }
    unawaited(
      repository
          .saveMusicNote(spaceId, note)
          .then<void>((_) {
            _lastFailedMusicNote = null;
            _lastFailedMusicNoteAction = null;
            _state = _state.copyWith(
              musicSaveStatus: SaveStatus.saved,
              musicSaveFeedback: '음악 노트를 저장했어요.',
              musicSaveTargetId: note.id,
              clearMusicDraftError: true,
            );
            notifyListeners();
          })
          .catchError((Object _) {
            _lastFailedMusicNote = note;
            _lastFailedMusicNoteAction = _FailedPersistenceAction.save;
            _state = _state.copyWith(
              musicDraftError: '음악 노트를 저장하지 못했어요. 다시 시도해 주세요.',
              musicSaveStatus: SaveStatus.failed,
              musicSaveTargetId: note.id,
              clearMusicSaveFeedback: true,
            );
            notifyListeners();
          }),
    );
  }

  void _deletePersistedMusicNote(MusicNote note, int previousIndex) {
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository == null || spaceId == null) {
      _lastFailedMusicNote = null;
      _lastFailedMusicNoteAction = null;
      _state = _state.copyWith(
        musicSaveStatus: SaveStatus.saved,
        musicSaveFeedback: '음악 노트를 삭제했어요.',
        musicSaveTargetId: note.id,
        clearMusicDraftError: true,
      );
      notifyListeners();
      return;
    }
    unawaited(
      repository
          .deleteMusicNote(spaceId, note.id)
          .then<void>((_) {
            _lastFailedMusicNote = null;
            _lastFailedMusicNoteAction = null;
            _state = _state.copyWith(
              musicSaveStatus: SaveStatus.saved,
              musicSaveFeedback: '음악 노트를 삭제했어요.',
              musicSaveTargetId: note.id,
              clearMusicDraftError: true,
            );
            notifyListeners();
          })
          .catchError((Object _) {
            final boundedIndex = previousIndex
                .clamp(0, _musicNotes.length)
                .toInt();
            if (!_musicNotes.any((candidate) => candidate.id == note.id)) {
              _musicNotes.insert(boundedIndex, note);
              _sortMusicNotesByUpdatedAt();
            }
            _lastFailedMusicNote = note;
            _lastFailedMusicNoteAction = _FailedPersistenceAction.delete;
            _state = _state.copyWith(
              musicDraftError: '음악 노트를 삭제하지 못했어요. 다시 시도해 주세요.',
              musicSaveStatus: SaveStatus.failed,
              musicSaveTargetId: note.id,
              clearMusicSaveFeedback: true,
            );
            notifyListeners();
          }),
    );
  }

  void _persistMusicNoteListenState(MusicNote note) {
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository == null || spaceId == null) {
      return;
    }
    unawaited(
      repository.saveMusicNoteListenState(spaceId, note).catchError((_) {}),
    );
  }

  void _persistScheduleEntry(
    ScheduleEntry entry, {
    String successFeedback = '일정을 저장했어요.',
  }) {
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository == null || spaceId == null) {
      _lastFailedScheduleEntry = null;
      _state = _state.copyWith(
        meetingSaveStatus: SaveStatus.saved,
        meetingSaveFeedback: successFeedback,
        meetingSaveTargetId: entry.id,
        clearMeetingDraftError: true,
      );
      notifyListeners();
      return;
    }
    unawaited(
      repository
          .saveScheduleEntry(spaceId, entry)
          .then<void>((_) {
            _lastFailedScheduleEntry = null;
            _state = _state.copyWith(
              meetingSaveStatus: SaveStatus.saved,
              meetingSaveFeedback: successFeedback,
              meetingSaveTargetId: entry.id,
              clearMeetingDraftError: true,
            );
            notifyListeners();
          })
          .catchError((Object _) {
            _lastFailedScheduleEntry = entry;
            _lastFailedScheduleEntrySuccessFeedback = successFeedback;
            _state = _state.copyWith(
              meetingDraftError: '일정을 저장하지 못했어요. 다시 시도해 주세요.',
              meetingSaveStatus: SaveStatus.failed,
              meetingSaveTargetId: entry.id,
              clearMeetingSaveFeedback: true,
            );
            notifyListeners();
          }),
    );
  }

  void _persistMeetingPlan(
    MeetingPlan plan, {
    String successFeedback = '만남 계획을 저장했어요.',
  }) {
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository == null || spaceId == null) {
      _lastFailedMeetingPlan = null;
      _state = _state.copyWith(
        meetingSaveStatus: SaveStatus.saved,
        meetingSaveFeedback: successFeedback,
        meetingSaveTargetId: plan.id,
        clearMeetingDraftError: true,
      );
      notifyListeners();
      return;
    }
    unawaited(
      repository
          .saveMeetingPlan(spaceId, plan)
          .then<void>((_) {
            _lastFailedMeetingPlan = null;
            _state = _state.copyWith(
              meetingSaveStatus: SaveStatus.saved,
              meetingSaveFeedback: successFeedback,
              meetingSaveTargetId: plan.id,
              clearMeetingDraftError: true,
            );
            notifyListeners();
          })
          .catchError((Object _) {
            _lastFailedMeetingPlan = plan;
            _lastFailedMeetingPlanSuccessFeedback = successFeedback;
            _state = _state.copyWith(
              meetingDraftError: '만남 계획을 저장하지 못했어요. 다시 시도해 주세요.',
              meetingSaveStatus: SaveStatus.failed,
              meetingSaveTargetId: plan.id,
              clearMeetingSaveFeedback: true,
            );
            notifyListeners();
          }),
    );
  }

  void _persistSharedPlace(SharedPlace place) {
    _persistSharedPlaceWith(
      place,
      meetingLinksOnly: false,
      write: (repository, spaceId) =>
          repository.saveSharedPlace(spaceId, place),
    );
  }

  void _persistSharedPlaceMeetingLinks(SharedPlace place) {
    _persistSharedPlaceWith(
      place,
      meetingLinksOnly: true,
      write: (repository, spaceId) =>
          repository.saveSharedPlaceMeetingLinks(spaceId, place),
    );
  }

  void _persistSharedPlaceWith(
    SharedPlace place, {
    required bool meetingLinksOnly,
    required Future<void> Function(
      AlagagiDataRepository repository,
      String spaceId,
    )
    write,
  }) {
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository == null || spaceId == null) {
      _lastFailedSharedPlace = null;
      _lastFailedSharedPlaceWasMeetingLinks = false;
      _state = _state.copyWith(
        placeSaveStatus: SaveStatus.saved,
        placeSaveFeedback: '장소를 저장했어요.',
        placeSaveTargetId: place.id,
        clearPlaceError: true,
      );
      notifyListeners();
      return;
    }
    final version = (_sharedPlaceSaveVersions[place.id] ?? 0) + 1;
    _sharedPlaceSaveVersions[place.id] = version;
    final previousSave =
        _sharedPlaceSaveChains[place.id] ?? Future<void>.value();
    final saveOperation = previousSave
        .catchError((Object _) {})
        .then<void>((_) => write(repository, spaceId));
    _sharedPlaceSaveChains[place.id] = saveOperation;
    unawaited(
      saveOperation
          .then<void>((_) {
            if (_sharedPlaceSaveVersions[place.id] != version) {
              return;
            }
            _lastFailedSharedPlace = null;
            _lastFailedSharedPlaceWasMeetingLinks = false;
            _state = _state.copyWith(
              placeSaveStatus: SaveStatus.saved,
              placeSaveFeedback: '장소를 저장했어요.',
              placeSaveTargetId: place.id,
              clearPlaceError: true,
            );
            notifyListeners();
          })
          .catchError((Object error, StackTrace stackTrace) {
            if (_sharedPlaceSaveVersions[place.id] != version) {
              return;
            }
            debugPrint('Shared place save failed for ${place.id}: $error');
            debugPrintStack(stackTrace: stackTrace);
            _persistDiagnosticEvent(
              feature: 'places',
              action: meetingLinksOnly
                  ? 'saveSharedPlaceMeetingLinks'
                  : 'saveSharedPlace',
              targetId: place.id,
              error: error,
              stackTrace: stackTrace,
              detail:
                  'meetingLinksOnly=$meetingLinksOnly; '
                  'linkedDateKey=${place.linkedDateKey ?? ''}; '
                  'linkCount=${place.normalizedMeetingPlanLinks().length}; '
                  'interestedBy=${place.interestedByProfileIds.join(',')}',
            );
            _lastFailedSharedPlace = place;
            _lastFailedSharedPlaceWasMeetingLinks = meetingLinksOnly;
            _state = _state.copyWith(
              placeError: _placeSaveFailureMessage(error),
              placeSaveStatus: SaveStatus.failed,
              placeSaveTargetId: place.id,
              clearPlaceSaveFeedback: true,
            );
            notifyListeners();
          })
          .whenComplete(() {
            if (_sharedPlaceSaveChains[place.id] == saveOperation) {
              _sharedPlaceSaveChains.remove(place.id);
            }
          }),
    );
  }

  void _persistDiagnosticEvent({
    required String feature,
    required String action,
    required String targetId,
    required Object error,
    StackTrace? stackTrace,
    String detail = '',
  }) {
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository == null || spaceId == null) {
      return;
    }
    final now = DateTime.now();
    final stackPreview = stackTrace?.toString() ?? '';
    final event = DiagnosticEvent(
      id: 'diag_${_state.me.id}_${now.microsecondsSinceEpoch}',
      feature: feature,
      action: action,
      targetId: targetId,
      message: _trimDiagnosticText('${error.runtimeType}: $error', 500),
      detail: _trimDiagnosticText(
        [
          if (detail.trim().isNotEmpty) detail.trim(),
          if (stackPreview.trim().isNotEmpty) stackPreview.trim(),
        ].join('\n'),
        1000,
      ),
      createdByProfileId: _state.me.id,
      createdAt: now,
    );
    unawaited(
      repository.saveDiagnosticEvent(spaceId, event).catchError((
        Object logError,
      ) {
        debugPrint('Diagnostic event save failed: $logError');
      }),
    );
  }

  String _trimDiagnosticText(String value, int maxLength) {
    final trimmed = value.trim();
    if (trimmed.length <= maxLength) {
      return trimmed;
    }
    return trimmed.substring(0, maxLength);
  }

  String _placeSaveFailureMessage(Object error) {
    final text = error.toString();
    if (text.contains('permission-denied')) {
      return '장소를 저장하지 못했어요. Firestore Rules 권한을 확인해 주세요.';
    }
    if (text.contains('not-found')) {
      return '장소를 저장하지 못했어요. 서버의 장소 문서를 찾지 못했어요.';
    }
    if (text.contains('unavailable') || text.contains('network')) {
      return '장소를 저장하지 못했어요. 네트워크 연결을 확인해 주세요.';
    }
    return '장소를 저장하지 못했어요. 다시 시도해 주세요.';
  }

  void _deleteSharedPlace(SharedPlace place, int previousIndex) {
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository == null || spaceId == null) {
      _lastFailedSharedPlace = null;
      _state = _state.copyWith(
        placeSaveStatus: SaveStatus.saved,
        placeSaveFeedback: '장소를 삭제했어요.',
        placeSaveTargetId: place.id,
        clearPlaceError: true,
      );
      notifyListeners();
      return;
    }
    unawaited(
      repository
          .deleteSharedPlace(spaceId, place.id)
          .then<void>((_) {
            _lastFailedSharedPlace = null;
            _state = _state.copyWith(
              placeSaveStatus: SaveStatus.saved,
              placeSaveFeedback: '장소를 삭제했어요.',
              placeSaveTargetId: place.id,
              clearPlaceError: true,
            );
            notifyListeners();
          })
          .catchError((Object _) {
            final boundedIndex = previousIndex
                .clamp(0, _sharedPlaces.length)
                .toInt();
            if (!_sharedPlaces.any((candidate) => candidate.id == place.id)) {
              _sharedPlaces.insert(boundedIndex, place);
              _sortSharedPlacesByUpdatedAt();
            }
            _state = _state.copyWith(
              placeError: '장소를 삭제하지 못했어요. 다시 시도해 주세요.',
              placeSaveStatus: SaveStatus.failed,
              placeSaveTargetId: place.id,
              clearPlaceSaveFeedback: true,
            );
            notifyListeners();
          }),
    );
  }

  void _persistCuriosityCard(CuriosityCard card) {
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository == null || spaceId == null) {
      _lastFailedCuriosityCard = null;
      _state = _state.copyWith(
        curiositySaveStatus: SaveStatus.saved,
        curiositySaveFeedback: '저장됐어요.',
        curiositySaveTargetId: card.id,
        clearCuriosityError: true,
      );
      notifyListeners();
      return;
    }
    unawaited(
      repository
          .saveCuriosityCard(spaceId, card)
          .then<void>((_) {
            _lastFailedCuriosityCard = null;
            _state = _state.copyWith(
              curiositySaveStatus: SaveStatus.saved,
              curiositySaveFeedback: '저장됐어요.',
              curiositySaveTargetId: card.id,
              clearCuriosityError: true,
            );
            notifyListeners();
          })
          .catchError((Object _) {
            _lastFailedCuriosityCard = card;
            _state = _state.copyWith(
              curiosityError: '저장하지 못했어요. 다시 시도해 주세요.',
              curiositySaveStatus: SaveStatus.failed,
              curiositySaveTargetId: card.id,
              clearCuriositySaveFeedback: true,
            );
            notifyListeners();
          }),
    );
  }

  void _persistImprovementPost(
    ImprovementPost post, {
    String successFeedback = '건의를 저장했어요.',
  }) {
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository == null || spaceId == null) {
      _lastFailedImprovementPost = null;
      _state = _state.copyWith(
        improvementSaveStatus: SaveStatus.saved,
        improvementSaveFeedback: successFeedback,
        improvementSaveTargetId: post.id,
        clearImprovementDraftError: true,
      );
      notifyListeners();
      return;
    }
    unawaited(
      repository
          .saveImprovementPost(spaceId, post)
          .then<void>((_) {
            _lastFailedImprovementPost = null;
            _state = _state.copyWith(
              improvementSaveStatus: SaveStatus.saved,
              improvementSaveFeedback: successFeedback,
              improvementSaveTargetId: post.id,
              clearImprovementDraftError: true,
            );
            notifyListeners();
          })
          .catchError((Object _) {
            _lastFailedImprovementPost = post;
            _state = _state.copyWith(
              improvementDraftError: '건의를 저장하지 못했어요. 다시 시도해 주세요.',
              improvementSaveStatus: SaveStatus.failed,
              improvementSaveTargetId: post.id,
              clearImprovementSaveFeedback: true,
            );
            notifyListeners();
          }),
    );
  }

  void _deletePersistedImprovementPost(
    ImprovementPost post,
    int previousIndex,
  ) {
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository == null || spaceId == null) {
      _state = _state.copyWith(
        improvementSaveStatus: SaveStatus.saved,
        improvementSaveFeedback: '건의를 삭제했어요.',
        improvementSaveTargetId: post.id,
        clearImprovementDraftError: true,
      );
      notifyListeners();
      return;
    }
    unawaited(
      repository
          .deleteImprovementPost(spaceId, post.id)
          .then<void>((_) {
            _state = _state.copyWith(
              improvementSaveStatus: SaveStatus.saved,
              improvementSaveFeedback: '건의를 삭제했어요.',
              improvementSaveTargetId: post.id,
              clearImprovementDraftError: true,
            );
            notifyListeners();
          })
          .catchError((Object _) {
            final boundedIndex = previousIndex
                .clamp(0, _improvementPosts.length)
                .toInt();
            if (!_improvementPosts.any(
              (candidate) => candidate.id == post.id,
            )) {
              _improvementPosts.insert(boundedIndex, post);
              _sortImprovementPostsByUpdatedAt();
            }
            _state = _state.copyWith(
              improvementDraftError: '건의를 삭제하지 못했어요. 다시 시도해 주세요.',
              improvementSaveStatus: SaveStatus.failed,
              improvementSaveTargetId: post.id,
              clearImprovementSaveFeedback: true,
            );
            notifyListeners();
          }),
    );
  }

  void _persistStockStory(StockStory story) {
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository == null || spaceId == null) {
      _lastFailedStockStory = null;
      _lastFailedStockStoryAction = null;
      _state = _state.copyWith(
        stockStorySaveStatus: SaveStatus.saved,
        stockStorySaveFeedback: '주식 이야기를 저장했어요.',
        stockStorySaveTargetId: story.id,
        clearStockStoryDraftError: true,
      );
      notifyListeners();
      return;
    }
    unawaited(
      repository
          .saveStockStory(spaceId, story)
          .then<void>((_) {
            _lastFailedStockStory = null;
            _lastFailedStockStoryAction = null;
            _state = _state.copyWith(
              stockStorySaveStatus: SaveStatus.saved,
              stockStorySaveFeedback: '주식 이야기를 저장했어요.',
              stockStorySaveTargetId: story.id,
              clearStockStoryDraftError: true,
            );
            notifyListeners();
          })
          .catchError((Object _) {
            _lastFailedStockStory = story;
            _lastFailedStockStoryAction = _FailedPersistenceAction.save;
            _state = _state.copyWith(
              stockStoryDraftError: '주식 이야기를 저장하지 못했어요. 다시 시도해 주세요.',
              stockStorySaveStatus: SaveStatus.failed,
              stockStorySaveTargetId: story.id,
              clearStockStorySaveFeedback: true,
            );
            notifyListeners();
          }),
    );
  }

  void _deletePersistedStockStory(StockStory story, int previousIndex) {
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository == null || spaceId == null) {
      _lastFailedStockStory = null;
      _lastFailedStockStoryAction = null;
      _state = _state.copyWith(
        stockStorySaveStatus: SaveStatus.saved,
        stockStorySaveFeedback: '주식 이야기를 삭제했어요.',
        stockStorySaveTargetId: story.id,
        clearStockStoryDraftError: true,
      );
      notifyListeners();
      return;
    }
    unawaited(
      repository
          .deleteStockStory(spaceId, story.id)
          .then<void>((_) {
            _lastFailedStockStory = null;
            _lastFailedStockStoryAction = null;
            _state = _state.copyWith(
              stockStorySaveStatus: SaveStatus.saved,
              stockStorySaveFeedback: '주식 이야기를 삭제했어요.',
              stockStorySaveTargetId: story.id,
              clearStockStoryDraftError: true,
            );
            notifyListeners();
          })
          .catchError((Object _) {
            final boundedIndex = previousIndex
                .clamp(0, _stockStories.length)
                .toInt();
            if (!_stockStories.any((candidate) => candidate.id == story.id)) {
              _stockStories.insert(boundedIndex, story);
              _sortStockStoriesByUpdatedAt();
            }
            _lastFailedStockStory = story;
            _lastFailedStockStoryAction = _FailedPersistenceAction.delete;
            _state = _state.copyWith(
              stockStoryDraftError: '주식 이야기를 삭제하지 못했어요. 다시 시도해 주세요.',
              stockStorySaveStatus: SaveStatus.failed,
              stockStorySaveTargetId: story.id,
              clearStockStorySaveFeedback: true,
            );
            notifyListeners();
          }),
    );
  }

  void _persistStockHolding(StockHolding holding) {
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository == null || spaceId == null) {
      _lastFailedStockHolding = null;
      _lastFailedStockHoldingAction = null;
      _state = _state.copyWith(
        stockHoldingSaveStatus: SaveStatus.saved,
        stockHoldingSaveFeedback: '보유 종목을 저장했어요.',
        stockHoldingSaveTargetId: holding.id,
        clearStockHoldingDraftError: true,
      );
      notifyListeners();
      return;
    }
    unawaited(
      repository
          .saveStockHolding(spaceId, holding)
          .then<void>((_) {
            _lastFailedStockHolding = null;
            _lastFailedStockHoldingAction = null;
            _state = _state.copyWith(
              stockHoldingSaveStatus: SaveStatus.saved,
              stockHoldingSaveFeedback: '보유 종목을 저장했어요.',
              stockHoldingSaveTargetId: holding.id,
              clearStockHoldingDraftError: true,
            );
            notifyListeners();
          })
          .catchError((Object _) {
            _lastFailedStockHolding = holding;
            _lastFailedStockHoldingAction = _FailedPersistenceAction.save;
            _state = _state.copyWith(
              stockHoldingDraftError: '보유 종목을 저장하지 못했어요. 다시 시도해 주세요.',
              stockHoldingSaveStatus: SaveStatus.failed,
              stockHoldingSaveTargetId: holding.id,
              clearStockHoldingSaveFeedback: true,
            );
            notifyListeners();
          }),
    );
  }

  void _deletePersistedStockHolding(StockHolding holding, int previousIndex) {
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository == null || spaceId == null) {
      _lastFailedStockHolding = null;
      _lastFailedStockHoldingAction = null;
      _state = _state.copyWith(
        stockHoldingSaveStatus: SaveStatus.saved,
        stockHoldingSaveFeedback: '보유 종목을 삭제했어요.',
        stockHoldingSaveTargetId: holding.id,
        clearStockHoldingDraftError: true,
      );
      notifyListeners();
      return;
    }
    unawaited(
      repository
          .deleteStockHolding(spaceId, holding.id)
          .then<void>((_) {
            _lastFailedStockHolding = null;
            _lastFailedStockHoldingAction = null;
            _state = _state.copyWith(
              stockHoldingSaveStatus: SaveStatus.saved,
              stockHoldingSaveFeedback: '보유 종목을 삭제했어요.',
              stockHoldingSaveTargetId: holding.id,
              clearStockHoldingDraftError: true,
            );
            notifyListeners();
          })
          .catchError((Object _) {
            final boundedIndex = previousIndex
                .clamp(0, _stockHoldings.length)
                .toInt();
            if (!_stockHoldings.any(
              (candidate) => candidate.id == holding.id,
            )) {
              _stockHoldings.insert(boundedIndex, holding);
              _sortStockHoldingsByUpdatedAt();
            }
            _lastFailedStockHolding = holding;
            _lastFailedStockHoldingAction = _FailedPersistenceAction.delete;
            _state = _state.copyWith(
              stockHoldingDraftError: '보유 종목을 삭제하지 못했어요. 다시 시도해 주세요.',
              stockHoldingSaveStatus: SaveStatus.failed,
              stockHoldingSaveTargetId: holding.id,
              clearStockHoldingSaveFeedback: true,
            );
            notifyListeners();
          }),
    );
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
    return partnerBalanceSelectionFor(activeBalanceQuestion);
  }

  String? get activeBalanceReason => balanceReasonFor(activeBalanceQuestion);

  String? balanceSelectionFor(BalanceQuestion question) {
    return _balanceSelections[question.id];
  }

  String? partnerBalanceSelectionFor(BalanceQuestion question) {
    return _partnerBalanceSelections[question.id] ??
        (_usesDemoData ? question.partnerChoiceId : null);
  }

  String? balanceReasonFor(BalanceQuestion question) {
    return _balanceReasons[question.id];
  }

  String? partnerBalanceReasonFor(BalanceQuestion question) {
    return _partnerBalanceReasons[question.id];
  }

  DateTime? balanceResultRevealedAtFor(BalanceQuestion question) {
    return _balanceResultRevealedAt[question.id];
  }

  bool isBalanceResultReadyFor(BalanceQuestion question) {
    return _balanceSelections.containsKey(question.id) &&
        partnerBalanceSelectionFor(question) != null;
  }

  bool isBalanceResultRevealedFor(BalanceQuestion question) {
    return isBalanceResultReadyFor(question) &&
        _balanceResultRevealedAt.containsKey(question.id);
  }

  int get balanceCompletedCount {
    return balanceQuestions
        .where((question) => _balanceSelections.containsKey(question.id))
        .length;
  }

  int get balanceResolvedCount {
    return balanceQuestions.where((question) {
      return _balanceSelections.containsKey(question.id) &&
          partnerBalanceSelectionFor(question) != null;
    }).length;
  }

  int get balanceRevealedCount {
    return balanceQuestions.where(isBalanceResultRevealedFor).length;
  }

  ProfileSlot? get todayFillableProfileSlot {
    final myCard = _profileCards.firstWhere((card) => card.profile.isMe);
    for (final slot in myCard.slots) {
      if (slot.value == null && !slot.skipped && !slot.hidden) {
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

  List<MusicNote> get visibleMusicNotes {
    final notes = switch (_state.musicListFilter) {
      MusicListFilter.all => _musicNotes.toList(),
      MusicListFilter.unlistened =>
        _musicNotes.where((note) => !note.isListenedBy(_state.me.id)).toList(),
      MusicListFilter.listened =>
        _musicNotes.where((note) => note.isListenedBy(_state.me.id)).toList(),
      MusicListFilter.mine =>
        _musicNotes
            .where((note) => note.createdByProfileId == _state.me.id)
            .toList(),
      MusicListFilter.partner =>
        _musicNotes
            .where((note) => note.createdByProfileId == _state.partner.id)
            .toList(),
    };
    if (_state.musicListFilter == MusicListFilter.all) {
      notes.sort((a, b) {
        final aListened = a.isListenedBy(_state.me.id);
        final bListened = b.isListenedBy(_state.me.id);
        if (aListened != bListened) {
          return aListened ? 1 : -1;
        }
        return _musicNotes.indexOf(a).compareTo(_musicNotes.indexOf(b));
      });
    }
    return List<MusicNote>.unmodifiable(notes);
  }

  int get unlistenedMusicNoteCount =>
      _musicNotes.where((note) => !note.isListenedBy(_state.me.id)).length;

  int get listenedMusicNoteCount =>
      _musicNotes.where((note) => note.isListenedBy(_state.me.id)).length;

  int get mutualListenedMusicNoteCount =>
      _musicNotes.where((note) => note.listenedByProfileIds.length >= 2).length;

  List<ScheduleEntry> get scheduleEntries =>
      List<ScheduleEntry>.unmodifiable(_scheduleEntries);

  List<MeetingPlan> get meetingPlans =>
      List<MeetingPlan>.unmodifiable(_meetingPlans);

  List<SharedPlace> get sharedPlaces =>
      List<SharedPlace>.unmodifiable(_sharedPlaces);

  bool get canRetryMeetingSave =>
      _lastFailedScheduleEntry != null || _lastFailedMeetingPlan != null;

  bool get canRetryPlaceSave => _lastFailedSharedPlace != null;

  bool get canRetryWishSave => _lastFailedWish != null;

  bool get canRetryMusicSave => _lastFailedMusicNote != null;

  bool get canRetryStockStorySave => _lastFailedStockStory != null;

  bool get canRetryStockHoldingSave => _lastFailedStockHolding != null;

  String get selectedMeetingDateKey =>
      _state.selectedMeetingDateKey ?? _todayDateKey();

  ScheduleEntry? get mySelectedScheduleEntry =>
      scheduleEntryFor(_state.me.id, selectedMeetingDateKey);

  ScheduleEntry? get partnerSelectedScheduleEntry =>
      scheduleEntryFor(_state.partner.id, selectedMeetingDateKey);

  List<String> get meetingDayDateKeys {
    final keys =
        _scheduleEntries
            .where((entry) => entry.isMeetingDay)
            .map((entry) => entry.dateKey)
            .toSet()
            .toList()
          ..sort();
    return List<String>.unmodifiable(keys);
  }

  List<ScheduleEntry> get meetingDayEntries {
    final entries = meetingDayDateKeys
        .map(meetingDayEntryFor)
        .nonNulls
        .toList();
    final today = _todayDateKey();
    entries.sort((a, b) {
      final aUpcoming = a.dateKey.compareTo(today) >= 0;
      final bUpcoming = b.dateKey.compareTo(today) >= 0;
      if (aUpcoming != bUpcoming) {
        return aUpcoming ? -1 : 1;
      }
      return aUpcoming
          ? a.dateKey.compareTo(b.dateKey)
          : b.dateKey.compareTo(a.dateKey);
    });
    return List<ScheduleEntry>.unmodifiable(entries);
  }

  List<ScheduleEntry> get upcomingMeetingDayEntries {
    final today = _todayDateKey();
    return List<ScheduleEntry>.unmodifiable(
      meetingDayEntries.where((entry) => entry.dateKey.compareTo(today) >= 0),
    );
  }

  List<ScheduleEntry> get pastMeetingDayEntries {
    final today = _todayDateKey();
    return List<ScheduleEntry>.unmodifiable(
      meetingDayEntries.where((entry) => entry.dateKey.compareTo(today) < 0),
    );
  }

  ScheduleEntry? get nextMeetingDayEntry {
    final entries = upcomingMeetingDayEntries;
    if (entries.isEmpty) {
      return null;
    }
    return entries.first;
  }

  ScheduleEntry? meetingDayEntryFor(String dateKey) {
    final entries = _scheduleEntries
        .where((entry) => entry.dateKey == dateKey && entry.isMeetingDay)
        .toList();
    if (entries.isEmpty) {
      return null;
    }
    return entries.firstWhere(
      (entry) => entry.profileId == _state.me.id,
      orElse: () => entries.first,
    );
  }

  String get selectedMeetingPlanDateKey {
    final selectedDateKey = _state.selectedMeetingPlanDateKey;
    final today = _todayDateKey();
    if (selectedDateKey != null &&
        selectedDateKey.compareTo(today) >= 0 &&
        meetingDayEntryFor(selectedDateKey) != null) {
      return selectedDateKey;
    }
    return nextMeetingDayEntry?.dateKey ??
        selectedDateKey ??
        selectedMeetingDateKey;
  }

  ScheduleEntry? get selectedMeetingPlanEntry {
    final entries = upcomingMeetingDayEntries;
    if (entries.isEmpty) {
      return null;
    }
    return entries.firstWhere(
      (entry) => entry.dateKey == selectedMeetingPlanDateKey,
      orElse: () => entries.first,
    );
  }

  MeetingPlan? meetingPlanFor(String dateKey) {
    final persistedPlan = _meetingPlans.cast<MeetingPlan?>().firstWhere(
      (plan) => plan?.dateKey == dateKey,
      orElse: () => null,
    );
    if (persistedPlan != null) {
      return persistedPlan;
    }
    final legacyItems = _legacyMeetingPlanItemsFor(dateKey);
    if (legacyItems.isEmpty) {
      return null;
    }
    final latestLegacyEntry = _latestScheduleEntryForDate(dateKey);
    return MeetingPlan(
      dateKey: dateKey,
      items: legacyItems,
      updatedByProfileId:
          latestLegacyEntry?.profileId ??
          meetingDayEntryFor(dateKey)?.profileId ??
          _state.me.id,
      updatedAt: latestLegacyEntry?.updatedAt,
    );
  }

  List<String> meetingPlanItemsFor(String dateKey) {
    return List<String>.unmodifiable(
      meetingPlanFor(dateKey)?.items ?? const [],
    );
  }

  int meetingPlanItemCountFor(String dateKey) =>
      meetingPlanItemsFor(dateKey).length;

  List<String> get meetingPlanDraftItems =>
      _parseMeetingPlanItems(_state.meetingPlanDraftText);

  List<SharedPlace> placesForMeetingPlan(String dateKey) {
    final places = _sharedPlaces
        .where((place) => place.isLinkedToMeetingDate(dateKey))
        .toList();
    places.sort((a, b) {
      final aOrder = a.meetingPlanLinkFor(dateKey)?.order ?? 9999;
      final bOrder = b.meetingPlanLinkFor(dateKey)?.order ?? 9999;
      if (aOrder != bOrder) {
        return aOrder.compareTo(bOrder);
      }
      final aTime = a.meetingPlanLinkFor(dateKey)?.reservationTimeLabel ?? '';
      final bTime = b.meetingPlanLinkFor(dateKey)?.reservationTimeLabel ?? '';
      if (aTime.isNotEmpty && bTime.isNotEmpty && aTime != bTime) {
        return aTime.compareTo(bTime);
      }
      if (a.isMutual != b.isMutual) {
        return a.isMutual ? -1 : 1;
      }
      return a.name.compareTo(b.name);
    });
    return List<SharedPlace>.unmodifiable(places);
  }

  List<MeetingCandidate> get meetingCandidates {
    final keys = _scheduleEntries.map((entry) => entry.dateKey).toSet().toList()
      ..sort();
    final candidates = <MeetingCandidate>[];
    for (final dateKey in keys) {
      final myEntry = scheduleEntryFor(_state.me.id, dateKey);
      final partnerEntry = scheduleEntryFor(_state.partner.id, dateKey);
      if (myEntry == null || partnerEntry == null) {
        continue;
      }
      final sharedSlots = myEntry.timeSlots.intersection(
        partnerEntry.timeSlots,
      );
      if (myEntry.canMeet && partnerEntry.canMeet && sharedSlots.isNotEmpty) {
        candidates.add(
          MeetingCandidate(
            dateKey: dateKey,
            sharedSlots: sharedSlots,
            myEntry: myEntry,
            partnerEntry: partnerEntry,
          ),
        );
      }
    }
    return List<MeetingCandidate>.unmodifiable(candidates);
  }

  ScheduleEntry? scheduleEntryFor(String profileId, String dateKey) {
    return _scheduleEntries.cast<ScheduleEntry?>().firstWhere(
      (entry) => entry?.profileId == profileId && entry?.dateKey == dateKey,
      orElse: () => null,
    );
  }

  List<String> _legacyMeetingPlanItemsFor(String dateKey) {
    final items = <String>[];
    final seen = <String>{};
    final entries = _scheduleEntries
        .where((entry) => entry.dateKey == dateKey)
        .toList();
    entries.sort((a, b) {
      if (a.profileId == _state.me.id && b.profileId != _state.me.id) {
        return -1;
      }
      if (b.profileId == _state.me.id && a.profileId != _state.me.id) {
        return 1;
      }
      final aUpdatedAt = a.updatedAt;
      final bUpdatedAt = b.updatedAt;
      if (aUpdatedAt == null || bUpdatedAt == null) {
        return a.profileId.compareTo(b.profileId);
      }
      return aUpdatedAt.compareTo(bUpdatedAt);
    });
    for (final entry in entries) {
      for (final item in entry.meetingPlanItems) {
        final trimmed = item.trim();
        if (trimmed.isEmpty || seen.contains(trimmed)) {
          continue;
        }
        seen.add(trimmed);
        items.add(trimmed);
      }
    }
    return List<String>.unmodifiable(items);
  }

  ScheduleEntry? _latestScheduleEntryForDate(String dateKey) {
    ScheduleEntry? latest;
    for (final entry in _scheduleEntries.where(
      (entry) => entry.dateKey == dateKey,
    )) {
      final updatedAt = entry.updatedAt;
      if (latest == null) {
        latest = entry;
        continue;
      }
      final latestUpdatedAt = latest.updatedAt;
      if (updatedAt != null &&
          (latestUpdatedAt == null || updatedAt.isAfter(latestUpdatedAt))) {
        latest = entry;
      }
    }
    return latest;
  }

  List<CuriosityCard> get curiosityCards =>
      List<CuriosityCard>.unmodifiable(_curiosityCards);

  List<ImprovementPost> get improvementPosts =>
      List<ImprovementPost>.unmodifiable(_improvementPosts);

  bool get canManageImprovementPosts => _state.me.isOwner;

  List<StockStory> get stockStories =>
      List<StockStory>.unmodifiable(_stockStories);

  List<StockStory> get visibleStockStories {
    final stories = switch (_state.stockStoryListFilter) {
      StockStoryListFilter.all => _stockStories,
      StockStoryListFilter.mine =>
        _stockStories
            .where((story) => story.createdByProfileId == _state.me.id)
            .toList(),
      StockStoryListFilter.partner =>
        _stockStories
            .where((story) => story.createdByProfileId == _state.partner.id)
            .toList(),
      StockStoryListFilter.needsReply =>
        _stockStories
            .where(
              (story) =>
                  story.createdByProfileId == _state.partner.id &&
                  !story.hasReply,
            )
            .toList(),
      StockStoryListFilter.replied =>
        _stockStories.where((story) => story.hasReply).toList(),
    };
    return List<StockStory>.unmodifiable(stories);
  }

  List<StockHolding> get stockHoldings =>
      List<StockHolding>.unmodifiable(_stockHoldings);

  List<StockHolding> get visibleStockHoldings {
    final holdings = switch (_state.stockHoldingListFilter) {
      StockHoldingListFilter.all => _stockHoldings,
      StockHoldingListFilter.mine =>
        _stockHoldings
            .where((holding) => holding.createdByProfileId == _state.me.id)
            .toList(),
      StockHoldingListFilter.partner =>
        _stockHoldings
            .where((holding) => holding.createdByProfileId == _state.partner.id)
            .toList(),
      StockHoldingListFilter.needsReply =>
        _stockHoldings
            .where(
              (holding) =>
                  holding.createdByProfileId == _state.partner.id &&
                  !holding.hasReply,
            )
            .toList(),
      StockHoldingListFilter.shared =>
        _stockHoldings
            .where((holding) => stockHoldingSharedByBoth(holding.name))
            .toList(),
      StockHoldingListFilter.holding =>
        _stockHoldings.where((holding) => holding.status == '보유 중').toList(),
      StockHoldingListFilter.considering =>
        _stockHoldings.where((holding) => holding.status == '정리 고민 중').toList(),
      StockHoldingListFilter.closed =>
        _stockHoldings.where((holding) => holding.status == '최근 정리함').toList(),
    };
    return List<StockHolding>.unmodifiable(holdings);
  }

  bool stockHoldingSharedByBoth(String name) {
    final normalizedName = name.trim().toLowerCase();
    if (normalizedName.isEmpty) {
      return false;
    }
    final owners = _stockHoldings
        .where((holding) => holding.name.trim().toLowerCase() == normalizedName)
        .map((holding) => holding.createdByProfileId)
        .toSet();
    return owners.contains(_state.me.id) && owners.contains(_state.partner.id);
  }

  CuriosityCard? get latestReceivedCuriosityCard {
    return _firstCuriosityCardWhere((card) => card.toProfileId == _state.me.id);
  }

  CuriosityCard? get latestSentCuriosityCard {
    return _firstCuriosityCardWhere(
      (card) => card.fromProfileId == _state.me.id,
    );
  }

  CuriosityCard? get pendingSentCuriosityCard {
    return _firstCuriosityCardWhere(
      (card) => card.fromProfileId == _state.me.id && !card.hasReply,
    );
  }

  bool get hasPendingSentCuriosityCard => pendingSentCuriosityCard != null;

  int get unansweredReceivedCuriosityCount {
    return _curiosityCards.where((card) {
      return card.toProfileId == _state.me.id && !card.hasReply;
    }).length;
  }

  CuriosityCard? _firstCuriosityCardWhere(
    bool Function(CuriosityCard card) test,
  ) {
    for (final card in _curiosityCards) {
      if (test(card)) {
        return card;
      }
    }
    return null;
  }

  bool isImprovementSaveTarget(String postId) {
    return _state.improvementSaveTargetId == postId;
  }

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
    final feature = _unreadFeatureForRoute(route);
    if (feature != null) {
      _markFeatureSeen(feature);
    }
    String? selectedMeetingPlanDateKey;
    String? meetingPlanDraftText;
    if (route == AlagagiRoute.meetingPlans) {
      final entry = selectedMeetingPlanEntry ?? nextMeetingDayEntry;
      selectedMeetingPlanDateKey = entry?.dateKey;
      meetingPlanDraftText = _meetingPlanTextFromItems(
        selectedMeetingPlanDateKey == null
            ? const []
            : meetingPlanItemsFor(selectedMeetingPlanDateKey),
      );
    }
    _state = _state.copyWith(
      route: route,
      selectedMeetingPlanDateKey: selectedMeetingPlanDateKey,
      clearSelectedMeetingPlanDateKey:
          route == AlagagiRoute.meetingPlans &&
          selectedMeetingPlanDateKey == null,
      meetingPlanDraftText: meetingPlanDraftText,
      meetingPlanItemDraft: route == AlagagiRoute.meetingPlans
          ? ''
          : _state.meetingPlanItemDraft,
      clearEditingMeetingPlanItemIndex: true,
      editingAnswer: false,
      clearActiveAnswerQuestion: route != AlagagiRoute.answer,
      clearAnswerError: true,
      clearAnswerSaveFeedback: route == AlagagiRoute.answer,
    );
    notifyListeners();
  }

  void openUnreadActivity(UnreadActivity activity) {
    if (activity.feature == UnreadActivityFeature.profileCard) {
      _state = _state.copyWith(profileCardTab: ProfileCardTab.partner);
    } else if (activity.feature == UnreadActivityFeature.stocks) {
      _state = _state.copyWith(
        stockStoryTab: activity.id.startsWith('stock-holding-')
            ? StockStoryTab.holdings
            : StockStoryTab.stories,
      );
    }
    goTo(activity.route);
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
    _markFeatureSeen(UnreadActivityFeature.music);
  }

  void _markFeatureSeen(UnreadActivityFeature feature) {
    final spaceId = _spaceId;
    if (spaceId == null) {
      return;
    }
    final latestTimestamp = _latestFeatureTimestamp(feature) ?? DateTime.now();
    _musicNoteSeenStore.writeLastSeenAt(
      spaceId,
      _state.me.id,
      feature,
      latestTimestamp,
    );
  }

  DateTime? _latestFeatureTimestamp(UnreadActivityFeature feature) {
    return switch (feature) {
      UnreadActivityFeature.profileCard => _latestProfileCardTimestamp(),
      UnreadActivityFeature.wishlist => _latestTimestamp(
        _wishes.map((wish) => wish.updatedAt),
      ),
      UnreadActivityFeature.meetings => _latestTimestamp([
        ..._scheduleEntries.map((entry) => entry.updatedAt),
        ..._meetingPlans.map((plan) => plan.updatedAt),
      ]),
      UnreadActivityFeature.places => _latestTimestamp(
        _sharedPlaces.map((place) => place.updatedAt),
      ),
      UnreadActivityFeature.curiosity => _latestTimestamp(
        _curiosityCards.map((card) => card.updatedAt),
      ),
      UnreadActivityFeature.stocks => _latestTimestamp([
        ..._stockStories.map((story) => story.updatedAt),
        ..._stockHoldings.map((holding) => holding.updatedAt),
      ]),
      UnreadActivityFeature.music => _latestMusicNoteTimestamp(),
      UnreadActivityFeature.improvements => _latestTimestamp(
        _improvementPosts.map((post) => post.updatedAt),
      ),
    };
  }

  DateTime? _latestProfileCardTimestamp() {
    final partnerCard = _profileCards.cast<ProfileCardData?>().firstWhere(
      (card) => card?.profile.id == _state.partner.id,
      orElse: () => null,
    );
    return _latestTimestamp(
      (partnerCard?.slots ?? const <ProfileSlot>[])
          .where((slot) => !slot.hidden && slot.value != null)
          .map((slot) => slot.updatedAt),
    );
  }

  DateTime? _latestTimestamp(Iterable<DateTime?> timestamps) {
    DateTime? latest;
    for (final updatedAt in timestamps) {
      if (updatedAt == null) {
        continue;
      }
      if (latest == null || updatedAt.isAfter(latest)) {
        latest = updatedAt;
      }
    }
    return latest;
  }

  DateTime? _latestMusicNoteTimestamp() {
    return _latestTimestamp(_musicNotes.map((note) => note.updatedAt));
  }

  UnreadActivityFeature? _unreadFeatureForRoute(AlagagiRoute route) {
    return switch (route) {
      AlagagiRoute.profileCard => UnreadActivityFeature.profileCard,
      AlagagiRoute.wishlist => UnreadActivityFeature.wishlist,
      AlagagiRoute.meetings => UnreadActivityFeature.meetings,
      AlagagiRoute.meetingPlans => UnreadActivityFeature.meetings,
      AlagagiRoute.places => UnreadActivityFeature.places,
      AlagagiRoute.stockStory => UnreadActivityFeature.stocks,
      AlagagiRoute.music => UnreadActivityFeature.music,
      AlagagiRoute.improvements => UnreadActivityFeature.improvements,
      _ => null,
    };
  }

  int? _parseMeetingTimeInput(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    final normalized = trimmed.replaceAll('：', ':');
    final parts = normalized.contains(':')
        ? normalized.split(':')
        : normalized.length <= 2
        ? [normalized, '0']
        : [
            normalized.substring(0, normalized.length - 2),
            normalized.substring(normalized.length - 2),
          ];
    if (parts.length != 2) {
      return null;
    }
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) {
      return null;
    }
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      return null;
    }
    return hour * 60 + minute;
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

  void _sortScheduleEntriesByDate() {
    _scheduleEntries.sort((a, b) {
      final dateCompare = a.dateKey.compareTo(b.dateKey);
      if (dateCompare != 0) {
        return dateCompare;
      }
      return a.profileId.compareTo(b.profileId);
    });
  }

  void _sortMeetingPlansByDate() {
    _meetingPlans.sort((a, b) => a.dateKey.compareTo(b.dateKey));
  }

  void _upsertMeetingPlan(MeetingPlan plan) {
    final index = _meetingPlans.indexWhere(
      (candidate) => candidate.dateKey == plan.dateKey,
    );
    if (index == -1) {
      _meetingPlans.add(plan);
    } else {
      _meetingPlans[index] = plan;
    }
    _sortMeetingPlansByDate();
  }

  void _sortSharedPlacesByUpdatedAt() {
    _sharedPlaces.sort((a, b) {
      final aUpdatedAt = a.updatedAt;
      final bUpdatedAt = b.updatedAt;
      if (aUpdatedAt == null && bUpdatedAt == null) {
        return b.id.compareTo(a.id);
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

  void _sortCuriosityCardsByUpdatedAt() {
    _curiosityCards.sort((a, b) {
      final aUpdatedAt = a.updatedAt;
      final bUpdatedAt = b.updatedAt;
      if (aUpdatedAt == null && bUpdatedAt == null) {
        return b.id.compareTo(a.id);
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

  void _sortImprovementPostsByUpdatedAt() {
    _improvementPosts.sort((a, b) {
      final aUpdatedAt = a.updatedAt;
      final bUpdatedAt = b.updatedAt;
      if (aUpdatedAt == null && bUpdatedAt == null) {
        return b.id.compareTo(a.id);
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

  void _sortStockStoriesByUpdatedAt() {
    _stockStories.sort((a, b) {
      final aUpdatedAt = a.updatedAt;
      final bUpdatedAt = b.updatedAt;
      if (aUpdatedAt == null && bUpdatedAt == null) {
        return b.id.compareTo(a.id);
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

  void _sortStockHoldingsByUpdatedAt() {
    _stockHoldings.sort((a, b) {
      final aUpdatedAt = a.updatedAt;
      final bUpdatedAt = b.updatedAt;
      if (aUpdatedAt == null && bUpdatedAt == null) {
        return b.id.compareTo(a.id);
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
    if (_balanceSelections[question.id] == optionId) {
      _balanceSelections.remove(question.id);
      _balanceReasons.remove(question.id);
      _balanceResultRevealedAt.remove(question.id);
      _deletePersistedBalanceSelection(question.id);
      notifyListeners();
      return;
    }
    final selection = BalanceSelection(
      questionId: question.id,
      profileId: _state.me.id,
      optionId: optionId,
      reason: _balanceReasons[question.id],
      resultRevealedAt: _balanceResultRevealedAt[question.id],
    );
    _balanceSelections[question.id] = optionId;
    _persistBalanceSelection(selection);
    notifyListeners();
  }

  void saveBalanceReason(String value) {
    final question = activeBalanceQuestion;
    final optionId = _balanceSelections[question.id];
    if (optionId == null) {
      return;
    }
    final reason = value.trim();
    if (reason.length > 80) {
      throw ArgumentError.value(value, 'value', '80자 안으로 남겨주세요.');
    }
    if (reason.isEmpty) {
      _balanceReasons.remove(question.id);
    } else {
      _balanceReasons[question.id] = reason;
    }
    _persistBalanceSelection(
      BalanceSelection(
        questionId: question.id,
        profileId: _state.me.id,
        optionId: optionId,
        reason: reason.isEmpty ? null : reason,
        resultRevealedAt: _balanceResultRevealedAt[question.id],
      ),
    );
    notifyListeners();
  }

  void revealBalanceResult(BalanceQuestion question) {
    final optionId = _balanceSelections[question.id];
    if (optionId == null || partnerBalanceSelectionFor(question) == null) {
      return;
    }
    final resultRevealedAt = _balanceResultRevealedAt[question.id];
    if (resultRevealedAt != null) {
      return;
    }
    final revealedAt = DateTime.now();
    _balanceResultRevealedAt[question.id] = revealedAt;
    _persistBalanceSelection(
      BalanceSelection(
        questionId: question.id,
        profileId: _state.me.id,
        optionId: optionId,
        reason: _balanceReasons[question.id],
        resultRevealedAt: revealedAt,
      ),
    );
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
          skipped: false,
          updatedAt: DateTime.now(),
          updatedByProfileId: _state.me.id,
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

  String? addCustomProfileSlot({
    required String title,
    required String value,
    required String category,
  }) {
    final trimmedTitle = title.trim();
    final trimmedValue = value.trim();
    final normalizedCategory =
        const {'취향', '하루', '대화', '함께', '직접'}.contains(category)
        ? category
        : '직접';
    if (trimmedTitle.length < 2) {
      return '카드 제목은 두 글자 이상 남겨주세요.';
    }
    if (trimmedTitle.length > 32) {
      return '카드 제목은 32자 안으로 남겨주세요.';
    }
    if (trimmedValue.isEmpty) {
      return '소개 내용을 한 줄이라도 남겨주세요.';
    }
    if (trimmedValue.length > 120) {
      return '소개 내용은 120자 안으로 남겨주세요.';
    }

    final cardIndex = _profileCards.indexWhere((card) => card.profile.isMe);
    if (cardIndex == -1) {
      return '내 카드를 찾지 못했어요.';
    }
    final now = DateTime.now();
    final slot = ProfileSlot(
      id: 'custom_${_state.me.id}_${now.microsecondsSinceEpoch}',
      label: trimmedTitle,
      icon: 'custom',
      category: normalizedCategory,
      inputHint: '직접 추가한 소개 카드',
      value: trimmedValue,
      custom: true,
      updatedAt: now,
      updatedByProfileId: _state.me.id,
    );
    final card = _profileCards[cardIndex];
    _profileCards[cardIndex] = card.copyWith(slots: [slot, ...card.slots]);
    _persistProfileSlot(slot);
    _state = _state.copyWith(profileCardTab: ProfileCardTab.me);
    notifyListeners();
    return null;
  }

  void skipProfileSlot(String slotId) {
    _updateMyProfileSlot(
      slotId,
      (slot) => slot.copyWith(
        clearValue: slot.value == null,
        skipped: true,
        updatedAt: DateTime.now(),
        updatedByProfileId: _state.me.id,
      ),
    );
  }

  void hideProfileSlot(String slotId) {
    _updateMyProfileSlot(
      slotId,
      (slot) => slot.copyWith(
        clearValue: true,
        skipped: false,
        hidden: true,
        updatedAt: DateTime.now(),
        updatedByProfileId: _state.me.id,
      ),
    );
  }

  void restoreProfileSlot(String slotId) {
    _updateMyProfileSlot(
      slotId,
      (slot) => slot.copyWith(
        skipped: false,
        hidden: false,
        updatedAt: DateTime.now(),
        updatedByProfileId: _state.me.id,
      ),
    );
  }

  void deleteCustomProfileSlot(String slotId) {
    final cardIndex = _profileCards.indexWhere((card) => card.profile.isMe);
    if (cardIndex == -1) {
      return;
    }
    final card = _profileCards[cardIndex];
    final slot = card.slots.cast<ProfileSlot?>().firstWhere(
      (candidate) => candidate?.id == slotId,
      orElse: () => null,
    );
    if (slot == null || !slot.custom) {
      return;
    }
    _profileCards[cardIndex] = card.copyWith(
      slots: card.slots.where((candidate) => candidate.id != slotId).toList(),
    );
    _persistDeletedProfileSlot(slotId);
    _state = _state.copyWith(profileCardTab: ProfileCardTab.me);
    notifyListeners();
  }

  void _updateMyProfileSlot(
    String slotId,
    ProfileSlot Function(ProfileSlot slot) update,
  ) {
    final cardIndex = _profileCards.indexWhere((card) => card.profile.isMe);
    if (cardIndex == -1) {
      return;
    }
    final card = _profileCards[cardIndex];
    ProfileSlot? updatedSlot;
    final slots = card.slots.map((slot) {
      if (slot.id != slotId) {
        return slot;
      }
      updatedSlot = update(slot);
      return updatedSlot!;
    }).toList();
    if (updatedSlot == null) {
      return;
    }
    _profileCards[cardIndex] = card.copyWith(slots: slots);
    _persistProfileSlot(updatedSlot!);
    _state = _state.copyWith(profileCardTab: ProfileCardTab.me);
    notifyListeners();
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
      clearEditingWishId: true,
      clearWishDraftError: true,
      clearWishSaveFeedback: true,
      clearWishSaveTargetId: true,
    );
    notifyListeners();
  }

  void startWishEdit(String wishId) {
    final wish = _wishes.cast<WishItem?>().firstWhere(
      (candidate) => candidate?.id == wishId,
      orElse: () => null,
    );
    if (wish == null || wish.createdByProfileId != _state.me.id) {
      _state = _state.copyWith(wishDraftError: '내가 담은 위시만 수정할 수 있어요.');
      notifyListeners();
      return;
    }
    _state = _state.copyWith(
      route: AlagagiRoute.wishlist,
      wishlistFilter: WishlistFilter.all,
      wishDraftVisible: true,
      wishDraftTitle: wish.title,
      wishDraftKind: wish.kind,
      editingWishId: wish.id,
      clearWishDraftError: true,
      clearWishSaveFeedback: true,
      clearWishSaveTargetId: true,
    );
    notifyListeners();
  }

  void cancelWishDraft() {
    _state = _state.copyWith(
      wishDraftVisible: false,
      wishDraftTitle: '',
      wishDraftKind: WishKind.activity,
      clearEditingWishId: true,
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

    final now = DateTime.now();
    final editingId = _state.editingWishId;
    final editingIndex = editingId == null
        ? -1
        : _wishes.indexWhere((wish) => wish.id == editingId);
    final WishItem wish;
    if (editingId != null) {
      if (editingIndex == -1) {
        _state = _state.copyWith(wishDraftError: '수정할 위시를 찾지 못했어요.');
        notifyListeners();
        return;
      }
      if (_wishes[editingIndex].createdByProfileId != _state.me.id) {
        _state = _state.copyWith(wishDraftError: '내가 담은 위시만 수정할 수 있어요.');
        notifyListeners();
        return;
      }
      wish = _wishes[editingIndex].copyWith(
        title: title,
        kind: _state.wishDraftKind,
        icon: _wishIconFor(_state.wishDraftKind),
        updatedAt: now,
        updatedByProfileId: _state.me.id,
      );
      _wishes[editingIndex] = wish;
    } else {
      wish = WishItem(
        id: 'wish_${_state.me.id}_${now.microsecondsSinceEpoch}',
        icon: _wishIconFor(_state.wishDraftKind),
        title: title,
        kind: _state.wishDraftKind,
        createdByProfileId: _state.me.id,
        likedByProfileIds: {_state.me.id},
        updatedAt: now,
        updatedByProfileId: _state.me.id,
      );
      _wishes.insert(0, wish);
    }
    _state = _state.copyWith(
      wishlistFilter: WishlistFilter.all,
      wishDraftVisible: false,
      wishDraftTitle: '',
      wishDraftKind: WishKind.activity,
      wishSaveStatus: SaveStatus.saving,
      wishSaveTargetId: wish.id,
      clearEditingWishId: true,
      clearWishDraftError: true,
      clearWishSaveFeedback: true,
    );
    notifyListeners();
    _persistWish(wish);
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
    final updatedWish = wish.copyWith(
      likedByProfileIds: likedBy,
      updatedAt: DateTime.now(),
      updatedByProfileId: _state.me.id,
    );
    _wishes[index] = updatedWish;
    _state = _state.copyWith(
      wishSaveStatus: SaveStatus.saving,
      wishSaveTargetId: updatedWish.id,
      clearWishDraftError: true,
      clearWishSaveFeedback: true,
    );
    notifyListeners();
    _persistWish(updatedWish);
  }

  void toggleWishDone(String wishId) {
    final index = _wishes.indexWhere((wish) => wish.id == wishId);
    if (index == -1) {
      return;
    }
    final wish = _wishes[index];
    final allowed =
        wish.createdByProfileId == _state.me.id ||
        wish.likedByProfileIds.contains(_state.me.id);
    if (!allowed) {
      _state = _state.copyWith(wishDraftError: '관심 표시한 위시만 함께함으로 옮길 수 있어요.');
      notifyListeners();
      return;
    }
    final updatedWish = wish.copyWith(
      done: !wish.done,
      updatedAt: DateTime.now(),
      updatedByProfileId: _state.me.id,
    );
    _wishes[index] = updatedWish;
    _state = _state.copyWith(
      wishSaveStatus: SaveStatus.saving,
      wishSaveTargetId: updatedWish.id,
      clearWishDraftError: true,
      clearWishSaveFeedback: true,
    );
    notifyListeners();
    _persistWish(updatedWish);
  }

  void deleteWish(String wishId) {
    final index = _wishes.indexWhere((wish) => wish.id == wishId);
    if (index == -1) {
      _state = _state.copyWith(wishDraftError: '삭제할 위시를 찾지 못했어요.');
      notifyListeners();
      return;
    }
    final wish = _wishes[index];
    if (wish.createdByProfileId != _state.me.id) {
      _state = _state.copyWith(wishDraftError: '내가 담은 위시만 삭제할 수 있어요.');
      notifyListeners();
      return;
    }
    _wishes.removeAt(index);
    final wasEditing = _state.editingWishId == wishId;
    _state = _state.copyWith(
      wishDraftVisible: wasEditing ? false : _state.wishDraftVisible,
      wishDraftTitle: wasEditing ? '' : _state.wishDraftTitle,
      wishDraftKind: wasEditing ? WishKind.activity : _state.wishDraftKind,
      wishSaveStatus: SaveStatus.saving,
      wishSaveTargetId: wish.id,
      clearEditingWishId: wasEditing,
      clearWishDraftError: true,
      clearWishSaveFeedback: true,
    );
    notifyListeners();
    _deletePersistedWish(wish, index);
  }

  void retryWishSave() {
    final wish = _lastFailedWish;
    if (wish == null || _state.wishSaveStatus == SaveStatus.saving) {
      return;
    }
    final previousIndex = _wishes.indexWhere(
      (candidate) => candidate.id == wish.id,
    );
    if (_lastFailedWishAction == _FailedPersistenceAction.delete &&
        previousIndex != -1) {
      _wishes.removeAt(previousIndex);
    }
    _state = _state.copyWith(
      wishSaveStatus: SaveStatus.saving,
      wishSaveTargetId: wish.id,
      clearWishDraftError: true,
      clearWishSaveFeedback: true,
    );
    notifyListeners();
    if (_lastFailedWishAction == _FailedPersistenceAction.delete) {
      _deletePersistedWish(wish, previousIndex == -1 ? 0 : previousIndex);
    } else {
      _persistWish(wish);
    }
  }

  String curiosityReplyDraftFor(String cardId) {
    return _state.curiosityReplyDraftsByCardId[cardId] ?? '';
  }

  void startImprovementDraft() {
    _state = _state.copyWith(
      route: AlagagiRoute.improvements,
      improvementDraftVisible: true,
      improvementDraftTitle: '',
      improvementDraftBody: '',
      improvementDraftCategory: improvementPostCategoryOptions.first,
      clearImprovementDraftError: true,
      clearEditingImprovementPostId: true,
      improvementSaveStatus: SaveStatus.idle,
      clearImprovementSaveFeedback: true,
      clearImprovementSaveTargetId: true,
    );
    notifyListeners();
  }

  void startImprovementEdit(String postId) {
    final index = _improvementPosts.indexWhere((post) => post.id == postId);
    if (index == -1) {
      _state = _state.copyWith(
        improvementDraftError: '수정할 건의를 찾지 못했어요.',
        improvementSaveStatus: SaveStatus.failed,
        improvementSaveTargetId: postId,
        clearImprovementSaveFeedback: true,
      );
      notifyListeners();
      return;
    }
    final post = _improvementPosts[index];
    if (post.createdByProfileId != _state.me.id) {
      _state = _state.copyWith(
        improvementDraftError: '내가 남긴 건의만 수정할 수 있어요.',
        improvementSaveStatus: SaveStatus.failed,
        improvementSaveTargetId: postId,
        clearImprovementSaveFeedback: true,
      );
      notifyListeners();
      return;
    }
    _state = _state.copyWith(
      route: AlagagiRoute.improvements,
      improvementDraftVisible: true,
      editingImprovementPostId: post.id,
      improvementDraftTitle: post.title,
      improvementDraftBody: post.body,
      improvementDraftCategory: post.category,
      improvementSaveStatus: SaveStatus.idle,
      clearImprovementDraftError: true,
      clearImprovementSaveFeedback: true,
      clearImprovementSaveTargetId: true,
    );
    notifyListeners();
  }

  void cancelImprovementDraft() {
    _state = _state.copyWith(
      improvementDraftVisible: false,
      improvementDraftTitle: '',
      improvementDraftBody: '',
      improvementDraftCategory: improvementPostCategoryOptions.first,
      clearImprovementDraftError: true,
      clearEditingImprovementPostId: true,
    );
    notifyListeners();
  }

  void updateImprovementDraft({String? title, String? body, String? category}) {
    _state = _state.copyWith(
      improvementDraftTitle: title,
      improvementDraftBody: body,
      improvementDraftCategory: category,
      improvementSaveStatus: SaveStatus.idle,
      clearImprovementDraftError: true,
      clearImprovementSaveFeedback: true,
      clearImprovementSaveTargetId: true,
    );
    notifyListeners();
  }

  void submitImprovementDraft() {
    if (_state.improvementSaveStatus == SaveStatus.saving) {
      return;
    }
    final title = _state.improvementDraftTitle.trim();
    final body = _state.improvementDraftBody.trim();
    final category = _state.improvementDraftCategory.trim();

    String? error;
    if (title.length < 2) {
      error = '제목은 두 글자 이상 남겨주세요.';
    } else if (title.length > 50) {
      error = '제목은 50자 안으로 남겨주세요.';
    } else if (body.length < 4) {
      error = '내용은 네 글자 이상 남겨주세요.';
    } else if (body.length > 300) {
      error = '내용은 300자 안으로 남겨주세요.';
    } else if (!improvementPostCategoryOptions.contains(category)) {
      error = '분류를 다시 골라주세요.';
    }
    if (error != null) {
      _state = _state.copyWith(
        improvementDraftError: error,
        improvementSaveStatus: SaveStatus.idle,
        clearImprovementSaveFeedback: true,
      );
      notifyListeners();
      return;
    }

    final editingId = _state.editingImprovementPostId;
    final editingIndex = editingId == null
        ? -1
        : _improvementPosts.indexWhere((post) => post.id == editingId);
    if (editingId != null) {
      if (editingIndex == -1) {
        _state = _state.copyWith(
          improvementDraftError: '수정할 건의를 찾지 못했어요.',
          improvementSaveStatus: SaveStatus.failed,
          improvementSaveTargetId: editingId,
          clearImprovementSaveFeedback: true,
        );
        notifyListeners();
        return;
      }
      if (_improvementPosts[editingIndex].createdByProfileId != _state.me.id) {
        _state = _state.copyWith(
          improvementDraftError: '내가 남긴 건의만 수정할 수 있어요.',
          improvementSaveStatus: SaveStatus.failed,
          improvementSaveTargetId: editingId,
          clearImprovementSaveFeedback: true,
        );
        notifyListeners();
        return;
      }
    }

    final now = DateTime.now();
    final ImprovementPost post;
    final String successFeedback;
    if (editingIndex == -1) {
      post = ImprovementPost(
        id: 'improvement_${_state.me.id}_${now.microsecondsSinceEpoch}',
        title: title,
        body: body,
        category: category,
        createdByProfileId: _state.me.id,
        createdLabel: '오늘',
        updatedAt: now,
      );
      _improvementPosts.insert(0, post);
      successFeedback = '건의를 남겼어요.';
    } else {
      post = _improvementPosts[editingIndex].copyWith(
        title: title,
        body: body,
        category: category,
        updatedAt: now,
      );
      _improvementPosts[editingIndex] = post;
      successFeedback = '건의를 수정했어요.';
    }
    _sortImprovementPostsByUpdatedAt();
    _lastFailedImprovementPost = null;
    _state = _state.copyWith(
      improvementDraftVisible: false,
      improvementDraftTitle: '',
      improvementDraftBody: '',
      improvementDraftCategory: improvementPostCategoryOptions.first,
      improvementSaveStatus: SaveStatus.saving,
      improvementSaveTargetId: post.id,
      clearImprovementDraftError: true,
      clearEditingImprovementPostId: true,
      clearImprovementSaveFeedback: true,
    );
    notifyListeners();
    _persistImprovementPost(post, successFeedback: successFeedback);
  }

  void saveImprovementOwnerNote(String postId, String value) {
    if (!canManageImprovementPosts) {
      _state = _state.copyWith(
        improvementDraftError: '영우만 개선 답변을 남길 수 있어요.',
        improvementSaveStatus: SaveStatus.failed,
        improvementSaveTargetId: postId,
        clearImprovementSaveFeedback: true,
      );
      notifyListeners();
      return;
    }
    final index = _improvementPosts.indexWhere((post) => post.id == postId);
    if (index == -1) {
      _state = _state.copyWith(
        improvementDraftError: '답변할 건의를 찾지 못했어요.',
        improvementSaveStatus: SaveStatus.failed,
        improvementSaveTargetId: postId,
        clearImprovementSaveFeedback: true,
      );
      notifyListeners();
      return;
    }
    final note = value.trim();
    if (note.isEmpty) {
      _state = _state.copyWith(
        improvementDraftError: '남길 답변을 한 줄만 적어주세요.',
        improvementSaveStatus: SaveStatus.idle,
        improvementSaveTargetId: postId,
        clearImprovementSaveFeedback: true,
      );
      notifyListeners();
      return;
    }
    if (note.length > 160) {
      _state = _state.copyWith(
        improvementDraftError: '답변은 160자 안으로 남겨주세요.',
        improvementSaveStatus: SaveStatus.idle,
        improvementSaveTargetId: postId,
        clearImprovementSaveFeedback: true,
      );
      notifyListeners();
      return;
    }
    final updatedPost = _improvementPosts[index].copyWith(
      ownerNote: note,
      ownerNoteProfileId: _state.me.id,
      ownerNoteLabel: '오늘',
      updatedAt: DateTime.now(),
    );
    _improvementPosts[index] = updatedPost;
    _sortImprovementPostsByUpdatedAt();
    _lastFailedImprovementPost = null;
    _state = _state.copyWith(
      improvementSaveStatus: SaveStatus.saving,
      improvementSaveTargetId: updatedPost.id,
      clearImprovementDraftError: true,
      clearImprovementSaveFeedback: true,
    );
    notifyListeners();
    _persistImprovementPost(updatedPost, successFeedback: '답변을 저장했어요.');
  }

  void toggleImprovementResolved(String postId) {
    if (!canManageImprovementPosts) {
      _state = _state.copyWith(
        improvementDraftError: '영우만 개선 완료를 처리할 수 있어요.',
        improvementSaveStatus: SaveStatus.failed,
        improvementSaveTargetId: postId,
        clearImprovementSaveFeedback: true,
      );
      notifyListeners();
      return;
    }
    final index = _improvementPosts.indexWhere((post) => post.id == postId);
    if (index == -1) {
      _state = _state.copyWith(
        improvementDraftError: '처리할 건의를 찾지 못했어요.',
        improvementSaveStatus: SaveStatus.failed,
        improvementSaveTargetId: postId,
        clearImprovementSaveFeedback: true,
      );
      notifyListeners();
      return;
    }
    final post = _improvementPosts[index];
    final nextResolved = !post.resolved;
    final updatedPost = post.copyWith(
      resolved: nextResolved,
      resolvedByProfileId: nextResolved ? _state.me.id : '',
      resolvedLabel: nextResolved ? '오늘' : '',
      updatedAt: DateTime.now(),
    );
    _improvementPosts[index] = updatedPost;
    _sortImprovementPostsByUpdatedAt();
    _lastFailedImprovementPost = null;
    _state = _state.copyWith(
      improvementSaveStatus: SaveStatus.saving,
      improvementSaveTargetId: updatedPost.id,
      clearImprovementDraftError: true,
      clearImprovementSaveFeedback: true,
    );
    notifyListeners();
    _persistImprovementPost(
      updatedPost,
      successFeedback: nextResolved ? '개선완료로 옮겼어요.' : '진행중으로 돌렸어요.',
    );
  }

  void deleteImprovementPost(String postId) {
    final index = _improvementPosts.indexWhere((post) => post.id == postId);
    if (index == -1) {
      _state = _state.copyWith(
        improvementDraftError: '삭제할 건의를 찾지 못했어요.',
        improvementSaveStatus: SaveStatus.failed,
        improvementSaveTargetId: postId,
        clearImprovementSaveFeedback: true,
      );
      notifyListeners();
      return;
    }
    final post = _improvementPosts[index];
    if (post.createdByProfileId != _state.me.id) {
      _state = _state.copyWith(
        improvementDraftError: '내가 남긴 건의만 삭제할 수 있어요.',
        improvementSaveStatus: SaveStatus.failed,
        improvementSaveTargetId: postId,
        clearImprovementSaveFeedback: true,
      );
      notifyListeners();
      return;
    }
    _improvementPosts.removeAt(index);
    final wasEditing = _state.editingImprovementPostId == postId;
    _state = _state.copyWith(
      improvementDraftVisible: wasEditing
          ? false
          : _state.improvementDraftVisible,
      improvementDraftTitle: wasEditing ? '' : _state.improvementDraftTitle,
      improvementDraftBody: wasEditing ? '' : _state.improvementDraftBody,
      improvementDraftCategory: wasEditing
          ? improvementPostCategoryOptions.first
          : _state.improvementDraftCategory,
      improvementSaveStatus: SaveStatus.saving,
      improvementSaveTargetId: post.id,
      clearImprovementDraftError: true,
      clearEditingImprovementPostId: wasEditing,
      clearImprovementSaveFeedback: true,
    );
    notifyListeners();
    _deletePersistedImprovementPost(post, index);
  }

  void retryImprovementSave() {
    final post = _lastFailedImprovementPost;
    if (post == null || _state.improvementSaveStatus == SaveStatus.saving) {
      return;
    }
    _state = _state.copyWith(
      improvementSaveStatus: SaveStatus.saving,
      improvementSaveTargetId: post.id,
      clearImprovementDraftError: true,
      clearImprovementSaveFeedback: true,
    );
    notifyListeners();
    _persistImprovementPost(post);
  }

  bool isCuriositySaveTarget(String cardId) {
    return _state.curiositySaveTargetId == cardId;
  }

  void updateCuriosityQuestionDraft(String value) {
    _state = _state.copyWith(
      curiosityQuestionDraft: value,
      curiositySaveStatus: SaveStatus.idle,
      clearCuriosityError: true,
      clearCuriositySaveFeedback: true,
      clearCuriositySaveTargetId: true,
    );
    notifyListeners();
  }

  void updateCuriosityReplyDraft({
    required String cardId,
    required String value,
  }) {
    final drafts = Map<String, String>.of(_state.curiosityReplyDraftsByCardId)
      ..[cardId] = value;
    _state = _state.copyWith(
      curiosityReplyDraftsByCardId: Map<String, String>.unmodifiable(drafts),
      curiositySaveStatus: SaveStatus.idle,
      clearCuriosityError: true,
      clearCuriositySaveFeedback: true,
      clearCuriositySaveTargetId: true,
    );
    notifyListeners();
  }

  void submitCuriosityQuestion() {
    if (_state.curiositySaveStatus == SaveStatus.saving) {
      return;
    }
    if (hasPendingSentCuriosityCard) {
      _state = _state.copyWith(
        curiosityError: '먼저 보낸 질문의 답장을 기다리는 중이에요.',
        curiositySaveStatus: SaveStatus.idle,
        clearCuriositySaveFeedback: true,
        clearCuriositySaveTargetId: true,
      );
      notifyListeners();
      return;
    }
    final question = _state.curiosityQuestionDraft.trim();
    if (question.isEmpty) {
      _state = _state.copyWith(
        curiosityError: '궁금한 걸 한 줄만 남겨도 괜찮아요.',
        curiositySaveStatus: SaveStatus.idle,
        clearCuriositySaveFeedback: true,
      );
      notifyListeners();
      return;
    }
    if (question.length > 80) {
      _state = _state.copyWith(
        curiosityError: '질문은 80자 안으로 남겨주세요.',
        curiositySaveStatus: SaveStatus.idle,
        clearCuriositySaveFeedback: true,
      );
      notifyListeners();
      return;
    }

    final now = DateTime.now();
    final card = CuriosityCard(
      id: 'curiosity_${_state.me.id}_${now.microsecondsSinceEpoch}',
      fromProfileId: _state.me.id,
      toProfileId: _state.partner.id,
      question: question,
      createdLabel: '오늘',
      updatedAt: now,
      updatedByProfileId: _state.me.id,
    );
    _curiosityCards.insert(0, card);
    _sortCuriosityCardsByUpdatedAt();
    _lastFailedCuriosityCard = null;
    _state = _state.copyWith(
      curiosityQuestionDraft: '',
      curiositySaveStatus: SaveStatus.saving,
      curiositySaveTargetId: card.id,
      clearCuriosityError: true,
      clearCuriositySaveFeedback: true,
    );
    notifyListeners();
    _persistCuriosityCard(card);
  }

  void submitCuriosityReply(String cardId) {
    if (_state.curiositySaveStatus == SaveStatus.saving) {
      return;
    }
    final index = _curiosityCards.indexWhere((card) => card.id == cardId);
    if (index == -1) {
      _state = _state.copyWith(
        curiosityError: '답장할 질문을 찾지 못했어요.',
        curiositySaveStatus: SaveStatus.idle,
        clearCuriositySaveFeedback: true,
      );
      notifyListeners();
      return;
    }
    final card = _curiosityCards[index];
    if (card.toProfileId != _state.me.id) {
      _state = _state.copyWith(
        curiosityError: '받은 질문에만 답장할 수 있어요.',
        curiositySaveStatus: SaveStatus.idle,
        clearCuriositySaveFeedback: true,
      );
      notifyListeners();
      return;
    }
    final reply = curiosityReplyDraftFor(cardId).trim();
    if (reply.isEmpty) {
      _state = _state.copyWith(
        curiosityError: '짧게라도 답장을 남겨주세요.',
        curiositySaveStatus: SaveStatus.idle,
        clearCuriositySaveFeedback: true,
      );
      notifyListeners();
      return;
    }
    if (reply.length > 160) {
      _state = _state.copyWith(
        curiosityError: '답장은 160자 안으로 남겨주세요.',
        curiositySaveStatus: SaveStatus.idle,
        clearCuriositySaveFeedback: true,
      );
      notifyListeners();
      return;
    }

    final updatedCard = card.copyWith(
      reply: reply,
      repliedLabel: card.repliedLabel ?? '오늘',
      updatedAt: DateTime.now(),
      updatedByProfileId: _state.me.id,
    );
    _curiosityCards[index] = updatedCard;
    _sortCuriosityCardsByUpdatedAt();
    _lastFailedCuriosityCard = null;
    final drafts = Map<String, String>.of(_state.curiosityReplyDraftsByCardId)
      ..remove(cardId);
    _state = _state.copyWith(
      curiosityReplyDraftsByCardId: Map<String, String>.unmodifiable(drafts),
      curiositySaveStatus: SaveStatus.saving,
      curiositySaveTargetId: cardId,
      clearCuriosityError: true,
      clearCuriositySaveFeedback: true,
    );
    notifyListeners();
    _persistCuriosityCard(updatedCard);
  }

  void retryCuriositySave() {
    final card = _lastFailedCuriosityCard;
    if (card == null || _state.curiositySaveStatus == SaveStatus.saving) {
      return;
    }
    _state = _state.copyWith(
      curiositySaveStatus: SaveStatus.saving,
      curiositySaveTargetId: card.id,
      clearCuriosityError: true,
      clearCuriositySaveFeedback: true,
    );
    notifyListeners();
    _persistCuriosityCard(card);
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
      clearMusicSaveFeedback: true,
      clearMusicSaveTargetId: true,
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
      clearMusicSaveFeedback: true,
      clearMusicSaveTargetId: true,
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
      clearMusicSaveFeedback: true,
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
      clearMusicSaveFeedback: true,
      clearMusicSaveTargetId: true,
    );
    notifyListeners();
  }

  void setMusicListFilter(MusicListFilter filter) {
    if (_state.musicListFilter == filter) {
      return;
    }
    _state = _state.copyWith(musicListFilter: filter);
    notifyListeners();
  }

  void setMusicDraftMood(String mood) {
    _state = _state.copyWith(
      musicDraftMood: mood,
      clearMusicDraftError: true,
      clearMusicSaveFeedback: true,
      clearMusicSaveTargetId: true,
    );
    notifyListeners();
  }

  void toggleMusicNoteListened(String noteId) {
    final noteIndex = _musicNotes.indexWhere((note) => note.id == noteId);
    if (noteIndex == -1) {
      return;
    }
    final note = _musicNotes[noteIndex];
    final listenedBy = Set<String>.from(note.listenedByProfileIds);
    if (!listenedBy.add(_state.me.id)) {
      listenedBy.remove(_state.me.id);
    }
    final updatedNote = note.copyWith(
      listenedByProfileIds: Set<String>.unmodifiable(listenedBy),
    );
    _musicNotes[noteIndex] = updatedNote;
    notifyListeners();
    _persistMusicNoteListenState(updatedNote);
  }

  void submitMusicDraft() {
    final title = _state.musicDraftTitle.trim();
    final artist = _state.musicDraftArtist.trim();
    final link = _state.musicDraftLink.trim();
    final noteBody = _state.musicDraftNote.trim();
    final mood = _state.musicDraftMood.trim();
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
    if (mood.isEmpty) {
      _state = _state.copyWith(musicDraftError: '분위기를 한 단어로 남겨주세요.');
      notifyListeners();
      return;
    }
    if (mood.length > 16) {
      _state = _state.copyWith(musicDraftError: '분위기는 16자 안으로 남겨주세요.');
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
      _state = _state.copyWith(
        musicDraftVisible: false,
        musicDraftTitle: '',
        musicDraftArtist: '',
        musicDraftLink: '',
        musicDraftNote: '',
        musicDraftMood: musicMoodOptions.first,
        musicSaveStatus: SaveStatus.saving,
        musicSaveTargetId: updatedNote.id,
        clearEditingMusicNoteId: true,
        clearMusicDraftError: true,
        clearMusicSaveFeedback: true,
      );
      notifyListeners();
      _persistMusicNote(updatedNote);
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
      listenedByProfileIds: {_state.me.id},
      updatedAt: now,
    );
    _musicNotes.insert(0, note);
    _sortMusicNotesByUpdatedAt();
    _state = _state.copyWith(
      musicDraftVisible: false,
      musicDraftTitle: '',
      musicDraftArtist: '',
      musicDraftLink: '',
      musicDraftNote: '',
      musicDraftMood: musicMoodOptions.first,
      musicSaveStatus: SaveStatus.saving,
      musicSaveTargetId: note.id,
      clearEditingMusicNoteId: true,
      clearMusicDraftError: true,
      clearMusicSaveFeedback: true,
    );
    notifyListeners();
    _persistMusicNote(note);
  }

  void deleteMusicNote(String noteId) {
    final index = _musicNotes.indexWhere((note) => note.id == noteId);
    if (index == -1) {
      _state = _state.copyWith(musicDraftError: '삭제할 음악 노트를 찾지 못했어요.');
      notifyListeners();
      return;
    }
    final note = _musicNotes[index];
    if (note.createdByProfileId != _state.me.id) {
      _state = _state.copyWith(musicDraftError: '내가 남긴 음악 노트만 삭제할 수 있어요.');
      notifyListeners();
      return;
    }
    _musicNotes.removeAt(index);
    final wasEditing = _state.editingMusicNoteId == noteId;
    _state = _state.copyWith(
      musicDraftVisible: wasEditing ? false : _state.musicDraftVisible,
      musicDraftTitle: wasEditing ? '' : _state.musicDraftTitle,
      musicDraftArtist: wasEditing ? '' : _state.musicDraftArtist,
      musicDraftLink: wasEditing ? '' : _state.musicDraftLink,
      musicDraftNote: wasEditing ? '' : _state.musicDraftNote,
      musicDraftMood: wasEditing
          ? musicMoodOptions.first
          : _state.musicDraftMood,
      musicSaveStatus: SaveStatus.saving,
      musicSaveTargetId: note.id,
      clearEditingMusicNoteId: wasEditing,
      clearMusicDraftError: true,
      clearMusicSaveFeedback: true,
    );
    notifyListeners();
    _deletePersistedMusicNote(note, index);
  }

  void retryMusicSave() {
    final note = _lastFailedMusicNote;
    if (note == null || _state.musicSaveStatus == SaveStatus.saving) {
      return;
    }
    final previousIndex = _musicNotes.indexWhere(
      (candidate) => candidate.id == note.id,
    );
    if (_lastFailedMusicNoteAction == _FailedPersistenceAction.delete &&
        previousIndex != -1) {
      _musicNotes.removeAt(previousIndex);
      _sortMusicNotesByUpdatedAt();
    }
    _state = _state.copyWith(
      musicSaveStatus: SaveStatus.saving,
      musicSaveTargetId: note.id,
      clearMusicDraftError: true,
      clearMusicSaveFeedback: true,
    );
    notifyListeners();
    if (_lastFailedMusicNoteAction == _FailedPersistenceAction.delete) {
      _deletePersistedMusicNote(note, previousIndex == -1 ? 0 : previousIndex);
    } else {
      _persistMusicNote(note);
    }
  }

  void selectMeetingDate(String dateKey) {
    final entry = scheduleEntryFor(_state.me.id, dateKey);
    final meetingDayEntry = meetingDayEntryFor(dateKey);
    _state = _state.copyWith(
      selectedMeetingDateKey: dateKey,
      meetingDraftAvailability:
          entry?.availability ?? MeetingAvailability.available,
      meetingDraftTimeSlots:
          entry?.timeSlots ?? const {MeetingTimeSlot.evening},
      meetingDraftTimeBlocks: entry?.timeBlocks ?? const [],
      meetingBlockStartDraft: '',
      meetingBlockEndDraft: '',
      meetingBlockTitleDraft: '',
      meetingDraftSharedMemo: entry?.sharedMemo ?? '',
      meetingDraftIsMeetingDay:
          entry?.isMeetingDay ?? meetingDayEntry?.isMeetingDay ?? false,
      meetingDraftMeetingTimeLabel:
          entry?.meetingTimeLabel ?? meetingDayEntry?.meetingTimeLabel ?? '',
      meetingDraftMeetingNote:
          entry?.meetingNote ?? meetingDayEntry?.meetingNote ?? '',
      meetingDraftMeetingPlanText: _meetingPlanTextFromItems(
        meetingPlanItemsFor(dateKey),
      ),
      clearMeetingDraftError: true,
      clearMeetingSaveFeedback: true,
      clearMeetingSaveTargetId: true,
    );
    notifyListeners();
  }

  void setMeetingAvailability(MeetingAvailability availability) {
    final timeSlots = availability == MeetingAvailability.busy
        ? <MeetingTimeSlot>{}
        : _state.meetingDraftTimeSlots.isEmpty
        ? {MeetingTimeSlot.evening}
        : _state.meetingDraftTimeSlots;
    _state = _state.copyWith(
      meetingDraftAvailability: availability,
      meetingDraftTimeSlots: timeSlots,
      clearMeetingDraftError: true,
      clearMeetingSaveFeedback: true,
    );
    notifyListeners();
  }

  void toggleMeetingTimeSlot(MeetingTimeSlot slot) {
    final slots = Set<MeetingTimeSlot>.from(_state.meetingDraftTimeSlots);
    if (slots.contains(slot)) {
      slots.remove(slot);
    } else {
      slots.add(slot);
    }
    _state = _state.copyWith(
      meetingDraftAvailability: slots.isEmpty
          ? MeetingAvailability.busy
          : _state.meetingDraftAvailability == MeetingAvailability.busy
          ? MeetingAvailability.available
          : _state.meetingDraftAvailability,
      meetingDraftTimeSlots: Set<MeetingTimeSlot>.unmodifiable(slots),
      clearMeetingDraftError: true,
      clearMeetingSaveFeedback: true,
    );
    notifyListeners();
  }

  void updateMeetingTimeBlockDraft({
    String? start,
    String? end,
    String? title,
  }) {
    _state = _state.copyWith(
      meetingBlockStartDraft: start,
      meetingBlockEndDraft: end,
      meetingBlockTitleDraft: title,
      clearMeetingDraftError: true,
      clearMeetingSaveFeedback: true,
    );
    notifyListeners();
  }

  void addMeetingTimeBlock() {
    final start = _parseMeetingTimeInput(_state.meetingBlockStartDraft);
    final end = _parseMeetingTimeInput(_state.meetingBlockEndDraft);
    final title = _state.meetingBlockTitleDraft.trim();
    if (start == null || end == null) {
      _state = _state.copyWith(meetingDraftError: '시간은 14:00처럼 적어주세요.');
      notifyListeners();
      return;
    }
    if (end <= start) {
      _state = _state.copyWith(meetingDraftError: '끝나는 시간은 시작 시간보다 늦어야 해요.');
      notifyListeners();
      return;
    }
    if (title.isEmpty) {
      _state = _state.copyWith(meetingDraftError: '무슨 일정인지 한 줄로 적어주세요.');
      notifyListeners();
      return;
    }
    if (title.length > 40) {
      _state = _state.copyWith(meetingDraftError: '일정 이름은 40자 안으로 남겨주세요.');
      notifyListeners();
      return;
    }
    if (_state.meetingDraftTimeBlocks.length >= 6) {
      _state = _state.copyWith(meetingDraftError: '하루 일정은 6개까지만 남길 수 있어요.');
      notifyListeners();
      return;
    }

    final blocks = [
      ..._state.meetingDraftTimeBlocks,
      ScheduleTimeBlock(startMinute: start, endMinute: end, title: title),
    ]..sort((a, b) => a.startMinute.compareTo(b.startMinute));
    _state = _state.copyWith(
      meetingDraftTimeBlocks: List<ScheduleTimeBlock>.unmodifiable(blocks),
      meetingBlockStartDraft: '',
      meetingBlockEndDraft: '',
      meetingBlockTitleDraft: '',
      clearMeetingDraftError: true,
      clearMeetingSaveFeedback: true,
    );
    notifyListeners();
  }

  void removeMeetingTimeBlock(String blockId) {
    final blocks = _state.meetingDraftTimeBlocks
        .where((block) => block.id != blockId)
        .toList(growable: false);
    _state = _state.copyWith(
      meetingDraftTimeBlocks: List<ScheduleTimeBlock>.unmodifiable(blocks),
      clearMeetingDraftError: true,
      clearMeetingSaveFeedback: true,
    );
    notifyListeners();
  }

  void updateMeetingDraft({String? sharedMemo}) {
    _state = _state.copyWith(
      meetingDraftSharedMemo: sharedMemo,
      clearMeetingDraftError: true,
      clearMeetingSaveFeedback: true,
    );
    notifyListeners();
  }

  void updateMeetingDayDraft({
    String? timeLabel,
    String? note,
    String? planText,
  }) {
    _state = _state.copyWith(
      meetingDraftMeetingTimeLabel: timeLabel,
      meetingDraftMeetingNote: note,
      meetingDraftMeetingPlanText: planText,
      clearMeetingDraftError: true,
      clearMeetingSaveFeedback: true,
    );
    notifyListeners();
  }

  void selectMeetingPlanDate(String dateKey) {
    _state = _state.copyWith(
      selectedMeetingPlanDateKey: dateKey,
      meetingPlanDraftText: _meetingPlanTextFromItems(
        meetingPlanItemsFor(dateKey),
      ),
      meetingPlanItemDraft: '',
      clearEditingMeetingPlanItemIndex: true,
      clearMeetingDraftError: true,
      clearMeetingSaveFeedback: true,
      clearMeetingSaveTargetId: true,
    );
    notifyListeners();
  }

  void updateMeetingPlanDraft(String value) {
    _state = _state.copyWith(
      meetingPlanDraftText: value,
      clearEditingMeetingPlanItemIndex: true,
      clearMeetingDraftError: true,
      clearMeetingSaveFeedback: true,
    );
    notifyListeners();
  }

  void updateMeetingPlanItemDraft(String value) {
    _state = _state.copyWith(
      meetingPlanItemDraft: value,
      clearMeetingDraftError: true,
      clearMeetingSaveFeedback: true,
    );
    notifyListeners();
  }

  void addMeetingPlanDraftItem() {
    final item = _state.meetingPlanItemDraft.trim();
    if (item.isEmpty) {
      _state = _state.copyWith(meetingDraftError: '추가할 내용을 한 줄로 적어주세요.');
      notifyListeners();
      return;
    }
    if (item.length > 40) {
      _state = _state.copyWith(meetingDraftError: '할 일은 한 줄에 40자 안으로 남겨주세요.');
      notifyListeners();
      return;
    }
    final items = meetingPlanDraftItems;
    final editingIndex = _state.editingMeetingPlanItemIndex;
    final nextItems = [...items];
    if (editingIndex == null) {
      nextItems.add(item);
    } else if (editingIndex < 0 || editingIndex >= nextItems.length) {
      _state = _state.copyWith(
        meetingDraftError: '수정할 계획을 찾지 못했어요.',
        clearEditingMeetingPlanItemIndex: true,
      );
      notifyListeners();
      return;
    } else {
      nextItems[editingIndex] = item;
    }
    _state = _state.copyWith(
      meetingPlanDraftText: _meetingPlanTextFromItems(nextItems),
      meetingPlanItemDraft: '',
      clearEditingMeetingPlanItemIndex: true,
      clearMeetingDraftError: true,
      clearMeetingSaveFeedback: true,
    );
    notifyListeners();
  }

  void startEditingMeetingPlanDraftItem(int index) {
    final items = meetingPlanDraftItems;
    if (index < 0 || index >= items.length) {
      return;
    }
    _state = _state.copyWith(
      meetingPlanItemDraft: items[index],
      editingMeetingPlanItemIndex: index,
      clearMeetingDraftError: true,
      clearMeetingSaveFeedback: true,
    );
    notifyListeners();
  }

  void cancelEditingMeetingPlanDraftItem() {
    if (_state.editingMeetingPlanItemIndex == null &&
        _state.meetingPlanItemDraft.isEmpty) {
      return;
    }
    _state = _state.copyWith(
      meetingPlanItemDraft: '',
      clearEditingMeetingPlanItemIndex: true,
      clearMeetingDraftError: true,
      clearMeetingSaveFeedback: true,
    );
    notifyListeners();
  }

  void removeMeetingPlanDraftItem(int index) {
    final items = meetingPlanDraftItems;
    if (index < 0 || index >= items.length) {
      return;
    }
    final nextItems = [...items]..removeAt(index);
    final editingIndex = _state.editingMeetingPlanItemIndex;
    final removedEditingItem = editingIndex == index;
    final adjustedEditingIndex = editingIndex != null && index < editingIndex
        ? editingIndex - 1
        : editingIndex;
    _state = _state.copyWith(
      meetingPlanDraftText: _meetingPlanTextFromItems(nextItems),
      meetingPlanItemDraft: removedEditingItem
          ? ''
          : _state.meetingPlanItemDraft,
      editingMeetingPlanItemIndex: adjustedEditingIndex,
      clearEditingMeetingPlanItemIndex: removedEditingItem,
      clearMeetingDraftError: true,
      clearMeetingSaveFeedback: true,
    );
    notifyListeners();
  }

  void reorderMeetingPlanDraftItem(int oldIndex, int newIndex) {
    final items = [...meetingPlanDraftItems];
    if (oldIndex < 0 || oldIndex >= items.length || items.length < 2) {
      return;
    }
    var targetIndex = newIndex;
    if (targetIndex > oldIndex) {
      targetIndex -= 1;
    }
    targetIndex = targetIndex.clamp(0, items.length - 1).toInt();
    if (oldIndex == targetIndex) {
      return;
    }

    final movedItem = items.removeAt(oldIndex);
    items.insert(targetIndex, movedItem);

    final editingIndex = _state.editingMeetingPlanItemIndex;
    int? nextEditingIndex = editingIndex;
    if (editingIndex != null) {
      if (editingIndex == oldIndex) {
        nextEditingIndex = targetIndex;
      } else if (oldIndex < editingIndex && editingIndex <= targetIndex) {
        nextEditingIndex = editingIndex - 1;
      } else if (targetIndex <= editingIndex && editingIndex < oldIndex) {
        nextEditingIndex = editingIndex + 1;
      }
    }

    _state = _state.copyWith(
      meetingPlanDraftText: _meetingPlanTextFromItems(items),
      editingMeetingPlanItemIndex: nextEditingIndex,
      clearEditingMeetingPlanItemIndex: nextEditingIndex == null,
      clearMeetingDraftError: true,
      clearMeetingSaveFeedback: true,
    );
    notifyListeners();
  }

  void submitMeetingPlanDraft() {
    if (_state.meetingSaveStatus == SaveStatus.saving) {
      return;
    }
    final dateKey = selectedMeetingPlanDateKey;
    final meetingDayEntry = meetingDayEntryFor(dateKey);
    if (meetingDayEntry == null) {
      _state = _state.copyWith(meetingDraftError: '먼저 약속에서 만나는 날을 정해주세요.');
      notifyListeners();
      return;
    }
    final meetingPlanItems = _parseMeetingPlanItems(
      _state.meetingPlanDraftText,
    );
    if (meetingPlanItems.any((item) => item.length > 40)) {
      _state = _state.copyWith(meetingDraftError: '할 일은 한 줄에 40자 안으로 남겨주세요.');
      notifyListeners();
      return;
    }
    final plan = MeetingPlan(
      dateKey: dateKey,
      items: List<String>.unmodifiable(meetingPlanItems),
      updatedByProfileId: _state.me.id,
      updatedAt: DateTime.now(),
    );
    _upsertMeetingPlan(plan);
    _lastFailedMeetingPlan = null;
    _state = _state.copyWith(
      selectedMeetingPlanDateKey: dateKey,
      meetingPlanDraftText: _meetingPlanTextFromItems(meetingPlanItems),
      meetingPlanItemDraft: '',
      clearEditingMeetingPlanItemIndex: true,
      meetingDraftMeetingPlanText: dateKey == selectedMeetingDateKey
          ? _meetingPlanTextFromItems(meetingPlanItems)
          : _state.meetingDraftMeetingPlanText,
      meetingSaveStatus: SaveStatus.saving,
      meetingSaveTargetId: plan.id,
      clearMeetingDraftError: true,
      clearMeetingSaveFeedback: true,
    );
    notifyListeners();
    _persistMeetingPlan(plan, successFeedback: '만남 계획을 저장했어요.');
  }

  void submitMeetingDayDraft() {
    _submitMeetingDraft(
      markAsMeetingDay: true,
      successFeedback: '만나는 날로 저장했어요.',
    );
  }

  void submitMeetingDraft() {
    _submitMeetingDraft(successFeedback: '일정을 저장했어요.');
  }

  void _submitMeetingDraft({
    bool markAsMeetingDay = false,
    required String successFeedback,
  }) {
    if (_state.meetingSaveStatus == SaveStatus.saving) {
      return;
    }
    final sharedMemo = _state.meetingDraftSharedMemo.trim();
    final availability = _state.meetingDraftAvailability;
    final timeBlocks = _state.meetingDraftTimeBlocks;
    final meetingTimeLabel = _state.meetingDraftMeetingTimeLabel.trim();
    final meetingNote = _state.meetingDraftMeetingNote.trim();
    final meetingPlanItems = _parseMeetingPlanItems(
      _state.meetingDraftMeetingPlanText,
    );
    final isMeetingDay = markAsMeetingDay || _state.meetingDraftIsMeetingDay;
    final timeSlots = availability == MeetingAvailability.busy
        ? <MeetingTimeSlot>{}
        : _state.meetingDraftTimeSlots;
    if (sharedMemo.length > 120) {
      _state = _state.copyWith(
        meetingDraftError: '상대에게 남길 한마디는 120자 안으로 남겨주세요.',
      );
      notifyListeners();
      return;
    }
    if (availability != MeetingAvailability.busy && timeSlots.isEmpty) {
      _state = _state.copyWith(meetingDraftError: '가능한 시간대를 하나 골라주세요.');
      notifyListeners();
      return;
    }
    if (meetingTimeLabel.length > 40) {
      _state = _state.copyWith(meetingDraftError: '만나는 시간은 40자 안으로 남겨주세요.');
      notifyListeners();
      return;
    }
    if (meetingNote.length > 80) {
      _state = _state.copyWith(meetingDraftError: '만나는 날 메모는 80자 안으로 남겨주세요.');
      notifyListeners();
      return;
    }
    if (meetingPlanItems.any((item) => item.length > 40)) {
      _state = _state.copyWith(meetingDraftError: '할 일은 한 줄에 40자 안으로 남겨주세요.');
      notifyListeners();
      return;
    }
    final entry = ScheduleEntry(
      dateKey: selectedMeetingDateKey,
      profileId: _state.me.id,
      availability: availability,
      timeSlots: Set<MeetingTimeSlot>.unmodifiable(timeSlots),
      sharedMemo: sharedMemo,
      timeBlocks: List<ScheduleTimeBlock>.unmodifiable(timeBlocks),
      isMeetingDay: isMeetingDay,
      meetingTimeLabel: isMeetingDay ? meetingTimeLabel : '',
      meetingNote: isMeetingDay ? meetingNote : '',
      meetingPlanItems: const [],
      updatedAt: DateTime.now(),
    );
    final sharedPlan = isMeetingDay && meetingPlanItems.isNotEmpty
        ? MeetingPlan(
            dateKey: selectedMeetingDateKey,
            items: List<String>.unmodifiable(meetingPlanItems),
            updatedByProfileId: _state.me.id,
            updatedAt: DateTime.now(),
          )
        : null;
    final index = _scheduleEntries.indexWhere(
      (candidate) => candidate.id == entry.id,
    );
    if (index == -1) {
      _scheduleEntries.add(entry);
    } else {
      _scheduleEntries[index] = entry;
    }
    _sortScheduleEntriesByDate();
    _lastFailedScheduleEntry = null;
    if (sharedPlan != null) {
      _upsertMeetingPlan(sharedPlan);
      _lastFailedMeetingPlan = null;
    }
    _state = _state.copyWith(
      meetingDraftIsMeetingDay: isMeetingDay,
      meetingDraftMeetingTimeLabel: isMeetingDay ? meetingTimeLabel : '',
      meetingDraftMeetingNote: isMeetingDay ? meetingNote : '',
      meetingDraftMeetingPlanText: isMeetingDay
          ? _meetingPlanTextFromItems(meetingPlanItems)
          : '',
      meetingSaveStatus: SaveStatus.saving,
      meetingSaveTargetId: entry.id,
      clearMeetingDraftError: true,
      clearMeetingSaveFeedback: true,
    );
    notifyListeners();
    _persistScheduleEntry(entry, successFeedback: successFeedback);
    if (sharedPlan != null) {
      _persistMeetingPlan(sharedPlan, successFeedback: successFeedback);
    }
  }

  void retryMeetingSave() {
    final plan = _lastFailedMeetingPlan;
    if (plan != null) {
      if (_state.meetingSaveStatus == SaveStatus.saving) {
        return;
      }
      _upsertMeetingPlan(plan);
      _state = _state.copyWith(
        meetingSaveStatus: SaveStatus.saving,
        meetingSaveTargetId: plan.id,
        clearMeetingDraftError: true,
        clearMeetingSaveFeedback: true,
      );
      notifyListeners();
      _persistMeetingPlan(
        plan,
        successFeedback: _lastFailedMeetingPlanSuccessFeedback,
      );
      return;
    }
    final entry = _lastFailedScheduleEntry;
    if (entry == null || _state.meetingSaveStatus == SaveStatus.saving) {
      return;
    }
    final index = _scheduleEntries.indexWhere(
      (candidate) => candidate.id == entry.id,
    );
    if (index == -1) {
      _scheduleEntries.add(entry);
      _sortScheduleEntriesByDate();
    } else {
      _scheduleEntries[index] = entry;
    }
    _state = _state.copyWith(
      meetingSaveStatus: SaveStatus.saving,
      meetingSaveTargetId: entry.id,
      clearMeetingDraftError: true,
      clearMeetingSaveFeedback: true,
    );
    notifyListeners();
    _persistScheduleEntry(
      entry,
      successFeedback: _lastFailedScheduleEntrySuccessFeedback,
    );
  }

  void startPlaceDraft() {
    _state = _state.copyWith(
      route: AlagagiRoute.places,
      placeDraftVisible: true,
      placeDraftName: '',
      placeDraftAddress: '',
      placeDraftNote: '',
      placeDraftCategory: PlaceCategory.cafe,
      placeDraftProvider: MapApiProvider.kakao,
      placeDraftProviderPlaceId: '',
      clearPlaceDraftCoordinates: true,
      clearPlaceDraftError: true,
      clearEditingPlaceId: true,
      placeSaveStatus: SaveStatus.idle,
      clearPlaceError: true,
      clearPlaceSaveFeedback: true,
      clearPlaceSaveTargetId: true,
    );
    notifyListeners();
  }

  void startEditingPlace(String placeId) {
    final place = _sharedPlaces.firstWhere(
      (candidate) => candidate.id == placeId,
      orElse: () => const SharedPlace(
        id: '',
        name: '',
        address: '',
        category: PlaceCategory.activity,
        provider: MapApiProvider.kakao,
        createdByProfileId: '',
        interestedByProfileIds: {},
      ),
    );
    if (place.id.isEmpty) {
      return;
    }
    if (place.createdByProfileId != _state.me.id) {
      _state = _state.copyWith(
        placeError: '내가 담은 장소만 수정할 수 있어요.',
        placeSaveStatus: SaveStatus.failed,
        placeSaveTargetId: placeId,
        clearPlaceSaveFeedback: true,
      );
      notifyListeners();
      return;
    }
    _state = _state.copyWith(
      route: AlagagiRoute.places,
      placeDraftVisible: true,
      placeDraftName: place.name,
      placeDraftAddress: place.address,
      placeDraftNote: place.note,
      placeDraftCategory: place.category,
      placeDraftProvider: MapApiProvider.kakao,
      placeDraftProviderPlaceId: place.providerPlaceId,
      placeDraftLatitude: place.latitude,
      placeDraftLongitude: place.longitude,
      editingPlaceId: place.id,
      clearPlaceDraftError: true,
      placeSaveStatus: SaveStatus.idle,
      clearPlaceError: true,
      clearPlaceSaveFeedback: true,
      clearPlaceSaveTargetId: true,
    );
    notifyListeners();
  }

  void cancelPlaceDraft() {
    _state = _state.copyWith(
      placeDraftVisible: false,
      placeDraftName: '',
      placeDraftAddress: '',
      placeDraftNote: '',
      placeDraftCategory: PlaceCategory.cafe,
      placeDraftProvider: MapApiProvider.kakao,
      placeDraftProviderPlaceId: '',
      clearPlaceDraftCoordinates: true,
      clearPlaceDraftError: true,
      clearEditingPlaceId: true,
    );
    notifyListeners();
  }

  void updatePlaceDraft({String? name, String? address, String? note}) {
    _state = _state.copyWith(
      placeDraftName: name,
      placeDraftAddress: address,
      placeDraftNote: note,
      clearPlaceDraftError: true,
    );
    notifyListeners();
  }

  void setPlaceDraftCategory(PlaceCategory category) {
    _state = _state.copyWith(
      placeDraftCategory: category,
      clearPlaceDraftError: true,
    );
    notifyListeners();
  }

  void setPlaceDraftProvider(MapApiProvider provider) {
    _state = _state.copyWith(
      placeDraftProvider: MapApiProvider.kakao,
      clearPlaceDraftError: true,
    );
    notifyListeners();
  }

  void applyKakaoPlaceResult({
    required String providerPlaceId,
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    PlaceCategory? category,
  }) {
    _state = _state.copyWith(
      placeDraftName: name,
      placeDraftAddress: address,
      placeDraftCategory: category,
      placeDraftProvider: MapApiProvider.kakao,
      placeDraftProviderPlaceId: providerPlaceId,
      placeDraftLatitude: latitude,
      placeDraftLongitude: longitude,
      clearPlaceDraftError: true,
    );
    notifyListeners();
  }

  void submitPlaceDraft() {
    if (_state.placeSaveStatus == SaveStatus.saving) {
      return;
    }
    final name = _state.placeDraftName.trim();
    final address = _state.placeDraftAddress.trim();
    final note = _state.placeDraftNote.trim();
    final providerPlaceId = _state.placeDraftProviderPlaceId.trim();
    if (name.isEmpty) {
      _state = _state.copyWith(placeDraftError: '지도에서 장소를 검색해 선택해주세요.');
      notifyListeners();
      return;
    }
    if (name.length > 60) {
      _state = _state.copyWith(placeDraftError: '장소 이름은 60자 안으로 남겨주세요.');
      notifyListeners();
      return;
    }
    if (address.length > 90) {
      _state = _state.copyWith(placeDraftError: '주소는 90자 안으로 담아주세요.');
      notifyListeners();
      return;
    }
    if (note.length > 120) {
      _state = _state.copyWith(placeDraftError: '메모는 120자 안으로 남겨주세요.');
      notifyListeners();
      return;
    }
    if (providerPlaceId.isEmpty ||
        _state.placeDraftLatitude == null ||
        _state.placeDraftLongitude == null) {
      _state = _state.copyWith(placeDraftError: '지도 검색 결과를 선택해주세요.');
      notifyListeners();
      return;
    }

    final now = DateTime.now();
    final editingPlaceId = _state.editingPlaceId;
    final editingIndex = editingPlaceId == null
        ? -1
        : _sharedPlaces.indexWhere((place) => place.id == editingPlaceId);
    final duplicateIndex = _sharedPlaces.indexWhere(
      (place) =>
          place.provider == MapApiProvider.kakao &&
          place.providerPlaceId.trim().isNotEmpty &&
          place.providerPlaceId.trim() == providerPlaceId &&
          place.id != editingPlaceId,
    );
    final targetIndex = editingIndex != -1 ? editingIndex : duplicateIndex;
    final existingPlace = targetIndex == -1 ? null : _sharedPlaces[targetIndex];
    if (editingPlaceId != null && editingIndex == -1) {
      _state = _state.copyWith(
        placeDraftError: '수정할 장소를 찾지 못했어요.',
        placeSaveStatus: SaveStatus.idle,
        clearPlaceSaveFeedback: true,
      );
      notifyListeners();
      return;
    }
    if (existingPlace != null &&
        editingPlaceId != null &&
        existingPlace.createdByProfileId != _state.me.id) {
      _state = _state.copyWith(
        placeDraftError: '내가 담은 장소만 수정할 수 있어요.',
        placeSaveStatus: SaveStatus.idle,
        clearPlaceSaveFeedback: true,
      );
      notifyListeners();
      return;
    }

    final canChangePlaceContent =
        existingPlace == null ||
        existingPlace.createdByProfileId == _state.me.id;
    final place = existingPlace == null
        ? SharedPlace(
            id: 'place_${_state.me.id}_${now.microsecondsSinceEpoch}',
            name: name,
            address: address,
            category: _state.placeDraftCategory,
            provider: MapApiProvider.kakao,
            providerPlaceId: providerPlaceId,
            latitude: _state.placeDraftLatitude,
            longitude: _state.placeDraftLongitude,
            note: note,
            createdByProfileId: _state.me.id,
            interestedByProfileIds: {_state.me.id},
            updatedAt: now,
            updatedByProfileId: _state.me.id,
          )
        : canChangePlaceContent
        ? existingPlace.copyWith(
            name: name,
            address: address,
            category: _state.placeDraftCategory,
            provider: MapApiProvider.kakao,
            providerPlaceId: providerPlaceId,
            latitude: _state.placeDraftLatitude,
            longitude: _state.placeDraftLongitude,
            note: note,
            updatedAt: now,
            updatedByProfileId: _state.me.id,
          )
        : existingPlace.copyWith(
            interestedByProfileIds: {
              ...existingPlace.interestedByProfileIds,
              _state.me.id,
            },
            updatedAt: now,
            updatedByProfileId: _state.me.id,
          );
    if (existingPlace == null) {
      _sharedPlaces.insert(0, place);
    } else {
      _sharedPlaces[targetIndex] = place;
    }
    _sortSharedPlacesByUpdatedAt();
    _lastFailedSharedPlace = null;
    _state = _state.copyWith(
      placeDraftVisible: false,
      placeDraftName: '',
      placeDraftAddress: '',
      placeDraftNote: '',
      placeDraftCategory: PlaceCategory.cafe,
      placeDraftProvider: MapApiProvider.kakao,
      placeDraftProviderPlaceId: '',
      clearPlaceDraftCoordinates: true,
      clearPlaceDraftError: true,
      clearEditingPlaceId: true,
      placeSaveStatus: SaveStatus.saving,
      placeSaveTargetId: place.id,
      clearPlaceError: true,
      clearPlaceSaveFeedback: true,
    );
    notifyListeners();
    _persistSharedPlace(place);
  }

  void togglePlaceInterest(String placeId) {
    if (_state.placeSaveStatus == SaveStatus.saving) {
      return;
    }
    final index = _sharedPlaces.indexWhere((place) => place.id == placeId);
    if (index == -1) {
      return;
    }
    final place = _sharedPlaces[index];
    final interestedBy = Set<String>.of(place.interestedByProfileIds);
    final likedByMe = interestedBy.contains(_state.me.id);
    if (likedByMe) {
      interestedBy.remove(_state.me.id);
    } else {
      interestedBy.add(_state.me.id);
    }
    final updatedPlace = place.copyWith(
      interestedByProfileIds: interestedBy,
      updatedAt: DateTime.now(),
      updatedByProfileId: _state.me.id,
    );
    _sharedPlaces[index] = updatedPlace;
    _sortSharedPlacesByUpdatedAt();
    _lastFailedSharedPlace = null;
    _state = _state.copyWith(
      placeSaveStatus: SaveStatus.saving,
      placeSaveTargetId: updatedPlace.id,
      clearPlaceError: true,
      clearPlaceSaveFeedback: true,
    );
    notifyListeners();
    _persistSharedPlaceMeetingLinks(updatedPlace);
  }

  void linkPlaceToSelectedMeeting(String placeId) {
    _linkPlaceToMeetingDate(placeId, selectedMeetingDateKey);
  }

  void linkPlaceToSelectedMeetingPlan(String placeId) {
    _linkPlaceToMeetingDate(placeId, selectedMeetingPlanDateKey);
  }

  void _linkPlaceToMeetingDate(String placeId, String dateKey) {
    if (_state.placeSaveStatus == SaveStatus.saving) {
      return;
    }
    final index = _sharedPlaces.indexWhere((place) => place.id == placeId);
    if (index == -1) {
      return;
    }
    final place = _sharedPlaces[index];
    final alreadyLinkedToSelectedDate = place.isLinkedToMeetingDate(dateKey);
    final updatedPlace =
        (alreadyLinkedToSelectedDate
                ? place.removeMeetingPlanLink(dateKey)
                : place.upsertMeetingPlanLink(
                    MeetingPlaceLink(
                      dateKey: dateKey,
                      order: _nextMeetingPlaceOrder(dateKey),
                    ),
                  ))
            .copyWith(
              interestedByProfileIds: alreadyLinkedToSelectedDate
                  ? place.interestedByProfileIds
                  : {...place.interestedByProfileIds, _state.me.id},
              updatedAt: DateTime.now(),
              updatedByProfileId: _state.me.id,
            );
    _sharedPlaces[index] = updatedPlace;
    _sortSharedPlacesByUpdatedAt();
    _lastFailedSharedPlace = null;
    _state = _state.copyWith(
      placeSaveStatus: SaveStatus.saving,
      placeSaveTargetId: updatedPlace.id,
      clearPlaceError: true,
      clearPlaceSaveFeedback: true,
    );
    notifyListeners();
    _persistSharedPlaceMeetingLinks(updatedPlace);
  }

  int _nextMeetingPlaceOrder(String dateKey) {
    var nextOrder = 0;
    for (final place in _sharedPlaces) {
      final order = place.meetingPlanLinkFor(dateKey)?.order;
      if (order != null && order >= nextOrder) {
        nextOrder = order + 1;
      }
    }
    return nextOrder;
  }

  bool updateMeetingPlaceReservationTime({
    required String dateKey,
    required String placeId,
    required String reservationTimeLabel,
  }) {
    final trimmed = reservationTimeLabel.trim();
    if (trimmed.length > 30) {
      _state = _state.copyWith(placeError: '예약 시간은 30자 안으로 적어주세요.');
      notifyListeners();
      return false;
    }
    final index = _sharedPlaces.indexWhere((place) => place.id == placeId);
    if (index == -1) {
      return false;
    }
    final place = _sharedPlaces[index];
    final currentLink = place.meetingPlanLinkFor(dateKey);
    final updatedLink = MeetingPlaceLink(
      dateKey: dateKey,
      order: currentLink?.order ?? _nextMeetingPlaceOrder(dateKey),
      reservationTimeLabel: trimmed,
    );
    final updatedPlace = place
        .upsertMeetingPlanLink(updatedLink)
        .copyWith(
          interestedByProfileIds: {
            ...place.interestedByProfileIds,
            _state.me.id,
          },
          updatedAt: DateTime.now(),
          updatedByProfileId: _state.me.id,
        );
    _sharedPlaces[index] = updatedPlace;
    _sortSharedPlacesByUpdatedAt();
    _lastFailedSharedPlace = null;
    _state = _state.copyWith(
      placeSaveStatus: SaveStatus.saving,
      placeSaveTargetId: updatedPlace.id,
      clearPlaceError: true,
      clearPlaceSaveFeedback: true,
    );
    notifyListeners();
    _persistSharedPlaceMeetingLinks(updatedPlace);
    return true;
  }

  void reorderMeetingPlanPlaces(String dateKey, int oldIndex, int newIndex) {
    if (_state.placeSaveStatus == SaveStatus.saving) {
      return;
    }
    final places = placesForMeetingPlan(dateKey).toList();
    if (oldIndex < 0 || oldIndex >= places.length || places.length < 2) {
      return;
    }
    var targetIndex = newIndex;
    if (targetIndex > oldIndex) {
      targetIndex -= 1;
    }
    targetIndex = targetIndex.clamp(0, places.length - 1).toInt();
    if (oldIndex == targetIndex) {
      return;
    }

    final movedPlace = places.removeAt(oldIndex);
    places.insert(targetIndex, movedPlace);

    final updatedPlaces = <SharedPlace>[];
    final now = DateTime.now();
    for (var order = 0; order < places.length; order++) {
      final place = places[order];
      final currentLink = place.meetingPlanLinkFor(dateKey);
      final updatedPlace = place
          .upsertMeetingPlanLink(
            MeetingPlaceLink(
              dateKey: dateKey,
              order: order,
              reservationTimeLabel: currentLink?.reservationTimeLabel ?? '',
            ),
          )
          .copyWith(
            interestedByProfileIds: {
              ...place.interestedByProfileIds,
              _state.me.id,
            },
            updatedAt: now,
            updatedByProfileId: _state.me.id,
          );
      final sharedIndex = _sharedPlaces.indexWhere(
        (candidate) => candidate.id == place.id,
      );
      if (sharedIndex == -1) {
        continue;
      }
      _sharedPlaces[sharedIndex] = updatedPlace;
      updatedPlaces.add(updatedPlace);
    }
    if (updatedPlaces.isEmpty) {
      return;
    }
    _sortSharedPlacesByUpdatedAt();
    _lastFailedSharedPlace = null;
    _state = _state.copyWith(
      placeSaveStatus: SaveStatus.saving,
      placeSaveTargetId: updatedPlaces.first.id,
      clearPlaceError: true,
      clearPlaceSaveFeedback: true,
    );
    notifyListeners();
    for (final place in updatedPlaces) {
      _persistSharedPlaceMeetingLinks(place);
    }
  }

  void deletePlace(String placeId) {
    if (_state.placeSaveStatus == SaveStatus.saving) {
      return;
    }
    final index = _sharedPlaces.indexWhere((place) => place.id == placeId);
    if (index == -1) {
      return;
    }
    final place = _sharedPlaces[index];
    if (place.createdByProfileId != _state.me.id) {
      _state = _state.copyWith(
        placeError: '내가 담은 장소만 삭제할 수 있어요.',
        placeSaveStatus: SaveStatus.failed,
        placeSaveTargetId: place.id,
        clearPlaceSaveFeedback: true,
      );
      notifyListeners();
      return;
    }
    _sharedPlaces.removeAt(index);
    _lastFailedSharedPlace = null;
    _state = _state.copyWith(
      placeSaveStatus: SaveStatus.saving,
      placeSaveTargetId: place.id,
      clearPlaceError: true,
      clearPlaceSaveFeedback: true,
    );
    notifyListeners();
    _deleteSharedPlace(place, index);
  }

  bool isPlaceSaveTarget(String placeId) {
    return _state.placeSaveTargetId == placeId;
  }

  void retryPlaceSave() {
    final place = _lastFailedSharedPlace;
    if (place == null || _state.placeSaveStatus == SaveStatus.saving) {
      return;
    }
    _state = _state.copyWith(
      placeSaveStatus: SaveStatus.saving,
      placeSaveTargetId: place.id,
      clearPlaceError: true,
      clearPlaceSaveFeedback: true,
    );
    notifyListeners();
    if (_lastFailedSharedPlaceWasMeetingLinks) {
      _persistSharedPlaceMeetingLinks(place);
    } else {
      _persistSharedPlace(place);
    }
  }

  void setStockStoryTab(StockStoryTab tab) {
    _state = _state.copyWith(
      stockStoryTab: tab,
      stockStoryListFilter: StockStoryListFilter.all,
      stockHoldingListFilter: StockHoldingListFilter.all,
      clearStockStoryDraftError: true,
      clearStockHoldingDraftError: true,
      clearStockStoryReplyError: true,
      clearStockHoldingReplyError: true,
      clearStockStorySaveFeedback: true,
      clearStockHoldingSaveFeedback: true,
    );
    notifyListeners();
  }

  void setStockStoryListFilter(StockStoryListFilter filter) {
    if (_state.stockStoryListFilter == filter) {
      return;
    }
    _state = _state.copyWith(stockStoryListFilter: filter);
    notifyListeners();
  }

  void setStockHoldingListFilter(StockHoldingListFilter filter) {
    if (_state.stockHoldingListFilter == filter) {
      return;
    }
    _state = _state.copyWith(stockHoldingListFilter: filter);
    notifyListeners();
  }

  void startStockStoryDraft() {
    _state = _state.copyWith(
      route: AlagagiRoute.stockStory,
      stockStoryTab: StockStoryTab.stories,
      stockStoryDraftVisible: true,
      stockStoryDraftName: '',
      stockStoryDraftReason: '',
      stockStoryDraftUpside: '',
      stockStoryDraftRisk: '',
      stockStoryDraftQuestion: '',
      clearStockStoryDraftError: true,
      clearStockStorySaveFeedback: true,
      clearStockStorySaveTargetId: true,
    );
    notifyListeners();
  }

  void cancelStockStoryDraft() {
    _state = _state.copyWith(
      stockStoryDraftVisible: false,
      stockStoryDraftName: '',
      stockStoryDraftReason: '',
      stockStoryDraftUpside: '',
      stockStoryDraftRisk: '',
      stockStoryDraftQuestion: '',
      clearStockStoryDraftError: true,
      clearStockStorySaveFeedback: true,
    );
    notifyListeners();
  }

  void updateStockStoryDraft({
    String? name,
    String? reason,
    String? upside,
    String? risk,
    String? question,
  }) {
    _state = _state.copyWith(
      stockStoryDraftName: name,
      stockStoryDraftReason: reason,
      stockStoryDraftUpside: upside,
      stockStoryDraftRisk: risk,
      stockStoryDraftQuestion: question,
      clearStockStoryDraftError: true,
      clearStockStorySaveFeedback: true,
      clearStockStorySaveTargetId: true,
    );
    notifyListeners();
  }

  void submitStockStoryDraft() {
    final name = _state.stockStoryDraftName.trim();
    final reason = _state.stockStoryDraftReason.trim();
    final rawUpside = _state.stockStoryDraftUpside.trim();
    final rawRisk = _state.stockStoryDraftRisk.trim();
    final rawQuestion = _state.stockStoryDraftQuestion.trim();
    final upside = rawUpside.isEmpty ? '좋아 보이는 점은 더 살펴볼게요.' : rawUpside;
    final risk = rawRisk.isEmpty ? '조심할 점은 같이 보면서 정리할게요.' : rawRisk;
    final question = rawQuestion.isEmpty
        ? '이 종목을 같이 어떻게 볼지 궁금해요.'
        : rawQuestion;

    String? error;
    if (name.isEmpty) {
      error = '같이 알아볼 종목명을 남겨주세요.';
    } else if (name.length > 40) {
      error = '종목명은 40자 안으로 남겨주세요.';
    } else if (reason.isEmpty) {
      error = '관심 이유를 한 줄만 남겨주세요.';
    } else if (reason.length > 120) {
      error = '관심 이유는 120자 안으로 남겨주세요.';
    } else if (upside.length > 80 || risk.length > 80) {
      error = '기대와 걱정은 각각 80자 안으로 남겨주세요.';
    } else if (question.length > 100) {
      error = '질문은 100자 안으로 남겨주세요.';
    }
    if (error != null) {
      _state = _state.copyWith(stockStoryDraftError: error);
      notifyListeners();
      return;
    }

    final now = DateTime.now();
    final story = StockStory(
      id: 'stock_${_state.me.id}_${now.microsecondsSinceEpoch}',
      name: name,
      reason: reason,
      upside: upside,
      risk: risk,
      question: question,
      createdByProfileId: _state.me.id,
      createdLabel: '오늘',
      updatedAt: now,
      updatedByProfileId: _state.me.id,
    );
    _stockStories.insert(0, story);
    _sortStockStoriesByUpdatedAt();
    _state = _state.copyWith(
      stockStoryDraftVisible: false,
      stockStoryDraftName: '',
      stockStoryDraftReason: '',
      stockStoryDraftUpside: '',
      stockStoryDraftRisk: '',
      stockStoryDraftQuestion: '',
      stockStorySaveStatus: SaveStatus.saving,
      stockStorySaveTargetId: story.id,
      clearStockStoryDraftError: true,
      clearStockStorySaveFeedback: true,
    );
    notifyListeners();
    _persistStockStory(story);
  }

  void deleteStockStory(String storyId) {
    final index = _stockStories.indexWhere((story) => story.id == storyId);
    if (index == -1) {
      _state = _state.copyWith(stockStoryDraftError: '삭제할 주식 이야기를 찾지 못했어요.');
      notifyListeners();
      return;
    }
    final story = _stockStories[index];
    if (story.createdByProfileId != _state.me.id) {
      _state = _state.copyWith(
        stockStoryDraftError: '내가 남긴 주식 이야기만 삭제할 수 있어요.',
      );
      notifyListeners();
      return;
    }
    _stockStories.removeAt(index);
    _state = _state.copyWith(
      stockStorySaveStatus: SaveStatus.saving,
      stockStorySaveTargetId: story.id,
      clearStockStoryDraftError: true,
      clearStockStorySaveFeedback: true,
    );
    notifyListeners();
    _deletePersistedStockStory(story, index);
  }

  void retryStockStorySave() {
    final story = _lastFailedStockStory;
    if (story == null || _state.stockStorySaveStatus == SaveStatus.saving) {
      return;
    }
    final previousIndex = _stockStories.indexWhere(
      (candidate) => candidate.id == story.id,
    );
    if (_lastFailedStockStoryAction == _FailedPersistenceAction.delete &&
        previousIndex != -1) {
      _stockStories.removeAt(previousIndex);
      _sortStockStoriesByUpdatedAt();
    }
    _state = _state.copyWith(
      stockStorySaveStatus: SaveStatus.saving,
      stockStorySaveTargetId: story.id,
      clearStockStoryDraftError: true,
      clearStockStorySaveFeedback: true,
    );
    notifyListeners();
    if (_lastFailedStockStoryAction == _FailedPersistenceAction.delete) {
      _deletePersistedStockStory(
        story,
        previousIndex == -1 ? 0 : previousIndex,
      );
    } else {
      _persistStockStory(story);
    }
  }

  String stockStoryReplyDraftFor(String storyId) {
    return _state.stockStoryReplyDraftsByStoryId[storyId] ?? '';
  }

  String stockStoryReplyToneFor(String storyId) {
    return _state.stockStoryReplyTonesByStoryId[storyId] ??
        stockStoryReplyToneOptions.first;
  }

  void updateStockStoryReplyDraft({
    required String storyId,
    required String value,
  }) {
    final drafts = Map<String, String>.of(_state.stockStoryReplyDraftsByStoryId)
      ..[storyId] = value;
    _state = _state.copyWith(
      stockStoryReplyDraftsByStoryId: Map<String, String>.unmodifiable(drafts),
      clearStockStoryReplyError: true,
    );
    notifyListeners();
  }

  void setStockStoryReplyTone(String storyId, String tone) {
    if (!stockStoryReplyToneOptions.contains(tone)) {
      return;
    }
    final tones = Map<String, String>.of(_state.stockStoryReplyTonesByStoryId)
      ..[storyId] = tone;
    _state = _state.copyWith(
      stockStoryReplyTonesByStoryId: Map<String, String>.unmodifiable(tones),
      clearStockStoryReplyError: true,
    );
    notifyListeners();
  }

  void submitStockStoryReply(String storyId) {
    final index = _stockStories.indexWhere((story) => story.id == storyId);
    if (index == -1) {
      _state = _state.copyWith(stockStoryReplyError: '답장할 이야기를 찾지 못했어요.');
      notifyListeners();
      return;
    }
    final story = _stockStories[index];
    if (story.createdByProfileId == _state.me.id) {
      _state = _state.copyWith(stockStoryReplyError: '상대가 남긴 이야기에만 답장할 수 있어요.');
      notifyListeners();
      return;
    }
    if (story.hasReply) {
      _state = _state.copyWith(stockStoryReplyError: '이미 답장을 남긴 이야기예요.');
      notifyListeners();
      return;
    }
    final reply = stockStoryReplyDraftFor(storyId).trim();
    if (reply.isEmpty) {
      _state = _state.copyWith(stockStoryReplyError: '짧게라도 관점을 남겨주세요.');
      notifyListeners();
      return;
    }
    if (reply.length > 160) {
      _state = _state.copyWith(stockStoryReplyError: '답장은 160자 안으로 남겨주세요.');
      notifyListeners();
      return;
    }
    final updatedStory = story.copyWith(
      replyTone: stockStoryReplyToneFor(storyId),
      reply: reply,
      repliedByProfileId: _state.me.id,
      repliedLabel: '오늘',
      updatedAt: DateTime.now(),
      updatedByProfileId: _state.me.id,
    );
    _stockStories[index] = updatedStory;
    _sortStockStoriesByUpdatedAt();
    final drafts = Map<String, String>.of(_state.stockStoryReplyDraftsByStoryId)
      ..remove(storyId);
    final tones = Map<String, String>.of(_state.stockStoryReplyTonesByStoryId)
      ..remove(storyId);
    _state = _state.copyWith(
      stockStoryReplyDraftsByStoryId: Map<String, String>.unmodifiable(drafts),
      stockStoryReplyTonesByStoryId: Map<String, String>.unmodifiable(tones),
      stockStorySaveStatus: SaveStatus.saving,
      stockStorySaveTargetId: updatedStory.id,
      clearStockStoryReplyError: true,
      clearStockStorySaveFeedback: true,
    );
    notifyListeners();
    _persistStockStory(updatedStory);
  }

  void startStockHoldingDraft() {
    _state = _state.copyWith(
      route: AlagagiRoute.stockStory,
      stockStoryTab: StockStoryTab.holdings,
      stockHoldingDraftVisible: true,
      stockHoldingDraftName: '',
      stockHoldingDraftStatus: stockHoldingStatusOptions.first,
      stockHoldingDraftWeightLabel: stockHoldingWeightOptions[1],
      stockHoldingDraftReason: '',
      stockHoldingDraftWatchPoint: '',
      stockHoldingDraftConcern: '',
      stockHoldingDraftQuestion: '',
      clearStockHoldingDraftError: true,
      clearEditingStockHoldingId: true,
    );
    notifyListeners();
  }

  void startStockHoldingEdit(String holdingId) {
    final index = _stockHoldings.indexWhere(
      (holding) => holding.id == holdingId,
    );
    if (index == -1) {
      _state = _state.copyWith(stockHoldingDraftError: '수정할 보유 종목을 찾지 못했어요.');
      notifyListeners();
      return;
    }
    final holding = _stockHoldings[index];
    if (holding.createdByProfileId != _state.me.id) {
      _state = _state.copyWith(
        stockHoldingDraftError: '내가 공유한 보유 종목만 수정할 수 있어요.',
      );
      notifyListeners();
      return;
    }
    _state = _state.copyWith(
      route: AlagagiRoute.stockStory,
      stockStoryTab: StockStoryTab.holdings,
      stockHoldingListFilter: StockHoldingListFilter.all,
      stockHoldingDraftVisible: true,
      editingStockHoldingId: holding.id,
      stockHoldingDraftName: holding.name,
      stockHoldingDraftStatus: holding.status,
      stockHoldingDraftWeightLabel: holding.weightLabel,
      stockHoldingDraftReason: holding.reason,
      stockHoldingDraftWatchPoint: holding.watchPoint,
      stockHoldingDraftConcern: holding.concern,
      stockHoldingDraftQuestion: holding.question,
      clearStockHoldingDraftError: true,
      clearStockHoldingReplyError: true,
    );
    notifyListeners();
  }

  void cancelStockHoldingDraft() {
    _state = _state.copyWith(
      stockHoldingDraftVisible: false,
      stockHoldingDraftName: '',
      stockHoldingDraftStatus: stockHoldingStatusOptions.first,
      stockHoldingDraftWeightLabel: stockHoldingWeightOptions[1],
      stockHoldingDraftReason: '',
      stockHoldingDraftWatchPoint: '',
      stockHoldingDraftConcern: '',
      stockHoldingDraftQuestion: '',
      clearStockHoldingDraftError: true,
      clearEditingStockHoldingId: true,
    );
    notifyListeners();
  }

  void updateStockHoldingDraft({
    String? name,
    String? status,
    String? weightLabel,
    String? reason,
    String? watchPoint,
    String? concern,
    String? question,
  }) {
    _state = _state.copyWith(
      stockHoldingDraftName: name,
      stockHoldingDraftStatus: status,
      stockHoldingDraftWeightLabel: weightLabel,
      stockHoldingDraftReason: reason,
      stockHoldingDraftWatchPoint: watchPoint,
      stockHoldingDraftConcern: concern,
      stockHoldingDraftQuestion: question,
      clearStockHoldingDraftError: true,
    );
    notifyListeners();
  }

  void submitStockHoldingDraft() {
    final name = _state.stockHoldingDraftName.trim();
    final status = _state.stockHoldingDraftStatus.trim();
    final weightLabel = _state.stockHoldingDraftWeightLabel.trim();
    final reason = _state.stockHoldingDraftReason.trim();
    final rawWatchPoint = _state.stockHoldingDraftWatchPoint.trim();
    final rawConcern = _state.stockHoldingDraftConcern.trim();
    final rawQuestion = _state.stockHoldingDraftQuestion.trim();
    final watchPoint = rawWatchPoint.isEmpty ? '앞으로 같이 더 볼게요.' : rawWatchPoint;
    final concern = rawConcern.isEmpty ? '걱정되는 점은 보면서 정리할게요.' : rawConcern;
    final question = rawQuestion.isEmpty
        ? '이 종목을 어떻게 볼지 같이 이야기해보고 싶어요.'
        : rawQuestion;

    String? error;
    if (name.isEmpty) {
      error = '보유 중인 종목명을 남겨주세요.';
    } else if (name.length > 40) {
      error = '종목명은 40자 안으로 남겨주세요.';
    } else if (!stockHoldingStatusOptions.contains(status)) {
      error = '보유 상태를 다시 골라주세요.';
    } else if (!stockHoldingWeightOptions.contains(weightLabel)) {
      error = '비중 느낌을 다시 골라주세요.';
    } else if (reason.isEmpty) {
      error = '보유 이유를 한 줄만 남겨주세요.';
    } else if (reason.length > 120) {
      error = '보유 이유는 120자 안으로 남겨주세요.';
    } else if (rawWatchPoint.length > 80 || rawConcern.length > 80) {
      error = '보고 싶은 점과 걱정은 각각 80자 안으로 남겨주세요.';
    } else if (rawQuestion.length > 100) {
      error = '질문은 100자 안으로 남겨주세요.';
    }
    if (error != null) {
      _state = _state.copyWith(stockHoldingDraftError: error);
      notifyListeners();
      return;
    }

    final editingId = _state.editingStockHoldingId;
    final editingIndex = editingId == null
        ? -1
        : _stockHoldings.indexWhere((holding) => holding.id == editingId);
    if (editingId != null) {
      if (editingIndex == -1) {
        _state = _state.copyWith(stockHoldingDraftError: '수정할 보유 종목을 찾지 못했어요.');
        notifyListeners();
        return;
      }
      if (_stockHoldings[editingIndex].createdByProfileId != _state.me.id) {
        _state = _state.copyWith(
          stockHoldingDraftError: '내가 공유한 보유 종목만 수정할 수 있어요.',
        );
        notifyListeners();
        return;
      }
    }

    final now = DateTime.now();
    final StockHolding holding;
    if (editingIndex == -1) {
      holding = StockHolding(
        id: 'holding_${_state.me.id}_${now.microsecondsSinceEpoch}',
        name: name,
        status: status,
        weightLabel: weightLabel,
        reason: reason,
        watchPoint: watchPoint,
        concern: concern,
        question: question,
        createdByProfileId: _state.me.id,
        createdLabel: '오늘',
        updatedAt: now,
      );
      _stockHoldings.insert(0, holding);
    } else {
      final existingHolding = _stockHoldings[editingIndex];
      holding = existingHolding.copyWith(
        name: name,
        status: status,
        weightLabel: weightLabel,
        reason: reason,
        watchPoint: watchPoint,
        concern: concern,
        question: question,
        updatedAt: now,
        updatedByProfileId: _state.me.id,
      );
      _stockHoldings[editingIndex] = holding;
    }
    _sortStockHoldingsByUpdatedAt();
    _state = _state.copyWith(
      stockHoldingDraftVisible: false,
      stockHoldingDraftName: '',
      stockHoldingDraftStatus: stockHoldingStatusOptions.first,
      stockHoldingDraftWeightLabel: stockHoldingWeightOptions[1],
      stockHoldingDraftReason: '',
      stockHoldingDraftWatchPoint: '',
      stockHoldingDraftConcern: '',
      stockHoldingDraftQuestion: '',
      clearStockHoldingDraftError: true,
      clearEditingStockHoldingId: true,
      stockHoldingSaveStatus: SaveStatus.saving,
      stockHoldingSaveTargetId: holding.id,
      clearStockHoldingSaveFeedback: true,
    );
    notifyListeners();
    _persistStockHolding(holding);
  }

  void deleteStockHolding(String holdingId) {
    final index = _stockHoldings.indexWhere(
      (holding) => holding.id == holdingId,
    );
    if (index == -1) {
      _state = _state.copyWith(stockHoldingDraftError: '삭제할 보유 종목을 찾지 못했어요.');
      notifyListeners();
      return;
    }
    final holding = _stockHoldings[index];
    if (holding.createdByProfileId != _state.me.id) {
      _state = _state.copyWith(
        stockHoldingDraftError: '내가 공유한 보유 종목만 삭제할 수 있어요.',
      );
      notifyListeners();
      return;
    }

    _stockHoldings.removeAt(index);
    final wasEditing = _state.editingStockHoldingId == holdingId;
    _state = _state.copyWith(
      stockHoldingDraftVisible: wasEditing
          ? false
          : _state.stockHoldingDraftVisible,
      stockHoldingDraftName: wasEditing ? '' : _state.stockHoldingDraftName,
      stockHoldingDraftStatus: wasEditing
          ? stockHoldingStatusOptions.first
          : _state.stockHoldingDraftStatus,
      stockHoldingDraftWeightLabel: wasEditing
          ? stockHoldingWeightOptions[1]
          : _state.stockHoldingDraftWeightLabel,
      stockHoldingDraftReason: wasEditing ? '' : _state.stockHoldingDraftReason,
      stockHoldingDraftWatchPoint: wasEditing
          ? ''
          : _state.stockHoldingDraftWatchPoint,
      stockHoldingDraftConcern: wasEditing
          ? ''
          : _state.stockHoldingDraftConcern,
      stockHoldingDraftQuestion: wasEditing
          ? ''
          : _state.stockHoldingDraftQuestion,
      clearStockHoldingDraftError: true,
      clearStockHoldingReplyError: true,
      clearEditingStockHoldingId: wasEditing,
      stockHoldingSaveStatus: SaveStatus.saving,
      stockHoldingSaveTargetId: holding.id,
      clearStockHoldingSaveFeedback: true,
    );
    notifyListeners();
    _deletePersistedStockHolding(holding, index);
  }

  void retryStockHoldingSave() {
    final holding = _lastFailedStockHolding;
    if (holding == null || _state.stockHoldingSaveStatus == SaveStatus.saving) {
      return;
    }
    final previousIndex = _stockHoldings.indexWhere(
      (candidate) => candidate.id == holding.id,
    );
    if (_lastFailedStockHoldingAction == _FailedPersistenceAction.delete &&
        previousIndex != -1) {
      _stockHoldings.removeAt(previousIndex);
      _sortStockHoldingsByUpdatedAt();
    }
    _state = _state.copyWith(
      stockHoldingSaveStatus: SaveStatus.saving,
      stockHoldingSaveTargetId: holding.id,
      clearStockHoldingSaveFeedback: true,
      clearStockHoldingDraftError: true,
    );
    notifyListeners();
    if (_lastFailedStockHoldingAction == _FailedPersistenceAction.delete) {
      _deletePersistedStockHolding(
        holding,
        previousIndex == -1 ? 0 : previousIndex,
      );
    } else {
      _persistStockHolding(holding);
    }
  }

  String stockHoldingReplyDraftFor(String holdingId) {
    return _state.stockHoldingReplyDraftsByHoldingId[holdingId] ?? '';
  }

  String stockHoldingReplyToneFor(String holdingId) {
    return _state.stockHoldingReplyTonesByHoldingId[holdingId] ??
        stockStoryReplyToneOptions.first;
  }

  void updateStockHoldingReplyDraft({
    required String holdingId,
    required String value,
  }) {
    final drafts = Map<String, String>.of(
      _state.stockHoldingReplyDraftsByHoldingId,
    )..[holdingId] = value;
    _state = _state.copyWith(
      stockHoldingReplyDraftsByHoldingId: Map<String, String>.unmodifiable(
        drafts,
      ),
      clearStockHoldingReplyError: true,
    );
    notifyListeners();
  }

  void setStockHoldingReplyTone(String holdingId, String tone) {
    if (!stockStoryReplyToneOptions.contains(tone)) {
      return;
    }
    final tones = Map<String, String>.of(
      _state.stockHoldingReplyTonesByHoldingId,
    )..[holdingId] = tone;
    _state = _state.copyWith(
      stockHoldingReplyTonesByHoldingId: Map<String, String>.unmodifiable(
        tones,
      ),
      clearStockHoldingReplyError: true,
    );
    notifyListeners();
  }

  void submitStockHoldingReply(String holdingId) {
    final index = _stockHoldings.indexWhere(
      (holding) => holding.id == holdingId,
    );
    if (index == -1) {
      _state = _state.copyWith(stockHoldingReplyError: '답장할 보유 종목을 찾지 못했어요.');
      notifyListeners();
      return;
    }
    final holding = _stockHoldings[index];
    if (holding.createdByProfileId == _state.me.id) {
      _state = _state.copyWith(
        stockHoldingReplyError: '상대가 공유한 보유 종목에만 답장할 수 있어요.',
      );
      notifyListeners();
      return;
    }
    if (holding.hasReply) {
      _state = _state.copyWith(stockHoldingReplyError: '이미 답장을 남긴 보유 종목이에요.');
      notifyListeners();
      return;
    }
    final reply = stockHoldingReplyDraftFor(holdingId).trim();
    if (reply.isEmpty) {
      _state = _state.copyWith(stockHoldingReplyError: '짧게라도 관점을 남겨주세요.');
      notifyListeners();
      return;
    }
    if (reply.length > 160) {
      _state = _state.copyWith(stockHoldingReplyError: '답장은 160자 안으로 남겨주세요.');
      notifyListeners();
      return;
    }
    final updatedHolding = holding.copyWith(
      replyTone: stockHoldingReplyToneFor(holdingId),
      reply: reply,
      repliedByProfileId: _state.me.id,
      repliedLabel: '오늘',
      updatedAt: DateTime.now(),
      updatedByProfileId: _state.me.id,
    );
    _stockHoldings[index] = updatedHolding;
    _sortStockHoldingsByUpdatedAt();
    final drafts = Map<String, String>.of(
      _state.stockHoldingReplyDraftsByHoldingId,
    )..remove(holdingId);
    final tones = Map<String, String>.of(
      _state.stockHoldingReplyTonesByHoldingId,
    )..remove(holdingId);
    _state = _state.copyWith(
      stockHoldingReplyDraftsByHoldingId: Map<String, String>.unmodifiable(
        drafts,
      ),
      stockHoldingReplyTonesByHoldingId: Map<String, String>.unmodifiable(
        tones,
      ),
      clearStockHoldingReplyError: true,
      stockHoldingSaveStatus: SaveStatus.saving,
      stockHoldingSaveTargetId: updatedHolding.id,
      clearStockHoldingSaveFeedback: true,
    );
    notifyListeners();
    _persistStockHolding(updatedHolding);
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
  DailyQuestion(
    id: 'q029',
    day: 29,
    number: 29,
    depth: QuestionDepth.inner,
    text: '요즘의 나를 색으로 표현한다면 어떤 색에 가까워요?',
    highlightedText: '요즘의 색',
  ),
  DailyQuestion(
    id: 'q030',
    day: 30,
    number: 30,
    depth: QuestionDepth.beliefs,
    text: '오래 머물고 싶은 대화는 어떤 분위기예요?',
    highlightedText: '대화 분위기',
  ),
  DailyQuestion(
    id: 'q031',
    day: 31,
    number: 31,
    depth: QuestionDepth.daily,
    text: '요즘 하루에서 가장 조용히 좋아지는 순간은 언제예요?',
    highlightedText: '조용한 순간',
  ),
  DailyQuestion(
    id: 'q032',
    day: 32,
    number: 32,
    depth: QuestionDepth.beliefs,
    text: '누군가를 알아갈 때 천천히 확인하고 싶은 부분은 뭐예요?',
    highlightedText: '확인하고 싶은 부분',
  ),
  DailyQuestion(
    id: 'q033',
    day: 33,
    number: 33,
    depth: QuestionDepth.inner,
    text: '쉽게 말하지 않지만 은근히 중요하게 여기는 게 있나요?',
    highlightedText: '중요하게 여기는 것',
  ),
  DailyQuestion(
    id: 'q034',
    day: 34,
    number: 34,
    depth: QuestionDepth.daily,
    text: '날씨가 좋은 날 제일 먼저 떠오르는 일은 뭐예요?',
    highlightedText: '좋은 날',
  ),
  DailyQuestion(
    id: 'q035',
    day: 35,
    number: 35,
    depth: QuestionDepth.beliefs,
    text: '편한 관계라고 느끼게 하는 작은 신호가 있다면요?',
    highlightedText: '편한 관계',
  ),
  DailyQuestion(
    id: 'q036',
    day: 36,
    number: 36,
    depth: QuestionDepth.inner,
    text: '요즘 나에게 가장 필요한 응원은 어떤 말이에요?',
    highlightedText: '필요한 응원',
  ),
  DailyQuestion(
    id: 'q037',
    day: 37,
    number: 37,
    depth: QuestionDepth.daily,
    text: '요즘 자주 가고 싶은 동네나 공간이 있나요?',
    highlightedText: '가고 싶은 공간',
  ),
  DailyQuestion(
    id: 'q038',
    day: 38,
    number: 38,
    depth: QuestionDepth.beliefs,
    text: '함께 시간을 보낼 때 중요하게 생각하는 리듬이 있어요?',
    highlightedText: '함께하는 리듬',
  ),
  DailyQuestion(
    id: 'q039',
    day: 39,
    number: 39,
    depth: QuestionDepth.inner,
    text: '처음보다 조금 더 편해졌다고 느끼는 순간은 언제예요?',
    highlightedText: '편해진 순간',
  ),
  DailyQuestion(
    id: 'q040',
    day: 40,
    number: 40,
    depth: QuestionDepth.daily,
    text: '요즘 나를 쉬게 해주는 소리는 뭐예요?',
    highlightedText: '쉬게 하는 소리',
  ),
  DailyQuestion(
    id: 'q041',
    day: 41,
    number: 41,
    depth: QuestionDepth.beliefs,
    text: '사소하지만 지켜주면 고마운 배려가 있나요?',
    highlightedText: '고마운 배려',
  ),
  DailyQuestion(
    id: 'q042',
    day: 42,
    number: 42,
    depth: QuestionDepth.inner,
    text: '마음이 복잡할 때 혼자 정리하는 방식은 뭐예요?',
    highlightedText: '정리 방식',
  ),
  DailyQuestion(
    id: 'q043',
    day: 43,
    number: 43,
    depth: QuestionDepth.daily,
    text: '최근에 저장해둔 사진이나 장면 중 마음에 남는 게 있나요?',
    highlightedText: '마음에 남은 장면',
  ),
  DailyQuestion(
    id: 'q044',
    day: 44,
    number: 44,
    depth: QuestionDepth.beliefs,
    text: '서로 다른 취향을 만났을 때 어떤 방식이 편해요?',
    highlightedText: '다른 취향',
  ),
  DailyQuestion(
    id: 'q045',
    day: 45,
    number: 45,
    depth: QuestionDepth.inner,
    text: '내가 나답다고 느끼는 순간은 언제예요?',
    highlightedText: '나다운 순간',
  ),
  DailyQuestion(
    id: 'q046',
    day: 46,
    number: 46,
    depth: QuestionDepth.daily,
    text: '요즘의 작은 목표가 있다면 뭐예요?',
    highlightedText: '작은 목표',
  ),
  DailyQuestion(
    id: 'q047',
    day: 47,
    number: 47,
    depth: QuestionDepth.beliefs,
    text: '대화가 끊겨도 어색하지 않은 순간은 어떤 느낌일까요?',
    highlightedText: '어색하지 않은 순간',
  ),
  DailyQuestion(
    id: 'q048',
    day: 48,
    number: 48,
    depth: QuestionDepth.inner,
    text: '아직은 낯설지만 조금 궁금한 주제가 있나요?',
    highlightedText: '궁금한 주제',
  ),
  DailyQuestion(
    id: 'q049',
    day: 49,
    number: 49,
    depth: QuestionDepth.daily,
    text: '하루 끝에 남아 있으면 좋은 기분은 어떤 기분이에요?',
    highlightedText: '좋은 기분',
  ),
  DailyQuestion(
    id: 'q050',
    day: 50,
    number: 50,
    depth: QuestionDepth.beliefs,
    text: '가까워질수록 더 조심하고 싶은 부분이 있나요?',
    highlightedText: '조심하고 싶은 부분',
  ),
  DailyQuestion(
    id: 'q051',
    day: 51,
    number: 51,
    depth: QuestionDepth.inner,
    text: '요즘 스스로에게 자주 해주는 말이 있나요?',
    highlightedText: '스스로에게 하는 말',
  ),
  DailyQuestion(
    id: 'q052',
    day: 52,
    number: 52,
    depth: QuestionDepth.daily,
    text: '같이 걷는다면 어떤 속도의 산책이 좋을 것 같아요?',
    highlightedText: '산책 속도',
  ),
  DailyQuestion(
    id: 'q053',
    day: 53,
    number: 53,
    depth: QuestionDepth.beliefs,
    text: '작은 약속을 정할 때 어떤 방식이 편해요?',
    highlightedText: '약속 방식',
  ),
  DailyQuestion(
    id: 'q054',
    day: 54,
    number: 54,
    depth: QuestionDepth.inner,
    text: '말보다 행동으로 더 잘 드러나는 내 마음은 어떤 쪽이에요?',
    highlightedText: '행동으로 드러나는 마음',
  ),
  DailyQuestion(
    id: 'q055',
    day: 55,
    number: 55,
    depth: QuestionDepth.daily,
    text: '요즘 발견한 괜찮은 장소나 물건이 있나요?',
    highlightedText: '괜찮은 발견',
  ),
  DailyQuestion(
    id: 'q056',
    day: 56,
    number: 56,
    depth: QuestionDepth.beliefs,
    text: '오래 기억하고 싶은 하루는 어떤 요소가 있어요?',
    highlightedText: '기억하고 싶은 하루',
  ),
  DailyQuestion(
    id: 'q057',
    day: 57,
    number: 57,
    depth: QuestionDepth.inner,
    text: '지금보다 조금 더 알게 되면 좋을 내 취향은 뭐예요?',
    highlightedText: '더 알고 싶은 취향',
  ),
  DailyQuestion(
    id: 'q058',
    day: 58,
    number: 58,
    depth: QuestionDepth.inner,
    text: '이 공간에서 가장 자연스럽게 남기고 싶은 이야기는 뭐예요?',
    highlightedText: '남기고 싶은 이야기',
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
    listenedByProfileIds: {'partner'},
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
    listenedByProfileIds: {'me'},
  ),
];

const seedScheduleEntries = [
  ScheduleEntry(
    dateKey: '2026-06-11',
    profileId: 'me',
    availability: MeetingAvailability.available,
    timeSlots: {MeetingTimeSlot.evening},
    timeBlocks: [
      ScheduleTimeBlock(
        startMinute: 18 * 60,
        endMinute: 18 * 60 + 30,
        title: '회사 일정',
      ),
    ],
    sharedMemo: '19:30 이후면 괜찮아요.',
  ),
  ScheduleEntry(
    dateKey: '2026-06-11',
    profileId: 'partner',
    availability: MeetingAvailability.available,
    timeSlots: {MeetingTimeSlot.evening},
    sharedMemo: '저녁이면 좋아요.',
  ),
  ScheduleEntry(
    dateKey: '2026-06-17',
    profileId: 'me',
    availability: MeetingAvailability.maybe,
    timeSlots: {MeetingTimeSlot.afternoon, MeetingTimeSlot.evening},
    timeBlocks: [
      ScheduleTimeBlock(
        startMinute: 15 * 60,
        endMinute: 17 * 60,
        title: '외부 미팅',
      ),
    ],
    sharedMemo: '오후는 조율 가능해요.',
  ),
  ScheduleEntry(
    dateKey: '2026-06-17',
    profileId: 'partner',
    availability: MeetingAvailability.available,
    timeSlots: {MeetingTimeSlot.afternoon},
    sharedMemo: '전시 보기 좋은 시간이에요.',
  ),
  ScheduleEntry(
    dateKey: '2026-06-19',
    profileId: 'me',
    availability: MeetingAvailability.busy,
    timeSlots: {},
    sharedMemo: '이 날은 어려워요.',
  ),
];

const seedSharedPlaces = [
  SharedPlace(
    id: 'place_exhibition',
    name: '작은 전시 공간',
    address: '서울 성동구 성수동',
    category: PlaceCategory.exhibition,
    provider: MapApiProvider.kakao,
    providerPlaceId: 'sample-kakao-exhibition',
    latitude: 37.5446,
    longitude: 127.0557,
    note: '전시 보고 근처에서 커피 마시면 좋을 것 같아요.',
    createdByProfileId: 'me',
    interestedByProfileIds: {'me', 'partner'},
    linkedDateKey: '2026-06-11',
  ),
  SharedPlace(
    id: 'place_cafe',
    name: '느린 커피 성수',
    address: '서울 성동구 연무장길',
    category: PlaceCategory.cafe,
    provider: MapApiProvider.kakao,
    providerPlaceId: 'sample-kakao-cafe',
    latitude: 37.5428,
    longitude: 127.0542,
    note: '사람이 많지 않은 시간에 가면 좋겠어요.',
    createdByProfileId: 'partner',
    interestedByProfileIds: {'partner'},
  ),
  SharedPlace(
    id: 'place_table',
    name: '골목 식탁',
    address: '서울 성동구 아차산로',
    category: PlaceCategory.food,
    provider: MapApiProvider.kakao,
    providerPlaceId: 'sample-kakao-table',
    latitude: 37.5462,
    longitude: 127.0576,
    note: '늦게까지 해서 저녁 후보로 괜찮아요.',
    createdByProfileId: 'me',
    interestedByProfileIds: {'me'},
  ),
];

const seedCuriosityCards = [
  CuriosityCard(
    id: 'curiosity_seed_1',
    fromProfileId: 'partner',
    toProfileId: 'me',
    question: '요즘 제일 자주 생각나는 건 뭐예요?',
    createdLabel: '오늘',
  ),
];

const seedStockStories = [
  StockStory(
    id: 'stock_seed_1',
    name: 'Apple',
    reason: '서비스 매출 흐름을 같이 살펴보고 싶어요.',
    upside: '구독 매출과 생태계 유지력',
    risk: '기기 교체 수요가 둔해질 가능성',
    question: '다음 실적에서 어떤 숫자를 먼저 보면 좋을까요?',
    createdByProfileId: 'partner',
    createdLabel: '오늘',
  ),
  StockStory(
    id: 'stock_seed_2',
    name: '삼성전자',
    reason: '반도체 업황을 차분히 관찰해보고 싶어요.',
    upside: '메모리 수요 회복',
    risk: '기대가 너무 빨리 반영됐는지',
    question: '실적 발표 전에는 어떤 점을 확인하면 좋을까요?',
    createdByProfileId: 'me',
    createdLabel: '오늘',
    replyTone: '더 찾아볼게요',
    reply: '뉴스보다 실적 숫자를 먼저 보자는 쪽이 편해요.',
    repliedByProfileId: 'partner',
    repliedLabel: '오늘',
  ),
];

const seedStockHoldings = [
  StockHolding(
    id: 'holding_seed_1',
    name: '삼성전자',
    status: '보유 중',
    weightLabel: '보통',
    reason: '반도체 업황을 천천히 보고 싶어서 들고 있어요.',
    watchPoint: '메모리 수요 회복',
    concern: '기대가 너무 빨리 반영됐는지',
    question: '다음 실적에서는 어떤 숫자를 같이 보면 좋을까요?',
    createdByProfileId: 'me',
    createdLabel: '오늘',
    replyTone: '같이 볼래요',
    reply: '뉴스보다 실적 숫자를 먼저 보는 쪽이 편해요.',
    repliedByProfileId: 'partner',
    repliedLabel: '오늘',
  ),
  StockHolding(
    id: 'holding_seed_2',
    name: 'Apple',
    status: '보유 중',
    weightLabel: '작게',
    reason: '서비스 매출을 믿고 작게 들고 있어요.',
    watchPoint: '서비스 매출 성장률',
    concern: '기기 교체 수요 둔화',
    question: '계속 들고 가도 괜찮아 보이는지 같이 봐줄래요?',
    createdByProfileId: 'partner',
    createdLabel: '오늘',
  ),
  StockHolding(
    id: 'holding_seed_3',
    name: '삼성전자',
    status: '정리 고민 중',
    weightLabel: '작게',
    reason: '같이 보는 종목이라 작은 비중으로 남겨뒀어요.',
    watchPoint: '실적 발표 전 수요 코멘트',
    concern: '가격에 기대가 먼저 들어갔는지',
    question: '조금 더 들고 볼지 같이 생각해볼까요?',
    createdByProfileId: 'partner',
    createdLabel: '어제',
  ),
];
