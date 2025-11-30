import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lms_app/constants/custom_colors.dart';
import 'package:lms_app/services/app_service.dart';
import 'rating_bar.dart';
import '../models/course.dart';
import '../screens/course_details.dart/details_view.dart';
import '../utils/next_screen.dart';

class FeaturedCourseTile extends StatelessWidget {
  const FeaturedCourseTile({
    super.key,
    required this.course,
  });

  final Course course;

  @override
  Widget build(BuildContext context) {
    final heroTag = UniqueKey();
    return InkWell(
      onTap: () => NextScreen.iOS(context, CourseDetailsView(course: course, heroTag: heroTag)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppService.isDarkMode(context) ? CustomColor.borderDark : CustomColor.border
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: heroTag,
              child: Stack(
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(3), topRight: Radius.circular(3)),
                        image: DecorationImage(image: CachedNetworkImageProvider(course.thumbnailUrl), fit: BoxFit.cover)),
                    width: MediaQuery.of(context).size.width,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Theme.of(context).primaryColor.withValues(alpha: 0.8)),
                        margin: const EdgeInsets.all(20),
                        child: Text(
                          'featured',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                        ).tr()),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'count-students',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.blueGrey),
                  ).tr(args: [course.studentsCount.toString()]),
                  const SizedBox(height: 3),
                  RatingViewer(rating: course.rating),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
