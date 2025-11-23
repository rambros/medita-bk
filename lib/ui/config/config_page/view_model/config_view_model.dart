import 'package:flutter/material.dart';
import '/data/repositories/auth_repository.dart';

class ConfigViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  ConfigViewModel({required AuthRepository authRepository}) : _authRepository = authRepository;

  Future<void> signOut() async {
    await _authRepository.signOut();
  }
}
