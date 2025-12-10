import 'package:medita_b_k/core/structs/index.dart';
import 'package:flutter/material.dart';

class SelectMeditationsPageViewModel extends ChangeNotifier {
  /// Local state fields for this page.

  bool isSelected = false;

  int selectedIndex = 0;

  AudioModelStruct? audioSelected;
  void updateAudioSelectedStruct(Function(AudioModelStruct) updateFn) {
    updateFn(audioSelected ??= AudioModelStruct());
  }

  void init(BuildContext context) {}

}
