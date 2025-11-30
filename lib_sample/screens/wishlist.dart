import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/components/loading_list_tile.dart';
import 'package:lms_app/configs/app_assets.dart';
import 'package:lms_app/mixins/course_mixin.dart';
import 'package:lms_app/utils/empty_animation.dart';
import 'package:quiver/iterables.dart';

import '../components/course_tile.dart';
import '../models/course.dart';
import '../providers/user_data_provider.dart';
import '../services/firebase_service.dart';

final wishlistProvider = FutureProvider<List<Course>>((ref) async {
  final List<Course> courses = [];
  final user = ref.watch(userDataProvider)!;
  final courseIds = user.wishList ?? [];
  final chunks = partition(courseIds, 10);

  final querySnapshots = await Future.wait(chunks.map((chunk) => FirebaseService().getCoursesQuery(chunk)).toList());
  for (var element in querySnapshots) {
    courses.addAll(element.docs.map((e) => Course.fromFirestore(e)).toList());
  }

  return courses;
});

class Wishlist extends ConsumerWidget with CourseMixin {
  const Wishlist({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDataProvider);
    final wishlist = ref.watch(wishlistProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('wishlist').tr(),
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, fontSize: 20),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FeatherIcons.chevronLeft)),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(wishlistProvider),
        child: user == null || user.wishList == null || user.wishList!.isEmpty
            ? EmptyAnimation(animationString: emptyAnimation, title: 'no-course'.tr())
            : wishlist.when(
                skipLoadingOnRefresh: false,
                loading: () => const LoadingListTile(height: 160),
                error: (error, stackTrace) => Center(
                  child: Text(error.toString()),
                ),
                data: (data) {
                  return ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: data.length,
                    separatorBuilder: (context, index) => const Divider(height: 50),
                    itemBuilder: (context, index) {
                      final Course course = data[index];
                      return CourseTile(course: course);
                    },
                  );
                },
              ),
      ),
    );
  }
}
