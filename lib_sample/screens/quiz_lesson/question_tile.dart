import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/models/question.dart';
import 'package:lms_app/screens/quiz_lesson/option_tile.dart';
import 'package:lms_app/theme/theme_provider.dart';
import '../../constants/custom_colors.dart';

class QuestionTile extends StatelessWidget {
  const QuestionTile({
    super.key,
    required this.ref,
    required this.questions,
    required this.currentPageIndex,
    required this.question,
    this.selectedOption,
    required this.questionIndex,
  });

  final WidgetRef ref;
  final List<Question> questions;
  final int currentPageIndex;
  final Question question;
  final int? selectedOption;
  final int questionIndex;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        decoration: BoxDecoration(
          color: isDarkMode ? CustomColor.container1Dark : CustomColor.container1,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'count-questions',
              style: Theme.of(context).textTheme.bodyLarge,
            ).tr(args: ['${currentPageIndex + 1}', questions.length.toString()]),
            const SizedBox(height: 10),
            Text('Q${currentPageIndex + 1}. ${question.questionTitle}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),

            // OPTIONS
            ListView.builder(
              shrinkWrap: true,
              itemCount: question.options.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return OptionTile(
                  ref: ref,
                  question: question,
                  questionIndex: questionIndex,
                  optionIndex: index,
                  selectedOption: selectedOption,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
