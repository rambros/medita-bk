import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/backend/schema/structs/index.dart';
import '/data/repositories/playlist_repository.dart';

class PlaylistListViewModel extends ChangeNotifier {
  PlaylistListViewModel({
    required PlaylistRepository repository,
    required this.userRef,
  }) : _repository = repository;

  final PlaylistRepository _repository;
  final DocumentReference userRef;

  Stream<List<PlaylistModelStruct>> get playlistsStream =>
      _repository.watchUserPlaylists(userRef);

  void init(BuildContext context) {}

  @override
  void dispose() {
    super.dispose();
  }
}
