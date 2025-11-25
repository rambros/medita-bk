import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';
import 'playlist_edit_audios_page_widget.dart'
    show PlaylistEditAudiosPageWidget;
import 'package:flutter/material.dart';

class PlaylistEditAudiosPageModel
    extends FlutterFlowModel<PlaylistEditAudiosPageWidget> {
  ///  Local state fields for this page.

  PlaylistModelStruct? playlist;
  void updatePlaylistStruct(Function(PlaylistModelStruct) updateFn) {
    updateFn(playlist ??= PlaylistModelStruct());
  }

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - checkDeviceAudios] action in playlistEditAudiosPage widget.
  List<AudioModelStruct>? editListAudios;
  // Stores action output result for [Custom Action - reorderItems] action in ListView widget.
  List<AudioModelStruct>? newList;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
