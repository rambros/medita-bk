import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/constants/custom_colors.dart';
import 'package:lms_app/theme/theme_provider.dart';
import '../../models/review.dart';
import '../../providers/app_settings_provider.dart';
import '../../providers/user_data_provider.dart';
import '../../services/app_service.dart';
import '../../components/rating_bar.dart';
import '../../components/user_avatar.dart';

class ReviewTile extends ConsumerWidget {
  const ReviewTile({super.key, required this.review});

  final Review review;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: isDarkMode ? CustomColor.borderDark : CustomColor.border),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              UserAvatar(imageUrl: review.reviewUser.imageUrl, radius: 20, iconSize: 12),
              const SizedBox(width: 10),
              Text(
                review.reviewUser.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              _reportButton(ref),
            ],
          ),
          const SizedBox(height: 8),
          RatingViewer(rating: review.rating),
          const SizedBox(height: 8),
          Visibility(
            visible: review.review != null,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(review.review.toString(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  )),
            ),
          ),
          Text(
            AppService.getDateTime(review.createdAt),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.blueGrey),
          )
        ],
      ),
    );
  }

  PopupMenuButton _reportButton(WidgetRef ref) {
    return PopupMenuButton(
      child: const Icon(FeatherIcons.moreHorizontal, size: 20),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: Text('report', style: Theme.of(context).textTheme.titleMedium).tr(),
            onTap: () {
              final user = ref.read(userDataProvider);
              final supportEmail = ref.read(appSettingsProvider)?.supportEmail ?? '';
              AppService().openReviewReportEmail(context, review, user, supportEmail);
            },
          ),
        ];
      },
    );
  }
}
