// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<EventModelStruct>> convertJsonToEventList(
    List<dynamic> jsonArray) async {
  // Add your function code here!
  List<EventModelStruct> listOfStruct = [];
  for (var item in jsonArray) {
    listOfStruct.add(EventModelStruct.fromMap(item));
  }
  return listOfStruct;
}
