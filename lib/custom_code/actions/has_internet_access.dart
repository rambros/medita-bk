// Automatic FlutterFlow imports
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';

Future<bool> hasInternetAccess() async {
  final connectivity = await Connectivity().checkConnectivity();
  if (connectivity == ConnectivityResult.none) return false;

  try {
    final result = await InternetAddress.lookup('google.com')
        .timeout(const Duration(seconds: 3));
    return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}
