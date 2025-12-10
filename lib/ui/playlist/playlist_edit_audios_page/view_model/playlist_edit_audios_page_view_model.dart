import 'package:medita_b_k/core/structs/index.dart';
import 'package:flutter/material.dart';

class PlaylistEditAudiosPageViewModel extends ChangeNotifier {
  /// Local state fields for this page.

  PlaylistModelStruct? playlist;
  void updatePlaylistStruct(Function(PlaylistModelStruct) updateFn) {
    updateFn(playlist ??= PlaylistModelStruct());
  }

  /// State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - checkDeviceAudios] action in playlistEditAudiosPage widget.
  List<AudioModelStruct>? editListAudios;
  // Stores action output result for [Custom Action - reorderItems] action in ListView widget.
  List<AudioModelStruct>? newList;

  void init(BuildContext context) {}

}
