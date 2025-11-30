import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lms_app/mixins/user_mixin.dart';
import 'package:lms_app/models/course.dart';
import 'package:lms_app/screens/auth/login.dart';
import 'package:lms_app/utils/next_screen.dart';
import 'package:lms_app/utils/snackbars.dart';
import '../reviews/rating_form.dart';
import '../../models/review.dart';
import '../../models/user_model.dart';
import '../../providers/user_data_provider.dart';
import '../../services/firebase_service.dart';

class ReviewButton extends ConsumerWidget with UserMixin {
  const ReviewButton({super.key, required this.course});
  final Course course;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserModel? user = ref.watch(userDataProvider);
    return IconButton(
      tooltip: 'Rate this course',
      onPressed: () async {
        final UserModel? user = ref.read(userDataProvider);
        if (user == null) {
          NextScreen.openBottomSheet(context, const LoginScreen(popUpScreen: true));
        } else if (!hasEnrolled(user, course)) {
          openSnackbar(context, 'enroll-to-make-reviews'.tr());
        } else {
          final Review? review = await FirebaseService().getUserReview(course.id, user.id);
          if (!context.mounted) return;
          NextScreen.openBottomSheet(context, RatingForm(review: review, course: course));
        }
      },
      icon: user != null && user.reviews!.contains(course.id)
          ? const Icon(LineIcons.starAlt, size: 22, color: Colors.orange)
          : const Icon(LineIcons.star, size: 22),
    );
  }
}
