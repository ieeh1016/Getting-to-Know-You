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
          ),
        ),
        todayDateKey: '2026-06-08',
      );

      expect(controller.todayMyAnswer?.body, '저는 노을 질 때가 좋아요.');
      expect(controller.todayPartnerAnswer?.body, '저는 아침 공기가 좋아요.');
      expect(controller.activeBalanceSelection, 'sea');
      expect(controller.activePartnerBalanceSelection, 'forest');
      expect(controller.visibleWishes.single.title, '조용한 카페에서 커피 마시기');
      expect(controller.insight.questionCount, 1);
      expect(controller.insight.matchCount, 1);
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

    test('question calendar window follows day 15 and selected day', () {
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

      expect(todayWindow, hasLength(14));
      expect(todayWindow.first.question?.number, greaterThan(1));
      expect(todayWindow.map((day) => day.question?.number), contains(15));
      expect(
        todayWindow.any((day) => day.isToday && day.question?.number == 15),
        isTrue,
      );

      controller.selectArchiveDate('2026-06-25');
      final selectedWindow = controller.visibleQuestionCalendarDays;

      expect(selectedWindow, hasLength(14));
      expect(selectedWindow.first.question?.number, greaterThan(1));
      expect(selectedWindow.map((day) => day.question?.number), contains(18));
      expect(
        selectedWindow.any(
          (day) => day.isSelected && day.question?.number == 18,
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

    test('calendar visible window includes today beyond the first 14 days', () {
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

      expect(visibleDateKeys, hasLength(14));
      expect(visibleDateKeys, contains('2026-06-20'));
      expect(visibleDateKeys, isNot(contains('2026-06-01')));
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
  Completer<void>? answerSaveCompleter;
  final List<({String spaceId, Answer answer})> savedAnswers = [];
  final List<({String spaceId, BalanceSelection selection})>
  savedBalanceSelections = [];
  final List<({String spaceId, String profileId, ProfileSlot slot})>
  savedProfileSlots = [];
  final List<({String spaceId, WishItem wish})> savedWishes = [];
  final List<({String spaceId, AnswerComment comment})> savedAnswerComments =
      [];
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
  Future<void> saveAnswerComment(String spaceId, AnswerComment comment) async {
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
