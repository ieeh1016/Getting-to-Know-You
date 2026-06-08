import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minyoung_pick/src/ui/minyoung_pick_app.dart';

void main() {
  testWidgets('renders the Minyoung Pick MVP content', (tester) async {
    await tester.pumpWidget(const MinyoungPickApp());

    expect(find.text('민영 Pick'), findsOneWidget);
    expect(find.text('성수 카페'), findsOneWidget);
    expect(find.text('한강 산책'), findsOneWidget);
    expect(find.text('작은 전시'), findsOneWidget);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -700));
    await tester.pumpAndSettle();

    expect(find.text('커피 한 잔권'), findsOneWidget);
  });

  testWidgets('selects one date option', (tester) async {
    await tester.pumpWidget(const MinyoungPickApp());

    await tester.tap(find.text('한강 산책'));
    await tester.pump();

    expect(find.text('선택됨'), findsOneWidget);
  });

  testWidgets('shows the next date idea', (tester) async {
    await tester.pumpWidget(const MinyoungPickApp());

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -260));
    await tester.pumpAndSettle();

    expect(find.text('디저트 먼저 먹기'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.refresh_rounded));
    await tester.pump();

    expect(find.text('가볍게 산책'), findsOneWidget);
    expect(find.text('디저트 먼저 먹기'), findsNothing);
  });
}
