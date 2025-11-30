import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import '../../components/html_body.dart';
import '../../models/notification_model.dart';

class CustomNotificationDeatils extends StatelessWidget {
  const CustomNotificationDeatils({super.key, required this.notificationModel});

  final NotificationModel notificationModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const Icon(
                    LineIcons.clock,
                    size: 20,
                    color: Colors.blueGrey,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    _getDate(context, notificationModel),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              notificationModel.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)
            ),
            Divider(
              height: 30,
              color: Theme.of(context).primaryColor,
              thickness: 2,
            ),
            HtmlBody(description: notificationModel.body),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  static String _getDate(BuildContext context, NotificationModel notificationModel) {
    final String date = DateFormat('MMMM dd, yyyy hh:mm a').format(notificationModel.recievedAt);
    return date;
  }
}
