import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/custom_colors.dart';
import '../services/app_service.dart';

class LoadingListTile extends StatelessWidget {
  const LoadingListTile({super.key, this.height});
  final double? height;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AppService.isDarkMode(context);

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: 6,
      separatorBuilder: (context, index) => const Divider(height: 50),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: isDarkMode ? CustomColor.shimmerBaseColorDark : CustomColor.shimmerBaseColor,
          highlightColor: isDarkMode ? CustomColor.shimmerhighlightColorDark : CustomColor.shimmerHighlightColor,
          child: Container(
            height: height ?? 200,
            color: Theme.of(context).canvasColor,
          ),
        );
      },
    );
  }
}
