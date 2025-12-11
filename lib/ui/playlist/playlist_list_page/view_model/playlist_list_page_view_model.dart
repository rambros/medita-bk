import 'package:flutter/material.dart';

import 'package:medita_bk/core/structs/index.dart';
import 'package:medita_bk/data/repositories/playlist_repository.dart';

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
