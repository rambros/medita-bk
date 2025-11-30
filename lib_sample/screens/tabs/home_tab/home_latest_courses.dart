import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/components/course_tile.dart';
import 'package:lms_app/models/course.dart';
import 'package:lms_app/screens/all_courses.dart/courses_view.dart';
import 'package:lms_app/services/firebase_service.dart';
import 'package:lms_app/utils/loading_widget.dart';
import 'package:lms_app/utils/next_screen.dart';

final homeLatestCoursesProvider = FutureProvider<List<Course>>((ref) async {
  final List<Course> courses = await FirebaseService().getLatestCourses(4);
  return courses;
});

class HomeLatestCourses extends ConsumerWidget {
  const HomeLatestCourses({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(homeLatestCoursesProvider);
    return courses.when(
        data: (courses) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RichText(
                            text: TextSpan(
                                text: 'explore'.tr(),
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                children: [
                              const TextSpan(text: ' '),
                              TextSpan(
                                text: 'latest-courses'.tr(),
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                              )
                            ])),
                      ),
                      TextButton(
                        onPressed: () => NextScreen.iOS(
                            context,
                            AllCoursesView(
                              courseBy: CourseBy.latest,
                              title: 'latest-courses'.tr(),
                            )),
                        style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
                        child: Text(
                          'view-all',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ).tr(),
                      )
                    ],
                  ),
                ),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: courses.length,
                  padding: const EdgeInsets.all(20),
                  separatorBuilder: (context, index) => const Divider(height: 50),
                  itemBuilder: (context, index) {
                    final Course course = courses[index];
                    return CourseTile(course: course);
                  },
                )
              ],
            ),
          );
        },
        error: (e, x) => Text('error: $e, $x'),
        loading: () => const LoadingIndicatorWidget());
  }
}
