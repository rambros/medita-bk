import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/screens/home/home_bottom_bar.dart';
import 'package:lms_app/screens/tabs/home_tab/home_tab.dart';
import 'package:lms_app/screens/tabs/profile_tab/profile_tab.dart';
import 'package:lms_app/screens/tabs/search_tab/search_tab.dart';
import '../tabs/my_courses_tab/my_courses_tab.dart';

final homeTabControllerProvider = StateProvider<PageController>((ref) => PageController(initialPage: 0));

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = ref.watch(homeTabControllerProvider);
    return Scaffold(
        bottomNavigationBar: const BottomBar(),
        body: PageView(
          allowImplicitScrolling: true,
          controller: tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            HomeTab(),
            SearchTab(),
            MyCoursesTab(),
            ProfileTab(),
          ],
        ));
  }
}
