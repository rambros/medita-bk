import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lms_app/screens/notifications/custom_notification_tile.dart';
import 'package:lms_app/configs/app_assets.dart';
import 'package:lms_app/constants/app_constants.dart';
import 'package:lms_app/models/notification_model.dart';
import 'package:lms_app/screens/notifications/clear_notifications_dialog.dart';
import 'package:lms_app/utils/empty_animation.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationList = Hive.box(notificationTag);
    return Scaffold(
      appBar: AppBar(
        title: const Text('notifications').tr(),
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, fontSize: 20),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FeatherIcons.chevronLeft)),
        actions: [
          Visibility(
            visible: notificationList.isNotEmpty,
            child: IconButton(
              onPressed: () => openClearAllDialog(context),
              icon: const Icon(Icons.delete_sweep_outlined),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ValueListenableBuilder(
            valueListenable: notificationList.listenable(),
            builder: (BuildContext context, dynamic value, Widget? child) {
              List items = notificationList.values.toList();
              List<NotificationModel> notifications = items.map((e) => NotificationModel.fromHive(e)).toList();
              notifications.sort((a, b) => b.recievedAt.compareTo(a.recievedAt));
              if (notifications.isEmpty) {
                return EmptyAnimation(animationString: notificationAnimation, title: 'no-notification'.tr());
              }
              return Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(15, 20, 15, 30),
                  itemCount: items.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 15),
                  itemBuilder: (BuildContext context, int index) {
                    final NotificationModel notification = notifications[index];
                    return CustomNotificationTile(notificationModel: notification);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
