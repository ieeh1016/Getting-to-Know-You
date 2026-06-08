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
              currentQuestionId: 'q003',
              openedDateKey: '2026-06-08',
            ),
          ),
        ),
      );

      expect(controller.todayQuestion.id, 'q003');
      expect(controller.todayQuestion.number, 3);
    });

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
              currentQuestionId: 'missing-question',
              openedDateKey: '2026-06-08',
            ),
          ),
        ),
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
        homeLine: '천천히 가까워지는 중',
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
      expect(controller.state.personalization.homeLine, '천천히 가까워지는 중');
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

class RecordingAlagagiRepository implements AlagagiDataRepository {
  bool failAnswerSaves = false;
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
