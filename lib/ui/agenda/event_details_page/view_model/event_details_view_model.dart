import 'package:flutter/material.dart';
import 'package:medita_b_k/core/structs/index.dart';

class EventDetailsViewModel extends ChangeNotifier {
  EventModelStruct? _event;
  EventModelStruct? get event => _event;

  void setEvent(EventModelStruct event) {
    _event = event;
    notifyListeners();
  }
}
