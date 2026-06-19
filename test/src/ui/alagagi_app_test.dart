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
    expect(find.byKey(homeMenuButtonKey), findsOneWidget);
    expect(find.byKey(homeCuriosityEntryKey), findsNothing);
    expect(find.text('닮은 취향 키워드'), findsNothing);
    expect(find.textContaining('궁금함 한 장'), findsNothing);
    expect(find.text('지금의 마음을 한 줄로...'), findsNothing);
    expect(find.text('9:41'), findsNothing);
    expect(find.textContaining('🔋'), findsNothing);
  });

  testWidgets('opens the soft curiosity menu from home', (tester) async {
    await tester.pumpWidget(const AlagagiApp());
    await enterSpace(tester);

    await tester.tap(find.byKey(homeMenuButtonKey));
    await tester.pumpAndSettle();
    expect(find.byKey(homeMenuSheetKey), findsOneWidget);
    expect(find.byKey(homeMenuCuriosityButtonKey), findsOneWidget);
    expect(find.byKey(homeMenuStockStoryButtonKey), findsOneWidget);
    expect(find.byKey(homeMenuImprovementButtonKey), findsOneWidget);
    expect(find.byKey(homeMenuBalanceButtonKey), findsOneWidget);
    expect(find.byKey(homeMenuProfileCardButtonKey), findsOneWidget);
    expect(find.byKey(homeMenuWishlistButtonKey), findsOneWidget);

    await tester.tap(find.byKey(homeMenuCuriosityButtonKey));
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

    await tester.tap(find.byKey(homeMenuButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(homeMenuCuriosityButtonKey));
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
    expect(find.text('답장을 기다리는 질문이 있어요'), findsOneWidget);
    expect(find.byKey(curiosityQuestionFieldKey), findsNothing);
    expect(find.text('답장 기다리는 중'), findsWidgets);
  });

  testWidgets('opens stock story from the home menu without a home card', (
    tester,
  ) async {
    await tester.pumpWidget(const AlagagiApp());
    await enterSpace(tester);

    expect(find.byKey(homeCuriosityEntryKey), findsNothing);
    expect(find.text('주식 이야기'), findsNothing);

    await tester.tap(find.byKey(homeMenuButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(homeMenuSheetKey), findsOneWidget);
    expect(find.text('궁금함 한 장'), findsOneWidget);
    expect(find.text('주식 이야기'), findsOneWidget);
    expect(find.byKey(homeMenuImprovementButtonKey), findsOneWidget);
    expect(find.byKey(homeMenuBalanceButtonKey), findsOneWidget);
    expect(find.byKey(homeMenuProfileCardButtonKey), findsOneWidget);
    expect(find.byKey(homeMenuWishlistButtonKey), findsOneWidget);

    await tester.tap(find.byKey(homeMenuStockStoryButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('주식 이야기'), findsOneWidget);
    expect(find.byKey(stockStoryAddButtonKey), findsOneWidget);
    expect(find.text('주식'), findsNothing);
    expect(find.text('홈'), findsOneWidget);
    expect(find.text('질문'), findsOneWidget);
    expect(find.text('음악'), findsOneWidget);
    expect(find.text('약속'), findsOneWidget);
    expect(find.text('장소'), findsOneWidget);
    expect(find.text('마이'), findsOneWidget);
  });

  testWidgets('improvement board opens from menu and saves a post', (
    tester,
  ) async {
    await tester.pumpWidget(const AlagagiApp());
    await enterSpace(tester);

    await tester.tap(find.byKey(homeMenuButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(homeMenuImprovementButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('건의함'), findsOneWidget);
    expect(find.byKey(improvementAddButtonKey), findsOneWidget);

    await tester.tap(find.byKey(improvementAddButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(improvementCategoryKey('추가 요청')));
    await tester.enterText(find.byKey(improvementTitleFieldKey), '루틴 공유');
    await tester.enterText(
      find.byKey(improvementBodyFieldKey),
      '서로의 반복 일정을 함께 볼 수 있으면 좋겠어요.',
    );
    await tester.ensureVisible(find.byKey(improvementSubmitButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(improvementSubmitButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('루틴 공유'), findsOneWidget);
    expect(find.textContaining('반복 일정'), findsOneWidget);
    expect(find.text('추가 요청'), findsWidgets);
  });

  testWidgets('improvement board owners can edit and delete their posts', (
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
          improvementPosts: [
            ImprovementPost(
              id: 'improvement_mine',
              title: '장소 화면',
              body: '지도를 볼 때 카드가 조금 덜 겹치면 좋겠어요.',
              category: '개선',
              createdByProfileId: 'youngwooUid',
              createdLabel: '오늘',
              updatedAt: DateTime.parse('2026-06-10T09:00:00.000Z'),
            ),
            ImprovementPost(
              id: 'improvement_partner',
              title: '음악 정렬',
              body: '아직 안 들은 노래를 먼저 보면 좋겠어요.',
              category: '아이디어',
              createdByProfileId: 'minyoungUid',
              createdLabel: '오늘',
              updatedAt: DateTime.parse('2026-06-10T08:00:00.000Z'),
            ),
          ],
        ),
      ),
    )..goTo(AlagagiRoute.improvements);

    await tester.pumpWidget(
      MaterialApp(home: AlagagiRoot(controller: controller)),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(improvementEditButtonKey('improvement_mine')),
      findsOneWidget,
    );
    expect(
      find.byKey(improvementDeleteButtonKey('improvement_mine')),
      findsOneWidget,
    );
    expect(
      find.byKey(improvementEditButtonKey('improvement_partner')),
      findsNothing,
    );

    await tester.ensureVisible(
      find.byKey(improvementEditButtonKey('improvement_mine')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(improvementEditButtonKey('improvement_mine')));
    await tester.pumpAndSettle();
    expect(find.text('수정 저장'), findsOneWidget);

    await tester.enterText(find.byKey(improvementTitleFieldKey), '지도 화면');
    await tester.enterText(
      find.byKey(improvementBodyFieldKey),
      '지도 조작 중에는 카드가 덜 가리면 좋겠어요.',
    );
    await tester.ensureVisible(find.byKey(improvementSubmitButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(improvementSubmitButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('지도 화면'), findsOneWidget);
    expect(find.textContaining('지도 조작'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(improvementDeleteButtonKey('improvement_mine')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(improvementDeleteButtonKey('improvement_mine')),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(improvementCardKey('improvement_mine')), findsNothing);
    expect(
      find.byKey(improvementCardKey('improvement_partner')),
      findsOneWidget,
    );
  });

  testWidgets('improvement board owner replies and moves completed posts', (
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
          role: 'owner',
        ),
        partner: const AppProfile(
          id: 'minyoungUid',
          nickname: '민영',
          avatar: '🪻',
          isMe: false,
        ),
        data: AlagagiSpaceData(
          improvementPosts: [
            ImprovementPost(
              id: 'improvement_partner',
              title: '루틴 공유',
              body: '서로의 반복 일정을 볼 수 있으면 좋겠어요.',
              category: '추가 요청',
              createdByProfileId: 'minyoungUid',
              createdLabel: '오늘',
              updatedAt: DateTime.parse('2026-06-10T08:00:00.000Z'),
            ),
          ],
        ),
      ),
    )..goTo(AlagagiRoute.improvements);

    await tester.pumpWidget(
      MaterialApp(home: AlagagiRoot(controller: controller)),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(improvementCardKey('improvement_partner')),
      findsOneWidget,
    );
    expect(
      find.byKey(improvementOwnerNoteFieldKey('improvement_partner')),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(improvementOwnerNoteFieldKey('improvement_partner')),
      '루틴 공유는 다음 개선 후보로 반영했어요.',
    );
    await tester.ensureVisible(
      find.byKey(improvementOwnerNoteSaveButtonKey('improvement_partner')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(improvementOwnerNoteSaveButtonKey('improvement_partner')),
    );
    await tester.pumpAndSettle();

    expect(find.text('영우 답변'), findsOneWidget);
    expect(
      controller.improvementPosts.single.ownerNote,
      '루틴 공유는 다음 개선 후보로 반영했어요.',
    );

    await tester.ensureVisible(
      find.byKey(improvementResolveButtonKey('improvement_partner')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(improvementResolveButtonKey('improvement_partner')),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(improvementCardKey('improvement_partner')), findsNothing);
    expect(find.text('진행중인 건의는 없어요.'), findsOneWidget);

    await tester.tap(find.byKey(improvementFilterButtonKey('resolved')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(improvementCardKey('improvement_partner')),
      findsOneWidget,
    );
    expect(find.text('개선완료'), findsWidgets);
    expect(controller.improvementPosts.single.resolved, isTrue);
  });

  testWidgets('home menu works as a feature launcher', (tester) async {
    await tester.pumpWidget(const AlagagiApp());
    await enterSpace(tester);

    await tester.tap(find.byKey(homeMenuButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(homeMenuBalanceButtonKey));
    await tester.pumpAndSettle();
    expect(find.byKey(balanceDeckKey), findsOneWidget);

    await tester.tap(find.byKey(subScreenBackButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(homeMenuButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(homeMenuProfileCardButtonKey));
    await tester.pumpAndSettle();
    expect(find.text('소개 카드'), findsOneWidget);

    await tester.tap(find.byKey(subScreenBackButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(homeMenuButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(homeMenuWishlistButtonKey));
    await tester.pumpAndSettle();
    expect(find.byKey(wishlistBoardKey), findsOneWidget);
  });

  testWidgets('stock story screen adds a quiet stock story', (tester) async {
    await tester.pumpWidget(const AlagagiApp());
    await enterSpace(tester);

    await tester.tap(find.byKey(homeMenuButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(homeMenuStockStoryButtonKey));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(stockStoryAddButtonKey));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(stockStoryNameFieldKey), 'Nvidia');
    await tester.enterText(
      find.byKey(stockStoryReasonFieldKey),
      '데이터센터 매출 흐름을 같이 보고 싶어요.',
    );
    await tester.ensureVisible(find.text('자세히 적기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('자세히 적기'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(stockStoryUpsideFieldKey),
      '구독 매출과 생태계 유지력',
    );
    await tester.enterText(find.byKey(stockStoryRiskFieldKey), '기기 교체 수요 둔화');
    await tester.enterText(
      find.byKey(stockStoryQuestionFieldKey),
      '다음 실적에서 어떤 숫자를 먼저 볼까요?',
    );
    await tester.ensureVisible(find.byKey(stockStorySubmitButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(stockStorySubmitButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('Nvidia'), findsOneWidget);
    expect(find.textContaining('데이터센터 매출'), findsOneWidget);
    expect(find.text('매수'), findsNothing);
    expect(find.text('매도'), findsNothing);
    expect(find.text('수익률'), findsNothing);
  });

  testWidgets(
    'stock holdings tab shares a held stock without a new home card',
    (tester) async {
      await tester.pumpWidget(const AlagagiApp());
      await enterSpace(tester);

      await tester.tap(find.byKey(homeMenuButtonKey));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(homeMenuStockStoryButtonKey));
      await tester.pumpAndSettle();

      expect(find.byKey(stockStoryTabStoriesKey), findsOneWidget);
      expect(find.byKey(stockStoryTabHoldingsKey), findsOneWidget);
      expect(find.byKey(stockHoldingAddButtonKey), findsNothing);

      await tester.tap(find.byKey(stockStoryTabHoldingsKey));
      await tester.pumpAndSettle();

      expect(find.text('보유'), findsWidgets);
      expect(find.byKey(stockHoldingAddButtonKey), findsOneWidget);
      expect(find.text('함께 보유 중'), findsWidgets);

      await tester.ensureVisible(find.byKey(stockHoldingAddButtonKey));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(stockHoldingAddButtonKey));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(stockHoldingNameFieldKey), 'Microsoft');
      await tester.enterText(
        find.byKey(stockHoldingReasonFieldKey),
        '클라우드 매출 흐름을 믿고 조금 들고 있어요.',
      );
      await tester.ensureVisible(find.text('자세히 적기'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('자세히 적기'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(stockHoldingWatchFieldKey),
        'Azure 성장률',
      );
      await tester.enterText(
        find.byKey(stockHoldingConcernFieldKey),
        'AI 투자 비용 부담',
      );
      await tester.enterText(
        find.byKey(stockHoldingQuestionFieldKey),
        '다음 실적에서 어떤 숫자를 같이 보면 좋을까요?',
      );
      await tester.ensureVisible(find.byKey(stockHoldingSubmitButtonKey));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(stockHoldingSubmitButtonKey));
      await tester.pumpAndSettle();

      expect(find.text('Microsoft'), findsOneWidget);
      expect(find.textContaining('클라우드 매출'), findsOneWidget);
      expect(find.text('보유 중'), findsWidgets);
      expect(find.text('매수'), findsNothing);
      expect(find.text('매도'), findsNothing);
      expect(find.text('수익률'), findsNothing);
    },
  );

  testWidgets('stock lists filter reply needs shared holdings and status', (
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
          stockStories: [
            StockStory(
              id: 'story_mine',
              name: '내 관심 종목',
              reason: '내가 흐름을 보고 싶어서 남겼어요.',
              upside: '구독 매출',
              risk: '성장 둔화',
              question: '같이 어떤 숫자를 볼까요?',
              createdByProfileId: 'youngwooUid',
              createdLabel: '오늘',
              updatedAt: DateTime.parse('2026-06-10T09:00:00.000Z'),
            ),
            StockStory(
              id: 'story_partner_waiting',
              name: '답장 필요한 종목',
              reason: '상대가 의견을 기다리고 있어요.',
              upside: '현금흐름',
              risk: '비용 증가',
              question: '이 리스크를 어떻게 봐요?',
              createdByProfileId: 'minyoungUid',
              createdLabel: '오늘',
              updatedAt: DateTime.parse('2026-06-10T10:00:00.000Z'),
            ),
            StockStory(
              id: 'story_partner_replied',
              name: '답장 끝난 종목',
              reason: '이미 짧게 답한 이야기예요.',
              upside: '브랜드 힘',
              risk: '환율',
              question: '계속 볼까요?',
              createdByProfileId: 'minyoungUid',
              createdLabel: '어제',
              replyTone: '같이 볼래요',
              reply: '다음 실적까지 같이 봐요.',
              repliedByProfileId: 'youngwooUid',
              repliedLabel: '오늘',
              updatedAt: DateTime.parse('2026-06-10T11:00:00.000Z'),
            ),
          ],
          stockHoldings: [
            StockHolding(
              id: 'holding_mine_msft',
              name: 'Microsoft',
              status: '보유 중',
              weightLabel: '보통',
              reason: '클라우드 매출 흐름을 보고 있어요.',
              watchPoint: 'Azure 성장률',
              concern: 'AI 투자 비용',
              question: '다음 실적에서 뭘 볼까요?',
              createdByProfileId: 'youngwooUid',
              createdLabel: '오늘',
              updatedAt: DateTime.parse('2026-06-10T12:00:00.000Z'),
            ),
            StockHolding(
              id: 'holding_partner_msft',
              name: 'Microsoft',
              status: '보유 중',
              weightLabel: '작게',
              reason: '상대도 같은 종목을 들고 있어요.',
              watchPoint: '마진',
              concern: '밸류에이션',
              question: '비중을 유지해도 될까요?',
              createdByProfileId: 'minyoungUid',
              createdLabel: '오늘',
              replyTone: '더 찾아볼게요',
              reply: '다음 뉴스까지 같이 체크해요.',
              repliedByProfileId: 'youngwooUid',
              repliedLabel: '오늘',
              updatedAt: DateTime.parse('2026-06-10T13:00:00.000Z'),
            ),
            StockHolding(
              id: 'holding_partner_tesla',
              name: 'Tesla',
              status: '정리 고민 중',
              weightLabel: '작게',
              reason: '변동성이 커져서 고민 중이에요.',
              watchPoint: '인도량',
              concern: '가격 경쟁',
              question: '계속 지켜볼까요?',
              createdByProfileId: 'minyoungUid',
              createdLabel: '오늘',
              updatedAt: DateTime.parse('2026-06-10T14:00:00.000Z'),
            ),
          ],
        ),
      ),
    )..goTo(AlagagiRoute.stockStory);

    await tester.pumpWidget(
      MaterialApp(home: AlagagiRoot(controller: controller)),
    );
    await tester.pumpAndSettle();

    final needsReplyStoryFilter = find.byKey(
      stockStoryListFilterButtonKey(StockStoryListFilter.needsReply.name),
    );
    await tester.scrollUntilVisible(
      needsReplyStoryFilter,
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(needsReplyStoryFilter);
    await tester.pumpAndSettle();

    expect(
      find.byKey(stockStoryCardKey('story_partner_waiting')),
      findsOneWidget,
    );
    expect(find.byKey(stockStoryCardKey('story_mine')), findsNothing);
    expect(
      find.byKey(stockStoryCardKey('story_partner_replied')),
      findsNothing,
    );

    await tester.tap(
      find.byKey(
        stockStoryListFilterButtonKey(StockStoryListFilter.replied.name),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(stockStoryCardKey('story_partner_replied')),
      findsOneWidget,
    );
    expect(
      find.byKey(stockStoryCardKey('story_partner_waiting')),
      findsNothing,
    );

    await tester.ensureVisible(find.byKey(stockStoryTabHoldingsKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(stockStoryTabHoldingsKey));
    await tester.pumpAndSettle();

    final sharedHoldingFilter = find.byKey(
      stockHoldingListFilterButtonKey(StockHoldingListFilter.shared.name),
    );
    await tester.scrollUntilVisible(
      sharedHoldingFilter,
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(sharedHoldingFilter);
    await tester.pumpAndSettle();

    expect(
      find.byKey(stockHoldingCardKey('holding_mine_msft')),
      findsOneWidget,
    );
    expect(
      find.byKey(stockHoldingCardKey('holding_partner_msft')),
      findsOneWidget,
    );
    expect(
      find.byKey(stockHoldingCardKey('holding_partner_tesla')),
      findsNothing,
    );

    await tester.tap(
      find.byKey(
        stockHoldingListFilterButtonKey(
          StockHoldingListFilter.considering.name,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(stockHoldingCardKey('holding_partner_tesla')),
      findsOneWidget,
    );
    expect(find.byKey(stockHoldingCardKey('holding_mine_msft')), findsNothing);
  });

  testWidgets('stock holding cards allow owners to edit and delete holdings', (
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
          stockHoldings: [
            StockHolding(
              id: 'holding_mine_msft',
              name: 'Microsoft',
              status: '보유 중',
              weightLabel: '보통',
              reason: '클라우드 매출 흐름을 보고 있어요.',
              watchPoint: 'Azure 성장률',
              concern: 'AI 투자 비용',
              question: '다음 실적에서 뭘 볼까요?',
              createdByProfileId: 'youngwooUid',
              createdLabel: '오늘',
              updatedAt: DateTime.parse('2026-06-10T12:00:00.000Z'),
            ),
            StockHolding(
              id: 'holding_partner_aapl',
              name: 'Apple',
              status: '보유 중',
              weightLabel: '작게',
              reason: '상대가 들고 있는 종목이에요.',
              watchPoint: '서비스 매출',
              concern: '교체 수요',
              question: '같이 봐줄래요?',
              createdByProfileId: 'minyoungUid',
              createdLabel: '오늘',
              updatedAt: DateTime.parse('2026-06-10T13:00:00.000Z'),
            ),
          ],
        ),
      ),
    )..goTo(AlagagiRoute.stockStory);

    await tester.pumpWidget(
      MaterialApp(home: AlagagiRoot(controller: controller)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(stockStoryTabHoldingsKey));
    await tester.pumpAndSettle();

    expect(
      find.byKey(stockHoldingEditButtonKey('holding_mine_msft')),
      findsOneWidget,
    );
    expect(
      find.byKey(stockHoldingDeleteButtonKey('holding_mine_msft')),
      findsOneWidget,
    );
    expect(
      find.byKey(stockHoldingEditButtonKey('holding_partner_aapl')),
      findsNothing,
    );
    expect(
      find.byKey(stockHoldingDeleteButtonKey('holding_partner_aapl')),
      findsNothing,
    );

    await tester.ensureVisible(
      find.byKey(stockHoldingEditButtonKey('holding_mine_msft')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(stockHoldingEditButtonKey('holding_mine_msft')),
    );
    await tester.pumpAndSettle();

    expect(find.text('수정 저장'), findsOneWidget);
    await tester.enterText(
      find.byKey(stockHoldingReasonFieldKey),
      'AI 매출과 클라우드를 다시 보려고 해요.',
    );
    await tester.ensureVisible(find.byKey(stockHoldingSubmitButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(stockHoldingSubmitButtonKey));
    await tester.pumpAndSettle();

    expect(find.textContaining('AI 매출과 클라우드'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(stockHoldingDeleteButtonKey('holding_mine_msft')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(stockHoldingDeleteButtonKey('holding_mine_msft')),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(stockHoldingCardKey('holding_mine_msft')), findsNothing);
    expect(
      find.byKey(stockHoldingCardKey('holding_partner_aapl')),
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
    expect(find.byKey(homeMenuButtonKey), findsOneWidget);
    expect(find.byKey(homeCuriosityEntryKey), findsNothing);
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
    await tester.tap(find.widgetWithText(FilledButton, '답 남기기'));
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
    await tester.tap(find.widgetWithText(FilledButton, '답 남기기'));
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
    final controller = AlagagiController()
      ..enterSpace('영우')
      ..completeFirstVisitGuide();
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
    final controller = AlagagiController()
      ..enterSpace('영우')
      ..completeFirstVisitGuide();
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

  testWidgets('profile card can skip and restore awkward prompts', (
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

    expect(controller.todayFillableProfileSlot?.id, 'rest');
    expect(find.byKey(profileRecommendedSlotSkipButtonKey), findsOneWidget);

    await tester.ensureVisible(find.byKey(profileRecommendedSlotSkipButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(profileRecommendedSlotSkipButtonKey));
    await tester.pumpAndSettle();

    expect(controller.myProfileCard.skippedCount, 1);
    expect(controller.todayFillableProfileSlot?.id, isNot('rest'));
    expect(find.text('넘겨둠'), findsOneWidget);
    expect(find.text('지금은 넘겨둔 질문이에요'), findsOneWidget);

    await tester.ensureVisible(find.byKey(profileSlotRestoreButtonKey('rest')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(profileSlotRestoreButtonKey('rest')));
    await tester.pumpAndSettle();

    expect(controller.myProfileCard.skippedCount, 0);
    expect(controller.todayFillableProfileSlot?.id, 'rest');
    expect(find.text('지금은 넘겨둔 질문이에요'), findsNothing);
  });

  testWidgets('profile card can add custom cards and hide default prompts', (
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

    await tester.ensureVisible(find.byKey(profileCustomCardAddButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(profileCustomCardAddButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(profileCustomCardPanelKey), findsOneWidget);
    await tester.enterText(
      find.byKey(profileCustomTitleFieldKey),
      '나를 편하게 하는 질문',
    );
    await tester.enterText(
      find.byKey(profileCustomBodyFieldKey),
      '정답 없이 편하게 이야기할 수 있는 질문이 좋아요.',
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(profileCustomSubmitButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(profileCustomSubmitButtonKey));
    await tester.pumpAndSettle();

    final customSlot = controller.myProfileCard.slots.first;
    expect(customSlot.custom, isTrue);
    expect(customSlot.category, '직접');
    expect(find.text('나를 편하게 하는 질문'), findsOneWidget);
    expect(find.textContaining('정답 없이'), findsOneWidget);
    expect(
      find.byKey(profileSlotDeleteButtonKey(customSlot.id)),
      findsOneWidget,
    );

    await tester.ensureVisible(find.byKey(profileSlotHideButtonKey('rest')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(profileSlotHideButtonKey('rest')));
    await tester.pumpAndSettle();

    expect(
      controller.myProfileCard.slots
          .firstWhere((slot) => slot.id == 'rest')
          .hidden,
      isTrue,
    );
    expect(find.byKey(profileHiddenSlotsPanelKey), findsOneWidget);
    expect(find.byKey(profileSlotCardKey('rest')), findsNothing);

    await tester.ensureVisible(find.byKey(profileSlotRestoreButtonKey('rest')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(profileSlotRestoreButtonKey('rest')));
    await tester.pumpAndSettle();

    expect(
      controller.myProfileCard.slots
          .firstWhere((slot) => slot.id == 'rest')
          .hidden,
      isFalse,
    );

    await tester.ensureVisible(
      find.byKey(profileSlotDeleteButtonKey(customSlot.id)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(profileSlotDeleteButtonKey(customSlot.id)));
    await tester.pumpAndSettle();

    expect(
      controller.myProfileCard.slots.where((slot) => slot.id == customSlot.id),
      isEmpty,
    );
    expect(find.text('나를 편하게 하는 질문'), findsNothing);
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
    expect(find.text('함께했어요'), findsWidgets);
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

    await tester.ensureVisible(find.text('취향 매치'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('취향 매치'));
    await tester.pumpAndSettle();
    expect(find.byKey(balanceDeckKey), findsOneWidget);
    expect(find.text('둘 중 하나만 골라도\n취향 기록이 쌓여요'), findsOneWidget);
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
    await tester.ensureVisible(find.text('취향 매치'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('취향 매치'));
    await tester.pumpAndSettle();

    final beforeSelection = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, '먼저 하나를 골라주세요'),
    );
    expect(beforeSelection.onPressed, isNull);

    await tester.ensureVisible(find.text('조용한 바다'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('조용한 바다'));
    await tester.pumpAndSettle();

    expect(find.text('선택한 카드를 한 번 더 누르면 취소돼요.'), findsOneWidget);
    await tester.tap(find.text('조용한 바다'));
    await tester.pumpAndSettle();
    expect(find.byKey(balanceReasonFieldKey), findsNothing);
    final clearedSelection = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, '먼저 하나를 골라주세요'),
    );
    expect(clearedSelection.onPressed, isNull);

    await tester.tap(find.text('조용한 바다'));
    await tester.pumpAndSettle();

    expect(find.byKey(balanceReasonFieldKey), findsNothing);
    expect(find.text('이유 없이 넘어가도 괜찮아요.'), findsOneWidget);
    await tester.ensureVisible(find.byKey(balanceReasonToggleButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(balanceReasonToggleButtonKey));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(balanceReasonFieldKey));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(balanceReasonFieldKey), '조용한 바다가 끌려요');
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    expect(find.text('조용한 바다가 끌려요'), findsWidgets);
    expect(find.text('결과 열어보기'), findsWidgets);
    expect(find.text('다른 취향이 이야기로 남았어요'), findsNothing);
    expect(find.byKey(balanceTabButtonKey('results')), findsOneWidget);
    expect(find.byKey(balanceTabButtonKey('notes')), findsOneWidget);
    expect(find.text('내 취향 노트'), findsNothing);
    expect(find.text('선택 이유 한 줄'), findsOneWidget);
    expect(find.text('결과 잠금'), findsNothing);

    await tester.ensureVisible(find.byKey(balanceTabButtonKey('results')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(balanceTabButtonKey('results')));
    await tester.pumpAndSettle();

    expect(find.text('결과함'), findsWidgets);
    expect(find.text('결과 잠금'), findsOneWidget);
    expect(find.text('선택 이유 한 줄'), findsNothing);
    expect(find.text('내 취향 노트'), findsNothing);
    expect(find.text('다름'), findsNothing);
    expect(find.text('상대'), findsNothing);

    await tester.ensureVisible(find.byKey(balanceTabButtonKey('notes')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(balanceTabButtonKey('notes')));
    await tester.pumpAndSettle();

    expect(find.text('내 취향 노트'), findsOneWidget);
    expect(find.textContaining('결과함에서만 공개'), findsWidgets);
    expect(find.text('결과 잠금'), findsNothing);

    await tester.ensureVisible(find.byKey(balanceTabButtonKey('choose')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(balanceTabButtonKey('choose')));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(balanceResultToggleButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(balanceResultToggleButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('다른 취향이 이야기로 남았어요'), findsOneWidget);
    expect(find.text('결과 접기'), findsOneWidget);

    final afterSelection = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, '다음 취향'),
    );
    expect(afterSelection.onPressed, isNotNull);
  });

  testWidgets('sub screen header follows soft paper option', (tester) async {
    await tester.pumpWidget(const AlagagiApp());
    await enterSpace(tester);

    await tester.tap(find.byKey(homeMenuButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(homeMenuBalanceButtonKey));
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
        .widgetList<Text>(find.text('취향 매치'))
        .map((text) => text.style)
        .where((style) => style?.fontSize == 18);
    expect(titleStyles, isNotEmpty);
    expect(titleStyles.first!.fontWeight, FontWeight.w700);
    expect(titleStyles.first!.fontFamily, 'Nanum Myeongjo');
  });

  testWidgets('bottom tab root screens do not show a back action', (
    tester,
  ) async {
    await tester.pumpWidget(const AlagagiApp());
    await enterSpace(tester);

    await tester.tap(find.text('약속'));
    await tester.pumpAndSettle();
    expect(find.text('만날 수 있는 날'), findsOneWidget);
    expect(find.byKey(subScreenBackButtonKey), findsNothing);

    await tester.tap(find.text('장소'));
    await tester.pumpAndSettle();
    expect(find.text('가보고 싶은 곳'), findsOneWidget);
    expect(find.byKey(subScreenBackButtonKey), findsNothing);

    await tester.tap(find.text('마이'));
    await tester.pumpAndSettle();
    expect(find.text('마이'), findsWidgets);
    expect(find.byKey(subScreenBackButtonKey), findsNothing);
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

  testWidgets('meeting tab saves detailed schedule and shared note', (
    tester,
  ) async {
    final controller = AlagagiController()..enterSpace('영우');
    await tester.pumpWidget(
      MaterialApp(home: AlagagiRoot(controller: controller)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('약속'));
    await tester.pumpAndSettle();

    expect(find.byKey(meetingCalendarKey), findsOneWidget);
    expect(
      find.byKey(meetingTimeBlockPresetButtonKey('evening')),
      findsNothing,
    );
    await tester.ensureVisible(find.byKey(meetingTimeBlockToggleButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(meetingTimeBlockToggleButtonKey));
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(meetingTimeBlockPresetButtonKey('evening')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(meetingTimeBlockPresetButtonKey('evening')));
    await tester.pumpAndSettle();

    final startEditable = tester.widget<EditableText>(
      find.descendant(
        of: find.byKey(meetingTimeBlockStartFieldKey),
        matching: find.byType(EditableText),
      ),
    );
    final endEditable = tester.widget<EditableText>(
      find.descendant(
        of: find.byKey(meetingTimeBlockEndFieldKey),
        matching: find.byType(EditableText),
      ),
    );
    final titleEditable = tester.widget<EditableText>(
      find.descendant(
        of: find.byKey(meetingTimeBlockTitleFieldKey),
        matching: find.byType(EditableText),
      ),
    );
    expect(startEditable.controller.text, '19:00');
    expect(endEditable.controller.text, '21:00');
    expect(titleEditable.controller.text, '저녁 약속');

    await tester.ensureVisible(find.byKey(meetingTimeBlockAddButtonKey));
    await tester.tap(find.byKey(meetingTimeBlockAddButtonKey));
    await tester.pumpAndSettle();
    expect(find.text('19:00-21:00 · 저녁 약속'), findsOneWidget);

    await tester.enterText(
      find.byKey(meetingSharedMemoFieldKey),
      '19:30 이후면 편해요.',
    );
    await tester.ensureVisible(find.byKey(meetingSubmitButtonKey));
    await tester.tap(find.byKey(meetingSubmitButtonKey));
    await tester.pumpAndSettle();

    expect(controller.mySelectedScheduleEntry?.sharedMemo, '19:30 이후면 편해요.');
    expect(
      controller.mySelectedScheduleEntry?.timeBlocks.single.title,
      '저녁 약속',
    );
    expect(find.text('일정을 저장했어요.'), findsOneWidget);
  });

  testWidgets('meeting calendar moves to nearby months for editing', (
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
      ),
    );
    controller
      ..goTo(AlagagiRoute.meetings)
      ..selectMeetingDate('2026-01-31');
    await tester.pumpWidget(
      MaterialApp(home: AlagagiRoot(controller: controller)),
    );
    await tester.pumpAndSettle();

    expect(find.text('2026년 1월'), findsOneWidget);
    await tester.tap(find.byKey(meetingCalendarNextButtonKey));
    await tester.pumpAndSettle();
    expect(controller.selectedMeetingDateKey, '2026-02-28');
    expect(find.text('2026년 2월'), findsOneWidget);

    await tester.tap(find.byKey(meetingCalendarPreviousButtonKey));
    await tester.pumpAndSettle();
    expect(controller.selectedMeetingDateKey, '2026-01-28');
    expect(find.text('2026년 1월'), findsOneWidget);
  });

  testWidgets('meeting calendar marks my saved date before partner input', (
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
      ),
    )..goTo(AlagagiRoute.meetings);
    await tester.pumpWidget(
      MaterialApp(home: AlagagiRoot(controller: controller)),
    );
    await tester.pumpAndSettle();

    final dateKey = controller.selectedMeetingDateKey;
    expect(find.text('내 입력'), findsOneWidget);
    expect(find.byKey(meetingMyEntryIndicatorKey(dateKey)), findsNothing);

    await tester.ensureVisible(find.byKey(meetingSubmitButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(meetingSubmitButtonKey));
    await tester.pumpAndSettle();

    expect(controller.mySelectedScheduleEntry, isNotNull);
    expect(controller.mySelectedScheduleEntry!.timeBlocks, isEmpty);
    expect(find.byKey(meetingMyEntryIndicatorKey(dateKey)), findsOneWidget);
  });

  testWidgets('meeting calendar keeps both entry marks on mutual dates', (
    tester,
  ) async {
    const dateKey = '2026-06-11';
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
          scheduleEntries: [
            ScheduleEntry(
              dateKey: dateKey,
              profileId: 'youngwooUid',
              availability: MeetingAvailability.available,
              timeSlots: {MeetingTimeSlot.evening},
            ),
            ScheduleEntry(
              dateKey: dateKey,
              profileId: 'minyoungUid',
              availability: MeetingAvailability.available,
              timeSlots: {MeetingTimeSlot.evening},
            ),
          ],
        ),
      ),
    );
    controller
      ..goTo(AlagagiRoute.meetings)
      ..selectMeetingDate(dateKey);
    await tester.pumpWidget(
      MaterialApp(home: AlagagiRoot(controller: controller)),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(meetingMutualIndicatorKey(dateKey)), findsOneWidget);
    expect(find.byKey(meetingMyEntryIndicatorKey(dateKey)), findsOneWidget);
    expect(
      find.byKey(meetingPartnerEntryIndicatorKey(dateKey)),
      findsOneWidget,
    );
  });

  testWidgets('meeting candidate list expands and selects candidate dates', (
    tester,
  ) async {
    const candidateDates = [
      '2026-06-11',
      '2026-06-12',
      '2026-06-13',
      '2026-06-14',
    ];
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
          scheduleEntries: [
            for (final dateKey in candidateDates) ...[
              ScheduleEntry(
                dateKey: dateKey,
                profileId: 'youngwooUid',
                availability: MeetingAvailability.available,
                timeSlots: {MeetingTimeSlot.evening},
              ),
              ScheduleEntry(
                dateKey: dateKey,
                profileId: 'minyoungUid',
                availability: MeetingAvailability.available,
                timeSlots: {MeetingTimeSlot.evening},
              ),
            ],
          ],
        ),
      ),
    )..goTo(AlagagiRoute.meetings);
    await tester.pumpWidget(
      MaterialApp(home: AlagagiRoot(controller: controller)),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(meetingCandidateCardKey('2026-06-14')), findsNothing);
    await tester.ensureVisible(find.byKey(meetingCandidateMoreButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(meetingCandidateMoreButtonKey));
    await tester.pumpAndSettle();
    expect(find.byKey(meetingCandidateCardKey('2026-06-14')), findsOneWidget);

    await tester.tap(find.byKey(meetingCandidateCardKey('2026-06-14')));
    await tester.pumpAndSettle();
    expect(controller.selectedMeetingDateKey, '2026-06-14');
  });

  testWidgets('meeting candidate saves free-form meeting day details', (
    tester,
  ) async {
    const dateKey = '2026-06-11';
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
          scheduleEntries: [
            ScheduleEntry(
              dateKey: dateKey,
              profileId: 'youngwooUid',
              availability: MeetingAvailability.available,
              timeSlots: {MeetingTimeSlot.evening},
            ),
            ScheduleEntry(
              dateKey: dateKey,
              profileId: 'minyoungUid',
              availability: MeetingAvailability.available,
              timeSlots: {MeetingTimeSlot.evening},
            ),
          ],
        ),
      ),
    );
    controller
      ..goTo(AlagagiRoute.meetings)
      ..selectMeetingDate(dateKey);
    await tester.pumpWidget(
      MaterialApp(home: AlagagiRoot(controller: controller)),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(meetingDayTimeFieldKey));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(meetingDayTimeFieldKey), '저녁 7시쯤');
    await tester.ensureVisible(find.byKey(meetingDayNoteFieldKey));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(meetingDayNoteFieldKey), '장소는 성수 쪽');
    await tester.ensureVisible(find.byKey(meetingDaySaveButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(meetingDaySaveButtonKey));
    await tester.pumpAndSettle();

    final entry = controller.scheduleEntryFor(controller.state.me.id, dateKey);
    expect(entry, isNotNull);
    expect(entry!.isMeetingDay, isTrue);
    expect(entry.meetingTimeLabel, '저녁 7시쯤');
    expect(entry.meetingNote, '장소는 성수 쪽');
    expect(entry.meetingPlanItems, isEmpty);
    expect(find.byKey(meetingDayIndicatorKey(dateKey)), findsOneWidget);
    expect(find.text('만나는 날로 저장했어요.'), findsOneWidget);
  });

  testWidgets(
    'meeting calendar fixed day stays visually distinct from selection',
    (tester) async {
      const meetingDateKey = '2026-06-11';
      const selectedDateKey = '2026-06-12';
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
            scheduleEntries: [
              ScheduleEntry(
                dateKey: meetingDateKey,
                profileId: 'youngwooUid',
                availability: MeetingAvailability.available,
                timeSlots: {MeetingTimeSlot.evening},
                isMeetingDay: true,
              ),
            ],
          ),
        ),
      );
      controller
        ..goTo(AlagagiRoute.meetings)
        ..selectMeetingDate(selectedDateKey);

      await tester.pumpWidget(
        MaterialApp(home: AlagagiRoot(controller: controller)),
      );
      await tester.pumpAndSettle();

      final fixedDayDecoration = _meetingDateCellDecoration(
        tester,
        meetingDateKey,
      );
      final selectedDayDecoration = _meetingDateCellDecoration(
        tester,
        selectedDateKey,
      );

      expect(fixedDayDecoration.color, const Color(0xFFFFF5D2));
      expect(fixedDayDecoration.color, isNot(AlagagiColors.ink));
      expect(selectedDayDecoration.color, AlagagiColors.ink);
      expect(
        find.byKey(meetingDayIndicatorKey(meetingDateKey)),
        findsOneWidget,
      );
    },
  );

  testWidgets('meeting plan tab saves plan items for a fixed meeting day', (
    tester,
  ) async {
    const dateKey = '2099-06-11';
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
          scheduleEntries: [
            ScheduleEntry(
              dateKey: dateKey,
              profileId: 'youngwooUid',
              availability: MeetingAvailability.available,
              timeSlots: {MeetingTimeSlot.evening},
              isMeetingDay: true,
              meetingTimeLabel: '저녁 7시쯤',
            ),
            ScheduleEntry(
              dateKey: dateKey,
              profileId: 'minyoungUid',
              availability: MeetingAvailability.available,
              timeSlots: {MeetingTimeSlot.evening},
            ),
          ],
          sharedPlaces: [
            SharedPlace(
              id: 'place_cafe',
              name: '조용한 카페',
              address: '서울 성동구',
              category: PlaceCategory.cafe,
              provider: MapApiProvider.kakao,
              createdByProfileId: 'minyoungUid',
              interestedByProfileIds: {'minyoungUid'},
            ),
            SharedPlace(
              id: 'place_food',
              name: '작은 식당',
              address: '서울 성동구',
              category: PlaceCategory.food,
              provider: MapApiProvider.kakao,
              createdByProfileId: 'youngwooUid',
              interestedByProfileIds: {'youngwooUid'},
            ),
            SharedPlace(
              id: 'place_walk',
              name: '산책길',
              address: '서울 성동구',
              category: PlaceCategory.walk,
              provider: MapApiProvider.kakao,
              createdByProfileId: 'minyoungUid',
              interestedByProfileIds: {'minyoungUid'},
            ),
            SharedPlace(
              id: 'place_exhibition',
              name: '작은 전시 공간',
              address: '서울 성동구',
              category: PlaceCategory.exhibition,
              provider: MapApiProvider.kakao,
              createdByProfileId: 'youngwooUid',
              interestedByProfileIds: {'youngwooUid'},
            ),
            SharedPlace(
              id: 'place_activity',
              name: '공방 체험',
              address: '서울 성동구',
              category: PlaceCategory.activity,
              provider: MapApiProvider.kakao,
              createdByProfileId: 'minyoungUid',
              interestedByProfileIds: {'minyoungUid'},
            ),
            SharedPlace(
              id: 'place_gallery_5',
              name: '다섯 번째 장소',
              address: '서울 성동구',
              category: PlaceCategory.exhibition,
              provider: MapApiProvider.kakao,
              createdByProfileId: 'youngwooUid',
              interestedByProfileIds: {'youngwooUid'},
            ),
          ],
        ),
      ),
    )..goTo(AlagagiRoute.meetingPlans);
    await tester.pumpWidget(
      MaterialApp(home: AlagagiRoot(controller: controller)),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(meetingPlanScreenKey), findsOneWidget);
    expect(find.byKey(meetingPlanDateButtonKey(dateKey)), findsOneWidget);
    expect(find.text('영우·민영의 계획'), findsOneWidget);
    expect(find.text('같이 하고 싶은 것들을 편하게 모아요.'), findsOneWidget);
    expect(find.text('그날 할 것'), findsNothing);

    for (final item in ['전시 보기', '근처 카페', '저녁 먹기']) {
      await tester.ensureVisible(find.byKey(meetingPlanDraftFieldKey));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(meetingPlanDraftFieldKey), item);
      await tester.ensureVisible(find.byKey(meetingPlanItemAddButtonKey));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(meetingPlanItemAddButtonKey));
      await tester.pumpAndSettle();
    }
    await tester.ensureVisible(find.byKey(meetingPlanItemEditButtonKey(1)));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(meetingPlanItemEditButtonKey(1)));
    await tester.pumpAndSettle();
    expect(find.text('2번째 계획 수정'), findsOneWidget);
    await tester.enterText(find.byKey(meetingPlanDraftFieldKey), '브런치 카페');
    await tester.tap(find.byKey(meetingPlanItemAddButtonKey));
    await tester.pumpAndSettle();
    expect(find.text('브런치 카페'), findsOneWidget);
    expect(find.text('근처 카페'), findsNothing);

    await tester.ensureVisible(find.byKey(meetingPlanSaveButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(meetingPlanSaveButtonKey));
    await tester.pumpAndSettle();

    final plan = controller.meetingPlanFor(dateKey);
    expect(plan, isNotNull);
    expect(plan!.items, ['전시 보기', '브런치 카페', '저녁 먹기']);
    expect(find.text('계획 3개'), findsOneWidget);
    expect(find.text('만남 계획을 저장했어요.'), findsOneWidget);

    expect(
      find.byKey(meetingPlanPlaceLinkButtonKey('place_cafe')),
      findsNothing,
    );
    await tester.ensureVisible(find.byKey(meetingPlanPlaceMoreButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(meetingPlanPlaceMoreButtonKey));
    await tester.pumpAndSettle();
    expect(
      find.byKey(meetingPlanPlaceLinkButtonKey('place_cafe')),
      findsOneWidget,
    );

    await tester.ensureVisible(
      find.byKey(meetingPlanPlaceLinkButtonKey('place_cafe')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(meetingPlanPlaceLinkButtonKey('place_cafe')));
    await tester.pumpAndSettle();

    expect(
      controller.sharedPlaces
          .firstWhere((place) => place.id == 'place_cafe')
          .linkedDateKey,
      dateKey,
    );
  });

  testWidgets('meeting plan keeps past meetings behind a separate button', (
    tester,
  ) async {
    const pastDateKey = '2000-06-11';
    const upcomingDateKey = '2099-06-11';
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
          scheduleEntries: [
            ScheduleEntry(
              dateKey: pastDateKey,
              profileId: 'youngwooUid',
              availability: MeetingAvailability.available,
              timeSlots: {MeetingTimeSlot.evening},
              isMeetingDay: true,
              meetingTimeLabel: '저녁 7시쯤',
              meetingNote: '성수에서 조용히 보기',
            ),
            ScheduleEntry(
              dateKey: upcomingDateKey,
              profileId: 'youngwooUid',
              availability: MeetingAvailability.available,
              timeSlots: {MeetingTimeSlot.evening},
              isMeetingDay: true,
              meetingTimeLabel: '오후 3시',
            ),
          ],
          meetingPlans: [
            MeetingPlan(
              dateKey: pastDateKey,
              items: ['전시 보기', '근처 카페', '저녁 먹기', '산책하기'],
              updatedByProfileId: 'youngwooUid',
            ),
          ],
          sharedPlaces: [
            SharedPlace(
              id: 'past_place',
              name: '조용한 카페',
              address: '서울 성동구',
              category: PlaceCategory.cafe,
              provider: MapApiProvider.kakao,
              createdByProfileId: 'youngwooUid',
              interestedByProfileIds: {'youngwooUid'},
              linkedDateKey: pastDateKey,
            ),
            SharedPlace(
              id: 'past_place_2',
              name: '작은 식당',
              address: '서울 성동구',
              category: PlaceCategory.food,
              provider: MapApiProvider.kakao,
              createdByProfileId: 'minyoungUid',
              interestedByProfileIds: {'minyoungUid'},
              linkedDateKey: pastDateKey,
            ),
            SharedPlace(
              id: 'past_place_3',
              name: '힐링 산책길',
              address: '서울 성동구',
              category: PlaceCategory.walk,
              provider: MapApiProvider.kakao,
              createdByProfileId: 'youngwooUid',
              interestedByProfileIds: {'youngwooUid'},
              linkedDateKey: pastDateKey,
            ),
          ],
        ),
      ),
    )..goTo(AlagagiRoute.meetingPlans);

    await tester.pumpWidget(
      MaterialApp(home: AlagagiRoot(controller: controller)),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(meetingPlanDateButtonKey(upcomingDateKey)),
      findsOneWidget,
    );
    expect(find.byKey(meetingPlanDateButtonKey(pastDateKey)), findsNothing);
    expect(find.byKey(meetingPastMeetingsButtonKey), findsOneWidget);

    await tester.tap(find.byKey(meetingPastMeetingsButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(meetingPastMeetingsSheetKey), findsOneWidget);
    expect(find.byKey(meetingPastMeetingCardKey(pastDateKey)), findsOneWidget);
    expect(find.text('지난 만남'), findsOneWidget);
    expect(find.text('저녁 7시쯤'), findsOneWidget);
    expect(find.text('계획 4개'), findsOneWidget);
    expect(find.text('장소 3곳'), findsOneWidget);
    expect(find.text('조용한 카페'), findsWidgets);
    final pastMeetingCard = find.byKey(meetingPastMeetingCardKey(pastDateKey));
    expect(
      find.descendant(of: pastMeetingCard, matching: find.text('산책하기')),
      findsNothing,
    );
    expect(
      find.descendant(of: pastMeetingCard, matching: find.text('힐링 산책길')),
      findsNothing,
    );

    await tester.tap(
      find.byKey(meetingPastMeetingPlansMoreButtonKey(pastDateKey)),
    );
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: pastMeetingCard, matching: find.text('산책하기')),
      findsOneWidget,
    );

    await tester.ensureVisible(
      find.byKey(meetingPastMeetingPlacesMoreButtonKey(pastDateKey)),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(meetingPastMeetingPlacesMoreButtonKey(pastDateKey)),
    );
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: pastMeetingCard, matching: find.text('힐링 산책길')),
      findsOneWidget,
    );
  });

  testWidgets('meeting save failure shows retry action', (tester) async {
    final repository = _FailingSaveRepository()..failScheduleSaves = true;
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
      ),
      repository: repository,
    );
    await tester.pumpWidget(
      MaterialApp(home: AlagagiRoot(controller: controller)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('약속'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(meetingSubmitButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(meetingSubmitButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('일정을 저장하지 못했어요. 다시 시도해 주세요.'), findsOneWidget);
    expect(find.byKey(meetingRetryButtonKey), findsOneWidget);
    expect(repository.savedScheduleEntries, isEmpty);

    repository.failScheduleSaves = false;
    await tester.tap(find.byKey(meetingRetryButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(meetingRetryButtonKey), findsNothing);
    expect(find.text('일정을 저장했어요.'), findsOneWidget);
    expect(repository.savedScheduleEntries.single.spaceId, 'main');
  });

  testWidgets('place tab adds a shared place without location tracking copy', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1000, 1200);
    addTearDown(() {
      tester.view.resetPhysicalSize();
    });
    final controller = AlagagiController()..enterSpace('영우');
    await tester.pumpWidget(
      MaterialApp(home: AlagagiRoot(controller: controller)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('장소'));
    await tester.pumpAndSettle();

    expect(find.byKey(placeBoardKey), findsOneWidget);
    expect(find.textContaining('위치 추적'), findsNothing);

    expect(find.byKey(placeAddButtonKey), findsOneWidget);
    controller.startPlaceDraft();
    await tester.pumpAndSettle();
    expect(find.text('네이버 지도'), findsNothing);
    expect(find.text('직접 입력'), findsNothing);
    expect(find.byKey(placeSearchFieldKey), findsOneWidget);
    controller.applyKakaoPlaceResult(
      providerPlaceId: 'kakao-bookstore-1',
      name: '작은 서점',
      address: '서울 성동구',
      latitude: 37.5446,
      longitude: 127.0557,
      category: PlaceCategory.activity,
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(placeNoteFieldKey), '조용히 둘러보기 좋아 보여요.');
    await tester.pumpAndSettle();
    controller.submitPlaceDraft();
    await tester.pumpAndSettle();

    expect(controller.sharedPlaces.first.name, '작은 서점');
    expect(controller.sharedPlaces.first.provider, MapApiProvider.kakao);
    expect(controller.sharedPlaces.first.providerPlaceId, 'kakao-bookstore-1');
    expect(controller.sharedPlaces.first.note, '조용히 둘러보기 좋아 보여요.');
    expect(find.text('선택한 날에 담기'), findsNothing);
    expect(find.text('선택한 날로 변경'), findsNothing);
    expect(find.text('연결 해제'), findsNothing);
    expect(find.textContaining('약속 연결'), findsNothing);
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
    expect(find.text('신나는'), findsOneWidget);
    expect(find.text('파이팅'), findsOneWidget);
    await tester.ensureVisible(find.byKey(musicMoodFieldKey));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(musicMoodFieldKey), '드라이브');
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(musicSubmitButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(musicSubmitButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('새벽 산책'), findsOneWidget);
    expect(find.textContaining('새벽에 들으면'), findsOneWidget);
    expect(find.text('드라이브'), findsOneWidget);
    expect(find.text('노래 남기기'), findsNothing);
    expect(find.textContaining('커플'), findsNothing);
    expect(find.textContaining('사랑'), findsNothing);
  });

  testWidgets('music listen emoji toggles without opening detail', (
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
          musicNotes: [
            MusicNote(
              id: 'music_partner',
              title: '오후의 문장',
              artist: '민영의 추천',
              link: 'https://music.example/afternoon',
              note: '카페에서 듣기 좋아요.',
              mood: '카페',
              createdByProfileId: 'minyoungUid',
              createdLabel: '오늘',
              listenedByProfileIds: {'minyoungUid'},
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

    final listenButton = find.byKey(musicListenedButtonKey('music_partner'));
    await tester.ensureVisible(listenButton);
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: listenButton, matching: find.text('아직')),
      findsOneWidget,
    );

    await tester.tap(listenButton);
    await tester.pumpAndSettle();

    expect(
      controller.musicNotes.single.listenedByProfileIds,
      containsAll(['minyoungUid', 'youngwooUid']),
    );
    expect(
      find.descendant(of: listenButton, matching: find.text('둘 다 들음')),
      findsOneWidget,
    );
    expect(find.byKey(readableDetailSheetKey), findsNothing);

    await tester.tap(listenButton);
    await tester.pumpAndSettle();

    expect(
      controller.musicNotes.single.listenedByProfileIds,
      isNot(contains('youngwooUid')),
    );
    expect(
      find.descendant(of: listenButton, matching: find.text('아직')),
      findsOneWidget,
    );
    expect(find.byKey(readableDetailSheetKey), findsNothing);
  });

  testWidgets(
    'music list prioritizes unlistened songs and filters the library',
    (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

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
                id: 'music_mine_done',
                title: '퇴근길',
                artist: '영우의 추천',
                link: 'https://music.example/after-work',
                note: '이미 들은 곡이에요.',
                mood: '밤',
                createdByProfileId: 'youngwooUid',
                createdLabel: '어제',
                listenedByProfileIds: {'youngwooUid'},
                updatedAt: DateTime.parse('2026-06-09T09:00:00.000Z'),
              ),
              MusicNote(
                id: 'music_partner_new',
                title: '새벽 편지',
                artist: '민영의 추천',
                link: 'https://music.example/dawn',
                note: '아직 들어봐야 할 곡이에요.',
                mood: '차분한',
                createdByProfileId: 'minyoungUid',
                createdLabel: '오늘',
                listenedByProfileIds: {'minyoungUid'},
                updatedAt: DateTime.parse('2026-06-10T10:00:00.000Z'),
              ),
              MusicNote(
                id: 'music_both_done',
                title: '같이 들은 곡',
                artist: '민영의 추천',
                link: 'https://music.example/together',
                note: '둘 다 들어본 곡이에요.',
                mood: '카페',
                createdByProfileId: 'minyoungUid',
                createdLabel: '오늘',
                listenedByProfileIds: {'youngwooUid', 'minyoungUid'},
                updatedAt: DateTime.parse('2026-06-10T11:00:00.000Z'),
              ),
            ],
          ),
        ),
      )..goTo(AlagagiRoute.music);

      await tester.pumpWidget(
        MaterialApp(home: AlagagiRoot(controller: controller)),
      );
      await tester.pumpAndSettle();

      Future<void> tapMusicFilter(MusicListFilter filter) async {
        final filterFinder = find.byKey(musicListFilterButtonKey(filter.name));
        await tester.ensureVisible(filterFinder);
        await tester.pumpAndSettle();
        await tester.tap(filterFinder);
        await tester.pumpAndSettle();
      }

      expect(find.text('전체 노트'), findsOneWidget);
      expect(find.text('둘 다 들음'), findsWidgets);
      expect(controller.visibleMusicNotes.first.id, 'music_partner_new');

      await tapMusicFilter(MusicListFilter.unlistened);

      expect(find.byKey(musicNoteCardKey('music_partner_new')), findsOneWidget);
      expect(find.byKey(musicNoteCardKey('music_mine_done')), findsNothing);
      expect(find.byKey(musicNoteCardKey('music_both_done')), findsNothing);

      await tapMusicFilter(MusicListFilter.listened);

      expect(find.byKey(musicNoteCardKey('music_mine_done')), findsOneWidget);
      expect(find.byKey(musicNoteCardKey('music_both_done')), findsOneWidget);
      expect(find.byKey(musicNoteCardKey('music_partner_new')), findsNothing);

      await tapMusicFilter(MusicListFilter.partner);

      expect(find.byKey(musicNoteCardKey('music_partner_new')), findsOneWidget);
      expect(find.byKey(musicNoteCardKey('music_both_done')), findsOneWidget);
      expect(find.byKey(musicNoteCardKey('music_mine_done')), findsNothing);
    },
  );

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

  testWidgets('music note link action opens a normalized external link', (
    tester,
  ) async {
    final openedLinks = <String>[];
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
              link: 'music.example/night',
              note: '퇴근길에 들으면 차분해져요.',
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
      MaterialApp(
        home: AlagagiRoot(
          controller: controller,
          onOpenExternalLink: openedLinks.add,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(musicLinkButtonKey('music_mine')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(musicLinkButtonKey('music_mine')));
    await tester.pumpAndSettle();

    expect(openedLinks, ['https://music.example/night']);
    expect(find.byKey(readableDetailSheetKey), findsNothing);

    await tester.tap(find.byKey(musicNoteCardKey('music_mine')));
    await tester.pumpAndSettle();

    expect(find.byKey(readableDetailSheetKey), findsOneWidget);
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

  testWidgets('home unread panel opens a scrollable full activity sheet', (
    tester,
  ) async {
    final guideStore = MemoryFirstVisitGuideStore()
      ..markFirstVisitGuideSeen('main', 'youngwooUid');
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
              link: '',
              note: '',
              mood: '밤',
              createdByProfileId: 'minyoungUid',
              createdLabel: '오늘',
              updatedAt: DateTime.parse('2026-06-09T10:03:00.000Z'),
            ),
          ],
          sharedPlaces: [
            SharedPlace(
              id: 'place_partner_new',
              name: '조용한 카페',
              address: '서울',
              category: PlaceCategory.cafe,
              provider: MapApiProvider.kakao,
              createdByProfileId: 'minyoungUid',
              interestedByProfileIds: {'minyoungUid'},
              updatedAt: DateTime.parse('2026-06-09T10:04:00.000Z'),
              updatedByProfileId: 'minyoungUid',
            ),
          ],
          stockStories: [
            StockStory(
              id: 'stock_partner_new',
              name: 'NVDA',
              reason: '같이 볼 흐름',
              upside: '성장',
              risk: '변동성',
              question: '어떻게 볼까요?',
              createdByProfileId: 'minyoungUid',
              createdLabel: '오늘',
              updatedAt: DateTime.parse('2026-06-09T10:02:00.000Z'),
              updatedByProfileId: 'minyoungUid',
            ),
          ],
          scheduleEntries: [
            ScheduleEntry(
              dateKey: '2026-06-19',
              profileId: 'minyoungUid',
              availability: MeetingAvailability.available,
              timeSlots: {MeetingTimeSlot.evening},
              updatedAt: DateTime.parse('2026-06-09T10:01:00.000Z'),
            ),
          ],
          improvementPosts: [
            ImprovementPost(
              id: 'improvement_partner_new',
              title: '루틴 공유',
              body: '서로의 루틴도 남기고 싶어요.',
              category: '추가 요청',
              createdByProfileId: 'minyoungUid',
              createdLabel: '오늘',
              updatedAt: DateTime.parse('2026-06-09T10:05:00.000Z'),
            ),
          ],
        ),
      ),
      firstVisitGuideStore: guideStore,
    );

    await tester.pumpWidget(
      MaterialApp(home: AlagagiRoot(controller: controller)),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(unreadActivityPanelKey), findsOneWidget);
    expect(find.text('외 2개 더 보기'), findsOneWidget);
    expect(find.textContaining('루틴 공유'), findsOneWidget);
    expect(find.textContaining('조용한 카페'), findsOneWidget);
    expect(find.textContaining('밤 산책'), findsOneWidget);
    expect(find.textContaining('NVDA'), findsNothing);

    await tester.ensureVisible(find.byKey(unreadActivityMoreButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(unreadActivityMoreButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(unreadActivitySheetKey), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(unreadActivitySheetKey),
        matching: find.text('5개의 새 소식을 최신순으로 모아봤어요.'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(unreadActivitySheetKey),
        matching: find.textContaining('NVDA'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(unreadActivitySheetKey),
        matching: find.textContaining('6/19 일정을'),
      ),
      findsOneWidget,
    );
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
      final repository = _FailingSaveRepository();
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

BoxDecoration _meetingDateCellDecoration(WidgetTester tester, String dateKey) {
  final container = tester.widget<Container>(
    find
        .descendant(
          of: find.byKey(meetingDateButtonKey(dateKey)),
          matching: find.byType(Container),
        )
        .first,
  );
  return container.decoration! as BoxDecoration;
}

class _FailingSaveRepository implements AlagagiDataRepository {
  bool failCommentSaves = true;
  bool failScheduleSaves = false;
  bool failMeetingPlanSaves = false;
  final List<({String spaceId, AnswerComment comment})> savedAnswerComments =
      [];
  final List<({String spaceId, ScheduleEntry entry})> savedScheduleEntries = [];
  final List<({String spaceId, MeetingPlan plan})> savedMeetingPlans = [];

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
  Future<void> deleteBalanceSelection(
    String spaceId,
    String questionId,
    String profileId,
  ) async {}

  @override
  Future<void> saveDailyQuestionProgress(
    String spaceId,
    DailyQuestionProgress progress,
  ) async {}

  @override
  Future<void> saveMusicNote(String spaceId, MusicNote note) async {}

  @override
  Future<void> deleteMusicNote(String spaceId, String noteId) async {}

  @override
  Future<void> saveMusicNoteListenState(String spaceId, MusicNote note) async {}

  @override
  Future<void> saveScheduleEntry(String spaceId, ScheduleEntry entry) async {
    if (failScheduleSaves) {
      throw StateError('schedule save failed');
    }
    savedScheduleEntries.add((spaceId: spaceId, entry: entry));
  }

  @override
  Future<void> saveMeetingPlan(String spaceId, MeetingPlan plan) async {
    if (failMeetingPlanSaves) {
      throw StateError('meeting plan save failed');
    }
    savedMeetingPlans.add((spaceId: spaceId, plan: plan));
  }

  @override
  Future<void> saveSharedPlace(String spaceId, SharedPlace place) async {}

  @override
  Future<void> deleteSharedPlace(String spaceId, String placeId) async {}

  @override
  Future<void> saveCuriosityCard(String spaceId, CuriosityCard card) async {}

  @override
  Future<void> saveStockStory(String spaceId, StockStory story) async {}

  @override
  Future<void> deleteStockStory(String spaceId, String storyId) async {}

  @override
  Future<void> saveStockHolding(String spaceId, StockHolding holding) async {}

  @override
  Future<void> deleteStockHolding(String spaceId, String holdingId) async {}

  @override
  Future<void> saveImprovementPost(
    String spaceId,
    ImprovementPost post,
  ) async {}

  @override
  Future<void> deleteImprovementPost(String spaceId, String postId) async {}

  @override
  Future<void> saveProfileSlot(
    String spaceId,
    String profileId,
    ProfileSlot slot,
  ) async {}

  @override
  Future<void> deleteProfileSlot(
    String spaceId,
    String profileId,
    String slotId,
  ) async {}

  @override
  Future<void> saveSpacePersonalization(
    String spaceId,
    SpacePersonalization personalization,
  ) async {}

  @override
  Future<void> saveWish(String spaceId, WishItem wish) async {}

  @override
  Future<void> deleteWish(String spaceId, String wishId) async {}
}
