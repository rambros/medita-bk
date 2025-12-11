import 'package:medita_bk/core/structs/index.dart';
import 'package:flutter/material.dart';

class SelectDeviceMusicPageViewModel extends ChangeNotifier {
  /// Local state fields for this page.

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

  void init(BuildContext context) {}

  @override
  void dispose() {
    titleFocusNode?.dispose();
    titleTextController?.dispose();

    authorFocusNode?.dispose();
    authorTextController?.dispose();
    super.dispose();
  }
}
