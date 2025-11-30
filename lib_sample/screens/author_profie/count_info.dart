import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AuthorCountInfo extends StatelessWidget {
  const AuthorCountInfo({
    super.key,
    required this.students,
    required this.courseCount,
    required this.reviewsCount,
  });

  final int students;
  final int courseCount;
  final int reviewsCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'students',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500, fontSize: 12),
            ).tr(),
            const SizedBox(height: 3),
            Text(
              students.toString(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'courses',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500, fontSize: 12),
            ).tr(),
            const SizedBox(height: 3),
            Text(
              courseCount.toString(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'reviews',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500, fontSize: 12),
            ).tr(),
            const SizedBox(height: 3),
            Text(
              reviewsCount.toString(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}