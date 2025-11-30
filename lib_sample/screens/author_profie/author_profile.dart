import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/constants/custom_colors.dart';
import 'package:lms_app/models/user_model.dart';
import 'package:lms_app/services/firebase_service.dart';
import '../../theme/theme_provider.dart';
import 'author_courses.dart';
import 'count_info.dart';
import 'profile_info.dart';

final authorReviewsCountProvider = FutureProvider.family.autoDispose<int, String>((ref, authorId) async {
  final int count = await FirebaseService().getAuthorReviewsCount(authorId);
  return count;
});

final authorCoursesCountProvider = FutureProvider.family.autoDispose<int, String>((ref, authorId) async {
  final int count = await FirebaseService().getAuthorCourseCount(authorId);
  return count;
});

class AuthorProfile extends ConsumerWidget {
  const AuthorProfile({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;

    final String jobTitle = user.authorInfo?.jobTitle ?? '';
    final String bio = user.authorInfo?.bio ?? '';
    final int students = user.authorInfo?.students ?? 0;
    final int reviewsCount = ref.watch(authorReviewsCountProvider(user.id)).value ?? 0;
    final int courseCount = ref.watch(authorCoursesCountProvider(user.id)).value ?? 0;

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: const Text('instructor').tr(),
            foregroundColor: Colors.white,
            pinned: false,
            floating: true,
            elevation: 0,
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                AuthorProfileInfo(user: user, jobTitle: jobTitle),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AuthorCountInfo(students: students, courseCount: courseCount, reviewsCount: reviewsCount),
                      const SizedBox(height: 40),
                      Text(
                        'about-me',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ).tr(),
                      const SizedBox(height: 10),
                      Text(
                        bio,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.7,
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: isDarkMode ? CustomColor.paragraphColorDark : CustomColor.paragraphColor,
                            ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'my-courses',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ).tr(),
                      const SizedBox(height: 10),
                      AuthorCourses(
                        user: user,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
