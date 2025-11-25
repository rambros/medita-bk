import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

/// Service for managing local notifications and scheduled alarms
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  /// Initialize the notification plugin
  ///
  /// This must be called before using any notification functionality.
  Future<void> initialize() async {
    if (_initialized) return;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iOSInit,
    );

    await _plugin.initialize(initSettings);
    _initialized = true;
  }

  /// Initialize timezone data
  ///
  /// Required for scheduling alarms at specific times.
  Future<void> initializeTimeZone() async {
    tz_data.initializeTimeZones();
  }

  /// Show an immediate notification
  ///
  /// [id] - Unique notification ID
  /// [title] - Notification title
  /// [body] - Notification body text
  /// [payload] - Optional payload data
  Future<void> showNotification({
    int id = 0,
    String title = 'Nova Notificação',
    String body = 'Flutter Local Notification',
    String? payload,
  }) async {
    await _ensureInitialized();

    const android = AndroidNotificationDetails(
      'channel id',
      'channel NAME',
      channelDescription: 'CHANNEL DESCRIPTION',
      priority: Priority.high,
      importance: Importance.max,
    );
    const iOS = DarwinNotificationDetails();
    const platform = NotificationDetails(android: android, iOS: iOS);

    await _plugin.show(id, title, body, platform, payload: payload);
  }

  /// Schedule an alarm notification
  ///
  /// [context] - Build context for time formatting
  /// [id] - Unique alarm ID
  /// [selectedTime] - Time to trigger the alarm
  Future<void> scheduleAlarm(
    BuildContext context,
    int id,
    DateTime selectedTime,
  ) async {
    await _ensureInitialized();

    final hour = selectedTime.hour;
    final minute = selectedTime.minute;
    final showtime = TimeOfDay(hour: hour, minute: minute).format(context);

    final timeZone = _TimeZone();
    final deviceTimeZoneName = await timeZone.getTimeZoneName();
    final currentLocation = await timeZone.getLocation(deviceTimeZoneName);
    final tzDateTimeNow = tz.TZDateTime.now(currentLocation);

    var scheduledNotificationDateTime = tz.TZDateTime(
      currentLocation,
      tzDateTimeNow.year,
      tzDateTimeNow.month,
      tzDateTimeNow.day,
      hour,
      minute,
    );

    if (scheduledNotificationDateTime.isBefore(tzDateTimeNow)) {
      scheduledNotificationDateTime = scheduledNotificationDateTime.add(const Duration(days: 1));
    }

    var scheduleMode = AndroidScheduleMode.inexactAllowWhileIdle;
    if (Platform.isAndroid) {
      final androidImplementation =
          _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        bool canScheduleExact = (await androidImplementation.canScheduleExactNotifications()) ?? false;

        if (!canScheduleExact) {
          final permissionGranted = await androidImplementation.requestExactAlarmsPermission();
          if (permissionGranted == true) {
            canScheduleExact = (await androidImplementation.canScheduleExactNotifications()) ?? false;
          }
        }

        if (canScheduleExact) {
          scheduleMode = AndroidScheduleMode.exactAllowWhileIdle;
        } else {
          debugPrint('Exact alarm permission not granted; scheduling inexact alarm instead.');
        }
      }
    }

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      autoCancel: true,
      playSound: true,
      color: Colors.black,
      importance: Importance.max,
      priority: Priority.high,
    );

    const iOSPlatformChannelSpecifics = DarwinNotificationDetails(
      sound: 'sd.aiff',
      presentSound: true,
    );

    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _plugin.zonedSchedule(
      id,
      'Hora de meditar',
      showtime,
      scheduledNotificationDateTime,
      platformChannelSpecifics,
      androidScheduleMode: scheduleMode,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Delete a scheduled alarm notification
  ///
  /// [idAlarm] - ID of the alarm to cancel
  Future<void> deleteAlarm(int idAlarm) async {
    await _plugin.cancel(idAlarm);
  }

  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await initialize();
    }
  }
}

/// Helper class for timezone operations
class _TimeZone {
  factory _TimeZone() => _instance ??= _TimeZone._();

  _TimeZone._() {
    tz_data.initializeTimeZones();
  }

  static _TimeZone? _instance;

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
    final zoneName = (timeZoneName == null || timeZoneName.isEmpty) ? await getTimeZoneName() : timeZoneName;
    return tz.getLocation(zoneName);
  }
}
