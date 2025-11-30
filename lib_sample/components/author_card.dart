import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lms_app/components/user_avatar.dart';
import 'package:lms_app/constants/custom_colors.dart';
import 'package:lms_app/models/user_model.dart';
import 'package:lms_app/services/app_service.dart';
import 'package:lms_app/utils/next_screen.dart';

import '../screens/author_profie/author_profile.dart';

class AuthorCard extends StatelessWidget{
  final UserModel user;
  const AuthorCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final String jobTitle = user.authorInfo?.jobTitle ?? '';
    final int students = user.authorInfo?.students ?? 0;
    final String bio = user.authorInfo?.bio ?? '';

    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        border: Border.all(color: AppService.isDarkMode(context) ? CustomColor.borderDark : CustomColor.border),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserAvatar(imageUrl: user.imageUrl, radius: 40),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, fontSize: 18)),
                    Text(
                      jobTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Text('count-students', style: Theme.of(context).textTheme.titleSmall,).tr(args: [students.toString()]),
          const SizedBox(
            height: 10,
          ),
          Text(
            bio,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppService.isDarkMode(context) ? CustomColor.paragraphColorDark : CustomColor.paragraphColor,
                ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(elevation: 0, side: BorderSide(color: Theme.of(context).primaryColor)),
                onPressed: () => NextScreen.iOS(context, AuthorProfile(user: user)),
                child: const Text('view-profile').tr()),
          )
        ],
      ),
    );
  }
}
