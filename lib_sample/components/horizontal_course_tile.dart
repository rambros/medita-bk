import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lms_app/components/price_tag.dart';
import 'package:lms_app/models/course.dart';
import 'rating_bar.dart';
import '../screens/course_details.dart/details_view.dart';
import '../utils/custom_cached_image.dart';
import '../utils/next_screen.dart';

class HorizontalCourseTile extends StatelessWidget {
  const HorizontalCourseTile({
    super.key,
    required this.course,
    required this.widthPercentage,
    required this.imageHeight,
  });

  final Course course;
  final double widthPercentage;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    final heroTag = UniqueKey();
    return InkWell(
      onTap: () => NextScreen.iOS(context, CourseDetailsView(course: course, heroTag: heroTag)),
      child: Container(
        width: MediaQuery.of(context).size.width * widthPercentage,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                    height: imageHeight,
                    width: MediaQuery.of(context).size.width,
                    child: Hero(
                      tag: heroTag,
                      child: CustomCacheImage(
                        imageUrl: course.thumbnailUrl,
                        radius: 0,
                      ),
                    )),
                PremiumTag(course: course),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.name,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 3),
                RatingViewer(rating: course.rating),
                const SizedBox(height: 3),
                Text(
                  'count-students',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.blueGrey),
                ).tr(args: [course.studentsCount.toString()])
              ],
            )
          ],
        ),
      ),
    );
  }
}
