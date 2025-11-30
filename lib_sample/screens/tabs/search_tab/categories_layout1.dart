import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/category.dart';
import '../../all_courses.dart/courses_view.dart';
import '../../../utils/cache_image_filter.dart';
import '../../../utils/next_screen.dart';

class CategoriesLayout1 extends StatelessWidget {
  const CategoriesLayout1({super.key, 
    required this.categories,
  });

  final AsyncValue<List<Category>> categories;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'all-categories',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ).tr(),
          const SizedBox(
            height: 10,
          ),
          categories.when(
            loading: () => const CircularProgressIndicator(),
            error: (error, stackTrace) => Text('error: $error'),
            data: (data) {
              return Column(
                children: data.map((category) {
                  return InkWell(
                    onTap: () => NextScreen.iOS(
                      context,
                      AllCoursesView(courseBy: CourseBy.category, title: category.name, categoryId: category.id),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 7),
                          height: 100,
                          child: CustomCacheImageWithDarkFilterFull(
                            imageUrl: category.thumbnailUrl,
                            radius: 10,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              category.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
