import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minyoung_pick/src/shared/text_editing_sync.dart';

void main() {
  test('IME-safe controller defers changes while composing', () {
    final values = <String>[];
    final controller = ImeSafeTextEditingController(
      onCommittedChanged: values.add,
    );

    controller.value = const TextEditingValue(
      text: 'a',
      selection: TextSelection.collapsed(offset: 1),
      composing: TextRange(start: 0, end: 1),
    );

    expect(values, isEmpty);

    controller.value = const TextEditingValue(
      text: 'ab',
      selection: TextSelection.collapsed(offset: 2),
    );

    expect(values, ['ab']);

    controller.dispose();
  });

  testWidgets('IME-safe controller dispatches current text on focus loss', (
    tester,
  ) async {
    final values = <String>[];
    final controller = ImeSafeTextEditingController(
      onCommittedChanged: values.add,
    );
    final focusNode = FocusNode();
    final detachFocusDispatch = dispatchTextOnFocusLost(controller, focusNode);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TextField(controller: controller, focusNode: focusNode),
        ),
      ),
    );

    focusNode.requestFocus();
    await tester.pump();

    controller.value = const TextEditingValue(
      text: 'a',
      selection: TextSelection.collapsed(offset: 1),
      composing: TextRange(start: 0, end: 1),
    );

    expect(values, isEmpty);

    focusNode.unfocus();
    await tester.pump();

    expect(values, ['a']);

    detachFocusDispatch();
    focusNode.dispose();
    controller.dispose();
  });
}
