import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lms_app/components/price_tag.dart';
import 'package:lms_app/mixins/course_mixin.dart';
import 'package:lms_app/mixins/user_mixin.dart';
import '../../../models/course.dart';
import '../../../models/user_model.dart';
import '../../course_details.dart/details_view.dart';
import '../../../utils/custom_cached_image.dart';
import '../../../utils/next_screen.dart';

class MyCourseTile extends StatelessWidget with UserMixin {
  const MyCourseTile({super.key, required this.course, required this.user});

  final Course course;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final heroTag = UniqueKey();
    List validIds = user.completedLessons!.where((element) => element.toString().contains(course.id)).toList();
    final double courseProgress = validIds.isEmpty ? 0 : (validIds.length / (course.lessonsCount != 0 ? course.lessonsCount : 1));
    final String courseProgesString = (courseProgress * 100).toStringAsFixed(0);

    return InkWell(
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.blueAccent),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 5),
                    child: LinearProgressIndicator(
                      value: courseProgress,
                      borderRadius: BorderRadius.circular(20),
                      minHeight: 8,
                      color: Colors.orange.shade300,
                    ),
                  ),
                  const Text('percent-completed').tr(args: [courseProgesString]),
                  const SizedBox(
                    height: 10,
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        side: BorderSide(color: Theme.of(context).primaryColor),
                        textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)
                        ),
                    child: Text(CourseMixin.enrollButtonText(course, user)).tr(),
                    onPressed: () => handleOpenCourse(context, user: user, course: course),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
