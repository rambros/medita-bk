import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

Future<void> openLogoutDialog(BuildContext context, VoidCallback onLogout) {
  return Dialogs.materialDialog(
    context: context,
    title: 'logout-title'.tr(),
    msg: 'logout-subtitle'.tr(),
    titleAlign: TextAlign.center,
    titleStyle: Theme.of(context).textTheme.headlineMedium!,
    msgAlign: TextAlign.center,
    msgStyle: Theme.of(context).textTheme.titleMedium,
    barrierDismissible: true,
    color: Theme.of(context).scaffoldBackgroundColor,
    actionsBuilder: (context) => [
      IconsOutlineButton(
        onPressed: () => Navigator.pop(context),
        text: 'close'.tr(),
      ),
      IconsOutlineButton(
        onPressed: () {
          Navigator.pop(context);
          onLogout();
        },
        text: 'yes'.tr(),
        color: Theme.of(context).primaryColor,
        textStyle: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
      ),
    ],
  );
}
