import 'package:flutter/material.dart';
import '/data/repositories/auth_repository.dart';
import '../../../../routing/nav.dart';
import '/ui/home/home_page/home_page.dart';

class SocialLoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  SocialLoginViewModel(this._authRepository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> signInWithGoogle(BuildContext context) async {
    _setLoading(true);
    try {
      GoRouter.of(context).prepareAuthEvent();
      final user = await _authRepository.signInWithGoogle(context);
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

  Future<void> signInWithApple(BuildContext context) async {
    _setLoading(true);
    try {
      GoRouter.of(context).prepareAuthEvent();
      final user = await _authRepository.signInWithApple(context);
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
