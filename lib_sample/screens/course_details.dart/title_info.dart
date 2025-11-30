import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/screens/reviews/rating_form.dart';
import 'package:lms_app/constants/custom_colors.dart';
import 'package:lms_app/models/course.dart';
import 'package:lms_app/theme/theme_provider.dart';
import '../../components/rating_bar.dart';

class TitleInfo extends ConsumerWidget {
  const TitleInfo({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    final rating = ref.watch(courseRatingProvider(course));

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        course.name,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: 24,
              height: 1.5,
              wordSpacing: 3,
              fontWeight: FontWeight.bold,
            ),
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              RatingViewer(rating: rating),
            ],
          ),
          const SizedBox(width: 20),
          Text(
            'count-students',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ).tr(args: [course.studentsCount.toString()]),
        ],
      ),
      const SizedBox(height: 20),
      Text(
        course.courseMeta.summary.toString(),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 17,
              color: isDarkMode ? CustomColor.paragraphColorDark : CustomColor.paragraphColor,
              height: 1.7,
              fontWeight: FontWeight.w400,
            ),
      )
    ]);
  }
}
