import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minyoung_pick/src/domain/alagagi_controller.dart';
import 'package:minyoung_pick/src/ui/alagagi_app.dart';

void main() {
  Future<void> enterSpace(WidgetTester tester) async {
    await tester.enterText(find.byKey(inviteNicknameFieldKey), '영우');
    await tester.ensureVisible(find.text('대화 공간으로 들어가기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('대화 공간으로 들어가기'));
    await tester.pumpAndSettle();
  }

  testWidgets('shows invite and enters home with nickname', (tester) async {
    await tester.pumpWidget(const AlagagiApp());

    expect(find.text('우리, 천천히\n알아가 볼래요?'), findsOneWidget);
    expect(find.text('9:41'), findsNothing);
    expect(find.textContaining('🔋'), findsNothing);

    await enterSpace(tester);

    expect(find.text('알아가기'), findsOneWidget);
    expect(find.text('오늘의 질문'), findsOneWidget);
    expect(find.byKey(homeQuestionCardKey), findsOneWidget);
    expect(find.text("TODAY'S QUESTION"), findsOneWidget);
    expect(find.text('DAY 12'), findsWidgets);
    expect(find.text('아직 내 답을 남기지 않았어요.'), findsOneWidget);
    expect(find.textContaining('답을 남기면'), findsOneWidget);
    expect(find.byKey(homeQuestionAnswerButtonKey), findsOneWidget);
    expect(find.text('지금의 마음을 한 줄로...'), findsNothing);
    expect(find.text('9:41'), findsNothing);
    expect(find.textContaining('🔋'), findsNothing);
  });

  testWidgets('home focused question card fits mobile unanswered state', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const AlagagiApp());
    await enterSpace(tester);

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byKey(alagagiShellKey)), const Size(390, 844));
    expect(find.byKey(homeQuestionCardKey), findsOneWidget);
    expect(find.byKey(homeQuestionAnswerButtonKey), findsOneWidget);
    expect(find.text('지금의 마음을 한 줄로...'), findsNothing);
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

  testWidgets('saves a short comment after partner answer is revealed', (
    tester,
  ) async {
    final controller = AlagagiController()..enterSpace('영우');
    controller
      ..updateDraftAnswer('노을 질 때가 좋아요.')
      ..submitTodayAnswer();

    await tester.pumpWidget(
      MaterialApp(home: AlagagiRoot(controller: controller)),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(answerCommentFieldKey));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(answerCommentFieldKey), '이 답 좋다.');
    await tester.tap(find.byKey(answerCommentSubmitButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('이 답 좋다.'), findsOneWidget);
  });

  testWidgets('keeps comment editor open when an edit is emptied', (
    tester,
  ) async {
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
          answers: [
            Answer(
              questionId: 'q001',
              profileId: 'youngwooUid',
              body: '노을 질 때가 좋아요.',
              createdLabel: '오늘',
            ),
            Answer(
              questionId: 'q001',
              profileId: 'minyoungUid',
              body: '저는 아침 공기가 좋아요.',
              createdLabel: '오늘',
            ),
          ],
          answerComments: [
            AnswerComment(
              questionId: 'q001',
              answerOwnerProfileId: 'minyoungUid',
              commenterProfileId: 'youngwooUid',
              body: '이 답 좋다.',
              createdLabel: '오늘',
            ),
          ],
        ),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(home: AlagagiRoot(controller: controller)),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('댓글 수정하기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('댓글 수정하기'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(answerCommentFieldKey), '');
    await tester.tap(find.byKey(answerCommentSubmitButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(answerCommentFieldKey), findsOneWidget);
    expect(find.text('한 줄만 남겨도 괜찮아요.'), findsOneWidget);
  });

  testWidgets('hides comment composer while partner answer is locked', (
    tester,
  ) async {
    await tester.pumpWidget(const AlagagiApp());
    await enterSpace(tester);

    expect(find.byKey(answerCommentFieldKey), findsNothing);
  });

  testWidgets('renders mobile shell without decorative phone frame', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const AlagagiApp());
    await enterSpace(tester);

    final shell = tester.widget<Container>(find.byKey(alagagiShellKey));
    final decoration = shell.decoration as BoxDecoration?;

    expect(tester.getSize(find.byKey(alagagiShellKey)), const Size(390, 844));
    expect(shell.margin, EdgeInsets.zero);
    expect(decoration?.border, isNull);
    expect(decoration?.borderRadius, isNull);
  });

  testWidgets('archive calendar shows controls weekdays and selected detail', (
    tester,
  ) async {
    final controller =
        AlagagiController.forSession(
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
                answers: [
                  Answer(
                    questionId: 'q019',
                    profileId: 'youngwooUid',
                    body: '작은 약속을 기억해줄 때요.',
                    createdLabel: '6월 7일',
                  ),
                  Answer(
                    questionId: 'q019',
                    profileId: 'minyoungUid',
                    body: '말투가 부드러울 때 오래 기억나요.',
                    createdLabel: '6월 7일',
                  ),
                ],
                answerComments: [
                  AnswerComment(
                    questionId: 'q019',
                    answerOwnerProfileId: 'minyoungUid',
                    commenterProfileId: 'youngwooUid',
                    body: '이 답을 읽으니 마음이 편해졌어요.',
                    createdLabel: '6월 7일',
                  ),
                ],
                dailyProgress: DailyQuestionProgress(
                  startedDateKey: '2026-05-20',
                  currentQuestionId: 'q001',
                  openedDateKey: '2026-06-09',
                ),
              ),
            ),
            todayDateKey: '2026-06-09',
          )
          ..goTo(AlagagiRoute.archive)
          ..selectArchiveDate('2026-06-07');

    await tester.pumpWidget(
      MaterialApp(home: AlagagiRoot(controller: controller)),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(archiveCalendarKey), findsOneWidget);
    expect(find.byKey(archiveCalendarPreviousButtonKey), findsOneWidget);
    expect(find.byKey(archiveCalendarNextButtonKey), findsOneWidget);
    expect(find.byKey(archiveCalendarTodayButtonKey), findsOneWidget);
    expect(find.text('2026년 6월'), findsOneWidget);
    expect(
      find.byKey(archiveCalendarDayButtonKey('2026-06-01')),
      findsOneWidget,
    );
    expect(
      find.byKey(archiveCalendarDayButtonKey('2026-07-05')),
      findsOneWidget,
    );
    for (final label in ['월', '화', '수', '목', '금', '토', '일']) {
      expect(find.text(label), findsOneWidget);
    }

    expect(find.text('6월 7일 · DAY 19'), findsOneWidget);
    expect(find.text('내 답'), findsWidgets);
    expect(find.text('민영님 답'), findsOneWidget);
    expect(find.text('작은 약속을 기억해줄 때요.'), findsWidgets);
    expect(find.text('말투가 부드러울 때 오래 기억나요.'), findsWidgets);
    expect(find.text('내 댓글'), findsWidgets);
    expect(find.text('이 답을 읽으니 마음이 편해졌어요.'), findsWidgets);

    await tester.tap(find.byKey(archiveCalendarTodayButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('6월 9일 · DAY 21'), findsOneWidget);
  });

  testWidgets('archive monthly calendar fits a 6-week mobile grid', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

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
          dailyProgress: DailyQuestionProgress(
            startedDateKey: '2026-08-01',
            currentQuestionId: 'q028',
            openedDateKey: '2026-08-28',
          ),
        ),
      ),
      todayDateKey: '2026-08-28',
    )..goTo(AlagagiRoute.archive);

    await tester.pumpWidget(
      MaterialApp(home: AlagagiRoot(controller: controller)),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('2026년 8월'), findsOneWidget);
    expect(
      find.byKey(archiveCalendarDayButtonKey('2026-07-27')),
      findsOneWidget,
    );
    expect(
      find.byKey(archiveCalendarDayButtonKey('2026-09-06')),
      findsOneWidget,
    );
    expect(find.text('8월 28일 · DAY 28'), findsOneWidget);

    await tester.tap(find.byKey(archiveCalendarDayButtonKey('2026-09-06')));
    await tester.pumpAndSettle();

    expect(find.text('8월 28일 · DAY 28'), findsOneWidget);

    await tester.tap(find.byKey(archiveCalendarNextButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('2026년 9월'), findsOneWidget);
    expect(find.text('9월 28일'), findsOneWidget);
    expect(find.text('아직 열리지 않았어요'), findsWidgets);
    expect(find.byKey(lateAnswerButtonKey), findsNothing);
  });

  testWidgets('archive calendar opens and saves a late answer', (tester) async {
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
          answers: [
            Answer(
              questionId: 'q001',
              profileId: 'youngwooUid',
              body: '아침이 좋아요.',
              createdLabel: '6월 7일',
            ),
            Answer(
              questionId: 'q001',
              profileId: 'minyoungUid',
              body: '저녁이 좋아요.',
              createdLabel: '6월 7일',
            ),
          ],
          dailyProgress: DailyQuestionProgress(
            startedDateKey: '2026-06-07',
            currentQuestionId: 'q001',
            openedDateKey: '2026-06-09',
          ),
        ),
      ),
      todayDateKey: '2026-06-09',
    )..goTo(AlagagiRoute.archive);

    await tester.pumpWidget(
      MaterialApp(home: AlagagiRoot(controller: controller)),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(archiveCalendarKey), findsOneWidget);
    expect(find.byKey(lateAnswerButtonKey), findsNothing);

    await tester.tap(find.byKey(archiveCalendarDayButtonKey('2026-06-08')));
    await tester.pumpAndSettle();

    expect(find.byKey(lateAnswerButtonKey), findsOneWidget);

    await tester.ensureVisible(find.byKey(lateAnswerButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(lateAnswerButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('늦게 답하기'), findsOneWidget);
    expect(find.text('6월 8일 · DAY 2'), findsOneWidget);
    expect(find.text('PAST QUESTION'), findsOneWidget);

    await tester.enterText(find.byKey(answerFieldKey), '늦게 남기는 답이에요.');
    await tester.tap(find.text('저장하기'));
    await tester.pumpAndSettle();

    expect(find.text('질문함'), findsWidgets);
    expect(find.text('늦게 남기는 답이에요.'), findsOneWidget);
  });

  testWidgets('customizes app title and home line from my screen', (
    tester,
  ) async {
    final controller = AlagagiController()
      ..enterSpace('영우')
      ..goTo(AlagagiRoute.my);

    await tester.pumpWidget(
      MaterialApp(home: AlagagiRoot(controller: controller)),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(personalizationAppTitleFieldKey),
      '민영과 영우',
    );
    await tester.enterText(
      find.byKey(personalizationHomeLineFieldKey),
      '천천히 알아가는 중',
    );
    await tester.ensureVisible(find.byKey(personalizationSubmitButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(personalizationSubmitButtonKey));
    await tester.pumpAndSettle();

    await tester.tap(find.text('홈'));
    await tester.pumpAndSettle();

    expect(find.text('민영과 영우'), findsOneWidget);
    expect(find.text('천천히 알아가는 중'), findsOneWidget);
  });

  testWidgets('profile card inline edit can save and cancel a slot', (
    tester,
  ) async {
    final controller = AlagagiController()
      ..enterSpace('영우')
      ..goTo(AlagagiRoute.profileCard)
      ..setProfileCardTab(ProfileCardTab.me);

    await tester.pumpWidget(
      MaterialApp(home: AlagagiRoot(controller: controller)),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(profileSlotEditButtonKey('rest')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(profileSlotEditButtonKey('rest')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(profileSlotFieldKey('rest')),
      '집에서 차 마시기',
    );
    await tester.tap(find.byKey(profileSlotSaveButtonKey('rest')));
    await tester.pumpAndSettle();

    expect(find.text('집에서 차 마시기'), findsOneWidget);

    await tester.tap(find.byKey(profileSlotEditButtonKey('rest')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(profileSlotFieldKey('rest')), '취소될 문장');
    await tester.tap(find.byKey(profileSlotCancelButtonKey('rest')));
    await tester.pumpAndSettle();

    expect(find.text('집에서 차 마시기'), findsOneWidget);
    expect(find.text('취소될 문장'), findsNothing);
  });

  testWidgets('my screen hides implementation terms in user copy', (
    tester,
  ) async {
    final localController = AlagagiController()
      ..enterSpace('영우')
      ..goTo(AlagagiRoute.my);

    await tester.pumpWidget(
      MaterialApp(home: AlagagiRoot(controller: localController)),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('로컬 MVP'), findsNothing);
    expect(find.textContaining('Firebase'), findsNothing);

    final signedInController = AlagagiController()
      ..enterSpace('영우')
      ..goTo(AlagagiRoute.my);
    await tester.pumpWidget(
      MaterialApp(
        home: AlagagiRoot(controller: signedInController, onSignOut: () {}),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('로컬 MVP'), findsNothing);
    expect(find.textContaining('Firebase'), findsNothing);
  });

  testWidgets('uses a low-pressure invite and wishlist tone', (tester) async {
    await tester.pumpWidget(const AlagagiApp());

    expect(find.text('대화 공간으로 들어가기'), findsOneWidget);
    expect(find.text('둘만의 공간'), findsNothing);
    expect(find.text('천천히 가까워지기'), findsNothing);
    expect(find.text('☀️'), findsNothing);
    expect(find.text('🔒'), findsNothing);
    expect(find.text('🌿'), findsNothing);

    await enterSpace(tester);
    await tester.drag(find.byType(Scrollable), const Offset(0, -700));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('언젠가, 같이'));
    await tester.pumpAndSettle();
    expect(find.text('⚖️'), findsNothing);
    expect(find.text('🪪'), findsNothing);
    expect(find.text('✈️'), findsNothing);

    await tester.tap(find.text('언젠가, 같이'));
    await tester.pumpAndSettle();

    expect(find.text('서로 관심'), findsOneWidget);
    expect(find.textContaining('🌱'), findsNothing);
    expect(find.textContaining('🌊'), findsNothing);
    expect(find.textContaining('🍜'), findsNothing);
    expect(find.textContaining('🎬'), findsNothing);
    expect(find.textContaining('🥾'), findsNothing);
    expect(find.textContaining('📷'), findsNothing);
    expect(find.textContaining('☕'), findsNothing);
    expect(find.text('둘 다 ♥'), findsNothing);
    expect(find.textContaining('💚'), findsNothing);
    expect(find.textContaining('🤍'), findsNothing);
  });

  testWidgets('navigates archive, records, and plus screens', (tester) async {
    await tester.pumpWidget(const AlagagiApp());
    await enterSpace(tester);

    await tester.tap(find.text('질문함'));
    await tester.pumpAndSettle();
    expect(find.text('그동안 주고받은 12개의 이야기'), findsOneWidget);

    await tester.tap(find.text('기록'));
    await tester.pumpAndSettle();
    expect(find.text('답변 속 공통점이 조금씩 보여요'), findsOneWidget);

    await tester.tap(find.text('홈'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(Scrollable), const Offset(0, -600));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('밸런스 게임'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('밸런스 게임'));
    await tester.pumpAndSettle();
    expect(find.text('둘 중 하나만!'), findsOneWidget);
    expect(find.text('⚖️'), findsNothing);
    expect(find.textContaining('🌊'), findsNothing);
    expect(find.textContaining('🌲'), findsNothing);

    await tester.tap(find.byKey(subScreenBackButtonKey));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('소개 카드'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('소개 카드'));
    await tester.pumpAndSettle();
    expect(find.textContaining('🎂'), findsNothing);
    expect(find.textContaining('🧭'), findsNothing);
    expect(find.textContaining('🍙'), findsNothing);
    expect(find.textContaining('🎧'), findsNothing);
    expect(find.textContaining('🔒'), findsNothing);
  });

  testWidgets('sub screen header follows soft paper option', (tester) async {
    await tester.pumpWidget(const AlagagiApp());
    await enterSpace(tester);

    await tester.tap(find.text('마이'));
    await tester.pumpAndSettle();

    final backButton = tester.widget<InkWell>(
      find.byKey(subScreenBackButtonKey),
    );
    expect(backButton.child, isA<Container>());

    final backContainer = backButton.child! as Container;
    expect(backContainer.constraints?.minWidth, 38);
    expect(backContainer.constraints?.maxWidth, 38);
    expect(backContainer.constraints?.minHeight, 38);
    expect(backContainer.constraints?.maxHeight, 38);

    final backDecoration = backContainer.decoration! as BoxDecoration;
    expect(backDecoration.color, AlagagiColors.paper);
    expect(backDecoration.borderRadius, BorderRadius.circular(19));

    final backIcon = backContainer.child! as Icon;
    expect(backIcon.icon, Icons.chevron_left_rounded);
    expect(backIcon.size, 21);
    expect(backIcon.color, const Color(0xFF656D5E));

    final titleStyles = tester
        .widgetList<Text>(find.text('마이'))
        .map((text) => text.style)
        .where((style) => style?.fontSize == 18);
    expect(titleStyles, isNotEmpty);
    expect(titleStyles.first!.fontWeight, FontWeight.w700);
    expect(titleStyles.first!.fontFamily, 'Nanum Myeongjo');
  });
}
