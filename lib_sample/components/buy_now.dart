import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:lms_app/services/app_service.dart';

class BuyNowTile extends StatelessWidget {
  const BuyNowTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).primaryColor),
      child: ListTile(
        leading: const Icon(
          FeatherIcons.shoppingCart,
          color: Colors.white,
        ),
        title: Text('buy-app-title', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)).tr(),
        subtitle: const Text(
          'buy-app-subtitle',
          style: TextStyle(color: Colors.white70),
        ).tr(),
        horizontalTitleGap: 20,
        trailing: const Icon(FeatherIcons.chevronRight, color: Colors.white),
        onTap: () => AppService().openLinkWithCustomTab('https://codecanyon.net/user/mrblab/portfolio'),
      ),
    );
  }
}
