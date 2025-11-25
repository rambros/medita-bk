import 'dart:async';

import 'package:flutter/material.dart';
import '/backend/schema/users_record.dart';
import '/data/repositories/auth_repository.dart';

class ConfigViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  ConfigViewModel({required AuthRepository authRepository}) : _authRepository = authRepository;

  StreamSubscription<UsersRecord?>? _userSub;
  UsersRecord? _user;
  UsersRecord? get user => _user;

  String get displayName => _user?.fullName ?? '';
  String get email => _authRepository.currentUserEmail;
  String get photoUrl => _user?.userImageUrl ?? '';

  void init() {
    _user = _authRepository.currentUser;
    notifyListeners();
    _userSub ??= _authRepository.authUserStream().listen((u) {
      _user = u;
      notifyListeners();
    });
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }

  @override
  void dispose() {
    _userSub?.cancel();
    super.dispose();
  }
}
