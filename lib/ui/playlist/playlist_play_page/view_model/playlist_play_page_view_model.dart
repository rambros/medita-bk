import '/core/structs/index.dart';
import 'package:flutter/material.dart';

class PlaylistPlayPageViewModel extends ChangeNotifier {
  /// Local state fields for this page.

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

  void init(BuildContext context) {}

}
