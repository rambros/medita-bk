import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lms_app/screens/home/home_bottom_bar.dart';
import 'package:lms_app/screens/home/home_view.dart';
import 'package:lms_app/utils/next_screen.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import '../../providers/user_data_provider.dart';
import '../../services/auth_service.dart';
import '../../services/firebase_service.dart';
import '../../services/sp_service.dart';
import '../intro.dart';

class DeleteAccount extends StatelessWidget {
  const DeleteAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'account-control',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ).tr(),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.blueGrey), borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: const Icon(LineIcons.removeUser),
          title: const Text('delete-account').tr(),
          trailing: const Icon(FeatherIcons.chevronRight),
          onTap: () => NextScreen.openBottomSheet(context, const _DeleteDialog(), maxHeight: 0.80),
        ),
      ),
    );
  }
}

class _DeleteDialog extends ConsumerWidget {
  const _DeleteDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = RoundedLoadingButtonController();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
      ),
      bottomNavigationBar: BottomAppBar(
        child: RoundedLoadingButton(
          controller: controller,
          animateOnTap: false,
          elevation: 0,
          color: Theme.of(context).primaryColor,
          child: Text(
            'account-delete-confirm',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ).tr(),
          onPressed: () => _handleDeleteAccount(context, ref, controller),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Text(
              'account-delete-title',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ).tr(),
            const SizedBox(height: 20),
            Text(
              'account-delete-subtitle',
              style: Theme.of(context).textTheme.titleMedium,
            ).tr()
          ],
        ),
      ),
    );
  }

  void _handleDeleteAccount(context, WidgetRef ref, RoundedLoadingButtonController controller) async {
    controller.start();
    final user = ref.read(userDataProvider);
    await FirebaseService().deleteUserDatafromDatabase(user!.id);
    await AuthService().deleteUserAuth();
    await AuthService().googleLogout();
    await AuthService().userLogOut();
    await SPService().clearLocalData();
    ref.invalidate(userDataProvider);
    ref.invalidate(homeTabControllerProvider);
    ref.invalidate(navBarIndexProvider);
    controller.success();
    NextScreen.closeOthersAnimation(context, const IntroScreen());
  }
}
