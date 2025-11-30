import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lms_app/services/hive_service.dart';
import 'package:lms_app/utils/string_extension.dart';
import '../../models/notification_model.dart';
import '../../utils/next_screen.dart';
import 'custom_notification_details.dart';

class CustomNotificationTile extends StatelessWidget {
  const CustomNotificationTile({super.key, required this.notificationModel});

  final NotificationModel notificationModel;

  @override
  Widget build(BuildContext context) {
    final bool isRead = notificationModel.read ?? false;
    return InkWell(
      child: Container(
        padding: const EdgeInsets.fromLTRB(15, 25, 10, 25),
        decoration: BoxDecoration(
          border: Border.all(
            color: isRead ? Colors.blueGrey : Theme.of(context).primaryColor,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VerticalDivider(
                    thickness: 2.0,
                    color: isRead ? Colors.blueGrey.shade200 : Theme.of(context).primaryColor,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notificationModel.title,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          notificationModel.body.toNormalText,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    constraints: const BoxConstraints(minHeight: 40),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(left: 8),
                    icon: const Icon(
                      Icons.close,
                      size: 20,
                    ),
                    onPressed: () => HiveService().deleteNotificationData(notificationModel.id),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  CupertinoIcons.time,
                  size: 18,
                  color: Colors.blueGrey,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  _getDate(context, notificationModel),
                  style: const TextStyle(fontSize: 13, color: Colors.blueGrey),
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () async {
        if (notificationModel.read == false) {
          await HiveService().setNotificationRead(notificationModel);
        }
        if (!context.mounted) return;
        NextScreen.openBottomSheet(context, CustomNotificationDeatils(notificationModel: notificationModel));
      },
    );
  }

  static String _getDate(BuildContext context, NotificationModel notificationModel) {
    final String date = DateFormat('MMMM dd, yyyy').format(notificationModel.recievedAt);
    return date;
  }
}
