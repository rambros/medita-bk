import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../configs/ad_config.dart';

final interstitalAdProvider = ChangeNotifierProvider((ref) => InterstitialAds());

class InterstitialAds extends ChangeNotifier {
  bool isInterstitalAdLoaded = false;

  InterstitialAd? _interstitialAd;

  void createInterstitialAd() async{
    await InterstitialAd.load(
        adUnitId: AdConfig.getInterstitialAdUnitId(),
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            debugPrint('$ad loaded');
            _interstitialAd = ad;
            isInterstitalAdLoaded = true;
            notifyListeners();
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error.');
            _interstitialAd = null;
            isInterstitalAdLoaded = false;
            notifyListeners();

            // Load ad when failed to load
            // createInterstitialAd();
          },
        ));
  }

  void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) => debugPrint('ad onAdShowedFullScreenContent.'),
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          debugPrint('$ad onAdDismissedFullScreenContent.');
          ad.dispose();
          _interstitialAd = null;
          isInterstitalAdLoaded = false;
          notifyListeners();
          // Loaded ad when dismissed by user
          createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
          ad.dispose();
          _interstitialAd = null;
          isInterstitalAdLoaded = false;
          notifyListeners();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
      notifyListeners();
    }
  }

  

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }
}
