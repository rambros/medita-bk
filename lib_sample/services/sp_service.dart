import 'package:shared_preferences/shared_preferences.dart';

class SPService {
  Future clearLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future setNotificationSubscription(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('n_subscribe', value);
  }

  Future<bool> getNotificationSubscription() async {
    final prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool('n_subscribe') ?? false;
    return value;
  }

  Future<bool> isGuestUser() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isGuest = prefs.getBool('guest_user') ?? false;
    return isGuest;
  }

  Future setGuestUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('guest_user', true);
  }
}
