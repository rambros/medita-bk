import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lms_app/components/price_tag.dart';
import 'package:lms_app/components/rating_bar.dart';
import 'package:lms_app/screens/course_details.dart/details_view.dart';
import 'package:lms_app/utils/custom_cached_image.dart';
import 'package:lms_app/utils/next_screen.dart';
import '../../models/course.dart';

class GridListCourseTile extends StatelessWidget {
  const GridListCourseTile({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    final heroTag = UniqueKey();
    return Column(
      children: [
        InkWell(
          onTap: () => NextScreen.iOS(context, CourseDetailsView(course: course, heroTag: heroTag)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    height: 90,
                    width: 100,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
                    child: Hero(tag: heroTag, child: CustomCacheImage(imageUrl: course.thumbnailUrl, radius: 3)),
                  ),
                  PremiumTag(course: course),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'By ${course.author.name}',
                        style: const TextStyle(color: Colors.purpleAccent),
                      ),
                      const SizedBox(height: 5),
                      Text('count-students', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.blueGrey)).tr(args: [
                        course.studentsCount.toString(),
                      ]),
                      const SizedBox(height: 5),
                      RatingViewer(rating: course.rating),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        const Divider()
      ],
    );
  }
}
