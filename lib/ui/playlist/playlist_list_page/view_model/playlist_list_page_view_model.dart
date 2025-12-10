import 'package:flutter/material.dart';

import 'package:medita_b_k/core/structs/index.dart';
import 'package:medita_b_k/data/repositories/playlist_repository.dart';

class PlaylistListViewModel extends ChangeNotifier {
  PlaylistListViewModel({
    required PlaylistRepository repository,
    required this.userId,
  }) : _repository = repository;

  final PlaylistRepository _repository;
  final String userId;

  Stream<List<PlaylistModelStruct>> get playlistsStream =>
      _repository.watchUserPlaylists(userId);

  void init(BuildContext context) {}

}
