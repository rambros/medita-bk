import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/structs/index.dart';
import '/backend/schema/users_record.dart';
import '/backend/schema/util/firestore_util.dart';

/// Repository responsible for persisting playlist data for the current user.
class PlaylistRepository {
  /// Stream playlists from the provided user reference.
  Stream<List<PlaylistModelStruct>> watchUserPlaylists(
    DocumentReference userRef,
  ) {
    return UsersRecord.getDocument(userRef).map((record) => record.playlists);
  }

  /// Append a playlist to the user document.
  Future<void> addPlaylist(
    DocumentReference userRef,
    PlaylistModelStruct playlist,
  ) {
    return userRef.update({
      ...mapToFirestore({
        'playlists': FieldValue.arrayUnion([
          getPlaylistModelFirestoreData(
            updatePlaylistModelStruct(playlist, clearUnsetFields: false),
            true,
          ),
        ]),
      }),
    });
  }

  /// Remove a playlist from the user document.
  Future<void> removePlaylist(
    DocumentReference userRef,
    PlaylistModelStruct playlist,
  ) {
    return userRef.update({
      ...mapToFirestore({
        'playlists': FieldValue.arrayRemove([
          getPlaylistModelFirestoreData(
            updatePlaylistModelStruct(playlist, clearUnsetFields: false),
            true,
          )
        ]),
      }),
    });
  }

  /// Replace one playlist with another (remove old, add new).
  Future<void> replacePlaylist({
    required DocumentReference userRef,
    required PlaylistModelStruct oldPlaylist,
    required PlaylistModelStruct newPlaylist,
  }) async {
    await removePlaylist(userRef, oldPlaylist);
    await addPlaylist(userRef, newPlaylist);
  }
}
