import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'select_meditations_page_widget.dart' show SelectMeditationsPageWidget;
import 'package:flutter/material.dart';

class SelectMeditationsPageModel
    extends FlutterFlowModel<SelectMeditationsPageWidget> {
  ///  Local state fields for this page.

  bool isSelected = false;

  int selectedIndex = 0;

  AudioModelStruct? audioSelected;
  void updateAudioSelectedStruct(Function(AudioModelStruct) updateFn) {
    updateFn(audioSelected ??= AudioModelStruct());
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
