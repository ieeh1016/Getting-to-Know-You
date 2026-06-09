import '../domain/alagagi_controller.dart';
import 'music_note_seen_store_stub.dart'
    if (dart.library.html) 'music_note_seen_store_web.dart';

MusicNoteSeenStore createDefaultMusicNoteSeenStore() {
  return createMusicNoteSeenStore();
}
