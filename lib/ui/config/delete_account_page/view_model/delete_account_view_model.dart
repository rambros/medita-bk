import 'package:flutter/material.dart';
import '../../../../routing/nav.dart';
import '/data/repositories/auth_repository.dart';
import '/ui/authentication/social_login/social_login_page.dart';

class DeleteAccountViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  DeleteAccountViewModel({required AuthRepository authRepository}) : _authRepository = authRepository;

  Future<void> deleteAccount(BuildContext context) async {
    await _authRepository.deleteUser(context);

    if (context.mounted) {
      GoRouter.of(context).prepareAuthEvent();
      await _authRepository.signOut();

      if (context.mounted) {
        GoRouter.of(context).clearRedirectLocation();
        context.pushNamedAuth(SocialLoginPage.routeName, context.mounted);
      }
    }
  }
}
