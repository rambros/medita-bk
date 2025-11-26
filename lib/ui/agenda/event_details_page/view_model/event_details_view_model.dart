import 'package:flutter/material.dart';
import '/core/structs/index.dart';

class EventDetailsViewModel extends ChangeNotifier {
  EventModelStruct? _event;
  EventModelStruct? get event => _event;

  void setEvent(EventModelStruct event) {
    _event = event;
    notifyListeners();
  }
}
