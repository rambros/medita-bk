import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lms_app/components/price_tag.dart';
import 'package:lms_app/components/rating_bar.dart';
import 'package:lms_app/screens/all_courses.dart/courses_view.dart';
import 'package:lms_app/screens/course_details.dart/details_view.dart';
import 'package:lms_app/utils/custom_cached_image.dart';
import 'package:lms_app/utils/next_screen.dart';

import '../../models/course.dart';

class GridCourseTile extends StatelessWidget {
  const GridCourseTile({super.key, required this.course, required this.gridStyle});

  final Course course;
  final GridStyle gridStyle;

  @override
  Widget build(BuildContext context) {
    final heroTag = UniqueKey();
    return InkWell(
      onTap: () => NextScreen.iOS(
          context,
          CourseDetailsView(
            course: course,
            heroTag: heroTag,
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: gridStyle == GridStyle.grid ? 130 : 180,
                    color: Colors.grey.shade100,
                    child: Hero(tag: heroTag, child: CustomCacheImage(imageUrl: course.thumbnailUrl, radius: 0)),
                  ),
                  PremiumTag(course: course)
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            course.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 3),
          Text(
            'count-students',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.blueGrey),
          ).tr(args: [course.studentsCount.toString()]),
          const SizedBox(height: 5),
          RatingViewer(rating: course.rating),
        ],
      ),
    );
  }
}
