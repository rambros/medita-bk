import '/core/structs/index.dart';
import 'package:flutter/material.dart';

import '/data/repositories/playlist_repository.dart';

class PlaylistDetailsPageViewModel extends ChangeNotifier {
  PlaylistDetailsPageViewModel({
    required PlaylistRepository repository,
    required this.userId,
  }) : _repository = repository;

  final PlaylistRepository _repository;
  final String userId;

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
      await _repository.removePlaylist(userId, target);
    } catch (e) {
      errorMessage = 'Erro ao remover playlist: $e';
      rethrow;
    }
  }

}
