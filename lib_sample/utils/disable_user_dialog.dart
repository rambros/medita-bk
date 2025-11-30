import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

Future<void> openDisableUserDialog(BuildContext context) {
  return Dialogs.materialDialog(
      context: context,
      title: 'user-disable-title'.tr(),
      msg: 'user-disable-subtitle'.tr(),
      titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      msgAlign: TextAlign.center,
      msgStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      barrierDismissible: false,
      color: Theme.of(context).scaffoldBackgroundColor,
      actionsBuilder: (context) => [
            Container(
              height: 50,
              margin: const EdgeInsets.only(top: 20),
              child: IconsButton(
                onPressed: () {
                  SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop', true);
                },
                text: 'Ok',
                iconData: Icons.check,
                color: Theme.of(context).primaryColor,
                textStyle: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                iconColor: Colors.white,
              ),
            ),
          ],
      onClose: (_) => SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop', true));
}
