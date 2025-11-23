import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'select_device_music_page_widget.dart' show SelectDeviceMusicPageWidget;
import 'package:flutter/material.dart';

class SelectDeviceMusicPageModel
    extends FlutterFlowModel<SelectDeviceMusicPageWidget> {
  ///  Local state fields for this page.

  bool isSelected = false;

  AudioModelStruct? audioSelected;
  void updateAudioSelectedStruct(Function(AudioModelStruct) updateFn) {
    updateFn(audioSelected ??= AudioModelStruct());
  }

  String? deviceAudioName;

  int audioDuration = 0;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - selectAudioFile] action in Button widget.
  String? audioName;
  // State field(s) for Title widget.
  FocusNode? titleFocusNode;
  TextEditingController? titleTextController;
  String? Function(BuildContext, String?)? titleTextControllerValidator;
  // State field(s) for Author widget.
  FocusNode? authorFocusNode;
  TextEditingController? authorTextController;
  String? Function(BuildContext, String?)? authorTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    titleFocusNode?.dispose();
    titleTextController?.dispose();

    authorFocusNode?.dispose();
    authorTextController?.dispose();
  }
}
