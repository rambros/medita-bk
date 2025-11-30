import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/constants/custom_colors.dart';
import 'package:lms_app/models/course.dart';
import 'package:lms_app/theme/theme_provider.dart';
import 'package:lms_app/utils/loading_widget.dart';
import '../../models/section.dart';
import '../../services/firebase_service.dart';
import 'lessons.dart';

final sectionsProvider = FutureProvider.family<List<Section>, String>((ref, courseId) async {
  final sections = await FirebaseService().getSections(courseId);
  return sections;
});

final isSectionExpnadedProvider = StateProvider.autoDispose.family<bool, String>((ref, sectionId) => false);

class Sections extends ConsumerWidget {
  const Sections({super.key, required this.course, required this.isInitialSectionOpen});

  final Course course;
  final bool isInitialSectionOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sections = ref.watch(sectionsProvider(course.id));
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    return sections.when(
      error: (e, x) => Container(),
      loading: () => const LoadingIndicatorWidget(),
      data: (sections) {
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 20),
          itemCount: sections.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemBuilder: (BuildContext context, int index) {
            final Section section = sections[index];
            final bool isExpanded = ref.watch(isSectionExpnadedProvider(section.id));
            return ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(color: isDarkMode ? CustomColor.borderDark : CustomColor.border),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(color: isDarkMode ? CustomColor.borderDark : CustomColor.border),
              ),
              maintainState: true,
              title: Text(
                '${index + 1}. ${section.name}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isExpanded ? Colors.blueAccent : Theme.of(context).expansionTileTheme.textColor,
                      fontSize: 17
                    ),
              ),
              initiallyExpanded: index == 0 && isInitialSectionOpen ? true : false,
              children: [Lessons(course: course, sectionId: section.id)],
              onExpansionChanged: (bool value) => ref.read(isSectionExpnadedProvider(section.id).notifier).update((state) => value),
            );
          },
        );
      },
    );
  }
}
