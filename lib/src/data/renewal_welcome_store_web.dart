// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;

import '../domain/alagagi_controller.dart';

RenewalWelcomeStore createRenewalWelcomeStore() {
  return BrowserRenewalWelcomeStore();
}

class BrowserRenewalWelcomeStore implements RenewalWelcomeStore {
  @override
  bool hasSeenRenewalWelcome(String spaceId, String profileId, String version) {
    return html.window.localStorage[_key(spaceId, profileId, version)] ==
        'true';
  }

  @override
  void markRenewalWelcomeSeen(
    String spaceId,
    String profileId,
    String version,
  ) {
    html.window.localStorage[_key(spaceId, profileId, version)] = 'true';
  }

  String _key(String spaceId, String profileId, String version) {
    return 'jogeumssik:renewalWelcomeSeen:$version:$spaceId:$profileId';
  }
}
