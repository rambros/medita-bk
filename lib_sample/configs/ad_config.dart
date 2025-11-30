import 'dart:io';

class AdConfig {

  // Andriod
  static const String appIdAndroid = 'ca-app-pub-3940256099942544~3347511713';
  static const String interstitialAdUnitIdAndroid = 'ca-app-pub-3940256099942544/1033173712';
  static const String bannerAdUnitIdAndroid = 'ca-app-pub-3940256099942544/6300978111';

  // iOS
  static const String appIdiOS = 'ca-app-pub-3940256099942544~1458002511';
  static const String interstitialAdUnitIdiOS = 'ca-app-pub-3940256099942544/4411468910';
  static const String bannerAdUnitIdiOS = 'ca-app-pub-3940256099942544/2934735716';

  // -- Don't edit these --

  static String getAdmobAppId() {
    if (Platform.isAndroid) {
      return appIdAndroid;
    } else {
      return appIdiOS;
    }
  }

  static String getBannerAdUnitId() {
    if (Platform.isAndroid) {
      return bannerAdUnitIdAndroid;
    } else {
      return bannerAdUnitIdiOS;
    }
  }

  static String getInterstitialAdUnitId() {
    if (Platform.isAndroid) {
      return interstitialAdUnitIdAndroid;
    } else {
      return interstitialAdUnitIdiOS;
    }
  }
}
