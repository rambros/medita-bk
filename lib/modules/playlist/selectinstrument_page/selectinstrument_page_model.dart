import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'selectinstrument_page_widget.dart' show SelectinstrumentPageWidget;
import 'package:flutter/material.dart';

class SelectinstrumentPageModel
    extends FlutterFlowModel<SelectinstrumentPageWidget> {
  ///  Local state fields for this page.

  bool isSelected = false;

  List<AudioModelStruct> instrumentsSounds = [];
  void addToInstrumentsSounds(AudioModelStruct item) =>
      instrumentsSounds.add(item);
  void removeFromInstrumentsSounds(AudioModelStruct item) =>
      instrumentsSounds.remove(item);
  void removeAtIndexFromInstrumentsSounds(int index) =>
      instrumentsSounds.removeAt(index);
  void insertAtIndexInInstrumentsSounds(int index, AudioModelStruct item) =>
      instrumentsSounds.insert(index, item);
  void updateInstrumentsSoundsAtIndex(
          int index, Function(AudioModelStruct) updateFn) =>
      instrumentsSounds[index] = updateFn(instrumentsSounds[index]);

  int selectedIndex = 0;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - getInstrumentSounds] action in selectinstrumentPage widget.
  List<AudioModelStruct>? listSounds;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
