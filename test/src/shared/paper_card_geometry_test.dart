import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minyoung_pick/src/shared/ui_components.dart';
import 'package:minyoung_pick/src/shared/ui_style.dart';

BoxDecoration _decorationOf(WidgetTester tester) {
  final container = tester.widget<Container>(
    find
        .descendant(
          of: find.byType(AlagagiPaperCard),
          matching: find.byType(Container),
        )
        .first,
  );
  return container.decoration! as BoxDecoration;
}

EdgeInsets _paddingOf(WidgetTester tester) {
  final container = tester.widget<Container>(
    find
        .descendant(
          of: find.byType(AlagagiPaperCard),
          matching: find.byType(Container),
        )
        .first,
  );
  return container.padding! as EdgeInsets;
}

void main() {
  testWidgets('default paper card uses the standard card shape', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: AlagagiPaperCard(child: Text('본문'))),
      ),
    );

    expect(
      _decorationOf(tester).borderRadius,
      BorderRadius.circular(AlagagiCardGeometry.radius),
    );
    expect(_paddingOf(tester), AlagagiCardGeometry.padding);
  });

  testWidgets('compact paper card uses the dense list card shape', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AlagagiPaperCard(compact: true, child: Text('본문')),
        ),
      ),
    );

    expect(
      _decorationOf(tester).borderRadius,
      BorderRadius.circular(AlagagiCardGeometry.compactRadius),
    );
    expect(_paddingOf(tester), AlagagiCardGeometry.compactPadding);
  });
}
