import 'dart:async';

import 'package:flutter/material.dart';
import 'package:medita_b_k/data/models/firebase/user_model.dart';
import 'package:medita_b_k/data/repositories/auth_repository.dart';
import 'package:medita_b_k/data/repositories/user_repository.dart';

class ConfigViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  ConfigViewModel({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository;

  StreamSubscription<UserModel?>? _userSub;
  UserModel? _user;
  UserModel? get user => _user;

  String get displayName => _user?.fullName ?? '';
  String get email => _authRepository.currentUserEmail;
  String get photoUrl => _user?.userImageUrl ?? '';

  void init() {
    final currentUserId = _authRepository.currentUserUid;

    if (currentUserId.isNotEmpty) {
      // Stream user data
      _userSub ??= _userRepository.streamUser(currentUserId).listen((user) {
        _user = user;
        notifyListeners();
      });
    }
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
