import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minyoung_pick/src/app/test_keys.dart';
import 'package:minyoung_pick/src/shared/picker_sheets.dart';

void main() {
  Future<void> pumpHost(
    WidgetTester tester,
    Future<void> Function(BuildContext context) onPressed,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        // 이 환경의 ink_sparkle 셰이더가 깨져 있어 splash를 끄고 검증한다.
        theme: ThemeData(splashFactory: NoSplash.splashFactory),
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () => onPressed(context),
                child: const Text('열기'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('date picker returns the tapped day and honours bounds', (
    tester,
  ) async {
    DateTime? picked;
    await pumpHost(tester, (context) async {
      picked = await showAlagagiDatePicker(
        context,
        title: '떠나는 날',
        initialDate: DateTime(2026, 9, 12),
        firstDate: DateTime(2026, 9, 10),
        lastDate: DateTime(2026, 9, 20),
      );
    });

    await tester.tap(find.text('열기'));
    await tester.pumpAndSettle();

    // 고른 날짜가 있는 달로 열린다.
    expect(find.text('2026년 9월'), findsOneWidget);

    // 범위 밖 날짜는 눌러도 아무 일이 없다.
    await tester.tap(find.byKey(datePickerDayButtonKey('2026-09-09')));
    await tester.pumpAndSettle();
    expect(find.byKey(datePickerDayButtonKey('2026-09-14')), findsOneWidget);

    await tester.tap(find.byKey(datePickerDayButtonKey('2026-09-14')));
    await tester.pumpAndSettle();

    expect(picked, DateTime(2026, 9, 14));
  });

  testWidgets('date picker moves between months', (tester) async {
    await pumpHost(tester, (context) async {
      await showAlagagiDatePicker(
        context,
        title: '떠나는 날',
        initialDate: DateTime(2026, 9, 12),
      );
    });

    await tester.tap(find.text('열기'));
    await tester.pumpAndSettle();
    expect(find.text('2026년 9월'), findsOneWidget);

    await tester.tap(find.byKey(datePickerNextMonthButtonKey));
    await tester.pumpAndSettle();
    expect(find.text('2026년 10월'), findsOneWidget);

    await tester.tap(find.byKey(datePickerPreviousMonthButtonKey));
    await tester.tap(find.byKey(datePickerPreviousMonthButtonKey));
    await tester.pumpAndSettle();
    expect(find.text('2026년 8월'), findsOneWidget);
  });

  testWidgets('time picker previews the value and returns HH:mm', (
    tester,
  ) async {
    String? picked;
    await pumpHost(tester, (context) async {
      picked = await showAlagagiTimePicker(
        context,
        title: '출발 시각',
        initialLabel: '08:20',
      );
    });

    await tester.tap(find.text('열기'));
    await tester.pumpAndSettle();

    // 들어온 값을 그대로 미리 보여준다.
    expect(
      tester.widget<Text>(find.byKey(timePickerPreviewKey)).data,
      '08:20',
    );

    await tester.tap(find.byKey(timePickerHourButtonKey(9)));
    await tester.pumpAndSettle();
    expect(
      tester.widget<Text>(find.byKey(timePickerPreviewKey)).data,
      '09:20',
    );

    await tester.tap(find.byKey(timePickerConfirmButtonKey));
    await tester.pumpAndSettle();

    expect(picked, '09:20');
  });

  testWidgets('time picker snaps a stray minute to the nearest step', (
    tester,
  ) async {
    await pumpHost(tester, (context) async {
      await showAlagagiTimePicker(
        context,
        title: '출발 시각',
        initialLabel: '08:23',
      );
    });

    await tester.tap(find.text('열기'));
    await tester.pumpAndSettle();

    expect(
      tester.widget<Text>(find.byKey(timePickerPreviewKey)).data,
      '08:25',
    );
  });
}
