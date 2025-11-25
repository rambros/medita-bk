import '/backend/schema/structs/index.dart';
import 'package:flutter/material.dart';

class PlaylistAddAudiosPageViewModel extends ChangeNotifier {
  /// State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - reorderItems] action in ListView widget.
  List<AudioModelStruct>? newList;

  void init(BuildContext context) {}

  @override
  void dispose() {
    super.dispose();
  }
}
