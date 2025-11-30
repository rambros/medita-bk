import 'package:flutter/material.dart';
import 'package:lms_app/constants/custom_colors.dart';
import 'package:lms_app/services/app_service.dart';
import 'package:shimmer/shimmer.dart';

import '../screens/all_courses.dart/courses_view.dart';

class LoadingGridTile extends StatelessWidget {
  const LoadingGridTile({super.key, required this.gridStyle});
  final GridStyle gridStyle;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gridStyle == GridStyle.grid ? 2 : 1,
        childAspectRatio: gridStyle == GridStyle.grid
            ? 0.68
            : gridStyle == GridStyle.box
                ? 1.3
                : 2.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 6,
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
          baseColor: AppService.isDarkMode(context) ? CustomColor.shimmerBaseColorDark : CustomColor.shimmerBaseColor,
          highlightColor: AppService.isDarkMode(context) ? CustomColor.shimmerhighlightColorDark : CustomColor.shimmerHighlightColor,
          child: Container(
            color: Colors.white,
          ),
        );
      },
    );
  }
}