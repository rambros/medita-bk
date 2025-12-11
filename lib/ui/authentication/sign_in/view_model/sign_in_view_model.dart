import 'package:flutter/material.dart';
import 'package:medita_bk/data/repositories/auth_repository.dart';
import 'package:medita_bk/routing/nav.dart';
import 'package:medita_bk/ui/home/home_page/home_page.dart';

class SignInViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  SignInViewModel(this._authRepository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Text Controllers are usually managed by the Widget in Flutter,
  // but can be here if we want to keep the Widget purely dumb.
  // For now, I'll keep them in the Widget to avoid passing Context for validation
  // or complex binding, but I'll expose methods to handle the actions.

  Future<void> signInWithEmail(BuildContext context, String email, String password) async {
    _setLoading(true);
    try {
      GoRouter.of(context).prepareAuthEvent();
      final user = await _authRepository.signInWithEmail(context, email, password);
      if (user != null) {
        if (context.mounted) {
          context.goNamedAuth(HomePage.routeName, context.mounted);
        }
      }
    } catch (e) {
      // Error handling is mostly done in AuthManager (showing snackbars),
      // but we can catch unexpected errors here.
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInAnonymously(BuildContext context) async {
    _setLoading(true);
    try {
      GoRouter.of(context).prepareAuthEvent();
      final user = await _authRepository.signInAnonymously(context);
      if (user != null) {
        if (context.mounted) {
          context.goNamedAuth(HomePage.routeName, context.mounted);
        }
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
