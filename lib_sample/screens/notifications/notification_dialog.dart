import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lms_app/services/hive_service.dart';
import 'package:lms_app/utils/next_screen.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

import '../../models/notification_model.dart';
import 'custom_notification_details.dart';

Future<void> notificationDialog(context, NotificationModel notificationModel) {
  return Dialogs.materialDialog(
    context: context,
    title: "notification-aleart".tr(),
    titleAlign: TextAlign.start,
    msg: notificationModel.title,
    titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    msgAlign: TextAlign.start,
    msgStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    barrierDismissible: true,
    color: Theme.of(context).scaffoldBackgroundColor,
    actionsBuilder: (context) => [
      IconsOutlineButton(
        onPressed: () => Navigator.pop(context),
        text: 'close'.tr(),
        iconData: Icons.close,
      ),
      IconsOutlineButton(
        onPressed: () async {
          Navigator.pop(context);
          await HiveService().setNotificationRead(notificationModel);
          if(!context.mounted) return;
          NextScreen.iOS(context, CustomNotificationDeatils(notificationModel: notificationModel));
        },
        text: 'open-details'.tr(),
        iconData: LineIcons.bell,
        color: Theme.of(context).primaryColor,
        iconColor: Colors.white,
        textStyle: const TextStyle(color: Colors.white),
      ),
    ],
  );
}
