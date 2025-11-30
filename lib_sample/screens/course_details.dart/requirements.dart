import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

import '../../models/course.dart';

class Requirements extends StatelessWidget {
  const Requirements({
    super.key,
    required this.course,
  });

  final Course course;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: course.courseMeta.requirements!.isNotEmpty,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 40, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'requirements',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ).tr(),
            const SizedBox(
              height: 5,
            ),
            Column(
              children: course.courseMeta.requirements!
                  .map((e) => ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        horizontalTitleGap: 10,
                        title: Text(e),
                        leading: const Icon(FeatherIcons.check, color: Colors.blueAccent),
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
