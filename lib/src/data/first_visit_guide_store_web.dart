// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;

import '../domain/alagagi_controller.dart';

FirstVisitGuideStore createFirstVisitGuideStore() {
  return BrowserFirstVisitGuideStore();
}

class BrowserFirstVisitGuideStore implements FirstVisitGuideStore {
  @override
  bool hasSeenFirstVisitGuide(String spaceId, String profileId) {
    return html.window.localStorage[_key(spaceId, profileId)] == 'true';
  }

  @override
  void markFirstVisitGuideSeen(String spaceId, String profileId) {
    html.window.localStorage[_key(spaceId, profileId)] = 'true';
  }

  String _key(String spaceId, String profileId) {
    return 'jogeumssik:onboardingSeen:$spaceId:$profileId';
  }
}
