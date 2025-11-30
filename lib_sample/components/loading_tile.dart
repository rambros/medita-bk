import 'package:flutter/material.dart';
import 'package:lms_app/constants/custom_colors.dart';
import 'package:lms_app/services/app_service.dart';
import 'package:shimmer/shimmer.dart';

class LoadingTile extends StatelessWidget {
  const LoadingTile({super.key, this.height, this.padding});

  final double? height;
  final double? padding;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AppService.isDarkMode(context);
    return Padding(
      padding: EdgeInsets.all(padding ?? 20),
      child: Shimmer.fromColors(
        baseColor: isDarkMode ? CustomColor.shimmerBaseColorDark : CustomColor.shimmerBaseColor,
        highlightColor: isDarkMode ? CustomColor.shimmerhighlightColorDark : CustomColor.shimmerHighlightColor,
        child: Container(
          height: height ?? 200,
          color: Theme.of(context).canvasColor,
        ),
      ),
    );
  }
}
