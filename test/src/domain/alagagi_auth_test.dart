import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:minyoung_pick/src/domain/alagagi_controller.dart';

void main() {
  group('Firebase private login spec', () {
    test('maps short login ids to Firebase Auth emails', () {
      expect(firebaseEmailForLoginId('youngwoo'), 'youngwoo@gettoknow.local');
      expect(firebaseEmailForLoginId(' minyoung '), 'minyoung@gettoknow.local');
      expect(
        firebaseEmailForLoginId('custom@example.com'),
        'custom@example.com',
      );
    });

    test('session controller starts from home with real profile ids', () {
      final repository = RecordingAlagagiRepository();
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
        repository: repository,
      );

      expect(controller.state.route, AlagagiRoute.home);
      expect(controller.state.me.id, 'youngwooUid');
      expect(controller.state.partner.nickname, '민영');

      controller.updateDraftAnswer('노을 질 때가 좋아요.');
      controller.submitTodayAnswer();

      expect(repository.savedAnswers.single.spaceId, 'main');
      expect(repository.savedAnswers.single.answer.profileId, 'youngwooUid');
      expect(repository.savedAnswers.single.answer.body, '노을 질 때가 좋아요.');
    });

    test(
      'session controller does not expose sample history in Firebase mode',
      () {
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

        expect(controller.todayQuestion.id, 'q001');
        expect(controller.todayMyAnswer, isNull);
        expect(controller.todayPartnerAnswer, isNull);
        expect(
          controller.archiveItems.where(
            (item) => item.myAnswer != null || item.partnerAnswer != null,
          ),
          isEmpty,
        );
        expect(controller.insight.questionCount, 0);
        expect(controller.insight.similarityPercent, 0);
        expect(controller.insight.matchedKeywords, isEmpty);
        expect(controller.visibleWishes, isEmpty);
        expect(controller.activeBalanceSelection, isNull);
        expect(controller.activePartnerBalanceSelection, isNull);
        expect(controller.activeProfileCard.filledCount, 0);
      },
    );

    test('session controller normalizes the old default app title', () {
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
            personalization: SpacePersonalization(appTitle: '알아가기'),
          ),
        ),
      );

      expect(controller.state.personalization.appTitle, '조금씩');
      expect(controller.state.personalizationDraft.appTitle, '조금씩');
    });

    test('session controller uses real Firestore-style session data', () {
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
                questionId: 'q001',
                profileId: 'youngwooUid',
                body: '저는 노을 질 때가 좋아요.',
                createdLabel: '오늘',
              ),
              Answer(
                questionId: 'q001',
                profileId: 'minyoungUid',
                body: '저는 아침 공기가 좋아요.',
                createdLabel: '오늘',
              ),
            ],
            balanceSelections: [
              BalanceSelection(
                questionId: 'b001',
                profileId: 'youngwooUid',
                optionId: 'sea',
              ),
              BalanceSelection(
                questionId: 'b001',
                profileId: 'minyoungUid',
                optionId: 'forest',
              ),
            ],
            wishes: [
              WishItem(
                id: 'wish_1',
                icon: '☕',
                title: '조용한 카페에서 커피 마시기',
                kind: WishKind.place,
                createdByProfileId: 'youngwooUid',
                likedByProfileIds: {'youngwooUid', 'minyoungUid'},
              ),
            ],
            curiosityCards: [
              CuriosityCard(
                id: 'curiosity_1',
                fromProfileId: 'minyoungUid',
                toProfileId: 'youngwooUid',
                question: '요즘 제일 자주 생각나는 건 뭐예요?',
                createdLabel: '오늘',
              ),
            ],
          ),
        ),
        todayDateKey: '2026-06-08',
      );

      expect(controller.todayMyAnswer?.body, '저는 노을 질 때가 좋아요.');
      expect(controller.todayPartnerAnswer?.body, '저는 아침 공기가 좋아요.');
      expect(controller.activeBalanceSelection, 'sea');
      expect(controller.activePartnerBalanceSelection, 'forest');
      expect(controller.visibleWishes.single.title, '조용한 카페에서 커피 마시기');
      expect(
        controller.latestReceivedCuriosityCard?.question,
        '요즘 제일 자주 생각나는 건 뭐예요?',
      );
      expect(controller.insight.questionCount, 1);
      expect(controller.insight.matchCount, 1);
    });

    test('session place draft updates duplicate kakao place', () async {
      final repository = RecordingAlagagiRepository();
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
            sharedPlaces: [
              SharedPlace(
                id: 'place_partner_cafe',
                name: '느린 커피',
                address: '서울 성동구',
                category: PlaceCategory.cafe,
                provider: MapApiProvider.kakao,
                providerPlaceId: 'kakao-cafe-1',
                latitude: 37.5446,
                longitude: 127.0557,
                note: '상대가 담은 곳',
                createdByProfileId: 'minyoungUid',
                interestedByProfileIds: {'minyoungUid'},
              ),
            ],
          ),
        ),
        repository: repository,
      );

      controller.startPlaceDraft();
      controller.applyKakaoPlaceResult(
        providerPlaceId: 'kakao-cafe-1',
        name: '느린 커피',
        address: '서울 성동구',
        latitude: 37.5446,
        longitude: 127.0557,
        category: PlaceCategory.food,
      );
      controller.updatePlaceDraft(note: '저녁 후보로 좋아 보여요.');
      controller.submitPlaceDraft();
      await Future<void>.delayed(Duration.zero);

      expect(controller.sharedPlaces, hasLength(1));
      expect(controller.sharedPlaces.single.id, 'place_partner_cafe');
      expect(
        controller.sharedPlaces.single.interestedByProfileIds,
        containsAll(['youngwooUid', 'minyoungUid']),
      );
      expect(repository.savedSharedPlaces.single.spaceId, 'main');
      expect(
        repository.savedSharedPlaces.single.place.id,
        'place_partner_cafe',
      );
      expect(
        repository.savedSharedPlaces.single.place.category,
        PlaceCategory.cafe,
      );
      expect(repository.savedSharedPlaces.single.place.note, '상대가 담은 곳');
    });

    test('session place save failure exposes retry state', () async {
      final repository = RecordingAlagagiRepository()
        ..failSharedPlaceSaves = true;
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
        repository: repository,
      );

      controller.startPlaceDraft();
      controller.applyKakaoPlaceResult(
        providerPlaceId: 'kakao-cafe-1',
        name: '느린 커피',
        address: '서울 성동구',
        latitude: 37.5446,
        longitude: 127.0557,
        category: PlaceCategory.cafe,
      );
      controller.submitPlaceDraft();
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      expect(controller.state.placeSaveStatus, SaveStatus.failed);
      expect(controller.state.placeError, contains('저장하지 못했어요'));
      expect(repository.savedSharedPlaces, isEmpty);
      expect(repository.savedDiagnosticEvents, hasLength(1));
      expect(repository.savedDiagnosticEvents.single.spaceId, 'main');
      expect(repository.savedDiagnosticEvents.single.event.feature, 'places');
      expect(
        repository.savedDiagnosticEvents.single.event.action,
        'saveSharedPlace',
      );
      expect(
        repository.savedDiagnosticEvents.single.event.message,
        contains('place save failed'),
      );

      repository.failSharedPlaceSaves = false;
      controller.retryPlaceSave();
      await Future<void>.delayed(Duration.zero);

      expect(controller.state.placeSaveStatus, SaveStatus.saved);
      expect(
        repository.savedSharedPlaces.single.place.providerPlaceId,
        'kakao-cafe-1',
      );
    });

    test('session place reservation failure writes diagnostic event', () async {
      final repository = RecordingAlagagiRepository()
        ..failSharedPlaceSaves = true;
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
            sharedPlaces: [
              SharedPlace(
                id: 'place_partner_cafe',
                name: '느린 커피',
                address: '서울 성동구',
                category: PlaceCategory.cafe,
                provider: MapApiProvider.kakao,
                providerPlaceId: 'kakao-cafe-1',
                latitude: 37.5446,
                longitude: 127.0557,
                createdByProfileId: 'minyoungUid',
                interestedByProfileIds: {'minyoungUid'},
              ),
            ],
          ),
        ),
        repository: repository,
      );

      final accepted = controller.updateMeetingPlaceReservationTime(
        dateKey: '2026-06-21',
        placeId: 'place_partner_cafe',
        reservationTimeLabel: '18:30 예약',
      );
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      expect(accepted, isTrue);
      expect(repository.savedSharedPlaceMeetingLinks, isEmpty);
      expect(controller.state.placeSaveStatus, SaveStatus.failed);
      expect(repository.savedDiagnosticEvents, hasLength(1));
      final event = repository.savedDiagnosticEvents.single.event;
      expect(event.action, 'saveSharedPlaceMeetingLinks');
      expect(event.targetId, 'place_partner_cafe');
      expect(event.detail, contains('meetingLinksOnly=true'));
    });

    test('session meeting save failure exposes retry state', () async {
      final repository = RecordingAlagagiRepository()
        ..failScheduleEntrySaves = true;
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
        repository: repository,
      );

      controller.selectMeetingDate('2026-06-21');
      controller.updateMeetingDraft(sharedMemo: '19:30 이후면 편해요.');
      controller.submitMeetingDraft();
      await Future<void>.delayed(Duration.zero);

      expect(controller.state.meetingSaveStatus, SaveStatus.failed);
      expect(controller.state.meetingDraftError, contains('저장하지 못했어요'));
      expect(repository.savedScheduleEntries, isEmpty);

      repository.failScheduleEntrySaves = false;
      controller.retryMeetingSave();
      await Future<void>.delayed(Duration.zero);

      expect(controller.state.meetingSaveStatus, SaveStatus.saved);
      expect(repository.savedScheduleEntries.single.spaceId, 'main');
      expect(
        repository.savedScheduleEntries.single.entry.sharedMemo,
        '19:30 이후면 편해요.',
      );
    });

    test(
      'session meeting plan saves to the shared meeting plan document',
      () async {
        final repository = RecordingAlagagiRepository();
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
                  dateKey: '2026-06-21',
                  profileId: 'youngwooUid',
                  availability: MeetingAvailability.available,
                  timeSlots: {MeetingTimeSlot.evening},
                  isMeetingDay: true,
                ),
              ],
            ),
          ),
          repository: repository,
        );

        controller.goTo(AlagagiRoute.meetingPlans);
        controller.updateMeetingPlanItemDraft('전시 보기');
        controller.addMeetingPlanDraftItem();
        controller.updateMeetingPlanItemDraft('근처 카페');
        controller.addMeetingPlanDraftItem();
        controller.submitMeetingPlanDraft();
        await Future<void>.delayed(Duration.zero);

        expect(repository.savedScheduleEntries, isEmpty);
        expect(repository.savedMeetingPlans.single.spaceId, 'main');
        expect(repository.savedMeetingPlans.single.plan.dateKey, '2026-06-21');
        expect(repository.savedMeetingPlans.single.plan.items, [
          '전시 보기',
          '근처 카페',
        ]);
        expect(
          repository.savedMeetingPlans.single.plan.updatedByProfileId,
          'youngwooUid',
        );
        expect(controller.meetingPlanItemsFor('2026-06-21'), [
          '전시 보기',
          '근처 카페',
        ]);
      },
    );

    test(
      'session meeting day save migrates legacy plan items to shared document',
      () async {
        final repository = RecordingAlagagiRepository();
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
                  dateKey: '2026-06-21',
                  profileId: 'youngwooUid',
                  availability: MeetingAvailability.available,
                  timeSlots: {MeetingTimeSlot.evening},
                  isMeetingDay: true,
                  meetingPlanItems: ['전시 보기'],
                ),
                ScheduleEntry(
                  dateKey: '2026-06-21',
                  profileId: 'minyoungUid',
                  availability: MeetingAvailability.available,
                  timeSlots: {MeetingTimeSlot.evening},
                  isMeetingDay: true,
                  meetingPlanItems: ['전시 보기', '근처 카페'],
                ),
              ],
            ),
          ),
          repository: repository,
        );

        controller
          ..goTo(AlagagiRoute.meetings)
          ..selectMeetingDate('2026-06-21')
          ..updateMeetingDayDraft(timeLabel: '저녁 7시쯤')
          ..submitMeetingDayDraft();
        await Future<void>.delayed(Duration.zero);

        expect(
          repository.savedScheduleEntries.single.entry.meetingPlanItems,
          isEmpty,
        );
        expect(repository.savedMeetingPlans.single.spaceId, 'main');
        expect(repository.savedMeetingPlans.single.plan.dateKey, '2026-06-21');
        expect(repository.savedMeetingPlans.single.plan.items, [
          '전시 보기',
          '근처 카페',
        ]);
        expect(controller.meetingPlanItemsFor('2026-06-21'), [
          '전시 보기',
          '근처 카페',
        ]);
      },
    );

    test('session meeting plan save failure exposes retry state', () async {
      final repository = RecordingAlagagiRepository()
        ..failMeetingPlanSaves = true;
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
                dateKey: '2026-06-21',
                profileId: 'youngwooUid',
                availability: MeetingAvailability.available,
                timeSlots: {MeetingTimeSlot.evening},
                isMeetingDay: true,
              ),
            ],
          ),
        ),
        repository: repository,
      );

      controller.goTo(AlagagiRoute.meetingPlans);
      controller.updateMeetingPlanItemDraft('전시 보기');
      controller.addMeetingPlanDraftItem();
      controller.submitMeetingPlanDraft();
      await Future<void>.delayed(Duration.zero);

      expect(controller.state.meetingSaveStatus, SaveStatus.failed);
      expect(controller.state.meetingDraftError, contains('저장하지 못했어요'));
      expect(repository.savedMeetingPlans, isEmpty);

      repository.failMeetingPlanSaves = false;
      controller.retryMeetingSave();
      await Future<void>.delayed(Duration.zero);

      expect(controller.state.meetingSaveStatus, SaveStatus.saved);
      expect(repository.savedMeetingPlans.single.plan.items, ['전시 보기']);
    });

    test(
      'session place meeting link adds my interest and can unlink',
      () async {
        final repository = RecordingAlagagiRepository();
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
              sharedPlaces: [
                SharedPlace(
                  id: 'place_partner_cafe',
                  name: '느린 커피',
                  address: '서울 성동구',
                  category: PlaceCategory.cafe,
                  provider: MapApiProvider.kakao,
                  providerPlaceId: 'kakao-cafe-1',
                  latitude: 37.5446,
                  longitude: 127.0557,
                  createdByProfileId: 'minyoungUid',
                  interestedByProfileIds: {'minyoungUid'},
                ),
              ],
            ),
          ),
          repository: repository,
        );

        controller.selectMeetingDate('2026-06-21');
        controller.linkPlaceToSelectedMeeting('place_partner_cafe');
        await Future<void>.delayed(Duration.zero);

        expect(controller.sharedPlaces.single.linkedDateKey, '2026-06-21');
        expect(
          controller.sharedPlaces.single.interestedByProfileIds,
          contains('youngwooUid'),
        );
        expect(
          repository.savedSharedPlaceMeetingLinks.single.place.linkedDateKey,
          '2026-06-21',
        );

        controller.linkPlaceToSelectedMeeting('place_partner_cafe');
        await Future<void>.delayed(Duration.zero);

        expect(controller.sharedPlaces.single.linkedDateKey, isNull);
        expect(
          repository.savedSharedPlaceMeetingLinks.last.place.linkedDateKey,
          isNull,
        );
      },
    );

    test('session place reservation waits for pending link save', () async {
      final repository = RecordingAlagagiRepository();
      final saveGate = Completer<void>();
      repository.sharedPlaceSaveCompleter = saveGate;
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
            sharedPlaces: [
              SharedPlace(
                id: 'place_partner_cafe',
                name: '느린 커피',
                address: '서울 성동구',
                category: PlaceCategory.cafe,
                provider: MapApiProvider.kakao,
                providerPlaceId: 'kakao-cafe-1',
                latitude: 37.5446,
                longitude: 127.0557,
                createdByProfileId: 'minyoungUid',
                interestedByProfileIds: {'minyoungUid'},
              ),
            ],
          ),
        ),
        repository: repository,
      );

      controller.selectMeetingDate('2026-06-21');
      controller.linkPlaceToSelectedMeeting('place_partner_cafe');
      final accepted = controller.updateMeetingPlaceReservationTime(
        dateKey: '2026-06-21',
        placeId: 'place_partner_cafe',
        reservationTimeLabel: '18:30 예약',
      );

      expect(accepted, isTrue);
      expect(repository.savedSharedPlaces, isEmpty);
      expect(repository.savedSharedPlaceMeetingLinks, isEmpty);

      saveGate.complete();
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      expect(repository.savedSharedPlaces, isEmpty);
      expect(repository.savedSharedPlaceMeetingLinks, hasLength(2));
      expect(
        repository.savedSharedPlaceMeetingLinks.last.place
            .meetingPlanLinkFor('2026-06-21')
            ?.reservationTimeLabel,
        '18:30 예약',
      );
    });

    test(
      'session place reservation saves legacy map metadata places',
      () async {
        final repository = RecordingAlagagiRepository();
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
              sharedPlaces: [
                SharedPlace(
                  id: 'place_legacy_cafe',
                  name: '예전 카페',
                  address: '서울 성동구',
                  category: PlaceCategory.cafe,
                  provider: MapApiProvider.kakao,
                  createdByProfileId: 'youngwooUid',
                  interestedByProfileIds: {'youngwooUid'},
                ),
              ],
            ),
          ),
          repository: repository,
        );

        controller.selectMeetingDate('2026-06-21');
        final accepted = controller.updateMeetingPlaceReservationTime(
          dateKey: '2026-06-21',
          placeId: 'place_legacy_cafe',
          reservationTimeLabel: '19:00 예약',
        );
        await Future<void>.delayed(Duration.zero);

        expect(accepted, isTrue);
        expect(repository.savedSharedPlaces, isEmpty);
        expect(repository.savedSharedPlaceMeetingLinks, hasLength(1));
        final savedPlace = repository.savedSharedPlaceMeetingLinks.single.place;
        expect(savedPlace.providerPlaceId, isEmpty);
        expect(savedPlace.latitude, isNull);
        expect(savedPlace.longitude, isNull);
        expect(
          savedPlace.meetingPlanLinkFor('2026-06-21')?.reservationTimeLabel,
          '19:00 예약',
        );
      },
    );

    test('session place delete removes my place from repository', () async {
      final repository = RecordingAlagagiRepository();
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
            sharedPlaces: [
              SharedPlace(
                id: 'place_my_cafe',
                name: '느린 커피',
                address: '서울 성동구',
                category: PlaceCategory.cafe,
                provider: MapApiProvider.kakao,
                providerPlaceId: 'kakao-cafe-1',
                latitude: 37.5446,
                longitude: 127.0557,
                createdByProfileId: 'youngwooUid',
                interestedByProfileIds: {'youngwooUid'},
              ),
            ],
          ),
        ),
        repository: repository,
      );

      controller.deletePlace('place_my_cafe');
      await Future<void>.delayed(Duration.zero);

      expect(controller.sharedPlaces, isEmpty);
      expect(repository.deletedSharedPlaces.single.spaceId, 'main');
      expect(repository.deletedSharedPlaces.single.placeId, 'place_my_cafe');
    });

    test('session controller saves curiosity question and reply', () {
      final repository = RecordingAlagagiRepository();
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
            curiosityCards: [
              CuriosityCard(
                id: 'curiosity_existing',
                fromProfileId: 'minyoungUid',
                toProfileId: 'youngwooUid',
                question: '요즘 제일 자주 생각나는 건 뭐예요?',
                createdLabel: '오늘',
              ),
            ],
          ),
        ),
        repository: repository,
      );

      controller.updateCuriosityQuestionDraft('이번 주에 기대되는 일이 있어요?');
      controller.submitCuriosityQuestion();

      expect(repository.savedCuriosityCards.last.spaceId, 'main');
      expect(
        repository.savedCuriosityCards.last.card.fromProfileId,
        'youngwooUid',
      );
      expect(
        repository.savedCuriosityCards.last.card.toProfileId,
        'minyoungUid',
      );
      expect(
        repository.savedCuriosityCards.last.card.question,
        '이번 주에 기대되는 일이 있어요?',
      );

      controller.updateCuriosityReplyDraft(
        cardId: 'curiosity_existing',
        value: '산책하면서 생각을 정리하는 시간이요.',
      );
      controller.submitCuriosityReply('curiosity_existing');

      expect(repository.savedCuriosityCards.last.card.id, 'curiosity_existing');
      expect(
        repository.savedCuriosityCards.last.card.reply,
        '산책하면서 생각을 정리하는 시간이요.',
      );
      expect(
        controller.latestReceivedCuriosityCard?.reply,
        '산책하면서 생각을 정리하는 시간이요.',
      );
    });

    test('session controller blocks another curiosity while one waits', () {
      final repository = RecordingAlagagiRepository();
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
            curiosityCards: [
              CuriosityCard(
                id: 'curiosity_waiting',
                fromProfileId: 'youngwooUid',
                toProfileId: 'minyoungUid',
                question: '이번 주에 기대되는 일이 있어요?',
                createdLabel: '오늘',
              ),
            ],
          ),
        ),
        repository: repository,
      );

      controller.updateCuriosityQuestionDraft('하나 더 물어봐도 돼요?');
      controller.submitCuriosityQuestion();

      expect(repository.savedCuriosityCards, isEmpty);
      expect(controller.state.curiosityError, contains('답장을 기다리는'));
      expect(controller.state.curiosityQuestionDraft, '하나 더 물어봐도 돼요?');
    });

    test('daily progress selects the shared current question', () {
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
              startedDateKey: '2026-06-06',
              currentQuestionId: 'q003',
              openedDateKey: '2026-06-08',
            ),
          ),
        ),
        todayDateKey: '2026-06-08',
      );

      expect(controller.todayQuestion.id, 'q003');
      expect(controller.todayQuestion.number, 3);
    });

    test('daily progress derives today question from started date key', () {
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
              startedDateKey: '2026-06-07',
              currentQuestionId: 'q001',
              openedDateKey: '2026-06-09',
            ),
          ),
        ),
        todayDateKey: '2026-06-09',
      );

      expect(controller.todayQuestion.id, 'q003');
      expect(controller.dailyProgress.startedDateKey, '2026-06-07');
      expect(controller.dailyProgress.currentQuestionId, 'q003');
    });

    test('date change writes daily progress at most once', () {
      final repository = RecordingAlagagiRepository();

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
              startedDateKey: '2026-06-07',
              currentQuestionId: 'q002',
              openedDateKey: '2026-06-08',
            ),
          ),
        ),
        repository: repository,
        todayDateKey: '2026-06-09',
      );

      expect(controller.todayQuestion.id, 'q003');
      expect(repository.savedDailyQuestionProgress, hasLength(1));
      expect(
        repository.savedDailyQuestionProgress.single.progress.currentQuestionId,
        'q003',
      );
      expect(
        repository.savedDailyQuestionProgress.single.progress.openedDateKey,
        '2026-06-09',
      );
    });

    test('same date daily progress load does not write again', () {
      final repository = RecordingAlagagiRepository();

      AlagagiController.forSession(
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
              startedDateKey: '2026-06-07',
              currentQuestionId: 'q003',
              openedDateKey: '2026-06-09',
            ),
          ),
        ),
        repository: repository,
        todayDateKey: '2026-06-09',
      );

      expect(repository.savedDailyQuestionProgress, isEmpty);
    });

    test('legacy progress migrates missing started date from opened date', () {
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
              currentQuestionId: 'q001',
              openedDateKey: '2026-06-08',
            ),
          ),
        ),
        todayDateKey: '2026-06-09',
      );

      expect(controller.dailyProgress.startedDateKey, '2026-06-08');
    });

    test('question calendar exposes past unanswered late answer state', () {
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
                questionId: 'q001',
                profileId: 'youngwooUid',
                body: '아침 시간이 좋아요.',
                createdLabel: '6월 7일',
              ),
              Answer(
                questionId: 'q001',
                profileId: 'minyoungUid',
                body: '저녁 산책이 좋아요.',
                createdLabel: '6월 7일',
              ),
            ],
            dailyProgress: DailyQuestionProgress(
              startedDateKey: '2026-06-07',
              currentQuestionId: 'q001',
              openedDateKey: '2026-06-09',
            ),
          ),
        ),
        todayDateKey: '2026-06-09',
      );

      final day1 = controller.questionCalendarDays[0];
      final day2 = controller.questionCalendarDays[1];
      final today = controller.questionCalendarDays[2];

      expect(day1.status, QuestionCalendarStatus.bothAnswered);
      expect(day1.canLateAnswer, isFalse);
      expect(day2.status, QuestionCalendarStatus.unanswered);
      expect(day2.canLateAnswer, isTrue);
      expect(today.isToday, isTrue);
    });

    test('question calendar month grid follows today and selected month', () {
      final controller = AlagagiController.forSession(
        firebaseSessionWithData(
          const AlagagiSpaceData(
            dailyProgress: DailyQuestionProgress(
              startedDateKey: '2026-06-08',
              currentQuestionId: 'q015',
              openedDateKey: '2026-06-22',
            ),
          ),
        ),
        todayDateKey: '2026-06-22',
      );

      final todayWindow = controller.visibleQuestionCalendarDays;

      expect(todayWindow.length, inInclusiveRange(35, 42));
      expect(todayWindow.first.dateKey, '2026-06-01');
      expect(todayWindow.last.dateKey, '2026-07-05');
      expect(todayWindow.map((day) => day.question?.number), contains(15));
      expect(
        todayWindow.any((day) => day.isToday && day.question?.number == 15),
        isTrue,
      );
      expect(todayWindow.where((day) => day.isInDisplayedMonth), hasLength(30));
      expect(
        todayWindow
            .where((day) => !day.isInDisplayedMonth)
            .map((day) => day.dateKey),
        containsAll(['2026-07-01', '2026-07-05']),
      );

      controller.selectArchiveDate('2026-07-02');
      final selectedWindow = controller.visibleQuestionCalendarDays;

      expect(selectedWindow.length, inInclusiveRange(35, 42));
      expect(selectedWindow.first.dateKey, '2026-06-29');
      expect(selectedWindow.last.dateKey, '2026-08-02');
      expect(
        selectedWindow.where((day) => day.isInDisplayedMonth),
        hasLength(31),
      );
      expect(
        selectedWindow.any(
          (day) => day.isSelected && day.question?.number == 25,
        ),
        isTrue,
      );
    });

    test(
      'late answer saves the selected past question with one answer key',
      () {
        final repository = RecordingAlagagiRepository();
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
                startedDateKey: '2026-06-07',
                currentQuestionId: 'q001',
                openedDateKey: '2026-06-09',
              ),
            ),
          ),
          repository: repository,
          todayDateKey: '2026-06-09',
        );

        controller.startLateAnswer('q002');
        expect(controller.state.route, AlagagiRoute.answer);
        expect(controller.activeAnswerQuestion.id, 'q002');

        controller.updateDraftAnswer('늦게 남기는 답이에요.');
        controller.submitActiveAnswer();

        expect(repository.savedAnswers, hasLength(1));
        expect(repository.savedAnswers.single.answer.questionId, 'q002');
        expect(repository.savedAnswers.single.answer.profileId, 'youngwooUid');
        expect(repository.savedAnswers.single.answer.body, '늦게 남기는 답이에요.');
        expect(controller.answerForQuestion('q002')?.body, '늦게 남기는 답이에요.');
      },
    );

    test(
      'failed late answer keeps archive retryable until save succeeds',
      () async {
        final repository = RecordingAlagagiRepository()..failAnswerSaves = true;
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
                startedDateKey: '2026-06-07',
                currentQuestionId: 'q001',
                openedDateKey: '2026-06-09',
              ),
            ),
          ),
          repository: repository,
          todayDateKey: '2026-06-09',
        );

        controller.startLateAnswer('q002');
        controller.updateDraftAnswer('늦게 남기지만 실패할 답이에요.');
        controller.submitActiveAnswer();
        await Future<void>.delayed(Duration.zero);

        expect(controller.state.route, AlagagiRoute.archive);
        expect(controller.state.answerSaveStatus, SaveStatus.failed);
        expect(
          controller.selectedQuestionCalendarDay?.status,
          QuestionCalendarStatus.unanswered,
        );
        expect(controller.selectedQuestionCalendarDay?.canLateAnswer, isTrue);
        expect(controller.partnerAnswerForQuestion('q002'), isNull);

        repository.failAnswerSaves = false;
        controller.retryAnswerSave();
        await Future<void>.delayed(Duration.zero);

        expect(controller.state.answerSaveStatus, SaveStatus.saved);
        expect(
          controller.selectedQuestionCalendarDay?.status,
          QuestionCalendarStatus.myAnswerOnly,
        );
        expect(repository.savedAnswers.single.answer.questionId, 'q002');
      },
    );

    test('invalid daily progress safely falls back to the first question', () {
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
              startedDateKey: '2026-06-08',
              currentQuestionId: 'missing-question',
              openedDateKey: '2026-06-08',
            ),
          ),
        ),
        todayDateKey: '2026-06-08',
      );

      expect(controller.todayQuestion.id, 'q001');
    });

    test('last balance question completes instead of looping', () {
      final controller = AlagagiController.forSession(firebaseTestSession);

      while (!controller.isLastBalanceQuestion) {
        controller.nextBalanceQuestion();
      }

      expect(controller.activeBalanceQuestion.id, 'b008');

      controller.nextBalanceQuestion();

      expect(controller.state.route, AlagagiRoute.home);
      expect(controller.activeBalanceQuestion.id, 'b008');
    });

    test('balance reason is saved with my selection', () async {
      final repository = RecordingAlagagiRepository();
      final controller = AlagagiController.forSession(
        firebaseTestSession,
        repository: repository,
      );

      controller.selectBalanceOption('sea');
      repository.savedBalanceSelections.clear();

      controller.saveBalanceReason('조용한 곳이 더 끌려요');
      await Future<void>.delayed(Duration.zero);

      expect(controller.activeBalanceReason, '조용한 곳이 더 끌려요');
      expect(repository.savedBalanceSelections, hasLength(1));
      expect(
        repository.savedBalanceSelections.single.selection.questionId,
        'b001',
      );
      expect(
        repository.savedBalanceSelections.single.selection.optionId,
        'sea',
      );
      expect(
        repository.savedBalanceSelections.single.selection.reason,
        '조용한 곳이 더 끌려요',
      );
    });

    test('selecting the same balance option clears the existing selection', () {
      final repository = RecordingAlagagiRepository();
      final session = firebaseSessionWithData(
        const AlagagiSpaceData(
          balanceSelections: [
            BalanceSelection(
              questionId: 'b001',
              profileId: 'youngwooUid',
              optionId: 'sea',
            ),
          ],
        ),
      );
      final controller = AlagagiController.forSession(
        session,
        repository: repository,
      );

      expect(controller.activeBalanceSelection, 'sea');

      controller.selectBalanceOption('sea');

      expect(controller.activeBalanceSelection, isNull);
      expect(repository.savedBalanceSelections, isEmpty);
      expect(repository.deletedBalanceSelections, [
        (spaceId: 'main', questionId: 'b001', profileId: 'youngwooUid'),
      ]);
    });

    test('revealing a balance result is saved separately from selection', () {
      final repository = RecordingAlagagiRepository();
      final session = firebaseSessionWithData(
        const AlagagiSpaceData(
          balanceSelections: [
            BalanceSelection(
              questionId: 'b001',
              profileId: 'youngwooUid',
              optionId: 'sea',
            ),
            BalanceSelection(
              questionId: 'b001',
              profileId: 'minyoungUid',
              optionId: 'forest',
            ),
          ],
        ),
      );
      final controller = AlagagiController.forSession(
        session,
        repository: repository,
      );
      final question = controller.activeBalanceQuestion;

      expect(controller.isBalanceResultReadyFor(question), isTrue);
      expect(controller.isBalanceResultRevealedFor(question), isFalse);

      controller.revealBalanceResult(question);

      expect(controller.isBalanceResultRevealedFor(question), isTrue);
      expect(controller.balanceRevealedCount, 1);
      expect(repository.savedBalanceSelections, hasLength(1));
      expect(
        repository.savedBalanceSelections.single.selection.resultRevealedAt,
        isNotNull,
      );

      repository.savedBalanceSelections.clear();
      controller.revealBalanceResult(question);

      expect(repository.savedBalanceSelections, isEmpty);
    });

    test('wish draft creates and saves my wish', () {
      final repository = RecordingAlagagiRepository();
      final controller = AlagagiController.forSession(
        firebaseTestSession,
        repository: repository,
      );

      controller.startWishDraft();
      controller.setWishDraftKind(WishKind.activity);
      controller.updateWishDraftTitle('한강에서 같이 산책하기');
      controller.submitWishDraft();

      expect(controller.state.wishDraftVisible, isFalse);
      expect(controller.state.wishDraftTitle, isEmpty);
      expect(controller.visibleWishes.single.title, '한강에서 같이 산책하기');
      expect(controller.visibleWishes.single.kind, WishKind.activity);
      expect(controller.visibleWishes.single.createdByProfileId, 'youngwooUid');
      expect(
        controller.visibleWishes.single.likedByProfileIds,
        contains('youngwooUid'),
      );
      expect(repository.savedWishes.single.spaceId, 'main');
      expect(repository.savedWishes.single.wish.title, '한강에서 같이 산책하기');
    });

    test('empty wish draft stays open with validation error', () {
      final controller = AlagagiController.forSession(firebaseTestSession);

      controller.startWishDraft();
      controller.submitWishDraft();

      expect(controller.state.wishDraftVisible, isTrue);
      expect(controller.state.wishDraftError, contains('한 줄'));
      expect(controller.visibleWishes, isEmpty);
    });

    test(
      'custom profile cards can be saved, hidden, restored, and deleted',
      () async {
        final repository = RecordingAlagagiRepository();
        final controller = AlagagiController.forSession(
          firebaseTestSession,
          repository: repository,
        );

        final addError = controller.addCustomProfileSlot(
          title: '내가 편한 질문',
          value: '천천히 대답할 수 있는 질문이 좋아요.',
          category: '직접',
        );
        await Future<void>.delayed(Duration.zero);

        expect(addError, isNull);
        final customSlot = controller.myProfileCard.slots.first;
        expect(customSlot.custom, isTrue);
        expect(customSlot.label, '내가 편한 질문');
        expect(repository.savedProfileSlots.last.slot.custom, isTrue);
        expect(repository.savedProfileSlots.last.slot.value, contains('천천히'));

        controller.hideProfileSlot('rest');
        await Future<void>.delayed(Duration.zero);

        final hiddenRest = controller.myProfileCard.slots.firstWhere(
          (slot) => slot.id == 'rest',
        );
        expect(hiddenRest.hidden, isTrue);
        expect(hiddenRest.value, isNull);
        expect(controller.todayFillableProfileSlot?.id, isNot('rest'));
        expect(repository.savedProfileSlots.last.slot.hidden, isTrue);

        controller.restoreProfileSlot('rest');
        await Future<void>.delayed(Duration.zero);

        final restoredRest = controller.myProfileCard.slots.firstWhere(
          (slot) => slot.id == 'rest',
        );
        expect(restoredRest.hidden, isFalse);

        controller.deleteCustomProfileSlot(customSlot.id);
        await Future<void>.delayed(Duration.zero);

        expect(
          controller.myProfileCard.slots.where(
            (slot) => slot.id == customSlot.id,
          ),
          isEmpty,
        );
        expect(repository.deletedProfileSlots.single.slotId, customSlot.id);
      },
    );

    test('partner custom profile cards appear on the partner card', () {
      final controller = AlagagiController.forSession(
        firebaseSessionWithData(
          AlagagiSpaceData(
            profileSlots: [
              ProfileSlotValue(
                profileId: 'minyoungUid',
                slot: ProfileSlot(
                  id: 'custom_minyoung_1',
                  label: '내가 만든 질문',
                  icon: 'custom',
                  category: '직접',
                  inputHint: '직접 추가한 소개 카드',
                  value: '이 질문이 더 편해서 직접 남겼어요.',
                  custom: true,
                  updatedAt: DateTime.parse('2026-06-09T10:00:00.000Z'),
                  updatedByProfileId: 'minyoungUid',
                ),
              ),
            ],
          ),
        ),
      );

      final partnerCustomSlot = controller.activeProfileCard.slots.firstWhere(
        (slot) => slot.id == 'custom_minyoung_1',
      );

      expect(partnerCustomSlot.custom, isTrue);
      expect(partnerCustomSlot.label, '내가 만든 질문');
      expect(partnerCustomSlot.value, contains('직접 남겼어요'));
      expect(
        controller.unreadCountForFeature(UnreadActivityFeature.profileCard),
        1,
      );
    });

    test('unread activities collect partner changes across features', () {
      final seenStore = MemoryMusicNoteSeenStore()
        ..writeLastSeenAt(
          'main',
          'youngwooUid',
          UnreadActivityFeature.wishlist,
          DateTime.parse('2026-06-09T08:00:00.000Z'),
        );
      final controller = AlagagiController.forSession(
        firebaseSessionWithData(
          AlagagiSpaceData(
            profileSlots: [
              ProfileSlotValue(
                profileId: 'minyoungUid',
                slot: ProfileSlot(
                  id: 'food',
                  label: '먹고 싶은 음식',
                  icon: 'food',
                  value: '따뜻한 국물',
                  updatedAt: DateTime.parse('2026-06-09T10:00:00.000Z'),
                  updatedByProfileId: 'minyoungUid',
                ),
              ),
            ],
            wishes: [
              WishItem(
                id: 'wish_partner',
                icon: '✨',
                title: '한강 산책',
                kind: WishKind.activity,
                createdByProfileId: 'minyoungUid',
                likedByProfileIds: {'minyoungUid'},
                updatedAt: DateTime.parse('2026-06-09T10:00:00.000Z'),
                updatedByProfileId: 'minyoungUid',
              ),
              WishItem(
                id: 'wish_mine',
                icon: '✨',
                title: '내가 누른 관심',
                kind: WishKind.activity,
                createdByProfileId: 'minyoungUid',
                likedByProfileIds: {'minyoungUid', 'youngwooUid'},
                updatedAt: DateTime.parse('2026-06-09T11:00:00.000Z'),
                updatedByProfileId: 'youngwooUid',
              ),
            ],
            scheduleEntries: [
              ScheduleEntry(
                dateKey: '2026-06-19',
                profileId: 'minyoungUid',
                availability: MeetingAvailability.available,
                timeSlots: {MeetingTimeSlot.evening},
                updatedAt: DateTime.parse('2026-06-09T10:05:00.000Z'),
              ),
            ],
            sharedPlaces: [
              SharedPlace(
                id: 'place_partner',
                name: '조용한 카페',
                address: '서울',
                category: PlaceCategory.cafe,
                provider: MapApiProvider.kakao,
                createdByProfileId: 'minyoungUid',
                interestedByProfileIds: {'minyoungUid'},
                updatedAt: DateTime.parse('2026-06-09T10:10:00.000Z'),
                updatedByProfileId: 'minyoungUid',
              ),
            ],
            stockStories: [
              StockStory(
                id: 'stock_partner',
                name: 'NVDA',
                reason: '같이 볼 흐름',
                upside: '성장',
                risk: '변동성',
                question: '어떻게 볼까요?',
                createdByProfileId: 'minyoungUid',
                createdLabel: '오늘',
                updatedAt: DateTime.parse('2026-06-09T10:20:00.000Z'),
                updatedByProfileId: 'minyoungUid',
              ),
            ],
            musicNotes: [
              MusicNote(
                id: 'music_partner',
                title: '밤 산책',
                artist: '민영',
                link: '',
                note: '',
                mood: '밤',
                createdByProfileId: 'minyoungUid',
                createdLabel: '오늘',
                updatedAt: DateTime.parse('2026-06-09T10:30:00.000Z'),
              ),
            ],
            improvementPosts: [
              ImprovementPost(
                id: 'improvement_partner',
                title: '새 기능',
                body: '새 소식도 보여주세요.',
                category: '추가 요청',
                createdByProfileId: 'minyoungUid',
                createdLabel: '오늘',
                updatedAt: DateTime.parse('2026-06-09T10:40:00.000Z'),
              ),
            ],
          ),
        ),
        musicNoteSeenStore: seenStore,
      );

      expect(
        controller.unreadActivities.map((activity) => activity.feature).toSet(),
        containsAll({
          UnreadActivityFeature.profileCard,
          UnreadActivityFeature.wishlist,
          UnreadActivityFeature.meetings,
          UnreadActivityFeature.places,
          UnreadActivityFeature.stocks,
          UnreadActivityFeature.music,
          UnreadActivityFeature.improvements,
        }),
      );
      expect(
        controller.unreadCountForFeature(UnreadActivityFeature.wishlist),
        1,
      );

      controller.goTo(AlagagiRoute.wishlist);

      expect(
        controller.unreadCountForFeature(UnreadActivityFeature.wishlist),
        0,
      );
      expect(
        seenStore.readLastSeenAt(
          'main',
          'youngwooUid',
          UnreadActivityFeature.wishlist,
        ),
        DateTime.parse('2026-06-09T11:00:00.000Z'),
      );
    });

    test('answer draft changes do not call repository writes', () {
      final repository = RecordingAlagagiRepository();
      final controller = AlagagiController.forSession(
        firebaseTestSession,
        repository: repository,
      );

      controller.updateDraftAnswer('아직 제출하지 않은 답변');

      expect(controller.state.draftAnswer, '아직 제출하지 않은 답변');
      expect(repository.savedAnswers, isEmpty);
    });

    test('answer edit persists same key with edited marker', () async {
      final repository = RecordingAlagagiRepository();
      final controller = AlagagiController.forSession(
        firebaseTestSession,
        repository: repository,
      );

      controller.updateDraftAnswer('처음 답변');
      controller.submitTodayAnswer();
      await Future<void>.delayed(Duration.zero);

      controller.editTodayAnswer();
      controller.updateDraftAnswer('수정한 답변');
      controller.submitTodayAnswer();
      await Future<void>.delayed(Duration.zero);

      expect(repository.savedAnswers, hasLength(2));
      expect(repository.savedAnswers.first.answer.questionId, 'q001');
      expect(repository.savedAnswers.last.answer.questionId, 'q001');
      expect(repository.savedAnswers.first.answer.profileId, 'youngwooUid');
      expect(repository.savedAnswers.last.answer.profileId, 'youngwooUid');
      expect(repository.savedAnswers.first.answer.edited, isFalse);
      expect(repository.savedAnswers.last.answer.edited, isTrue);
    });

    test('answer save failure exposes retry state', () async {
      final repository = RecordingAlagagiRepository()..failAnswerSaves = true;
      final controller = AlagagiController.forSession(
        firebaseTestSession,
        repository: repository,
      );

      controller.updateDraftAnswer('저장 실패를 확인하는 답변');
      controller.submitTodayAnswer();
      await Future<void>.delayed(Duration.zero);

      expect(controller.state.answerSaveStatus, SaveStatus.failed);
      expect(controller.state.answerError, contains('저장하지 못했어요'));
      expect(repository.savedAnswers, isEmpty);

      repository.failAnswerSaves = false;
      controller.retryAnswerSave();
      await Future<void>.delayed(Duration.zero);

      expect(controller.state.answerSaveStatus, SaveStatus.saved);
      expect(repository.savedAnswers.single.answer.body, '저장 실패를 확인하는 답변');
    });

    test('partner answer stays locked until my answer save succeeds', () async {
      final saveCompleter = Completer<void>();
      final repository = RecordingAlagagiRepository()
        ..answerSaveCompleter = saveCompleter;
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
                questionId: 'q001',
                profileId: 'minyoungUid',
                body: '민영이의 답변',
                createdLabel: '오늘',
              ),
            ],
          ),
        ),
        repository: repository,
        todayDateKey: '2026-06-08',
      );

      controller.updateDraftAnswer('저장 중인 내 답변');
      controller.submitTodayAnswer();
      await Future<void>.delayed(Duration.zero);

      expect(controller.state.answerSaveStatus, SaveStatus.saving);
      expect(controller.todayMyAnswer?.body, '저장 중인 내 답변');
      expect(controller.todayPartnerAnswer, isNull);

      controller.updateAnswerCommentDraft(
        questionId: 'q001',
        answerOwnerProfileId: 'minyoungUid',
        value: '저장되기 전에는 댓글도 잠겨야 해요.',
      );
      controller.submitAnswerComment(
        questionId: 'q001',
        answerOwnerProfileId: 'minyoungUid',
      );

      expect(repository.savedAnswerComments, isEmpty);
      expect(controller.state.commentError, contains('상대 답이 열린 뒤'));

      saveCompleter.complete();
      await Future<void>.delayed(Duration.zero);

      expect(controller.state.answerSaveStatus, SaveStatus.saved);
      expect(controller.todayPartnerAnswer?.body, '민영이의 답변');
    });

    test(
      'failed answer save keeps partner answer locked until retry succeeds',
      () async {
        final repository = RecordingAlagagiRepository()..failAnswerSaves = true;
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
                  questionId: 'q001',
                  profileId: 'minyoungUid',
                  body: '민영이의 답변',
                  createdLabel: '오늘',
                ),
              ],
            ),
          ),
          repository: repository,
          todayDateKey: '2026-06-08',
        );

        controller.updateDraftAnswer('실패할 답변');
        controller.submitTodayAnswer();
        await Future<void>.delayed(Duration.zero);

        expect(controller.state.answerSaveStatus, SaveStatus.failed);
        expect(controller.todayPartnerAnswer, isNull);

        repository.failAnswerSaves = false;
        controller.retryAnswerSave();
        await Future<void>.delayed(Duration.zero);

        expect(controller.state.answerSaveStatus, SaveStatus.saved);
        expect(controller.todayPartnerAnswer?.body, '민영이의 답변');
      },
    );

    test('already liked wish interest tap is no-op in Firebase mode', () {
      final repository = RecordingAlagagiRepository();
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
            wishes: [
              WishItem(
                id: 'wish_1',
                icon: '☕',
                title: '조용한 카페 가기',
                kind: WishKind.place,
                createdByProfileId: 'minyoungUid',
                likedByProfileIds: {'youngwooUid'},
              ),
            ],
          ),
        ),
        repository: repository,
      );

      controller.toggleWishLike('wish_1');

      expect(controller.visibleWishes.single.likedByProfileIds, {
        'youngwooUid',
      });
      expect(repository.savedWishes, isEmpty);
    });

    test('calendar month grid includes today beyond the first 14 days', () {
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
              currentQuestionId: 'q020',
              openedDateKey: '2026-06-20',
            ),
          ),
        ),
        todayDateKey: '2026-06-20',
      );

      final visibleDateKeys = controller.visibleQuestionCalendarDays
          .map((day) => day.dateKey)
          .toList();

      expect(visibleDateKeys.length, inInclusiveRange(35, 42));
      expect(visibleDateKeys.first, '2026-06-01');
      expect(visibleDateKeys, contains('2026-06-20'));
      expect(visibleDateKeys, contains('2026-06-30'));
      expect(
        controller.visibleQuestionCalendarDays
            .singleWhere((day) => day.dateKey == '2026-06-20')
            .isToday,
        isTrue,
      );
    });

    test('calendar month navigation changes only local state', () {
      final repository = RecordingAlagagiRepository();
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
              currentQuestionId: 'q020',
              openedDateKey: '2026-06-20',
            ),
          ),
        ),
        repository: repository,
        todayDateKey: '2026-06-20',
      );

      controller.selectNextArchiveMonth();

      expect(
        controller.visibleQuestionCalendarDays.first.dateKey,
        '2026-06-29',
      );
      expect(
        controller.selectedQuestionCalendarDay?.dateKey.startsWith('2026-07'),
        isTrue,
      );

      controller.selectPreviousArchiveMonth();

      expect(
        controller.visibleQuestionCalendarDays.first.dateKey,
        '2026-06-01',
      );

      controller.selectTodayArchiveMonth();

      expect(controller.selectedQuestionCalendarDay?.dateKey, '2026-06-20');
      expect(repository.savedAnswers, isEmpty);
      expect(repository.savedDailyQuestionProgress, isEmpty);
    });

    test('answer comment draft does not write until submit', () {
      final repository = RecordingAlagagiRepository();
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
                questionId: 'q001',
                profileId: 'youngwooUid',
                body: '저는 노을 질 때가 좋아요.',
                createdLabel: '오늘',
              ),
              Answer(
                questionId: 'q001',
                profileId: 'minyoungUid',
                body: '저는 아침 공기가 좋아요.',
                createdLabel: '오늘',
              ),
            ],
          ),
        ),
        repository: repository,
      );

      controller.updateAnswerCommentDraft(
        questionId: 'q001',
        answerOwnerProfileId: 'minyoungUid',
        value: '이 답 좋다. 조금 더 듣고 싶어.',
      );

      expect(repository.savedAnswerComments, isEmpty);
      expect(
        controller.commentDraftForAnswer('q001', 'minyoungUid'),
        '이 답 좋다. 조금 더 듣고 싶어.',
      );
    });

    test(
      'answer comment save and edit overwrite the same comment key',
      () async {
        final repository = RecordingAlagagiRepository();
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
                  questionId: 'q001',
                  profileId: 'youngwooUid',
                  body: '저는 노을 질 때가 좋아요.',
                  createdLabel: '오늘',
                ),
                Answer(
                  questionId: 'q001',
                  profileId: 'minyoungUid',
                  body: '저는 아침 공기가 좋아요.',
                  createdLabel: '오늘',
                ),
              ],
            ),
          ),
          repository: repository,
        );

        controller.updateAnswerCommentDraft(
          questionId: 'q001',
          answerOwnerProfileId: 'minyoungUid',
          value: '이 답 좋다.',
        );
        controller.submitAnswerComment(
          questionId: 'q001',
          answerOwnerProfileId: 'minyoungUid',
        );
        await Future<void>.delayed(Duration.zero);

        controller.updateAnswerCommentDraft(
          questionId: 'q001',
          answerOwnerProfileId: 'minyoungUid',
          value: '이 답 좋다. 조금 더 듣고 싶어.',
        );
        controller.submitAnswerComment(
          questionId: 'q001',
          answerOwnerProfileId: 'minyoungUid',
        );
        await Future<void>.delayed(Duration.zero);

        expect(repository.savedAnswerComments, hasLength(2));
        expect(repository.savedAnswerComments.first.comment.edited, isFalse);
        expect(repository.savedAnswerComments.last.comment.edited, isTrue);
        expect(repository.savedAnswerComments.last.comment.questionId, 'q001');
        expect(
          repository.savedAnswerComments.last.comment.answerOwnerProfileId,
          'minyoungUid',
        );
        expect(
          controller
              .commentForAnswer('q001', 'minyoungUid', 'youngwooUid')
              ?.body,
          '이 답 좋다. 조금 더 듣고 싶어.',
        );
      },
    );

    test('answer comment reply saves on a received partner comment', () async {
      final repository = RecordingAlagagiRepository();
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
                questionId: 'q001',
                profileId: 'youngwooUid',
                body: '저는 노을 질 때가 좋아요.',
                createdLabel: '오늘',
              ),
              Answer(
                questionId: 'q001',
                profileId: 'minyoungUid',
                body: '저는 아침 공기가 좋아요.',
                createdLabel: '오늘',
              ),
            ],
            answerComments: [
              AnswerComment(
                questionId: 'q001',
                answerOwnerProfileId: 'youngwooUid',
                commenterProfileId: 'minyoungUid',
                body: '왜 노을이 좋아요?',
                createdLabel: '오늘',
              ),
            ],
          ),
        ),
        repository: repository,
      );

      controller.updateAnswerCommentReplyDraft(
        questionId: 'q001',
        answerOwnerProfileId: 'youngwooUid',
        commenterProfileId: 'minyoungUid',
        value: '하루가 조용히 정리되는 느낌이라서요.',
      );
      controller.submitAnswerCommentReply(
        questionId: 'q001',
        answerOwnerProfileId: 'youngwooUid',
        commenterProfileId: 'minyoungUid',
      );
      await Future<void>.delayed(Duration.zero);

      expect(repository.savedAnswerComments, hasLength(1));
      expect(repository.savedAnswerComments.single.comment.body, '왜 노을이 좋아요?');
      expect(
        repository.savedAnswerComments.single.comment.replyBody,
        '하루가 조용히 정리되는 느낌이라서요.',
      );
      expect(
        repository.savedAnswerComments.single.comment.repliedByProfileId,
        'youngwooUid',
      );
      expect(
        repository.savedAnswerComments.single.comment.replyEdited,
        isFalse,
      );

      controller.updateAnswerCommentReplyDraft(
        questionId: 'q001',
        answerOwnerProfileId: 'youngwooUid',
        commenterProfileId: 'minyoungUid',
        value: '하루가 부드럽게 마무리되는 느낌이라서요.',
      );
      controller.submitAnswerCommentReply(
        questionId: 'q001',
        answerOwnerProfileId: 'youngwooUid',
        commenterProfileId: 'minyoungUid',
      );
      await Future<void>.delayed(Duration.zero);

      expect(repository.savedAnswerComments, hasLength(2));
      expect(
        repository.savedAnswerComments.last.comment.replyBody,
        '하루가 부드럽게 마무리되는 느낌이라서요.',
      );
      expect(repository.savedAnswerComments.last.comment.replyEdited, isTrue);
    });

    test('answer comment is rejected when partner answer is skipped', () {
      final repository = RecordingAlagagiRepository();
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
                questionId: 'q001',
                profileId: 'youngwooUid',
                body: '저는 노을 질 때가 좋아요.',
                createdLabel: '오늘',
              ),
              Answer(
                questionId: 'q001',
                profileId: 'minyoungUid',
                body: '',
                createdLabel: '오늘',
                skipped: true,
              ),
            ],
          ),
        ),
        repository: repository,
      );

      controller.updateAnswerCommentDraft(
        questionId: 'q001',
        answerOwnerProfileId: 'minyoungUid',
        value: '나중에 다시 들어볼게.',
      );
      controller.submitAnswerComment(
        questionId: 'q001',
        answerOwnerProfileId: 'minyoungUid',
      );

      expect(repository.savedAnswerComments, isEmpty);
      expect(controller.state.commentError, contains('상대 답이 열린 뒤'));
    });

    test('personalization draft saves only on explicit action', () async {
      final repository = RecordingAlagagiRepository();
      final controller = AlagagiController.forSession(
        firebaseTestSession,
        repository: repository,
      );

      controller.updatePersonalizationDraft(
        appTitle: '민영과 영우',
        homeLine: '천천히 알아가는 중',
      );

      expect(repository.savedPersonalizations, isEmpty);
      expect(controller.state.personalizationDraft.appTitle, '민영과 영우');

      controller.savePersonalizationDraft();
      await Future<void>.delayed(Duration.zero);

      expect(repository.savedPersonalizations.single.spaceId, 'main');
      expect(
        repository.savedPersonalizations.single.personalization.appTitle,
        '민영과 영우',
      );
      expect(controller.state.personalization.appTitle, '민영과 영우');
      expect(controller.state.personalization.homeLine, '천천히 알아가는 중');
    });

    test(
      'music notes load from session data and save only on submit',
      () async {
        final repository = RecordingAlagagiRepository();
        final controller = AlagagiController.forSession(
          firebaseSessionWithData(
            const AlagagiSpaceData(
              musicNotes: [
                MusicNote(
                  id: 'music_1',
                  title: '밤 산책',
                  artist: '민영의 추천',
                  link: 'https://music.example/night',
                  note: '퇴근길에 들으면 차분해져요.',
                  mood: '밤',
                  createdByProfileId: 'minyoungUid',
                  createdLabel: '오늘',
                ),
              ],
            ),
          ),
          repository: repository,
        );

        expect(controller.musicNotes.single.title, '밤 산책');
        expect(controller.musicNotes.single.createdByProfileId, 'minyoungUid');

        controller.startMusicDraft();
        controller.updateMusicDraft(
          title: '오후의 문장',
          artist: 'Unknown Artist',
          link: 'https://music.example/afternoon',
          note: '카페에서 이야기할 때 배경에 있으면 좋을 것 같아서요.',
        );
        controller.setMusicDraftMood('카페');

        expect(repository.savedMusicNotes, isEmpty);

        controller.submitMusicDraft();
        await Future<void>.delayed(Duration.zero);

        expect(repository.savedMusicNotes.single.spaceId, 'main');
        expect(repository.savedMusicNotes.single.note.title, '오후의 문장');
        expect(repository.savedMusicNotes.single.note.artist, 'Unknown Artist');
        expect(repository.savedMusicNotes.single.note.mood, '카페');
        expect(
          repository.savedMusicNotes.single.note.createdByProfileId,
          'youngwooUid',
        );
        expect(
          repository.savedMusicNotes.single.note.listenedByProfileIds,
          contains('youngwooUid'),
        );
        expect(repository.savedMusicListenStates, isEmpty);
        expect(controller.state.musicDraftVisible, isFalse);
        expect(controller.musicNotes.first.title, '오후의 문장');
      },
    );

    test('music note listen emoji toggles my listen state only', () async {
      final repository = RecordingAlagagiRepository();
      final controller = AlagagiController.forSession(
        firebaseSessionWithData(
          const AlagagiSpaceData(
            musicNotes: [
              MusicNote(
                id: 'music_partner',
                title: '밤 산책',
                artist: '민영의 추천',
                link: 'https://music.example/night',
                note: '퇴근길에 들으면 차분해져요.',
                mood: '밤',
                createdByProfileId: 'minyoungUid',
                createdLabel: '오늘',
                listenedByProfileIds: {'minyoungUid'},
              ),
            ],
          ),
        ),
        repository: repository,
      );

      controller.toggleMusicNoteListened('music_partner');
      await Future<void>.delayed(Duration.zero);

      expect(controller.musicNotes.single.title, '밤 산책');
      expect(
        controller.musicNotes.single.listenedByProfileIds,
        containsAll(['minyoungUid', 'youngwooUid']),
      );
      expect(repository.savedMusicNotes, isEmpty);
      expect(repository.savedMusicListenStates.single.spaceId, 'main');
      expect(
        repository.savedMusicListenStates.single.note.listenedByProfileIds,
        containsAll(['minyoungUid', 'youngwooUid']),
      );

      controller.toggleMusicNoteListened('music_partner');
      await Future<void>.delayed(Duration.zero);

      expect(
        controller.musicNotes.single.listenedByProfileIds,
        isNot(contains('youngwooUid')),
      );
      expect(repository.savedMusicListenStates, hasLength(2));
    });

    test('music note edit overwrites the existing own note document', () async {
      final repository = RecordingAlagagiRepository();
      final controller = AlagagiController.forSession(
        firebaseSessionWithData(
          AlagagiSpaceData(
            musicNotes: [
              MusicNote(
                id: 'music_mine',
                title: '밤 산책',
                artist: '영우의 추천',
                link: 'https://music.example/night',
                note: '퇴근길에 들으면 차분해져요.',
                mood: '밤',
                createdByProfileId: 'youngwooUid',
                createdLabel: '오늘',
                updatedAt: DateTime.parse('2026-06-09T09:00:00.000Z'),
              ),
            ],
          ),
        ),
        repository: repository,
      );

      controller.startMusicEdit('music_mine');
      expect(controller.state.musicDraftVisible, isTrue);
      expect(controller.state.editingMusicNoteId, 'music_mine');
      expect(controller.state.musicDraftTitle, '밤 산책');

      controller.updateMusicDraft(
        title: '다시 듣는 밤 산책',
        artist: '영우의 추천',
        link: 'https://music.example/night-v2',
        note: '조금 더 천천히 듣고 싶어서요.',
      );
      controller.setMusicDraftMood('산책');
      controller.submitMusicDraft();
      await Future<void>.delayed(Duration.zero);

      expect(controller.musicNotes, hasLength(1));
      expect(controller.musicNotes.single.id, 'music_mine');
      expect(controller.musicNotes.single.title, '다시 듣는 밤 산책');
      expect(controller.musicNotes.single.mood, '산책');
      expect(controller.state.editingMusicNoteId, isNull);
      expect(repository.savedMusicNotes, hasLength(1));
      expect(repository.savedMusicNotes.single.note.id, 'music_mine');
      expect(repository.savedMusicNotes.single.note.title, '다시 듣는 밤 산책');
      expect(repository.savedMusicNotes.single.note.updatedAt, isNotNull);
    });

    test(
      'stock stories load from session data and save only on submit',
      () async {
        final repository = RecordingAlagagiRepository();
        final controller = AlagagiController.forSession(
          firebaseSessionWithData(
            const AlagagiSpaceData(
              stockStories: [
                StockStory(
                  id: 'stock_partner',
                  name: 'Apple',
                  reason: '서비스 매출 흐름을 같이 보고 싶어요.',
                  upside: '구독 매출과 생태계 유지력',
                  risk: '기기 교체 수요 둔화',
                  question: '다음 실적에서 어떤 숫자를 먼저 볼까요?',
                  createdByProfileId: 'minyoungUid',
                  createdLabel: '오늘',
                ),
              ],
            ),
          ),
          repository: repository,
        );

        expect(controller.stockStories.single.name, 'Apple');
        expect(
          controller.stockStories.single.createdByProfileId,
          'minyoungUid',
        );

        controller.startStockStoryDraft();
        controller.updateStockStoryDraft(
          name: '삼성전자',
          reason: '실적 발표 전에 같이 살펴보고 싶어요.',
          upside: '메모리 업황 회복',
          risk: '기대가 이미 가격에 반영됐는지',
          question: '이번 분기에는 어떤 숫자를 먼저 보면 좋을까요?',
        );

        expect(repository.savedStockStories, isEmpty);

        controller.submitStockStoryDraft();
        await Future<void>.delayed(Duration.zero);

        expect(repository.savedStockStories.single.spaceId, 'main');
        expect(repository.savedStockStories.single.story.name, '삼성전자');
        expect(
          repository.savedStockStories.single.story.createdByProfileId,
          'youngwooUid',
        );
        expect(controller.state.stockStoryDraftVisible, isFalse);
        expect(controller.stockStories.first.name, '삼성전자');
      },
    );

    test(
      'stock story reply updates the existing partner story document',
      () async {
        final repository = RecordingAlagagiRepository();
        final controller = AlagagiController.forSession(
          firebaseSessionWithData(
            AlagagiSpaceData(
              stockStories: [
                StockStory(
                  id: 'stock_partner',
                  name: 'Apple',
                  reason: '서비스 매출 흐름을 같이 보고 싶어요.',
                  upside: '구독 매출과 생태계 유지력',
                  risk: '기기 교체 수요 둔화',
                  question: '다음 실적에서 어떤 숫자를 먼저 볼까요?',
                  createdByProfileId: 'minyoungUid',
                  createdLabel: '오늘',
                  updatedAt: DateTime.parse('2026-06-09T09:00:00.000Z'),
                ),
              ],
            ),
          ),
          repository: repository,
        );

        controller.setStockStoryReplyTone('stock_partner', '조심해요');
        controller.updateStockStoryReplyDraft(
          storyId: 'stock_partner',
          value: '마진이 유지되는지 먼저 보고 싶어요.',
        );
        controller.submitStockStoryReply('stock_partner');
        await Future<void>.delayed(Duration.zero);

        expect(controller.stockStories, hasLength(1));
        expect(controller.stockStories.single.id, 'stock_partner');
        expect(controller.stockStories.single.replyTone, '조심해요');
        expect(controller.stockStories.single.reply, '마진이 유지되는지 먼저 보고 싶어요.');
        expect(
          controller.stockStories.single.repliedByProfileId,
          'youngwooUid',
        );
        expect(repository.savedStockStories, hasLength(1));
        expect(repository.savedStockStories.single.story.id, 'stock_partner');
        expect(repository.savedStockStories.single.story.replyTone, '조심해요');
      },
    );

    test(
      'stock holdings load from session data and save only on submit',
      () async {
        final repository = RecordingAlagagiRepository();
        final controller = AlagagiController.forSession(
          firebaseSessionWithData(
            const AlagagiSpaceData(
              stockHoldings: [
                StockHolding(
                  id: 'holding_partner',
                  name: 'Apple',
                  status: '보유 중',
                  weightLabel: '보통',
                  reason: '서비스 매출을 믿고 들고 있어요.',
                  watchPoint: '서비스 매출 성장률',
                  concern: '기기 교체 수요 둔화',
                  question: '다음 실적에서 어떤 숫자를 같이 보면 좋을까요?',
                  createdByProfileId: 'minyoungUid',
                  createdLabel: '오늘',
                ),
              ],
            ),
          ),
          repository: repository,
        );

        expect(controller.stockHoldings.single.name, 'Apple');
        expect(
          controller.stockHoldings.single.createdByProfileId,
          'minyoungUid',
        );

        controller.startStockHoldingDraft();
        controller.updateStockHoldingDraft(
          name: '삼성전자',
          reason: '반도체 업황을 같이 보려고 들고 있어요.',
          watchPoint: '메모리 수요 회복',
          concern: '기대가 너무 빨리 반영됐는지',
          question: '다음 실적에서 어떤 숫자를 같이 보면 좋을까요?',
        );

        expect(repository.savedStockHoldings, isEmpty);

        controller.submitStockHoldingDraft();
        await Future<void>.delayed(Duration.zero);

        expect(repository.savedStockHoldings.single.spaceId, 'main');
        expect(repository.savedStockHoldings.single.holding.name, '삼성전자');
        expect(repository.savedStockHoldings.single.holding.status, '보유 중');
        expect(
          repository.savedStockHoldings.single.holding.createdByProfileId,
          'youngwooUid',
        );
        expect(controller.state.stockHoldingDraftVisible, isFalse);
        expect(controller.stockHoldings.first.name, '삼성전자');
      },
    );

    test('stock holding owner can edit and delete own holding', () async {
      final repository = RecordingAlagagiRepository();
      final controller = AlagagiController.forSession(
        firebaseSessionWithData(
          AlagagiSpaceData(
            stockHoldings: [
              StockHolding(
                id: 'holding_mine',
                name: 'Microsoft',
                status: '보유 중',
                weightLabel: '보통',
                reason: '클라우드 매출을 믿고 들고 있어요.',
                watchPoint: 'Azure 성장률',
                concern: 'AI 투자 비용',
                question: '다음 실적에서 어떤 숫자를 같이 보면 좋을까요?',
                createdByProfileId: 'youngwooUid',
                createdLabel: '오늘',
                replyTone: '같이 볼래요',
                reply: '답장은 유지돼요.',
                repliedByProfileId: 'minyoungUid',
                repliedLabel: '오늘',
                updatedAt: DateTime.parse('2026-06-09T09:00:00.000Z'),
              ),
              StockHolding(
                id: 'holding_partner',
                name: 'Apple',
                status: '보유 중',
                weightLabel: '작게',
                reason: '상대가 들고 있는 종목이에요.',
                watchPoint: '서비스 매출',
                concern: '교체 수요',
                question: '같이 봐줄래요?',
                createdByProfileId: 'minyoungUid',
                createdLabel: '오늘',
                updatedAt: DateTime.parse('2026-06-09T08:00:00.000Z'),
              ),
            ],
          ),
        ),
        repository: repository,
      );

      controller.startStockHoldingEdit('holding_partner');
      expect(controller.state.stockHoldingDraftError, contains('내가 공유한'));

      controller.startStockHoldingEdit('holding_mine');
      expect(controller.state.stockHoldingDraftVisible, isTrue);
      expect(controller.state.editingStockHoldingId, 'holding_mine');
      expect(controller.state.stockHoldingDraftName, 'Microsoft');

      controller.updateStockHoldingDraft(
        status: '정리 고민 중',
        weightLabel: '크게',
        reason: 'AI 매출과 클라우드를 다시 보려고 해요.',
      );
      controller.submitStockHoldingDraft();
      await Future<void>.delayed(Duration.zero);

      final editedHolding = controller.stockHoldings.firstWhere(
        (holding) => holding.id == 'holding_mine',
      );
      expect(editedHolding.status, '정리 고민 중');
      expect(editedHolding.weightLabel, '크게');
      expect(editedHolding.reason, 'AI 매출과 클라우드를 다시 보려고 해요.');
      expect(editedHolding.reply, '답장은 유지돼요.');
      expect(repository.savedStockHoldings.single.holding.id, 'holding_mine');

      controller.deleteStockHolding('holding_partner');
      expect(controller.state.stockHoldingDraftError, contains('내가 공유한'));
      expect(repository.deletedStockHoldings, isEmpty);
      expect(
        controller.stockHoldings.any(
          (holding) => holding.id == 'holding_partner',
        ),
        isTrue,
      );

      controller.deleteStockHolding('holding_mine');
      await Future<void>.delayed(Duration.zero);

      expect(
        controller.stockHoldings.any((holding) => holding.id == 'holding_mine'),
        isFalse,
      );
      expect(repository.deletedStockHoldings.single.spaceId, 'main');
      expect(repository.deletedStockHoldings.single.holdingId, 'holding_mine');
    });

    test(
      'stock holding reply updates the existing partner holding document',
      () async {
        final repository = RecordingAlagagiRepository();
        final controller = AlagagiController.forSession(
          firebaseSessionWithData(
            AlagagiSpaceData(
              stockHoldings: [
                StockHolding(
                  id: 'holding_partner',
                  name: 'Apple',
                  status: '보유 중',
                  weightLabel: '보통',
                  reason: '서비스 매출을 믿고 들고 있어요.',
                  watchPoint: '서비스 매출 성장률',
                  concern: '기기 교체 수요 둔화',
                  question: '다음 실적에서 어떤 숫자를 같이 보면 좋을까요?',
                  createdByProfileId: 'minyoungUid',
                  createdLabel: '오늘',
                  updatedAt: DateTime.parse('2026-06-09T09:00:00.000Z'),
                ),
              ],
            ),
          ),
          repository: repository,
        );

        controller.setStockHoldingReplyTone('holding_partner', '같이 볼래요');
        controller.updateStockHoldingReplyDraft(
          holdingId: 'holding_partner',
          value: '실적 발표 후에 같이 다시 볼게요.',
        );
        controller.submitStockHoldingReply('holding_partner');
        await Future<void>.delayed(Duration.zero);

        expect(controller.stockHoldings, hasLength(1));
        expect(controller.stockHoldings.single.id, 'holding_partner');
        expect(controller.stockHoldings.single.replyTone, '같이 볼래요');
        expect(controller.stockHoldings.single.reply, '실적 발표 후에 같이 다시 볼게요.');
        expect(
          controller.stockHoldings.single.repliedByProfileId,
          'youngwooUid',
        );
        expect(repository.savedStockHoldings, hasLength(1));
        expect(
          repository.savedStockHoldings.single.holding.id,
          'holding_partner',
        );
        expect(
          repository.savedStockHoldings.single.holding.replyTone,
          '같이 볼래요',
        );
      },
    );

    test('improvement board saves edits and deletes owner posts', () async {
      final repository = RecordingAlagagiRepository();
      final controller = AlagagiController.forSession(
        firebaseSessionWithData(
          AlagagiSpaceData(
            improvementPosts: [
              ImprovementPost(
                id: 'improvement_mine',
                title: '장소 화면 개선',
                body: '지도 위 버튼을 조금 더 정리하면 좋겠어요.',
                category: '개선',
                createdByProfileId: 'youngwooUid',
                createdLabel: '오늘',
                updatedAt: DateTime.parse('2026-06-10T09:00:00.000Z'),
              ),
              ImprovementPost(
                id: 'improvement_partner',
                title: '루틴 공유',
                body: '서로의 반복 일정을 볼 수 있으면 좋겠어요.',
                category: '추가 요청',
                createdByProfileId: 'minyoungUid',
                createdLabel: '오늘',
                updatedAt: DateTime.parse('2026-06-10T08:00:00.000Z'),
              ),
            ],
          ),
        ),
        repository: repository,
      );

      expect(controller.improvementPosts, hasLength(2));

      controller.startImprovementDraft();
      controller.updateImprovementDraft(
        title: '음악 정렬',
        body: '아직 안 들은 노래를 더 쉽게 보고 싶어요.',
        category: '아이디어',
      );

      expect(repository.savedImprovementPosts, isEmpty);

      controller.submitImprovementDraft();
      await Future<void>.delayed(Duration.zero);

      expect(repository.savedImprovementPosts.single.spaceId, 'main');
      expect(repository.savedImprovementPosts.single.post.title, '음악 정렬');
      expect(
        repository.savedImprovementPosts.single.post.createdByProfileId,
        'youngwooUid',
      );

      controller.startImprovementEdit('improvement_partner');
      expect(controller.state.improvementDraftError, contains('내가 남긴'));

      controller.startImprovementEdit('improvement_mine');
      expect(controller.state.editingImprovementPostId, 'improvement_mine');
      controller.updateImprovementDraft(
        title: '장소 화면 더 넓게',
        body: '지도를 볼 때 카드가 덜 겹치면 좋겠어요.',
        category: '불편함',
      );
      controller.submitImprovementDraft();
      await Future<void>.delayed(Duration.zero);

      final editedPost = controller.improvementPosts.firstWhere(
        (post) => post.id == 'improvement_mine',
      );
      expect(editedPost.title, '장소 화면 더 넓게');
      expect(editedPost.category, '불편함');
      expect(repository.savedImprovementPosts.last.post.id, 'improvement_mine');

      controller.deleteImprovementPost('improvement_partner');
      expect(controller.state.improvementDraftError, contains('내가 남긴'));
      expect(repository.deletedImprovementPosts, isEmpty);

      controller.deleteImprovementPost('improvement_mine');
      await Future<void>.delayed(Duration.zero);

      expect(
        controller.improvementPosts.any(
          (post) => post.id == 'improvement_mine',
        ),
        isFalse,
      );
      expect(repository.deletedImprovementPosts.single.spaceId, 'main');
      expect(
        repository.deletedImprovementPosts.single.postId,
        'improvement_mine',
      );
    });

    test('only owner can reply and resolve improvement posts', () async {
      final repository = RecordingAlagagiRepository();
      final controller = AlagagiController.forSession(
        firebaseSessionWithData(
          AlagagiSpaceData(
            improvementPosts: [
              ImprovementPost(
                id: 'improvement_partner',
                title: '루틴 공유',
                body: '서로의 반복 일정을 볼 수 있으면 좋겠어요.',
                category: '추가 요청',
                createdByProfileId: 'minyoungUid',
                createdLabel: '오늘',
                updatedAt: DateTime.parse('2026-06-10T08:00:00.000Z'),
              ),
            ],
          ),
        ),
        repository: repository,
      );

      controller.saveImprovementOwnerNote(
        'improvement_partner',
        '루틴 공유는 다음 개선 후보로 정리했어요.',
      );
      await Future<void>.delayed(Duration.zero);
      controller.toggleImprovementResolved('improvement_partner');
      await Future<void>.delayed(Duration.zero);

      final post = controller.improvementPosts.single;
      expect(post.ownerNote, '루틴 공유는 다음 개선 후보로 정리했어요.');
      expect(post.ownerNoteProfileId, 'youngwooUid');
      expect(post.resolved, isTrue);
      expect(post.resolvedByProfileId, 'youngwooUid');
      expect(repository.savedImprovementPosts, hasLength(2));
      expect(repository.savedImprovementPosts.last.post.resolved, isTrue);

      final guestRepository = RecordingAlagagiRepository();
      final guestController = AlagagiController.forSession(
        AlagagiSession(
          spaceId: 'main',
          me: const AppProfile(
            id: 'minyoungUid',
            nickname: '민영',
            avatar: '🪻',
            isMe: true,
          ),
          partner: const AppProfile(
            id: 'youngwooUid',
            nickname: '영우',
            avatar: '🌿',
            isMe: false,
          ),
          data: AlagagiSpaceData(improvementPosts: [post]),
        ),
        repository: guestRepository,
      );

      guestController.saveImprovementOwnerNote(
        'improvement_partner',
        '민영이 답변을 남기면 안 돼요.',
      );
      guestController.toggleImprovementResolved('improvement_partner');

      expect(guestRepository.savedImprovementPosts, isEmpty);
      expect(guestController.state.improvementDraftError, contains('영우만'));
    });

    test(
      'home progress summary uses local seen time for new partner music notes',
      () {
        final seenStore = MemoryMusicNoteSeenStore()
          ..writeLastSeenMusicNoteAt(
            'main',
            'youngwooUid',
            DateTime.parse('2026-06-09T08:00:00.000Z'),
          );
        final controller = AlagagiController.forSession(
          firebaseSessionWithData(
            AlagagiSpaceData(
              musicNotes: [
                MusicNote(
                  id: 'music_partner_new',
                  title: '밤 산책',
                  artist: '민영의 추천',
                  link: 'https://music.example/night',
                  note: '퇴근길에 들으면 차분해져요.',
                  mood: '밤',
                  createdByProfileId: 'minyoungUid',
                  createdLabel: '오늘',
                  updatedAt: DateTime.parse('2026-06-09T10:00:00.000Z'),
                ),
                MusicNote(
                  id: 'music_mine_new',
                  title: '오후의 문장',
                  artist: '영우의 추천',
                  link: 'https://music.example/afternoon',
                  note: '카페에서 이야기할 때 배경에 있으면 좋을 것 같아서요.',
                  mood: '카페',
                  createdByProfileId: 'youngwooUid',
                  createdLabel: '오늘',
                  updatedAt: DateTime.parse('2026-06-09T11:00:00.000Z'),
                ),
              ],
            ),
          ),
          musicNoteSeenStore: seenStore,
        );

        final musicItem = controller.homeProgressSummary.items.singleWhere(
          (item) => item.id == 'music',
        );

        expect(musicItem.stateText, '새 음악 노트가 있어요');
        expect(
          controller.homeProgressSummary.primaryAction?.route,
          isNot(AlagagiRoute.music),
        );

        controller.goTo(AlagagiRoute.music);

        expect(
          seenStore.readLastSeenMusicNoteAt('main', 'youngwooUid'),
          DateTime.parse('2026-06-09T11:00:00.000Z'),
        );
        expect(
          controller.homeProgressSummary.items
              .singleWhere((item) => item.id == 'music')
              .stateText,
          '최근 음악 노트 2곡',
        );
      },
    );
  });
}

const firebaseTestSession = AlagagiSession(
  spaceId: 'main',
  me: AppProfile(id: 'youngwooUid', nickname: '영우', avatar: '🌿', isMe: true),
  partner: AppProfile(
    id: 'minyoungUid',
    nickname: '민영',
    avatar: '🪻',
    isMe: false,
  ),
);

AlagagiSession firebaseSessionWithData(AlagagiSpaceData data) {
  return AlagagiSession(
    spaceId: firebaseTestSession.spaceId,
    me: firebaseTestSession.me,
    partner: firebaseTestSession.partner,
    data: data,
  );
}

class RecordingAlagagiRepository implements AlagagiDataRepository {
  bool failAnswerSaves = false;
  bool failAnswerCommentSaves = false;
  bool failScheduleEntrySaves = false;
  bool failMeetingPlanSaves = false;
  bool failSharedPlaceSaves = false;
  Completer<void>? answerSaveCompleter;
  Completer<void>? sharedPlaceSaveCompleter;
  final List<({String spaceId, Answer answer})> savedAnswers = [];
  final List<({String spaceId, BalanceSelection selection})>
  savedBalanceSelections = [];
  final List<({String spaceId, String questionId, String profileId})>
  deletedBalanceSelections = [];
  final List<({String spaceId, String profileId, ProfileSlot slot})>
  savedProfileSlots = [];
  final List<({String spaceId, String profileId, String slotId})>
  deletedProfileSlots = [];
  final List<({String spaceId, WishItem wish})> savedWishes = [];
  final List<({String spaceId, String wishId})> deletedWishes = [];
  final List<({String spaceId, MusicNote note})> savedMusicNotes = [];
  final List<({String spaceId, MusicNote note})> savedMusicListenStates = [];
  final List<({String spaceId, String noteId})> deletedMusicNotes = [];
  final List<({String spaceId, ScheduleEntry entry})> savedScheduleEntries = [];
  final List<({String spaceId, MeetingPlan plan})> savedMeetingPlans = [];
  final List<({String spaceId, SharedPlace place})> savedSharedPlaces = [];
  final List<({String spaceId, SharedPlace place})>
  savedSharedPlaceMeetingLinks = [];
  final List<({String spaceId, DiagnosticEvent event})> savedDiagnosticEvents =
      [];
  final List<({String spaceId, String placeId})> deletedSharedPlaces = [];
  final List<({String spaceId, StockStory story})> savedStockStories = [];
  final List<({String spaceId, String storyId})> deletedStockStories = [];
  final List<({String spaceId, StockHolding holding})> savedStockHoldings = [];
  final List<({String spaceId, String holdingId})> deletedStockHoldings = [];
  final List<({String spaceId, ImprovementPost post})> savedImprovementPosts =
      [];
  final List<({String spaceId, String postId})> deletedImprovementPosts = [];
  final List<({String spaceId, AnswerComment comment})> savedAnswerComments =
      [];
  final List<({String spaceId, CuriosityCard card})> savedCuriosityCards = [];
  final List<({String spaceId, DailyQuestionProgress progress})>
  savedDailyQuestionProgress = [];
  final List<({String spaceId, SpacePersonalization personalization})>
  savedPersonalizations = [];

  @override
  Future<AlagagiSession?> loadSession(AlagagiAuthUser user) async {
    return null;
  }

  @override
  Future<void> saveAnswer(String spaceId, Answer answer) async {
    final completer = answerSaveCompleter;
    if (completer != null) {
      await completer.future;
    }
    if (failAnswerSaves) {
      throw StateError('save failed');
    }
    savedAnswers.add((spaceId: spaceId, answer: answer));
  }

  @override
  Future<void> saveBalanceSelection(
    String spaceId,
    BalanceSelection selection,
  ) async {
    savedBalanceSelections.add((spaceId: spaceId, selection: selection));
  }

  @override
  Future<void> deleteBalanceSelection(
    String spaceId,
    String questionId,
    String profileId,
  ) async {
    deletedBalanceSelections.add((
      spaceId: spaceId,
      questionId: questionId,
      profileId: profileId,
    ));
  }

  @override
  Future<void> saveProfileSlot(
    String spaceId,
    String profileId,
    ProfileSlot slot,
  ) async {
    savedProfileSlots.add((spaceId: spaceId, profileId: profileId, slot: slot));
  }

  @override
  Future<void> deleteProfileSlot(
    String spaceId,
    String profileId,
    String slotId,
  ) async {
    deletedProfileSlots.add((
      spaceId: spaceId,
      profileId: profileId,
      slotId: slotId,
    ));
  }

  @override
  Future<void> saveWish(String spaceId, WishItem wish) async {
    savedWishes.add((spaceId: spaceId, wish: wish));
  }

  @override
  Future<void> deleteWish(String spaceId, String wishId) async {
    deletedWishes.add((spaceId: spaceId, wishId: wishId));
  }

  @override
  Future<void> saveMusicNote(String spaceId, MusicNote note) async {
    savedMusicNotes.add((spaceId: spaceId, note: note));
  }

  @override
  Future<void> saveMusicNoteListenState(String spaceId, MusicNote note) async {
    savedMusicListenStates.add((spaceId: spaceId, note: note));
  }

  @override
  Future<void> deleteMusicNote(String spaceId, String noteId) async {
    deletedMusicNotes.add((spaceId: spaceId, noteId: noteId));
  }

  @override
  Future<void> saveScheduleEntry(String spaceId, ScheduleEntry entry) async {
    if (failScheduleEntrySaves) {
      throw StateError('schedule save failed');
    }
    savedScheduleEntries.add((spaceId: spaceId, entry: entry));
  }

  @override
  Future<void> saveMeetingPlan(String spaceId, MeetingPlan plan) async {
    if (failMeetingPlanSaves) {
      throw StateError('meeting plan save failed');
    }
    savedMeetingPlans.add((spaceId: spaceId, plan: plan));
  }

  @override
  Future<void> saveSharedPlace(String spaceId, SharedPlace place) async {
    final completer = sharedPlaceSaveCompleter;
    if (completer != null) {
      await completer.future;
    }
    if (failSharedPlaceSaves) {
      throw StateError('place save failed');
    }
    savedSharedPlaces.add((spaceId: spaceId, place: place));
  }

  @override
  Future<void> saveSharedPlaceMeetingLinks(
    String spaceId,
    SharedPlace place,
  ) async {
    final completer = sharedPlaceSaveCompleter;
    if (completer != null) {
      await completer.future;
    }
    if (failSharedPlaceSaves) {
      throw StateError('place meeting links save failed');
    }
    savedSharedPlaceMeetingLinks.add((spaceId: spaceId, place: place));
  }

  @override
  Future<void> deleteSharedPlace(String spaceId, String placeId) async {
    deletedSharedPlaces.add((spaceId: spaceId, placeId: placeId));
  }

  @override
  Future<void> saveDiagnosticEvent(
    String spaceId,
    DiagnosticEvent event,
  ) async {
    savedDiagnosticEvents.add((spaceId: spaceId, event: event));
  }

  @override
  Future<void> saveCuriosityCard(String spaceId, CuriosityCard card) async {
    savedCuriosityCards.add((spaceId: spaceId, card: card));
  }

  @override
  Future<void> saveStockStory(String spaceId, StockStory story) async {
    savedStockStories.add((spaceId: spaceId, story: story));
  }

  @override
  Future<void> deleteStockStory(String spaceId, String storyId) async {
    deletedStockStories.add((spaceId: spaceId, storyId: storyId));
  }

  @override
  Future<void> saveStockHolding(String spaceId, StockHolding holding) async {
    savedStockHoldings.add((spaceId: spaceId, holding: holding));
  }

  @override
  Future<void> deleteStockHolding(String spaceId, String holdingId) async {
    deletedStockHoldings.add((spaceId: spaceId, holdingId: holdingId));
  }

  @override
  Future<void> saveImprovementPost(String spaceId, ImprovementPost post) async {
    savedImprovementPosts.add((spaceId: spaceId, post: post));
  }

  @override
  Future<void> deleteImprovementPost(String spaceId, String postId) async {
    deletedImprovementPosts.add((spaceId: spaceId, postId: postId));
  }

  @override
  Future<void> saveAnswerComment(String spaceId, AnswerComment comment) async {
    if (failAnswerCommentSaves) {
      throw StateError('comment save failed');
    }
    savedAnswerComments.add((spaceId: spaceId, comment: comment));
  }

  @override
  Future<void> saveDailyQuestionProgress(
    String spaceId,
    DailyQuestionProgress progress,
  ) async {
    savedDailyQuestionProgress.add((spaceId: spaceId, progress: progress));
  }

  @override
  Future<void> saveSpacePersonalization(
    String spaceId,
    SpacePersonalization personalization,
  ) async {
    savedPersonalizations.add((
      spaceId: spaceId,
      personalization: personalization,
    ));
  }
}
