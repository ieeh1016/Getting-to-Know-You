// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;

import '../domain/alagagi_controller.dart';

MusicNoteSeenStore createMusicNoteSeenStore() {
  return BrowserMusicNoteSeenStore();
}

class BrowserMusicNoteSeenStore implements MusicNoteSeenStore {
  @override
  DateTime? readLastSeenAt(
    String spaceId,
    String profileId,
    UnreadActivityFeature feature,
  ) {
    final raw =
        html.window.localStorage[_key(spaceId, profileId, feature)] ??
        (feature == UnreadActivityFeature.music
            ? html.window.localStorage[_legacyMusicKey(spaceId, profileId)]
            : null);
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }
    return DateTime.tryParse(raw);
  }

  @override
  void writeLastSeenAt(
    String spaceId,
    String profileId,
    UnreadActivityFeature feature,
    DateTime timestamp,
  ) {
    html.window.localStorage[_key(spaceId, profileId, feature)] = timestamp
        .toUtc()
        .toIso8601String();
  }

  @override
  DateTime? readLastSeenMusicNoteAt(String spaceId, String profileId) {
    return readLastSeenAt(spaceId, profileId, UnreadActivityFeature.music);
  }

  @override
  void writeLastSeenMusicNoteAt(
    String spaceId,
    String profileId,
    DateTime timestamp,
  ) {
    writeLastSeenAt(spaceId, profileId, UnreadActivityFeature.music, timestamp);
  }

  String _key(String spaceId, String profileId, UnreadActivityFeature feature) {
    return 'alagagi:lastSeen:${feature.storageKey}:$spaceId:$profileId';
  }

  String _legacyMusicKey(String spaceId, String profileId) {
    return 'alagagi:lastSeenMusicNoteAt:$spaceId:$profileId';
  }
}
