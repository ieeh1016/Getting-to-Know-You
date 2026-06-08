import 'package:flutter/foundation.dart';

class DateOption {
  const DateOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.place,
    required this.timeLabel,
  });

  final String id;
  final String title;
  final String subtitle;
  final String place;
  final String timeLabel;
}

class DateIdea {
  const DateIdea({
    required this.id,
    required this.title,
    required this.description,
  });

  final String id;
  final String title;
  final String description;
}

class PreferencePrompt {
  const PreferencePrompt({
    required this.id,
    required this.title,
    required this.choices,
  });

  final String id;
  final String title;
  final List<String> choices;
}

class PickCoupon {
  const PickCoupon({
    required this.id,
    required this.title,
    required this.description,
  });

  final String id;
  final String title;
  final String description;
}

@immutable
class MinyoungPickState {
  const MinyoungPickState({
    this.selectedDateId,
    this.activeIdeaIndex = 0,
    this.selectedPreferences = const {},
    this.usedCouponIds = const {},
  });

  final String? selectedDateId;
  final int activeIdeaIndex;
  final Map<String, String> selectedPreferences;
  final Set<String> usedCouponIds;

  MinyoungPickState copyWith({
    String? selectedDateId,
    int? activeIdeaIndex,
    Map<String, String>? selectedPreferences,
    Set<String>? usedCouponIds,
  }) {
    return MinyoungPickState(
      selectedDateId: selectedDateId ?? this.selectedDateId,
      activeIdeaIndex: activeIdeaIndex ?? this.activeIdeaIndex,
      selectedPreferences: selectedPreferences ?? this.selectedPreferences,
      usedCouponIds: usedCouponIds ?? this.usedCouponIds,
    );
  }
}

class MinyoungPickController extends ChangeNotifier {
  MinyoungPickController({
    List<DateOption>? dateOptions,
    List<DateIdea>? ideas,
    List<PreferencePrompt>? preferencePrompts,
    List<PickCoupon>? coupons,
  }) : dateOptions = dateOptions ?? seedDateOptions,
       ideas = ideas ?? seedDateIdeas,
       preferencePrompts = preferencePrompts ?? seedPreferencePrompts,
       coupons = coupons ?? seedCoupons;

  final List<DateOption> dateOptions;
  final List<DateIdea> ideas;
  final List<PreferencePrompt> preferencePrompts;
  final List<PickCoupon> coupons;

  MinyoungPickState _state = const MinyoungPickState();

  MinyoungPickState get state => _state;

  DateIdea get activeIdea => ideas[_state.activeIdeaIndex];

  void selectDate(String dateId) {
    _assertKnownId(dateOptions.map((option) => option.id), dateId);
    _state = _state.copyWith(selectedDateId: dateId);
    notifyListeners();
  }

  void showNextIdea() {
    final nextIndex = (_state.activeIdeaIndex + 1) % ideas.length;
    _state = _state.copyWith(activeIdeaIndex: nextIndex);
    notifyListeners();
  }

  void selectPreference(String promptId, String choice) {
    final prompt = preferencePrompts.firstWhere(
      (item) => item.id == promptId,
      orElse: () => throw ArgumentError.value(promptId, 'promptId'),
    );
    if (!prompt.choices.contains(choice)) {
      throw ArgumentError.value(choice, 'choice');
    }

    final nextPreferences = Map<String, String>.from(_state.selectedPreferences)
      ..[promptId] = choice;
    _state = _state.copyWith(selectedPreferences: nextPreferences);
    notifyListeners();
  }

  void toggleCoupon(String couponId) {
    _assertKnownId(coupons.map((coupon) => coupon.id), couponId);
    final nextUsedCouponIds = Set<String>.from(_state.usedCouponIds);
    if (nextUsedCouponIds.contains(couponId)) {
      nextUsedCouponIds.remove(couponId);
    } else {
      nextUsedCouponIds.add(couponId);
    }
    _state = _state.copyWith(usedCouponIds: nextUsedCouponIds);
    notifyListeners();
  }

  void _assertKnownId(Iterable<String> knownIds, String id) {
    if (!knownIds.contains(id)) {
      throw ArgumentError.value(id, 'id');
    }
  }
}

const seedDateOptions = [
  DateOption(
    id: 'seongsu_cafe',
    title: '성수 카페',
    subtitle: '조용한 테이블, 달달한 디저트',
    place: '성수',
    timeLabel: '토요일 오후',
  ),
  DateOption(
    id: 'hanriver_walk',
    title: '한강 산책',
    subtitle: '걷다가 커피 한 잔',
    place: '여의도',
    timeLabel: '해질 무렵',
  ),
  DateOption(
    id: 'small_gallery',
    title: '작은 전시',
    subtitle: '보고 나와서 저녁 먹기',
    place: '북촌',
    timeLabel: '주말 낮',
  ),
];

const seedDateIdeas = [
  DateIdea(
    id: 'dessert_first',
    title: '디저트 먼저 먹기',
    description: '케이크를 고르고 다음 코스는 천천히 정하기',
  ),
  DateIdea(
    id: 'slow_walk',
    title: '가볍게 산책',
    description: '붐비지 않는 길에서 커피 들고 걷기',
  ),
  DateIdea(
    id: 'quiet_movie',
    title: '조용한 영화',
    description: '끝나고 좋았던 장면 하나씩 말하기',
  ),
];

const seedPreferencePrompts = [
  PreferencePrompt(id: 'food', title: '음식', choices: ['한식', '파스타', '디저트']),
  PreferencePrompt(
    id: 'cafe',
    title: '카페',
    choices: ['조용한 곳', '뷰 좋은 곳', '디저트 맛집'],
  ),
  PreferencePrompt(id: 'time', title: '시간', choices: ['점심', '오후', '저녁']),
];

const seedCoupons = [
  PickCoupon(id: 'coffee', title: '커피 한 잔권', description: '오늘 커피는 제가 살게요'),
  PickCoupon(id: 'menu', title: '메뉴 선택권', description: '오늘 메뉴는 민영 픽'),
  PickCoupon(id: 'waiting', title: '웨이팅 대신 서 있기권', description: '줄은 제가 맡겠습니다'),
];
