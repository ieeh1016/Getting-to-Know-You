import 'package:flutter_test/flutter_test.dart';
import 'package:minyoung_pick/src/domain/alagagi_controller.dart';

void main() {
  group('Trip duration', () {
    Trip tripBetween(String start, String end) => Trip(
      id: 'trip_1',
      title: '가을 제주',
      destination: '제주도',
      startDateKey: start,
      endDateKey: end,
      createdByProfileId: 'me',
    );

    test('same day trip reads as a day trip', () {
      final trip = tripBetween('2026-09-12', '2026-09-12');

      expect(trip.nightCount, 0);
      expect(trip.dayCount, 1);
      expect(trip.durationLabel, '당일');
      expect(trip.dateKeys, ['2026-09-12']);
    });

    test('two night trip reads as 2박 3일 and lists every day', () {
      final trip = tripBetween('2026-09-12', '2026-09-14');

      expect(trip.nightCount, 2);
      expect(trip.dayCount, 3);
      expect(trip.durationLabel, '2박 3일');
      expect(trip.dateKeys, [
        '2026-09-12',
        '2026-09-13',
        '2026-09-14',
      ]);
      expect(trip.containsDateKey('2026-09-13'), isTrue);
      expect(trip.containsDateKey('2026-09-15'), isFalse);
    });
  });

  group('AlagagiController trips', () {
    AlagagiController buildController() {
      return AlagagiController.forSession(
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
      );
    }

    test('saving a trip stores duration derived from the two dates', () {
      final controller = buildController();

      final error = controller.saveTrip(
        title: '가을 제주',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-14',
      );

      expect(error, isNull);
      expect(controller.trips, hasLength(1));
      expect(controller.trips.single.durationLabel, '2박 3일');
      expect(controller.trips.single.status, TripStatus.planning);
    });

    test('end date before start date is rejected without storing a trip', () {
      final controller = buildController();

      final error = controller.saveTrip(
        title: '거꾸로 여행',
        destination: '어딘가',
        startDateKey: '2026-09-14',
        endDateKey: '2026-09-12',
      );

      expect(error, isNotNull);
      expect(controller.trips, isEmpty);
    });

    test('empty title is rejected', () {
      final controller = buildController();

      final error = controller.saveTrip(
        title: '   ',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-14',
      );

      expect(error, isNotNull);
      expect(controller.trips, isEmpty);
    });

    test('trip items only accept dates inside the trip', () {
      final controller = buildController();
      controller.saveTrip(
        title: '가을 제주',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-14',
      );
      final tripId = controller.trips.single.id;

      final inside = controller.saveTripItem(
        tripId: tripId,
        kind: TripItemKind.plan,
        title: '오름 산책',
        dateKey: '2026-09-13',
      );
      final outside = controller.saveTripItem(
        tripId: tripId,
        kind: TripItemKind.plan,
        title: '기간 밖 일정',
        dateKey: '2026-09-20',
      );

      expect(inside, isNull);
      expect(outside, isNotNull);
      expect(controller.tripItemsFor(tripId), hasLength(1));
    });

    test('shortening a trip moves out-of-range item dates back to undecided', () {
      final controller = buildController();
      controller.saveTrip(
        title: '가을 제주',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-14',
      );
      final tripId = controller.trips.single.id;
      controller.saveTripItem(
        tripId: tripId,
        kind: TripItemKind.plan,
        title: '셋째 날 계획',
        dateKey: '2026-09-14',
      );

      controller.saveTrip(
        tripId: tripId,
        title: '가을 제주',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-13',
      );

      expect(controller.tripItemsFor(tripId).single.dateKey, isNull);
    });

    test('check state toggles for packing and plan, not for stay', () {
      final controller = buildController();
      controller.saveTrip(
        title: '가을 제주',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-14',
      );
      final tripId = controller.trips.single.id;
      controller.saveTripItem(
        tripId: tripId,
        kind: TripItemKind.packing,
        title: '충전기',
      );
      controller.saveTripItem(
        tripId: tripId,
        kind: TripItemKind.plan,
        title: '오름 산책',
      );

      final packing = controller
          .tripItemsFor(tripId, kind: TripItemKind.packing)
          .single;
      final plan = controller
          .tripItemsFor(tripId, kind: TripItemKind.plan)
          .single;

      controller.saveTripItem(
        tripId: tripId,
        kind: TripItemKind.stay,
        title: '호텔',
      );
      final stay = controller
          .tripItemsFor(tripId, kind: TripItemKind.stay)
          .single;

      controller.toggleTripItemCheck(packing.id);
      // 계획도 다녀온 뒤 `했다`를 표시할 수 있어야 한다.
      controller.toggleTripItemCheck(plan.id);
      // 숙소는 체크할 대상이 아니다.
      controller.toggleTripItemCheck(stay.id);

      expect(
        controller.tripItemsFor(tripId, kind: TripItemKind.packing).single
            .checked,
        isTrue,
      );
      expect(
        controller.tripItemsFor(tripId, kind: TripItemKind.plan).single.checked,
        isTrue,
      );
      expect(
        controller.tripItemsFor(tripId, kind: TripItemKind.stay).single.checked,
        isFalse,
      );
      expect(controller.tripPackingCheckedCount(tripId), 1);
    });

    test('timeline groups items by day and orders them by time', () {
      final controller = buildController();
      controller.saveTrip(
        title: '가을 제주',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-14',
      );
      final tripId = controller.trips.single.id;

      controller.saveTripItem(
        tripId: tripId,
        kind: TripItemKind.plan,
        title: '저녁 식사',
        dateKey: '2026-09-12',
        timeLabel: '19:00',
      );
      controller.saveTripItem(
        tripId: tripId,
        kind: TripItemKind.transport,
        title: '김포 출발',
        dateKey: '2026-09-12',
        timeLabel: '08:20',
      );
      controller.saveTripItem(
        tripId: tripId,
        kind: TripItemKind.stay,
        title: '오션뷰 호텔',
        dateKey: '2026-09-12',
        endDateKey: '2026-09-14',
      );
      controller.saveTripItem(
        tripId: tripId,
        kind: TripItemKind.plan,
        title: '언제든 가보고 싶은 카페',
      );
      controller.saveTripItem(
        tripId: tripId,
        kind: TripItemKind.packing,
        title: '충전기',
      );

      final days = controller.tripTimelineDays(tripId);

      // 여행 3일 + 날짜 미정 묶음
      expect(days, hasLength(4));
      expect(days.first.dayNumber, 1);
      expect(days.first.dateKey, '2026-09-12');

      // 시각이 있는 항목이 먼저, 시간 미정은 그날 끝에 붙는다.
      expect(
        days.first.items.map((item) => item.title),
        ['김포 출발', '저녁 식사'],
      );

      // 준비물은 목록이라, 숙소는 하룻밤을 통째로 차지해 시각 흐름에 끼우면
      // 어색하므로 둘 다 타임라인 항목에 오지 않는다.
      final timelineTitles = days
          .expand((day) => day.items)
          .map((item) => item.title);
      expect(timelineTitles, isNot(contains('충전기')));
      expect(timelineTitles, isNot(contains('오션뷰 호텔')));

      final undated = days.last;
      expect(undated.isUndated, isTrue);
      expect(undated.dayLabel, '언제든');
      expect(undated.items.single.title, '언제든 가보고 싶은 카페');
    });

    test('a stay covers every night between check-in and check-out', () {
      final controller = buildController();
      controller.saveTrip(
        title: '가을 제주',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-14',
      );
      final tripId = controller.trips.single.id;
      controller.saveTripItem(
        tripId: tripId,
        kind: TripItemKind.stay,
        title: '오션뷰 호텔',
        dateKey: '2026-09-12',
        timeLabel: '15:00',
        endDateKey: '2026-09-14',
        endTimeLabel: '11:00',
      );

      final stay = controller
          .tripItemsFor(tripId, kind: TripItemKind.stay)
          .single;
      expect(stay.stayNightCount, 2);

      // 체크인 밤과 그다음 밤에는 머물고, 체크아웃 당일 밤에는 머물지 않는다.
      expect(
        controller.tripStaysForNight(tripId, '2026-09-12').single.id,
        stay.id,
      );
      expect(
        controller.tripStaysForNight(tripId, '2026-09-13').single.id,
        stay.id,
      );
      expect(controller.tripStaysForNight(tripId, '2026-09-14'), isEmpty);
      expect(
        controller.tripStaysCheckingOut(tripId, '2026-09-14').single.id,
        stay.id,
      );
    });

    test('check-out must come after check-in', () {
      final controller = buildController();
      controller.saveTrip(
        title: '가을 제주',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-14',
      );
      final tripId = controller.trips.single.id;

      expect(
        controller.saveTripItem(
          tripId: tripId,
          kind: TripItemKind.stay,
          title: '거꾸로 숙소',
          dateKey: '2026-09-13',
          endDateKey: '2026-09-12',
        ),
        isNotNull,
      );
      expect(
        controller.saveTripItem(
          tripId: tripId,
          kind: TripItemKind.stay,
          title: '같은 날 숙소',
          dateKey: '2026-09-13',
          endDateKey: '2026-09-13',
        ),
        isNotNull,
      );
      expect(controller.tripItemsFor(tripId), isEmpty);
    });

    test('shrinking a trip keeps check-in but drops an outside check-out', () {
      final controller = buildController();
      controller.saveTrip(
        title: '가을 제주',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-14',
      );
      final tripId = controller.trips.single.id;
      controller.saveTripItem(
        tripId: tripId,
        kind: TripItemKind.stay,
        title: '오션뷰 호텔',
        dateKey: '2026-09-12',
        endDateKey: '2026-09-14',
      );

      controller.saveTrip(
        tripId: tripId,
        title: '가을 제주',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-13',
      );

      final stay = controller.tripItemsFor(tripId).single;
      expect(stay.dateKey, '2026-09-12');
      expect(stay.endDateKey, isNull);
    });

    test('transport keeps a mode, a route and an arrival time', () {
      final controller = buildController();
      controller.saveTrip(
        title: '가을 제주',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-14',
      );
      final tripId = controller.trips.single.id;

      final error = controller.saveTripItem(
        tripId: tripId,
        kind: TripItemKind.transport,
        title: 'KE1201',
        dateKey: '2026-09-12',
        timeLabel: '08:20',
        endTimeLabel: '09:35',
        transportMode: TripTransportMode.flight,
        fromLabel: '김포공항',
        toLabel: '제주공항',
      );

      expect(error, isNull);
      final item = controller.tripItemsFor(tripId).single;
      expect(item.transportMode, TripTransportMode.flight);
      expect(item.fromLabel, '김포공항');
      expect(item.toLabel, '제주공항');
      expect(item.endTimeLabel, '09:35');
    });

    test('arrival time alone is rejected without a departure time', () {
      final controller = buildController();
      controller.saveTrip(
        title: '가을 제주',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-14',
      );
      final tripId = controller.trips.single.id;

      expect(
        controller.saveTripItem(
          tripId: tripId,
          kind: TripItemKind.transport,
          title: 'KE1201',
          dateKey: '2026-09-12',
          endTimeLabel: '09:35',
        ),
        isNotNull,
      );
    });

    test('a plan item never carries transport fields', () {
      final controller = buildController();
      controller.saveTrip(
        title: '가을 제주',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-14',
      );
      final tripId = controller.trips.single.id;

      controller.saveTripItem(
        tripId: tripId,
        kind: TripItemKind.plan,
        title: '오름 산책',
        dateKey: '2026-09-12',
        transportMode: TripTransportMode.car,
        fromLabel: '숙소',
        toLabel: '오름',
      );

      final item = controller.tripItemsFor(tripId).single;
      expect(item.transportMode, isNull);
      expect(item.fromLabel, isNull);
      expect(item.toLabel, isNull);
    });

    test('trip photos accept data URIs within the size cap', () {
      final controller = buildController();
      controller.saveTrip(
        title: '가을 제주',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-14',
      );
      final tripId = controller.trips.single.id;

      expect(
        controller.saveTripPhoto(
          tripId: tripId,
          imageDataUrl: 'https://example.com/photo.jpg',
        ),
        isNotNull,
      );
      expect(
        controller.saveTripPhoto(
          tripId: tripId,
          imageDataUrl:
              'data:image/jpeg;base64,${'A' * kTripPhotoMaxDataUrlLength}',
        ),
        isNotNull,
      );
      expect(
        controller.saveTripPhoto(
          tripId: tripId,
          imageDataUrl: 'data:image/jpeg;base64,AAAA',
          caption: '숙소 앞',
        ),
        isNull,
      );

      expect(controller.tripPhotosFor(tripId), hasLength(1));
      expect(controller.tripPhotoCount(tripId), 1);

      final photoId = controller.tripPhotosFor(tripId).single.id;
      expect(controller.deleteTripPhoto(photoId), isTrue);
      expect(controller.tripPhotosFor(tripId), isEmpty);
    });

    test('day header labels read as 1일차 and a dated weekday', () {
      final controller = buildController();
      controller.saveTrip(
        title: '가을 제주',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-13',
      );
      final tripId = controller.trips.single.id;

      final days = controller.tripTimelineDays(tripId);

      expect(days.first.dayLabel, '1일차');
      // 2026-09-12는 토요일이다.
      expect(days.first.dateLabel, '9월 12일 (토)');
      expect(days[1].dayLabel, '2일차');
      expect(days[1].dateLabel, '9월 13일 (일)');
    });

    test('time label is rejected unless it reads as HH:mm', () {
      final controller = buildController();
      controller.saveTrip(
        title: '가을 제주',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-14',
      );
      final tripId = controller.trips.single.id;

      expect(
        controller.saveTripItem(
          tripId: tripId,
          kind: TripItemKind.transport,
          title: '출발',
          dateKey: '2026-09-12',
          timeLabel: '8시 20분',
        ),
        isNotNull,
      );
      expect(
        controller.saveTripItem(
          tripId: tripId,
          kind: TripItemKind.transport,
          title: '출발',
          dateKey: '2026-09-12',
          timeLabel: '25:00',
        ),
        isNotNull,
      );
      expect(
        controller.saveTripItem(
          tripId: tripId,
          kind: TripItemKind.transport,
          title: '출발',
          dateKey: '2026-09-12',
          timeLabel: '08:20',
        ),
        isNull,
      );
      expect(controller.tripItemsFor(tripId).single.timeLabel, '08:20');
    });

    test('clearing a date also clears the time it belonged to', () {
      final controller = buildController();
      controller.saveTrip(
        title: '가을 제주',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-14',
      );
      final tripId = controller.trips.single.id;
      controller.saveTripItem(
        tripId: tripId,
        kind: TripItemKind.plan,
        title: '오름 산책',
        dateKey: '2026-09-14',
        timeLabel: '10:00',
      );

      controller.saveTrip(
        tripId: tripId,
        title: '가을 제주',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-13',
      );

      final item = controller.tripItemsFor(tripId).single;
      expect(item.dateKey, isNull);
      expect(item.timeLabel, isNull);
    });

    test('only the uploader can caption a photo', () {
      final owner = buildController();
      owner.saveTrip(
        title: '가을 제주',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-13',
      );
      final tripId = owner.trips.single.id;
      owner.saveTripPhoto(
        tripId: tripId,
        imageDataUrl: 'data:image/jpeg;base64,AAAA',
      );
      final photo = owner.tripPhotosFor(tripId).single;

      expect(owner.updateTripPhotoCaption(photo.id, '숙소 앞에서'), isNull);
      expect(owner.tripPhotosFor(tripId).single.caption, '숙소 앞에서');

      // 상대 화면에서는 같은 사진이라도 설명을 고칠 수 없다.
      final partner = AlagagiController.forSession(
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
          data: AlagagiSpaceData(
            trips: owner.trips,
            tripPhotos: owner.tripPhotosFor(tripId),
          ),
        ),
      );

      expect(partner.updateTripPhotoCaption(photo.id, '내가 고침'), isNotNull);
      expect(partner.deleteTripPhoto(photo.id), isFalse);
      expect(partner.tripPhotosFor(tripId).single.caption, '숙소 앞에서');
    });

    test('photo caption keeps the documented limit', () {
      final controller = buildController();
      controller.saveTrip(
        title: '가을 제주',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-13',
      );
      final tripId = controller.trips.single.id;
      controller.saveTripPhoto(
        tripId: tripId,
        imageDataUrl: 'data:image/jpeg;base64,AAAA',
      );
      final photoId = controller.tripPhotosFor(tripId).single.id;

      expect(
        controller.updateTripPhotoCaption(
          photoId,
          '가' * kTripPhotoMaxCaptionLength,
        ),
        isNull,
      );
      expect(
        controller.updateTripPhotoCaption(
          photoId,
          '가' * (kTripPhotoMaxCaptionLength + 1),
        ),
        isNotNull,
      );
      expect(
        controller.tripPhotosFor(tripId).single.caption.length,
        kTripPhotoMaxCaptionLength,
      );
    });

    test('a plan can point at a place saved on the place board', () {
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
                id: 'place_ramen',
                name: '골목 라멘',
                address: '제주시 어딘가',
                category: PlaceCategory.food,
                provider: MapApiProvider.kakao,
                createdByProfileId: 'youngwooUid',
                interestedByProfileIds: {'youngwooUid'},
              ),
            ],
          ),
        ),
      );
      controller.saveTrip(
        title: '가을 제주',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-13',
      );
      final tripId = controller.trips.single.id;

      final error = controller.saveTripItem(
        tripId: tripId,
        kind: TripItemKind.plan,
        title: '점심',
        dateKey: '2026-09-12',
        placeId: 'place_ramen',
        link: 'https://example.com/reserve',
      );

      expect(error, isNull);
      final item = controller.tripItemsFor(tripId).single;
      expect(item.placeId, 'place_ramen');
      expect(item.link, 'https://example.com/reserve');
      expect(controller.placeForTripItem(item)?.name, '골목 라멘');
      expect(
        controller.placeForTripItem(item)?.category,
        PlaceCategory.food,
      );
    });

    test('an unknown place id is rejected', () {
      final controller = buildController();
      controller.saveTrip(
        title: '가을 제주',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-13',
      );
      final tripId = controller.trips.single.id;

      expect(
        controller.saveTripItem(
          tripId: tripId,
          kind: TripItemKind.plan,
          title: '점심',
          placeId: 'place_missing',
        ),
        isNotNull,
      );
      expect(controller.tripItemsFor(tripId), isEmpty);
    });

    test('planning trips read nearest first and past trips most recent', () {
      final controller = buildController();
      controller.saveTrip(
        title: '늦가을',
        destination: '강릉',
        startDateKey: '2026-11-01',
        endDateKey: '2026-11-02',
      );
      controller.saveTrip(
        title: '초가을',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-13',
      );

      expect(
        controller.tripsWithStatus(TripStatus.planning).map((t) => t.title),
        ['초가을', '늦가을'],
      );
    });

    test('same-time items keep the order they were dragged into', () {
      final controller = buildController();
      controller.saveTrip(
        title: '가을 제주',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-13',
      );
      final tripId = controller.trips.single.id;
      for (final title in ['가', '나', '다']) {
        controller.saveTripItem(
          tripId: tripId,
          kind: TripItemKind.plan,
          title: title,
          dateKey: '2026-09-12',
          timeLabel: '09:00',
        );
      }

      // 시각이 같으면 담은 순서를 따른다.
      expect(
        controller.tripTimelineDays(tripId).first.items.map((i) => i.title),
        ['가', '나', '다'],
      );

      controller.reorderTripDayItems(tripId, '2026-09-12', 2, 0);

      expect(
        controller.tripTimelineDays(tripId).first.items.map((i) => i.title),
        ['다', '가', '나'],
      );
    });

    test('packing items can be assigned to one of us, to both, or nobody', () {
      final controller = buildController();
      controller.saveTrip(
        title: '가을 제주',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-13',
      );
      final tripId = controller.trips.single.id;
      controller.saveTripItem(
        tripId: tripId,
        kind: TripItemKind.packing,
        title: '충전기',
      );
      final item = controller.tripItemsFor(tripId).single;

      controller.setTripItemAssignee(item.id, 'minyoungUid');
      expect(
        controller.tripItemsFor(tripId).single.assigneeProfileId,
        'minyoungUid',
      );

      // 같은 사람을 다시 고르면 담당이 풀린다.
      controller.setTripItemAssignee(item.id, 'minyoungUid');
      expect(
        controller.tripItemsFor(tripId).single.assigneeProfileId,
        isNull,
      );

      // 둘 다 챙겨야 하는 것은 `함께`로 둔다.
      controller.setTripItemAssignee(item.id, kTripSharedAssigneeId);
      expect(
        controller.tripItemsFor(tripId).single.assigneeProfileId,
        kTripSharedAssigneeId,
      );

      controller.setTripItemAssignee(item.id, kTripSharedAssigneeId);
      expect(
        controller.tripItemsFor(tripId).single.assigneeProfileId,
        isNull,
      );

      // 우리 둘도 `함께`도 아닌 값은 담당이 될 수 없다.
      controller.setTripItemAssignee(item.id, 'strangerUid');
      expect(
        controller.tripItemsFor(tripId).single.assigneeProfileId,
        isNull,
      );
    });

    test('a shared assignee can be set when the item is created', () {
      final controller = buildController();
      controller.saveTrip(
        title: '가을 제주',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-13',
      );
      final tripId = controller.trips.single.id;

      expect(
        controller.saveTripItem(
          tripId: tripId,
          kind: TripItemKind.packing,
          title: '우산',
          assigneeProfileId: kTripSharedAssigneeId,
        ),
        isNull,
      );
      expect(
        controller.tripItemsFor(tripId).single.assigneeProfileId,
        kTripSharedAssigneeId,
      );

      expect(
        controller.saveTripItem(
          tripId: tripId,
          kind: TripItemKind.packing,
          title: '여권',
          assigneeProfileId: 'strangerUid',
        ),
        isNotNull,
      );
    });

    test('photos can be tagged with a trip day and grouped by it', () {
      final controller = buildController();
      controller.saveTrip(
        title: '가을 제주',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-13',
      );
      final tripId = controller.trips.single.id;
      controller.saveTripPhoto(
        tripId: tripId,
        imageDataUrl: 'data:image/jpeg;base64,AAAA',
      );
      final photoId = controller.tripPhotosFor(tripId).single.id;

      expect(controller.setTripPhotoDateKey(photoId, '2026-09-20'), isNotNull);
      expect(controller.setTripPhotoDateKey(photoId, '2026-09-12'), isNull);
      expect(
        controller.tripPhotosForDate(tripId, '2026-09-12').single.id,
        photoId,
      );
      expect(controller.tripPhotosForDate(tripId, '2026-09-13'), isEmpty);

      expect(controller.setTripPhotoDateKey(photoId, null), isNull);
      expect(controller.tripPhotosForDate(tripId, '2026-09-12'), isEmpty);
    });

    test('a past planning trip asks to be moved, without moving itself', () {
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
        todayDateKey: '2026-09-20',
      );
      controller.saveTrip(
        title: '지난 여행',
        destination: '강릉',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-13',
      );
      final trip = controller.trips.single;

      expect(controller.tripNeedsStatusNudge(trip), isTrue);
      // 물어보기만 하고 스스로 바꾸지는 않는다.
      expect(trip.status, TripStatus.planning);

      controller.setTripStatus(trip.id, TripStatus.done);
      expect(
        controller.tripNeedsStatusNudge(controller.trips.single),
        isFalse,
      );
    });

    test('home shows the nearest upcoming or ongoing trip only', () {
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
        todayDateKey: '2026-09-01',
      );

      expect(controller.upcomingTrip, isNull);

      controller.saveTrip(
        title: '늦가을',
        destination: '강릉',
        startDateKey: '2026-11-01',
        endDateKey: '2026-11-02',
      );
      controller.saveTrip(
        title: '초가을',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-13',
      );

      expect(controller.upcomingTrip?.title, '초가을');
    });

    test('a trip note is saved with the trip', () {
      final controller = buildController();

      expect(
        controller.saveTrip(
          title: '가을 제주',
          destination: '제주도',
          startDateKey: '2026-09-12',
          endDateKey: '2026-09-13',
          note: '여권 만료일 확인하기',
        ),
        isNull,
      );
      expect(controller.trips.single.note, '여권 만료일 확인하기');

      expect(
        controller.saveTrip(
          tripId: controller.trips.single.id,
          title: '가을 제주',
          destination: '제주도',
          startDateKey: '2026-09-12',
          endDateKey: '2026-09-13',
          note: '가' * 501,
        ),
        isNotNull,
      );
    });

    test('only the creator can delete a trip or an item', () async {
      final controller = buildController();
      controller.saveTrip(
        title: '가을 제주',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-14',
      );
      final tripId = controller.trips.single.id;

      expect(await controller.deleteTrip('missing_trip'), isFalse);
      expect(controller.deleteTripItem('missing_item'), isFalse);
      expect(await controller.deleteTrip(tripId), isTrue);
      expect(controller.trips, isEmpty);
    });

    test('status change is explicit and does not follow the calendar', () {
      final controller = buildController();
      controller.saveTrip(
        title: '지난 여행',
        destination: '강릉',
        startDateKey: '2026-01-02',
        endDateKey: '2026-01-03',
      );
      final tripId = controller.trips.single.id;

      expect(controller.trips.single.status, TripStatus.planning);

      controller.setTripStatus(tripId, TripStatus.done);

      expect(controller.tripsWithStatus(TripStatus.done), hasLength(1));
      expect(controller.tripsWithStatus(TripStatus.planning), isEmpty);
    });

    test('saving a trip remembers which one so the screen can open it', () {
      final controller = buildController();

      expect(controller.lastSavedTripId, isNull);

      controller.saveTrip(
        title: '가을 제주',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-14',
      );

      expect(controller.lastSavedTripId, controller.trips.single.id);
    });

    test('openTrip hands the trip over once and then forgets it', () {
      final controller = buildController();
      controller.saveTrip(
        title: '가을 제주',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-14',
      );
      final tripId = controller.trips.single.id;

      controller.openTrip(tripId);

      expect(controller.state.route, AlagagiRoute.trips);
      expect(controller.consumePendingTripId(), tripId);
      // 목록으로 나갔다 돌아올 때 같은 여행이 다시 열리면 안 된다.
      expect(controller.consumePendingTripId(), isNull);
    });

    test('packing can be copied from a past trip without the checks', () {
      final controller = buildController();
      controller.saveTrip(
        title: '지난 강릉',
        destination: '강릉',
        startDateKey: '2026-05-02',
        endDateKey: '2026-05-03',
      );
      final pastTripId = controller.trips.single.id;
      controller.saveTripItem(
        tripId: pastTripId,
        kind: TripItemKind.packing,
        title: '충전기',
      );
      controller.saveTripItem(
        tripId: pastTripId,
        kind: TripItemKind.packing,
        title: '우산',
      );
      final charger = controller
          .tripItemsFor(pastTripId, kind: TripItemKind.packing)
          .firstWhere((item) => item.title == '충전기');
      controller.toggleTripItemCheck(charger.id);

      controller.saveTrip(
        title: '가을 제주',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-14',
      );
      final tripId = controller.lastSavedTripId!;
      controller.saveTripItem(
        tripId: tripId,
        kind: TripItemKind.packing,
        title: '우산',
      );

      expect(controller.tripsWithPackingExcept(tripId), hasLength(1));

      final copied = controller.copyTripPacking(
        fromTripId: pastTripId,
        toTripId: tripId,
      );

      // 이미 있는 '우산'은 건너뛴다.
      expect(copied, 1);
      final packing = controller.tripItemsFor(
        tripId,
        kind: TripItemKind.packing,
      );
      expect(packing.map((item) => item.title), containsAll(['우산', '충전기']));
      // 챙긴 표시는 지난 여행의 것이다. 옮기지 않는다.
      expect(packing.every((item) => !item.checked), isTrue);

      // 다시 눌러도 늘어나지 않는다.
      expect(
        controller.copyTripPacking(fromTripId: pastTripId, toTripId: tripId),
        0,
      );
    });

    test('a planning trip claims its days on the meeting calendar', () {
      final controller = buildController();
      controller.saveTrip(
        title: '가을 제주',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-14',
      );
      final tripId = controller.trips.single.id;

      expect(controller.tripCoveringDate('2026-09-13')?.id, tripId);
      expect(controller.tripCoveringDate('2026-09-15'), isNull);

      // 다녀온 여행은 앞으로의 달력을 더 막지 않는다.
      controller.setTripStatus(tripId, TripStatus.done);
      expect(controller.tripCoveringDate('2026-09-13'), isNull);
    });

    test('reordering a day does not stamp the items as updated', () {
      final controller = buildController();
      controller.saveTrip(
        title: '가을 제주',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-14',
      );
      final tripId = controller.lastSavedTripId!;
      for (final title in ['아침', '점심', '저녁']) {
        controller.saveTripItem(
          tripId: tripId,
          kind: TripItemKind.plan,
          title: title,
          dateKey: '2026-09-12',
        );
      }
      final before = {
        for (final item in controller.tripItemsFor(tripId))
          item.id: item.updatedAt,
      };

      controller.reorderTripDayItems(tripId, '2026-09-12', 2, 0);

      // 순서만 바꾼 것은 상대 홈에 '새로 도착한 것'을 만들지 않는다.
      for (final item in controller.tripItemsFor(tripId)) {
        expect(item.updatedAt, before[item.id]);
      }
      expect(
        controller.tripItemsFor(tripId).map((item) => item.title).first,
        '저녁',
      );
    });

    test('the next item today follows the clock, not the first row', () {
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
        todayDateKey: '2026-09-13',
      );
      controller.saveTrip(
        title: '가을 제주',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-14',
      );
      final tripId = controller.lastSavedTripId!;
      for (final entry in [('09:20', '공항 도착'), ('15:40', '성산일출봉')]) {
        controller.saveTripItem(
          tripId: tripId,
          kind: TripItemKind.plan,
          title: entry.$2,
          dateKey: '2026-09-13',
          timeLabel: entry.$1,
        );
      }

      expect(
        controller.nextTripItemToday(tripId, nowTimeLabel: '08:00')?.title,
        '공항 도착',
      );
      expect(
        controller.nextTripItemToday(tripId, nowTimeLabel: '12:00')?.title,
        '성산일출봉',
      );
      // 오늘 시각이 전부 지났으면 마지막 것을 짚어준다.
      expect(
        controller.nextTripItemToday(tripId, nowTimeLabel: '23:00')?.title,
        '성산일출봉',
      );
    });

    test('trip updates show up as unread activity for the partner', () {
      final controller = buildController();
      controller.saveTrip(
        title: '가을 제주',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-14',
      );

      // 내가 적은 것은 나에게 새 소식이 아니다.
      expect(
        controller.unreadCountForFeature(UnreadActivityFeature.trips),
        0,
      );
    });
  });
}
