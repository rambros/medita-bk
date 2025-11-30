import 'package:flutter/material.dart';
import 'package:lms_app/utils/empty_icon.dart';

class NoLicenseFound extends StatelessWidget {
  const NoLicenseFound({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: EmptyPageWithIcon(
          icon: Icons.key_off,
          title: 'No License Found!',
          description: 'Active your license from your admin panel',
        ),
      ),
    );
  }
}
