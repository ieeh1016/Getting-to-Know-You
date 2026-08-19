import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minyoung_pick/src/domain/alagagi_controller.dart';
import 'package:minyoung_pick/src/ui/alagagi_app.dart';

/// 여행을 앱처럼 편하게 쓰기 위한 손놀림들.
///
/// 여기 담긴 것은 전부 "다시 찾아 올라가지 않는다", "sheet를 여닫지 않는다",
/// "잘못 고른 것을 되돌릴 수 있다"에 관한 것이다.
void main() {
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
    )..goTo(AlagagiRoute.trips);
  }

  String seedTrip(
    AlagagiController controller, {
    String title = '가을 제주',
    String start = '2026-09-12',
    String end = '2026-09-14',
  }) {
    controller.saveTrip(
      title: title,
      destination: '제주도',
      startDateKey: start,
      endDateKey: end,
    );
    return controller.lastSavedTripId!;
  }

  Future<void> pumpTrips(
    WidgetTester tester,
    AlagagiController controller,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        // 이 환경의 test engine은 Material 3 기본 splash shader
        // (`shaders/ink_sparkle.frag`)를 읽지 못한다. 여행 화면 동작과
        // 상관없는 실패라 splash를 끄고 본다.
        theme: ThemeData(splashFactory: NoSplash.splashFactory),
        home: AlagagiRoot(controller: controller),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> openTripDetail(
    WidgetTester tester,
    AlagagiController controller,
    String tripId,
  ) async {
    await tester.ensureVisible(find.byKey(tripCardKey(tripId)));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(tripCardKey(tripId)));
    await tester.pumpAndSettle();
  }

  /// sheet 안은 자체 스크롤 영역이고 저장 button이 아래를 덮고 있다.
  /// 목록 아래쪽 줄은 보이더라도 그대로는 눌리지 않는다.
  Future<void> tapInSheet(
    WidgetTester tester,
    Key sheetKey,
    Finder target,
  ) async {
    final scrollable = find.descendant(
      of: find.byKey(sheetKey),
      matching: find.byType(Scrollable),
    );
    if (scrollable.evaluate().isNotEmpty) {
      await tester.scrollUntilVisible(target, 80, scrollable: scrollable.first);
      final viewportHeight =
          tester.view.physicalSize.height / tester.view.devicePixelRatio;
      for (var attempt = 0; attempt < 4; attempt += 1) {
        if (tester.getCenter(target).dy < viewportHeight - 160) {
          break;
        }
        await tester.drag(scrollable.first, const Offset(0, -80));
        await tester.pumpAndSettle();
      }
    }
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  Future<void> openItemForm(
    WidgetTester tester,
    TripItemKind kind,
  ) async {
    await tester.ensureVisible(find.byKey(tripItemAddButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(tripItemAddButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(tripKindPickerOptionKey(kind.storageKey)));
    await tester.pumpAndSettle();
  }

  testWidgets('long trips get a day rail that stays with the tab bar', (
    tester,
  ) async {
    final controller = buildController();
    final tripId = seedTrip(controller);
    await pumpTrips(tester, controller);
    await openTripDetail(tester, controller, tripId);

    // 3일 이상이면 날짜로 건너뛸 수 있다.
    expect(find.byKey(tripDayRailKey), findsOneWidget);
    expect(find.byKey(tripDayJumpButtonKey('2026-09-13')), findsOneWidget);

    await tester.tap(find.byKey(tripDayJumpButtonKey('2026-09-13')));
    await tester.pumpAndSettle();

    // 눌러도 상세에 머문다. tab 줄은 고정이라 여전히 보인다.
    expect(find.byKey(tripKindTabKey('timeline')), findsOneWidget);
  });

  testWidgets('a short trip does not get a day rail', (tester) async {
    final controller = buildController();
    final tripId = seedTrip(controller, start: '2026-09-12', end: '2026-09-13');
    await pumpTrips(tester, controller);
    await openTripDetail(tester, controller, tripId);

    expect(find.byKey(tripDayRailKey), findsNothing);
  });

  testWidgets('packing can be added one after another without reopening', (
    tester,
  ) async {
    final controller = buildController();
    final tripId = seedTrip(controller);
    await pumpTrips(tester, controller);
    await openTripDetail(tester, controller, tripId);

    await openItemForm(tester, TripItemKind.packing);
    await tester.enterText(find.byKey(tripItemTitleFieldKey), '충전기');
    await tester.tap(find.byKey(tripItemKeepAddingButtonKey));
    await tester.pumpAndSettle();

    // sheet는 열린 채로 남고, 담은 것을 알려준다.
    expect(find.byKey(tripItemFormSheetKey), findsOneWidget);
    expect(find.byKey(tripItemKeepAddingNoticeKey), findsOneWidget);
    expect(
      controller.tripItemsFor(tripId, kind: TripItemKind.packing),
      hasLength(1),
    );

    await tester.enterText(find.byKey(tripItemTitleFieldKey), '멀미약');
    await tester.tap(find.byKey(tripItemKeepAddingButtonKey));
    await tester.pumpAndSettle();

    expect(
      controller
          .tripItemsFor(tripId, kind: TripItemKind.packing)
          .map((item) => item.title),
      containsAll(['충전기', '멀미약']),
    );
  });

  testWidgets('a wrongly chosen kind can be changed inside the form', (
    tester,
  ) async {
    final controller = buildController();
    final tripId = seedTrip(controller);
    controller.saveTripItem(
      tripId: tripId,
      kind: TripItemKind.packing,
      title: '충전기',
    );
    await pumpTrips(tester, controller);
    await openTripDetail(tester, controller, tripId);

    await tester.tap(find.byKey(tripKindTabKey('packing')));
    await tester.pumpAndSettle();
    final item = controller
        .tripItemsFor(tripId, kind: TripItemKind.packing)
        .single;
    await tester.ensureVisible(find.byKey(tripItemEditButtonKey(item.id)));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(tripItemEditButtonKey(item.id)));
    await tester.pumpAndSettle();

    await tapInSheet(
      tester,
      tripItemFormSheetKey,
      find.byKey(tripItemKindFieldKey),
    );
    await tester.tap(
      find.byKey(tripKindPickerOptionKey(TripItemKind.plan.storageKey)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(tripItemSubmitButtonKey));
    await tester.pumpAndSettle();

    expect(
      controller.tripItemsFor(tripId, kind: TripItemKind.packing),
      isEmpty,
    );
    expect(
      controller.tripItemsFor(tripId, kind: TripItemKind.plan).single.title,
      '충전기',
    );
  });

  testWidgets('a picked time can be cleared again', (tester) async {
    final controller = buildController();
    final tripId = seedTrip(controller);
    controller.saveTripItem(
      tripId: tripId,
      kind: TripItemKind.plan,
      title: '저녁 식사',
      dateKey: '2026-09-12',
      timeLabel: '19:00',
    );
    await pumpTrips(tester, controller);
    await openTripDetail(tester, controller, tripId);

    final item = controller
        .tripItemsFor(tripId, kind: TripItemKind.plan)
        .single;
    await tester.ensureVisible(find.byKey(tripTimelineEntryKey(item.id)));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(tripTimelineEntryKey(item.id)));
    await tester.pumpAndSettle();

    expect(find.byKey(tripItemTimeClearButtonKey), findsOneWidget);
    await tapInSheet(
      tester,
      tripItemFormSheetKey,
      find.byKey(tripItemTimeClearButtonKey),
    );
    await tester.tap(find.byKey(tripItemSubmitButtonKey));
    await tester.pumpAndSettle();

    expect(
      controller.tripItemsFor(tripId, kind: TripItemKind.plan).single.timeLabel,
      isNull,
    );
  });

  testWidgets('packing can be pulled over from a past trip', (tester) async {
    final controller = buildController();
    final pastTripId = seedTrip(
      controller,
      title: '지난 강릉',
      start: '2026-05-02',
      end: '2026-05-03',
    );
    controller.saveTripItem(
      tripId: pastTripId,
      kind: TripItemKind.packing,
      title: '충전기',
    );
    final tripId = seedTrip(controller);
    await pumpTrips(tester, controller);
    await openTripDetail(tester, controller, tripId);

    await tester.tap(find.byKey(tripKindTabKey('packing')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(tripPackingCopyButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(tripPackingCopyButtonKey));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(tripPackingSourceOptionKey(pastTripId)));
    await tester.pumpAndSettle();

    expect(find.byKey(tripPackingNoticeKey), findsOneWidget);
    expect(
      controller
          .tripItemsFor(tripId, kind: TripItemKind.packing)
          .single
          .title,
      '충전기',
    );
  });

  testWidgets('a wish can be carried into a trip plan', (tester) async {
    final controller = buildController();
    final tripId = seedTrip(controller);
    controller.startWishDraft();
    controller.setWishDraftKind(WishKind.place);
    controller.updateWishDraftTitle('노천탕 있는 곳에서 하루');
    controller.submitWishDraft();
    await pumpTrips(tester, controller);
    await openTripDetail(tester, controller, tripId);

    await openItemForm(tester, TripItemKind.plan);
    await tester.tap(find.byKey(tripItemWishFieldKey));
    await tester.pumpAndSettle();

    final wishId = controller.wishesForTripPlan().single.id;
    await tester.tap(find.byKey(tripWishPickerOptionKey(wishId)));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(tripItemSubmitButtonKey));
    await tester.pumpAndSettle();

    expect(
      controller.tripItemsFor(tripId, kind: TripItemKind.plan).single.title,
      '노천탕 있는 곳에서 하루',
    );
  });

  testWidgets('the budget card names what nobody was credited for', (
    tester,
  ) async {
    final controller = buildController();
    final tripId = seedTrip(controller);
    controller.saveTripItem(
      tripId: tripId,
      kind: TripItemKind.plan,
      title: '숙소값',
      cost: 120000,
      paidByProfileId: 'youngwooUid',
    );
    controller.saveTripItem(
      tripId: tripId,
      kind: TripItemKind.plan,
      title: '기념품',
      cost: 20000,
    );
    await pumpTrips(tester, controller);
    await openTripDetail(tester, controller, tripId);

    await tester.ensureVisible(find.byKey(tripBudgetSummaryKey));
    await tester.pumpAndSettle();

    expect(find.byKey(tripBudgetUnattributedKey), findsOneWidget);
    expect(find.byKey(tripBudgetSettlementKey), findsOneWidget);
  });

  testWidgets('the meeting calendar shows which days a trip already holds', (
    tester,
  ) async {
    final controller = buildController();
    seedTrip(controller);
    controller.selectMeetingDate('2026-09-13');
    controller.goTo(AlagagiRoute.meetings);
    await pumpTrips(tester, controller);

    await tester.ensureVisible(find.byKey(meetingCalendarKey));
    await tester.pumpAndSettle();

    expect(
      find.byKey(meetingTripDayIndicatorKey('2026-09-13')),
      findsOneWidget,
    );
    expect(find.byKey(meetingTripDayIndicatorKey('2026-09-20')), findsNothing);
  });
}
