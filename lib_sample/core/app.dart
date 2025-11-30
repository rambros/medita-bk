import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/configs/app_config.dart';
import 'package:lms_app/screens/splash.dart';
import 'package:lms_app/theme/dark_theme.dart';
import 'package:lms_app/theme/light_theme.dart';
import 'package:lms_app/theme/theme_provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;
final FirebaseAnalyticsObserver firebaseObserver =  FirebaseAnalyticsObserver(analytics: firebaseAnalytics);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeRef = ref.watch(themeProvider);
    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      navigatorObservers: [firebaseObserver],
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      locale: context.locale,
      themeMode: themeRef.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const SplashScreen(),
    );
  }
}
