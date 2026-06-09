// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;

import '../domain/alagagi_controller.dart';

MusicNoteSeenStore createMusicNoteSeenStore() {
  return BrowserMusicNoteSeenStore();
}

class BrowserMusicNoteSeenStore implements MusicNoteSeenStore {
  @override
  DateTime? readLastSeenMusicNoteAt(String spaceId, String profileId) {
    final raw = html.window.localStorage[_key(spaceId, profileId)];
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }
    return DateTime.tryParse(raw);
  }

  @override
  void writeLastSeenMusicNoteAt(
    String spaceId,
    String profileId,
    DateTime timestamp,
  ) {
    html.window.localStorage[_key(spaceId, profileId)] = timestamp
        .toUtc()
        .toIso8601String();
  }

  String _key(String spaceId, String profileId) {
    return 'alagagi:lastSeenMusicNoteAt:$spaceId:$profileId';
  }
}
