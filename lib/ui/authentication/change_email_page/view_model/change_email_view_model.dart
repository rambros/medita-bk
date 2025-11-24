import 'package:flutter/material.dart';
import '/data/repositories/auth_repository.dart';

class ChangeEmailViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  ChangeEmailViewModel(this._authRepository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> updateEmail(BuildContext context, String email) async {
    if (email.isEmpty) {
      _errorMessage = 'Email is required';
      notifyListeners();
      return;
    }
    _setLoading(true);
    try {
      await _authRepository.updateEmail(context, email);
      if (context.mounted) {
        Navigator.pop(context);
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
