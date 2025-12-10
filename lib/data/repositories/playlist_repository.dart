import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:medita_b_k/core/structs/index.dart';
import 'package:medita_b_k/core/structs/util/firestore_util.dart';
import 'package:medita_b_k/data/models/firebase/user_model.dart';
import 'package:medita_b_k/data/services/firebase/firestore_service.dart';

/// Repository responsible for persisting playlist data for the current user.
class PlaylistRepository {
  PlaylistRepository({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  final FirestoreService _firestoreService;
  static const String _collection = 'users';

  /// Stream playlists from the provided user reference.
  Stream<List<PlaylistModelStruct>> watchUserPlaylists(String userId) {
    return _firestoreService
        .streamDocument(
          collectionPath: _collection,
          documentId: userId,
          fromSnapshot: UserModel.fromFirestore,
        )
        .map((user) => user?.playlists ?? const []);
  }

  /// Append a playlist to the user document.
  Future<void> addPlaylist(
    String userId,
    PlaylistModelStruct playlist,
  ) {
    return _firestoreService.updateDocument(
      collectionPath: _collection,
      documentId: userId,
      data: {
        ...mapToFirestore({
          'playlists': FieldValue.arrayUnion([
            getPlaylistModelFirestoreData(
              updatePlaylistModelStruct(playlist, clearUnsetFields: false),
              true,
            ),
          ]),
        }),
      },
    );
  }

  /// Remove a playlist from the user document.
  Future<void> removePlaylist(
    String userId,
    PlaylistModelStruct playlist,
  ) {
    return _firestoreService.updateDocument(
      collectionPath: _collection,
      documentId: userId,
      data: {
        ...mapToFirestore({
          'playlists': FieldValue.arrayRemove([
            getPlaylistModelFirestoreData(
              updatePlaylistModelStruct(playlist, clearUnsetFields: false),
              true,
            )
          ]),
        }),
      },
    );
  }

  /// Replace one playlist with another (remove old, add new).
  Future<void> replacePlaylist({
    required String userId,
    required PlaylistModelStruct oldPlaylist,
    required PlaylistModelStruct newPlaylist,
  }) async {
    await removePlaylist(userId, oldPlaylist);
    await addPlaylist(userId, newPlaylist);
  }
}
