import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';

class EventDetailsViewModel extends ChangeNotifier {
  EventModelStruct? _event;
  EventModelStruct? get event => _event;

  void setEvent(EventModelStruct event) {
    _event = event;
    notifyListeners();
  }
}
