import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lms_app/components/html_body.dart';
import 'package:lms_app/models/course.dart';

class CourseDescription extends StatelessWidget {
  const CourseDescription({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: course.courseMeta.description != null && course.courseMeta.description!.isNotEmpty,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'course-details',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ).tr(),
            const SizedBox(
              height: 10,
            ),
            HtmlBody(description: course.courseMeta.description.toString())
          ],
        ),
      ),
    );
  }
}
