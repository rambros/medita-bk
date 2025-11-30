import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:lms_app/iAP/iap_mixin.dart';

import '../mixins/user_mixin.dart';
import '../models/user_model.dart';

class ProductTile extends StatelessWidget with IAPMixin {
  const ProductTile({
    super.key,
    required this.productDetails,
    required this.purchases,
    required this.user,
    required this.makePurchase,
  });

  final ProductDetails productDetails;
  final Map<String, PurchaseDetails> purchases;
  final UserModel? user;
  final Function makePurchase;

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final bool _hasSubscribed = hasSubscribed(productDetails, user);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(border: Border.all(color: Colors.blueGrey, width: 0.5), borderRadius: BorderRadius.circular(5)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        isThreeLine: true,
        title: Text(
          getProductTitle(productDetails.title),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 10),
              child: Text(
                productDetails.description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.blueGrey),
              ),
            ),
            TextButton(
              onPressed: _hasSubscribed ? null : () => makePurchase(productDetails, purchases),
              style: TextButton.styleFrom(
                  elevation: 0,
                  disabledBackgroundColor: Theme.of(context).disabledColor,
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
              child: const Text('subscribe').tr(),
            ),
            !_hasSubscribed
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.done_all,
                          color: Colors.green,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Text('subscribed').tr(),
                        const SizedBox(width: 10),
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.titleSmall,
                            children: [
                            const TextSpan(text: '('),
                            TextSpan(text: UserMixin.isExpired(user!) ? 'expired'.tr() : 'active'.tr()),
                            const TextSpan(text: ')'),
                          ]),
                        )
                      ],
                    ),
                  ),
          ],
        ),
        trailing: Text(
          productDetails.price,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.green, fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
    );
  }
}
