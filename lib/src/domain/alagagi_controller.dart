import 'dart:async';

import 'package:flutter/foundation.dart';

enum AlagagiRoute {
  invite,
  home,
  answer,
  archive,
  records,
  balance,
  profileCard,
  wishlist,
  my,
}

enum ArchiveFilter { all, bothAnswered, similar }

enum ProfileCardTab { partner, me }

enum WishlistFilter { all, mutual, places, activities }

enum WishKind { place, activity }

enum QuestionDepth { light, daily, beliefs, inner }

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
  });

  final String spaceId;
  final AppProfile me;
  final AppProfile partner;
}

abstract class AlagagiDataRepository {
  Future<AlagagiSession?> loadSession(AlagagiAuthUser user);

  Future<void> saveAnswer(String spaceId, Answer answer);

  Future<void> saveProfileSlot(
    String spaceId,
    String profileId,
    ProfileSlot slot,
  );

  Future<void> saveWish(String spaceId, WishItem wish);
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

  AppProfile copyWith({String? nickname}) {
    return AppProfile(
      id: id,
      nickname: nickname ?? this.nickname,
      avatar: avatar,
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
  });

  final String questionId;
  final String profileId;
  final String body;
  final String createdLabel;
  final bool skipped;

  Answer copyWith({
    String? questionId,
    String? profileId,
    String? body,
    String? createdLabel,
    bool? skipped,
  }) {
    return Answer(
      questionId: questionId ?? this.questionId,
      profileId: profileId ?? this.profileId,
      body: body ?? this.body,
      createdLabel: createdLabel ?? this.createdLabel,
      skipped: skipped ?? this.skipped,
    );
  }
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
    required this.partnerChoiceId,
  });

  final String id;
  final String prompt;
  final BalanceOption left;
  final BalanceOption right;
  final String partnerChoiceId;
}

class ProfileSlot {
  const ProfileSlot({
    required this.id,
    required this.label,
    required this.icon,
    this.value,
    this.locked = false,
    this.unlockHint,
  });

  final String id;
  final String label;
  final String icon;
  final String? value;
  final bool locked;
  final String? unlockHint;

  ProfileSlot copyWith({String? value, bool? locked, String? unlockHint}) {
    return ProfileSlot(
      id: id,
      label: label,
      icon: icon,
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

  int get filledCount =>
      slots.where((slot) => slot.value != null && !slot.locked).length;

  int get totalCount => slots.length;

  ProfileCardData copyWith({List<ProfileSlot>? slots, AppProfile? profile}) {
    return ProfileCardData(
      profile: profile ?? this.profile,
      subtitle: subtitle,
      slots: slots ?? this.slots,
    );
  }
}

class WishItem {
  const WishItem({
    required this.id,
    required this.icon,
    required this.title,
    required this.kind,
    required this.likedByProfileIds,
    this.done = false,
  });

  final String id;
  final String icon;
  final String title;
  final WishKind kind;
  final Set<String> likedByProfileIds;
  final bool done;

  bool get isMutual => likedByProfileIds.length >= 2;

  WishItem copyWith({Set<String>? likedByProfileIds, bool? done}) {
    return WishItem(
      id: id,
      icon: icon,
      title: title,
      kind: kind,
      likedByProfileIds: likedByProfileIds ?? this.likedByProfileIds,
      done: done ?? this.done,
    );
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
    this.draftAnswer = '',
    this.inviteError,
    this.answerError,
    this.skippedToday = false,
  });

  final AppProfile me;
  final AppProfile partner;
  final AlagagiRoute route;
  final ArchiveFilter archiveFilter;
  final ProfileCardTab profileCardTab;
  final WishlistFilter wishlistFilter;
  final int activeBalanceIndex;
  final String draftAnswer;
  final String? inviteError;
  final String? answerError;
  final bool skippedToday;

  AlagagiState copyWith({
    AppProfile? me,
    AppProfile? partner,
    AlagagiRoute? route,
    ArchiveFilter? archiveFilter,
    ProfileCardTab? profileCardTab,
    WishlistFilter? wishlistFilter,
    int? activeBalanceIndex,
    String? draftAnswer,
    String? inviteError,
    bool clearInviteError = false,
    String? answerError,
    bool clearAnswerError = false,
    bool? skippedToday,
  }) {
    return AlagagiState(
      me: me ?? this.me,
      partner: partner ?? this.partner,
      route: route ?? this.route,
      archiveFilter: archiveFilter ?? this.archiveFilter,
      profileCardTab: profileCardTab ?? this.profileCardTab,
      wishlistFilter: wishlistFilter ?? this.wishlistFilter,
      activeBalanceIndex: activeBalanceIndex ?? this.activeBalanceIndex,
      draftAnswer: draftAnswer ?? this.draftAnswer,
      inviteError: clearInviteError ? null : inviteError ?? this.inviteError,
      answerError: clearAnswerError ? null : answerError ?? this.answerError,
      skippedToday: skippedToday ?? this.skippedToday,
    );
  }
}

class AlagagiController extends ChangeNotifier {
  AlagagiController({AlagagiDataRepository? repository})
    : _repository = repository,
      _spaceId = null,
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
  }) : _repository = repository,
       _spaceId = session.spaceId,
       _state = AlagagiState(
         me: session.me,
         partner: session.partner,
         route: AlagagiRoute.home,
       ) {
    _applyProfilesToSeedData();
  }

  AlagagiState _state;
  final AlagagiDataRepository? _repository;
  final String? _spaceId;

  final DailyQuestion todayQuestion = seedQuestions.first;
  final List<DailyQuestion> questions = seedQuestions;
  final RelationshipInsight insight = seedInsight;
  final List<BalanceQuestion> balanceQuestions = seedBalanceQuestions;

  final Map<String, Answer> _myAnswersByQuestionId = {
    for (final answer in seedMyAnswers) answer.questionId: answer,
  };
  final Map<String, Answer> _partnerAnswersByQuestionId = {
    for (final answer in seedPartnerAnswers) answer.questionId: answer,
  };
  final Map<String, String> _balanceSelections = {};
  final List<ProfileCardData> _profileCards = List<ProfileCardData>.from(
    seedProfileCards,
  );
  final List<WishItem> _wishes = List<WishItem>.from(seedWishes);

  AlagagiState get state => _state;

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
          );
        }),
      );
    _wishes
      ..clear()
      ..addAll(
        seedWishes.map((wish) {
          return wish.copyWith(
            likedByProfileIds: _mapSeedProfileIds(wish.likedByProfileIds),
          );
        }),
      );
  }

  Set<String> _mapSeedProfileIds(Set<String> profileIds) {
    return profileIds.map((profileId) {
      return switch (profileId) {
        'me' => _state.me.id,
        'partner' => _state.partner.id,
        _ => profileId,
      };
    }).toSet();
  }

  void _persistAnswer(Answer answer) {
    final repository = _repository;
    final spaceId = _spaceId;
    if (repository == null || spaceId == null) {
      return;
    }
    unawaited(repository.saveAnswer(spaceId, answer).catchError((_) {}));
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

  Answer? get todayMyAnswer => _myAnswersByQuestionId[todayQuestion.id];

  Answer? get todayPartnerAnswer => todayMyAnswer == null
      ? null
      : _partnerAnswersByQuestionId[todayQuestion.id];

  BalanceQuestion get activeBalanceQuestion =>
      balanceQuestions[_state.activeBalanceIndex];

  String? get activeBalanceSelection =>
      _balanceSelections[activeBalanceQuestion.id];

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

  List<ArchiveItem> get archiveItems {
    final items = questions.map((question) {
      return ArchiveItem(
        question: question,
        myAnswer: _myAnswersByQuestionId[question.id],
        partnerAnswer: _myAnswersByQuestionId[question.id] == null
            ? null
            : _partnerAnswersByQuestionId[question.id],
        matchedKeywords:
            seedMatchedKeywordsByQuestionId[question.id] ?? const [],
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
    _state = _state.copyWith(route: route, clearAnswerError: true);
    notifyListeners();
  }

  void updateDraftAnswer(String value) {
    _state = _state.copyWith(draftAnswer: value, clearAnswerError: true);
    notifyListeners();
  }

  void submitTodayAnswer() {
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

    final answer = Answer(
      questionId: todayQuestion.id,
      profileId: _state.me.id,
      body: body,
      createdLabel: '오늘',
    );
    _myAnswersByQuestionId[todayQuestion.id] = answer;
    _persistAnswer(answer);
    _state = _state.copyWith(
      draftAnswer: '',
      route: AlagagiRoute.home,
      skippedToday: false,
      clearAnswerError: true,
    );
    notifyListeners();
  }

  void skipToday() {
    final answer = Answer(
      questionId: todayQuestion.id,
      profileId: _state.me.id,
      body: '',
      createdLabel: '오늘',
      skipped: true,
    );
    _myAnswersByQuestionId[todayQuestion.id] = answer;
    _persistAnswer(answer);
    _state = _state.copyWith(
      route: AlagagiRoute.home,
      skippedToday: true,
      draftAnswer: '',
      clearAnswerError: true,
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
    _balanceSelections[question.id] = optionId;
    notifyListeners();
  }

  void nextBalanceQuestion() {
    final nextIndex = (_state.activeBalanceIndex + 1) % balanceQuestions.length;
    _state = _state.copyWith(activeBalanceIndex: nextIndex);
    notifyListeners();
  }

  void setProfileCardTab(ProfileCardTab tab) {
    _state = _state.copyWith(profileCardTab: tab);
    notifyListeners();
  }

  void fillTodayProfileSlot(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return;
    }

    final cardIndex = _profileCards.indexWhere((card) => card.profile.isMe);
    final card = _profileCards[cardIndex];
    ProfileSlot? filledSlot;
    final slots = card.slots.map((slot) {
      if (slot.id == 'motto') {
        filledSlot = slot.copyWith(
          value: trimmed,
          locked: false,
          unlockHint: '',
        );
        return filledSlot!;
      }
      return slot;
    }).toList();
    _profileCards[cardIndex] = card.copyWith(slots: slots);
    if (filledSlot != null) {
      _persistProfileSlot(filledSlot!);
    }
    _state = _state.copyWith(profileCardTab: ProfileCardTab.me);
    notifyListeners();
  }

  void setWishlistFilter(WishlistFilter filter) {
    _state = _state.copyWith(wishlistFilter: filter);
    notifyListeners();
  }

  void toggleWishLike(String wishId) {
    final index = _wishes.indexWhere((wish) => wish.id == wishId);
    if (index == -1) {
      throw ArgumentError.value(wishId, 'wishId');
    }
    final wish = _wishes[index];
    final likedBy = Set<String>.from(wish.likedByProfileIds);
    if (likedBy.contains(_state.me.id)) {
      likedBy.remove(_state.me.id);
    } else {
      likedBy.add(_state.me.id);
    }
    final updatedWish = wish.copyWith(likedByProfileIds: likedBy);
    _wishes[index] = updatedWish;
    _persistWish(updatedWish);
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
    TimelineEvent(dateLabel: '5월 28일', description: '우리, 알아가기를 시작했어요'),
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
      ProfileSlot(id: 'age', icon: '🎂', label: '나이대', value: '20대 후반'),
      ProfileSlot(
        id: 'mbti',
        icon: '🧭',
        label: 'MBTI',
        value: 'INFJ · 나랑 한 글자 차이',
      ),
      ProfileSlot(
        id: 'food',
        icon: '🍙',
        label: '좋아하는 음식',
        value: '떡볶이, 그리고 떡볶이',
      ),
      ProfileSlot(id: 'song', icon: '🎧', label: '요즘 노래', value: '어쿠스틱 발라드'),
      ProfileSlot(id: 'type', icon: '🐾', label: '동물상', value: '고양이상이래요'),
      ProfileSlot(
        id: 'motto',
        icon: '💭',
        label: '좌우명',
        locked: true,
        unlockHint: '내일 열려요',
      ),
      ProfileSlot(
        id: 'sleep',
        icon: '🌙',
        label: '잠드는 시간',
        locked: true,
        unlockHint: '아직 비밀',
      ),
    ],
  ),
  ProfileCardData(
    profile: AppProfile(id: 'me', nickname: '나', avatar: '🌿', isMe: true),
    subtitle: '천천히 채우는 중 · 12일째',
    slots: [
      ProfileSlot(id: 'age', icon: '🎂', label: '나이대', value: '30대 초반'),
      ProfileSlot(id: 'mbti', icon: '🧭', label: 'MBTI', value: 'INTJ'),
      ProfileSlot(id: 'food', icon: '🍙', label: '좋아하는 음식', value: '파스타와 커피'),
      ProfileSlot(id: 'song', icon: '🎧', label: '요즘 노래', value: '잔잔한 재즈'),
      ProfileSlot(id: 'type', icon: '🐾', label: '동물상', value: '차분한 강아지상'),
      ProfileSlot(
        id: 'motto',
        icon: '💭',
        label: '좌우명',
        locked: true,
        unlockHint: '오늘 채울 칸',
      ),
      ProfileSlot(
        id: 'sleep',
        icon: '🌙',
        label: '잠드는 시간',
        locked: true,
        unlockHint: '아직 비밀',
      ),
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
