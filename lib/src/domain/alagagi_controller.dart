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
  trips,
  stockStory,
  improvements,
  profileCard,
  wishlist,
  memoryCards,
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
  memoryCards,
  trips,
}

/// 닫힌 폼에 적던 내용. 기기 memory에만 잠깐 남고 Firestore에는 쓰지 않는다.
class TripItemDraft {
  const TripItemDraft({
    required this.kind,
    required this.title,
    required this.note,
    required this.link,
    required this.fromLabel,
    required this.toLabel,
    required this.dateKey,
    required this.timeLabel,
    required this.endDateKey,
    required this.endTimeLabel,
    required this.placeId,
    required this.assigneeProfileId,
    required this.transportMode,
  });

  final TripItemKind kind;
  final String title;
  final String note;
  final String link;
  final String fromLabel;
  final String toLabel;
  final String? dateKey;
  final String? timeLabel;
  final String? endDateKey;
  final String? endTimeLabel;
  final String? placeId;
  final String? assigneeProfileId;
  final TripTransportMode transportMode;

  /// 되살릴 값이 있는가. 제목이나 메모가 없으면 되살릴 이유가 없다.
  bool get hasContent => title.trim().isNotEmpty || note.trim().isNotEmpty;
}

enum ArchiveFilter { all, bothAnswered, similar }

enum ProfileCardTab { partner, me }

enum WishlistFilter { all, mutual, places, activities }

enum WishKind { place, activity }

enum MemoryCardType { likes, dislikes, current, together, care }

enum MemoryCardVisibility { shared, private }

enum MemoryCardReaction { agree, liked, correction }

enum MusicListFilter { all, unlistened, listened, mine, partner }

enum MeetingAvailability { available, maybe, busy }

enum MeetingTimeSlot { morning, afternoon, evening }

/// 장소를 어디서 가져왔는지.
///
/// `kakao`는 국내 지도 검색 결과, `manual`은 직접 적어 넣은 곳이다. 카카오
/// 검색은 국내만 다루므로 해외 여행에서는 직접 입력으로 담는다.
enum MapApiProvider { kakao, manual }

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

/// 기억 카드 입력 한도. UI `maxLength`, controller 검증, `firestore.rules`의
/// `validMemoryCardShape`가 모두 이 값을 따라야 한다. 한 곳만 바꾸면 입력은
/// 되는데 저장이 조용히 실패한다.
const kMemoryCardTitleMinLength = 2;
const kMemoryCardTitleMaxLength = 80;
const kMemoryCardBodyMaxLength = 2000;

/// 수정 제안은 작성자가 반영하면 그대로 카드 본문이 된다. 본문보다 짧게 두면
/// 긴 카드를 통째로 고쳐 제안할 수 없으므로 같은 한도를 쓴다.
const kMemoryCardCorrectionMaxLength = kMemoryCardBodyMaxLength;

const memoryCardTypeOptions = [
  MemoryCardType.likes,
  MemoryCardType.dislikes,
  MemoryCardType.current,
  MemoryCardType.together,
  MemoryCardType.care,
];

enum QuestionDepth { light, daily, beliefs, inner }

enum SaveStatus { idle, saving, saved, failed }

enum HomeProgressSummaryTone { calm, waiting, ready }

enum PushNotificationPermissionStatus {
  unsupported,
  notDetermined,
  denied,
  authorized,
  provisional,
}

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

class PushNotificationSetupState {
  const PushNotificationSetupState({
    required this.supported,
    required this.enabled,
    required this.permissionStatus,
    this.tokenRegistered = false,
    this.inProgress = false,
    this.message = '',
  });

  const PushNotificationSetupState.unsupported()
    : supported = false,
      enabled = false,
      permissionStatus = PushNotificationPermissionStatus.unsupported,
      tokenRegistered = false,
      inProgress = false,
      message = '';

  final bool supported;
  final bool enabled;
  final PushNotificationPermissionStatus permissionStatus;
  final bool tokenRegistered;
  final bool inProgress;
  final String message;

  bool get permissionAllowsNotifications =>
      permissionStatus == PushNotificationPermissionStatus.authorized ||
      permissionStatus == PushNotificationPermissionStatus.provisional;

  PushNotificationSetupState copyWith({
    bool? supported,
    bool? enabled,
    PushNotificationPermissionStatus? permissionStatus,
    bool? tokenRegistered,
    bool? inProgress,
    String? message,
  }) {
    return PushNotificationSetupState(
      supported: supported ?? this.supported,
      enabled: enabled ?? this.enabled,
      permissionStatus: permissionStatus ?? this.permissionStatus,
      tokenRegistered: tokenRegistered ?? this.tokenRegistered,
      inProgress: inProgress ?? this.inProgress,
      message: message ?? this.message,
    );
  }
}

class PushNotificationIntent {
  const PushNotificationIntent({
    required this.route,
    this.feature = '',
    this.targetId = '',
    this.title = '',
    this.body = '',
  });

  final AlagagiRoute route;
  final String feature;
  final String targetId;
  final String title;
  final String body;
}

abstract class AlagagiPushNotificationService {
  bool get isSupported;

  Future<PushNotificationSetupState> loadState({required AlagagiAuthUser user});

  Future<PushNotificationSetupState> enable({
    required AlagagiAuthUser user,
    required AlagagiSession session,
  });

  Future<PushNotificationSetupState> disable({
    required AlagagiAuthUser user,
    required AlagagiSession session,
  });

  Future<void> registerTokenForSession({
    required AlagagiAuthUser user,
    required AlagagiSession session,
    String? token,
  });

  Future<PushNotificationIntent?> initialIntent();

  Stream<PushNotificationIntent> openedIntents();

  Stream<PushNotificationIntent> foregroundIntents();

  Stream<String> tokenRefreshes();
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
    this.profileSlots = const [],
    this.wishes = const [],
    this.musicNotes = const [],
    this.musicNoteComments = const [],
    this.scheduleEntries = const [],
    this.meetingPlans = const [],
    this.sharedPlaces = const [],
    this.trips = const [],
    this.tripItems = const [],
    this.tripPhotos = const [],
    this.curiosityCards = const [],
    this.stockStories = const [],
    this.stockHoldings = const [],
    this.improvementPosts = const [],
    this.memoryCards = const [],
    this.memoryCardResponses = const [],
    this.dailyProgress,
    this.personalization = const SpacePersonalization(),
    this.relationship = const RelationshipMetadata(),
  });

  final List<Answer> answers;
  final List<AnswerComment> answerComments;
  final List<ProfileSlotValue> profileSlots;
  final List<WishItem> wishes;
  final List<MusicNote> musicNotes;
  final List<MusicNoteComment> musicNoteComments;
  final List<ScheduleEntry> scheduleEntries;
  final List<MeetingPlan> meetingPlans;
  final List<SharedPlace> sharedPlaces;
  final List<Trip> trips;
  final List<TripItem> tripItems;
  final List<TripPhoto> tripPhotos;
  final List<CuriosityCard> curiosityCards;
  final List<StockStory> stockStories;
  final List<StockHolding> stockHoldings;
  final List<ImprovementPost> improvementPosts;
  final List<MemoryCard> memoryCards;
  final List<MemoryCardResponse> memoryCardResponses;
  final DailyQuestionProgress? dailyProgress;
  final SpacePersonalization personalization;
  final RelationshipMetadata relationship;
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

  Future<void> saveTrip(String spaceId, Trip trip);

  Future<void> deleteTrip(String spaceId, String tripId);

  Future<void> saveTripItem(String spaceId, TripItem item);

  Future<void> deleteTripItem(String spaceId, String itemId);

  /// 여행 사진은 session 로딩에 넣지 않는다. 문서 하나가 수백 KB라 앱을 열
  /// 때마다 전부 받으면 홈 진입이 느려지고 전송량도 크게 든다.
  Future<List<TripPhoto>> loadTripPhotos(String spaceId, String tripId);

  Future<void> saveTripPhoto(String spaceId, TripPhoto photo);

  Future<void> deleteTripPhoto(String spaceId, String photoId);

  Future<void> saveWish(String spaceId, WishItem wish);

  Future<void> deleteWish(String spaceId, String wishId);

  Future<void> saveMemoryCard(String spaceId, MemoryCard card);

  Future<void> saveMemoryCardResponse(
    String spaceId,
    MemoryCardResponse response,
  );

  Future<void> saveMusicNote(String spaceId, MusicNote note);

  Future<void> saveMusicNoteListenState(String spaceId, MusicNote note);

  Future<void> deleteMusicNote(String spaceId, String noteId);

  Future<void> saveMusicNoteComment(String spaceId, MusicNoteComment comment);

  Future<void> deleteMusicNoteComment(String spaceId, String commentId);

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

  /// 질문 문구와 id는 그대로 두고 순서 번호만 옮긴다.
  DailyQuestion withDay(int newDay) => DailyQuestion(
    id: id,
    day: newDay,
    number: newDay,
    depth: depth,
    text: text,
    highlightedText: highlightedText,
  );
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
    this.replyBody = '',
    this.repliedByProfileId = '',
    this.replyCreatedLabel = '',
    this.replyEdited = false,
  });

  final String questionId;
  final String answerOwnerProfileId;
  final String commenterProfileId;
  final String body;
  final String createdLabel;
  final bool edited;
  final String replyBody;
  final String repliedByProfileId;
  final String replyCreatedLabel;
  final bool replyEdited;

  bool get hasReply => replyBody.trim().isNotEmpty;

  AnswerComment copyWith({
    String? body,
    String? createdLabel,
    bool? edited,
    String? replyBody,
    String? repliedByProfileId,
    String? replyCreatedLabel,
    bool? replyEdited,
  }) {
    return AnswerComment(
      questionId: questionId,
      answerOwnerProfileId: answerOwnerProfileId,
      commenterProfileId: commenterProfileId,
      body: body ?? this.body,
      createdLabel: createdLabel ?? this.createdLabel,
      edited: edited ?? this.edited,
      replyBody: replyBody ?? this.replyBody,
      repliedByProfileId: repliedByProfileId ?? this.repliedByProfileId,
      replyCreatedLabel: replyCreatedLabel ?? this.replyCreatedLabel,
      replyEdited: replyEdited ?? this.replyEdited,
    );
  }
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

const kRelationshipStartedDateKey = '2026-07-05';

/// 이 space에서 첫 질문을 연 날. `progress/daily`의 `startedDateKey`가 기준이고,
/// 이 상수는 그 문서를 읽지 못했을 때 쓰는 fallback이다.
///
/// [kRelationshipStartedDateKey]와는 다른 값이다. 그쪽은 홈 헤더에 보여주는
/// 관계 시작일이고, 이 값은 질문 순서를 세는 기준일이다.
const kQuestionStartedDateKey = '2026-06-09';

class RelationshipMetadata {
  const RelationshipMetadata({
    this.startedDateKey = kRelationshipStartedDateKey,
  });

  final String startedDateKey;

  RelationshipMetadata copyWith({String? startedDateKey}) {
    return RelationshipMetadata(
      startedDateKey: startedDateKey ?? this.startedDateKey,
    );
  }
}

class SpacePersonalization {
  const SpacePersonalization({
    this.appTitle = '우리 둘',
    this.homeLine = '오늘도 우리를 조금 남겨요',
    this.inviteLine = '하루에 하나씩, 우리 이야기를 쌓아요',
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
  if (appTitle.isEmpty || appTitle == '알아가기' || appTitle == '조금씩') {
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

const profileSlotCatalogV3 = [
  ProfileSlot(
    id: 'now_song',
    icon: 'music',
    label: '요즘 반복 재생',
    category: '취향',
    inputHint: '요즘 계속 듣는 노래',
  ),
  ProfileSlot(
    id: 'now_craving',
    icon: 'food',
    label: '요즘 당기는 음식',
    category: '취향',
    inputHint: '자꾸 생각나는 음식',
  ),
  ProfileSlot(
    id: 'now_favorite',
    icon: 'taste',
    label: '요즘 마음에 든 것',
    category: '취향',
    inputHint: '드라마, 물건, 장소 무엇이든',
  ),
  ProfileSlot(
    id: 'money_ok',
    icon: 'object',
    label: '아깝지 않은 소비',
    category: '취향',
    inputHint: '돈을 써도 좋은 항목',
  ),
  ProfileSlot(
    id: 'small_joy',
    icon: 'joy',
    label: '사소하지만 좋아하는 것',
    category: '취향',
    inputHint: '남들은 몰라도 좋은 것',
  ),
  ProfileSlot(
    id: 'day_rhythm',
    icon: 'time',
    label: '하루 중 좋은 시간',
    category: '하루',
    inputHint: '컨디션이 좋은 시간대',
  ),
  ProfileSlot(
    id: 'recharge_way',
    icon: 'recharge',
    label: '충전되는 방식',
    category: '하루',
    inputHint: '혼자 또는 같이, 쉬는 법',
  ),
  ProfileSlot(
    id: 'tired_signal',
    icon: 'tired',
    label: '지칠 때 나오는 모습',
    category: '하루',
    inputHint: '피곤하면 이렇게 돼요',
  ),
  ProfileSlot(
    id: 'week_shape',
    icon: 'week',
    label: '요즘 일주일의 밀도',
    category: '하루',
    inputHint: '바쁜 요일과 여유로운 요일',
  ),
  ProfileSlot(
    id: 'night_routine',
    icon: 'night',
    label: '잠들기 전 하는 일',
    category: '하루',
    inputHint: '자기 전 루틴',
  ),
  ProfileSlot(
    id: 'reply_pace',
    icon: 'reply',
    label: '편한 연락 속도',
    category: '대화',
    inputHint: '자주 또는 필요할 때',
  ),
  ProfileSlot(
    id: 'call_or_text',
    icon: 'call',
    label: '통화와 메시지 중',
    category: '대화',
    inputHint: '더 편한 쪽',
  ),
  ProfileSlot(
    id: 'busy_signal',
    icon: 'busy',
    label: '바쁠 때 알려주는 법',
    category: '대화',
    inputHint: '연락이 뜸해질 때 신호',
  ),
  ProfileSlot(
    id: 'upset_style',
    icon: 'upset',
    label: '서운할 때의 나',
    category: '대화',
    inputHint: '기분이 상하면 이렇게 돼요',
  ),
  ProfileSlot(
    id: 'words_i_like',
    icon: 'words',
    label: '들으면 기분 좋아지는 말',
    category: '대화',
    inputHint: '자주 듣고 싶은 말',
  ),
  ProfileSlot(
    id: 'meet_flow',
    icon: 'flow',
    label: '만날 때 좋은 흐름',
    category: '함께',
    inputHint: '미리 정하는 편인지 그때 정하는 편인지',
  ),
  ProfileSlot(
    id: 'quiet_together',
    icon: 'quiet',
    label: '같이 있을 때 조용한 시간',
    category: '함께',
    inputHint: '말없이 있는 시간의 느낌',
  ),
  ProfileSlot(
    id: 'next_plan',
    icon: 'scene',
    label: '다음에 같이 하고 싶은 것',
    category: '함께',
    inputHint: '가까운 시일에 해보고 싶은 것',
  ),
  ProfileSlot(
    id: 'comfort_place',
    icon: 'place',
    label: '둘이 있기 좋은 장소',
    category: '함께',
    inputHint: '편하게 느껴지는 공간',
  ),
  ProfileSlot(
    id: 'care_wish',
    icon: 'care',
    label: '힘들 때 받고 싶은 것',
    category: '함께',
    inputHint: '위로가 되는 방식',
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

enum TripStatus { planning, done }

extension TripStatusMeta on TripStatus {
  String get storageKey => switch (this) {
    TripStatus.planning => 'planning',
    TripStatus.done => 'done',
  };

  String get label => switch (this) {
    TripStatus.planning => '계획 중',
    TripStatus.done => '다녀옴',
  };
}

/// 이동 수단. 아이콘과 기본 문구가 여기에 붙는다.
enum TripTransportMode { flight, train, bus, car, ship, walk }

extension TripTransportModeMeta on TripTransportMode {
  String get storageKey => switch (this) {
    TripTransportMode.flight => 'flight',
    TripTransportMode.train => 'train',
    TripTransportMode.bus => 'bus',
    TripTransportMode.car => 'car',
    TripTransportMode.ship => 'ship',
    TripTransportMode.walk => 'walk',
  };

  String get label => switch (this) {
    TripTransportMode.flight => '비행기',
    TripTransportMode.train => '기차',
    TripTransportMode.bus => '버스',
    TripTransportMode.car => '자동차',
    TripTransportMode.ship => '배',
    TripTransportMode.walk => '도보',
  };

  /// 편명, 호선처럼 수단마다 다르게 부르는 값의 예시.
  String get titleHint => switch (this) {
    TripTransportMode.flight => '예: KE1201',
    TripTransportMode.train => '예: KTX 101',
    TripTransportMode.bus => '예: 공항버스 6015',
    TripTransportMode.car => '예: 렌터카',
    TripTransportMode.ship => '예: 완도-제주 페리',
    TripTransportMode.walk => '예: 숙소까지 걷기',
  };
}

const tripTransportModeOptions = TripTransportMode.values;

TripTransportMode tripTransportModeFromKey(String? key) => switch (key) {
  'flight' => TripTransportMode.flight,
  'train' => TripTransportMode.train,
  'bus' => TripTransportMode.bus,
  'car' => TripTransportMode.car,
  'ship' => TripTransportMode.ship,
  'walk' => TripTransportMode.walk,
  _ => TripTransportMode.flight,
};

/// `memo`는 일정도 숙소도 준비물도 아닌 것들을 적어두는 갈래다.
/// 종류 picker에는 넣지 않는다. 상세 위쪽 메모 카드에서만 담는다.
enum TripItemKind { stay, transport, packing, plan, memo }


extension TripItemKindMeta on TripItemKind {
  String get storageKey => switch (this) {
    TripItemKind.stay => 'stay',
    TripItemKind.transport => 'transport',
    TripItemKind.packing => 'packing',
    TripItemKind.plan => 'plan',
    TripItemKind.memo => 'memo',
  };

  String get label => switch (this) {
    TripItemKind.stay => '숙소',
    TripItemKind.transport => '이동',
    TripItemKind.packing => '준비물',
    TripItemKind.plan => '계획',
    TripItemKind.memo => '메모',
  };

  String get titleHint => switch (this) {
    TripItemKind.stay => '묵을 곳 이름',
    TripItemKind.transport => '편명이나 노선',
    TripItemKind.packing => '챙길 것',
    TripItemKind.plan => '무엇을 할지',
    TripItemKind.memo => '적어둘 것',
  };

  String get noteHint => switch (this) {
    TripItemKind.stay => '주소나 예약 정보 같은 메모',
    TripItemKind.transport => '좌석, 예약 번호 같은 메모',
    TripItemKind.packing => '수량이나 챙길 이유',
    TripItemKind.plan => '가고 싶은 곳이나 하고 싶은 것',
    TripItemKind.memo => '',
  };

  String get emptyText => switch (this) {
    TripItemKind.stay => '아직 정한 숙소가 없어요. 필요할 때 채우면 돼요.',
    TripItemKind.transport => '아직 정한 이동편이 없어요.',
    TripItemKind.packing => '챙길 것을 하나씩 적어두면 편해요.',
    TripItemKind.plan => '아직 정한 계획이 없어요. 천천히 채워도 괜찮아요.',
    TripItemKind.memo => '일정도 준비물도 아닌 것들을 여기 적어둬요.',
  };

  bool get usesCheck => this == TripItemKind.packing;

  /// 다녀온 뒤 `했다`를 표시할 수 있는 종류인지.
  ///
  /// 준비물의 체크가 `챙겼다`라면 계획의 체크는 `했다`다. 표시가 없으면
  /// 다녀온 뒤에도 타임라인이 계획인지 기록인지 구분되지 않는다.
  bool get usesDoneToggle => this == TripItemKind.plan;

  /// 숙소는 하룻밤을 통째로 차지하므로 하루 안의 시각 흐름에 끼우지 않고
  /// 그날 머무는 곳으로 따로 보여준다. 준비물은 시간과 무관한 목록이다.
  bool get appearsOnTimeline =>
      this == TripItemKind.transport || this == TripItemKind.plan;

  /// 날짜 범위를 갖는 종류인지. 숙소만 체크인~체크아웃을 가진다.
  bool get usesDateRange => this == TripItemKind.stay;

  /// 출발/도착 시각과 수단을 갖는 종류인지.
  bool get usesRoute => this == TripItemKind.transport;

  /// 장소를 붙일 수 있는 종류인지. 숙소와 계획은 실제 장소가 있다.
  bool get usesPlace => this == TripItemKind.stay || this == TripItemKind.plan;
}

/// 종류 picker에 보여줄 갈래. `memo`는 상세 위 메모 카드에서만 담는다.
const tripItemKindOptions = [
  TripItemKind.stay,
  TripItemKind.transport,
  TripItemKind.packing,
  TripItemKind.plan,
];

enum TripPhase { upcoming, ongoing, past }

/// 오늘 기준 여행의 위치.
class TripTiming {
  const TripTiming({
    required this.phase,
    required this.daysUntilStart,
    this.dayNumber = 0,
  });

  final TripPhase phase;

  /// 시작까지 남은 날. 이미 시작했으면 0이다.
  final int daysUntilStart;

  /// 여행 중일 때 오늘이 며칠째인지.
  final int dayNumber;

  /// `D-12`, `여행 2일차`, `다녀온 여행`.
  String get label => switch (phase) {
    TripPhase.upcoming => daysUntilStart == 0 ? 'D-DAY' : 'D-$daysUntilStart',
    TripPhase.ongoing => '여행 $dayNumber일차',
    TripPhase.past => '다녀온 여행',
  };
}

class Trip {
  const Trip({
    required this.id,
    required this.title,
    required this.destination,
    required this.startDateKey,
    required this.endDateKey,
    required this.createdByProfileId,
    this.status = TripStatus.planning,
    this.note = '',
    this.updatedAt,
    this.updatedByProfileId,
  });

  final String id;
  final String title;
  final String destination;
  final String startDateKey;
  final String endDateKey;
  final String createdByProfileId;
  final TripStatus status;
  final String note;

  final DateTime? updatedAt;
  final String? updatedByProfileId;

  DateTime? get startDate => DateTime.tryParse(startDateKey);

  DateTime? get endDate => DateTime.tryParse(endDateKey);

  /// 시작일과 종료일 사이의 밤 수. 같은 날이면 0이다.
  int get nightCount {
    final start = startDate;
    final end = endDate;
    if (start == null || end == null) {
      return 0;
    }
    final nights = end.difference(start).inDays;
    return nights < 0 ? 0 : nights;
  }

  int get dayCount => nightCount + 1;

  String get durationLabel =>
      nightCount == 0 ? '당일' : '$nightCount박 $dayCount일';

  /// 여행 기간에 포함되는 날짜 key 목록.
  List<String> get dateKeys {
    final start = startDate;
    if (start == null) {
      return const [];
    }
    return List<String>.unmodifiable([
      for (var offset = 0; offset < dayCount; offset += 1)
        _tripDateKey(start.add(Duration(days: offset))),
    ]);
  }

  bool containsDateKey(String dateKey) => dateKeys.contains(dateKey);

  Trip copyWith({
    String? title,
    String? destination,
    String? startDateKey,
    String? endDateKey,
    TripStatus? status,
    String? note,
    DateTime? updatedAt,
    String? updatedByProfileId,
  }) {
    return Trip(
      id: id,
      title: title ?? this.title,
      destination: destination ?? this.destination,
      startDateKey: startDateKey ?? this.startDateKey,
      endDateKey: endDateKey ?? this.endDateKey,
      createdByProfileId: createdByProfileId,
      status: status ?? this.status,
      note: note ?? this.note,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedByProfileId: updatedByProfileId ?? this.updatedByProfileId,
    );
  }
}

class TripItem {
  const TripItem({
    required this.id,
    required this.tripId,
    required this.kind,
    required this.title,
    required this.createdByProfileId,
    this.note = '',
    this.dateKey,
    this.timeLabel,
    this.endDateKey,
    this.endTimeLabel,
    this.transportMode,
    this.fromLabel,
    this.toLabel,
    this.placeId,
    this.link,
    this.assigneeProfileId,
    this.sortOrder = 0,
    this.checked = false,
    this.updatedAt,
    this.updatedByProfileId,
  });

  final String id;
  final String tripId;
  final TripItemKind kind;
  final String title;
  final String createdByProfileId;
  final String note;
  final String? dateKey;

  /// `09:30` 형태의 시각. 숙소는 체크인, 이동은 출발 시각이다.
  /// 없으면 그날 안에서 시간 미정으로 뒤에 놓인다.
  final String? timeLabel;

  /// 숙소 체크아웃 날짜. 숙소에만 쓴다.
  final String? endDateKey;

  /// 숙소 체크아웃 시각 또는 이동 도착 시각.
  final String? endTimeLabel;

  /// 이동 수단. 이동에만 쓴다.
  final TripTransportMode? transportMode;

  /// 이동 출발지와 도착지.
  final String? fromLabel;
  final String? toLabel;

  /// 장소 보드에 저장해둔 장소 id. 식당이나 카페를 일정에 붙일 때 쓴다.
  final String? placeId;
  final String? link;

  /// 준비물을 챙기기로 한 사람. 정하지 않으면 둘 중 누구든이다.
  final String? assigneeProfileId;

  /// 같은 날 같은 시각일 때의 순서. 사용자가 끌어서 바꾼 값이다.
  final int sortOrder;

  final bool checked;

  final DateTime? updatedAt;
  final String? updatedByProfileId;

  /// 숙소가 덮는 밤 수. 체크인 다음 날 체크아웃이면 1박이다.
  int get stayNightCount {
    final start = DateTime.tryParse(dateKey ?? '');
    final end = DateTime.tryParse(endDateKey ?? '');
    if (start == null || end == null) {
      return 0;
    }
    final nights = end.difference(start).inDays;
    return nights < 0 ? 0 : nights;
  }

  /// 이 숙소가 `dateKey` 밤에 머무는 곳인지. 체크아웃 당일 밤은 제외한다.
  bool coversNight(String nightDateKey) {
    if (kind != TripItemKind.stay) {
      return false;
    }
    final start = DateTime.tryParse(dateKey ?? '');
    final night = DateTime.tryParse(nightDateKey);
    if (start == null || night == null) {
      return false;
    }
    final end = DateTime.tryParse(endDateKey ?? '');
    if (end == null) {
      // 체크아웃을 아직 안 정했으면 체크인 당일만 표시한다.
      return night == start;
    }
    return !night.isBefore(start) && night.isBefore(end);
  }

  TripItem copyWith({
    TripItemKind? kind,
    String? title,
    String? note,
    String? dateKey,
    bool clearDateKey = false,
    String? timeLabel,
    bool clearTimeLabel = false,
    String? endDateKey,
    bool clearEndDateKey = false,
    String? endTimeLabel,
    bool clearEndTimeLabel = false,
    TripTransportMode? transportMode,
    bool clearTransportMode = false,
    String? fromLabel,
    bool clearFromLabel = false,
    String? toLabel,
    bool clearToLabel = false,
    String? placeId,
    bool clearPlaceId = false,
    String? link,
    bool clearLink = false,
    String? assigneeProfileId,
    bool clearAssignee = false,
    int? sortOrder,
    bool? checked,
    DateTime? updatedAt,
    String? updatedByProfileId,
  }) {
    return TripItem(
      id: id,
      tripId: tripId,
      kind: kind ?? this.kind,
      title: title ?? this.title,
      createdByProfileId: createdByProfileId,
      note: note ?? this.note,
      dateKey: clearDateKey ? null : dateKey ?? this.dateKey,
      timeLabel: clearTimeLabel ? null : timeLabel ?? this.timeLabel,
      endDateKey: clearEndDateKey ? null : endDateKey ?? this.endDateKey,
      endTimeLabel: clearEndTimeLabel
          ? null
          : endTimeLabel ?? this.endTimeLabel,
      transportMode: clearTransportMode
          ? null
          : transportMode ?? this.transportMode,
      fromLabel: clearFromLabel ? null : fromLabel ?? this.fromLabel,
      toLabel: clearToLabel ? null : toLabel ?? this.toLabel,
      placeId: clearPlaceId ? null : placeId ?? this.placeId,
      link: clearLink ? null : link ?? this.link,
      assigneeProfileId: clearAssignee
          ? null
          : assigneeProfileId ?? this.assigneeProfileId,
      sortOrder: sortOrder ?? this.sortOrder,
      checked: checked ?? this.checked,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedByProfileId: updatedByProfileId ?? this.updatedByProfileId,
    );
  }
}

/// 여행에 붙이는 사진 한 장.
///
/// Spark plan에는 Cloud Storage를 쓰지 않으므로 이미지는 앱에서 줄인 뒤
/// data URI 문자열로 Firestore 문서 하나에 담는다. 그래서 크기 상한이 있다.
class TripPhoto {
  const TripPhoto({
    required this.id,
    required this.tripId,
    required this.imageDataUrl,
    required this.createdByProfileId,
    this.caption = '',
    this.dateKey,
    this.updatedAt,
  });

  final String id;
  final String tripId;

  /// `data:image/jpeg;base64,...` 형태.
  final String imageDataUrl;
  final String createdByProfileId;
  final String caption;
  final String? dateKey;
  final DateTime? updatedAt;
}

/// 사진 data URI 상한. Firestore 문서 한도(1MiB)와 목록 로딩 비용을 함께 본다.
const kTripPhotoMaxDataUrlLength = 700000;

/// 사진 설명 상한. UI, controller, `firestore.rules`가 같은 값을 쓴다.
const kTripPhotoMaxCaptionLength = 200;

/// 준비물을 둘이 함께 챙길 때 쓰는 담당 값.
///
/// member uid와 같은 자리에 담기지만 사람이 아니다. uid와 겹치지 않도록
/// Firebase uid에 쓰이지 않는 형태로 둔다.
const kTripSharedAssigneeId = 'both';

/// 여행 하루. 타임라인은 이 묶음을 날짜순으로 이어 붙여 만든다.
class TripDay {
  const TripDay({
    required this.dateKey,
    required this.dayNumber,
    required this.items,
  });

  /// 날짜 미정 묶음은 `dateKey`가 비어 있고 [dayNumber]가 0이다.
  final String dateKey;
  final int dayNumber;
  final List<TripItem> items;

  bool get isUndated => dateKey.isEmpty;

  DateTime? get date => DateTime.tryParse(dateKey);

  /// `9월 12일 (토)` 형태. 날짜 미정이면 안내 문구를 돌려준다.
  String get dateLabel {
    final parsed = date;
    if (parsed == null) {
      return '날짜 미정';
    }
    return '${parsed.month}월 ${parsed.day}일 (${tripWeekdayLabel(parsed)})';
  }

  String get dayLabel => isUndated ? '언제든' : '$dayNumber일차';
}

const _tripWeekdayLabels = ['월', '화', '수', '목', '금', '토', '일'];

String tripWeekdayLabel(DateTime date) =>
    _tripWeekdayLabels[(date.weekday - 1) % 7];

/// 시각 표기는 `HH:mm`만 받는다. 비어 있으면 시간 미정이다.
bool isValidTripTimeLabel(String value) {
  final match = RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$').firstMatch(value);
  return match != null;
}

String _tripDateKey(DateTime date) {
  String twoDigits(int value) => value.toString().padLeft(2, '0');
  return '${date.year}-${twoDigits(date.month)}-${twoDigits(date.day)}';
}

extension MemoryCardTypeMeta on MemoryCardType {
  String get label {
    return switch (this) {
      MemoryCardType.likes => '좋아하는 것',
      MemoryCardType.dislikes => '싫어하는 것',
      MemoryCardType.current => '요즘 이야기',
      MemoryCardType.together => '함께 할 것',
      MemoryCardType.care => '조심할 것',
    };
  }

  String get storageKey {
    return switch (this) {
      MemoryCardType.likes => 'likes',
      MemoryCardType.dislikes => 'dislikes',
      MemoryCardType.current => 'current',
      MemoryCardType.together => 'together',
      MemoryCardType.care => 'care',
    };
  }
}

extension MemoryCardVisibilityMeta on MemoryCardVisibility {
  String get label {
    return switch (this) {
      MemoryCardVisibility.shared => '공유',
      MemoryCardVisibility.private => '나만 보기',
    };
  }

  String get storageKey {
    return switch (this) {
      MemoryCardVisibility.shared => 'shared',
      MemoryCardVisibility.private => 'private',
    };
  }
}

extension MemoryCardReactionMeta on MemoryCardReaction {
  String get label {
    return switch (this) {
      MemoryCardReaction.agree => '맞아요',
      MemoryCardReaction.liked => '좋아요',
      MemoryCardReaction.correction => '수정 제안',
    };
  }

  String get storageKey {
    return switch (this) {
      MemoryCardReaction.agree => 'agree',
      MemoryCardReaction.liked => 'liked',
      MemoryCardReaction.correction => 'correction',
    };
  }
}

class MemoryCard {
  const MemoryCard({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.createdByProfileId,
    required this.subjectProfileId,
    required this.visibility,
    required this.createdLabel,
    this.updatedAt,
    this.updatedByProfileId,
  });

  final String id;
  final MemoryCardType type;
  final String title;
  final String body;
  final String createdByProfileId;
  final String subjectProfileId;
  final MemoryCardVisibility visibility;
  final String createdLabel;
  final DateTime? updatedAt;
  final String? updatedByProfileId;

  bool get isShared => visibility == MemoryCardVisibility.shared;

  String get lastChangedByProfileId => updatedByProfileId ?? createdByProfileId;

  MemoryCard copyWith({
    MemoryCardType? type,
    String? title,
    String? body,
    String? createdByProfileId,
    String? subjectProfileId,
    MemoryCardVisibility? visibility,
    String? createdLabel,
    DateTime? updatedAt,
    String? updatedByProfileId,
  }) {
    return MemoryCard(
      id: id,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      createdByProfileId: createdByProfileId ?? this.createdByProfileId,
      subjectProfileId: subjectProfileId ?? this.subjectProfileId,
      visibility: visibility ?? this.visibility,
      createdLabel: createdLabel ?? this.createdLabel,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedByProfileId: updatedByProfileId ?? this.updatedByProfileId,
    );
  }
}

class MemoryCardResponse {
  const MemoryCardResponse({
    required this.id,
    required this.cardId,
    required this.responderProfileId,
    required this.reaction,
    this.correctionText = '',
    this.updatedAt,
  });

  final String id;
  final String cardId;
  final String responderProfileId;
  final MemoryCardReaction reaction;
  final String correctionText;
  final DateTime? updatedAt;

  bool get hasCorrection => correctionText.trim().isNotEmpty;

  MemoryCardResponse copyWith({
    MemoryCardReaction? reaction,
    String? correctionText,
    DateTime? updatedAt,
  }) {
    return MemoryCardResponse(
      id: id,
      cardId: cardId,
      responderProfileId: responderProfileId,
      reaction: reaction ?? this.reaction,
      correctionText: correctionText ?? this.correctionText,
      updatedAt: updatedAt ?? this.updatedAt,
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

class MusicNoteComment {
  const MusicNoteComment({
    required this.id,
    required this.musicNoteId,
    required this.body,
    required this.createdByProfileId,
    required this.createdLabel,
    this.edited = false,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String musicNoteId;
  final String body;
  final String createdByProfileId;
  final String createdLabel;
  final bool edited;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MusicNoteComment copyWith({
    String? body,
    bool? edited,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MusicNoteComment(
      id: id,
      musicNoteId: musicNoteId,
      body: body ?? this.body,
      createdByProfileId: createdByProfileId,
      createdLabel: createdLabel,
      edited: edited ?? this.edited,
      createdAt: createdAt ?? this.createdAt,
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
    this.isCancelled = false,
    this.updatedAt,
  });

  final String dateKey;
  final List<String> items;
  final String updatedByProfileId;
  final bool isCancelled;
  final DateTime? updatedAt;

  String get id => dateKey;

  MeetingPlan copyWith({
    List<String>? items,
    String? updatedByProfileId,
    bool? isCancelled,
    DateTime? updatedAt,
  }) {
    return MeetingPlan(
      dateKey: dateKey,
      items: items ?? this.items,
      updatedByProfileId: updatedByProfileId ?? this.updatedByProfileId,
      isCancelled: isCancelled ?? this.isCancelled,
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

/// 구글 지도 검색 주소.
///
/// 휴대폰에서 이 주소를 열면 구글 지도 app이 있으면 app으로, 없으면 web으로
/// 이어진다. 앱마다 다른 scheme을 쓰지 않아도 되는 유일한 방법이다.
/// 카카오 검색은 국내만 되므로 해외 장소는 여기에 기댄다.
String googleMapsSearchUrl(String query) {
  final trimmed = query.trim();
  if (trimmed.isEmpty) {
    return 'https://www.google.com/maps';
  }
  return 'https://www.google.com/maps/search/?api=1'
      '&query=${Uri.encodeComponent(trimmed)}';
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
    this.mapLink = '',
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

  /// 사용자가 붙여넣은 지도 링크. 좌표가 없는 직접 입력 장소를 지도로 잇는다.
  final String mapLink;
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

  /// 이 장소를 구글 지도에서 여는 주소.
  ///
  /// 붙여넣은 링크가 있으면 그대로 쓰고, 좌표가 있으면 좌표로, 둘 다 없으면
  /// 이름과 주소로 검색한다. 카카오로 담은 국내 장소도 해외에서 쓰는 지도
  /// 앱으로 열 수 있게 항상 값을 돌려준다.
  String get googleMapsUrl {
    final link = mapLink.trim();
    if (link.isNotEmpty) {
      return link;
    }
    final latitude = this.latitude;
    final longitude = this.longitude;
    if (latitude != null && longitude != null) {
      // 좌표는 그대로 넘긴다. 쉼표를 %2C로 바꾸면 구글이 받기는 해도
      // 문서에 적힌 형태가 아니고, 기존 링크와 모양이 달라진다.
      return 'https://www.google.com/maps/search/?api=1'
          '&query=$latitude,$longitude';
    }
    return googleMapsSearchUrl(
      [name.trim(), address.trim()].where((part) => part.isNotEmpty).join(' '),
    );
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
    String? mapLink,
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
      mapLink: mapLink ?? this.mapLink,
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
      UnreadActivityFeature.memoryCards => 'memoryCards',
      UnreadActivityFeature.trips => 'trips',
    };
  }

  String get label {
    return switch (this) {
      UnreadActivityFeature.profileCard => '서로 노트',
      UnreadActivityFeature.wishlist => '언젠가, 같이',
      UnreadActivityFeature.meetings => '데이트',
      UnreadActivityFeature.places => '장소',
      UnreadActivityFeature.curiosity => '궁금함',
      UnreadActivityFeature.stocks => '주식 이야기',
      UnreadActivityFeature.music => '음악 노트',
      UnreadActivityFeature.improvements => '건의함',
      UnreadActivityFeature.memoryCards => '서로의 기억',
      UnreadActivityFeature.trips => '여행 계획',
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
      UnreadActivityFeature.memoryCards => AlagagiRoute.memoryCards,
      UnreadActivityFeature.trips => AlagagiRoute.trips,
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

const renewalWelcomeVersion = 'couple-2026-07-05-v1';

abstract class RenewalWelcomeStore {
  bool hasSeenRenewalWelcome(String spaceId, String profileId, String version);

  void markRenewalWelcomeSeen(String spaceId, String profileId, String version);
}

class MemoryRenewalWelcomeStore implements RenewalWelcomeStore {
  final Set<String> _seenKeys = {};

  @override
  bool hasSeenRenewalWelcome(String spaceId, String profileId, String version) {
    return _seenKeys.contains(_key(spaceId, profileId, version));
  }

  @override
  void markRenewalWelcomeSeen(
    String spaceId,
    String profileId,
    String version,
  ) {
    _seenKeys.add(_key(spaceId, profileId, version));
  }

  static String _key(String spaceId, String profileId, String version) {
    return 'jogeumssik:renewalWelcomeSeen:$version:$spaceId:$profileId';
  }
}

bool _isMinyoungProfile(AppProfile profile) {
  final id = profile.id.toLowerCase();
  final nickname = profile.nickname.trim().toLowerCase();
  return id.contains('minyoung') || nickname == '민영';
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
    this.musicCommentDraftsByNoteId = const {},
    this.musicCommentEditDraftsByCommentId = const {},
    this.musicCommentError,
    this.musicCommentSaveStatus = SaveStatus.idle,
    this.musicCommentSaveFeedback,
    this.musicCommentSaveTargetId,
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
    this.tripSaveStatus = SaveStatus.idle,
    this.tripSaveFeedback,
    this.tripSaveError,
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
    this.commentReplyDraftsByCommentKey = const {},
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
    this.renewalWelcomeVisible = false,
  });

  final AppProfile me;
  final AppProfile partner;
  final AlagagiRoute route;
  final ArchiveFilter archiveFilter;
  final ProfileCardTab profileCardTab;
  final WishlistFilter wishlistFilter;
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
  final Map<String, String> musicCommentDraftsByNoteId;
  final Map<String, String> musicCommentEditDraftsByCommentId;
  final String? musicCommentError;
  final SaveStatus musicCommentSaveStatus;
  final String? musicCommentSaveFeedback;
  final String? musicCommentSaveTargetId;
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

  /// 여행 저장 상태. 다른 기능과 같은 채널을 여행에도 둔다. 이게 없으면
  /// write가 실패해도 화면은 성공한 것처럼 보이고 다음 진입에 조용히 되돌아간다.
  final SaveStatus tripSaveStatus;
  final String? tripSaveFeedback;
  final String? tripSaveError;
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
  final Map<String, String> commentReplyDraftsByCommentKey;
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
  final bool renewalWelcomeVisible;

  AlagagiState copyWith({
    AppProfile? me,
    AppProfile? partner,
    AlagagiRoute? route,
    ArchiveFilter? archiveFilter,
    ProfileCardTab? profileCardTab,
    WishlistFilter? wishlistFilter,
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
    Map<String, String>? musicCommentDraftsByNoteId,
    Map<String, String>? musicCommentEditDraftsByCommentId,
    String? musicCommentError,
    bool clearMusicCommentError = false,
    SaveStatus? musicCommentSaveStatus,
    String? musicCommentSaveFeedback,
    bool clearMusicCommentSaveFeedback = false,
    String? musicCommentSaveTargetId,
    bool clearMusicCommentSaveTargetId = false,
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
    SaveStatus? tripSaveStatus,
    String? tripSaveFeedback,
    bool clearTripSaveFeedback = false,
    String? tripSaveError,
    bool clearTripSaveError = false,
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
    Map<String, String>? commentReplyDraftsByCommentKey,
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
    bool? renewalWelcomeVisible,
  }) {
    return AlagagiState(
      me: me ?? this.me,
      partner: partner ?? this.partner,
      route: route ?? this.route,
      archiveFilter: archiveFilter ?? this.archiveFilter,
      profileCardTab: profileCardTab ?? this.profileCardTab,
      wishlistFilter: wishlistFilter ?? this.wishlistFilter,
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
      musicCommentDraftsByNoteId:
          musicCommentDraftsByNoteId ?? this.musicCommentDraftsByNoteId,
      musicCommentEditDraftsByCommentId:
          musicCommentEditDraftsByCommentId ??
          this.musicCommentEditDraftsByCommentId,
      musicCommentError: clearMusicCommentError
          ? null
          : musicCommentError ?? this.musicCommentError,
      musicCommentSaveStatus:
          musicCommentSaveStatus ?? this.musicCommentSaveStatus,
      musicCommentSaveFeedback: clearMusicCommentSaveFeedback
          ? null
          : musicCommentSaveFeedback ?? this.musicCommentSaveFeedback,
      musicCommentSaveTargetId: clearMusicCommentSaveTargetId
          ? null
          : musicCommentSaveTargetId ?? this.musicCommentSaveTargetId,
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
      tripSaveStatus: tripSaveStatus ?? this.tripSaveStatus,
      tripSaveFeedback: clearTripSaveFeedback
          ? null
          : tripSaveFeedback ?? this.tripSaveFeedback,
      tripSaveError: clearTripSaveError
          ? null
          : tripSaveError ?? this.tripSaveError,
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
      commentReplyDraftsByCommentKey:
          commentReplyDraftsByCommentKey ?? this.commentReplyDraftsByCommentKey,
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
      renewalWelcomeVisible:
          renewalWelcomeVisible ?? this.renewalWelcomeVisible,
    );
  }
}

enum _FailedPersistenceAction { save, delete }

enum _TripWriteKind { trip, item, photo }

/// 다시 보낼 수 있게 보관하는 여행 write 한 건.
enum _TripWriteOp { save, delete }

class _PendingTripWrite {
  const _PendingTripWrite._(
    this.kind,
    this.key,
    this._send, {
    this.op = _TripWriteOp.save,
    this.feedback = '여행 내용을 저장했어요.',
    this.restore,
  });

  factory _PendingTripWrite.trip(Trip trip) => _PendingTripWrite._(
    _TripWriteKind.trip,
    'trip:${trip.id}',
    (repository, spaceId) => repository.saveTrip(spaceId, trip),
    feedback: '여행을 저장했어요.',
  );

  factory _PendingTripWrite.item(TripItem item) => _PendingTripWrite._(
    _TripWriteKind.item,
    'item:${item.id}',
    (repository, spaceId) => repository.saveTripItem(spaceId, item),
    feedback: '${item.kind.label}을 저장했어요.',
  );

  factory _PendingTripWrite.photo(
    TripPhoto photo, {
    required String feedback,
  }) => _PendingTripWrite._(
    _TripWriteKind.photo,
    'photo:${photo.id}',
    (repository, spaceId) => repository.saveTripPhoto(spaceId, photo),
    feedback: feedback,
  );

  factory _PendingTripWrite.deleteTrip(String tripId) => _PendingTripWrite._(
    _TripWriteKind.trip,
    'trip:$tripId',
    (repository, spaceId) => repository.deleteTrip(spaceId, tripId),
    op: _TripWriteOp.delete,
    feedback: '여행을 지웠어요.',
  );

  factory _PendingTripWrite.deleteItem(
    TripItem item, {
    void Function()? restore,
  }) => _PendingTripWrite._(
    _TripWriteKind.item,
    'item:${item.id}',
    (repository, spaceId) => repository.deleteTripItem(spaceId, item.id),
    op: _TripWriteOp.delete,
    feedback: '${item.kind.label}을 지웠어요.',
    restore: restore,
  );

  factory _PendingTripWrite.deletePhoto(
    TripPhoto photo, {
    void Function()? restore,
  }) => _PendingTripWrite._(
    _TripWriteKind.photo,
    'photo:${photo.id}',
    (repository, spaceId) => repository.deleteTripPhoto(spaceId, photo.id),
    op: _TripWriteOp.delete,
    feedback: '사진을 지웠어요.',
    restore: restore,
  );

  final _TripWriteKind kind;

  /// 같은 대상의 재시도가 쌓이지 않도록 구분하는 값.
  final String key;
  final _TripWriteOp op;
  final String feedback;

  /// 실패했을 때 화면을 되돌리는 일. 여러 번 불려도 안전해야 한다.
  final void Function()? restore;
  final Future<void> Function(AlagagiDataRepository, String) _send;

  Future<void> send(AlagagiDataRepository repository, String spaceId) =>
      _send(repository, spaceId);
}

class AlagagiController extends ChangeNotifier {
  AlagagiController({
    AlagagiDataRepository? repository,
    MusicNoteSeenStore? musicNoteSeenStore,
    FirstVisitGuideStore? firstVisitGuideStore,
    RenewalWelcomeStore? renewalWelcomeStore,
  }) : _repository = repository,
       _musicNoteSeenStore = musicNoteSeenStore ?? MemoryMusicNoteSeenStore(),
       _firstVisitGuideStore = firstVisitGuideStore,
       _renewalWelcomeStore = renewalWelcomeStore,
       _todayDateKeyOverride = null,
       _spaceId = null,
       _usesDemoData = true,
       _todayQuestion = seedQuestions.first,
       _dailyProgress = const DailyQuestionProgress(
         startedDateKey: '2026-06-08',
         currentQuestionId: 'q12',
         openedDateKey: '2026-06-08',
       ),
       _relationship = const RelationshipMetadata(),
       questions = seedQuestions,
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
    RenewalWelcomeStore? renewalWelcomeStore,
    String? todayDateKey,
  }) : _repository = repository,
       _musicNoteSeenStore = musicNoteSeenStore ?? MemoryMusicNoteSeenStore(),
       _firstVisitGuideStore = firstVisitGuideStore,
       _renewalWelcomeStore = renewalWelcomeStore,
       _todayDateKeyOverride = todayDateKey,
       _spaceId = session.spaceId,
       _usesDemoData = false,
       _dailyProgress = _resolveDailyQuestionProgress(
         _sessionQuestionCatalog(session, todayDateKey),
         session.data.dailyProgress,
         todayDateKey: todayDateKey,
       ),
       _relationship = session.data.relationship,
       _todayQuestion = _questionForProgress(
         _sessionQuestionCatalog(session, todayDateKey),
         _resolveDailyQuestionProgress(
           _sessionQuestionCatalog(session, todayDateKey),
           session.data.dailyProgress,
           todayDateKey: todayDateKey,
         ),
       ),
       questions = _sessionQuestionCatalog(session, todayDateKey),
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
    _initializeRenewalWelcome();
  }

  AlagagiState _state;
  final AlagagiDataRepository? _repository;
  final MusicNoteSeenStore _musicNoteSeenStore;
  final FirstVisitGuideStore? _firstVisitGuideStore;
  final RenewalWelcomeStore? _renewalWelcomeStore;
  final String? _todayDateKeyOverride;
  final String? _spaceId;
  final bool _usesDemoData;

  DailyQuestion _todayQuestion;
  DailyQuestionProgress _dailyProgress;
  RelationshipMetadata _relationship;
  final List<DailyQuestion> questions;

  final Map<String, Answer> _myAnswersByQuestionId = {};
  final Map<String, Answer> _partnerAnswersByQuestionId = {};
  final Set<String> _persistedMyAnswerQuestionIds = {};
  final Map<String, AnswerComment> _answerCommentsByKey = {};
  final List<ProfileCardData> _profileCards = [];
  final List<WishItem> _wishes = [];
  final List<Trip> _trips = [];
  final List<TripItem> _tripItems = [];
  final List<TripPhoto> _tripPhotos = [];

  /// 사진을 읽어둔 여행. 여행 하나를 열 때 그 여행 것만 읽는다.
  final Set<String> _loadedPhotoTripIds = {};

  /// 여행별로 진행 중인 사진 읽기.
  final Map<String, Future<void>> _tripPhotoLoads = {};
  bool _tripPhotosFailed = false;

  /// 저장에 실패한 여행 write. `다시 시도`가 이 목록을 다시 흘려보낸다.
  final List<_PendingTripWrite> _failedTripWrites = [];
  final List<MusicNote> _musicNotes = [];
  final List<MusicNoteComment> _musicNoteComments = [];
  final List<ScheduleEntry> _scheduleEntries = [];
  final List<MeetingPlan> _meetingPlans = [];
  final List<SharedPlace> _sharedPlaces = [];
  final List<CuriosityCard> _curiosityCards = [];
  final List<StockStory> _stockStories = [];
  final List<StockHolding> _stockHoldings = [];
  final List<ImprovementPost> _improvementPosts = [];
  final List<MemoryCard> _memoryCards = [];
  final List<MemoryCardResponse> _memoryCardResponses = [];
  final Map<String, Future<void>> _sharedPlaceSaveChains = {};
  final Map<String, int> _sharedPlaceSaveVersions = {};
  Answer? _lastFailedAnswer;
  AnswerComment? _lastFailedAnswerComment;
  ScheduleEntry? _lastFailedScheduleEntry;
  String _lastFailedScheduleEntrySuccessFeedback = '일정을 저장했어요.';
  MeetingPlan? _lastFailedMeetingPlan;
  String _lastFailedMeetingPlanSuccessFeedback = '계획을 저장했어요.';
  SharedPlace? _lastFailedSharedPlace;
  bool _lastFailedSharedPlaceWasMeetingLinks = false;
  CuriosityCard? _lastFailedCuriosityCard;
  ImprovementPost? _lastFailedImprovementPost;
  WishItem? _lastFailedWish;
  _FailedPersistenceAction? _lastFailedWishAction;
  MusicNote? _lastFailedMusicNote;
  _FailedPersistenceAction? _lastFailedMusicNoteAction;
  MusicNoteComment? _lastFailedMusicNoteComment;
  _FailedPersistenceAction? _lastFailedMusicNoteCommentAction;
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
    _relationship = session.data.relationship;
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

  RelationshipMetadata get relationship => _relationship;

  int? get relationshipDayCount {
    final startedDate = DateTime.tryParse(_relationship.startedDateKey);
    final todayDate = DateTime.tryParse(_currentDateKey());
    if (startedDate == null || todayDate == null) {
      return null;
    }
    final normalizedStartedDate = DateTime(
      startedDate.year,
      startedDate.month,
      startedDate.day,
    );
    final normalizedTodayDate = DateTime(
      todayDate.year,
      todayDate.month,
      todayDate.day,
    );
    final days = normalizedTodayDate.difference(normalizedStartedDate).inDays;
    if (days < 0) {
      return null;
    }
    return days + 1;
  }

  String get relationshipStartedLabel {
    final startedDateKey = _relationship.startedDateKey.trim();
    if (startedDateKey.isEmpty) {
      return '우리 기록';
    }
    return '${startedDateKey.replaceAll('-', '.')}부터';
  }

  String get relationshipDayLabel {
    final dayCount = relationshipDayCount;
    if (dayCount == null) {
      return '우리 기록';
    }
    return '함께한 지 $dayCount일째';
  }

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
        title: '서로 노트에 새 답이 있어요',
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
    for (final card in _memoryCards) {
      if (!card.isShared) {
        continue;
      }
      _addUnreadActivity(
        activities,
        feature: UnreadActivityFeature.memoryCards,
        id: 'memory-card-${card.id}',
        title: '기억 카드가 업데이트됐어요',
        description: '$partnerName님이 "${card.title}"을 남겼어요.',
        updatedAt: card.updatedAt,
        actorProfileId: card.lastChangedByProfileId,
      );
    }
    for (final response in _memoryCardResponses) {
      final card = _memoryCards.cast<MemoryCard?>().firstWhere(
        (candidate) => candidate?.id == response.cardId,
        orElse: () => null,
      );
      if (card == null ||
          !card.isShared ||
          card.createdByProfileId != _state.me.id) {
        continue;
      }
      _addUnreadActivity(
        activities,
        feature: UnreadActivityFeature.memoryCards,
        id: 'memory-response-${response.id}',
        title: '기억 카드에 반응이 있어요',
        description: response.reaction == MemoryCardReaction.correction
            ? '$partnerName님이 "${card.title}"에 수정 제안을 남겼어요.'
            : '$partnerName님이 "${card.title}"에 ${response.reaction.label}를 남겼어요.',
        updatedAt: response.updatedAt,
        actorProfileId: response.responderProfileId,
      );
    }
    for (final entry in _scheduleEntries) {
      _addUnreadActivity(
        activities,
        feature: UnreadActivityFeature.meetings,
        id: 'meeting-${entry.id}',
        title: '데이트 일정이 업데이트됐어요',
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
        title: '계획이 업데이트됐어요',
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
    for (final comment in _musicNoteComments) {
      final note = _musicNotes.cast<MusicNote?>().firstWhere(
        (candidate) => candidate?.id == comment.musicNoteId,
        orElse: () => null,
      );
      _addUnreadActivity(
        activities,
        feature: UnreadActivityFeature.music,
        id: 'music-comment-${comment.id}',
        title: '음악 노트에 새 댓글이 있어요',
        description: note == null
            ? '$partnerName님이 음악 노트에 댓글을 남겼어요.'
            : '$partnerName님이 "${note.title}"에 댓글을 남겼어요.',
        updatedAt: comment.updatedAt ?? comment.createdAt,
        actorProfileId: comment.createdByProfileId,
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
    for (final trip in _trips) {
      _addUnreadActivity(
        activities,
        feature: UnreadActivityFeature.trips,
        id: 'trip-${trip.id}',
        title: '여행 계획이 업데이트됐어요',
        description: '$partnerName님이 "${trip.title}"을 정리했어요.',
        updatedAt: trip.updatedAt,
        actorProfileId: trip.updatedByProfileId ?? trip.createdByProfileId,
      );
    }
    for (final item in _tripItems) {
      final trip = tripById(item.tripId);
      if (trip == null) {
        continue;
      }
      // 체크된 항목을 '남겼어요'라고 부르면 무슨 일이 있었는지 어긋난다.
      // 지금 상태에서 읽을 수 있는 만큼만 정확히 적는다.
      final String description;
      if (item.checked && item.kind.usesCheck) {
        description =
            '$partnerName님이 "${trip.title}"에서 "${item.title}"을 챙겼다고 표시했어요.';
      } else if (item.checked && item.kind.usesDoneToggle) {
        description =
            '$partnerName님이 "${trip.title}"에서 "${item.title}"을 했다고 표시했어요.';
      } else {
        description =
            '$partnerName님이 "${trip.title}"에 ${item.kind.label} "${item.title}"을 남겼어요.';
      }
      _addUnreadActivity(
        activities,
        feature: UnreadActivityFeature.trips,
        id: 'trip-item-${item.id}',
        title: '여행 준비가 업데이트됐어요',
        description: description,
        updatedAt: item.updatedAt,
        actorProfileId: item.updatedByProfileId ?? item.createdByProfileId,
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
    _memoryCards
      ..clear()
      ..addAll(
        seedMemoryCards.map((card) {
          return card.copyWith(
            createdByProfileId: _mapSeedProfileId(card.createdByProfileId),
            subjectProfileId: _mapSeedProfileId(card.subjectProfileId),
            updatedByProfileId: card.updatedByProfileId == null
                ? null
                : _mapSeedProfileId(card.updatedByProfileId!),
          );
        }),
      );
    _sortMemoryCardsByUpdatedAt();
    _memoryCardResponses
      ..clear()
      ..addAll(
        seedMemoryCardResponses.map((response) {
          return MemoryCardResponse(
            id: response.id,
            cardId: response.cardId,
            responderProfileId: _mapSeedProfileId(response.responderProfileId),
            reaction: response.reaction,
            correctionText: response.correctionText,
            updatedAt: response.updatedAt,
          );
        }),
      );
    _sortMemoryCardResponsesByUpdatedAt();
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
    _musicNoteComments
      ..clear()
      ..addAll(
        seedMusicNoteComments.map((comment) {
          return MusicNoteComment(
            id: comment.id,
            musicNoteId: comment.musicNoteId,
            body: comment.body,
            createdByProfileId: _mapSeedProfileId(comment.createdByProfileId),
            createdLabel: comment.createdLabel,
            edited: comment.edited,
            createdAt: comment.createdAt,
            updatedAt: comment.updatedAt,
          );
        }),
      );
    _sortMusicNoteCommentsByUpdatedAt();
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
    _trips
      ..clear()
      ..addAll(data.trips);
    _sortTrips();
    _tripItems
      ..clear()
      ..addAll(data.tripItems);
    // session 로딩은 사진을 싣지 않는다. 이미 읽어둔 사진을 여기서 비우면
    // 화면에 머무는 동안 갱신이 돌 때 사진이 사라진 채로 남는다.
    if (data.tripPhotos.isNotEmpty) {
      _tripPhotos
        ..clear()
        ..addAll(data.tripPhotos);
      _loadedPhotoTripIds
        ..clear()
        ..addAll(data.tripPhotos.map((photo) => photo.tripId));
    } else if (_repository == null) {
      _tripPhotos.clear();
    }

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
    _memoryCards
      ..clear()
      ..addAll(data.memoryCards);
    _sortMemoryCardsByUpdatedAt();
    _memoryCardResponses
      ..clear()
      ..addAll(data.memoryCardResponses);
    _sortMemoryCardResponsesByUpdatedAt();
    _musicNotes
      ..clear()
      ..addAll(data.musicNotes);
    _sortMusicNotesByUpdatedAt();
    _musicNoteComments
      ..clear()
      ..addAll(data.musicNoteComments);
    _sortMusicNoteCommentsByUpdatedAt();
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

  /// space의 실제 시작일과 오늘 날짜로 활성 질문 순서를 만든다.
  static List<DailyQuestion> _sessionQuestionCatalog(
    AlagagiSession session,
    String? todayDateKey,
  ) {
    final resolvedTodayDateKey = todayDateKey ?? _todayDateKey();
    // progress 문서를 읽지 못했을 때 오늘을 시작일로 보면 v1이 1개로 잘려
    // 이미 나온 질문이 사라진다. 모를 때는 실제 첫 질문 날짜로 되돌린다.
    return buildActiveQuestionCatalog(
      startedDateKey:
          session.data.dailyProgress?.startedDateKey ?? kQuestionStartedDateKey,
      todayDateKey: resolvedTodayDateKey,
    );
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

  String _currentDateKey() => _todayDateKeyOverride ?? _todayDateKey();

  /// 화면이 D-day나 오늘 표시를 계산할 때 쓰는 오늘. test에서는 고정할 수 있다.
  String get todayDateKey => _currentDateKey();

  /// 여행에서 쓰는 오늘. 기기의 로컬 날짜를 따른다.
  ///
  /// 오늘의 질문과 만남 달력은 둘이 한국에서 맞추는 것이라 KST를 지킨다.
  /// 여행은 다르다. 파리 저녁 6시에 이미 내일이 되어 `다가오는 여행` 카드가
  /// 사라지고 `다녀온 여행으로 옮길까요`가 뜨면 안 된다.
  String get tripTodayDateKey =>
      _todayDateKeyOverride ?? _dateKey(DateTime.now());

  /// 지금 몇 시인지. 여행 안에서 쓰므로 이것도 기기 시각을 따른다.
  String _currentTimeLabel() {
    final now = DateTime.now();
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${twoDigits(now.hour)}:${twoDigits(now.minute)}';
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
        subtitle: '편한 만큼 채워두는 내 서로 노트',
        slots: _profileSlotCatalog(),
      ),
    ];
  }

  List<ProfileSlot> _profileSlotCatalog() {
    return profileSlotCatalogV3;
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
      daysTogether:
          relationshipDayCount ?? (questionCount == 0 ? 0 : questionCount),
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

  void _persistMemoryCard(MemoryCard card) {
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository == null || spaceId == null) {
      return;
    }
    unawaited(repository.saveMemoryCard(spaceId, card).catchError((_) {}));
  }

  void _persistMemoryCardResponse(MemoryCardResponse response) {
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository == null || spaceId == null) {
      return;
    }
    unawaited(
      repository.saveMemoryCardResponse(spaceId, response).catchError((_) {}),
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

  void _persistMusicNoteComment(MusicNoteComment comment) {
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository == null || spaceId == null) {
      _lastFailedMusicNoteComment = null;
      _lastFailedMusicNoteCommentAction = null;
      _state = _state.copyWith(
        musicCommentSaveStatus: SaveStatus.saved,
        musicCommentSaveFeedback: '댓글을 저장했어요.',
        musicCommentSaveTargetId: comment.id,
        clearMusicCommentError: true,
      );
      notifyListeners();
      return;
    }
    unawaited(
      repository
          .saveMusicNoteComment(spaceId, comment)
          .then<void>((_) {
            _lastFailedMusicNoteComment = null;
            _lastFailedMusicNoteCommentAction = null;
            _state = _state.copyWith(
              musicCommentSaveStatus: SaveStatus.saved,
              musicCommentSaveFeedback: '댓글을 저장했어요.',
              musicCommentSaveTargetId: comment.id,
              clearMusicCommentError: true,
            );
            notifyListeners();
          })
          .catchError((Object _) {
            _lastFailedMusicNoteComment = comment;
            _lastFailedMusicNoteCommentAction = _FailedPersistenceAction.save;
            _state = _state.copyWith(
              musicCommentError: '댓글을 저장하지 못했어요. 다시 시도해 주세요.',
              musicCommentSaveStatus: SaveStatus.failed,
              musicCommentSaveTargetId: comment.id,
              clearMusicCommentSaveFeedback: true,
            );
            notifyListeners();
          }),
    );
  }

  void _deletePersistedMusicNoteComment(
    MusicNoteComment comment,
    int previousIndex,
  ) {
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository == null || spaceId == null) {
      _lastFailedMusicNoteComment = null;
      _lastFailedMusicNoteCommentAction = null;
      _state = _state.copyWith(
        musicCommentSaveStatus: SaveStatus.saved,
        musicCommentSaveFeedback: '댓글을 삭제했어요.',
        musicCommentSaveTargetId: comment.id,
        clearMusicCommentError: true,
      );
      notifyListeners();
      return;
    }
    unawaited(
      repository
          .deleteMusicNoteComment(spaceId, comment.id)
          .then<void>((_) {
            _lastFailedMusicNoteComment = null;
            _lastFailedMusicNoteCommentAction = null;
            _state = _state.copyWith(
              musicCommentSaveStatus: SaveStatus.saved,
              musicCommentSaveFeedback: '댓글을 삭제했어요.',
              musicCommentSaveTargetId: comment.id,
              clearMusicCommentError: true,
            );
            notifyListeners();
          })
          .catchError((Object _) {
            final boundedIndex = previousIndex
                .clamp(0, _musicNoteComments.length)
                .toInt();
            if (!_musicNoteComments.any(
              (candidate) => candidate.id == comment.id,
            )) {
              _musicNoteComments.insert(boundedIndex, comment);
              _sortMusicNoteCommentsByUpdatedAt();
            }
            _lastFailedMusicNoteComment = comment;
            _lastFailedMusicNoteCommentAction = _FailedPersistenceAction.delete;
            _state = _state.copyWith(
              musicCommentError: '댓글을 삭제하지 못했어요. 다시 시도해 주세요.',
              musicCommentSaveStatus: SaveStatus.failed,
              musicCommentSaveTargetId: comment.id,
              clearMusicCommentSaveFeedback: true,
            );
            notifyListeners();
          }),
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
    String successFeedback = '계획을 저장했어요.',
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

  List<MemoryCard> get visibleMemoryCards {
    return List<MemoryCard>.unmodifiable(_visibleMemoryCards());
  }

  List<MemoryCardResponse> get memoryCardResponses {
    return List<MemoryCardResponse>.unmodifiable(_memoryCardResponses);
  }

  List<MemoryCard> memoryCardsForOwner(String ownerProfileId) {
    return List<MemoryCard>.unmodifiable(
      _visibleMemoryCards().where(
        (card) => card.createdByProfileId == ownerProfileId,
      ),
    );
  }

  int memoryCardCountForOwner(String ownerProfileId) {
    return memoryCardsForOwner(ownerProfileId).length;
  }

  MemoryCard? get latestVisibleMemoryCard {
    final cards = _visibleMemoryCards();
    if (cards.isEmpty) {
      return null;
    }
    return cards.first;
  }

  MemoryCardResponse? memoryResponseForCard(
    String cardId, {
    String? responderProfileId,
  }) {
    final profileId = responderProfileId ?? _state.me.id;
    return _memoryCardResponses.cast<MemoryCardResponse?>().firstWhere(
      (response) =>
          response?.cardId == cardId &&
          response?.responderProfileId == profileId,
      orElse: () => null,
    );
  }

  List<MemoryCard> _visibleMemoryCards() {
    return _memoryCards.where((card) {
      return card.visibility == MemoryCardVisibility.shared ||
          card.createdByProfileId == _state.me.id;
    }).toList();
  }

  List<MusicNote> get musicNotes => List<MusicNote>.unmodifiable(_musicNotes);

  List<MusicNoteComment> get musicNoteComments =>
      List<MusicNoteComment>.unmodifiable(_musicNoteComments);

  List<MusicNoteComment> musicCommentsForNote(String noteId) {
    return List<MusicNoteComment>.unmodifiable(
      _musicNoteComments.where((comment) => comment.musicNoteId == noteId),
    );
  }

  MusicNoteComment? latestMusicCommentForNote(String noteId) {
    final comments = musicCommentsForNote(noteId);
    if (comments.isEmpty) {
      return null;
    }
    return comments.first;
  }

  int musicCommentCountForNote(String noteId) => _musicNoteComments
      .where((comment) => comment.musicNoteId == noteId)
      .length;

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

  bool get canRetryMusicCommentSave => _lastFailedMusicNoteComment != null;

  bool get canRetryStockStorySave => _lastFailedStockStory != null;

  bool get canRetryStockHoldingSave => _lastFailedStockHolding != null;

  String get selectedMeetingDateKey =>
      _state.selectedMeetingDateKey ?? _currentDateKey();

  ScheduleEntry? get mySelectedScheduleEntry =>
      scheduleEntryFor(_state.me.id, selectedMeetingDateKey);

  ScheduleEntry? get partnerSelectedScheduleEntry =>
      scheduleEntryFor(_state.partner.id, selectedMeetingDateKey);

  List<String> get meetingDayDateKeys {
    final keys =
        _scheduleEntries
            .where(
              (entry) =>
                  entry.isMeetingDay && !_meetingDayCancelled(entry.dateKey),
            )
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
    final today = _currentDateKey();
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
    final today = _currentDateKey();
    return List<ScheduleEntry>.unmodifiable(
      meetingDayEntries.where((entry) => entry.dateKey.compareTo(today) >= 0),
    );
  }

  List<ScheduleEntry> get pastMeetingDayEntries {
    final today = _currentDateKey();
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
    if (_meetingDayCancelled(dateKey)) {
      return null;
    }
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
    final today = _currentDateKey();
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

  MeetingPlan? _persistedMeetingPlanFor(String dateKey) {
    return _meetingPlans.cast<MeetingPlan?>().firstWhere(
      (plan) => plan?.dateKey == dateKey,
      orElse: () => null,
    );
  }

  bool _meetingDayCancelled(String dateKey) =>
      _persistedMeetingPlanFor(dateKey)?.isCancelled == true;

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

  /// 답이 있는 질문은 활성 순서에서 빠졌더라도 기록에서 사라지면 안 된다.
  List<DailyQuestion> get answerableQuestions {
    final byId = {for (final question in questions) question.id: question};
    final answeredIds = {
      ..._myAnswersByQuestionId.keys,
      ..._partnerAnswersByQuestionId.keys,
    };
    final missing = allKnownQuestions
        .where(
          (question) =>
              answeredIds.contains(question.id) &&
              !byId.containsKey(question.id),
        )
        .toList();
    if (missing.isEmpty) {
      return questions;
    }
    return List<DailyQuestion>.unmodifiable([...questions, ...missing]);
  }

  List<ArchiveItem> get archiveItems {
    final catalog = answerableQuestions;
    final visibleQuestions = _usesDemoData
        ? catalog
        : catalog.where((question) {
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

  void completeRenewalWelcome() {
    _markRenewalWelcomeSeen();
    if (!_state.renewalWelcomeVisible) {
      return;
    }
    _state = _state.copyWith(renewalWelcomeVisible: false);
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

  void _initializeRenewalWelcome() {
    final store = _renewalWelcomeStore;
    final spaceId = _spaceId;
    if (store == null || spaceId == null || !_isMinyoungProfile(_state.me)) {
      return;
    }
    if (store.hasSeenRenewalWelcome(
      spaceId,
      _state.me.id,
      renewalWelcomeVersion,
    )) {
      return;
    }
    _state = _state.copyWith(renewalWelcomeVisible: true);
  }

  void _markFirstVisitGuideSeen() {
    final store = _firstVisitGuideStore;
    final spaceId = _spaceId;
    if (store == null || spaceId == null) {
      return;
    }
    store.markFirstVisitGuideSeen(spaceId, _state.me.id);
  }

  void _markRenewalWelcomeSeen() {
    final store = _renewalWelcomeStore;
    final spaceId = _spaceId;
    if (store == null || spaceId == null) {
      return;
    }
    store.markRenewalWelcomeSeen(spaceId, _state.me.id, renewalWelcomeVersion);
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
      UnreadActivityFeature.memoryCards => _latestTimestamp([
        ..._memoryCards.map((card) => card.updatedAt),
        ..._memoryCardResponses.map((response) => response.updatedAt),
      ]),
      UnreadActivityFeature.trips => _latestTimestamp([
        ..._trips.map((trip) => trip.updatedAt),
        ..._tripItems.map((item) => item.updatedAt),
      ]),
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
    return _latestTimestamp([
      ..._musicNotes.map((note) => note.updatedAt),
      ..._musicNoteComments.map(
        (comment) => comment.updatedAt ?? comment.createdAt,
      ),
    ]);
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
      AlagagiRoute.memoryCards => UnreadActivityFeature.memoryCards,
      AlagagiRoute.trips => UnreadActivityFeature.trips,
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

  void _sortMemoryCardsByUpdatedAt() {
    _memoryCards.sort((a, b) {
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

  void _sortMemoryCardResponsesByUpdatedAt() {
    _memoryCardResponses.sort((a, b) {
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

  void _sortMusicNoteCommentsByUpdatedAt() {
    _musicNoteComments.sort((a, b) {
      final aUpdatedAt = a.updatedAt ?? a.createdAt;
      final bUpdatedAt = b.updatedAt ?? b.createdAt;
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
    final comment =
        existing?.copyWith(
          body: body,
          createdLabel: existing.createdLabel,
          edited: true,
        ) ??
        AnswerComment(
          questionId: questionId,
          answerOwnerProfileId: answerOwnerProfileId,
          commenterProfileId: _state.me.id,
          body: body,
          createdLabel: '오늘',
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

  String commentReplyDraftForComment(AnswerComment comment) {
    return _state.commentReplyDraftsByCommentKey[_answerCommentKey(
          comment.questionId,
          comment.answerOwnerProfileId,
          comment.commenterProfileId,
        )] ??
        comment.replyBody;
  }

  String commentReplyInputValueForComment(AnswerComment comment) {
    return _state.commentReplyDraftsByCommentKey[_answerCommentKey(
          comment.questionId,
          comment.answerOwnerProfileId,
          comment.commenterProfileId,
        )] ??
        '';
  }

  bool hasCommentReplyDraftForComment(AnswerComment comment) {
    return _state.commentReplyDraftsByCommentKey.containsKey(
      _answerCommentKey(
        comment.questionId,
        comment.answerOwnerProfileId,
        comment.commenterProfileId,
      ),
    );
  }

  void updateAnswerCommentReplyDraft({
    required String questionId,
    required String answerOwnerProfileId,
    required String commenterProfileId,
    required String value,
  }) {
    final commentKey = _answerCommentKey(
      questionId,
      answerOwnerProfileId,
      commenterProfileId,
    );
    final drafts = Map<String, String>.of(_state.commentReplyDraftsByCommentKey)
      ..[commentKey] = value;
    _state = _state.copyWith(
      commentReplyDraftsByCommentKey: Map<String, String>.unmodifiable(drafts),
      commentSaveStatus: SaveStatus.idle,
      clearCommentError: true,
      clearCommentSaveFeedback: true,
      clearCommentSaveTargetKey: true,
    );
    notifyListeners();
  }

  void cancelAnswerCommentReplyDraft({
    required String questionId,
    required String answerOwnerProfileId,
    required String commenterProfileId,
  }) {
    final drafts = Map<String, String>.of(_state.commentReplyDraftsByCommentKey)
      ..remove(
        _answerCommentKey(questionId, answerOwnerProfileId, commenterProfileId),
      );
    _state = _state.copyWith(
      commentReplyDraftsByCommentKey: Map<String, String>.unmodifiable(drafts),
      commentSaveStatus: SaveStatus.idle,
      clearCommentError: true,
      clearCommentSaveFeedback: true,
      clearCommentSaveTargetKey: true,
    );
    notifyListeners();
  }

  void submitAnswerCommentReply({
    required String questionId,
    required String answerOwnerProfileId,
    required String commenterProfileId,
  }) {
    if (_state.commentSaveStatus == SaveStatus.saving) {
      return;
    }
    final existing = commentForAnswer(
      questionId,
      answerOwnerProfileId,
      commenterProfileId,
    );
    if (existing == null) {
      _state = _state.copyWith(
        commentError: '답장할 댓글을 찾지 못했어요.',
        commentSaveStatus: SaveStatus.idle,
        clearCommentSaveFeedback: true,
      );
      notifyListeners();
      return;
    }
    if (answerOwnerProfileId != _state.me.id ||
        commenterProfileId == _state.me.id) {
      _state = _state.copyWith(
        commentError: '내 답에 받은 댓글에만 답장할 수 있어요.',
        commentSaveStatus: SaveStatus.idle,
        clearCommentSaveFeedback: true,
      );
      notifyListeners();
      return;
    }
    final body = commentReplyDraftForComment(existing).trim();
    if (body.isEmpty) {
      _state = _state.copyWith(
        commentError: '답장도 한 줄만 남겨도 괜찮아요.',
        commentSaveStatus: SaveStatus.idle,
        clearCommentSaveFeedback: true,
      );
      notifyListeners();
      return;
    }
    if (body.length > 120) {
      _state = _state.copyWith(
        commentError: '답장은 120자 안으로 남겨주세요.',
        commentSaveStatus: SaveStatus.idle,
        clearCommentSaveFeedback: true,
      );
      notifyListeners();
      return;
    }

    final updated = existing.copyWith(
      replyBody: body,
      repliedByProfileId: _state.me.id,
      replyCreatedLabel: existing.hasReply ? existing.replyCreatedLabel : '오늘',
      replyEdited: existing.hasReply,
    );
    final commentKey = _answerCommentKey(
      questionId,
      answerOwnerProfileId,
      commenterProfileId,
    );
    _answerCommentsByKey[commentKey] = updated;
    _lastFailedAnswerComment = null;
    final drafts = Map<String, String>.of(_state.commentReplyDraftsByCommentKey)
      ..remove(commentKey);
    _state = _state.copyWith(
      commentReplyDraftsByCommentKey: Map<String, String>.unmodifiable(drafts),
      commentSaveStatus: SaveStatus.saving,
      commentSaveTargetKey: _answerCommentDraftKey(
        questionId,
        answerOwnerProfileId,
      ),
      clearCommentError: true,
      clearCommentSaveFeedback: true,
    );
    notifyListeners();
    _persistAnswerComment(updated);
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

  // --- Trips ---

  List<Trip> get trips => List<Trip>.unmodifiable(_trips);

  /// 홈 카드처럼 화면 밖에서 여행 하나를 지목해 열 때 쓴다.
  String? _pendingTripId;

  /// 마지막으로 저장한 여행의 id. 새로 만든 뒤 그 여행으로 바로 들어가려고 둔다.
  String? _lastSavedTripId;

  String? get lastSavedTripId => _lastSavedTripId;

  /// 여행 화면으로 가면서 이 여행을 펼쳐 달라고 표시한다.
  void openTrip(String tripId) {
    _pendingTripId = tripId;
    goTo(AlagagiRoute.trips);
  }

  /// 화면이 한 번 읽고 나면 지운다. 목록으로 나갔다가 돌아올 때
  /// 같은 여행이 다시 열리면 뒤로 가기가 먹지 않는 것처럼 보인다.
  String? consumePendingTripId() {
    final tripId = _pendingTripId;
    _pendingTripId = null;
    return tripId;
  }

  List<Trip> tripsWithStatus(TripStatus status) =>
      List<Trip>.unmodifiable(_trips.where((trip) => trip.status == status));

  Trip? tripById(String tripId) {
    for (final trip in _trips) {
      if (trip.id == tripId) {
        return trip;
      }
    }
    return null;
  }

  List<TripItem> tripItemsFor(String tripId, {TripItemKind? kind}) {
    final items = _tripItems
        .where((item) => item.tripId == tripId)
        .where((item) => kind == null || item.kind == kind)
        .toList();
    items.sort(_compareTripItems);
    return List<TripItem>.unmodifiable(items);
  }

  /// 날짜 -> 시각 -> 제목 순. 날짜와 시각이 없는 항목은 각각 뒤로 밀린다.
  static int _compareTripItems(TripItem first, TripItem second) {
    final firstDate = first.dateKey;
    final secondDate = second.dateKey;
    if (firstDate != secondDate) {
      if (firstDate == null) {
        return 1;
      }
      if (secondDate == null) {
        return -1;
      }
      return firstDate.compareTo(secondDate);
    }
    final firstTime = first.timeLabel;
    final secondTime = second.timeLabel;
    if (firstTime != secondTime) {
      if (firstTime == null) {
        return 1;
      }
      if (secondTime == null) {
        return -1;
      }
      return firstTime.compareTo(secondTime);
    }
    // 시각까지 같으면 사용자가 정한 순서를 따른다.
    if (first.sortOrder != second.sortOrder) {
      return first.sortOrder.compareTo(second.sortOrder);
    }
    return first.title.compareTo(second.title);
  }

  /// 지도 검색 없이 장소를 직접 담는다.
  ///
  /// 카카오 검색은 국내만 다뤄 해외 여행에서는 결과가 나오지 않는다. 이름과
  /// 메모만으로도 담고, 지도 링크를 붙여두면 나중에 지도 앱으로 바로 연다.
  /// 실패 이유가 있으면 문자열로 돌려주고 아무것도 쓰지 않는다.
  String? saveManualPlace({
    String? placeId,
    required String name,
    required PlaceCategory category,
    String address = '',
    String note = '',
    String mapLink = '',
  }) {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      return '장소 이름을 적어주세요.';
    }
    if (trimmedName.length > 40) {
      return '장소 이름은 40자 안으로 적어주세요.';
    }
    final trimmedAddress = address.trim();
    if (trimmedAddress.length > 120) {
      return '주소는 120자 안으로 적어주세요.';
    }
    final trimmedNote = note.trim();
    if (trimmedNote.length > 120) {
      return '메모는 120자 안으로 남겨주세요.';
    }
    final trimmedLink = mapLink.trim();
    if (trimmedLink.isNotEmpty && !_isSupportedPlaceLink(trimmedLink)) {
      return '지도 링크는 http로 시작하는 주소여야 해요.';
    }
    if (trimmedLink.length > 500) {
      return '지도 링크가 너무 길어요.';
    }

    final editingIndex = placeId == null
        ? -1
        : _sharedPlaces.indexWhere((place) => place.id == placeId);
    if (placeId != null && editingIndex == -1) {
      return '수정할 장소를 찾지 못했어요.';
    }
    if (editingIndex != -1 &&
        _sharedPlaces[editingIndex].createdByProfileId != _state.me.id) {
      return '내가 담은 장소만 수정할 수 있어요.';
    }

    // 직접 입력에는 provider place id가 없다. 같은 곳을 각자 담아 카드가
    // 둘로 갈라지지 않도록 이름과 주소로 같은 곳인지 본다.
    final duplicateIndex = _sharedPlaces.indexWhere(
      (place) =>
          place.provider == MapApiProvider.manual &&
          place.id != placeId &&
          _normalizedPlaceKey(place.name) == _normalizedPlaceKey(trimmedName) &&
          _normalizedPlaceKey(place.address) ==
              _normalizedPlaceKey(trimmedAddress),
    );
    final targetIndex = editingIndex != -1 ? editingIndex : duplicateIndex;

    final now = DateTime.now();
    final SharedPlace place;
    if (targetIndex != -1) {
      final existing = _sharedPlaces[targetIndex];
      place = existing.copyWith(
        name: trimmedName,
        address: trimmedAddress,
        category: category,
        note: trimmedNote.isEmpty ? existing.note : trimmedNote,
        mapLink: trimmedLink.isEmpty ? existing.mapLink : trimmedLink,
        interestedByProfileIds: {
          ...existing.interestedByProfileIds,
          _state.me.id,
        },
        updatedAt: now,
        updatedByProfileId: _state.me.id,
      );
      _sharedPlaces[targetIndex] = place;
    } else {
      place = SharedPlace(
        id: 'place_${_state.me.id}_${now.microsecondsSinceEpoch}',
        name: trimmedName,
        address: trimmedAddress,
        category: category,
        provider: MapApiProvider.manual,
        createdByProfileId: _state.me.id,
        interestedByProfileIds: {_state.me.id},
        note: trimmedNote,
        mapLink: trimmedLink,
        updatedAt: now,
        updatedByProfileId: _state.me.id,
      );
      _sharedPlaces.insert(0, place);
    }
    // 방금 담은 곳을 부른 쪽이 바로 고를 수 있게 남긴다. 이름·주소가 겹쳐
    // 기존 항목에 합쳐진 경우에도 그 id여야 한다.
    _lastSavedPlaceId = place.id;
    _persistSharedPlace(place);
    notifyListeners();
    return null;
  }

  /// 마지막으로 담은 장소의 id.
  String? _lastSavedPlaceId;

  String? get lastSavedPlaceId => _lastSavedPlaceId;

  void clearLastSavedPlaceId() {
    _lastSavedPlaceId = null;
  }

  static bool _isSupportedPlaceLink(String value) {
    final uri = Uri.tryParse(value);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  /// 띄어쓰기와 대소문자 차이는 같은 곳으로 본다.
  static String _normalizedPlaceKey(String value) {
    return value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// 여행 항목에 붙은 장소. 장소가 지워졌으면 null이다.
  SharedPlace? placeForTripItem(TripItem item) {
    final placeId = item.placeId;
    if (placeId == null) {
      return null;
    }
    for (final place in _sharedPlaces) {
      if (place.id == placeId) {
        return place;
      }
    }
    return null;
  }

  /// 그날 밤 머무는 숙소. 체크아웃 당일 밤은 포함하지 않는다.
  List<TripItem> tripStaysForNight(String tripId, String dateKey) {
    final stays = _tripItems
        .where(
          (item) =>
              item.tripId == tripId &&
              item.kind == TripItemKind.stay &&
              item.coversNight(dateKey),
        )
        .toList();
    stays.sort(_compareTripItems);
    return List<TripItem>.unmodifiable(stays);
  }

  /// 그날 체크아웃하는 숙소. 아침에 나가는 일정이라 하루 머리에 보여준다.
  List<TripItem> tripStaysCheckingOut(String tripId, String dateKey) {
    final stays = _tripItems
        .where(
          (item) =>
              item.tripId == tripId &&
              item.kind == TripItemKind.stay &&
              item.endDateKey == dateKey,
        )
        .toList();
    stays.sort(_compareTripItems);
    return List<TripItem>.unmodifiable(stays);
  }

  /// 여행 일정 타임라인. 날짜별로 묶고 날짜 미정 묶음을 마지막에 둔다.
  ///
  /// 준비물은 챙길 목록이라, 숙소는 하룻밤을 통째로 차지해 시각 흐름에
  /// 끼우면 어색하므로 둘 다 타임라인 항목에서 제외한다. 숙소는
  /// [tripStaysForNight]로 하루 머리에 따로 보여준다.
  List<TripDay> tripTimelineDays(String tripId) {
    final trip = tripById(tripId);
    if (trip == null) {
      return const [];
    }
    final scheduled = _tripItems
        .where((item) => item.tripId == tripId && item.kind.appearsOnTimeline)
        .toList();
    scheduled.sort(_compareTripItems);

    final days = <TripDay>[];
    final dateKeys = trip.dateKeys;
    for (var index = 0; index < dateKeys.length; index += 1) {
      final dateKey = dateKeys[index];
      days.add(
        TripDay(
          dateKey: dateKey,
          dayNumber: index + 1,
          items: List<TripItem>.unmodifiable(
            scheduled.where((item) => item.dateKey == dateKey),
          ),
        ),
      );
    }

    final undated = scheduled.where((item) => item.dateKey == null).toList();
    if (undated.isNotEmpty) {
      days.add(
        TripDay(
          dateKey: '',
          dayNumber: 0,
          items: List<TripItem>.unmodifiable(undated),
        ),
      );
    }
    return List<TripDay>.unmodifiable(days);
  }

  /// 이 날 잡혀 있는 여행. 만남 달력이 여행 기간과 겹치는 날을 알아야
  /// 같은 날에 두 가지를 잡아두지 않는다.
  Trip? tripCoveringDate(String dateKey) {
    for (final trip in _trips) {
      if (trip.status != TripStatus.planning) {
        continue;
      }
      if (dateKey.compareTo(trip.startDateKey) >= 0 &&
          dateKey.compareTo(trip.endDateKey) <= 0) {
        return trip;
      }
    }
    return null;
  }

  /// 닫힌 항목 폼의 draft. `tripId:kind` 하나씩만 들고 있고, 저장하면 지운다.
  /// 화면을 다시 그릴 이유가 없으므로 state에 넣지 않는다.
  final Map<String, TripItemDraft> _tripItemDrafts = {};

  String _tripItemDraftKey(String tripId, TripItemKind kind) =>
      '$tripId:${kind.storageKey}';

  void rememberTripItemDraft(String tripId, TripItemDraft draft) {
    if (!draft.hasContent) {
      _tripItemDrafts.remove(_tripItemDraftKey(tripId, draft.kind));
      return;
    }
    _tripItemDrafts[_tripItemDraftKey(tripId, draft.kind)] = draft;
  }

  TripItemDraft? tripItemDraftFor(String tripId, TripItemKind kind) =>
      _tripItemDrafts[_tripItemDraftKey(tripId, kind)];

  void clearTripItemDraft(String tripId, TripItemKind kind) {
    _tripItemDrafts.remove(_tripItemDraftKey(tripId, kind));
  }

  /// 준비물을 담아둔 다른 여행들. 가까운 여행부터 보여준다.
  List<Trip> tripsWithPackingExcept(String tripId) {
    final withPacking = _trips.where((trip) {
      if (trip.id == tripId) {
        return false;
      }
      return _tripItems.any(
        (item) => item.tripId == trip.id && item.kind == TripItemKind.packing,
      );
    }).toList();
    withPacking.sort(
      (first, second) => second.startDateKey.compareTo(first.startDateKey),
    );
    return List<Trip>.unmodifiable(withPacking);
  }

  /// 지난 여행의 준비물을 그대로 가져온다. 챙긴 표시는 옮기지 않고,
  /// 이미 같은 이름이 있으면 건너뛴다. 담은 개수를 돌려준다.
  int copyTripPacking({required String fromTripId, required String toTripId}) {
    final target = tripById(toTripId);
    if (target == null || fromTripId == toTripId) {
      return 0;
    }
    final existing = _tripItems
        .where(
          (item) =>
              item.tripId == toTripId && item.kind == TripItemKind.packing,
        )
        .map((item) => item.title.trim())
        .toSet();
    final source = _tripItems
        .where(
          (item) =>
              item.tripId == fromTripId && item.kind == TripItemKind.packing,
        )
        .toList();
    source.sort((first, second) => first.sortOrder.compareTo(second.sortOrder));

    var copied = 0;
    for (final item in source) {
      if (existing.contains(item.title.trim())) {
        continue;
      }
      final error = saveTripItem(
        tripId: toTripId,
        kind: TripItemKind.packing,
        title: item.title,
        note: item.note,
        assigneeProfileId: item.assigneeProfileId,
      );
      if (error == null) {
        existing.add(item.title.trim());
        copied += 1;
      }
    }
    return copied;
  }

  /// 여행 중일 때 오늘 잡혀 있는 일정. 홈에서 오늘 무엇이 있는지 바로 본다.
  List<TripItem> tripItemsForToday(String tripId) {
    final today = tripTodayDateKey;
    final scheduled = _tripItems
        .where(
          (item) =>
              item.tripId == tripId &&
              item.kind.appearsOnTimeline &&
              item.dateKey == today,
        )
        .toList();
    scheduled.sort(_compareTripItems);
    return List<TripItem>.unmodifiable(scheduled);
  }

  /// 여행에 적어둔 메모. 담은 순서대로 읽는다.
  List<TripItem> tripMemosFor(String tripId) {
    final memos = _tripItems
        .where((item) => item.tripId == tripId && item.kind == TripItemKind.memo)
        .toList();
    memos.sort((first, second) {
      if (first.sortOrder != second.sortOrder) {
        return first.sortOrder.compareTo(second.sortOrder);
      }
      return first.id.compareTo(second.id);
    });
    return List<TripItem>.unmodifiable(memos);
  }

  /// 메모를 담거나 고친다. 내용만 있으면 되고 링크는 선택이다.
  ///
  /// 링크를 따로 받는 이유는 앱이 글에서 주소를 짐작하지 않기 위해서다.
  /// 짐작이 틀리면 사용자는 왜 안 열리는지 알 길이 없다.
  String? saveTripMemo({
    required String tripId,
    String? itemId,
    required String text,
    String link = '',
  }) {
    return saveTripItem(
      tripId: tripId,
      itemId: itemId,
      kind: TripItemKind.memo,
      title: text,
      link: link,
    );
  }

  /// 여행 중 지금 시각 다음에 오는 항목. 화면을 그릴 때만 계산한다.
  ///
  /// 시각을 안 적은 항목은 `지금`과 견줄 수 없어 후보에서 뺀다.
  /// 오늘 시각이 전부 지났으면 마지막 항목을 돌려준다.
  TripItem? nextTripItemToday(String tripId, {String? nowTimeLabel}) {
    final timed = tripItemsForToday(
      tripId,
    ).where((item) => item.timeLabel != null).toList();
    if (timed.isEmpty) {
      return null;
    }
    final now = nowTimeLabel ?? _currentTimeLabel();
    for (final item in timed) {
      if (item.timeLabel!.compareTo(now) >= 0) {
        return item;
      }
    }
    return timed.last;
  }

  /// 한 종류 안에서도 날짜별로 묶어 보여준다.
  List<TripDay> tripDaysForKind(String tripId, TripItemKind kind) {
    final trip = tripById(tripId);
    if (trip == null) {
      return const [];
    }
    final items = tripItemsFor(tripId, kind: kind);
    final days = <TripDay>[];
    final dateKeys = trip.dateKeys;
    for (var index = 0; index < dateKeys.length; index += 1) {
      final dateKey = dateKeys[index];
      final dayItems = items.where((item) => item.dateKey == dateKey).toList();
      if (dayItems.isEmpty) {
        continue;
      }
      days.add(
        TripDay(
          dateKey: dateKey,
          dayNumber: index + 1,
          items: List<TripItem>.unmodifiable(dayItems),
        ),
      );
    }
    final undated = items.where((item) => item.dateKey == null).toList();
    if (undated.isNotEmpty) {
      days.add(
        TripDay(
          dateKey: '',
          dayNumber: 0,
          items: List<TripItem>.unmodifiable(undated),
        ),
      );
    }
    return List<TripDay>.unmodifiable(days);
  }

  int tripPackingCheckedCount(String tripId) => tripItemsFor(
    tripId,
    kind: TripItemKind.packing,
  ).where((item) => item.checked).length;

  /// 여행을 만들거나 수정한다. 실패 이유가 있으면 문자열로 돌려주고 아무것도 쓰지 않는다.
  String? saveTrip({
    String? tripId,
    required String title,
    required String destination,
    required String startDateKey,
    required String endDateKey,
    String note = '',
    TripStatus? status,
  }) {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
      return '여행 이름을 적어주세요.';
    }
    final start = DateTime.tryParse(startDateKey);
    final end = DateTime.tryParse(endDateKey);
    if (start == null || end == null) {
      return '날짜를 다시 확인해 주세요.';
    }
    if (end.isBefore(start)) {
      return '돌아오는 날은 떠나는 날보다 앞설 수 없어요.';
    }
    if (note.trim().length > 500) {
      return '메모는 500자 안으로 남겨주세요.';
    }
    final now = DateTime.now();
    final existingIndex = tripId == null
        ? -1
        : _trips.indexWhere((trip) => trip.id == tripId);
    final Trip trip;
    if (existingIndex >= 0) {
      trip = _trips[existingIndex].copyWith(
        title: trimmedTitle,
        destination: destination.trim(),
        startDateKey: startDateKey,
        endDateKey: endDateKey,
        note: note.trim(),
        status: status,
        updatedAt: now,
        updatedByProfileId: _state.me.id,
      );
      _trips[existingIndex] = trip;
    } else {
      trip = Trip(
        id: 'trip_${_state.me.id}_${now.microsecondsSinceEpoch}',
        title: trimmedTitle,
        destination: destination.trim(),
        startDateKey: startDateKey,
        endDateKey: endDateKey,
        createdByProfileId: _state.me.id,
        status: status ?? TripStatus.planning,
        note: note.trim(),
        updatedAt: now,
        updatedByProfileId: _state.me.id,
      );
      _trips.add(trip);
    }
    _sortTrips();
    _dropTripItemDatesOutsideTrip(trip);
    _persistTrip(trip);
    _lastSavedTripId = trip.id;
    notifyListeners();
    return null;
  }

  void setTripStatus(String tripId, TripStatus status) {
    final index = _trips.indexWhere((trip) => trip.id == tripId);
    if (index < 0 || _trips[index].status == status) {
      return;
    }
    final trip = _trips[index].copyWith(
      status: status,
      updatedAt: DateTime.now(),
      updatedByProfileId: _state.me.id,
    );
    _trips[index] = trip;
    _sortTrips();
    _persistTrip(trip);
    notifyListeners();
  }

  /// 여행은 둘 중 누구든 지울 수 있다. 둘이 같이 채우는 공간이라 누가
  /// 먼저 만들었는지로 지울 수 있는 사람을 가르면, 상대가 담아둔 것을
  /// 정리할 길이 사라진다. 대신 확인 sheet를 반드시 거친다.
  Future<bool> deleteTrip(String tripId) async {
    final index = _trips.indexWhere((trip) => trip.id == tripId);
    if (index < 0) {
      return false;
    }
    // 목록에서 빼는 일이 먼저다. 사진을 읽고 나서 지우면 그동안 지운
    // 여행이 목록에 그대로 남아 눌리지 않는 것처럼 보인다.
    _trips.removeAt(index);
    if (_pendingTripId == tripId) {
      _pendingTripId = null;
    }
    if (_lastSavedTripId == tripId) {
      _lastSavedTripId = null;
    }
    notifyListeners();

    // 진행 중인 읽기가 있으면 끝날 때까지 기다린다. 그래야 지울 목록이
    // 완전해지고, 읽기가 나중에 끝나 지운 사진이 되살아나지 않는다.
    final inFlight = _tripPhotoLoads[tripId];
    if (inFlight != null) {
      await inFlight;
    }

    // 지울 사진 목록을 확보한다. 읽지 않은 채 지우면 문서가 남는다.
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository != null &&
        spaceId != null &&
        !_loadedPhotoTripIds.contains(tripId)) {
      try {
        final photos = await repository.loadTripPhotos(spaceId, tripId);
        final known = _tripPhotos.map((photo) => photo.id).toSet();
        _tripPhotos.addAll(photos.where((photo) => !known.contains(photo.id)));
      } catch (_) {
        // 못 읽었으면 아는 것만 지운다. 실패는 재시도 큐에 남는다.
      }
    }

    final removedItems = _tripItems
        .where((item) => item.tripId == tripId)
        .toList();
    final removedPhotos = _tripPhotos
        .where((photo) => photo.tripId == tripId)
        .toList();

    _tripItems.removeWhere((item) => item.tripId == tripId);
    _tripPhotos.removeWhere((photo) => photo.tripId == tripId);
    _loadedPhotoTripIds.remove(tripId);

    // 항목과 사진을 남겨두면 화면에서만 사라지고 문서는 영원히 남는다.
    // 사진은 문서 하나가 수백 KB라 지운 여행의 짐이 계속 쌓인다.
    // 자식 하나가 실패했다고 여행을 되살리지는 않는다. 사라진 여행에
    // 상대 항목만 붙어 되돌아오는 쪽이 더 나쁘다. 실패는 재시도 큐에 남는다.
    for (final item in removedItems) {
      _runTripWrite(_PendingTripWrite.deleteItem(item));
    }
    for (final photo in removedPhotos) {
      _runTripWrite(_PendingTripWrite.deletePhoto(photo));
    }
    _runTripWrite(_PendingTripWrite.deleteTrip(tripId));
    notifyListeners();
    return true;
  }

  /// 여행 항목을 만들거나 수정한다. 실패 이유가 있으면 문자열로 돌려준다.
  String? saveTripItem({
    required String tripId,
    String? itemId,
    required TripItemKind kind,
    required String title,
    String note = '',
    String? dateKey,
    String? timeLabel,
    String? endDateKey,
    String? endTimeLabel,
    TripTransportMode? transportMode,
    String? fromLabel,
    String? toLabel,
    String? placeId,
    String? link,
    String? assigneeProfileId,
  }) {
    final trip = tripById(tripId);
    if (trip == null) {
      return '여행을 찾을 수 없어요.';
    }
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
      return '내용을 적어주세요.';
    }
    final resolvedDateKey = dateKey != null && trip.containsDateKey(dateKey)
        ? dateKey
        : null;
    if (dateKey != null && resolvedDateKey == null) {
      return '여행 기간 안의 날짜만 고를 수 있어요.';
    }
    final trimmedTime = timeLabel?.trim() ?? '';
    if (trimmedTime.isNotEmpty && !isValidTripTimeLabel(trimmedTime)) {
      return '시간은 09:30처럼 적어주세요.';
    }
    // 날짜를 정하지 않았으면 시각만 남겨둘 이유가 없다.
    final resolvedTimeLabel = resolvedDateKey == null || trimmedTime.isEmpty
        ? null
        : trimmedTime;

    final trimmedEndTime = endTimeLabel?.trim() ?? '';
    if (trimmedEndTime.isNotEmpty && !isValidTripTimeLabel(trimmedEndTime)) {
      return '시간은 09:30처럼 적어주세요.';
    }

    // 숙소는 체크인~체크아웃 범위를 갖는다.
    String? resolvedEndDateKey;
    if (kind.usesDateRange && endDateKey != null) {
      if (!trip.containsDateKey(endDateKey)) {
        return '여행 기간 안의 날짜만 고를 수 있어요.';
      }
      if (resolvedDateKey == null) {
        return '체크인 날짜를 먼저 골라주세요.';
      }
      final checkIn = DateTime.parse(resolvedDateKey);
      final checkOut = DateTime.parse(endDateKey);
      if (!checkOut.isAfter(checkIn)) {
        return '체크아웃은 체크인 다음 날부터 고를 수 있어요.';
      }
      resolvedEndDateKey = endDateKey;
    }

    final resolvedEndTimeLabel = trimmedEndTime.isEmpty ? null : trimmedEndTime;
    if (kind.usesRoute &&
        resolvedTimeLabel == null &&
        resolvedEndTimeLabel != null) {
      return '출발 시각을 먼저 적어주세요.';
    }
    final resolvedMode = kind.usesRoute
        ? (transportMode ?? TripTransportMode.flight)
        : null;
    String? trimmedOrNull(String? value) {
      final trimmed = value?.trim() ?? '';
      return trimmed.isEmpty ? null : trimmed;
    }

    final resolvedFrom = kind.usesRoute ? trimmedOrNull(fromLabel) : null;
    final resolvedTo = kind.usesRoute ? trimmedOrNull(toLabel) : null;

    // 장소는 저장해둔 장소 보드의 것만 붙인다.
    final trimmedPlaceId = trimmedOrNull(placeId);
    final resolvedPlaceId =
        trimmedPlaceId != null &&
            _sharedPlaces.any((place) => place.id == trimmedPlaceId)
        ? trimmedPlaceId
        : null;
    if (trimmedPlaceId != null && resolvedPlaceId == null) {
      return '장소를 찾을 수 없어요.';
    }
    final resolvedLink = trimmedOrNull(link);

    // 담당은 준비물에만 두고, 우리 둘 중 한 명이어야 한다.
    final trimmedAssignee = kind.usesCheck
        ? trimmedOrNull(assigneeProfileId)
        : null;
    if (trimmedAssignee != null && !_isValidTripAssignee(trimmedAssignee)) {
      return '담당은 둘 중 한 사람이거나 함께여야 해요.';
    }

    final now = DateTime.now();
    final existingIndex = itemId == null
        ? -1
        : _tripItems.indexWhere((item) => item.id == itemId);
    final TripItem item;
    if (existingIndex >= 0) {
      item = _tripItems[existingIndex].copyWith(
        kind: kind,
        title: trimmedTitle,
        note: note.trim(),
        dateKey: resolvedDateKey,
        clearDateKey: resolvedDateKey == null,
        timeLabel: resolvedTimeLabel,
        clearTimeLabel: resolvedTimeLabel == null,
        endDateKey: resolvedEndDateKey,
        clearEndDateKey: resolvedEndDateKey == null,
        endTimeLabel: resolvedEndTimeLabel,
        clearEndTimeLabel: resolvedEndTimeLabel == null,
        transportMode: resolvedMode,
        clearTransportMode: resolvedMode == null,
        fromLabel: resolvedFrom,
        clearFromLabel: resolvedFrom == null,
        toLabel: resolvedTo,
        clearToLabel: resolvedTo == null,
        placeId: resolvedPlaceId,
        clearPlaceId: resolvedPlaceId == null,
        link: resolvedLink,
        clearLink: resolvedLink == null,
        assigneeProfileId: trimmedAssignee,
        clearAssignee: trimmedAssignee == null,
        checked: (kind.usesCheck || kind.usesDoneToggle) ? null : false,
        updatedAt: now,
        updatedByProfileId: _state.me.id,
      );
      _tripItems[existingIndex] = item;
    } else {
      item = TripItem(
        id: 'trip_item_${_state.me.id}_${now.microsecondsSinceEpoch}',
        tripId: tripId,
        kind: kind,
        title: trimmedTitle,
        createdByProfileId: _state.me.id,
        note: note.trim(),
        dateKey: resolvedDateKey,
        timeLabel: resolvedTimeLabel,
        endDateKey: resolvedEndDateKey,
        endTimeLabel: resolvedEndTimeLabel,
        transportMode: resolvedMode,
        fromLabel: resolvedFrom,
        toLabel: resolvedTo,
        placeId: resolvedPlaceId,
        link: resolvedLink,
        assigneeProfileId: trimmedAssignee,
        sortOrder: _nextTripItemOrder(tripId, resolvedDateKey),
        updatedAt: now,
        updatedByProfileId: _state.me.id,
      );
      _tripItems.add(item);
    }
    _persistTripItem(item);
    notifyListeners();
    return null;
  }

  /// 체크는 준비물 항목에만 있다.
  void toggleTripItemCheck(String itemId) {
    final index = _tripItems.indexWhere((item) => item.id == itemId);
    if (index < 0) {
      return;
    }
    final kind = _tripItems[index].kind;
    if (!kind.usesCheck && !kind.usesDoneToggle) {
      return;
    }
    final item = _tripItems[index].copyWith(
      checked: !_tripItems[index].checked,
      updatedAt: DateTime.now(),
      updatedByProfileId: _state.me.id,
    );
    _tripItems[index] = item;
    _persistTripItem(item);
    notifyListeners();
  }

  /// 항목은 만든 사람만 지울 수 있다.
  bool deleteTripItem(String itemId) {
    final index = _tripItems.indexWhere((item) => item.id == itemId);
    if (index < 0) {
      return false;
    }
    final removed = _tripItems.removeAt(index);
    _runTripWrite(
      _PendingTripWrite.deleteItem(
        removed,
        // 여러 번 불려도 안전해야 한다. 재시도가 또 실패할 수 있다.
        restore: () {
          if (_tripItems.any((candidate) => candidate.id == removed.id)) {
            return;
          }
          _tripItems.insert(index.clamp(0, _tripItems.length), removed);
          notifyListeners();
        },
      ),
    );
    notifyListeners();
    return true;
  }

  // --- Trip photos ---

  bool get tripPhotosLoading => _tripPhotoLoads.isNotEmpty;

  /// 사진을 읽지 못했는지. 빈 여행과 실패를 같은 화면으로 보여주면 안 된다.
  bool get tripPhotosFailed => _tripPhotosFailed;

  bool tripPhotosLoadedFor(String tripId) =>
      _repository == null || _loadedPhotoTripIds.contains(tripId);

  /// 여행 하나를 열 때 그 여행의 사진만 읽는다.
  ///
  /// 예전에는 space의 사진을 통째로 받아, 여행이 쌓일수록 준비물 하나 보려고
  /// 들어가도 지난 여행 사진을 전부 내려받았다.
  Future<void> ensureTripPhotosLoaded(
    String tripId, {
    bool force = false,
  }) async {
    // 전역 '로딩 중' 하나로 막으면 다른 여행을 열었을 때 조용히 건너뛰어
    // 빈 여행처럼 보인다. 여행별로 진행 중인 읽기를 따로 들고 있는다.
    final inFlight = _tripPhotoLoads[tripId];
    if (inFlight != null) {
      await inFlight;
      return;
    }
    if (!force && tripPhotosLoadedFor(tripId)) {
      return;
    }
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository == null || spaceId == null) {
      return;
    }
    final load = _loadTripPhotos(repository, spaceId, tripId);
    _tripPhotoLoads[tripId] = load;
    _tripPhotosFailed = false;
    notifyListeners();
    try {
      await load;
    } finally {
      _tripPhotoLoads.remove(tripId);
      notifyListeners();
    }
  }

  Future<void> _loadTripPhotos(
    AlagagiDataRepository repository,
    String spaceId,
    String tripId,
  ) async {
    try {
      final photos = await repository.loadTripPhotos(spaceId, tripId);
      // 통째로 갈아끼우면, 방금 올려 아직 서버에 닿지 않은 사진이 사라진다.
      // id로 합치고 서버 쪽을 우선한다.
      final loadedIds = photos.map((photo) => photo.id).toSet();
      _tripPhotos
        ..removeWhere(
          (photo) => photo.tripId == tripId && loadedIds.contains(photo.id),
        )
        ..addAll(photos);
      _loadedPhotoTripIds.add(tripId);
    } catch (_) {
      // 실패를 삼키면 빈 여행처럼 보인다. 화면이 구분할 수 있게 남긴다.
      _tripPhotosFailed = true;
    }
  }

  List<TripPhoto> tripPhotosFor(String tripId) {
    final photos = _tripPhotos
        .where((photo) => photo.tripId == tripId)
        .toList();
    photos.sort((first, second) {
      final firstAt = first.updatedAt;
      final secondAt = second.updatedAt;
      if (firstAt == null || secondAt == null) {
        return 0;
      }
      return secondAt.compareTo(firstAt);
    });
    return List<TripPhoto>.unmodifiable(photos);
  }

  /// 여행이 오늘 기준으로 어디쯤인지. 카드에 D-day를 보여주는 데 쓴다.
  TripTiming tripTimingFor(Trip trip) {
    final today = DateTime.tryParse(tripTodayDateKey);
    final start = trip.startDate;
    final end = trip.endDate;
    if (today == null || start == null || end == null) {
      return const TripTiming(phase: TripPhase.upcoming, daysUntilStart: 0);
    }
    if (today.isBefore(start)) {
      return TripTiming(
        phase: TripPhase.upcoming,
        daysUntilStart: start.difference(today).inDays,
      );
    }
    if (!today.isAfter(end)) {
      return TripTiming(
        phase: TripPhase.ongoing,
        daysUntilStart: 0,
        dayNumber: today.difference(start).inDays + 1,
      );
    }
    return const TripTiming(phase: TripPhase.past, daysUntilStart: 0);
  }

  int tripPhotoCount(String tripId) => tripPhotosFor(tripId).length;

  /// 갤러리에서 고른 사진을 여행에 붙인다. 실패 이유가 있으면 문자열로 돌려준다.
  String? saveTripPhoto({
    required String tripId,
    required String imageDataUrl,
    String caption = '',
    String? dateKey,
  }) {
    final trip = tripById(tripId);
    if (trip == null) {
      return '여행을 찾을 수 없어요.';
    }
    if (!imageDataUrl.startsWith('data:image/')) {
      return '사진 파일만 올릴 수 있어요.';
    }
    if (imageDataUrl.length > kTripPhotoMaxDataUrlLength) {
      return '사진 용량이 너무 커요. 다른 사진으로 골라주세요.';
    }
    if (caption.trim().length > kTripPhotoMaxCaptionLength) {
      return '설명은 $kTripPhotoMaxCaptionLength자 안으로 적어주세요.';
    }
    final resolvedDateKey = dateKey != null && trip.containsDateKey(dateKey)
        ? dateKey
        : null;

    final now = DateTime.now();
    final photo = TripPhoto(
      id: 'trip_photo_${_state.me.id}_${now.microsecondsSinceEpoch}',
      tripId: tripId,
      imageDataUrl: imageDataUrl,
      createdByProfileId: _state.me.id,
      caption: caption.trim(),
      dateKey: resolvedDateKey,
      updatedAt: now,
    );
    _tripPhotos.insert(0, photo);
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository != null && spaceId != null) {
      _persistTripPhoto(photo, feedback: '사진을 담았어요.');
    }
    notifyListeners();
    return null;
  }

  /// 사진 설명은 올린 사람만 고칠 수 있다.
  String? updateTripPhotoCaption(String photoId, String caption) {
    final index = _tripPhotos.indexWhere((photo) => photo.id == photoId);
    if (index < 0) {
      return '사진을 찾을 수 없어요.';
    }
    final existing = _tripPhotos[index];
    if (existing.createdByProfileId != _state.me.id) {
      return '올린 사람만 설명을 고칠 수 있어요.';
    }
    final trimmed = caption.trim();
    if (trimmed.length > kTripPhotoMaxCaptionLength) {
      return '설명은 $kTripPhotoMaxCaptionLength자 안으로 적어주세요.';
    }
    final updated = TripPhoto(
      id: existing.id,
      tripId: existing.tripId,
      imageDataUrl: existing.imageDataUrl,
      createdByProfileId: existing.createdByProfileId,
      caption: trimmed,
      dateKey: existing.dateKey,
      updatedAt: existing.updatedAt,
    );
    _tripPhotos[index] = updated;
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository != null && spaceId != null) {
      _persistTripPhoto(updated, feedback: '사진 설명을 저장했어요.');
    }
    notifyListeners();
    return null;
  }

  /// 사진은 올린 사람만 지울 수 있다.
  bool deleteTripPhoto(String photoId) {
    final index = _tripPhotos.indexWhere((photo) => photo.id == photoId);
    if (index < 0) {
      return false;
    }
    final removed = _tripPhotos.removeAt(index);
    _runTripWrite(
      _PendingTripWrite.deletePhoto(
        removed,
        restore: () {
          if (_tripPhotos.any((candidate) => candidate.id == removed.id)) {
            return;
          }
          _tripPhotos.insert(index.clamp(0, _tripPhotos.length), removed);
          notifyListeners();
        },
      ),
    );
    notifyListeners();
    return true;
  }

  /// 계획 중인 여행은 가까운 순, 다녀온 여행은 최근 순으로 읽는 편이 맞다.
  /// 같은 날 안에서 새 항목이 맨 뒤에 붙도록 다음 순서 값을 만든다.
  int _nextTripItemOrder(String tripId, String? dateKey) {
    var maxOrder = -1;
    for (final item in _tripItems) {
      if (item.tripId != tripId || item.dateKey != dateKey) {
        continue;
      }
      if (item.sortOrder > maxOrder) {
        maxOrder = item.sortOrder;
      }
    }
    return maxOrder + 1;
  }

  /// 타임라인에서 끌어 옮긴 순서를 저장한다.
  ///
  /// 시각이 같은 항목끼리는 시각만으로 순서를 정할 수 없다. 옮긴 자리의
  /// 순서를 그대로 굳혀 다음에 열어도 같게 보이도록 한다.

  /// 담당은 우리 둘 중 하나이거나 `함께`다.
  bool _isValidTripAssignee(String value) {
    return value == _state.me.id ||
        value == _state.partner.id ||
        value == kTripSharedAssigneeId;
  }

  /// 준비물을 챙길 사람을 바꾼다. 같은 사람을 다시 고르면 담당을 지운다.
  void setTripItemAssignee(String itemId, String? profileId) {
    final index = _tripItems.indexWhere((item) => item.id == itemId);
    if (index < 0 || !_tripItems[index].kind.usesCheck) {
      return;
    }
    final current = _tripItems[index];
    final next = current.assigneeProfileId == profileId ? null : profileId;
    if (next != null && !_isValidTripAssignee(next)) {
      return;
    }
    final updated = current.copyWith(
      assigneeProfileId: next,
      clearAssignee: next == null,
      updatedAt: DateTime.now(),
      updatedByProfileId: _state.me.id,
    );
    _tripItems[index] = updated;
    _persistTripItem(updated);
    notifyListeners();
  }

  /// 사진을 여행 특정 날짜에 묶는다. 빈 값이면 날짜 없이 둔다.
  String? setTripPhotoDateKey(String photoId, String? dateKey) {
    final index = _tripPhotos.indexWhere((photo) => photo.id == photoId);
    if (index < 0) {
      return '사진을 찾을 수 없어요.';
    }
    // 날짜로 묶는 것은 둘이 같이 정리하는 일이다. 올린 사람만 할 수 있으면
    // 상대가 담은 사진은 영영 미분류로 남는다.
    final existing = _tripPhotos[index];
    final trip = tripById(existing.tripId);
    if (dateKey != null && (trip == null || !trip.containsDateKey(dateKey))) {
      return '여행 기간 안의 날짜만 고를 수 있어요.';
    }
    _tripPhotos[index] = TripPhoto(
      id: existing.id,
      tripId: existing.tripId,
      imageDataUrl: existing.imageDataUrl,
      createdByProfileId: existing.createdByProfileId,
      caption: existing.caption,
      dateKey: dateKey,
      updatedAt: existing.updatedAt,
    );
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository != null && spaceId != null) {
      _persistTripPhoto(_tripPhotos[index], feedback: '사진 날짜를 정했어요.');
    }
    notifyListeners();
    return null;
  }

  /// 그날 찍은 사진. 타임라인 하루 끝에 함께 보여준다.
  List<TripPhoto> tripPhotosForDate(String tripId, String dateKey) {
    return List<TripPhoto>.unmodifiable(
      tripPhotosFor(tripId).where((photo) => photo.dateKey == dateKey),
    );
  }

  /// 홈에 보여줄 다가오거나 진행 중인 여행. 없으면 null이다.
  Trip? get upcomingTrip {
    for (final trip in _trips) {
      if (trip.status != TripStatus.planning) {
        continue;
      }
      final phase = tripTimingFor(trip).phase;
      if (phase == TripPhase.upcoming || phase == TripPhase.ongoing) {
        return trip;
      }
    }
    return null;
  }

  /// 날짜가 지났는데 아직 `계획 중`인 여행. 상태를 물어볼 때 쓴다.
  bool tripNeedsStatusNudge(Trip trip) {
    return trip.status == TripStatus.planning &&
        tripTimingFor(trip).phase == TripPhase.past;
  }

  void _sortTrips() {
    _trips.sort((first, second) {
      if (first.status != second.status) {
        return first.status == TripStatus.planning ? -1 : 1;
      }
      if (first.status == TripStatus.planning) {
        return first.startDateKey.compareTo(second.startDateKey);
      }
      return second.startDateKey.compareTo(first.startDateKey);
    });
  }

  /// 기간이 줄어들면 밖으로 나간 항목 날짜는 미정으로 되돌린다.
  void _dropTripItemDatesOutsideTrip(Trip trip) {
    for (var index = 0; index < _tripItems.length; index += 1) {
      final item = _tripItems[index];
      if (item.tripId != trip.id) {
        continue;
      }
      final dateKey = item.dateKey;
      final endDateKey = item.endDateKey;
      final startDropped = dateKey != null && !trip.containsDateKey(dateKey);
      final endDropped =
          endDateKey != null && !trip.containsDateKey(endDateKey);
      if (!startDropped && !endDropped) {
        continue;
      }
      // 체크인이 살아 있으면 체크아웃만 비운다.
      final updated = item.copyWith(
        clearDateKey: startDropped,
        clearTimeLabel: startDropped,
        clearEndDateKey: startDropped || endDropped,
        clearEndTimeLabel: startDropped || endDropped,
        updatedAt: DateTime.now(),
        updatedByProfileId: _state.me.id,
      );
      _tripItems[index] = updated;
      _persistTripItem(updated);
    }
  }

  void _persistTrip(Trip trip) {
    _runTripWrite(_PendingTripWrite.trip(trip));
  }

  void _persistTripItem(TripItem item) {
    _runTripWrite(_PendingTripWrite.item(item));
  }

  void _persistTripPhoto(TripPhoto photo, {required String feedback}) {
    _runTripWrite(_PendingTripWrite.photo(photo, feedback: feedback));
  }

  /// 여행 write 하나를 흘려보내고 결과를 상태로 남긴다.
  ///
  /// 실패를 조용히 삼키면 화면은 저장된 것처럼 보이고 다음 진입에 되돌아간다.
  /// 실패한 write는 모아두고 사용자가 다시 시도할 수 있게 한다.
  void _runTripWrite(_PendingTripWrite write, {String? feedback}) {
    final resolvedFeedback = feedback ?? write.feedback;
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository == null || spaceId == null) {
      return;
    }
    _state = _state.copyWith(
      tripSaveStatus: SaveStatus.saving,
      // 아직 실패한 write가 남아 있으면 안내를 지우면 안 된다. 지우면
      // 다시 시도할 button까지 사라져 되돌릴 길이 없어진다.
      clearTripSaveError: _failedTripWrites.isEmpty,
      clearTripSaveFeedback: true,
    );
    notifyListeners();

    unawaited(
      write
          .send(repository, spaceId)
          .then<void>((_) {
            _failedTripWrites.removeWhere(
              (pending) => pending.key == write.key,
            );
            if (_failedTripWrites.isEmpty) {
              _state = _state.copyWith(
                tripSaveStatus: SaveStatus.saved,
                tripSaveFeedback: resolvedFeedback,
                clearTripSaveError: true,
              );
            } else {
              // 이번 것은 됐지만 아직 못 보낸 것이 남았다. 저장했다고 말하면
              // 거짓이고, 아무 말도 안 하면 화면이 영원히 조용해진다.
              _state = _state.copyWith(
                tripSaveStatus: SaveStatus.failed,
                tripSaveError: '여행 내용 일부를 저장하지 못했어요. 다시 시도해 주세요.',
                clearTripSaveFeedback: true,
              );
            }
            notifyListeners();
          })
          .catchError((Object _) {
            // 지운 것이 서버에 닿지 않았으면 화면에서도 되살려야 한다.
            // 지운 줄 알고 나갔다가 다음에 되돌아와 있는 것이 제일 나쁘다.
            write.restore?.call();
            _failedTripWrites
              ..removeWhere((pending) => pending.key == write.key)
              ..add(write);
            _state = _state.copyWith(
              tripSaveStatus: SaveStatus.failed,
              tripSaveError: write.op == _TripWriteOp.delete
                  ? '여행 내용을 지우지 못했어요. 다시 시도해 주세요.'
                  : '여행 내용을 저장하지 못했어요. 다시 시도해 주세요.',
              clearTripSaveFeedback: true,
            );
            notifyListeners();
          }),
    );
  }

  bool get hasFailedTripWrites => _failedTripWrites.isNotEmpty;

  /// 실패한 여행 write를 한 번에 다시 보낸다.
  void retryTripSaves() {
    if (_failedTripWrites.isEmpty) {
      return;
    }
    final pending = List<_PendingTripWrite>.from(_failedTripWrites);
    _failedTripWrites.clear();
    for (final write in pending) {
      _runTripWrite(write);
    }
  }

  /// 저장 안내를 사용자가 확인하면 지운다.
  void clearTripSaveFeedback() {
    if (_state.tripSaveFeedback == null && _state.tripSaveError == null) {
      return;
    }
    _state = _state.copyWith(
      tripSaveStatus: SaveStatus.idle,
      clearTripSaveFeedback: true,
      clearTripSaveError: true,
    );
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
      inputHint: '직접 추가한 서로 노트',
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

  MemoryCard? createMemoryCard({
    required MemoryCardType type,
    required String title,
    required String body,
    MemoryCardVisibility visibility = MemoryCardVisibility.shared,
  }) {
    final trimmedTitle = title.trim();
    final trimmedBody = body.trim();
    if (trimmedTitle.length < kMemoryCardTitleMinLength ||
        trimmedTitle.length > kMemoryCardTitleMaxLength) {
      return null;
    }
    if (trimmedBody.isEmpty || trimmedBody.length > kMemoryCardBodyMaxLength) {
      return null;
    }
    final now = DateTime.now();
    final card = MemoryCard(
      id: 'memory_${_state.me.id}_${now.microsecondsSinceEpoch}',
      type: type,
      title: trimmedTitle,
      body: trimmedBody,
      createdByProfileId: _state.me.id,
      subjectProfileId: _state.partner.id,
      visibility: visibility,
      createdLabel: '오늘',
      updatedAt: now,
      updatedByProfileId: _state.me.id,
    );
    _memoryCards.insert(0, card);
    _sortMemoryCardsByUpdatedAt();
    notifyListeners();
    _persistMemoryCard(card);
    return card;
  }

  MemoryCard? setMemoryCardVisibility(
    String cardId,
    MemoryCardVisibility visibility,
  ) {
    final index = _memoryCards.indexWhere((card) => card.id == cardId);
    if (index == -1 || _memoryCards[index].createdByProfileId != _state.me.id) {
      return null;
    }
    final updatedCard = _memoryCards[index].copyWith(
      visibility: visibility,
      updatedAt: DateTime.now(),
      updatedByProfileId: _state.me.id,
    );
    _memoryCards[index] = updatedCard;
    _sortMemoryCardsByUpdatedAt();
    notifyListeners();
    _persistMemoryCard(updatedCard);
    return updatedCard;
  }

  MemoryCardResponse? respondToMemoryCard(
    String cardId,
    MemoryCardReaction reaction, {
    String correctionText = '',
  }) {
    final card = _memoryCards.cast<MemoryCard?>().firstWhere(
      (candidate) => candidate?.id == cardId,
      orElse: () => null,
    );
    if (card == null ||
        !card.isShared ||
        card.createdByProfileId == _state.me.id) {
      return null;
    }
    final trimmedCorrection = correctionText.trim();
    if (reaction == MemoryCardReaction.correction &&
        trimmedCorrection.isEmpty) {
      return null;
    }
    if (trimmedCorrection.length > kMemoryCardCorrectionMaxLength) {
      return null;
    }

    final now = DateTime.now();
    final response = MemoryCardResponse(
      id: '${card.id}_${_state.me.id}',
      cardId: card.id,
      responderProfileId: _state.me.id,
      reaction: reaction,
      correctionText: reaction == MemoryCardReaction.correction
          ? trimmedCorrection
          : '',
      updatedAt: now,
    );
    final index = _memoryCardResponses.indexWhere(
      (candidate) => candidate.id == response.id,
    );
    if (index == -1) {
      _memoryCardResponses.insert(0, response);
    } else {
      _memoryCardResponses[index] = response;
    }
    _sortMemoryCardResponsesByUpdatedAt();
    notifyListeners();
    _persistMemoryCardResponse(response);
    return response;
  }

  MemoryCard? applyMemoryCardCorrection(
    String cardId, {
    required String responderProfileId,
  }) {
    final cardIndex = _memoryCards.indexWhere((card) => card.id == cardId);
    if (cardIndex == -1 ||
        _memoryCards[cardIndex].createdByProfileId != _state.me.id) {
      return null;
    }
    final response = memoryResponseForCard(
      cardId,
      responderProfileId: responderProfileId,
    );
    if (response == null || !response.hasCorrection) {
      return null;
    }
    final updatedCard = _memoryCards[cardIndex].copyWith(
      body: response.correctionText.trim(),
      updatedAt: DateTime.now(),
      updatedByProfileId: _state.me.id,
    );
    _memoryCards[cardIndex] = updatedCard;
    _sortMemoryCardsByUpdatedAt();
    notifyListeners();
    _persistMemoryCard(updatedCard);
    return updatedCard;
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

  String musicCommentDraftForNote(String noteId) {
    return _state.musicCommentDraftsByNoteId[noteId] ?? '';
  }

  String musicCommentEditDraftForComment(String commentId) {
    return _state.musicCommentEditDraftsByCommentId[commentId] ??
        _musicNoteComments
            .cast<MusicNoteComment?>()
            .firstWhere(
              (comment) => comment?.id == commentId,
              orElse: () => null,
            )
            ?.body ??
        '';
  }

  bool hasMusicCommentEditDraft(String commentId) {
    return _state.musicCommentEditDraftsByCommentId.containsKey(commentId);
  }

  bool isMusicCommentSaveTarget(String commentId) {
    return _state.musicCommentSaveTargetId == commentId;
  }

  void updateMusicCommentDraft(String noteId, String value) {
    final drafts = Map<String, String>.of(_state.musicCommentDraftsByNoteId)
      ..[noteId] = value;
    _state = _state.copyWith(
      musicCommentDraftsByNoteId: Map<String, String>.unmodifiable(drafts),
      musicCommentSaveStatus: SaveStatus.idle,
      clearMusicCommentError: true,
      clearMusicCommentSaveFeedback: true,
    );
    notifyListeners();
  }

  void submitMusicComment(String noteId) {
    if (_state.musicCommentSaveStatus == SaveStatus.saving) {
      return;
    }
    final noteExists = _musicNotes.any((note) => note.id == noteId);
    if (!noteExists) {
      _state = _state.copyWith(
        musicCommentError: '댓글을 남길 음악 노트를 찾지 못했어요.',
        musicCommentSaveStatus: SaveStatus.idle,
      );
      notifyListeners();
      return;
    }
    final body = musicCommentDraftForNote(noteId).trim();
    if (body.isEmpty) {
      _state = _state.copyWith(
        musicCommentError: '한 줄만 남겨도 괜찮아요.',
        musicCommentSaveStatus: SaveStatus.idle,
      );
      notifyListeners();
      return;
    }
    if (body.length > 180) {
      _state = _state.copyWith(
        musicCommentError: '댓글은 180자 안으로 남겨주세요.',
        musicCommentSaveStatus: SaveStatus.idle,
      );
      notifyListeners();
      return;
    }

    final now = DateTime.now();
    final comment = MusicNoteComment(
      id: 'music_comment_${_state.me.id}_${now.microsecondsSinceEpoch}',
      musicNoteId: noteId,
      body: body,
      createdByProfileId: _state.me.id,
      createdLabel: '오늘',
      createdAt: now,
      updatedAt: now,
    );
    _musicNoteComments.insert(0, comment);
    _sortMusicNoteCommentsByUpdatedAt();
    final drafts = Map<String, String>.of(_state.musicCommentDraftsByNoteId)
      ..remove(noteId);
    _lastFailedMusicNoteComment = null;
    _lastFailedMusicNoteCommentAction = null;
    _state = _state.copyWith(
      musicCommentDraftsByNoteId: Map<String, String>.unmodifiable(drafts),
      musicCommentSaveStatus: SaveStatus.saving,
      musicCommentSaveTargetId: comment.id,
      clearMusicCommentError: true,
      clearMusicCommentSaveFeedback: true,
    );
    notifyListeners();
    _persistMusicNoteComment(comment);
  }

  void startMusicCommentEdit(String commentId) {
    final comment = _musicNoteComments.cast<MusicNoteComment?>().firstWhere(
      (candidate) => candidate?.id == commentId,
      orElse: () => null,
    );
    if (comment == null) {
      _state = _state.copyWith(musicCommentError: '수정할 댓글을 찾지 못했어요.');
      notifyListeners();
      return;
    }
    if (comment.createdByProfileId != _state.me.id) {
      _state = _state.copyWith(musicCommentError: '내가 남긴 댓글만 수정할 수 있어요.');
      notifyListeners();
      return;
    }
    final drafts = Map<String, String>.of(
      _state.musicCommentEditDraftsByCommentId,
    )..[comment.id] = comment.body;
    _state = _state.copyWith(
      musicCommentEditDraftsByCommentId: Map<String, String>.unmodifiable(
        drafts,
      ),
      musicCommentSaveStatus: SaveStatus.idle,
      clearMusicCommentError: true,
      clearMusicCommentSaveFeedback: true,
    );
    notifyListeners();
  }

  void updateMusicCommentEditDraft(String commentId, String value) {
    final drafts = Map<String, String>.of(
      _state.musicCommentEditDraftsByCommentId,
    )..[commentId] = value;
    _state = _state.copyWith(
      musicCommentEditDraftsByCommentId: Map<String, String>.unmodifiable(
        drafts,
      ),
      musicCommentSaveStatus: SaveStatus.idle,
      clearMusicCommentError: true,
      clearMusicCommentSaveFeedback: true,
    );
    notifyListeners();
  }

  void cancelMusicCommentEdit(String commentId) {
    final drafts = Map<String, String>.of(
      _state.musicCommentEditDraftsByCommentId,
    )..remove(commentId);
    _state = _state.copyWith(
      musicCommentEditDraftsByCommentId: Map<String, String>.unmodifiable(
        drafts,
      ),
      musicCommentSaveStatus: SaveStatus.idle,
      clearMusicCommentError: true,
      clearMusicCommentSaveFeedback: true,
    );
    notifyListeners();
  }

  void submitMusicCommentEdit(String commentId) {
    if (_state.musicCommentSaveStatus == SaveStatus.saving) {
      return;
    }
    final index = _musicNoteComments.indexWhere(
      (comment) => comment.id == commentId,
    );
    if (index == -1) {
      _state = _state.copyWith(musicCommentError: '수정할 댓글을 찾지 못했어요.');
      notifyListeners();
      return;
    }
    final current = _musicNoteComments[index];
    if (current.createdByProfileId != _state.me.id) {
      _state = _state.copyWith(musicCommentError: '내가 남긴 댓글만 수정할 수 있어요.');
      notifyListeners();
      return;
    }
    final body = musicCommentEditDraftForComment(commentId).trim();
    if (body.isEmpty) {
      _state = _state.copyWith(
        musicCommentError: '한 줄만 남겨도 괜찮아요.',
        musicCommentSaveStatus: SaveStatus.idle,
      );
      notifyListeners();
      return;
    }
    if (body.length > 180) {
      _state = _state.copyWith(
        musicCommentError: '댓글은 180자 안으로 남겨주세요.',
        musicCommentSaveStatus: SaveStatus.idle,
      );
      notifyListeners();
      return;
    }
    final updated = current.copyWith(
      body: body,
      edited: true,
      updatedAt: DateTime.now(),
    );
    _musicNoteComments[index] = updated;
    _sortMusicNoteCommentsByUpdatedAt();
    final drafts = Map<String, String>.of(
      _state.musicCommentEditDraftsByCommentId,
    )..remove(commentId);
    _lastFailedMusicNoteComment = null;
    _lastFailedMusicNoteCommentAction = null;
    _state = _state.copyWith(
      musicCommentEditDraftsByCommentId: Map<String, String>.unmodifiable(
        drafts,
      ),
      musicCommentSaveStatus: SaveStatus.saving,
      musicCommentSaveTargetId: updated.id,
      clearMusicCommentError: true,
      clearMusicCommentSaveFeedback: true,
    );
    notifyListeners();
    _persistMusicNoteComment(updated);
  }

  void deleteMusicComment(String commentId) {
    if (_state.musicCommentSaveStatus == SaveStatus.saving) {
      return;
    }
    final index = _musicNoteComments.indexWhere(
      (comment) => comment.id == commentId,
    );
    if (index == -1) {
      _state = _state.copyWith(musicCommentError: '삭제할 댓글을 찾지 못했어요.');
      notifyListeners();
      return;
    }
    final comment = _musicNoteComments[index];
    if (comment.createdByProfileId != _state.me.id) {
      _state = _state.copyWith(musicCommentError: '내가 남긴 댓글만 삭제할 수 있어요.');
      notifyListeners();
      return;
    }
    _musicNoteComments.removeAt(index);
    final editDrafts = Map<String, String>.of(
      _state.musicCommentEditDraftsByCommentId,
    )..remove(commentId);
    _lastFailedMusicNoteComment = null;
    _lastFailedMusicNoteCommentAction = null;
    _state = _state.copyWith(
      musicCommentEditDraftsByCommentId: Map<String, String>.unmodifiable(
        editDrafts,
      ),
      musicCommentSaveStatus: SaveStatus.saving,
      musicCommentSaveTargetId: comment.id,
      clearMusicCommentError: true,
      clearMusicCommentSaveFeedback: true,
    );
    notifyListeners();
    _deletePersistedMusicNoteComment(comment, index);
  }

  void retryMusicCommentSave() {
    final comment = _lastFailedMusicNoteComment;
    if (comment == null || _state.musicCommentSaveStatus == SaveStatus.saving) {
      return;
    }
    final previousIndex = _musicNoteComments.indexWhere(
      (candidate) => candidate.id == comment.id,
    );
    if (_lastFailedMusicNoteCommentAction == _FailedPersistenceAction.delete &&
        previousIndex != -1) {
      _musicNoteComments.removeAt(previousIndex);
      _sortMusicNoteCommentsByUpdatedAt();
    }
    _state = _state.copyWith(
      musicCommentSaveStatus: SaveStatus.saving,
      musicCommentSaveTargetId: comment.id,
      clearMusicCommentError: true,
      clearMusicCommentSaveFeedback: true,
    );
    notifyListeners();
    if (_lastFailedMusicNoteCommentAction == _FailedPersistenceAction.delete) {
      _deletePersistedMusicNoteComment(
        comment,
        previousIndex == -1 ? 0 : previousIndex,
      );
    } else {
      _persistMusicNoteComment(comment);
    }
  }

  void selectMeetingDate(String dateKey) {
    final entry = scheduleEntryFor(_state.me.id, dateKey);
    final meetingDayEntry = meetingDayEntryFor(dateKey);
    final cancelled = _meetingDayCancelled(dateKey);
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
          !cancelled &&
          (entry?.isMeetingDay ?? meetingDayEntry?.isMeetingDay ?? false),
      meetingDraftMeetingTimeLabel: cancelled
          ? ''
          : entry?.meetingTimeLabel ?? meetingDayEntry?.meetingTimeLabel ?? '',
      meetingDraftMeetingNote: cancelled
          ? ''
          : entry?.meetingNote ?? meetingDayEntry?.meetingNote ?? '',
      meetingDraftMeetingPlanText: _meetingPlanTextFromItems(
        cancelled ? const [] : meetingPlanItemsFor(dateKey),
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
    _autoSaveMeetingPlanDraft();
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
    _autoSaveMeetingPlanDraft();
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
    _autoSaveMeetingPlanDraft();
  }

  /// 계획 항목을 담거나 고치거나 지우면 그 자리에서 저장한다.
  ///
  /// 타이핑은 저장하지 않는다. `추가`를 누르는 것, 지우는 것, 순서를 바꾸는
  /// 것만 명시적인 동작이고, 그때마다 문서 하나를 쓴다.
  void _autoSaveMeetingPlanDraft() {
    // 고치던 줄은 그대로 둔다. 저장했다고 편집을 취소해 버리면 순서를
    // 바꾸는 사이에 적던 것이 사라진다.
    _saveMeetingPlanDraft(feedback: '자동으로 저장했어요.', preserveEditing: true);
  }

  void submitMeetingPlanDraft() {
    if (_state.meetingSaveStatus == SaveStatus.saving) {
      return;
    }
    _saveMeetingPlanDraft(feedback: '계획을 저장했어요.');
  }

  void _saveMeetingPlanDraft({
    required String feedback,
    bool preserveEditing = false,
  }) {
    final dateKey = selectedMeetingPlanDateKey;
    final meetingDayEntry = meetingDayEntryFor(dateKey);
    if (meetingDayEntry == null) {
      // 조용히 넘기면 적은 것이 저장된 줄 알고 화면을 떠난다.
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
      isCancelled: false,
      updatedAt: DateTime.now(),
    );
    _upsertMeetingPlan(plan);
    _lastFailedMeetingPlan = null;
    _state = _state.copyWith(
      selectedMeetingPlanDateKey: dateKey,
      meetingPlanDraftText: _meetingPlanTextFromItems(meetingPlanItems),
      meetingPlanItemDraft: preserveEditing
          ? _state.meetingPlanItemDraft
          : '',
      editingMeetingPlanItemIndex: preserveEditing
          ? _state.editingMeetingPlanItemIndex
          : null,
      clearEditingMeetingPlanItemIndex: !preserveEditing,
      meetingDraftMeetingPlanText: dateKey == selectedMeetingDateKey
          ? _meetingPlanTextFromItems(meetingPlanItems)
          : _state.meetingDraftMeetingPlanText,
      meetingSaveStatus: SaveStatus.saving,
      meetingSaveTargetId: plan.id,
      clearMeetingDraftError: true,
      clearMeetingSaveFeedback: true,
    );
    notifyListeners();
    _persistMeetingPlan(plan, successFeedback: feedback);
  }

  void submitMeetingDayDraft() {
    _submitMeetingDraft(
      markAsMeetingDay: true,
      successFeedback: '만나는 날로 저장했어요.',
    );
  }

  void cancelMeetingDay(String dateKey) {
    if (_state.meetingSaveStatus == SaveStatus.saving) {
      return;
    }
    if (meetingDayEntryFor(dateKey) == null && !_meetingDayCancelled(dateKey)) {
      _state = _state.copyWith(meetingDraftError: '취소할 만남을 찾지 못했어요.');
      notifyListeners();
      return;
    }

    final planDateWasSelected = selectedMeetingPlanDateKey == dateKey;
    final plan = MeetingPlan(
      dateKey: dateKey,
      items: meetingPlanItemsFor(dateKey),
      updatedByProfileId: _state.me.id,
      isCancelled: true,
      updatedAt: DateTime.now(),
    );
    _upsertMeetingPlan(plan);
    _lastFailedMeetingPlan = null;

    final selectedMeetingDate = selectedMeetingDateKey == dateKey;
    final nextPlanEntry = planDateWasSelected ? nextMeetingDayEntry : null;
    _state = _state.copyWith(
      meetingDraftIsMeetingDay: selectedMeetingDate
          ? false
          : _state.meetingDraftIsMeetingDay,
      meetingDraftMeetingTimeLabel: selectedMeetingDate
          ? ''
          : _state.meetingDraftMeetingTimeLabel,
      meetingDraftMeetingNote: selectedMeetingDate
          ? ''
          : _state.meetingDraftMeetingNote,
      meetingDraftMeetingPlanText: selectedMeetingDate
          ? ''
          : _state.meetingDraftMeetingPlanText,
      selectedMeetingPlanDateKey: planDateWasSelected
          ? nextPlanEntry?.dateKey
          : _state.selectedMeetingPlanDateKey,
      clearSelectedMeetingPlanDateKey:
          planDateWasSelected && nextPlanEntry == null,
      meetingPlanDraftText: planDateWasSelected
          ? _meetingPlanTextFromItems(
              nextPlanEntry == null
                  ? const []
                  : meetingPlanItemsFor(nextPlanEntry.dateKey),
            )
          : _state.meetingPlanDraftText,
      meetingPlanItemDraft: planDateWasSelected
          ? ''
          : _state.meetingPlanItemDraft,
      clearEditingMeetingPlanItemIndex: planDateWasSelected,
      meetingSaveStatus: SaveStatus.saving,
      meetingSaveTargetId: plan.id,
      clearMeetingDraftError: true,
      clearMeetingSaveFeedback: true,
    );
    notifyListeners();
    _persistMeetingPlan(plan, successFeedback: '만남을 취소했어요.');
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
    final currentPlan = _persistedMeetingPlanFor(selectedMeetingDateKey);
    final sharedPlan = isMeetingDay
        ? MeetingPlan(
            dateKey: selectedMeetingDateKey,
            items: List<String>.unmodifiable(
              meetingPlanItems.isNotEmpty
                  ? meetingPlanItems
                  : currentPlan?.items ?? const [],
            ),
            updatedByProfileId: _state.me.id,
            isCancelled: false,
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

/// 첫 질문 세트. 이미 지나간 질문이므로 보존용이며 수정하지 않는다.
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

/// DAY 33부터 쓰는 질문 세트. 만난 지 얼마 되지 않은 두 사람 기준으로 다시 썼다.
const questionCatalogV2 = [
  DailyQuestion(
    id: 'qb001',
    day: 33,
    number: 33,
    depth: QuestionDepth.light,
    text: '요즘 하루 중에 제일 마음이 편해지는 시간은 언제예요?',
    highlightedText: '마음이 편해지는 시간',
  ),
  DailyQuestion(
    id: 'qb002',
    day: 34,
    number: 34,
    depth: QuestionDepth.light,
    text: '오늘 나를 기분 좋게 한 아주 작은 일이 있었어요?',
    highlightedText: '기분 좋았던 일',
  ),
  DailyQuestion(
    id: 'qb003',
    day: 35,
    number: 35,
    depth: QuestionDepth.light,
    text: '요즘 자주 듣는 노래 하나만 알려줄래요?',
    highlightedText: '자주 듣는 노래',
  ),
  DailyQuestion(
    id: 'qb004',
    day: 36,
    number: 36,
    depth: QuestionDepth.light,
    text: '피곤할 때 나만의 회복 방법이 있어요?',
    highlightedText: '회복 방법',
  ),
  DailyQuestion(
    id: 'qb005',
    day: 37,
    number: 37,
    depth: QuestionDepth.light,
    text: '요즘 제일 자주 먹게 되는 음식은 뭐예요?',
    highlightedText: '자주 먹는 음식',
  ),
  DailyQuestion(
    id: 'qb006',
    day: 38,
    number: 38,
    depth: QuestionDepth.light,
    text: '카페에 가면 보통 뭘 시켜요?',
    highlightedText: '카페에서 시키는 것',
  ),
  DailyQuestion(
    id: 'qb007',
    day: 39,
    number: 39,
    depth: QuestionDepth.light,
    text: '쉬는 날 아침은 보통 어떻게 시작해요?',
    highlightedText: '쉬는 날 아침',
  ),
  DailyQuestion(
    id: 'qb008',
    day: 40,
    number: 40,
    depth: QuestionDepth.light,
    text: '요즘 빠져 있는 게 있다면 뭐예요?',
    highlightedText: '요즘 빠진 것',
  ),
  DailyQuestion(
    id: 'qb009',
    day: 41,
    number: 41,
    depth: QuestionDepth.light,
    text: '사진첩에서 최근에 찍은 사진은 어떤 거예요?',
    highlightedText: '최근에 찍은 사진',
  ),
  DailyQuestion(
    id: 'qb010',
    day: 42,
    number: 42,
    depth: QuestionDepth.light,
    text: '기분이 가라앉을 때 찾아보는 콘텐츠가 있어요?',
    highlightedText: '기분 전환 콘텐츠',
  ),
  DailyQuestion(
    id: 'qb011',
    day: 43,
    number: 43,
    depth: QuestionDepth.light,
    text: '걷기 좋다고 느끼는 날씨는 어떤 날씨예요?',
    highlightedText: '걷기 좋은 날씨',
  ),
  DailyQuestion(
    id: 'qb012',
    day: 44,
    number: 44,
    depth: QuestionDepth.light,
    text: '요즘 사고 싶은 물건이 있어요?',
    highlightedText: '사고 싶은 것',
  ),
  DailyQuestion(
    id: 'qb013',
    day: 45,
    number: 45,
    depth: QuestionDepth.light,
    text: '하루를 마무리할 때 꼭 하는 일이 있어요?',
    highlightedText: '하루 마무리',
  ),
  DailyQuestion(
    id: 'qb014',
    day: 46,
    number: 46,
    depth: QuestionDepth.light,
    text: '이번 주에 제일 잘한 일 하나만 꼽는다면요?',
    highlightedText: '이번 주 잘한 일',
  ),
  DailyQuestion(
    id: 'qb015',
    day: 47,
    number: 47,
    depth: QuestionDepth.daily,
    text: '우리가 처음 만난 날, 제일 먼저 눈에 들어온 건 뭐였어요?',
    highlightedText: '처음 만난 날',
  ),
  DailyQuestion(
    id: 'qb016',
    day: 48,
    number: 48,
    depth: QuestionDepth.daily,
    text: '나랑 있을 때 제일 편했던 순간은 언제였어요?',
    highlightedText: '편했던 순간',
  ),
  DailyQuestion(
    id: 'qb017',
    day: 49,
    number: 49,
    depth: QuestionDepth.daily,
    text: '요즘 나한테 연락하고 싶어지는 순간은 언제예요?',
    highlightedText: '연락하고 싶은 순간',
  ),
  DailyQuestion(
    id: 'qb018',
    day: 50,
    number: 50,
    depth: QuestionDepth.daily,
    text: '같이 갔던 곳 중에 다시 가보고 싶은 데가 있어요?',
    highlightedText: '다시 가고 싶은 곳',
  ),
  DailyQuestion(
    id: 'qb019',
    day: 51,
    number: 51,
    depth: QuestionDepth.daily,
    text: '내가 웃겼던 순간이 있었어요?',
    highlightedText: '웃겼던 순간',
  ),
  DailyQuestion(
    id: 'qb020',
    day: 52,
    number: 52,
    depth: QuestionDepth.daily,
    text: '요즘 나를 떠올리면 같이 생각나는 게 있어요?',
    highlightedText: '같이 떠오르는 것',
  ),
  DailyQuestion(
    id: 'qb021',
    day: 53,
    number: 53,
    depth: QuestionDepth.daily,
    text: '만나기 전에 보통 뭘 준비해요?',
    highlightedText: '만나기 전 준비',
  ),
  DailyQuestion(
    id: 'qb022',
    day: 54,
    number: 54,
    depth: QuestionDepth.daily,
    text: '만날 코스는 미리 정하는 편이에요, 그때그때 정하는 편이에요?',
    highlightedText: '코스 정하는 방식',
  ),
  DailyQuestion(
    id: 'qb023',
    day: 55,
    number: 55,
    depth: QuestionDepth.daily,
    text: '같이 있을 때 말없이 조용한 시간도 편한 편이에요?',
    highlightedText: '조용한 시간',
  ),
  DailyQuestion(
    id: 'qb024',
    day: 56,
    number: 56,
    depth: QuestionDepth.daily,
    text: '연락은 자주 오가는 게 좋아요, 필요할 때만 하는 게 좋아요?',
    highlightedText: '연락 속도',
  ),
  DailyQuestion(
    id: 'qb025',
    day: 57,
    number: 57,
    depth: QuestionDepth.daily,
    text: '나한테 듣고 싶은 말이 있다면 뭐예요?',
    highlightedText: '듣고 싶은 말',
  ),
  DailyQuestion(
    id: 'qb026',
    day: 58,
    number: 58,
    depth: QuestionDepth.daily,
    text: '서운한 게 생기면 바로 말하는 편이에요?',
    highlightedText: '서운함 말하기',
  ),
  DailyQuestion(
    id: 'qb027',
    day: 59,
    number: 59,
    depth: QuestionDepth.daily,
    text: '기분이 안 좋은 날에는 옆에서 어떻게 해주면 좋아요?',
    highlightedText: '기분이 안 좋은 날',
  ),
  DailyQuestion(
    id: 'qb028',
    day: 60,
    number: 60,
    depth: QuestionDepth.daily,
    text: '혼자 있고 싶은 날에는 어떻게 알려주면 좋을까요?',
    highlightedText: '혼자 있고 싶은 날',
  ),
  DailyQuestion(
    id: 'qb029',
    day: 61,
    number: 61,
    depth: QuestionDepth.daily,
    text: '같이 하면 재밌을 것 같은데 아직 못 해본 게 있어요?',
    highlightedText: '아직 못 해본 것',
  ),
  DailyQuestion(
    id: 'qb030',
    day: 62,
    number: 62,
    depth: QuestionDepth.daily,
    text: '요즘 우리한테 잘 맞는 만남 주기는 어느 정도인 것 같아요?',
    highlightedText: '만남 주기',
  ),
  DailyQuestion(
    id: 'qb031',
    day: 63,
    number: 63,
    depth: QuestionDepth.beliefs,
    text: '사람이 좋아지는 순간은 보통 어떤 때예요?',
    highlightedText: '좋아지는 순간',
  ),
  DailyQuestion(
    id: 'qb032',
    day: 64,
    number: 64,
    depth: QuestionDepth.beliefs,
    text: '나를 편하게 만들어주는 사람들의 공통점이 있어요?',
    highlightedText: '편해지는 사람',
  ),
  DailyQuestion(
    id: 'qb033',
    day: 65,
    number: 65,
    depth: QuestionDepth.beliefs,
    text: '관계에서 제일 중요하게 생각하는 건 뭐예요?',
    highlightedText: '중요하게 보는 것',
  ),
  DailyQuestion(
    id: 'qb034',
    day: 66,
    number: 66,
    depth: QuestionDepth.beliefs,
    text: '고마운데 표현을 잘 못하고 넘어간 적이 있어요?',
    highlightedText: '표현하지 못한 마음',
  ),
  DailyQuestion(
    id: 'qb035',
    day: 67,
    number: 67,
    depth: QuestionDepth.beliefs,
    text: '스스로 마음에 드는 성격 하나를 꼽는다면요?',
    highlightedText: '마음에 드는 성격',
  ),
  DailyQuestion(
    id: 'qb036',
    day: 68,
    number: 68,
    depth: QuestionDepth.beliefs,
    text: '바꾸고 싶은 습관이 있어요?',
    highlightedText: '바꾸고 싶은 습관',
  ),
  DailyQuestion(
    id: 'qb037',
    day: 69,
    number: 69,
    depth: QuestionDepth.beliefs,
    text: '요즘 가장 신경 쓰고 있는 일은 뭐예요?',
    highlightedText: '신경 쓰이는 일',
  ),
  DailyQuestion(
    id: 'qb038',
    day: 70,
    number: 70,
    depth: QuestionDepth.beliefs,
    text: '일하거나 공부할 때 나는 어떤 사람이에요?',
    highlightedText: '일할 때의 나',
  ),
  DailyQuestion(
    id: 'qb039',
    day: 71,
    number: 71,
    depth: QuestionDepth.beliefs,
    text: '돈을 써도 아깝지 않은 항목이 있어요?',
    highlightedText: '아깝지 않은 소비',
  ),
  DailyQuestion(
    id: 'qb040',
    day: 72,
    number: 72,
    depth: QuestionDepth.beliefs,
    text: '어릴 때 자주 하던 놀이나 취미가 있었어요?',
    highlightedText: '어릴 때 취미',
  ),
  DailyQuestion(
    id: 'qb041',
    day: 73,
    number: 73,
    depth: QuestionDepth.beliefs,
    text: '가족이나 친구들 사이에서 나는 어떤 역할이에요?',
    highlightedText: '내 역할',
  ),
  DailyQuestion(
    id: 'qb042',
    day: 74,
    number: 74,
    depth: QuestionDepth.beliefs,
    text: '최근에 마음이 놓였던 순간은 언제였어요?',
    highlightedText: '마음 놓인 순간',
  ),
  DailyQuestion(
    id: 'qb043',
    day: 75,
    number: 75,
    depth: QuestionDepth.beliefs,
    text: '요즘 스스로에게 해주고 싶은 말이 있어요?',
    highlightedText: '나에게 하고 싶은 말',
  ),
  DailyQuestion(
    id: 'qb044',
    day: 76,
    number: 76,
    depth: QuestionDepth.beliefs,
    text: '무리하고 있다는 신호를 어떻게 알아채요?',
    highlightedText: '무리하는 신호',
  ),
  DailyQuestion(
    id: 'qb045',
    day: 77,
    number: 77,
    depth: QuestionDepth.beliefs,
    text: '잘 쉬었다고 느끼는 하루는 어떤 하루예요?',
    highlightedText: '잘 쉰 하루',
  ),
  DailyQuestion(
    id: 'qb046',
    day: 78,
    number: 78,
    depth: QuestionDepth.inner,
    text: '앞으로 몇 달 안에 해보고 싶은 게 있어요?',
    highlightedText: '해보고 싶은 것',
  ),
  DailyQuestion(
    id: 'qb047',
    day: 79,
    number: 79,
    depth: QuestionDepth.inner,
    text: '같이 가보고 싶은 도시나 동네가 있어요?',
    highlightedText: '가보고 싶은 곳',
  ),
  DailyQuestion(
    id: 'qb048',
    day: 80,
    number: 80,
    depth: QuestionDepth.inner,
    text: '내가 잘 몰랐던 나의 모습이 있다면 알려줄래요?',
    highlightedText: '잘 모르던 모습',
  ),
  DailyQuestion(
    id: 'qb049',
    day: 81,
    number: 81,
    depth: QuestionDepth.inner,
    text: '요즘 나에게 고마웠던 순간이 있었어요?',
    highlightedText: '고마웠던 순간',
  ),
  DailyQuestion(
    id: 'qb050',
    day: 82,
    number: 82,
    depth: QuestionDepth.inner,
    text: '나랑 있을 때 조금 더 해보고 싶은 게 있어요?',
    highlightedText: '더 해보고 싶은 것',
  ),
  DailyQuestion(
    id: 'qb051',
    day: 83,
    number: 83,
    depth: QuestionDepth.inner,
    text: '우리가 대화할 때 좋은 점은 뭐라고 생각해요?',
    highlightedText: '대화의 좋은 점',
  ),
  DailyQuestion(
    id: 'qb052',
    day: 84,
    number: 84,
    depth: QuestionDepth.inner,
    text: '서로 다르다고 느낀 부분이 있었어요?',
    highlightedText: '다르다고 느낀 것',
  ),
  DailyQuestion(
    id: 'qb053',
    day: 85,
    number: 85,
    depth: QuestionDepth.inner,
    text: '그 다름이 오히려 재밌게 느껴진 적도 있어요?',
    highlightedText: '다름의 재미',
  ),
  DailyQuestion(
    id: 'qb054',
    day: 86,
    number: 86,
    depth: QuestionDepth.inner,
    text: '나한테 아직 못 물어본 게 있어요?',
    highlightedText: '못 물어본 질문',
  ),
  DailyQuestion(
    id: 'qb055',
    day: 87,
    number: 87,
    depth: QuestionDepth.inner,
    text: '요즘 나를 보면서 안심이 되는 부분이 있어요?',
    highlightedText: '안심되는 부분',
  ),
  DailyQuestion(
    id: 'qb056',
    day: 88,
    number: 88,
    depth: QuestionDepth.inner,
    text: '힘든 시기를 지날 때 옆 사람에게 바라는 건 뭐예요?',
    highlightedText: '힘들 때 바라는 것',
  ),
  DailyQuestion(
    id: 'qb057',
    day: 89,
    number: 89,
    depth: QuestionDepth.inner,
    text: '지금 우리 속도는 어떤 것 같아요?',
    highlightedText: '지금의 속도',
  ),
  DailyQuestion(
    id: 'qb058',
    day: 90,
    number: 90,
    depth: QuestionDepth.inner,
    text: '앞으로 우리가 계속 지켜갔으면 하는 게 있어요?',
    highlightedText: '지켜가고 싶은 것',
  ),
];

/// 지금까지 나온 질문과 앞으로 나올 질문을 모두 담은 조회용 목록.
///
/// 답변은 `{questionId}_{uid}` key로 저장되므로, 한 번이라도 나왔던 질문은
/// 계속 조회할 수 있어야 기록 화면에서 사라지지 않는다.
final allKnownQuestions = List<DailyQuestion>.unmodifiable([
  ...questionCatalogV1,
  ...questionCatalogV2,
]);

/// 오늘까지 나온 질문은 [questionCatalogV1] 원문 그대로 두고, 내일부터
/// [questionCatalogV2]가 이어지도록 순서를 만든다.
///
/// cutover를 상수로 박아두면 실제 `startedDateKey`가 다를 때 조용히 어긋난다.
/// 그래서 space의 시작일과 오늘 날짜에서 매번 계산한다.
List<DailyQuestion> buildActiveQuestionCatalog({
  required String startedDateKey,
  required String todayDateKey,
}) {
  final preservedCount = questionCatalogV1PreservedCount(
    startedDateKey: startedDateKey,
    todayDateKey: todayDateKey,
  );
  return List<DailyQuestion>.unmodifiable([
    ...questionCatalogV1.take(preservedCount),
    for (var index = 0; index < questionCatalogV2.length; index += 1)
      questionCatalogV2[index].withDay(preservedCount + index + 1),
  ]);
}

/// 오늘까지 쓰인 v1 질문 수. 최소 1개, 최대 v1 전체다.
int questionCatalogV1PreservedCount({
  required String startedDateKey,
  required String todayDateKey,
}) {
  final started = DateTime.tryParse(startedDateKey);
  final today = DateTime.tryParse(todayDateKey);
  if (started == null || today == null) {
    return questionCatalogV1.length;
  }
  final elapsedDays = today.difference(started).inDays + 1;
  return elapsedDays.clamp(1, questionCatalogV1.length);
}

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

const seedProfileCards = [
  ProfileCardData(
    profile: AppProfile(
      id: 'partner',
      nickname: '영우',
      avatar: '🪻',
      isMe: false,
    ),
    subtitle: '편한 만큼 채워지는 중',
    slots: [
      ProfileSlot(
        id: 'now_song',
        icon: 'music',
        label: '요즘 반복 재생',
        value: '요즘은 잔잔한 어쿠스틱만 계속 듣고 있어요.',
      ),
      ProfileSlot(
        id: 'now_craving',
        icon: 'food',
        label: '요즘 당기는 음식',
        value: '매콤한 분식이나 따뜻한 국물',
      ),
      ProfileSlot(id: 'now_favorite', icon: 'taste', label: '요즘 마음에 든 것'),
      ProfileSlot(id: 'day_rhythm', icon: 'time', label: '하루 중 좋은 시간'),
      ProfileSlot(id: 'recharge_way', icon: 'recharge', label: '충전되는 방식'),
      ProfileSlot(id: 'reply_pace', icon: 'reply', label: '편한 연락 속도'),
      ProfileSlot(id: 'words_i_like', icon: 'words', label: '들으면 기분 좋아지는 말'),
      ProfileSlot(id: 'meet_flow', icon: 'flow', label: '만날 때 좋은 흐름'),
      ProfileSlot(id: 'next_plan', icon: 'scene', label: '다음에 같이 하고 싶은 것'),
      ProfileSlot(id: 'care_wish', icon: 'care', label: '힘들 때 받고 싶은 것'),
    ],
  ),
  ProfileCardData(
    profile: AppProfile(id: 'me', nickname: '나', avatar: '🌿', isMe: true),
    subtitle: '편한 만큼 채워두는 내 서로 노트',
    slots: [
      ProfileSlot(
        id: 'now_song',
        icon: 'music',
        label: '요즘 반복 재생',
        value: '잔잔한 재즈를 자주 틀어둬요.',
      ),
      ProfileSlot(
        id: 'now_craving',
        icon: 'food',
        label: '요즘 당기는 음식',
        value: '파스타와 커피',
      ),
      ProfileSlot(id: 'now_favorite', icon: 'taste', label: '요즘 마음에 든 것'),
      ProfileSlot(id: 'day_rhythm', icon: 'time', label: '하루 중 좋은 시간'),
      ProfileSlot(id: 'recharge_way', icon: 'recharge', label: '충전되는 방식'),
      ProfileSlot(id: 'reply_pace', icon: 'reply', label: '편한 연락 속도'),
      ProfileSlot(id: 'words_i_like', icon: 'words', label: '들으면 기분 좋아지는 말'),
      ProfileSlot(id: 'meet_flow', icon: 'flow', label: '만날 때 좋은 흐름'),
      ProfileSlot(id: 'next_plan', icon: 'scene', label: '다음에 같이 하고 싶은 것'),
      ProfileSlot(id: 'care_wish', icon: 'care', label: '힘들 때 받고 싶은 것'),
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

const seedMemoryCards = [
  MemoryCard(
    id: 'memory_seed_1',
    type: MemoryCardType.likes,
    title: '조용한 카페 자리',
    body: '민영이는 창가 쪽보다 조금 안쪽에 앉는 걸 더 편하게 느낀다고 했어요.',
    createdByProfileId: 'me',
    subjectProfileId: 'partner',
    visibility: MemoryCardVisibility.shared,
    createdLabel: '오늘',
  ),
  MemoryCard(
    id: 'memory_seed_2',
    type: MemoryCardType.care,
    title: '너무 갑작스러운 약속은 조심',
    body: '일정이 가까울수록 선택지가 적으면 부담스러울 수 있어서 미리 후보를 몇 개만 정해두기.',
    createdByProfileId: 'me',
    subjectProfileId: 'partner',
    visibility: MemoryCardVisibility.shared,
    createdLabel: '오늘',
  ),
  MemoryCard(
    id: 'memory_seed_3',
    type: MemoryCardType.current,
    title: '요즘은 가벼운 산책',
    body: '길게 정해진 코스보다 걷다가 괜찮은 곳에 잠깐 들르는 쪽을 좋아한다고 했어요.',
    createdByProfileId: 'partner',
    subjectProfileId: 'me',
    visibility: MemoryCardVisibility.shared,
    createdLabel: '어제',
  ),
];

const seedMemoryCardResponses = [
  MemoryCardResponse(
    id: 'memory_seed_1_partner',
    cardId: 'memory_seed_1',
    responderProfileId: 'partner',
    reaction: MemoryCardReaction.agree,
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

const seedMusicNoteComments = [
  MusicNoteComment(
    id: 'music_comment_1',
    musicNoteId: 'music_1',
    body: '퇴근길에 듣기 좋겠다. 나도 저장해둘게요.',
    createdByProfileId: 'me',
    createdLabel: '오늘',
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
