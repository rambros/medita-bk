import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lms_app/configs/app_assets.dart';
import 'package:lms_app/configs/features_config.dart';
import 'package:lms_app/components/languages.dart';
import 'package:lms_app/screens/auth/login.dart';
import 'package:lms_app/screens/splash.dart';
import 'package:lms_app/services/sp_service.dart';
import 'package:lms_app/utils/next_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../providers/app_settings_provider.dart';

final introPageController = Provider.autoDispose((ref) => PageController(initialPage: 0));

class IntroScreen extends ConsumerWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(introPageController);
    final settings = ref.watch(appSettingsProvider);
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
          child: TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.w600)),
            child: const Text('get-started').tr(),
            onPressed: () => NextScreen.openBottomSheet(context, const LoginScreen()),
          ),
        ),
      ),
      appBar: AppBar(
        actions: [
          Visibility(
            visible: settings?.skipLogin != null && settings!.skipLogin == true,
            child: TextButton(
              child: const Text('skip').tr(),
              onPressed: () => _onSkipPressed(context),
            ),
          ),
          Visibility(
            visible: isMultilanguageEnbled,
            child: IconButton(
              padding: const EdgeInsets.only(right: 10),
              icon: const Icon(LineIcons.language),
              onPressed: () => NextScreen.openBottomSheet(context, const Languages()),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: controller,
              children: const [
                IntroView(image: introImage1, title: 'intro-title1'),
                IntroView(image: introImage2, title: 'intro-title2'),
                IntroView(image: introImage3, title: 'intro-title3'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: SmoothPageIndicator(
              controller: controller,
              count: 3,
            ),
          )
        ],
      ),
    );
  }

  void _onSkipPressed(BuildContext context) async {
    await SPService().setGuestUser().then((value) {
      if (!context.mounted) return;
      NextScreen.replaceAnimation(context, const SplashScreen());
    });
  }
}

class IntroView extends StatelessWidget {
  const IntroView({super.key, required this.image, required this.title});

  final String image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 5,
          child: SvgPicture.asset(image),
        ),
        Flexible(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Text(title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 25, fontWeight: FontWeight.w600, wordSpacing: 3))
                .tr(),
          ),
        ),
      ],
    );
  }
}


// righteous
// adamina
// comforta