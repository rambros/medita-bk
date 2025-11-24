import 'package:flutter/material.dart';

class MeditationStatisticsViewModel extends ChangeNotifier {
  // TabController is managed in the widget due to TickerProviderStateMixin requirement.
  // This ViewModel can be extended in the future if we need to add
  // business logic for statistics data.

  @override
  void dispose() {
    super.dispose();
  }
}
