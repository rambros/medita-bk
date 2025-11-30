import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../components/user_avatar.dart';
import '../../models/user_model.dart';
import '../../services/app_service.dart';

class AuthorProfileInfo extends StatelessWidget {
  const AuthorProfileInfo({
    super.key,
    required this.user,
    required this.jobTitle,
  });

  final UserModel user;
  final String jobTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 40),
      child: Column(
        children: [
          UserAvatar(
            imageUrl: user.imageUrl,
            radius: 100,
            iconSize: 60,
          ),
          const SizedBox(height: 10),
          Text(
            user.name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            jobTitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: user.authorInfo != null && user.authorInfo?.website != null,
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  child: IconButton(
                    icon: Icon(
                      FontAwesomeIcons.globe,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () => AppService().openLink(user.authorInfo!.website!),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Visibility(
                visible: user.authorInfo != null && user.authorInfo?.fb != null,
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  child: IconButton(
                    icon: Icon(
                      FontAwesomeIcons.facebook,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () => AppService().openLink(user.authorInfo!.fb!),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Visibility(
                visible: user.authorInfo != null && user.authorInfo?.twitter != null,
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  child: IconButton(
                    icon: Icon(
                      FontAwesomeIcons.twitter,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () => AppService().openLink(user.authorInfo!.twitter!),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
