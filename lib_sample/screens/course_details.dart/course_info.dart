import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lms_app/models/course.dart';
import 'package:lms_app/models/user_model.dart';
import 'package:lms_app/screens/author_profie/author_profile.dart';
import 'package:lms_app/services/app_service.dart';
import 'package:lms_app/services/firebase_service.dart';
import 'package:lms_app/utils/next_screen.dart';
import 'package:lms_app/utils/snackbars.dart';

class CourseInfo extends StatelessWidget {
  const CourseInfo({super.key, required this.course});
  final Course course;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: 'created-by'.tr(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              children: [
                const TextSpan(text: ' '),
                TextSpan(
                  text: course.author.name,
                  recognizer: TapGestureRecognizer()..onTap = () => _onTapAuthor(context),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.blue),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(FeatherIcons.calendar, size: 20, color: Colors.blueGrey),
              const SizedBox(width: 5),
              Text('last-updated-', style: Theme.of(context).textTheme.bodyLarge).tr(
                args: [AppService.getDate(course.updatedAt ?? course.createdAt)],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(FeatherIcons.globe, size: 20, color: Colors.blueGrey),
              const SizedBox(width: 5),
              Text('language-', style: Theme.of(context).textTheme.bodyLarge).tr(args: [course.courseMeta.language.toString()]),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(FeatherIcons.clock, size: 20, color: Colors.blueGrey),
              const SizedBox(width: 5),
              Text('duration-', style: Theme.of(context).textTheme.bodyLarge).tr(args: [course.courseMeta.duration.toString()]),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(FeatherIcons.book, size: 20, color: Colors.blueGrey),
              const SizedBox(width: 5),
              Text('count-lesson', style: Theme.of(context).textTheme.bodyLarge).tr(args: [course.lessonsCount.toString()]),
            ],
          ),
        ],
      ),
    );
  }

  void _onTapAuthor(BuildContext context) async {
    final UserModel? author = await FirebaseService().getAuthorData(course.author.id);
    if (!context.mounted) return;
    if (author != null) {
      NextScreen.popup(context, AuthorProfile(user: author));
    } else {
      openSnackbar(context, 'Error on getting author profile');
    }
  }
}
