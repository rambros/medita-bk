import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/components/loading_tile.dart';
import 'package:lms_app/models/course.dart';
import 'package:lms_app/services/firebase_service.dart';
import '../../../components/featured_course_tile.dart';

final featuredCoursesProvider = FutureProvider<List<Course>>((ref) async {
  final List<Course> courses = await FirebaseService().getFeaturedCourses();
  return courses;
});

class FeaturedCourses extends ConsumerWidget {
  const FeaturedCourses({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(featuredCoursesProvider);
    return courses.when(
      skipLoadingOnRefresh: false,
      data: (courses) {
        return Visibility(
          visible: courses.isNotEmpty,
          child: CarouselSlider(
            items: courses.map((course) {
              return FeaturedCourseTile(course: course);
            }).toList(),
            options: CarouselOptions(
              height: 300,
              enableInfiniteScroll: true,
              pageSnapping: true,
              viewportFraction: 0.8,
              enlargeFactor: 0.2,
              autoPlay: true,
              enlargeCenterPage: true,
              enlargeStrategy: CenterPageEnlargeStrategy.zoom,
            ),
          ),
        );
      },
      error: (e, x) => Text('error: $e, $x'),
      loading: () => const LoadingTile(height: 260),
    );
  }
}
