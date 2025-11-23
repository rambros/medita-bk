// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future showNotification() async {
  // Add your function code here!
  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var android = const AndroidNotificationDetails('channel id', 'channel NAME',
      channelDescription: 'CHANNEL DESCRIPTION',
      priority: Priority.high,
      importance: Importance.max);
  var iOS = const DarwinNotificationDetails();
  var platform = NotificationDetails(android: android, iOS: iOS);
  await flutterLocalNotificationsPlugin.show(
      0, 'Nova Notificação', 'Flutter Local Notification', platform,
      payload: 'seu lembrete ');
}
