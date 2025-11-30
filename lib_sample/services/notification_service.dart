import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/constants/app_constants.dart';
import 'package:lms_app/screens/notifications/custom_notification_details.dart';
import 'package:lms_app/services/hive_service.dart';
import 'package:lms_app/services/sp_service.dart';
import 'package:lms_app/utils/next_screen.dart';
import 'package:lms_app/screens/notifications/notification_dialog.dart';
import 'package:lms_app/utils/snackbars.dart';
import '../models/notification_model.dart';
import '../screens/notifications/notification_permisson_dialog.dart';

final nProvider = StateProvider<bool>((ref) => false);

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<bool?> _checkPermisson() async {
    bool? accepted;
    await _fcm.getNotificationSettings().then((NotificationSettings settings) async {
      if (settings.authorizationStatus == AuthorizationStatus.authorized || settings.authorizationStatus == AuthorizationStatus.provisional) {
        accepted = true;
      } else {
        accepted = false;
      }
    });
    return accepted;
  }

  Future _subscribe() async {
    await _fcm.subscribeToTopic(notificationTopicForAll);
  }

  Future _unsubscribe() async {
    await _fcm.unsubscribeFromTopic(notificationTopicForAll);
  }

  Future checkNotificationSubscription(WidgetRef ref) async {
    final bool value = await SPService().getNotificationSubscription();
    if (value) {
      await _subscribe();
      ref.read(nProvider.notifier).update((state) => true);
    } else {
      await _unsubscribe();
      ref.read(nProvider.notifier).update((state) => false);
    }
  }

  void handleSubscription(context, bool newValue, WidgetRef ref) async {
    if (newValue) {
      final bool? accepted = await _checkPermisson();
      if (accepted != null && accepted) {
        ref.read(nProvider.notifier).update((state) => true);
        openSnackbar(context, 'notifications-enabled'.tr());
        await _subscribe();
        await SPService().setNotificationSubscription(newValue);
      } else {
        openNotificationPermissionDialog(context);
      }
    } else {
      ref.read(nProvider.notifier).update((state) => false);
      openSnackbar(context, 'notifications-disabled'.tr());
      await _unsubscribe();
      await SPService().setNotificationSubscription(newValue);
    }
  }

  Future _handleNotificationPermission(WidgetRef ref) async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
      ref.read(nProvider.notifier).update((state) => true);
      SPService().setNotificationSubscription(true);
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  Future initFirebasePushNotification(BuildContext context, WidgetRef ref) async {
    await _handleNotificationPermission(ref);

    RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    debugPrint('inittal message : $initialMessage');
    if (initialMessage != null) {
      await HiveService().saveNotificationData(initialMessage).then((value){
        if(!context.mounted) return;
        _navigateToDetailsScreen(context, initialMessage);
      });
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('onMessage: ${message.data}');
      await HiveService().saveNotificationData(message).then((value){
        if(!context.mounted) return;
        _openNotificationDialog(context, message);
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      debugPrint('onMessageOppn: ${message.data}');
      await HiveService().saveNotificationData(message).then((value){
        if(!context.mounted) return;
        _navigateToDetailsScreen(context, message);
      });
    });
  }

  Future _openNotificationDialog(context, RemoteMessage message) async {
    final NotificationModel notificationModel = NotificationModel.fromRemoteMessage(message);
    notificationDialog(context, notificationModel);
  }

  _navigateToDetailsScreen(context, RemoteMessage message) async {
    final NotificationModel notification = NotificationModel.fromRemoteMessage(message);
    HiveService().setNotificationRead(notification);
    NextScreen.normal(context, CustomNotificationDeatils(notificationModel: notification));
  }
}
