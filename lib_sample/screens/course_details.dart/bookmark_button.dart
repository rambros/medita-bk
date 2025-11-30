import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lms_app/models/course.dart';
import 'package:lms_app/models/user_model.dart';
import 'package:lms_app/screens/auth/login.dart';
import 'package:lms_app/services/firebase_service.dart';
import 'package:lms_app/utils/next_screen.dart';
import 'package:lms_app/utils/snackbars.dart';

import '../../providers/user_data_provider.dart';

class BookmarkButton extends ConsumerWidget {
  const BookmarkButton({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
        onPressed: () async {
          final UserModel? user = ref.read(userDataProvider);
          if (user == null) {
            NextScreen.openBottomSheet(context, const LoginScreen(popUpScreen: true));
          } else {
            if (!user.wishList!.contains(course.id)) {
              openSnackbar(context, 'added-wishlist'.tr());
            } else {
              openSnackbar(context, 'removed-wishlist'.tr());
            }
            await FirebaseService().updateWishList(user, course);
            ref.read(userDataProvider.notifier).getData();
          }
        },
        icon: _BookmarkIcon(
          course: course,
        ));
  }
}

class _BookmarkIcon extends ConsumerWidget {
  const _BookmarkIcon({required this.course});

  final Course course;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double iconSize = 20;
    final user = ref.watch(userDataProvider);
    if (user == null || user.wishList!.isEmpty) {
      return const Icon(FeatherIcons.heart, size: iconSize);
    } else if (user.wishList!.contains(course.id)) {
      return const Icon(LineIcons.heartAlt, color: Colors.redAccent, size: iconSize);
    } else {
      return const Icon(FeatherIcons.heart, size: iconSize);
    }
  }
}
