import 'package:flutter_local_notifications/flutter_local_notifications.dart';
void main() async {
  final hasIt = await AndroidFlutterLocalNotificationsPlugin().areNotificationsEnabled();
}
