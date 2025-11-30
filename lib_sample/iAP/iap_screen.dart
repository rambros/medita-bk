import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:lms_app/iAP/iap_mixin.dart';
import 'package:lms_app/iAP/product_tile.dart';
import 'package:lms_app/iAP/top_section.dart';
import 'package:lms_app/models/user_model.dart';
import 'package:lms_app/utils/loading_widget.dart';
import 'package:lms_app/utils/toasts.dart';
import '../providers/user_data_provider.dart';
import 'example_delegate_ios.dart';
import 'iap_config.dart';

class IAPScreen extends ConsumerStatefulWidget {
  const IAPScreen({super.key});

  @override
  ConsumerState<IAPScreen> createState() => _IAPScreen2State();
}

class _IAPScreen2State extends ConsumerState<IAPScreen> with IAPMixin {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails> _products = <ProductDetails>[];
  // ignore: prefer_final_fields
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;

  @override
  void initState() {
    _initIAP();
    _initStoreInfo();
    super.initState();
  }

  _initIAP() {
    final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {
      debugPrint(error.toString());
    });
  }

  Future<void> _initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (isAvailable) {
      final ProductDetailsResponse productDetailResponse = await _inAppPurchase.queryProductDetails(IAPConfig.kProductIds().toSet());
      if (productDetailResponse.error == null && productDetailResponse.productDetails.isNotEmpty) {
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _products.sort((a, b) => a.rawPrice.compareTo(b.rawPrice));
        _purchasePending = false;
        _loading = false;
        setState(() {});
      } else {
        _loading = false;
        setState(() {});
      }
    } else {
      setState(() {
        _isAvailable = false;
        _loading = false;
      });
    }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition = _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }
  }

  Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      debugPrint(purchaseDetails.status.toString());

      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          setState(() {
            _loading = false;
            _purchasePending = false;
          });
        } else if (purchaseDetails.status == PurchaseStatus.restored) {
          debugPrint('restored');
          final bool valid = _verifyPurchase(purchaseDetails);
          if (valid) {
            unawaited(deliverProduct(purchaseDetails));
          }
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          final bool valid = _verifyPurchase(purchaseDetails);
          if (valid) {
            unawaited(deliverProduct(purchaseDetails));
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  void _onDispose() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition = _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
  }

  Future makePurchase(ProductDetails productDetails, purchases) async {
    showPendingUI();
    late PurchaseParam purchaseParam;

    if (Platform.isAndroid) {
      final GooglePlayPurchaseDetails? oldSubscription = _getOldSubscription(productDetails, purchases);

      purchaseParam = GooglePlayPurchaseParam(
        productDetails: productDetails,
        changeSubscriptionParam: (oldSubscription != null)
            ? ChangeSubscriptionParam(oldPurchaseDetails: oldSubscription, replacementMode: ReplacementMode.withTimeProration)
            : null,
      );
    } else {
      purchaseParam = PurchaseParam(productDetails: productDetails);
    }

    if (Platform.isIOS) {
      var transactions = await SKPaymentQueueWrapper().transactions();
      transactions.forEach((skPaymentTransactionWrapper) {
        SKPaymentQueueWrapper().finishTransaction(skPaymentTransactionWrapper);
      });
    }

    try {
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } on PlatformException catch (e) {
      setState(() {
        _purchasePending = false;
        _loading = false;
      });
      openToast('Error on purchasing subscription: $e');
    }
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    await handleProvideReward(purchaseDetails: purchaseDetails, ref: ref, products: _products);
    setState(() {
      _purchases.add(purchaseDetails);
      _purchasePending = false;
    });
  }

  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
    });
  }

  bool _verifyPurchase(PurchaseDetails purchaseDetails) {
    if (purchaseDetails.transactionDate != null && IAPConfig.kProductIds().contains(purchaseDetails.productID)) {
      final purchasedAt = DateTime.fromMillisecondsSinceEpoch(int.parse(purchaseDetails.transactionDate.toString()));
      final int durationInDays = IAPMixin.getExpirePeriodAsDays(purchaseDetails.productID);
      final expireDate = purchasedAt.add(Duration(days: durationInDays));
      final now = DateTime.now().toUtc();
      final int difference = expireDate.difference(now).inDays;
      if (difference >= 0) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    debugPrint('Invalid Status: ${purchaseDetails.status}');
  }

  void _handleRestorePurchase() async {
    setState(() {
      _purchasePending = true;
    });
    await _inAppPurchase.restorePurchases();
    setState(() {
      _purchasePending = false;
    });
  }

  GooglePlayPurchaseDetails? _getOldSubscription(ProductDetails productDetails, Map<String, PurchaseDetails> purchases) {
    GooglePlayPurchaseDetails? oldSubscription;
    return oldSubscription;
  }

  @override
  void dispose() {
    _onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? user = ref.watch(userDataProvider);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 50),
            child: Column(
              children: [
                const IAPTopSection(),
                const SizedBox(height: 20),
                _buildProductList(user),
              ],
            ),
          ),
        ),
        _loadingPurchaseTile(context),
        _loadingModalBarrier(context),
      ],
    );
  }

  Visibility _loadingModalBarrier(BuildContext context) {
    return Visibility(
      visible: _purchasePending,
      child: Opacity(
        opacity: 0.3,
        child: ModalBarrier(
          dismissible: false,
          color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Visibility _loadingPurchaseTile(BuildContext context) {
    return Visibility(
      visible: _purchasePending,
      child: Align(
          alignment: Alignment.center,
          child: Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(8)),
            child: const LoadingIndicatorWidget(color: Colors.white),
          )),
    );
  }

  Widget _buildProductList(UserModel? user) {
    if (_loading) {
      return const Center(child: LoadingIndicatorWidget());
    }
    if (!_isAvailable) {
      return const Center(
        child: Text('IAP is not avaibale for this device'),
      );
    }
    final Map<String, PurchaseDetails> purchases = Map<String, PurchaseDetails>.fromEntries(_purchases.map((PurchaseDetails purchase) {
      if (purchase.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchase);
      }
      return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
    }));

    return Column(
      children: [
        Column(
          children: _products.map((productDetails) {
            return ProductTile(productDetails: productDetails, purchases: purchases, makePurchase: makePurchase, user: user);
          }).toList(),
        ),
        TextButton(
          child: const Text('restore-purchase').tr(),
          onPressed: () => _handleRestorePurchase(),
        )
      ],
    );
  }
}
