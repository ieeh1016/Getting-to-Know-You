import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Firestore rules file stays in sync with Firebase setup docs', () {
    final rules = File('firestore.rules').readAsStringSync().trimRight();
    final firebaseSetup = File('docs/firebase_setup.md').readAsStringSync();
    final documentedRules = _extractFirestoreRulesBlock(firebaseSetup);

    expect(documentedRules.trimRight(), rules);
  });

  test('Firestore repository collections are covered by security rules', () {
    final repository = File(
      'lib/src/data/firebase_alagagi_repositories.dart',
    ).readAsStringSync();
    final rules = File('firestore.rules').readAsStringSync();
    final collectionNames = RegExp(
      r"\.collection\('([^']+)'\)",
    ).allMatches(repository).map((match) => match.group(1)!).toSet();

    expect(collectionNames, isNotEmpty);

    for (final collectionName in collectionNames) {
      expect(
        rules,
        contains(_rulesMatchPatternForCollection(collectionName)),
        reason:
            'Firestore collection "$collectionName" is used by the repository '
            'but is not covered by firestore.rules.',
      );
    }
  });

  test('shared place rules cover repository write metadata and date links', () {
    final repository = File(
      'lib/src/data/firebase_alagagi_repositories.dart',
    ).readAsStringSync();
    final rules = File('firestore.rules').readAsStringSync();

    expect(
      RegExp(
        r"'updatedByProfileId'\s*:\s*place\.updatedByProfileId\s*\?\?\s*place\.createdByProfileId",
      ).hasMatch(repository),
      isTrue,
      reason:
          'saveSharedPlace writes updatedByProfileId, so sharedPlaces rules '
          'must allow and validate the field.',
    );
    expect(rules, contains("'updatedByProfileId'"));
    expect(
      rules,
      contains('request.resource.data.updatedByProfileId == request.auth.uid'),
    );
    expect(rules, contains('request.resource.data.updatedAt == request.time'));
    expect(rules, contains('function validSharedPlaceMeetingLinkUpdate'));
    expect(
      rules,
      contains('validSharedPlaceMeetingLinkUpdate(spaceId, placeId)'),
    );
  });

  test('shared place rules allow legacy map metadata normalization', () {
    final rules = File('firestore.rules').readAsStringSync();

    expect(
      rules,
      contains('function preservesOrNormalizesSharedPlaceMapFields'),
    );
    expect(
      rules,
      contains('request.resource.data.providerPlaceId.size() <= 80'),
    );
    expect(rules, contains('request.resource.data.providerPlaceId.size() > 0'));
    expect(rules, contains('request.resource.data.latitude == null'));
    expect(rules, contains('request.resource.data.longitude == null'));
    expect(rules, contains("'providerPlaceId'"));
    expect(rules, contains("'latitude'"));
    expect(rules, contains("'longitude'"));
  });

  test('music note rules allow custom mood labels used by the app', () {
    final controller = File(
      'lib/src/domain/alagagi_controller.dart',
    ).readAsStringSync();
    final rules = File('firestore.rules').readAsStringSync();

    expect(controller, contains('if (mood.length > 16)'));
    expect(rules, contains('request.resource.data.mood is string'));
    expect(rules, contains('request.resource.data.mood.size() > 0'));
    expect(rules, contains('request.resource.data.mood.size() <= 16'));
    expect(
      rules,
      isNot(contains('request.resource.data.mood in [')),
      reason:
          'The music UI supports typed custom moods, so Firestore rules must '
          'not restrict music notes to the quick mood chips only.',
    );
  });

  test(
    'curiosity rules cover repository write metadata for questions and replies',
    () {
      final repository = File(
        'lib/src/data/firebase_alagagi_repositories.dart',
      ).readAsStringSync();
      final rules = File('firestore.rules').readAsStringSync();
      final method = RegExp(
        r'Future<void> saveCuriosityCard[\s\S]*?\n  @override',
      ).firstMatch(repository)?.group(0);
      final curiosityRules = RegExp(
        r'function validCuriosityCardShape[\s\S]*?function validStockStoryShape',
      ).firstMatch(rules)?.group(0);

      expect(method, isNotNull);
      expect(curiosityRules, isNotNull);
      expect(method, contains("'updatedByProfileId'"));
      expect(curiosityRules, contains("'updatedByProfileId'"));
      expect(
        curiosityRules,
        contains('request.resource.data.updatedByProfileId is string'),
      );
      expect(
        curiosityRules,
        contains('request.resource.data.updatedByProfileId in get'),
      );
      expect(
        curiosityRules,
        contains(
          'request.resource.data.updatedByProfileId == request.auth.uid',
        ),
      );
    },
  );

  test('shared place meeting link saves use a narrow Firestore patch', () {
    final repository = File(
      'lib/src/data/firebase_alagagi_repositories.dart',
    ).readAsStringSync();
    final rules = File('firestore.rules').readAsStringSync();
    final method = RegExp(
      r'Future<void> saveSharedPlaceMeetingLinks[\s\S]*?\n  @override',
    ).firstMatch(repository)?.group(0);
    final patchPayload = RegExp(
      r'Map<String, Object\?> _sharedPlaceMeetingLinkPatchToData[\s\S]*?\n  String _mapApiProviderToData',
    ).firstMatch(repository)?.group(0);

    expect(method, isNotNull);
    expect(patchPayload, isNotNull);
    expect(patchPayload, contains("'meetingPlanLinks'"));
    expect(patchPayload, contains("'linkedDateKey'"));
    expect(patchPayload, contains("'interestedByProfileIds'"));
    expect(method, contains('_updateWithActivityEvent('));
    expect(repository, contains('batch.update(reference, data)'));
    expect(method, isNot(contains('SetOptions(merge: true)')));
    expect(patchPayload, isNot(contains("'name'")));
    expect(patchPayload, isNot(contains("'providerPlaceId'")));
    expect(rules, contains('function validSharedPlaceMeetingPatchUpdate'));
    expect(
      rules,
      contains('request.resource.data.interestedByProfileIds.hasOnly'),
    );
    expect(rules, contains('request.resource.data.updatedByProfileId in get'));
    expect(rules, contains('request.resource.data.updatedAt is timestamp'));
    expect(
      rules,
      contains('validSharedPlaceMeetingPatchUpdate(spaceId, placeId)'),
    );
  });

  test('answer comment rules separate comment authors from reply authors', () {
    final repository = File(
      'lib/src/data/firebase_alagagi_repositories.dart',
    ).readAsStringSync();
    final rules = File('firestore.rules').readAsStringSync();

    expect(repository, contains("'replyBody'"));
    expect(repository, contains("'repliedByProfileId'"));
    expect(repository, contains("'replyCreatedLabel'"));
    expect(repository, contains("'replyEdited'"));
    expect(rules, contains('function validAnswerCommentOwnerWrite'));
    expect(rules, contains('function validAnswerCommentReplyWrite'));
    expect(rules, contains('preservesExistingAnswerCommentReply'));
    expect(
      rules,
      contains('request.resource.data.repliedByProfileId == request.auth.uid'),
    );
  });

  test('music note comments are separate owner-scoped documents', () {
    final repository = File(
      'lib/src/data/firebase_alagagi_repositories.dart',
    ).readAsStringSync();
    final rules = File('firestore.rules').readAsStringSync();

    expect(repository, contains("collection('musicNoteComments')"));
    expect(repository, contains('Future<void> saveMusicNoteComment'));
    expect(repository, contains('Future<void> deleteMusicNoteComment'));
    expect(rules, contains('match /musicNoteComments/{commentId}'));
    expect(rules, contains('function validMusicNoteCommentShape'));
    expect(rules, contains('function validMusicNoteCommentOwnerEdit'));
    expect(
      rules,
      contains('resource.data.createdByProfileId == request.auth.uid'),
    );
  });

  test('memory card rules cover visibility and response writes', () {
    final repository = File(
      'lib/src/data/firebase_alagagi_repositories.dart',
    ).readAsStringSync();
    final rules = File('firestore.rules').readAsStringSync();

    expect(repository, contains("collection('memoryCards')"));
    expect(repository, contains("collection('memoryCardResponses')"));
    expect(rules, contains('match /memoryCards/{cardId}'));
    expect(rules, contains('match /memoryCardResponses/{responseId}'));
    expect(rules, contains("resource.data.visibility == 'shared'"));
    expect(
      rules,
      contains('request.resource.data.createdByProfileId == request.auth.uid'),
    );
    expect(rules, contains('function validMemoryCardResponseWrite'));
    expect(
      rules,
      contains(
        "memoryCardDocument(spaceId, request.resource.data.cardId).data.visibility == 'shared'",
      ),
    );
    expect(
      rules,
      contains(
        'memoryCardDocument(spaceId, request.resource.data.cardId).data.createdByProfileId != request.auth.uid',
      ),
    );
  });

  test('push notification pipeline stays dormant for Spark plan', () {
    final app = File('lib/src/ui/alagagi_app.dart').readAsStringSync();
    final pushService = File(
      'lib/src/data/push_notifications.dart',
    ).readAsStringSync();
    final rules = File('firestore.rules').readAsStringSync();
    final functions = File('functions/index.js').readAsStringSync();
    final firebaseConfig = File('firebase.json').readAsStringSync();
    final firebaseSetup = File('docs/firebase_setup.md').readAsStringSync();
    final firebaseRepository = File(
      'lib/src/data/firebase_alagagi_repositories.dart',
    ).readAsStringSync();

    expect(
      app,
      contains(
        "const kPushNotificationsEnabled = bool.fromEnvironment(\n  'ENABLE_PUSH_NOTIFICATIONS'",
      ),
    );
    expect(
      firebaseRepository,
      contains("bool.fromEnvironment('ENABLE_ACTIVITY_EVENTS')"),
    );
    expect(firebaseRepository, contains('if (!_activityEventsEnabled ||'));
    expect(pushService, contains("collection('notificationSettings')"));
    expect(pushService, contains("collection('notificationTokens')"));
    expect(firebaseRepository, contains("collection('activityEvents')"));
    expect(rules, contains('match /notificationSettings/{settingId}'));
    expect(rules, contains('match /notificationTokens/{tokenId}'));
    expect(rules, contains('match /activityEvents/{eventId}'));
    expect(rules, contains('request.auth.uid == userId'));
    expect(rules, contains('validPushNotificationToken'));
    expect(rules, contains('validActivityEvent'));
    expect(
      rules,
      contains('request.resource.data.actorProfileId == request.auth.uid'),
    );
    expect(firebaseConfig, isNot(contains('"functions"')));
    expect(functions, contains('notifyActivityEventCreated'));
    expect(functions, contains('activityEvents'));
    expect(functions, contains('ACTIVITY_NOTIFICATION_COPY'));
    expect(functions, contains('resolveRecipientUid'));
    expect(functions, contains('sendEachForMulticast'));
    expect(functions, contains('markNotificationEvent'));
    expect(functions, isNot(contains('card.title')));
    expect(functions, isNot(contains('card.body')));
    expect(firebaseSetup, contains('Spark'));
    expect(firebaseSetup, contains('푸시 알림 서버 경로는 휴면'));
  });

  test('meeting plan rules do not cap plan item count at eight', () {
    final rules = File('firestore.rules').readAsStringSync();

    expect(rules, isNot(contains('meetingPlanItems.size() <= 8')));
    expect(rules, isNot(contains('items.size() <= 8')));
    expect(rules, contains('request.resource.data.meetingPlanItems is list'));
    expect(rules, contains('request.resource.data.items is list'));
  });

  test('improvement owner replies and completion stay owner-only', () {
    final rules = File('firestore.rules').readAsStringSync();

    expect(rules, contains("currentUserProfile().data.role == 'owner'"));
    expect(rules, contains('validImprovementPostOwnerStatusUpdate'));
    expect(rules, contains("'ownerNote'"));
    expect(rules, contains("'resolved'"));
  });

  test('multi-agent harness playbook is linked and role complete', () {
    final agents = File('AGENTS.md').readAsStringSync();
    final playbook = File('docs/agent_harness_playbook.md').readAsStringSync();

    expect(agents, contains('docs/agent_harness_playbook.md'));
    expect(playbook, contains('Orchestrator Agent'));
    expect(playbook, contains('Spec Agent'));
    expect(playbook, contains('Test Agent'));
    expect(playbook, contains('Implementation Agent'));
    expect(playbook, contains('UI QA Agent'));
    expect(playbook, contains('Firebase Rules/Budget Agent'));
    expect(playbook, contains('Verification Agent'));
    expect(playbook, contains('앱 runtime에는 AI agent가 포함되지 않는다.'));
    expect(
      playbook,
      contains('test code, snapshot, golden, fixture를 임의로 수정하지 않는다.'),
    );
  });

  test('AI context routing and trace lookup docs are linked', () {
    final agents = File('AGENTS.md').readAsStringSync();
    final contextMap = File('docs/ai_context_map.md').readAsStringSync();
    final specTrace = File('docs/spec_trace.md').readAsStringSync();
    final testPlan = File('docs/test_plan.md').readAsStringSync();
    final playbook = File('docs/agent_harness_playbook.md').readAsStringSync();

    expect(agents, contains('docs/ai_context_map.md'));
    expect(agents, contains('docs/spec_trace.md'));
    expect(agents, contains('Context 효율 규칙'));
    expect(contextMap, contains('Routing Table'));
    expect(contextMap, contains('Verification Log Summary Rule'));
    expect(contextMap, contains('source of truth를 대체하지 않고'));
    expect(specTrace, contains('HARNESS-002'));
    expect(specTrace, contains('Q-ANSWER-001'));
    expect(specTrace, contains('MUSIC-COMMENT-001'));
    expect(testPlan, contains('Trace ID 운영'));
    expect(testPlan, contains('[HARNESS-002]'));
    expect(playbook, contains('docs/ai_context_map.md'));
    expect(playbook, contains('첫 관련 failure'));
  });

  test('portable AI app process stays bootstrap-oriented', () {
    final process = File('AI_APP_DEV_PROCESS.md').readAsStringSync();
    final specTrace = File('docs/spec_trace.md').readAsStringSync();
    final testPlan = File('docs/test_plan.md').readAsStringSync();

    expect(process, contains('휴대 가능한 방법론 seed'));
    expect(process, contains('영구적인 제품 `source of truth`가 아니다'));
    expect(process, contains('첫 30분 프로토콜'));
    expect(process, contains('production app code는 만들거나 수정하지 마'));
    expect(process, contains('README.md'));
    expect(process, contains('AGENTS.md'));
    expect(process, contains('docs/spec.md'));
    expect(process, contains('docs/test_plan.md'));
    expect(process, contains('docs/ai_context_map.md'));
    expect(process, contains('docs/spec_trace.md'));
    expect(process, contains('동작 변경은 문서화된 예외가 없는 한 fail-first testing'));
    expect(process, contains('No-test reason'));
    expect(process, contains('Context Budget'));
    expect(process, contains('부트스트랩 완료 기준'));
    expect(process, contains('이 프로토콜 후 agent는 멈춘다'));
    expect(specTrace, contains('HARNESS-003'));
    expect(testPlan, contains('[HARNESS-003]'));
  });

  test('design proposal HTML guide is linked and structure complete', () {
    final agents = File('AGENTS.md').readAsStringSync();
    final guide = File('docs/design/README.md').readAsStringSync();

    expect(agents, contains('docs/design/README.md'));
    expect(guide, contains('Design Proposal HTML Guide'));
    expect(guide, contains('source of truth가 아니다'));
    expect(guide, contains('390px-class mobile'));
    expect(guide, contains('page-title'));
    expect(guide, contains('principles'));
    expect(guide, contains('stage'));
    expect(guide, contains('proposal-note'));
    expect(guide, contains('Firestore write'));
    expect(guide, contains('status bar mock'));
  });

  test('CI deploys Spark-compatible Firebase rules from repository source', () {
    final firebaseConfig =
        jsonDecode(File('firebase.json').readAsStringSync())
            as Map<String, dynamic>;
    final firestoreConfig = firebaseConfig['firestore'] as Map<String, dynamic>;
    final workflow = File('.github/workflows/deploy.yml').readAsStringSync();
    final firebaseSetup = File('docs/firebase_setup.md').readAsStringSync();

    expect(firestoreConfig['rules'], 'firestore.rules');
    expect(firebaseConfig.containsKey('functions'), isFalse);
    expect(workflow, contains('firebase deploy --only firestore:rules'));
    expect(
      workflow,
      isNot(contains('firebase deploy --only firestore:rules,functions')),
    );
    expect(workflow, contains('Firebase rules deploy failed'));
    expect(workflow, isNot(contains('npm install --prefix functions')));
    expect(workflow, contains('FIREBASE_SERVICE_ACCOUNT'));
    expect(workflow, contains('google-github-actions/auth@v2'));
    expect(workflow, contains('credentials_json:'));
    expect(workflow, contains('create_credentials_file: true'));
    expect(workflow, contains('export_environment_variables: true'));
    expect(
      workflow,
      isNot(contains(r'''printf '%s' "$FIREBASE_SERVICE_ACCOUNT"''')),
      reason:
          'CI should let the Google auth action create the ADC file instead '
          'of writing service account JSON by hand.',
    );
    expect(workflow, contains("if: github.event_name != 'pull_request'"));
    expect(firebaseSetup, contains('roles/firebaserules.admin'));
    expect(firebaseSetup, contains('Spark'));
    expect(firebaseSetup, contains('firebase deploy --only firestore:rules'));
  });
}

String _extractFirestoreRulesBlock(String markdown) {
  final match = RegExp(
    r'## 6\. Firestore Security Rules[\s\S]*?```js\n([\s\S]*?)\n```',
  ).firstMatch(markdown);
  if (match == null) {
    fail('Could not find Firestore rules code block in docs/firebase_setup.md');
  }
  return match.group(1)!;
}

String _rulesMatchPatternForCollection(String collectionName) {
  return switch (collectionName) {
    'users' => 'match /users/{userId}',
    'spaces' => 'match /spaces/{spaceId}',
    'profileCards' => 'match /profileCards/{profileId}/slots/{slotId}',
    'slots' => 'match /profileCards/{profileId}/slots/{slotId}',
    _ => 'match /$collectionName/',
  };
}
