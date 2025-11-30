import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:lms_app/constants/custom_colors.dart';
import 'package:lms_app/services/app_service.dart';

import '../../models/course.dart';

class Learnings extends StatelessWidget {
  const Learnings({
    super.key,
    required this.course,
  });

  final Course course;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: course.courseMeta.learnings!.isNotEmpty,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        color: AppService.isDarkMode(context) ? CustomColor.containerDark : CustomColor.container,
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'what-will-you-learn',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ).tr(),
            const SizedBox(
              height: 5,
            ),
            Column(
              children: course.courseMeta.learnings!
                  .map((e) => ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        horizontalTitleGap: 10,
                        title: Text(e),
                        leading: const Icon(FeatherIcons.check, color: Colors.blue),
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
