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

// Imports other custom actions
import 'dart:io';
// ignore_for_file: unused_import, unnecessary_import

import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tzdata;

class TimeZone {
  factory TimeZone() => _instance ??= TimeZone._();

  TimeZone._() {
    tzdata.initializeTimeZones();
  }

  static TimeZone? _instance;

  Future<String> getTimeZoneName() async {
    try {
      final timezone = await FlutterTimezone.getLocalTimezone();
      return timezone.identifier;
    } catch (_) {
      final fallbackLocation = tz.local;
      return fallbackLocation.name;
    }
  }

  Future<tz.Location> getLocation([String? timeZoneName]) async {
    final zoneName = (timeZoneName == null || timeZoneName.isEmpty)
        ? await getTimeZoneName()
        : timeZoneName;
    return tz.getLocation(zoneName);
  }
}

bool _notificationsInitialized = false;

Future<void> _ensureNotificationsInitialized(
  FlutterLocalNotificationsPlugin plugin,
) async {
  if (_notificationsInitialized) {
    return;
  }

  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iOSInit = DarwinInitializationSettings();
  const initializationSettings =
      InitializationSettings(android: androidInit, iOS: iOSInit);

  await plugin.initialize(initializationSettings);
  _notificationsInitialized = true;
}

Future<void> scheduleAlarm(
    BuildContext context, int id, DateTime selectedTime) async {
  // Add your function code here!
  final hour = selectedTime.hour;
  final minute = selectedTime.minute;
  final showtime = TimeOfDay(hour: hour, minute: minute).format(context);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await _ensureNotificationsInitialized(flutterLocalNotificationsPlugin);
  final timeZone = TimeZone();
  final deviceTimeZoneName = await timeZone.getTimeZoneName();
  final currentLocation = await timeZone.getLocation(deviceTimeZoneName);
  final tzDateTimeNow = tz.TZDateTime.now(currentLocation);
  var scheduledNotificationDateTime = tz.TZDateTime(currentLocation,
      tzDateTimeNow.year, tzDateTimeNow.month, tzDateTimeNow.day, hour, minute);
  if (scheduledNotificationDateTime.isBefore(tzDateTimeNow)) {
    scheduledNotificationDateTime =
        scheduledNotificationDateTime.add(const Duration(days: 1));
  }

  var scheduleMode = AndroidScheduleMode.inexactAllowWhileIdle;
  if (Platform.isAndroid) {
    final androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      bool canScheduleExact =
          (await androidImplementation.canScheduleExactNotifications()) ??
              false;

      if (!canScheduleExact) {
        final permissionGranted =
            await androidImplementation.requestExactAlarmsPermission();
        if (permissionGranted == true) {
          canScheduleExact =
              (await androidImplementation.canScheduleExactNotifications()) ??
                  false;
        }
      }

      if (canScheduleExact) {
        scheduleMode = AndroidScheduleMode.exactAllowWhileIdle;
      } else {
        debugPrint(
            'Exact alarm permission not granted; scheduling inexact alarm instead.');
      }
    }
  }

  const androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'your channel id',
    'your  channel name',
    channelDescription: 'your  channel description',
    //sound: RawResourceAndroidNotificationSound('sd'),
    autoCancel: true,
    playSound: true,
    color: Colors.black, // primaryColor,
    importance: Importance.max,
    priority: Priority.high,
  );

  const iOSPlatformChannelSpecifics =
      DarwinNotificationDetails(sound: 'sd.aiff', presentSound: true);

  const platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
      //for multiple alarm give unique id each time as--> DateTime.now().millisecond,
      id,
      'Hora de meditar',
      showtime,
      scheduledNotificationDateTime,
      platformChannelSpecifics,
      androidScheduleMode: scheduleMode,
      //uiLocalNotificationDateInterpretation:
      //    UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time
      // scheduledNotificationRepeatFrequency:
      //         ScheduledNotificationRepeatFrequency.daily,
      );
  //print("alarm set");
}
