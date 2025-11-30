import 'package:flutter/material.dart';
import 'package:lms_app/models/course.dart';

import '../configs/app_assets.dart';
import '../constants/app_constants.dart';

class PremiumTag extends StatelessWidget {
  const PremiumTag({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: course.priceStatus == priceStatus.keys.elementAt(1),
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
              ),
            ),
            child: Image.asset(premiumImage, height: 16, width: 16, fit: BoxFit.contain)),
      ),
    );
  }
}
