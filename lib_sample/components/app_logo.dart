import 'package:flutter/material.dart';
import 'package:lms_app/configs/app_assets.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      logo,
      height: 60,
      width: 130,
    );
  }
}
