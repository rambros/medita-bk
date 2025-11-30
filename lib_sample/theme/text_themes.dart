import 'package:flutter/material.dart';

// Default Text Theme
const TextTheme textThemeDefault = TextTheme(
  headlineSmall: TextStyle(letterSpacing: -0.3),
  titleMedium: TextStyle(letterSpacing: -0.1),
);

// Text theme for iOS to fix font spcaing issue on iOS
const TextTheme textThemeiOS = TextTheme(
  headlineSmall: TextStyle(letterSpacing: -0.3),
  titleMedium: TextStyle(letterSpacing: -0.1),
  bodyLarge: TextStyle(letterSpacing: -0.2, fontWeight: FontWeight.w500),
);
