import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minyoung_pick/src/domain/alagagi_controller.dart';
import 'package:minyoung_pick/src/ui/alagagi_app.dart';

void main() {
  Future<void> enterSpace(WidgetTester tester) async {
    await tester.enterText(find.byKey(inviteNicknameFieldKey), '영우');
    await tester.ensureVisible(find.text('우리 공간으로 들어가기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('우리 공간으로 들어가기'));
    await tester.pumpAndSettle();
  }

  testWidgets('shows invite and enters home with nickname', (tester) async {
    await tester.pumpWidget(const AlagagiApp());

    expect(find.text('우리, 천천히\n알아가 볼래요?'), findsOneWidget);

    await enterSpace(tester);

    expect(find.text('알아가기'), findsOneWidget);
    expect(find.text('오늘의 질문'), findsOneWidget);
  });

  testWidgets('submits today answer and reveals partner answer', (
    tester,
  ) async {
    await tester.pumpWidget(const AlagagiApp());
    await enterSpace(tester);

    await tester.ensureVisible(find.text('답 남기기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('답 남기기'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(answerFieldKey), '노을 질 때가 좋아요.');
    await tester.tap(find.text('답 남기고 영우님 답 열어보기'));
    await tester.pumpAndSettle();

    expect(find.text('노을 질 때가 좋아요.'), findsOneWidget);
    expect(find.textContaining('공기가 조금 조용해지는 시간'), findsOneWidget);
  });

  testWidgets('edits today answer from home with existing text prefilled', (
    tester,
  ) async {
    await tester.pumpWidget(const AlagagiApp());
    await enterSpace(tester);

    await tester.ensureVisible(find.text('답 남기기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('답 남기기'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(answerFieldKey), '처음 남긴 답이에요.');
    await tester.tap(find.text('답 남기고 영우님 답 열어보기'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(editAnswerButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(editAnswerButtonKey));
    await tester.pumpAndSettle();

    final editable = tester.widget<EditableText>(find.byType(EditableText));
    expect(editable.controller.text, '처음 남긴 답이에요.');

    await tester.enterText(find.byKey(answerFieldKey), '조금 더 다듬은 답이에요.');
    await tester.tap(find.text('수정 저장하기'));
    await tester.pumpAndSettle();

    expect(find.text('조금 더 다듬은 답이에요.'), findsOneWidget);
    expect(find.textContaining('공기가 조금 조용해지는 시간'), findsOneWidget);
  });

  testWidgets('expands and collapses a long today answer preview', (
    tester,
  ) async {
    final controller = AlagagiController()..enterSpace('영우');
    const tail = '마지막문장';
    final longAnswer = '${'차분하게 이어지는 생각을 적어둡니다. ' * 8}$tail';
    controller
      ..updateDraftAnswer(longAnswer)
      ..submitTodayAnswer();

    await tester.pumpWidget(
      MaterialApp(home: AlagagiRoot(controller: controller)),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining(tail), findsNothing);
    expect(find.text('더 보기'), findsOneWidget);

    await tester.ensureVisible(find.text('더 보기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('더 보기'));
    await tester.pumpAndSettle();

    expect(find.textContaining(tail), findsOneWidget);
    expect(find.text('접기'), findsOneWidget);
  });

  testWidgets('navigates archive, records, and plus screens', (tester) async {
    await tester.pumpWidget(const AlagagiApp());
    await enterSpace(tester);

    await tester.tap(find.text('질문함'));
    await tester.pumpAndSettle();
    expect(find.text('그동안 주고받은 12개의 이야기'), findsOneWidget);

    await tester.tap(find.text('기록'));
    await tester.pumpAndSettle();
    expect(find.text('생각보다 결이 잘 맞는 사이예요'), findsOneWidget);

    await tester.tap(find.text('홈'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(Scrollable), const Offset(0, -600));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('밸런스 게임'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('밸런스 게임'));
    await tester.pumpAndSettle();
    expect(find.text('둘 중 하나만!'), findsOneWidget);
  });
}
