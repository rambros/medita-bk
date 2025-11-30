import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../configs/app_assets.dart';

class IAPTopSection extends StatelessWidget {
  const IAPTopSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).primaryColor,
            child: Image.asset(premiumImage, height: 50, width: 50),
          ),
          const SizedBox(height: 20),
          Text(
            'iap-title',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
          ).tr(),
          const SizedBox(height: 10),
          Text(
            'iap-subtitle',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.blueGrey, fontSize: 18),
          ).tr()
        ],
      ),
    );
  }
}