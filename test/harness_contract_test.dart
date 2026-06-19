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
    expect(playbook, contains('does not include AI agents.'));
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
    expect(workflow, contains('GOOGLE_APPLICATION_CREDENTIALS'));
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
