import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String themeKey = 'theme';
final themeProvider = ChangeNotifierProvider((ref) => ThemeProviderState());

class ThemeProviderState extends ChangeNotifier {
  bool isDarkMode = false;

  ThemeProviderState() {
    getCurrectTheme();
  }

  getCurrectTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode = prefs.getBool(themeKey) ?? false;
    notifyListeners();
  }

  changeTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(themeKey, value);
    isDarkMode = value;
    notifyListeners();
  }
}
