import 'package:flutter_test/flutter_test.dart';

import 'package:minyoung_pick/main.dart' as app;

void main() {
  testWidgets('app starts with the product title', (tester) async {
    app.main();
    await tester.pump();

    expect(find.text('민영 Pick'), findsOneWidget);
  });
}
