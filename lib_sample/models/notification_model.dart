import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationModel {
  final String id, title, body;
  final DateTime recievedAt;
  bool? read;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.recievedAt,
    this.read,
  });

  factory NotificationModel.fromRemoteMessage(RemoteMessage d) {
    return NotificationModel(
      id: d.messageId.toString(),
      title: d.notification?.title ?? '',
      recievedAt: DateTime.now(),
      body: d.data['description'] ?? '',
    );
  }

  factory NotificationModel.fromHive(dynamic d) {
    return NotificationModel(
      id: d['id'],
      title: d['title'],
      recievedAt: d['recieved_at'],
      body: d['description'],
      read: d['read'] ?? false,
    );
  }

  static Map<String, dynamic> getMap(NotificationModel d) {
    return {
      'id': d.id,
      'title': d.title,
      'description': d.body,
      'recieved_at': d.recievedAt,
      'read': d.read,
    };
  }
}
