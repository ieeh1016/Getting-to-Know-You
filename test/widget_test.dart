import 'package:flutter_test/flutter_test.dart';

import 'package:minyoung_pick/main.dart' as app;

void main() {
  testWidgets('app starts with the invite title', (tester) async {
    await app.main();
    await tester.pump();

    expect(find.text('우리, 천천히\n알아가 볼래요?'), findsOneWidget);
  });
}
