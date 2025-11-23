// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<AudioModelStruct>> reorderItems(
  List<AudioModelStruct> list,
  int newIndex,
  int oldIndex,
) async {
  // Define a function called reorderItems that returns a Future of a list of strings.
// It takes in a list of strings, an old index, and a new index as parameters.
  // If the item is being moved to a position further down the list
  // (i.e., to a higher index), decrement the newIndex by 1.
  // This adjustment is needed because removing an item from its original
  // position will shift the indices of all subsequent items.
  if (oldIndex < newIndex) {
    newIndex -= 1;
  }

  // Remove the item from its original position in the list and store
  // it in the 'item' variable.
  final item = list.removeAt(oldIndex);

  // Insert the removed item into its new position in the list.
  list.insert(newIndex, item);

  // Return the modified list.
  return list;
}
