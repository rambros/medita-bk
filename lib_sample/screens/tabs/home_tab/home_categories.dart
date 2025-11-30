import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/components/loading_tile.dart';
import 'package:lms_app/screens/all_courses.dart/courses_view.dart';
import 'package:lms_app/services/firebase_service.dart';
import 'package:lms_app/utils/next_screen.dart';
import '../../../models/category.dart';
import '../../home/home_bottom_bar.dart';
import '../../home/home_view.dart';

final homeCategoriesProvider = FutureProvider<List<Category>>((ref) async {
  final List<Category> categories = await FirebaseService().getHomeCategories(5);
  return categories;
});

class HomeCategories extends ConsumerWidget {
  const HomeCategories({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(homeCategoriesProvider);
    return Visibility(
      visible: categories.value != null && categories.value!.isNotEmpty,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'categories',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ).tr(),
                TextButton(
                  onPressed: () {
                    ref.read(navBarIndexProvider.notifier).state = 1;
                    ref.read(homeTabControllerProvider.notifier).state.animateToPage(1, duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
                  },
                  style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
                  child: Text(
                    'view-all',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ).tr(),
                )
              ],
            ),
            const SizedBox(height: 10),
            categories.when(
                skipLoadingOnRefresh: false,
                data: (categories) {
                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: categories
                        .take(4)
                        .map((e) => ActionChip(
                              onPressed: () => NextScreen.iOS(
                                context,
                                AllCoursesView(courseBy: CourseBy.category, title: e.name, categoryId: e.id),
                              ),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              label: Text(
                                e.name,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ))
                        .toList(),
                  );
                },
                error: (e, x) => Text('error: $e, $x'),
                loading: () => const LoadingTile(height: 100, padding: 0)),
          ],
        ),
      ),
    );
  }
}
