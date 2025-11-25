import 'package:in_app_review/in_app_review.dart';

/// Service for managing app reviews and ratings
class ReviewService {
  static final ReviewService _instance = ReviewService._internal();
  factory ReviewService() => _instance;

  ReviewService._internal();

  final InAppReview _inAppReview = InAppReview.instance;

  /// Request in-app review
  ///
  /// Shows the native in-app review dialog if available.
  /// The system decides when to show the dialog based on quotas.
  Future<void> requestInAppReview() async {
    if (await _inAppReview.isAvailable()) {
      await _inAppReview.requestReview();
    }
  }

  /// Open app store listing
  ///
  /// Opens the app's page in the App Store or Play Store.
  /// [appStoreId] - Optional App Store ID (iOS only)
  Future<void> openStoreListing({String appStoreId = '1524154748'}) async {
    await _inAppReview.openStoreListing(appStoreId: appStoreId);
  }
}
