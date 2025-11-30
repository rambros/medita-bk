import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/screens/course_details.dart/sections.dart';
import '../../models/course.dart';

class Curriculam extends ConsumerWidget {
  const Curriculam({
    super.key,
    required this.course,
  });

  final Course course;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'curricullam',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ).tr(),
        Sections(
          course: course,
          isInitialSectionOpen: false,
        ),
      ],
    );
  }
}
