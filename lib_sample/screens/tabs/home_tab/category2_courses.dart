import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/components/loading_tile.dart';
import 'package:lms_app/constants/custom_colors.dart';
import 'package:lms_app/components/horizontal_course_tile.dart';
import 'package:lms_app/models/app_settings_model.dart';
import 'package:lms_app/models/course.dart';
import 'package:lms_app/screens/all_courses.dart/courses_view.dart';
import 'package:lms_app/services/firebase_service.dart';
import 'package:lms_app/theme/theme_provider.dart';
import 'package:lms_app/utils/next_screen.dart';

final category2CoursessProvider = FutureProvider.family<List<Course>, String>((ref, categoryId) async {
  final List<Course> courses = await FirebaseService().getHomeCategoryCourses(categoryId, 5);
  return courses;
});

class Category2Courses extends ConsumerWidget {
  const Category2Courses({super.key, required this.category});

  final HomeCategory category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(category2CoursessProvider(category.id));
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    return courses.when(
        data: (courses) {
          return Visibility(
            visible: courses.isNotEmpty,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.symmetric(vertical: 40),
              color: isDarkMode ? CustomColor.containerDark : CustomColor.container,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: RichText(
                              text: TextSpan(
                                  text: 'top-courses-in'.tr(),
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                                  children: [
                                const TextSpan(text: ' '),
                                TextSpan(
                                  text: category.name,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.blueAccent, fontWeight: FontWeight.w700),
                                )
                              ])),
                        ),
                        TextButton(
                          onPressed: () => NextScreen.iOS(
                              context,
                              AllCoursesView(
                                courseBy: CourseBy.category,
                                title: category.name,
                                categoryId: category.id,
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: courses.map((course) {
                        return HorizontalCourseTile(course: course, widthPercentage: 0.50, imageHeight: 120);
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
          );
        },
        error: (e, x) => Text('error: $e, $x'),
        loading: () => const LoadingTile(height: 300));
  }
}
