import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lms_app/ads/interstitial_ads.dart';
import 'package:lms_app/mixins/user_mixin.dart';
import '../providers/app_settings_provider.dart';
import '../providers/user_data_provider.dart';

class AdManager {
  static Future initAds(WidgetRef ref) async {
    final settings = ref.read(appSettingsProvider);
    final user = ref.read(userDataProvider);

    if (settings?.ads?.isAdsEnabled == true && UserMixin.isUserPremium(user)) {
      await MobileAds.instance.initialize();
      debugPrint('Initialized ads');
    }
  }

  static bool isBannerEnbaled(WidgetRef ref) {
    final settings = ref.read(appSettingsProvider);
    final user = ref.read(userDataProvider);

    if (settings?.ads?.isAdsEnabled == true && settings?.ads?.bannerEnbaled == true && !UserMixin.isUserPremium(user)) {
      return true;
    } else {
      return false;
    }
  }

  static initInterstitailAds(WidgetRef ref) async {
    final settings = ref.read(appSettingsProvider);
    final user = ref.read(userDataProvider);

    if (settings?.ads?.isAdsEnabled == true && settings?.ads?.interstitialEnabled == true && !UserMixin.isUserPremium(user)) {
      if (ref.read(interstitalAdProvider).isInterstitalAdLoaded) {
        ref.read(interstitalAdProvider).showInterstitialAd();
      } else {
        ref.read(interstitalAdProvider).createInterstitialAd();
      }
    } else {
      debugPrint(' interstitial ads disbaled');
    }
  }
}
