import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lms_app/screens/intro.dart';
import 'package:lms_app/utils/next_screen.dart';

class NoUserFound extends StatelessWidget {
  const NoUserFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LineIcons.userSlash, size: 100),
            const SizedBox(height: 15),
            Text('No User Found!', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 20),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                fixedSize: const Size(200, 50),
                textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
              ),
              onPressed: ()=> NextScreen.replace(context, const IntroScreen()),
              child: const Text('login').tr(),
            )
          ],
        ),
      ),
    );
  }
}