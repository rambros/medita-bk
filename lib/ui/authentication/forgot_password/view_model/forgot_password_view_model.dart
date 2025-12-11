import 'package:flutter/material.dart';
import 'package:medita_bk/data/repositories/auth_repository.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  ForgotPasswordViewModel(this._authRepository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> resetPassword(BuildContext context, String email) async {
    if (email.isEmpty) {
      _errorMessage = 'Email is required';
      notifyListeners();
      return;
    }
    _setLoading(true);
    try {
      await _authRepository.resetPassword(context, email);
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
