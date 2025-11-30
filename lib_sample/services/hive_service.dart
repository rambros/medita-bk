import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lms_app/models/notification_model.dart';
import 'package:path_provider/path_provider.dart';
import '../constants/app_constants.dart';

class HiveService {
  static void initHive() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path); 
    await Hive.openBox(notificationTag);
  }

  Future saveNotificationData(RemoteMessage message) async {
    final list = Hive.box(notificationTag);
    final NotificationModel notificationModel = NotificationModel.fromRemoteMessage(message);
    final Map<String, dynamic> data = NotificationModel.getMap(notificationModel);
    await list.put(notificationModel.id, data);
  }

  Future setNotificationRead(NotificationModel notificationModel) async {
    final list = Hive.box(notificationTag);
    final newModel = notificationModel;
    newModel.read = true;
    final Map<String, dynamic> data = NotificationModel.getMap(newModel);
    await list.put(notificationModel.id, data);
  }

  Future deleteNotificationData(String id) async {
    final notificationList = Hive.box(notificationTag);
    await notificationList.delete(id);
  }

  Future deleteAllNotificationData() async {
    final notificationList = Hive.box(notificationTag);
    await notificationList.clear();
  }
}
