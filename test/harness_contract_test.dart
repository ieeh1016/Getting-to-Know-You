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
    expect(method, contains('.update('));
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

  test('CI deploys canonical Firestore rules from repository source', () {
    final firebaseConfig =
        jsonDecode(File('firebase.json').readAsStringSync())
            as Map<String, dynamic>;
    final firestoreConfig = firebaseConfig['firestore'] as Map<String, dynamic>;
    final workflow = File('.github/workflows/deploy.yml').readAsStringSync();
    final firebaseSetup = File('docs/firebase_setup.md').readAsStringSync();

    expect(firestoreConfig['rules'], 'firestore.rules');
    expect(workflow, contains('firebase deploy --only firestore:rules'));
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
    expect(firebaseSetup, contains('roles/serviceusage.serviceUsageViewer'));
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
