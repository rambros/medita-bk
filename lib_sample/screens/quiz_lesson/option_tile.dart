import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/models/question.dart';
import 'quiz_screen.dart';

class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    required this.ref,
    required this.question,
    required this.questionIndex,
    this.selectedOption,
    required this.optionIndex,
  });

  final WidgetRef ref;
  final Question question;
  final int questionIndex;
  final int? selectedOption;
  final int optionIndex;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedOption != null && optionIndex == selectedOption;
    final bool isCorrectOption = optionIndex == question.correctAnswerIndex ? true : false;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: RadioListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            // ignore: deprecated_member_use
            groupValue: ref.watch(selectedOptionProvider),
            title: Text(
              question.options[optionIndex],
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w500),
            ),
            tileColor: _tileColor(context, isSelected, isCorrectOption),
            value: optionIndex,
            activeColor: Colors.white,
            secondary: _trailingIcon(isSelected, isCorrectOption),
            contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            // ignore: deprecated_member_use
            onChanged: selectedOption != null ? null : (int? value) => _onChanged(value, ref, questionIndex, isCorrectOption)),
      ),
    );
  }

  void _onChanged(int? value, WidgetRef ref, int questionIndex, bool isCorrectOption) {
    ref.read(selectedOptionProvider.notifier).update((state) => value);

    //Initiating corrct Answer count
    if (questionIndex == 0) {
      ref.invalidate(correctAnswerCountProvider);
    }

    //updting correct answer count when the answer is correct
    if (isCorrectOption) {
      ref.read(correctAnswerCountProvider.notifier).update((state) => state + 1);
    }
  }

  Icon? _trailingIcon(bool isSelected, bool isCorrectOption) {
    if (!isSelected) {
      return null;
    } else {
      if (isCorrectOption) {
        return const Icon(Icons.check, color: Colors.white);
      } else {
        return const Icon(Icons.clear, color: Colors.white);
      }
    }
  }

  Color _tileColor(BuildContext context, bool isSelected, bool isCorrectOption) {
    if (!isSelected) {
      return Theme.of(context).scaffoldBackgroundColor;
    } else {
      if (isCorrectOption) {
        return Colors.orangeAccent;
      } else {
        return Colors.redAccent;
      }
    }
  }
}
