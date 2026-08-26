import 'package:flutter_test/flutter_test.dart';
import 'package:minyoung_pick/src/domain/alagagi_controller.dart';

void main() {
  group('AlagagiController', () {
    test('starts on invite with Youngwoo as the inviter side', () {
      final controller = AlagagiController();

      expect(controller.state.route, AlagagiRoute.invite);
      expect(controller.state.partner.nickname, '영우');
      expect(controller.todayQuestion.text, contains('좋아하는 시간'));
    });

    test('enters the home screen with a nickname', () {
      final controller = AlagagiController();

      controller.enterSpace('영우');

      expect(controller.state.route, AlagagiRoute.home);
      expect(controller.state.me.nickname, '영우');
      expect(controller.state.inviteError, isNull);
    });

    test('keeps invite screen and reports a gentle error without nickname', () {
      final controller = AlagagiController();

      controller.enterSpace('   ');

      expect(controller.state.route, AlagagiRoute.invite);
      expect(controller.state.inviteError, contains('이름'));
    });

    test('submits today answer and unlocks partner answer', () {
      final controller = AlagagiController()..enterSpace('영우');

      controller.updateDraftAnswer('저는 노을 질 때가 제일 좋아요.');
      controller.submitTodayAnswer();

      expect(controller.state.route, AlagagiRoute.home);
      expect(controller.todayMyAnswer?.body, '저는 노을 질 때가 제일 좋아요.');
      expect(controller.todayPartnerAnswer?.body, contains('조용해지는 시간'));
    });

    test('edits today answer with existing body preloaded', () {
      final controller = AlagagiController()..enterSpace('영우');

      controller.updateDraftAnswer('처음 답변이에요.');
      controller.submitTodayAnswer();
      controller.editTodayAnswer();

      expect(controller.state.route, AlagagiRoute.answer);
      expect(controller.state.editingAnswer, isTrue);
      expect(controller.state.draftAnswer, '처음 답변이에요.');

      controller.updateDraftAnswer('수정한 답변이에요.');
      controller.submitTodayAnswer();

      expect(controller.state.route, AlagagiRoute.home);
      expect(controller.state.editingAnswer, isFalse);
      expect(controller.todayMyAnswer?.body, '수정한 답변이에요.');
      expect(controller.todayPartnerAnswer?.body, contains('조용해지는 시간'));
    });

    test('answers again after skipping today', () {
      final controller = AlagagiController()..enterSpace('영우');

      controller.skipToday();
      expect(controller.todayMyAnswer?.skipped, isTrue);

      controller.answerTodayAfterSkip();
      controller.updateDraftAnswer('다시 남기는 답이에요.');
      controller.submitTodayAnswer();

      expect(controller.todayMyAnswer?.skipped, isFalse);
      expect(controller.todayMyAnswer?.body, '다시 남기는 답이에요.');
    });

    test('toggles long answer expansion by answer key', () {
      final controller = AlagagiController()..enterSpace('영우');
      const questionId = 'q12';
      const profileId = 'me';

      expect(controller.isAnswerExpanded(questionId, profileId), isFalse);

      controller.toggleAnswerExpanded(questionId, profileId);
      expect(controller.isAnswerExpanded(questionId, profileId), isTrue);

      controller.toggleAnswerExpanded(questionId, profileId);
      expect(controller.isAnswerExpanded(questionId, profileId), isFalse);
    });

    test('filters archive by both answered and similar answers', () {
      final controller = AlagagiController();

      controller.setArchiveFilter(ArchiveFilter.bothAnswered);
      expect(
        controller.archiveItems.every((item) => item.bothAnswered),
        isTrue,
      );

      controller.setArchiveFilter(ArchiveFilter.similar);
      expect(controller.archiveItems.every((item) => item.similar), isTrue);
    });

    test('fills my first empty profile card slot', () {
      final controller = AlagagiController();

      controller.fillTodayProfileSlot('천천히, 하지만 꾸준히');

      expect(controller.state.profileCardTab, ProfileCardTab.me);
      expect(
        controller.activeProfileCard.slots
            .firstWhere((slot) => slot.id == 'now_favorite')
            .value,
        '천천히, 하지만 꾸준히',
      );
    });

    test('profile card catalog provides expanded category packs', () {
      final controller = AlagagiController()
        ..enterSpace('영우')
        ..setProfileCardTab(ProfileCardTab.me);

      final slots = controller.activeProfileCard.slots;

      expect(slots.length, greaterThanOrEqualTo(20));
      expect(
        slots.map((slot) => slot.category).toSet(),
        containsAll(['취향', '하루', '대화', '함께']),
      );
      expect(
        slots.map((slot) => slot.label),
        containsAll(['요즘 반복 재생', '편한 연락 속도', '다음에 같이 하고 싶은 것']),
      );
      expect(slots.every((slot) => slot.inputHint.isNotEmpty), isTrue);
    });

    test('wishlist mutual filter reacts to liking partner wish', () {
      final controller = AlagagiController();

      controller.toggleWishLike('movie');
      controller.setWishlistFilter(WishlistFilter.mutual);

      expect(
        controller.visibleWishes.map((wish) => wish.id),
        contains('movie'),
      );
    });

    test('meeting draft stores detailed schedule and shared note', () {
      final controller = AlagagiController()..enterSpace('영우');

      controller.selectMeetingDate('2026-06-24');
      controller.setMeetingAvailability(MeetingAvailability.available);
      controller.toggleMeetingTimeSlot(MeetingTimeSlot.morning);
      controller.updateMeetingDraft(sharedMemo: '오후나 저녁은 괜찮아요.');
      controller.updateMeetingTimeBlockDraft(
        start: '14:00',
        end: '16:30',
        title: '병원 예약',
      );
      controller.addMeetingTimeBlock();
      controller.submitMeetingDraft();

      final entry = controller.scheduleEntryFor(
        controller.state.me.id,
        '2026-06-24',
      );

      expect(entry, isNotNull);
      expect(entry!.sharedMemo, '오후나 저녁은 괜찮아요.');
      expect(entry.timeSlots, contains(MeetingTimeSlot.evening));
      expect(entry.timeBlocks.single.timeLabel, '14:00-16:30');
      expect(entry.timeBlocks.single.title, '병원 예약');
    });

    test('meeting day draft stores flexible time and note', () {
      final controller = AlagagiController()..enterSpace('영우');

      controller.selectMeetingDate('2026-06-11');
      controller.updateMeetingDayDraft(
        timeLabel: '저녁 7시쯤',
        note: '장소는 성수 쪽으로 천천히 보기',
      );
      controller.submitMeetingDayDraft();

      final entry = controller.scheduleEntryFor(
        controller.state.me.id,
        '2026-06-11',
      );

      expect(entry, isNotNull);
      expect(entry!.isMeetingDay, isTrue);
      expect(entry.meetingTimeLabel, '저녁 7시쯤');
      expect(entry.meetingNote, '장소는 성수 쪽으로 천천히 보기');
      expect(entry.meetingPlanItems, isEmpty);
      expect(controller.meetingDayEntryFor('2026-06-11'), entry);
    });

    test('meeting day can be cancelled and reactivated', () {
      final controller = AlagagiController()..enterSpace('영우');

      controller.selectMeetingDate('2026-06-11');
      controller.updateMeetingDayDraft(timeLabel: '저녁 7시쯤');
      controller.submitMeetingDayDraft();
      controller.goTo(AlagagiRoute.meetingPlans);
      controller.updateMeetingPlanItemDraft('전시 보기');
      controller.addMeetingPlanDraftItem();
      controller.submitMeetingPlanDraft();

      controller.cancelMeetingDay('2026-06-11');

      expect(controller.meetingDayEntryFor('2026-06-11'), isNull);
      expect(controller.meetingDayDateKeys, isEmpty);
      expect(controller.meetingPlanFor('2026-06-11')?.isCancelled, isTrue);
      expect(controller.meetingPlanItemsFor('2026-06-11'), ['전시 보기']);
      expect(controller.state.meetingSaveFeedback, '만남을 취소했어요.');

      controller.goTo(AlagagiRoute.meetings);
      controller.selectMeetingDate('2026-06-11');
      expect(controller.state.meetingDraftIsMeetingDay, isFalse);

      controller.submitMeetingDayDraft();

      expect(controller.meetingDayEntryFor('2026-06-11'), isNotNull);
      expect(controller.meetingPlanFor('2026-06-11')?.isCancelled, isFalse);
      expect(controller.meetingPlanItemsFor('2026-06-11'), ['전시 보기']);
    });

    test('meeting plan draft stores line-separated things to do', () {
      final controller = AlagagiController()..enterSpace('영우');

      controller.selectMeetingDate('2026-06-11');
      controller.updateMeetingDayDraft(timeLabel: '저녁 7시쯤');
      controller.submitMeetingDayDraft();
      controller.goTo(AlagagiRoute.meetingPlans);
      controller.updateMeetingPlanItemDraft('전시 보기');
      controller.addMeetingPlanDraftItem();
      controller.updateMeetingPlanItemDraft('삭제할 임시 계획');
      controller.addMeetingPlanDraftItem();
      controller.removeMeetingPlanDraftItem(1);
      controller.updateMeetingPlanItemDraft('근처 카페');
      controller.addMeetingPlanDraftItem();
      controller.updateMeetingPlanItemDraft('저녁 먹기');
      controller.addMeetingPlanDraftItem();
      controller.startEditingMeetingPlanDraftItem(1);
      expect(controller.state.meetingPlanItemDraft, '근처 카페');
      controller.updateMeetingPlanItemDraft('브런치 카페');
      controller.addMeetingPlanDraftItem();
      expect(controller.state.editingMeetingPlanItemIndex, isNull);
      expect(controller.meetingPlanDraftItems, ['전시 보기', '브런치 카페', '저녁 먹기']);
      controller.reorderMeetingPlanDraftItem(2, 0);
      expect(controller.meetingPlanDraftItems, ['저녁 먹기', '전시 보기', '브런치 카페']);
      controller.submitMeetingPlanDraft();

      final plan = controller.meetingPlanFor('2026-06-11');

      expect(controller.state.route, AlagagiRoute.meetingPlans);
      expect(controller.selectedMeetingPlanDateKey, '2026-06-11');
      expect(plan, isNotNull);
      expect(plan!.items, ['저녁 먹기', '전시 보기', '브런치 카페']);
      expect(controller.state.meetingSaveFeedback, '계획을 저장했어요.');
    });

    test('meeting plan reorder keeps the edited item selected', () {
      final controller = AlagagiController()..enterSpace('영우');

      controller.selectMeetingDate('2026-06-11');
      controller.updateMeetingDayDraft(timeLabel: '저녁 7시쯤');
      controller.submitMeetingDayDraft();
      controller.goTo(AlagagiRoute.meetingPlans);
      for (final item in ['전시 보기', '브런치 카페', '저녁 먹기']) {
        controller.updateMeetingPlanItemDraft(item);
        controller.addMeetingPlanDraftItem();
      }

      controller.startEditingMeetingPlanDraftItem(1);
      controller.reorderMeetingPlanDraftItem(0, 3);

      expect(controller.meetingPlanDraftItems, ['브런치 카페', '저녁 먹기', '전시 보기']);
      expect(controller.state.editingMeetingPlanItemIndex, 0);
      expect(controller.state.meetingPlanItemDraft, '브런치 카페');
    });

    test('auto save does not cancel the row being edited', () {
      final controller = AlagagiController()..enterSpace('영우');

      controller.selectMeetingDate('2026-06-11');
      controller.updateMeetingDayDraft(timeLabel: '저녁 7시쯤');
      controller.submitMeetingDayDraft();
      controller.goTo(AlagagiRoute.meetingPlans);
      for (final item in ['전시 보기', '브런치 카페']) {
        controller.updateMeetingPlanItemDraft(item);
        controller.addMeetingPlanDraftItem();
      }

      controller.startEditingMeetingPlanDraftItem(1);
      controller.updateMeetingPlanItemDraft('브런치 카페에서 아침');

      // 다른 줄을 지워 자동 저장이 돌아도 고치던 줄은 그대로 남아야 한다.
      controller.removeMeetingPlanDraftItem(0);

      expect(controller.state.editingMeetingPlanItemIndex, 0);
      expect(controller.state.meetingPlanItemDraft, '브런치 카페에서 아침');
    });

    test('meeting plan draft can store more than eight items', () {
      final controller = AlagagiController()..enterSpace('영우');

      controller.selectMeetingDate('2026-06-11');
      controller.updateMeetingDayDraft(timeLabel: '저녁 7시쯤');
      controller.submitMeetingDayDraft();
      controller.goTo(AlagagiRoute.meetingPlans);

      final items = List<String>.generate(10, (index) => '계획 ${index + 1}');
      for (final item in items) {
        controller.updateMeetingPlanItemDraft(item);
        controller.addMeetingPlanDraftItem();
      }
      controller.submitMeetingPlanDraft();

      final plan = controller.meetingPlanFor('2026-06-11');

      expect(plan, isNotNull);
      expect(plan!.items, items);
      expect(controller.state.meetingDraftError, isNull);
    });

    test('meeting days split upcoming and past dates', () {
      final controller = AlagagiController.forSession(
        const AlagagiSession(
          spaceId: 'main',
          me: AppProfile(
            id: 'youngwooUid',
            nickname: '영우',
            avatar: '🌿',
            isMe: true,
          ),
          partner: AppProfile(
            id: 'minyoungUid',
            nickname: '민영',
            avatar: '🪻',
            isMe: false,
          ),
          data: AlagagiSpaceData(
            scheduleEntries: [
              ScheduleEntry(
                dateKey: '2000-06-11',
                profileId: 'youngwooUid',
                availability: MeetingAvailability.available,
                timeSlots: {MeetingTimeSlot.evening},
                isMeetingDay: true,
              ),
              ScheduleEntry(
                dateKey: '2099-06-11',
                profileId: 'youngwooUid',
                availability: MeetingAvailability.available,
                timeSlots: {MeetingTimeSlot.evening},
                isMeetingDay: true,
              ),
            ],
          ),
        ),
      )..goTo(AlagagiRoute.meetingPlans);

      expect(controller.upcomingMeetingDayEntries.single.dateKey, '2099-06-11');
      expect(controller.pastMeetingDayEntries.single.dateKey, '2000-06-11');
      expect(controller.nextMeetingDayEntry?.dateKey, '2099-06-11');
      expect(controller.selectedMeetingPlanDateKey, '2099-06-11');
    });

    test(
      'meeting plan reads legacy personal schedule items as one shared list',
      () {
        final controller = AlagagiController.forSession(
          AlagagiSession(
            spaceId: 'main',
            me: const AppProfile(
              id: 'youngwooUid',
              nickname: '영우',
              avatar: '🌿',
              isMe: true,
            ),
            partner: const AppProfile(
              id: 'minyoungUid',
              nickname: '민영',
              avatar: '🪻',
              isMe: false,
            ),
            data: AlagagiSpaceData(
              scheduleEntries: [
                ScheduleEntry(
                  dateKey: '2099-06-11',
                  profileId: 'youngwooUid',
                  availability: MeetingAvailability.available,
                  timeSlots: const {MeetingTimeSlot.evening},
                  isMeetingDay: true,
                  meetingPlanItems: const ['전시 보기'],
                  updatedAt: DateTime.parse('2026-06-09T10:00:00.000Z'),
                ),
                ScheduleEntry(
                  dateKey: '2099-06-11',
                  profileId: 'minyoungUid',
                  availability: MeetingAvailability.available,
                  timeSlots: const {MeetingTimeSlot.evening},
                  isMeetingDay: true,
                  meetingPlanItems: const ['전시 보기', '근처 카페'],
                  updatedAt: DateTime.parse('2026-06-09T11:00:00.000Z'),
                ),
              ],
            ),
          ),
        )..goTo(AlagagiRoute.meetingPlans);

        expect(controller.meetingPlanItemsFor('2099-06-11'), [
          '전시 보기',
          '근처 카페',
        ]);
        expect(controller.meetingPlanDraftItems, ['전시 보기', '근처 카페']);
      },
    );

    test('place board saves a place and toggles interest', () {
      final controller = AlagagiController()..enterSpace('영우');

      controller.startPlaceDraft();
      controller.applyKakaoPlaceResult(
        providerPlaceId: 'kakao-cafe-1',
        name: '조용한 카페',
        address: '서울 성동구',
        latitude: 37.5446,
        longitude: 127.0557,
        category: PlaceCategory.cafe,
      );
      controller.updatePlaceDraft(note: '저녁에 이야기하기 좋아 보여요.');
      controller.submitPlaceDraft();

      final place = controller.sharedPlaces.first;
      expect(place.name, '조용한 카페');
      expect(place.provider, MapApiProvider.kakao);
      expect(place.providerPlaceId, 'kakao-cafe-1');
      expect(place.latitude, 37.5446);
      expect(place.longitude, 127.0557);
      expect(place.interestedByProfileIds, contains(controller.state.me.id));

      controller.togglePlaceInterest(place.id);
      expect(
        controller.sharedPlaces.first.interestedByProfileIds,
        isNot(contains(controller.state.me.id)),
      );

      controller.togglePlaceInterest(place.id);
      expect(
        controller.sharedPlaces.first.interestedByProfileIds,
        contains(controller.state.me.id),
      );
    });

    test(
      'place board updates duplicate kakao place instead of adding another',
      () {
        final controller = AlagagiController()..enterSpace('영우');

        controller.startPlaceDraft();
        controller.applyKakaoPlaceResult(
          providerPlaceId: 'kakao-cafe-1',
          name: '조용한 카페',
          address: '서울 성동구',
          latitude: 37.5446,
          longitude: 127.0557,
          category: PlaceCategory.cafe,
        );
        controller.updatePlaceDraft(note: '첫 메모');
        controller.submitPlaceDraft();

        controller.startPlaceDraft();
        controller.applyKakaoPlaceResult(
          providerPlaceId: 'kakao-cafe-1',
          name: '조용한 카페',
          address: '서울 성동구',
          latitude: 37.5446,
          longitude: 127.0557,
          category: PlaceCategory.food,
        );
        controller.updatePlaceDraft(note: '업데이트한 메모');
        controller.submitPlaceDraft();

        final matchingPlaces = controller.sharedPlaces
            .where((place) => place.providerPlaceId == 'kakao-cafe-1')
            .toList();
        expect(matchingPlaces, hasLength(1));
        expect(matchingPlaces.single.category, PlaceCategory.food);
        expect(matchingPlaces.single.note, '업데이트한 메모');
      },
    );

    test('place board links and unlinks selected meeting date', () {
      final controller = AlagagiController()..enterSpace('영우');

      controller.startPlaceDraft();
      controller.applyKakaoPlaceResult(
        providerPlaceId: 'kakao-cafe-1',
        name: '조용한 카페',
        address: '서울 성동구',
        latitude: 37.5446,
        longitude: 127.0557,
        category: PlaceCategory.cafe,
      );
      controller.submitPlaceDraft();

      final placeId = controller.sharedPlaces
          .firstWhere((place) => place.providerPlaceId == 'kakao-cafe-1')
          .id;
      controller.selectMeetingDate('2026-06-24');
      controller.linkPlaceToSelectedMeeting(placeId);
      expect(
        controller.sharedPlaces
            .firstWhere((place) => place.id == placeId)
            .linkedDateKey,
        '2026-06-24',
      );
      expect(
        controller.sharedPlaces
            .firstWhere((place) => place.id == placeId)
            .meetingPlanLinkFor('2026-06-24')
            ?.order,
        0,
      );

      controller.linkPlaceToSelectedMeeting(placeId);
      expect(
        controller.sharedPlaces
            .firstWhere((place) => place.id == placeId)
            .linkedDateKey,
        isNull,
      );
      expect(
        controller.sharedPlaces
            .firstWhere((place) => place.id == placeId)
            .meetingPlanLinkFor('2026-06-24'),
        isNull,
      );
    });

    test('meeting plan places store reservation time and custom order', () {
      final controller = AlagagiController.forSession(
        const AlagagiSession(
          spaceId: 'main',
          me: AppProfile(
            id: 'youngwooUid',
            nickname: '영우',
            avatar: '🌿',
            isMe: true,
          ),
          partner: AppProfile(
            id: 'minyoungUid',
            nickname: '민영',
            avatar: '🪻',
            isMe: false,
          ),
        ),
      );

      final placeSeeds = [
        (
          providerPlaceId: 'kakao-cafe-1',
          name: '조용한 카페',
          category: PlaceCategory.cafe,
        ),
        (
          providerPlaceId: 'kakao-food-1',
          name: '작은 식당',
          category: PlaceCategory.food,
        ),
        (
          providerPlaceId: 'kakao-gallery-1',
          name: '작은 전시 공간',
          category: PlaceCategory.exhibition,
        ),
      ];
      for (final seed in placeSeeds) {
        controller.startPlaceDraft();
        controller.applyKakaoPlaceResult(
          providerPlaceId: seed.providerPlaceId,
          name: seed.name,
          address: '서울 성동구',
          latitude: 37.5446,
          longitude: 127.0557,
          category: seed.category,
        );
        controller.submitPlaceDraft();
      }

      const dateKey = '2026-06-24';
      controller.selectMeetingDate(dateKey);
      for (final place in controller.sharedPlaces.reversed) {
        controller.linkPlaceToSelectedMeeting(place.id);
      }
      final cafeId = controller.sharedPlaces
          .firstWhere((place) => place.providerPlaceId == 'kakao-cafe-1')
          .id;

      controller.updateMeetingPlaceReservationTime(
        dateKey: dateKey,
        placeId: cafeId,
        reservationTimeLabel: '18:30 예약',
      );
      controller.reorderMeetingPlanPlaces(dateKey, 2, 0);

      final places = controller.placesForMeetingPlan(dateKey);
      expect(places.map((place) => place.name), [
        '작은 전시 공간',
        '조용한 카페',
        '작은 식당',
      ]);
      expect(
        places
            .firstWhere((place) => place.id == cafeId)
            .meetingPlanLinkFor(dateKey)
            ?.reservationTimeLabel,
        '18:30 예약',
      );
      expect(places.map((place) => place.meetingPlanLinkFor(dateKey)?.order), [
        0,
        1,
        2,
      ]);
    });

    test('place board edits and deletes my place', () {
      final controller = AlagagiController()..enterSpace('영우');

      controller.startPlaceDraft();
      controller.applyKakaoPlaceResult(
        providerPlaceId: 'kakao-cafe-1',
        name: '조용한 카페',
        address: '서울 성동구',
        latitude: 37.5446,
        longitude: 127.0557,
        category: PlaceCategory.cafe,
      );
      controller.updatePlaceDraft(note: '첫 메모');
      controller.submitPlaceDraft();

      final placeId = controller.sharedPlaces
          .firstWhere((place) => place.providerPlaceId == 'kakao-cafe-1')
          .id;
      controller.startEditingPlace(placeId);
      controller.setPlaceDraftCategory(PlaceCategory.food);
      controller.updatePlaceDraft(note: '수정한 메모');
      controller.submitPlaceDraft();

      final editedPlace = controller.sharedPlaces.firstWhere(
        (place) => place.id == placeId,
      );
      expect(editedPlace.category, PlaceCategory.food);
      expect(editedPlace.note, '수정한 메모');

      controller.deletePlace(placeId);
      expect(
        controller.sharedPlaces.any((place) => place.id == placeId),
        isFalse,
      );
    });

    test('daily question catalog avoids long-term pressure language', () {
      const blockedWords = ['결혼', '평생', '영원', '기념일', '헤어지'];
      final questionTexts = allKnownQuestions.expand(
        (question) => [question.text, question.highlightedText],
      );

      for (final text in questionTexts) {
        for (final blockedWord in blockedWords) {
          expect(text, isNot(contains(blockedWord)));
        }
      }
    });

    test('daily question catalog provides 58 stable sequential questions', () {
      expect(questionCatalogV1, hasLength(58));

      for (var index = 0; index < questionCatalogV1.length; index++) {
        final expectedNumber = index + 1;
        final question = questionCatalogV1[index];

        expect(question.id, 'q${expectedNumber.toString().padLeft(3, '0')}');
        expect(question.day, expectedNumber);
        expect(question.number, expectedNumber);
        expect(question.text.trim(), isNotEmpty);
        expect(question.highlightedText.trim(), isNotEmpty);
      }

      final ids = questionCatalogV1.map((question) => question.id).toSet();
      expect(ids, hasLength(questionCatalogV1.length));
    });

    test('every day up to today keeps its original question', () {
      // 2026-07-05 시작, 2026-08-05 오늘이면 DAY 1-32가 이미 나온 질문이다.
      final catalog = buildActiveQuestionCatalog(
        startedDateKey: '2026-07-05',
        todayDateKey: '2026-08-05',
      );

      expect(
        questionCatalogV1PreservedCount(
          startedDateKey: '2026-07-05',
          todayDateKey: '2026-08-05',
        ),
        32,
      );

      for (var index = 0; index < 32; index++) {
        expect(catalog[index].id, questionCatalogV1[index].id);
        expect(catalog[index].text, questionCatalogV1[index].text);
      }
    });

    test('new questions start the day after today', () {
      final catalog = buildActiveQuestionCatalog(
        startedDateKey: '2026-07-05',
        todayDateKey: '2026-08-05',
      );

      // 오늘은 DAY 32, 내일은 DAY 33이다.
      expect(catalog[31].id, questionCatalogV1[31].id);
      expect(catalog[32].id, questionCatalogV2.first.id);
      expect(catalog[32].day, 33);
    });

    test('this space keeps all 58 first-set questions through today', () {
      // 이 space는 2026-06-09에 첫 질문을 열었다. 2026-08-05는 DAY 58이고
      // v1 마지막 질문이므로, 오늘까지 나온 58개가 모두 원문으로 남아야 한다.
      const startedDateKey = kQuestionStartedDateKey;
      const todayDateKey = '2026-08-05';

      expect(
        questionCatalogV1PreservedCount(
          startedDateKey: startedDateKey,
          todayDateKey: todayDateKey,
        ),
        questionCatalogV1.length,
      );

      final catalog = buildActiveQuestionCatalog(
        startedDateKey: startedDateKey,
        todayDateKey: todayDateKey,
      );

      for (var index = 0; index < questionCatalogV1.length; index++) {
        expect(catalog[index].id, questionCatalogV1[index].id);
        expect(catalog[index].text, questionCatalogV1[index].text);
      }

      expect(catalog[57].day, 58);
      expect(catalog[58].id, questionCatalogV2.first.id);
      expect(catalog[58].day, 59);
    });

    test('missing progress falls back to the real first question date', () {
      // progress 문서를 읽지 못해도 이미 나온 질문이 잘리면 안 된다.
      final controller = AlagagiController.forSession(
        const AlagagiSession(
          spaceId: 'main',
          me: AppProfile(
            id: 'youngwooUid',
            nickname: '영우',
            avatar: '🌿',
            isMe: true,
          ),
          partner: AppProfile(
            id: 'minyoungUid',
            nickname: '민영',
            avatar: '🪻',
            isMe: false,
          ),
          data: AlagagiSpaceData(),
        ),
        todayDateKey: '2026-08-05',
      );

      expect(
        controller.questions.take(questionCatalogV1.length).map(
          (question) => question.id,
        ),
        questionCatalogV1.map((question) => question.id),
      );
    });

    test('cutover follows the real start date instead of a fixed day', () {
      // 더 오래된 space라면 그만큼 v1이 더 많이 보존돼야 한다.
      final longer = buildActiveQuestionCatalog(
        startedDateKey: '2026-06-01',
        todayDateKey: '2026-08-05',
      );
      final shorter = buildActiveQuestionCatalog(
        startedDateKey: '2026-08-01',
        todayDateKey: '2026-08-05',
      );

      // v1이 58개뿐이라 66일이 지난 space는 v1을 모두 소진한 상태다.
      expect(longer[57].id, questionCatalogV1.last.id);
      expect(longer[58].id, questionCatalogV2.first.id);
      expect(shorter[4].id, questionCatalogV1[4].id);
      expect(shorter[5].id, questionCatalogV2.first.id);
    });

    test('question ids never repeat across catalog versions', () {
      final ids = allKnownQuestions.map((question) => question.id).toList();

      expect(ids.toSet(), hasLength(ids.length));
      expect(
        questionCatalogV1.map((question) => question.id).toSet().intersection(
          questionCatalogV2.map((question) => question.id).toSet(),
        ),
        isEmpty,
      );
    });

    test('active catalog days stay sequential from day one', () {
      final catalog = buildActiveQuestionCatalog(
        startedDateKey: '2026-07-05',
        todayDateKey: '2026-08-05',
      );

      for (var index = 0; index < catalog.length; index++) {
        expect(catalog[index].day, index + 1);
        expect(catalog[index].number, index + 1);
      }
    });

    test('answers to retired questions stay visible in the archive', () {
      final controller = AlagagiController.forSession(
        const AlagagiSession(
          spaceId: 'main',
          me: AppProfile(
            id: 'youngwooUid',
            nickname: '영우',
            avatar: '🌿',
            isMe: true,
          ),
          partner: AppProfile(
            id: 'minyoungUid',
            nickname: '민영',
            avatar: '🪻',
            isMe: false,
          ),
          data: AlagagiSpaceData(
            answers: [
              Answer(
                questionId: 'q050',
                profileId: 'youngwooUid',
                body: '한참 전에 남긴 답이에요.',
                createdLabel: '지난달',
              ),
            ],
            dailyProgress: DailyQuestionProgress(
              startedDateKey: '2026-07-05',
              currentQuestionId: 'q001',
              openedDateKey: '2026-07-05',
            ),
          ),
        ),
        todayDateKey: '2026-08-05',
      );

      // q050은 오늘 기준 활성 순서에는 없지만 답이 있으므로 기록에 남아야 한다.
      expect(
        controller.questions.map((question) => question.id),
        isNot(contains('q050')),
      );
      expect(
        controller.archiveItems.map((item) => item.question.id),
        contains('q050'),
      );
      expect(
        controller.archiveItems
            .firstWhere((item) => item.question.id == 'q050')
            .question
            .text,
        questionCatalogV1[49].text,
      );
    });

    test('daily question resolver reaches the extended catalog', () {
      final controller = AlagagiController.forSession(
        const AlagagiSession(
          spaceId: 'main',
          me: AppProfile(
            id: 'youngwooUid',
            nickname: '영우',
            avatar: '🌿',
            isMe: true,
          ),
          partner: AppProfile(
            id: 'minyoungUid',
            nickname: '민영',
            avatar: '🪻',
            isMe: false,
          ),
          data: AlagagiSpaceData(
            dailyProgress: DailyQuestionProgress(
              startedDateKey: '2026-06-01',
              currentQuestionId: 'q001',
              openedDateKey: '2026-06-01',
            ),
          ),
        ),
        todayDateKey: '2026-07-28',
      );

      // 2026-06-01 시작 기준 2026-07-28은 DAY 58이다.
      expect(controller.todayQuestion.day, 58);
      expect(controller.todayQuestion.id, controller.questions[57].id);
      expect(
        controller.dailyProgress.currentQuestionId,
        controller.questions[57].id,
      );
    });
  });
}
