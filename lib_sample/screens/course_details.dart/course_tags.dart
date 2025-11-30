import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/models/tag.dart';
import 'package:lms_app/screens/all_courses.dart/courses_view.dart';
import 'package:lms_app/services/firebase_service.dart';
import 'package:lms_app/utils/next_screen.dart';
import '../../models/course.dart';

final courseTagsProvider = FutureProvider.family.autoDispose<List<Tag>, List>((ref, tagIds) async {
  List<Tag> tags = await FirebaseService().getCourseTags(tagIds);
  return tags;
});

class CourseTags extends ConsumerWidget {
  const CourseTags({
    super.key,
    required this.course,
  });

  final Course course;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsRef = ref.watch(courseTagsProvider(course.tagIDs ?? []));
    return Visibility(
      visible: course.tagIDs!.isNotEmpty,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: tagsRef.when(
            loading: () => Container(),
            error: (error, stackTrace) => Container(),
            data: (tags) {
              return Wrap(
                spacing: 10,
                runSpacing: 8,
                children: tags.map((tag) {
                  return InkWell(
                    onTap: () => NextScreen.iOS(
                      context,
                      AllCoursesView(
                        courseBy: CourseBy.tag,
                        title: '#${tag.name}',
                        tagId: tag.id,
                      ),
                    ),
                    child: Chip(
                      labelStyle: Theme.of(context).textTheme.titleMedium,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 15),
                      label: Text('#${tag.name}'),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 0,
                    ),
                  );
                }).toList(),
              );
            }),
      ),
    );
  }
}
