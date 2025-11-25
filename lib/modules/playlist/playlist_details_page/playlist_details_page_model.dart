import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'playlist_details_page_widget.dart' show PlaylistDetailsPageWidget;
import 'package:flutter/material.dart';

class PlaylistDetailsPageModel
    extends FlutterFlowModel<PlaylistDetailsPageWidget> {
  ///  Local state fields for this page.

  PlaylistModelStruct? playlist;
  void updatePlaylistStruct(Function(PlaylistModelStruct) updateFn) {
    updateFn(playlist ??= PlaylistModelStruct());
  }

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - checkDeviceAudios] action in playlistDetailsPage widget.
  List<AudioModelStruct>? newListAudios;
  // Stores action output result for [Custom Action - deleteInvalidDeviceAudios] action in Icon widget.
  List<AudioModelStruct>? checkedListAudios;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
