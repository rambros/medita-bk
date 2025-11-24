import 'package:flutter/material.dart';

class MeditationPlayViewModel extends ChangeNotifier {
  // This page is mostly static UI with animations.
  // The animation state is managed by Flutter's AnimationController
  // which is handled in the widget itself due to TickerProviderStateMixin.

  // No additional state management needed for this simple page.

  @override
  void dispose() {
    super.dispose();
  }
}
