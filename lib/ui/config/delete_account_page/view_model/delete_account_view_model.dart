import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/flutter_flow/nav/nav.dart';
import '/data/repositories/auth_repository.dart';
import '/modules/authentication/sociall_login/sociall_login_widget.dart';

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
        context.pushNamedAuth(SociallLoginWidget.routeName, context.mounted);
      }
    }
  }
}
