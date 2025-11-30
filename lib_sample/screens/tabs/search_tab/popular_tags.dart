import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/tag.dart';
import '../../all_courses.dart/courses_view.dart';
import '../../../utils/next_screen.dart';

class PopularTags extends StatelessWidget {
  const PopularTags({super.key, required this.tags});

  final AsyncValue<List<Tag>> tags;

  @override
  Widget build(BuildContext context) {
    return tags.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text('error: $error'),
      data: (data) {
        return Wrap(
          spacing: 5,
          runSpacing: 3,
          children: data.map((tag) {
            return ActionChip(
              onPressed: () => NextScreen.iOS(
                context,
                AllCoursesView(courseBy: CourseBy.tag, title: '#${tag.name}', tagId: tag.id),
              ),
              label: Text(
                tag.name,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            );
          }).toList(),
        );
      },
    );
  }
}