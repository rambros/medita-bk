import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../models/purchase_history.dart';
import '../models/subscription.dart';
import '../models/user_model.dart';
import '../providers/user_data_provider.dart';
import '../services/firebase_service.dart';

mixin IAPMixin {
  handleProvideReward({
    required PurchaseDetails purchaseDetails,
    required WidgetRef ref,
    required List<ProductDetails> products,
  }) async {
    final user = ref.read(userDataProvider)!;
    final ProductDetails product = products.firstWhere((element) => element.id == purchaseDetails.productID);

    if (user.subscription != null && _hasAlreadyPurchased(purchaseDetails, user) && !_isExpired(user)) {
      debugPrint('already purchased');
    } else {
      debugPrint('updating database');
      await FirebaseService().updateSubscription(user, _subscriptionData(purchaseDetails, product));
      await FirebaseService().savePurchaseHistory(user, _historyData(user, purchaseDetails, product));
      await FirebaseService().updatePurchaseStats();
      await ref.read(userDataProvider.notifier).getData();
    }
  }

  bool hasSubscribed(ProductDetails product, UserModel? user) {
    if (user == null || user.subscription == null) {
      return false;
    } else {
      if (user.subscription!.productId == product.id && !_isExpired(user)) {
        return true;
      } else {
        return false;
      }
    }
  }

  static bool _isExpired(UserModel user) {
    final DateTime expireDate = user.subscription!.expireAt;
    final DateTime now = DateTime.now().toUtc();
    final difference = expireDate.difference(now).inDays;
    if (difference >= 0) {
      return false;
    } else {
      return true;
    }
  }

  static bool _hasAlreadyPurchased(PurchaseDetails purchase, UserModel user) {
    if (user.subscription!.productId == purchase.productID) {
      return true;
    } else {
      return false;
    }
  }

  Subscription _subscriptionData(PurchaseDetails purchaseDetails, ProductDetails product) {
    final purchaseAt = DateTime.fromMillisecondsSinceEpoch(int.parse(purchaseDetails.transactionDate.toString()));
    final expireAt = purchaseAt.add(Duration(days: getExpirePeriodAsDays(purchaseDetails.productID)));

    final Subscription subscription =
        Subscription(plan: product.title, purchaseAt: purchaseAt, expireAt: expireAt, productId: purchaseDetails.productID);
    return subscription;
  }

  PurchaseHistory _historyData(UserModel user, PurchaseDetails purchaseDetails, ProductDetails product) {
    final purchaseAt = DateTime.fromMillisecondsSinceEpoch(int.parse(purchaseDetails.transactionDate.toString()));
    final expireAt = purchaseAt.add(Duration(days: getExpirePeriodAsDays(purchaseDetails.productID)));
    final String id = DateTime.now().microsecondsSinceEpoch.toString();
    final String platform = Platform.isIOS ? 'iOS' : 'Android';

    final PurchaseHistory history = PurchaseHistory(
      id: id,
      plan: product.title,
      purchaseAt: purchaseAt,
      expireAt: expireAt,
      userId: user.id,
      userName: user.name,
      userEmail: user.email,
      price: product.price,
      purchaseId: purchaseDetails.purchaseID,
      platform: platform,
    );

    return history;
  }

  static int getExpirePeriodAsDays(String productId) {
    final String formattedString = productId.replaceAll(RegExp(r'[^0-9]'), '');
    return int.parse(formattedString.trim());
  }

  String getProductTitle(String title) {
    if (Platform.isAndroid) {
      final RegExp regExp = RegExp(r'\([^()]*\)');
      String result = title.replaceFirst(regExp, '');
      return result.trim();
    } else {
      return title;
    }
  }
}
