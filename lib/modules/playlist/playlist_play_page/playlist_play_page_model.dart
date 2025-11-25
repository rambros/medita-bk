import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';
import 'playlist_play_page_widget.dart' show PlaylistPlayPageWidget;
import 'package:flutter/material.dart';

class PlaylistPlayPageModel extends FlutterFlowModel<PlaylistPlayPageWidget> {
  ///  Local state fields for this page.

  PlaylistModelStruct? playlist;
  void updatePlaylistStruct(Function(PlaylistModelStruct) updateFn) {
    updateFn(playlist ??= PlaylistModelStruct());
  }

  List<AudioModelStruct> listAudios = [];
  void addToListAudios(AudioModelStruct item) => listAudios.add(item);
  void removeFromListAudios(AudioModelStruct item) => listAudios.remove(item);
  void removeAtIndexFromListAudios(int index) => listAudios.removeAt(index);
  void insertAtIndexInListAudios(int index, AudioModelStruct item) =>
      listAudios.insert(index, item);
  void updateListAudiosAtIndex(
          int index, Function(AudioModelStruct) updateFn) =>
      listAudios[index] = updateFn(listAudios[index]);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
