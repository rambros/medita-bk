import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/ads/ad_manager.dart';
import 'package:lms_app/components/mark_complete_button.dart';
import 'package:lms_app/models/course.dart';
import 'package:lms_app/models/lesson.dart';
import 'package:lms_app/screens/quiz_lesson/quiz_screen.dart';
import 'package:lms_app/utils/next_screen.dart';

class QuizComplete extends ConsumerWidget {
  const QuizComplete({super.key, required this.lesson, required this.course});

  final Lesson lesson;
  final Course course;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final correctAnswerCount = ref.watch(correctAnswerCountProvider);
    final double percentage = (correctAnswerCount / lesson.questions!.length) * 100;
    final bool isPassed = percentage >= 50 ? true : false;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        title: Text(lesson.name),
      ),
      bottomNavigationBar: isPassed
          ? MarkCompleteButton(course: course, lesson: lesson)
          : BottomAppBar(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  'try-again',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18, color: Colors.white),
                ).tr(),
                onPressed: () {
                  // Placed ads when user failed the test
                  AdManager.initInterstitailAds(ref);
                  NextScreen.replaceAnimation(context, QuizLesson(course: course, lesson: lesson));
                },
              ),
            ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.all(30),
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Text(
                    'your-score',
                    style: Theme.of(context).textTheme.titleLarge,
                  ).tr(),
                  const SizedBox(height: 10),
                  Text('score-count', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.green))
                      .tr(args: [percentage.toStringAsFixed(0)]),
                  const SizedBox(height: 20),
                  Text(
                    isPassed ? 'passed-test' : "failed-test",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(),
                  ).tr(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
