import 'dart:io';
import 'package:flutter/material.dart';
import '../configs/app_config.dart';
import 'text_themes.dart';
// import '../configs/font_config.dart';
// import 'package:google_fonts/google_fonts.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryColor: AppConfig.appThemeColor,
  textTheme: Platform.isIOS ? textThemeiOS : textThemeDefault,
  // fontFamily: GoogleFonts.getFont(fontFamily).fontFamily,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
  ),
  scaffoldBackgroundColor: Colors.white,
  dividerTheme: DividerThemeData(color: Colors.blueGrey.shade100, thickness: 0.7),
);


