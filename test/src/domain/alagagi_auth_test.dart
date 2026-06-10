import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:minyoung_pick/src/domain/alagagi_controller.dart';

void main() {
  group('Firebase private login spec', () {
    test('maps short login ids to Firebase Auth emails', () {
      expect(firebaseEmailForLoginId('youngwoo'), 'youngwoo@gettoknow.local');
      expect(firebaseEmailForLoginId(' minyoung '), 'minyoung@gettoknow.local');
      expect(
        firebaseEmailForLoginId('custom@example.com'),
        'custom@example.com',
      );
    });

    test('session controller starts from home with real profile ids', () {
      final repository = RecordingAlagagiRepository();
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

      expect(controller.state.route, AlagagiRoute.home);
      expect(controller.state.me.id, 'youngwooUid');
      expect(controller.state.partner.nickname, '민영');

      controller.updateDraftAnswer('노을 질 때가 좋아요.');
      controller.submitTodayAnswer();

      expect(repository.savedAnswers.single.spaceId, 'main');
      expect(repository.savedAnswers.single.answer.profileId, 'youngwooUid');
      expect(repository.savedAnswers.single.answer.body, '노을 질 때가 좋아요.');
    });

    test(
      'session controller does not expose sample history in Firebase mode',
      () {
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

        expect(controller.todayQuestion.id, 'q001');
        expect(controller.todayMyAnswer, isNull);
        expect(controller.todayPartnerAnswer, isNull);
        expect(
          controller.archiveItems.where(
            (item) => item.myAnswer != null || item.partnerAnswer != null,
          ),
          isEmpty,
        );
        expect(controller.insight.questionCount, 0);
        expect(controller.insight.similarityPercent, 0);
        expect(controller.insight.matchedKeywords, isEmpty);
        expect(controller.visibleWishes, isEmpty);
        expect(controller.activeBalanceSelection, isNull);
        expect(controller.activePartnerBalanceSelection, isNull);
        expect(controller.activeProfileCard.filledCount, 0);
      },
    );

    test('session controller normalizes the old default app title', () {
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
            personalization: SpacePersonalization(appTitle: '알아가기'),
          ),
        ),
      );

      expect(controller.state.personalization.appTitle, '조금씩');
      expect(controller.state.personalizationDraft.appTitle, '조금씩');
    });

    test('session controller uses real Firestore-style session data', () {
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
                body: '저는 노을 질 때가 좋아요.',
                createdLabel: '오늘',
              ),
              Answer(
                questionId: 'q001',
                profileId: 'minyoungUid',
                body: '저는 아침 공기가 좋아요.',
                createdLabel: '오늘',
              ),
            ],
            balanceSelections: [
              BalanceSelection(
                questionId: 'b001',
                profileId: 'youngwooUid',
                optionId: 'sea',
              ),
              BalanceSelection(
                questionId: 'b001',
                profileId: 'minyoungUid',
                optionId: 'forest',
              ),
            ],
            wishes: [
              WishItem(
                id: 'wish_1',
                icon: '☕',
                title: '조용한 카페에서 커피 마시기',
                kind: WishKind.place,
                createdByProfileId: 'youngwooUid',
                likedByProfileIds: {'youngwooUid', 'minyoungUid'},
              ),
            ],
            curiosityCards: [
              CuriosityCard(
                id: 'curiosity_1',
                fromProfileId: 'minyoungUid',
                toProfileId: 'youngwooUid',
                question: '요즘 제일 자주 생각나는 건 뭐예요?',
                createdLabel: '오늘',
              ),
            ],
          ),
        ),
        todayDateKey: '2026-06-08',
      );

      expect(controller.todayMyAnswer?.body, '저는 노을 질 때가 좋아요.');
      expect(controller.todayPartnerAnswer?.body, '저는 아침 공기가 좋아요.');
      expect(controller.activeBalanceSelection, 'sea');
      expect(controller.activePartnerBalanceSelection, 'forest');
      expect(controller.visibleWishes.single.title, '조용한 카페에서 커피 마시기');
      expect(
        controller.latestReceivedCuriosityCard?.question,
        '요즘 제일 자주 생각나는 건 뭐예요?',
      );
      expect(controller.insight.questionCount, 1);
      expect(controller.insight.matchCount, 1);
    });

    test('session controller saves curiosity question and reply', () {
      final repository = RecordingAlagagiRepository();
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
            curiosityCards: [
              CuriosityCard(
                id: 'curiosity_existing',
                fromProfileId: 'minyoungUid',
                toProfileId: 'youngwooUid',
                question: '요즘 제일 자주 생각나는 건 뭐예요?',
                createdLabel: '오늘',
              ),
            ],
          ),
        ),
        repository: repository,
      );

      controller.updateCuriosityQuestionDraft('이번 주에 기대되는 일이 있어요?');
      controller.submitCuriosityQuestion();

      expect(repository.savedCuriosityCards.last.spaceId, 'main');
      expect(
        repository.savedCuriosityCards.last.card.fromProfileId,
        'youngwooUid',
      );
      expect(
        repository.savedCuriosityCards.last.card.toProfileId,
        'minyoungUid',
      );
      expect(
        repository.savedCuriosityCards.last.card.question,
        '이번 주에 기대되는 일이 있어요?',
      );

      controller.updateCuriosityReplyDraft(
        cardId: 'curiosity_existing',
        value: '산책하면서 생각을 정리하는 시간이요.',
      );
      controller.submitCuriosityReply('curiosity_existing');

      expect(repository.savedCuriosityCards.last.card.id, 'curiosity_existing');
      expect(
        repository.savedCuriosityCards.last.card.reply,
        '산책하면서 생각을 정리하는 시간이요.',
      );
      expect(
        controller.latestReceivedCuriosityCard?.reply,
        '산책하면서 생각을 정리하는 시간이요.',
      );
    });

    test('session controller blocks another curiosity while one waits', () {
      final repository = RecordingAlagagiRepository();
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
            curiosityCards: [
              CuriosityCard(
                id: 'curiosity_waiting',
                fromProfileId: 'youngwooUid',
                toProfileId: 'minyoungUid',
                question: '이번 주에 기대되는 일이 있어요?',
                createdLabel: '오늘',
              ),
            ],
          ),
        ),
        repository: repository,
      );

      controller.updateCuriosityQuestionDraft('하나 더 물어봐도 돼요?');
      controller.submitCuriosityQuestion();

      expect(repository.savedCuriosityCards, isEmpty);
      expect(controller.state.curiosityError, contains('답장을 기다리는'));
      expect(controller.state.curiosityQuestionDraft, '하나 더 물어봐도 돼요?');
    });

    test('daily progress selects the shared current question', () {
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
              startedDateKey: '2026-06-06',
              currentQuestionId: 'q003',
              openedDateKey: '2026-06-08',
            ),
          ),
        ),
        todayDateKey: '2026-06-08',
      );

      expect(controller.todayQuestion.id, 'q003');
      expect(controller.todayQuestion.number, 3);
    });

    test('daily progress derives today question from started date key', () {
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
              startedDateKey: '2026-06-07',
              currentQuestionId: 'q001',
              openedDateKey: '2026-06-09',
            ),
          ),
        ),
        todayDateKey: '2026-06-09',
      );

      expect(controller.todayQuestion.id, 'q003');
      expect(controller.dailyProgress.startedDateKey, '2026-06-07');
      expect(controller.dailyProgress.currentQuestionId, 'q003');
    });

    test('date change writes daily progress at most once', () {
      final repository = RecordingAlagagiRepository();

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
              startedDateKey: '2026-06-07',
              currentQuestionId: 'q002',
              openedDateKey: '2026-06-08',
            ),
          ),
        ),
        repository: repository,
        todayDateKey: '2026-06-09',
      );

      expect(controller.todayQuestion.id, 'q003');
      expect(repository.savedDailyQuestionProgress, hasLength(1));
      expect(
        repository.savedDailyQuestionProgress.single.progress.currentQuestionId,
        'q003',
      );
      expect(
        repository.savedDailyQuestionProgress.single.progress.openedDateKey,
        '2026-06-09',
      );
    });

    test('same date daily progress load does not write again', () {
      final repository = RecordingAlagagiRepository();

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
            dailyProgress: DailyQuestionProgress(
              startedDateKey: '2026-06-07',
              currentQuestionId: 'q003',
              openedDateKey: '2026-06-09',
            ),
          ),
        ),
        repository: repository,
        todayDateKey: '2026-06-09',
      );

      expect(repository.savedDailyQuestionProgress, isEmpty);
    });

    test('legacy progress migrates missing started date from opened date', () {
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
              currentQuestionId: 'q001',
              openedDateKey: '2026-06-08',
            ),
          ),
        ),
        todayDateKey: '2026-06-09',
      );

      expect(controller.dailyProgress.startedDateKey, '2026-06-08');
    });

    test('question calendar exposes past unanswered late answer state', () {
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
                body: '아침 시간이 좋아요.',
                createdLabel: '6월 7일',
              ),
              Answer(
                questionId: 'q001',
                profileId: 'minyoungUid',
                body: '저녁 산책이 좋아요.',
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
      );

      final day1 = controller.questionCalendarDays[0];
      final day2 = controller.questionCalendarDays[1];
      final today = controller.questionCalendarDays[2];

      expect(day1.status, QuestionCalendarStatus.bothAnswered);
      expect(day1.canLateAnswer, isFalse);
      expect(day2.status, QuestionCalendarStatus.unanswered);
      expect(day2.canLateAnswer, isTrue);
      expect(today.isToday, isTrue);
    });

    test('question calendar month grid follows today and selected month', () {
      final controller = AlagagiController.forSession(
        firebaseSessionWithData(
          const AlagagiSpaceData(
            dailyProgress: DailyQuestionProgress(
              startedDateKey: '2026-06-08',
              currentQuestionId: 'q015',
              openedDateKey: '2026-06-22',
            ),
          ),
        ),
        todayDateKey: '2026-06-22',
      );

      final todayWindow = controller.visibleQuestionCalendarDays;

      expect(todayWindow.length, inInclusiveRange(35, 42));
      expect(todayWindow.first.dateKey, '2026-06-01');
      expect(todayWindow.last.dateKey, '2026-07-05');
      expect(todayWindow.map((day) => day.question?.number), contains(15));
      expect(
        todayWindow.any((day) => day.isToday && day.question?.number == 15),
        isTrue,
      );
      expect(todayWindow.where((day) => day.isInDisplayedMonth), hasLength(30));
      expect(
        todayWindow
            .where((day) => !day.isInDisplayedMonth)
            .map((day) => day.dateKey),
        containsAll(['2026-07-01', '2026-07-05']),
      );

      controller.selectArchiveDate('2026-07-02');
      final selectedWindow = controller.visibleQuestionCalendarDays;

      expect(selectedWindow.length, inInclusiveRange(35, 42));
      expect(selectedWindow.first.dateKey, '2026-06-29');
      expect(selectedWindow.last.dateKey, '2026-08-02');
      expect(
        selectedWindow.where((day) => day.isInDisplayedMonth),
        hasLength(31),
      );
      expect(
        selectedWindow.any(
          (day) => day.isSelected && day.question?.number == 25,
        ),
        isTrue,
      );
    });

    test(
      'late answer saves the selected past question with one answer key',
      () {
        final repository = RecordingAlagagiRepository();
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
                startedDateKey: '2026-06-07',
                currentQuestionId: 'q001',
                openedDateKey: '2026-06-09',
              ),
            ),
          ),
          repository: repository,
          todayDateKey: '2026-06-09',
        );

        controller.startLateAnswer('q002');
        expect(controller.state.route, AlagagiRoute.answer);
        expect(controller.activeAnswerQuestion.id, 'q002');

        controller.updateDraftAnswer('늦게 남기는 답이에요.');
        controller.submitActiveAnswer();

        expect(repository.savedAnswers, hasLength(1));
        expect(repository.savedAnswers.single.answer.questionId, 'q002');
        expect(repository.savedAnswers.single.answer.profileId, 'youngwooUid');
        expect(repository.savedAnswers.single.answer.body, '늦게 남기는 답이에요.');
        expect(controller.answerForQuestion('q002')?.body, '늦게 남기는 답이에요.');
      },
    );

    test(
      'failed late answer keeps archive retryable until save succeeds',
      () async {
        final repository = RecordingAlagagiRepository()..failAnswerSaves = true;
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
                startedDateKey: '2026-06-07',
                currentQuestionId: 'q001',
                openedDateKey: '2026-06-09',
              ),
            ),
          ),
          repository: repository,
          todayDateKey: '2026-06-09',
        );

        controller.startLateAnswer('q002');
        controller.updateDraftAnswer('늦게 남기지만 실패할 답이에요.');
        controller.submitActiveAnswer();
        await Future<void>.delayed(Duration.zero);

        expect(controller.state.route, AlagagiRoute.archive);
        expect(controller.state.answerSaveStatus, SaveStatus.failed);
        expect(
          controller.selectedQuestionCalendarDay?.status,
          QuestionCalendarStatus.unanswered,
        );
        expect(controller.selectedQuestionCalendarDay?.canLateAnswer, isTrue);
        expect(controller.partnerAnswerForQuestion('q002'), isNull);

        repository.failAnswerSaves = false;
        controller.retryAnswerSave();
        await Future<void>.delayed(Duration.zero);

        expect(controller.state.answerSaveStatus, SaveStatus.saved);
        expect(
          controller.selectedQuestionCalendarDay?.status,
          QuestionCalendarStatus.myAnswerOnly,
        );
        expect(repository.savedAnswers.single.answer.questionId, 'q002');
      },
    );

    test('invalid daily progress safely falls back to the first question', () {
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
              startedDateKey: '2026-06-08',
              currentQuestionId: 'missing-question',
              openedDateKey: '2026-06-08',
            ),
          ),
        ),
        todayDateKey: '2026-06-08',
      );

      expect(controller.todayQuestion.id, 'q001');
    });

    test('last balance question completes instead of looping', () {
      final controller = AlagagiController.forSession(firebaseTestSession);

      while (!controller.isLastBalanceQuestion) {
        controller.nextBalanceQuestion();
      }

      expect(controller.activeBalanceQuestion.id, 'b008');

      controller.nextBalanceQuestion();

      expect(controller.state.route, AlagagiRoute.home);
      expect(controller.activeBalanceQuestion.id, 'b008');
    });

    test('wish draft creates and saves my wish', () {
      final repository = RecordingAlagagiRepository();
      final controller = AlagagiController.forSession(
        firebaseTestSession,
        repository: repository,
      );

      controller.startWishDraft();
      controller.setWishDraftKind(WishKind.activity);
      controller.updateWishDraftTitle('한강에서 같이 산책하기');
      controller.submitWishDraft();

      expect(controller.state.wishDraftVisible, isFalse);
      expect(controller.state.wishDraftTitle, isEmpty);
      expect(controller.visibleWishes.single.title, '한강에서 같이 산책하기');
      expect(controller.visibleWishes.single.kind, WishKind.activity);
      expect(controller.visibleWishes.single.createdByProfileId, 'youngwooUid');
      expect(
        controller.visibleWishes.single.likedByProfileIds,
        contains('youngwooUid'),
      );
      expect(repository.savedWishes.single.spaceId, 'main');
      expect(repository.savedWishes.single.wish.title, '한강에서 같이 산책하기');
    });

    test('empty wish draft stays open with validation error', () {
      final controller = AlagagiController.forSession(firebaseTestSession);

      controller.startWishDraft();
      controller.submitWishDraft();

      expect(controller.state.wishDraftVisible, isTrue);
      expect(controller.state.wishDraftError, contains('한 줄'));
      expect(controller.visibleWishes, isEmpty);
    });

    test('answer draft changes do not call repository writes', () {
      final repository = RecordingAlagagiRepository();
      final controller = AlagagiController.forSession(
        firebaseTestSession,
        repository: repository,
      );

      controller.updateDraftAnswer('아직 제출하지 않은 답변');

      expect(controller.state.draftAnswer, '아직 제출하지 않은 답변');
      expect(repository.savedAnswers, isEmpty);
    });

    test('answer edit persists same key with edited marker', () async {
      final repository = RecordingAlagagiRepository();
      final controller = AlagagiController.forSession(
        firebaseTestSession,
        repository: repository,
      );

      controller.updateDraftAnswer('처음 답변');
      controller.submitTodayAnswer();
      await Future<void>.delayed(Duration.zero);

      controller.editTodayAnswer();
      controller.updateDraftAnswer('수정한 답변');
      controller.submitTodayAnswer();
      await Future<void>.delayed(Duration.zero);

      expect(repository.savedAnswers, hasLength(2));
      expect(repository.savedAnswers.first.answer.questionId, 'q001');
      expect(repository.savedAnswers.last.answer.questionId, 'q001');
      expect(repository.savedAnswers.first.answer.profileId, 'youngwooUid');
      expect(repository.savedAnswers.last.answer.profileId, 'youngwooUid');
      expect(repository.savedAnswers.first.answer.edited, isFalse);
      expect(repository.savedAnswers.last.answer.edited, isTrue);
    });

    test('answer save failure exposes retry state', () async {
      final repository = RecordingAlagagiRepository()..failAnswerSaves = true;
      final controller = AlagagiController.forSession(
        firebaseTestSession,
        repository: repository,
      );

      controller.updateDraftAnswer('저장 실패를 확인하는 답변');
      controller.submitTodayAnswer();
      await Future<void>.delayed(Duration.zero);

      expect(controller.state.answerSaveStatus, SaveStatus.failed);
      expect(controller.state.answerError, contains('저장하지 못했어요'));
      expect(repository.savedAnswers, isEmpty);

      repository.failAnswerSaves = false;
      controller.retryAnswerSave();
      await Future<void>.delayed(Duration.zero);

      expect(controller.state.answerSaveStatus, SaveStatus.saved);
      expect(repository.savedAnswers.single.answer.body, '저장 실패를 확인하는 답변');
    });

    test('partner answer stays locked until my answer save succeeds', () async {
      final saveCompleter = Completer<void>();
      final repository = RecordingAlagagiRepository()
        ..answerSaveCompleter = saveCompleter;
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
                profileId: 'minyoungUid',
                body: '민영이의 답변',
                createdLabel: '오늘',
              ),
            ],
          ),
        ),
        repository: repository,
        todayDateKey: '2026-06-08',
      );

      controller.updateDraftAnswer('저장 중인 내 답변');
      controller.submitTodayAnswer();
      await Future<void>.delayed(Duration.zero);

      expect(controller.state.answerSaveStatus, SaveStatus.saving);
      expect(controller.todayMyAnswer?.body, '저장 중인 내 답변');
      expect(controller.todayPartnerAnswer, isNull);

      controller.updateAnswerCommentDraft(
        questionId: 'q001',
        answerOwnerProfileId: 'minyoungUid',
        value: '저장되기 전에는 댓글도 잠겨야 해요.',
      );
      controller.submitAnswerComment(
        questionId: 'q001',
        answerOwnerProfileId: 'minyoungUid',
      );

      expect(repository.savedAnswerComments, isEmpty);
      expect(controller.state.commentError, contains('상대 답이 열린 뒤'));

      saveCompleter.complete();
      await Future<void>.delayed(Duration.zero);

      expect(controller.state.answerSaveStatus, SaveStatus.saved);
      expect(controller.todayPartnerAnswer?.body, '민영이의 답변');
    });

    test(
      'failed answer save keeps partner answer locked until retry succeeds',
      () async {
        final repository = RecordingAlagagiRepository()..failAnswerSaves = true;
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
                  profileId: 'minyoungUid',
                  body: '민영이의 답변',
                  createdLabel: '오늘',
                ),
              ],
            ),
          ),
          repository: repository,
          todayDateKey: '2026-06-08',
        );

        controller.updateDraftAnswer('실패할 답변');
        controller.submitTodayAnswer();
        await Future<void>.delayed(Duration.zero);

        expect(controller.state.answerSaveStatus, SaveStatus.failed);
        expect(controller.todayPartnerAnswer, isNull);

        repository.failAnswerSaves = false;
        controller.retryAnswerSave();
        await Future<void>.delayed(Duration.zero);

        expect(controller.state.answerSaveStatus, SaveStatus.saved);
        expect(controller.todayPartnerAnswer?.body, '민영이의 답변');
      },
    );

    test('already liked wish interest tap is no-op in Firebase mode', () {
      final repository = RecordingAlagagiRepository();
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
            wishes: [
              WishItem(
                id: 'wish_1',
                icon: '☕',
                title: '조용한 카페 가기',
                kind: WishKind.place,
                createdByProfileId: 'minyoungUid',
                likedByProfileIds: {'youngwooUid'},
              ),
            ],
          ),
        ),
        repository: repository,
      );

      controller.toggleWishLike('wish_1');

      expect(controller.visibleWishes.single.likedByProfileIds, {
        'youngwooUid',
      });
      expect(repository.savedWishes, isEmpty);
    });

    test('calendar month grid includes today beyond the first 14 days', () {
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
              startedDateKey: '2026-06-01',
              currentQuestionId: 'q020',
              openedDateKey: '2026-06-20',
            ),
          ),
        ),
        todayDateKey: '2026-06-20',
      );

      final visibleDateKeys = controller.visibleQuestionCalendarDays
          .map((day) => day.dateKey)
          .toList();

      expect(visibleDateKeys.length, inInclusiveRange(35, 42));
      expect(visibleDateKeys.first, '2026-06-01');
      expect(visibleDateKeys, contains('2026-06-20'));
      expect(visibleDateKeys, contains('2026-06-30'));
      expect(
        controller.visibleQuestionCalendarDays
            .singleWhere((day) => day.dateKey == '2026-06-20')
            .isToday,
        isTrue,
      );
    });

    test('calendar month navigation changes only local state', () {
      final repository = RecordingAlagagiRepository();
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
              startedDateKey: '2026-06-01',
              currentQuestionId: 'q020',
              openedDateKey: '2026-06-20',
            ),
          ),
        ),
        repository: repository,
        todayDateKey: '2026-06-20',
      );

      controller.selectNextArchiveMonth();

      expect(
        controller.visibleQuestionCalendarDays.first.dateKey,
        '2026-06-29',
      );
      expect(
        controller.selectedQuestionCalendarDay?.dateKey.startsWith('2026-07'),
        isTrue,
      );

      controller.selectPreviousArchiveMonth();

      expect(
        controller.visibleQuestionCalendarDays.first.dateKey,
        '2026-06-01',
      );

      controller.selectTodayArchiveMonth();

      expect(controller.selectedQuestionCalendarDay?.dateKey, '2026-06-20');
      expect(repository.savedAnswers, isEmpty);
      expect(repository.savedDailyQuestionProgress, isEmpty);
    });

    test('answer comment draft does not write until submit', () {
      final repository = RecordingAlagagiRepository();
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
                body: '저는 노을 질 때가 좋아요.',
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

      controller.updateAnswerCommentDraft(
        questionId: 'q001',
        answerOwnerProfileId: 'minyoungUid',
        value: '이 답 좋다. 조금 더 듣고 싶어.',
      );

      expect(repository.savedAnswerComments, isEmpty);
      expect(
        controller.commentDraftForAnswer('q001', 'minyoungUid'),
        '이 답 좋다. 조금 더 듣고 싶어.',
      );
    });

    test(
      'answer comment save and edit overwrite the same comment key',
      () async {
        final repository = RecordingAlagagiRepository();
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
                  body: '저는 노을 질 때가 좋아요.',
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

        controller.updateAnswerCommentDraft(
          questionId: 'q001',
          answerOwnerProfileId: 'minyoungUid',
          value: '이 답 좋다.',
        );
        controller.submitAnswerComment(
          questionId: 'q001',
          answerOwnerProfileId: 'minyoungUid',
        );
        await Future<void>.delayed(Duration.zero);

        controller.updateAnswerCommentDraft(
          questionId: 'q001',
          answerOwnerProfileId: 'minyoungUid',
          value: '이 답 좋다. 조금 더 듣고 싶어.',
        );
        controller.submitAnswerComment(
          questionId: 'q001',
          answerOwnerProfileId: 'minyoungUid',
        );
        await Future<void>.delayed(Duration.zero);

        expect(repository.savedAnswerComments, hasLength(2));
        expect(repository.savedAnswerComments.first.comment.edited, isFalse);
        expect(repository.savedAnswerComments.last.comment.edited, isTrue);
        expect(repository.savedAnswerComments.last.comment.questionId, 'q001');
        expect(
          repository.savedAnswerComments.last.comment.answerOwnerProfileId,
          'minyoungUid',
        );
        expect(
          controller
              .commentForAnswer('q001', 'minyoungUid', 'youngwooUid')
              ?.body,
          '이 답 좋다. 조금 더 듣고 싶어.',
        );
      },
    );

    test('answer comment is rejected when partner answer is skipped', () {
      final repository = RecordingAlagagiRepository();
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
                body: '저는 노을 질 때가 좋아요.',
                createdLabel: '오늘',
              ),
              Answer(
                questionId: 'q001',
                profileId: 'minyoungUid',
                body: '',
                createdLabel: '오늘',
                skipped: true,
              ),
            ],
          ),
        ),
        repository: repository,
      );

      controller.updateAnswerCommentDraft(
        questionId: 'q001',
        answerOwnerProfileId: 'minyoungUid',
        value: '나중에 다시 들어볼게.',
      );
      controller.submitAnswerComment(
        questionId: 'q001',
        answerOwnerProfileId: 'minyoungUid',
      );

      expect(repository.savedAnswerComments, isEmpty);
      expect(controller.state.commentError, contains('상대 답이 열린 뒤'));
    });

    test('personalization draft saves only on explicit action', () async {
      final repository = RecordingAlagagiRepository();
      final controller = AlagagiController.forSession(
        firebaseTestSession,
        repository: repository,
      );

      controller.updatePersonalizationDraft(
        appTitle: '민영과 영우',
        homeLine: '천천히 알아가는 중',
      );

      expect(repository.savedPersonalizations, isEmpty);
      expect(controller.state.personalizationDraft.appTitle, '민영과 영우');

      controller.savePersonalizationDraft();
      await Future<void>.delayed(Duration.zero);

      expect(repository.savedPersonalizations.single.spaceId, 'main');
      expect(
        repository.savedPersonalizations.single.personalization.appTitle,
        '민영과 영우',
      );
      expect(controller.state.personalization.appTitle, '민영과 영우');
      expect(controller.state.personalization.homeLine, '천천히 알아가는 중');
    });

    test(
      'music notes load from session data and save only on submit',
      () async {
        final repository = RecordingAlagagiRepository();
        final controller = AlagagiController.forSession(
          firebaseSessionWithData(
            const AlagagiSpaceData(
              musicNotes: [
                MusicNote(
                  id: 'music_1',
                  title: '밤 산책',
                  artist: '민영의 추천',
                  link: 'https://music.example/night',
                  note: '퇴근길에 들으면 차분해져요.',
                  mood: '밤',
                  createdByProfileId: 'minyoungUid',
                  createdLabel: '오늘',
                ),
              ],
            ),
          ),
          repository: repository,
        );

        expect(controller.musicNotes.single.title, '밤 산책');
        expect(controller.musicNotes.single.createdByProfileId, 'minyoungUid');

        controller.startMusicDraft();
        controller.updateMusicDraft(
          title: '오후의 문장',
          artist: 'Unknown Artist',
          link: 'https://music.example/afternoon',
          note: '카페에서 이야기할 때 배경에 있으면 좋을 것 같아서요.',
        );
        controller.setMusicDraftMood('카페');

        expect(repository.savedMusicNotes, isEmpty);

        controller.submitMusicDraft();
        await Future<void>.delayed(Duration.zero);

        expect(repository.savedMusicNotes.single.spaceId, 'main');
        expect(repository.savedMusicNotes.single.note.title, '오후의 문장');
        expect(repository.savedMusicNotes.single.note.artist, 'Unknown Artist');
        expect(repository.savedMusicNotes.single.note.mood, '카페');
        expect(
          repository.savedMusicNotes.single.note.createdByProfileId,
          'youngwooUid',
        );
        expect(controller.state.musicDraftVisible, isFalse);
        expect(controller.musicNotes.first.title, '오후의 문장');
      },
    );

    test('music note edit overwrites the existing own note document', () async {
      final repository = RecordingAlagagiRepository();
      final controller = AlagagiController.forSession(
        firebaseSessionWithData(
          AlagagiSpaceData(
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
            ],
          ),
        ),
        repository: repository,
      );

      controller.startMusicEdit('music_mine');
      expect(controller.state.musicDraftVisible, isTrue);
      expect(controller.state.editingMusicNoteId, 'music_mine');
      expect(controller.state.musicDraftTitle, '밤 산책');

      controller.updateMusicDraft(
        title: '다시 듣는 밤 산책',
        artist: '영우의 추천',
        link: 'https://music.example/night-v2',
        note: '조금 더 천천히 듣고 싶어서요.',
      );
      controller.setMusicDraftMood('산책');
      controller.submitMusicDraft();
      await Future<void>.delayed(Duration.zero);

      expect(controller.musicNotes, hasLength(1));
      expect(controller.musicNotes.single.id, 'music_mine');
      expect(controller.musicNotes.single.title, '다시 듣는 밤 산책');
      expect(controller.musicNotes.single.mood, '산책');
      expect(controller.state.editingMusicNoteId, isNull);
      expect(repository.savedMusicNotes, hasLength(1));
      expect(repository.savedMusicNotes.single.note.id, 'music_mine');
      expect(repository.savedMusicNotes.single.note.title, '다시 듣는 밤 산책');
      expect(repository.savedMusicNotes.single.note.updatedAt, isNotNull);
    });

    test(
      'home progress summary uses local seen time for new partner music notes',
      () {
        final seenStore = MemoryMusicNoteSeenStore()
          ..writeLastSeenMusicNoteAt(
            'main',
            'youngwooUid',
            DateTime.parse('2026-06-09T08:00:00.000Z'),
          );
        final controller = AlagagiController.forSession(
          firebaseSessionWithData(
            AlagagiSpaceData(
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
                MusicNote(
                  id: 'music_mine_new',
                  title: '오후의 문장',
                  artist: '영우의 추천',
                  link: 'https://music.example/afternoon',
                  note: '카페에서 이야기할 때 배경에 있으면 좋을 것 같아서요.',
                  mood: '카페',
                  createdByProfileId: 'youngwooUid',
                  createdLabel: '오늘',
                  updatedAt: DateTime.parse('2026-06-09T11:00:00.000Z'),
                ),
              ],
            ),
          ),
          musicNoteSeenStore: seenStore,
        );

        final musicItem = controller.homeProgressSummary.items.singleWhere(
          (item) => item.id == 'music',
        );

        expect(musicItem.stateText, '새 음악 노트가 있어요');
        expect(
          controller.homeProgressSummary.primaryAction?.route,
          isNot(AlagagiRoute.music),
        );

        controller.goTo(AlagagiRoute.music);

        expect(
          seenStore.readLastSeenMusicNoteAt('main', 'youngwooUid'),
          DateTime.parse('2026-06-09T11:00:00.000Z'),
        );
        expect(
          controller.homeProgressSummary.items
              .singleWhere((item) => item.id == 'music')
              .stateText,
          '최근 음악 노트 2곡',
        );
      },
    );
  });
}

const firebaseTestSession = AlagagiSession(
  spaceId: 'main',
  me: AppProfile(id: 'youngwooUid', nickname: '영우', avatar: '🌿', isMe: true),
  partner: AppProfile(
    id: 'minyoungUid',
    nickname: '민영',
    avatar: '🪻',
    isMe: false,
  ),
);

AlagagiSession firebaseSessionWithData(AlagagiSpaceData data) {
  return AlagagiSession(
    spaceId: firebaseTestSession.spaceId,
    me: firebaseTestSession.me,
    partner: firebaseTestSession.partner,
    data: data,
  );
}

class RecordingAlagagiRepository implements AlagagiDataRepository {
  bool failAnswerSaves = false;
  bool failAnswerCommentSaves = false;
  Completer<void>? answerSaveCompleter;
  final List<({String spaceId, Answer answer})> savedAnswers = [];
  final List<({String spaceId, BalanceSelection selection})>
  savedBalanceSelections = [];
  final List<({String spaceId, String profileId, ProfileSlot slot})>
  savedProfileSlots = [];
  final List<({String spaceId, WishItem wish})> savedWishes = [];
  final List<({String spaceId, MusicNote note})> savedMusicNotes = [];
  final List<({String spaceId, AnswerComment comment})> savedAnswerComments =
      [];
  final List<({String spaceId, CuriosityCard card})> savedCuriosityCards = [];
  final List<({String spaceId, DailyQuestionProgress progress})>
  savedDailyQuestionProgress = [];
  final List<({String spaceId, SpacePersonalization personalization})>
  savedPersonalizations = [];

  @override
  Future<AlagagiSession?> loadSession(AlagagiAuthUser user) async {
    return null;
  }

  @override
  Future<void> saveAnswer(String spaceId, Answer answer) async {
    final completer = answerSaveCompleter;
    if (completer != null) {
      await completer.future;
    }
    if (failAnswerSaves) {
      throw StateError('save failed');
    }
    savedAnswers.add((spaceId: spaceId, answer: answer));
  }

  @override
  Future<void> saveBalanceSelection(
    String spaceId,
    BalanceSelection selection,
  ) async {
    savedBalanceSelections.add((spaceId: spaceId, selection: selection));
  }

  @override
  Future<void> saveProfileSlot(
    String spaceId,
    String profileId,
    ProfileSlot slot,
  ) async {
    savedProfileSlots.add((spaceId: spaceId, profileId: profileId, slot: slot));
  }

  @override
  Future<void> saveWish(String spaceId, WishItem wish) async {
    savedWishes.add((spaceId: spaceId, wish: wish));
  }

  @override
  Future<void> saveMusicNote(String spaceId, MusicNote note) async {
    savedMusicNotes.add((spaceId: spaceId, note: note));
  }

  @override
  Future<void> saveCuriosityCard(String spaceId, CuriosityCard card) async {
    savedCuriosityCards.add((spaceId: spaceId, card: card));
  }

  @override
  Future<void> saveAnswerComment(String spaceId, AnswerComment comment) async {
    if (failAnswerCommentSaves) {
      throw StateError('comment save failed');
    }
    savedAnswerComments.add((spaceId: spaceId, comment: comment));
  }

  @override
  Future<void> saveDailyQuestionProgress(
    String spaceId,
    DailyQuestionProgress progress,
  ) async {
    savedDailyQuestionProgress.add((spaceId: spaceId, progress: progress));
  }

  @override
  Future<void> saveSpacePersonalization(
    String spaceId,
    SpacePersonalization personalization,
  ) async {
    savedPersonalizations.add((
      spaceId: spaceId,
      personalization: personalization,
    ));
  }
}
