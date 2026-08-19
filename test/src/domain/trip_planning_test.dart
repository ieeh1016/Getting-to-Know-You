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

    test('check state only toggles for packing items', () {
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

      controller.toggleTripItemCheck(packing.id);
      controller.toggleTripItemCheck(plan.id);

      expect(
        controller.tripItemsFor(tripId, kind: TripItemKind.packing).single
            .checked,
        isTrue,
      );
      expect(
        controller.tripItemsFor(tripId, kind: TripItemKind.plan).single.checked,
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

    test('only the creator can delete a trip or an item', () {
      final controller = buildController();
      controller.saveTrip(
        title: '가을 제주',
        destination: '제주도',
        startDateKey: '2026-09-12',
        endDateKey: '2026-09-14',
      );
      final tripId = controller.trips.single.id;

      expect(controller.deleteTrip('missing_trip'), isFalse);
      expect(controller.deleteTripItem('missing_item'), isFalse);
      expect(controller.deleteTrip(tripId), isTrue);
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
  });
}
