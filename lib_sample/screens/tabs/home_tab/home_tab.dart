import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lms_app/components/app_logo.dart';
import 'package:lms_app/screens/tabs/home_tab/top_authors.dart';
import 'package:lms_app/screens/notifications/notifications.dart';
import 'package:lms_app/screens/search/search_view.dart';
import 'package:lms_app/screens/wishlist.dart';
import 'package:lms_app/utils/next_screen.dart';
import '../../../providers/app_settings_provider.dart';
import 'category1_courses.dart';
import 'category2_courses.dart';
import 'category3_courses.dart';
import 'featured_courses.dart';
import 'free_courses.dart';
import 'home_categories.dart';
import 'home_latest_courses.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    return RefreshIndicator.adaptive(
      displacement: 60,
      onRefresh: () async {
        ref.invalidate(featuredCoursesProvider);
        ref.invalidate(homeCategoriesProvider);
        ref.invalidate(freeCoursesProvider);
        ref.invalidate(category1CoursessProvider);
        ref.invalidate(category2CoursessProvider);
        ref.invalidate(category3CoursessProvider);
        ref.invalidate(topAuthorsProvider);
        ref.invalidate(homeLatestCoursesProvider);
      },
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const AppLogo(),
            pinned: false,
            floating: true,
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                // style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                onPressed: () {
                  NextScreen.iOS(context, const SearchScreen());
                },
                icon: const Icon(FeatherIcons.search, size: 22),
              ),
              IconButton(
                style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                onPressed: () {
                  NextScreen.iOS(context, const Wishlist());
                },
                icon: const Icon(FeatherIcons.heart, size: 22),
              ),
              IconButton(
                // style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                onPressed: () {
                  NextScreen.iOS(context, const Notifications());
                },
                icon: const Icon(LineIcons.bell),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Visibility(visible: settings?.featured ?? true, child: const FeaturedCourses()),
                Visibility(visible: settings?.categories ?? true, child: const HomeCategories()),
                Visibility(visible: settings?.freeCourses ?? true, child: const FreeCourses()),
                if (settings != null && settings.homeCategory1 != null) Category1Courses(category: settings.homeCategory1!),
                if (settings != null && settings.homeCategory2 != null) Category2Courses(category: settings.homeCategory2!),
                if (settings != null && settings.homeCategory3 != null) Category3Courses(category: settings.homeCategory3!),
                Visibility(visible: settings?.topAuthors ?? true, child: const TopAuthors()),
                Visibility(visible: settings?.latestCourses ?? true, child: const HomeLatestCourses()),
              ],
            ),
          )
        ],
      ),
    );
  }
}
