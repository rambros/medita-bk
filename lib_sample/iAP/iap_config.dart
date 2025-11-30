import 'dart:io';


// Subscription Ids for Android and iOS. You can use same ids for android & iOS if you want.

class IAPConfig {

  // Enable/disable Subscription
  static const bool iAPEnabled = false;

  //subscription product ids for android (Google Play Store)
  static const List<String> kProductIdsAndroid = <String>[
    'weekly_7',
    'monthly_30',
    'yearly_365',
  ];
  

  // subscription product ids for iOS (Apple Appstore)
  static const List<String> kProductIdsiOS = <String>[
    'weekly_7',
    'monthly_30',
    'yearly_365',
  ];



  // -- Dont edit this --
  static List<String> kProductIds() {
    if (Platform.isAndroid) {
      return kProductIdsAndroid;
    } else if (Platform.isIOS) {
      return kProductIdsiOS;
    } else {
      return [];
    }
  }
}
