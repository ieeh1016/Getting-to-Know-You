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
        title: '체크인',
        dateKey: '2026-09-12',
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
        ['김포 출발', '저녁 식사', '체크인'],
      );

      // 준비물은 시간 흐름이 아니라 목록이라 타임라인에 오지 않는다.
      expect(
        days.expand((day) => day.items).map((item) => item.title),
        isNot(contains('충전기')),
      );

      final undated = days.last;
      expect(undated.isUndated, isTrue);
      expect(undated.dayLabel, '언제든');
      expect(undated.items.single.title, '언제든 가보고 싶은 카페');
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
