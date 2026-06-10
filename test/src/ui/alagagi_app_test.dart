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

    expect(find.text('천천히 알아가는 기록'), findsOneWidget);
    expect(find.text('J O G E U M S S I K'), findsNothing);
    expect(find.text('우리, 천천히\n알아가 볼래요?'), findsOneWidget);
    expect(find.text('알아가기'), findsNothing);
    expect(find.text('9:41'), findsNothing);
    expect(find.textContaining('🔋'), findsNothing);

    await enterSpace(tester);

    expect(find.text('조금씩'), findsOneWidget);
    expect(find.byKey(homeBrandLogoKey), findsOneWidget);
    expect(find.text('천천히 알아가는 기록'), findsOneWidget);
    expect(find.text('J O G E U M S S I K'), findsNothing);
    expect(find.text('알아가기'), findsNothing);
    expect(find.text('오늘의 질문'), findsOneWidget);
    expect(find.byKey(homeQuestionCardKey), findsOneWidget);
    expect(find.text("Today's Question"), findsOneWidget);
    expect(find.text('DAY 12'), findsWidgets);
    expect(find.text('아직 내 답을 남기지 않았어요.'), findsOneWidget);
    expect(find.textContaining('답을 남기면'), findsOneWidget);
    expect(find.byKey(homeQuestionAnswerButtonKey), findsOneWidget);
    expect(find.byKey(homeCuriosityEntryKey), findsOneWidget);
    expect(find.textContaining('궁금함 한 장'), findsOneWidget);
    expect(find.text('지금의 마음을 한 줄로...'), findsNothing);
    expect(find.text('9:41'), findsNothing);
    expect(find.textContaining('🔋'), findsNothing);
  });

  testWidgets('opens the soft curiosity menu from home', (tester) async {
    await tester.pumpWidget(const AlagagiApp());
    await enterSpace(tester);

    await tester.ensureVisible(find.byKey(homeCuriosityEntryKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(homeCuriosityEntryKey));
    await tester.pumpAndSettle();

    expect(find.byKey(homeCuriositySheetKey), findsOneWidget);
    expect(find.text('궁금함 한 장'), findsOneWidget);
    expect(find.textContaining('님이 물었어요'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(homeCuriositySheetKey),
        matching: find.text('요즘 제일 자주 생각나는 건 뭐예요?'),
      ),
      findsOneWidget,
    );
    expect(find.byKey(curiosityReplyFieldKey), findsOneWidget);
    expect(find.text('답장 저장하기'), findsOneWidget);
    expect(find.text('나중에 보기'), findsOneWidget);
    expect(find.byKey(curiosityQuestionFieldKey), findsOneWidget);
    expect(find.text('질문 보내기'), findsOneWidget);
  });

  testWidgets('saves a curiosity reply and a new question in the sheet', (
    tester,
  ) async {
    await tester.pumpWidget(const AlagagiApp());
    await enterSpace(tester);

    await tester.ensureVisible(find.byKey(homeCuriosityEntryKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(homeCuriosityEntryKey));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(curiosityReplyFieldKey),
      '산책하면서 생각을 정리하는 시간이요.',
    );
    await tester.ensureVisible(find.byKey(curiosityReplySubmitButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(curiosityReplySubmitButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('내 답장'), findsOneWidget);
    expect(find.text('산책하면서 생각을 정리하는 시간이요.'), findsOneWidget);

    await tester.enterText(
      find.byKey(curiosityQuestionFieldKey),
      '이번 주에 기대되는 일이 있어요?',
    );
    await tester.ensureVisible(find.byKey(curiosityQuestionSubmitButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(curiosityQuestionSubmitButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('내가 남긴 질문'), findsOneWidget);
    expect(find.text('이번 주에 기대되는 일이 있어요?'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(homeCuriositySheetKey),
        matching: find.textContaining('답장을 기다리는 중'),
      ),
      findsOneWidget,
    );
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
    expect(find.byKey(homeBrandLogoKey), findsOneWidget);
    expect(find.byKey(homeCuriosityEntryKey), findsOneWidget);
    expect(
      tester.getSize(find.byKey(bottomNavigationKey)).height,
      lessThanOrEqualTo(72),
    );
    expect(find.text('지금의 마음을 한 줄로...'), findsNothing);
  });

  testWidgets(
    'bottom navigation reserves space instead of covering scroll content',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(const AlagagiApp());
      await enterSpace(tester);

      final scrollableBottom = tester
          .getBottomLeft(find.byType(Scrollable).first)
          .dy;
      final navTop = tester.getTopLeft(find.byKey(bottomNavigationKey)).dy;

      expect(scrollableBottom, lessThanOrEqualTo(navTop));
    },
  );

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
    expect(find.text('펼쳐 읽기'), findsOneWidget);
    expect(find.text('전체 보기'), findsNothing);

    await tester.ensureVisible(find.text('더 보기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('더 보기'));
    await tester.pumpAndSettle();

    expect(find.textContaining(tail), findsOneWidget);
    expect(find.text('접기'), findsOneWidget);
  });

  testWidgets('opens a full detail sheet from a long today answer preview', (
    tester,
  ) async {
    final controller = AlagagiController()..enterSpace('영우');
    const tail = '끝까지 읽히는 마지막 문장';
    final longAnswer = '${'오늘 생각을 천천히 적어둡니다. ' * 8}$tail';
    controller
      ..updateDraftAnswer(longAnswer)
      ..submitTodayAnswer();

    await tester.pumpWidget(
      MaterialApp(home: AlagagiRoot(controller: controller)),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(readableDetailSheetKey), findsNothing);

    await tester.ensureVisible(find.text('펼쳐 읽기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('펼쳐 읽기'));
    await tester.pumpAndSettle();

    expect(find.byKey(readableDetailSheetKey), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(readableDetailSheetKey),
        matching: find.textContaining(tail),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(readableDetailSheetKey),
        matching: find.text('수정하기'),
      ),
      findsOneWidget,
    );
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
    expect(find.text('펼쳐 읽기'), findsNothing);
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

    await tester.ensureVisible(find.byKey(answerCommentEditButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(answerCommentEditButtonKey));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(answerCommentFieldKey), '');
    await tester.tap(find.byKey(answerCommentSubmitButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(answerCommentFieldKey), findsOneWidget);
    expect(find.text('한 줄만 남겨도 괜찮아요.'), findsOneWidget);
  });

  testWidgets('shows partner comment under my answer as read-only', (
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
              answerOwnerProfileId: 'youngwooUid',
              commenterProfileId: 'minyoungUid',
              body: '이 답을 보니까 장면이 그려져요.',
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

    expect(find.text('민영님의 댓글'), findsOneWidget);
    expect(find.text('이 답을 보니까 장면이 그려져요.'), findsOneWidget);
    expect(find.byKey(answerCommentEditButtonKey), findsNothing);
  });

  testWidgets('cancels an existing comment edit without hiding the comment', (
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

    await tester.ensureVisible(find.byKey(answerCommentEditButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(answerCommentEditButtonKey));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(answerCommentFieldKey), '다른 말');
    await tester.tap(find.byKey(answerCommentCancelButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(answerCommentFieldKey), findsNothing);
    expect(find.text('이 답 좋다.'), findsOneWidget);
    expect(find.text('다른 말'), findsNothing);
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

  testWidgets('archive selected answer opens a readable detail sheet', (
    tester,
  ) async {
    const tail = '달력에서도 끝까지 읽히는 문장';
    final longBody = '${'선택한 날짜에 남긴 긴 답변입니다. ' * 8}$tail';
    final controller =
        AlagagiController.forSession(
            AlagagiSession(
              spaceId: 'main',
              me: const AppProfile(
                id: 'youngwooUid',
                nickname: '영우',
                avatar: '🌿',
                isMe: true,
              ),
              partner: const AppProfile(
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
                    body: longBody,
                    createdLabel: '6월 7일',
                  ),
                  const Answer(
                    questionId: 'q019',
                    profileId: 'minyoungUid',
                    body: '말투가 부드러울 때 오래 기억나요.',
                    createdLabel: '6월 7일',
                  ),
                ],
                dailyProgress: const DailyQuestionProgress(
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

    await tester.ensureVisible(
      find.byKey(answerPreviewBlockKey('q019', 'youngwooUid')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(answerPreviewBlockKey('q019', 'youngwooUid')));
    await tester.pumpAndSettle();

    expect(find.byKey(readableDetailSheetKey), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(readableDetailSheetKey),
        matching: find.textContaining(tail),
      ),
      findsOneWidget,
    );
  });

  testWidgets('archive read-only comment detail does not expose edit action', (
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
                    body: '읽기 전용 댓글은 보기만 할 수 있어요.',
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

    final commentPreview = find.text('읽기 전용 댓글은 보기만 할 수 있어요.').first;
    await tester.ensureVisible(commentPreview);
    await tester.pumpAndSettle();
    await tester.tap(commentPreview);
    await tester.pumpAndSettle();

    expect(find.byKey(readableDetailSheetKey), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(readableDetailSheetKey),
        matching: find.text('수정하기'),
      ),
      findsNothing,
    );
  });

  testWidgets('archive skipped answer is not shown as an empty saved answer', (
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
              body: '',
              createdLabel: '6월 7일',
              skipped: true,
            ),
          ],
          dailyProgress: DailyQuestionProgress(
            startedDateKey: '2026-06-07',
            currentQuestionId: 'q003',
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

    expect(find.text('패스한 질문'), findsWidgets);
    expect(find.text('내 답은 남겼어요.'), findsNothing);
    expect(find.text('내 답 보기'), findsNothing);
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

    expect(find.text('질문'), findsWidgets);
    expect(find.text('늦게 남기는 답이에요.'), findsOneWidget);
  });

  testWidgets('my screen shows a personal dashboard and next actions', (
    tester,
  ) async {
    final controller = AlagagiController.forSession(
      AlagagiSession(
        spaceId: 'main',
        me: const AppProfile(
          id: 'youngwooUid',
          nickname: '영우',
          avatar: '🌿',
          isMe: true,
        ),
        partner: const AppProfile(
          id: 'minyoungUid',
          nickname: '민영',
          avatar: '🪻',
          isMe: false,
        ),
        data: AlagagiSpaceData(
          answers: const [
            Answer(
              questionId: 'q002',
              profileId: 'youngwooUid',
              body: '밤에 조금 조용해지는 시간이 좋아요.',
              createdLabel: '어제',
            ),
          ],
          profileSlots: const [
            ProfileSlotValue(
              profileId: 'youngwooUid',
              slot: ProfileSlot(
                id: 'rest',
                label: '나에게 맞는 속도',
                icon: 'clock',
                value: '천천히 생각하고 말하는 쪽이 편해요.',
              ),
            ),
          ],
          musicNotes: [
            MusicNote(
              id: 'music_mine',
              title: '밤 산책',
              artist: '영우의 추천',
              link: 'https://music.example/night',
              note: '퇴근길에 들으면 마음이 조금 차분해져요.',
              mood: '밤',
              createdByProfileId: 'youngwooUid',
              createdLabel: '오늘',
              updatedAt: DateTime.parse('2026-06-09T09:00:00.000Z'),
            ),
          ],
        ),
      ),
    )..goTo(AlagagiRoute.my);

    await tester.pumpWidget(
      MaterialApp(home: AlagagiRoot(controller: controller)),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(myDashboardKey), findsOneWidget);
    expect(find.text('내 기록'), findsOneWidget);
    expect(find.text('다음에 해볼 것'), findsOneWidget);
    expect(find.text('최근 내 흔적'), findsOneWidget);
    expect(find.text('계정'), findsOneWidget);
    expect(find.text('내 공간 다듬기'), findsNothing);
    expect(find.text('커스텀 저장'), findsNothing);
    expect(find.text('1'), findsWidgets);
    expect(find.text('밤 산책'), findsOneWidget);
    expect(find.text('밤에 조금 조용해지는 시간이 좋아요.'), findsOneWidget);

    await tester.ensureVisible(find.byKey(myNextPrimaryButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(myNextPrimaryButtonKey));
    await tester.pumpAndSettle();

    expect(controller.state.route, AlagagiRoute.answer);

    controller.goTo(AlagagiRoute.my);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(myProfileCardActionButtonKey),
      140,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(myProfileCardActionButtonKey));
    await tester.pumpAndSettle();

    expect(controller.state.route, AlagagiRoute.profileCard);
    expect(controller.state.profileCardTab, ProfileCardTab.me);

    controller.goTo(AlagagiRoute.my);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(myMusicActionButtonKey),
      140,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(myMusicActionButtonKey));
    await tester.pumpAndSettle();

    expect(controller.state.route, AlagagiRoute.music);
    expect(controller.state.editingMusicNoteId, 'music_mine');
  });

  testWidgets('my recent trace card opens the full saved text', (tester) async {
    const tail = '최근 흔적 팝업에서 보여야 하는 마지막 문장';
    final longAnswer = '${'최근 남긴 답변을 조금 길게 적어둡니다. ' * 8}$tail';
    final controller = AlagagiController.forSession(
      AlagagiSession(
        spaceId: 'main',
        me: const AppProfile(
          id: 'youngwooUid',
          nickname: '영우',
          avatar: '🌿',
          isMe: true,
        ),
        partner: const AppProfile(
          id: 'minyoungUid',
          nickname: '민영',
          avatar: '🪻',
          isMe: false,
        ),
        data: AlagagiSpaceData(
          answers: [
            Answer(
              questionId: 'q002',
              profileId: 'youngwooUid',
              body: longAnswer,
              createdLabel: '어제',
            ),
          ],
        ),
      ),
    )..goTo(AlagagiRoute.my);

    await tester.pumpWidget(
      MaterialApp(home: AlagagiRoot(controller: controller)),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(myTraceCardKey('question')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(myTraceCardKey('question')));
    await tester.pumpAndSettle();

    expect(find.byKey(readableDetailSheetKey), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(readableDetailSheetKey),
        matching: find.textContaining(tail),
      ),
      findsOneWidget,
    );
  });

  testWidgets('profile card focused editor can save and cancel a slot', (
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

    expect(find.text('TODAY PICK'), findsOneWidget);
    expect(find.byKey(profileCategoryChipKey('전체')), findsOneWidget);
    expect(find.byKey(profileCategoryChipKey('취향')), findsOneWidget);
    expect(find.byKey(profileCategoryChipKey('하루')), findsOneWidget);
    expect(find.text('2 / 24'), findsOneWidget);

    await tester.ensureVisible(find.byKey(profileRecommendedSlotButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(profileRecommendedSlotButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(profileEditorPanelKey), findsOneWidget);
    expect(find.text('카드 저장'), findsOneWidget);

    await tester.enterText(
      find.byKey(profileSlotFieldKey('rest')),
      '집에서 차 마시기',
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(profileSlotSaveButtonKey('rest')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(profileSlotSaveButtonKey('rest')));
    await tester.pumpAndSettle();

    expect(find.text('집에서 차 마시기'), findsOneWidget);
    expect(find.byKey(profileSlotReadButtonKey('rest')), findsOneWidget);
    expect(find.text('전체 보기'), findsNothing);

    await tester.ensureVisible(find.byKey(profileSlotEditButtonKey('rest')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(profileSlotEditButtonKey('rest')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(profileSlotFieldKey('rest')), '취소될 문장');
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(profileSlotCancelButtonKey('rest')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(profileSlotCancelButtonKey('rest')));
    await tester.pumpAndSettle();

    expect(find.text('집에서 차 마시기'), findsOneWidget);
    expect(find.text('취소될 문장'), findsNothing);
  });

  testWidgets('partner profile card shows only filled read cards', (
    tester,
  ) async {
    final controller = AlagagiController()
      ..enterSpace('영우')
      ..goTo(AlagagiRoute.profileCard)
      ..setProfileCardTab(ProfileCardTab.partner);

    await tester.pumpWidget(
      MaterialApp(home: AlagagiRoot(controller: controller)),
    );
    await tester.pumpAndSettle();

    expect(find.text('채워진 답만 보여요'), findsOneWidget);
    expect(find.text('매콤한 분식이나 따뜻한 국물'), findsOneWidget);
    expect(find.text('아직 비어 있어요'), findsNothing);
    expect(find.byKey(profileRecommendedSlotButtonKey), findsNothing);
    expect(find.text('이 질문 쓰기'), findsNothing);
    expect(find.byKey(profileSlotReadButtonKey('food')), findsOneWidget);
    expect(find.text('전체 보기'), findsNothing);

    await tester.ensureVisible(find.byKey(profileSlotReadButtonKey('food')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(profileSlotReadButtonKey('food')));
    await tester.pumpAndSettle();

    expect(find.byKey(readableDetailSheetKey), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(readableDetailSheetKey),
        matching: find.textContaining('매콤한 분식이나 따뜻한 국물'),
      ),
      findsOneWidget,
    );
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

    expect(find.text('서로 관심'), findsWidgets);
    expect(find.byKey(wishlistBoardKey), findsOneWidget);
    expect(find.text('서로 관심 있어요'), findsOneWidget);
    expect(find.text('조용한 제안'), findsOneWidget);
    expect(find.text('함께했어요'), findsOneWidget);
    expect(find.byKey(wishAddButtonKey), findsOneWidget);
    expect(tester.getCenter(find.byKey(wishAddButtonKey)).dy, lessThan(620));
    expect(find.textContaining('추천'), findsNothing);
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

    await tester.tap(find.text('질문'));
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
    expect(find.byKey(balanceDeckKey), findsOneWidget);
    expect(find.text('짧게 고르고,\n나중에 이야기로 이어져요'), findsOneWidget);
    expect(find.textContaining('궁합'), findsNothing);
    expect(find.textContaining('%'), findsNothing);
    expect(find.textContaining('점수'), findsNothing);
    expect(find.textContaining('완벽'), findsNothing);
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

  testWidgets('home and records avoid score-like percent copy', (tester) async {
    await tester.pumpWidget(const AlagagiApp());
    await enterSpace(tester);

    expect(find.textContaining('%'), findsNothing);
    expect(find.textContaining('점수'), findsNothing);
    expect(find.textContaining('지수'), findsNothing);

    await tester.tap(find.text('질문'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('기록'));
    await tester.pumpAndSettle();

    expect(find.textContaining('%'), findsNothing);
    expect(find.textContaining('점수'), findsNothing);
    expect(find.textContaining('지수'), findsNothing);
    expect(find.text('함께 답한 질문'), findsWidgets);
  });

  testWidgets('balance next action waits until an option is selected', (
    tester,
  ) async {
    await tester.pumpWidget(const AlagagiApp());
    await enterSpace(tester);

    await tester.drag(find.byType(Scrollable), const Offset(0, -600));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('밸런스 게임'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('밸런스 게임'));
    await tester.pumpAndSettle();

    final beforeSelection = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, '먼저 하나를 골라주세요'),
    );
    expect(beforeSelection.onPressed, isNull);

    await tester.tap(find.text('조용한 바다'));
    await tester.pumpAndSettle();

    final afterSelection = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, '다음 질문'),
    );
    expect(afterSelection.onPressed, isNotNull);
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

  testWidgets('bottom navigation exposes questions music and my tabs', (
    tester,
  ) async {
    await tester.pumpWidget(const AlagagiApp());
    await enterSpace(tester);

    expect(find.text('홈'), findsOneWidget);
    expect(find.text('질문'), findsOneWidget);
    expect(find.text('음악'), findsOneWidget);
    expect(find.text('마이'), findsOneWidget);
    expect(find.text('질문함'), findsNothing);
    expect(find.text('기록'), findsNothing);

    await tester.tap(find.text('질문'));
    await tester.pumpAndSettle();
    expect(find.text('질문'), findsWidgets);
    expect(find.text('달력'), findsOneWidget);
    expect(find.text('기록'), findsOneWidget);
    expect(find.byKey(archiveCalendarKey), findsOneWidget);

    await tester.tap(find.text('기록'));
    await tester.pumpAndSettle();
    expect(find.text('답변 속 공통점이 조금씩 보여요'), findsOneWidget);
  });

  testWidgets('music tab adds a lightweight song note', (tester) async {
    await tester.pumpWidget(const AlagagiApp());
    await enterSpace(tester);

    await tester.tap(find.text('음악'));
    await tester.pumpAndSettle();

    expect(find.text('음악 노트'), findsOneWidget);
    expect(find.byKey(musicAddButtonKey), findsOneWidget);
    expect(find.text('한 곡 남기기'), findsOneWidget);
    expect(
      tester.getCenter(find.byKey(musicAddButtonKey)).dy,
      closeTo(tester.getCenter(find.text('들어볼 곡')).dy, 24),
    );

    await tester.tap(find.byKey(musicAddButtonKey));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(musicTitleFieldKey), '새벽 산책');
    await tester.enterText(find.byKey(musicArtistFieldKey), '민영의 추천');
    await tester.enterText(
      find.byKey(musicLinkFieldKey),
      'https://music.example/night',
    );
    await tester.enterText(find.byKey(musicNoteFieldKey), '새벽에 들으면 생각이 정리돼요.');
    await tester.ensureVisible(find.text('집중'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('집중'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(musicSubmitButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(musicSubmitButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('새벽 산책'), findsOneWidget);
    expect(find.textContaining('새벽에 들으면'), findsOneWidget);
    expect(find.text('노래 남기기'), findsNothing);
    expect(find.textContaining('커플'), findsNothing);
    expect(find.textContaining('사랑'), findsNothing);
  });

  testWidgets('music tab edits an existing own song note', (tester) async {
    final controller = AlagagiController.forSession(
      AlagagiSession(
        spaceId: 'main',
        me: const AppProfile(
          id: 'youngwooUid',
          nickname: '영우',
          avatar: '🌿',
          isMe: true,
        ),
        partner: const AppProfile(
          id: 'minyoungUid',
          nickname: '민영',
          avatar: '🪻',
          isMe: false,
        ),
        data: AlagagiSpaceData(
          musicNotes: [
            MusicNote(
              id: 'music_mine',
              title: '밤 산책',
              artist: '영우의 추천',
              link: 'https://music.example/night',
              note: '퇴근길에 들으면 차분해져요.',
              mood: '밤',
              createdByProfileId: 'youngwooUid',
              createdLabel: '오늘',
              updatedAt: DateTime.parse('2026-06-09T09:00:00.000Z'),
            ),
            MusicNote(
              id: 'music_partner',
              title: '오후의 문장',
              artist: '민영의 추천',
              link: 'https://music.example/afternoon',
              note: '카페에서 듣기 좋아요.',
              mood: '카페',
              createdByProfileId: 'minyoungUid',
              createdLabel: '오늘',
              updatedAt: DateTime.parse('2026-06-09T10:00:00.000Z'),
            ),
          ],
        ),
      ),
    )..goTo(AlagagiRoute.music);

    await tester.pumpWidget(
      MaterialApp(home: AlagagiRoot(controller: controller)),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(musicEditButtonKey('music_mine')), findsOneWidget);
    expect(find.byKey(musicEditButtonKey('music_partner')), findsNothing);

    await tester.scrollUntilVisible(
      find.byKey(musicEditButtonKey('music_mine')),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(musicEditButtonKey('music_mine')));
    await tester.pumpAndSettle();

    expect(find.text('음악 노트 다듬기'), findsOneWidget);
    final titleEditable = tester.widget<EditableText>(
      find.descendant(
        of: find.byKey(musicTitleFieldKey),
        matching: find.byType(EditableText),
      ),
    );
    expect(titleEditable.controller.text, '밤 산책');

    await tester.enterText(find.byKey(musicTitleFieldKey), '다시 듣는 밤 산책');
    await tester.enterText(find.byKey(musicNoteFieldKey), '조금 더 천천히 듣고 싶어서요.');
    await tester.scrollUntilVisible(
      find.byKey(musicSubmitButtonKey),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(musicSubmitButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('다시 듣는 밤 산책'), findsOneWidget);
    expect(find.text('밤 산책'), findsNothing);
    expect(find.text('조금 더 천천히 듣고 싶어서요.'), findsOneWidget);
    expect(
      controller.musicNotes.where((note) => note.id == 'music_mine'),
      hasLength(1),
    );
  });

  testWidgets('music note card opens a full detail sheet', (tester) async {
    const tail = '음악 메모 팝업에서 보여야 하는 마지막 문장';
    final longNote = '${'퇴근길에 들으면 차분해져서 남겨둔 메모입니다. ' * 4}$tail';
    final controller = AlagagiController.forSession(
      AlagagiSession(
        spaceId: 'main',
        me: const AppProfile(
          id: 'youngwooUid',
          nickname: '영우',
          avatar: '🌿',
          isMe: true,
        ),
        partner: const AppProfile(
          id: 'minyoungUid',
          nickname: '민영',
          avatar: '🪻',
          isMe: false,
        ),
        data: AlagagiSpaceData(
          musicNotes: [
            MusicNote(
              id: 'music_mine',
              title: '밤 산책',
              artist: '영우의 추천',
              link: 'https://music.example/night',
              note: longNote,
              mood: '밤',
              createdByProfileId: 'youngwooUid',
              createdLabel: '오늘',
              updatedAt: DateTime.parse('2026-06-09T09:00:00.000Z'),
            ),
          ],
        ),
      ),
    )..goTo(AlagagiRoute.music);

    await tester.pumpWidget(
      MaterialApp(home: AlagagiRoot(controller: controller)),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(musicNoteCardKey('music_mine')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(musicNoteCardKey('music_mine')));
    await tester.pumpAndSettle();

    expect(find.byKey(readableDetailSheetKey), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(readableDetailSheetKey),
        matching: find.textContaining(tail),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(readableDetailSheetKey),
        matching: find.textContaining('https://music.example/night'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('home summary marks new partner music until music tab is seen', (
    tester,
  ) async {
    final seenStore = MemoryMusicNoteSeenStore()
      ..writeLastSeenMusicNoteAt(
        'main',
        'youngwooUid',
        DateTime.parse('2026-06-09T08:00:00.000Z'),
      );
    final controller = AlagagiController.forSession(
      AlagagiSession(
        spaceId: 'main',
        me: const AppProfile(
          id: 'youngwooUid',
          nickname: '영우',
          avatar: '🌿',
          isMe: true,
        ),
        partner: const AppProfile(
          id: 'minyoungUid',
          nickname: '민영',
          avatar: '🪻',
          isMe: false,
        ),
        data: AlagagiSpaceData(
          musicNotes: [
            MusicNote(
              id: 'music_partner_new',
              title: '밤 산책',
              artist: '민영의 추천',
              link: 'https://music.example/night',
              note: '퇴근길에 들으면 차분해져요.',
              mood: '밤',
              createdByProfileId: 'minyoungUid',
              createdLabel: '오늘',
              updatedAt: DateTime.parse('2026-06-09T10:00:00.000Z'),
            ),
          ],
        ),
      ),
      musicNoteSeenStore: seenStore,
    );

    await tester.pumpWidget(
      MaterialApp(home: AlagagiRoot(controller: controller)),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(homeProgressSummaryKey), findsOneWidget);
    expect(find.text('둘 다 답한 질문'), findsOneWidget);
    expect(find.text('새 음악 노트가 있어요'), findsOneWidget);

    await tester.tap(find.text('음악'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('홈'));
    await tester.pumpAndSettle();

    expect(find.text('새 음악 노트가 있어요'), findsNothing);
    expect(find.text('최근 음악 노트 1곡'), findsOneWidget);
  });

  testWidgets(
    'first visit guide appears once and stores start choice locally',
    (tester) async {
      final guideStore = MemoryFirstVisitGuideStore();
      const session = AlagagiSession(
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
      );
      final controller = AlagagiController.forSession(
        session,
        firstVisitGuideStore: guideStore,
      );

      await tester.pumpWidget(
        MaterialApp(home: AlagagiRoot(controller: controller)),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(firstVisitGuideSheetKey), findsOneWidget);
      expect(find.text('처음 방문 안내'), findsOneWidget);
      expect(find.text('오늘은 여기서 시작하면 충분해요'), findsOneWidget);
      expect(find.text('오늘 질문에 답하기'), findsOneWidget);
      expect(find.text('한 곡 남기기'), findsOneWidget);
      expect(find.text('언젠가 같이 담기'), findsOneWidget);
      expect(find.textContaining('하트'), findsNothing);
      expect(find.textContaining('커플'), findsNothing);

      await tester.ensureVisible(find.byKey(firstVisitGuideStartButtonKey));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(firstVisitGuideStartButtonKey));
      await tester.pumpAndSettle();

      expect(find.byKey(firstVisitGuideSheetKey), findsNothing);
      expect(guideStore.hasSeenFirstVisitGuide('main', 'youngwooUid'), isTrue);

      final returningController = AlagagiController.forSession(
        session,
        firstVisitGuideStore: guideStore,
      );
      await tester.pumpWidget(
        MaterialApp(home: AlagagiRoot(controller: returningController)),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(firstVisitGuideSheetKey), findsNothing);
    },
  );

  testWidgets('first visit tour and my help reopen the guide book', (
    tester,
  ) async {
    final guideStore = MemoryFirstVisitGuideStore();
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
        data: AlagagiSpaceData(),
      ),
      firstVisitGuideStore: guideStore,
    );

    await tester.pumpWidget(
      MaterialApp(home: AlagagiRoot(controller: controller)),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(firstVisitGuideTourButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(firstVisitGuideTourButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(firstVisitGuideSheetKey), findsNothing);
    expect(find.byKey(firstVisitGuideBookSheetKey), findsOneWidget);
    expect(find.text('헷갈릴 때만 다시 보는 안내서'), findsOneWidget);
    expect(guideStore.hasSeenFirstVisitGuide('main', 'youngwooUid'), isTrue);

    await tester.tap(find.byIcon(Icons.close_rounded).last);
    await tester.pumpAndSettle();

    controller.goTo(AlagagiRoute.my);
    await tester.pumpAndSettle();

    expect(find.text('도움말'), findsOneWidget);
    expect(find.byKey(myFirstVisitGuideButtonKey), findsOneWidget);

    await tester.ensureVisible(find.byKey(myFirstVisitGuideButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(myFirstVisitGuideButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(firstVisitGuideBookSheetKey), findsOneWidget);
    expect(find.text('처음 안내 다시 보기'), findsWidgets);
  });

  testWidgets(
    'comment save failure shows a retry action instead of disappearing',
    (tester) async {
      final repository = _FailingCommentRepository();
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
          ),
        ),
        repository: repository,
      );

      await tester.pumpWidget(
        MaterialApp(home: AlagagiRoot(controller: controller)),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(answerCommentFieldKey));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(answerCommentFieldKey), '이 답 좋다.');
      await tester.tap(find.byKey(answerCommentSubmitButtonKey));
      await tester.pumpAndSettle();

      expect(find.text('댓글 저장 다시 시도'), findsOneWidget);

      repository.failCommentSaves = false;
      await tester.tap(find.text('댓글 저장 다시 시도'));
      await tester.pumpAndSettle();

      expect(find.text('댓글 저장 다시 시도'), findsNothing);
      expect(repository.savedAnswerComments.single.comment.body, '이 답 좋다.');
    },
  );
}

class _FailingCommentRepository implements AlagagiDataRepository {
  bool failCommentSaves = true;
  final List<({String spaceId, AnswerComment comment})> savedAnswerComments =
      [];

  @override
  Future<AlagagiSession?> loadSession(AlagagiAuthUser user) async => null;

  @override
  Future<void> saveAnswer(String spaceId, Answer answer) async {}

  @override
  Future<void> saveAnswerComment(String spaceId, AnswerComment comment) async {
    if (failCommentSaves) {
      throw StateError('comment save failed');
    }
    savedAnswerComments.add((spaceId: spaceId, comment: comment));
  }

  @override
  Future<void> saveBalanceSelection(
    String spaceId,
    BalanceSelection selection,
  ) async {}

  @override
  Future<void> saveDailyQuestionProgress(
    String spaceId,
    DailyQuestionProgress progress,
  ) async {}

  @override
  Future<void> saveMusicNote(String spaceId, MusicNote note) async {}

  @override
  Future<void> saveCuriosityCard(String spaceId, CuriosityCard card) async {}

  @override
  Future<void> saveProfileSlot(
    String spaceId,
    String profileId,
    ProfileSlot slot,
  ) async {}

  @override
  Future<void> saveSpacePersonalization(
    String spaceId,
    SpacePersonalization personalization,
  ) async {}

  @override
  Future<void> saveWish(String spaceId, WishItem wish) async {}
}
