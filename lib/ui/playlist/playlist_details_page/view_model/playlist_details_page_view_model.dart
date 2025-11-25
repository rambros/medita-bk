import '/backend/schema/structs/index.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/data/repositories/playlist_repository.dart';

class PlaylistDetailsPageViewModel extends ChangeNotifier {
  PlaylistDetailsPageViewModel({
    required PlaylistRepository repository,
    required this.userRef,
  }) : _repository = repository;

  final PlaylistRepository _repository;
  final DocumentReference userRef;

  /// Local state fields for this page.

  PlaylistModelStruct? playlist;
  void updatePlaylistStruct(Function(PlaylistModelStruct) updateFn) {
    updateFn(playlist ??= PlaylistModelStruct());
  }

  /// State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - checkDeviceAudios] action in playlistDetailsPage widget.
  List<AudioModelStruct>? newListAudios;
  // Stores action output result for [Custom Action - deleteInvalidDeviceAudios] action in Icon widget.
  List<AudioModelStruct>? checkedListAudios;

  String? errorMessage;

  void init(BuildContext context) {}

  Future<void> removePlaylist(PlaylistModelStruct target) async {
    try {
      await _repository.removePlaylist(userRef, target);
    } catch (e) {
      errorMessage = 'Erro ao remover playlist: $e';
      rethrow;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
