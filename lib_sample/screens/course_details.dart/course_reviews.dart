import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/models/course.dart';
import 'package:lms_app/models/review.dart';
import 'package:lms_app/screens/reviews/reviews.dart';
import 'package:lms_app/services/firebase_service.dart';
import 'package:lms_app/utils/next_screen.dart';

import '../reviews/review_tile.dart';

final courseReviewProvider = FutureProvider.family<List<Review>, String>((ref, courseId) async {
  final List<Review> reviews = await FirebaseService().getLimitedReviews(courseId, 3);
  return reviews;
});

class CourseReviews extends ConsumerWidget {
  const CourseReviews({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviews = ref.watch(courseReviewProvider(course.id));
    return Visibility(
      visible: reviews.value != null && reviews.value!.isNotEmpty,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'student-feedbacks',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ).tr(),
            reviews.when(
              loading: () => const CircularProgressIndicator(),
              error: (e, x) => Text('error: $e'),
              data: (data) {
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  itemCount: data.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => const SizedBox(height: 20),
                  itemBuilder: (BuildContext context, int index) {
                    final Review review = data[index];
                    return ReviewTile(review: review);
                  },
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  NextScreen.popup(context, AllReviews(course));
                },
                child: const Text('view-all-reviews').tr(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
