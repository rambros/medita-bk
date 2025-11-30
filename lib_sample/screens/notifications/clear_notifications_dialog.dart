import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lms_app/services/hive_service.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

void openClearAllDialog(BuildContext context) {
  return Dialogs.bottomMaterialDialog(
    context: context,
    title: 'delete-all-title'.tr(),
    msg: 'delete-all-subtitle'.tr(),
    titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    msgStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    color: Theme.of(context).canvasColor,
    actionsBuilder: (context) {
      return [
        IconsOutlineButton(
          text: 'cancel'.tr(),
          iconData: Icons.close,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          onPressed: () => Navigator.pop(context),
        ),
        IconsOutlineButton(
          text: 'delete'.tr(),
          color: Colors.red,
          iconData: Icons.delete,
          iconColor: Colors.white,
          textStyle: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          onPressed: () async {
            Navigator.pop(context);
            await HiveService().deleteAllNotificationData();
          },
        ),
      ];
    },
  );
}
