import 'package:medita_b_k/core/structs/index.dart';

/// Service for agenda/event-specific utilities
class AgendaService {
  /// Convert JSON array to list of EventModelStruct
  ///
  /// Parses a dynamic JSON array into a typed list of event structures.
  static Future<List<EventModelStruct>> convertJsonToEventList(
    List<dynamic> jsonArray,
  ) async {
    final List<EventModelStruct> listOfStruct = [];
    for (final item in jsonArray) {
      listOfStruct.add(EventModelStruct.fromMap(item));
    }
    return listOfStruct;
  }
}
