import 'dart:async';

import 'package:flutter/material.dart';
import 'package:medita_bk/data/models/firebase/user_model.dart';
import 'package:medita_bk/data/repositories/auth_repository.dart';
import 'package:medita_bk/data/repositories/user_repository.dart';
import 'package:medita_bk/data/services/user_document_service.dart';

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

  String get displayName =>
      _user?.fullName.isNotEmpty == true
          ? _user!.fullName
          : _authRepository.currentUser?.displayName ?? '';

  String get email => _authRepository.currentUserEmail;

  String get photoUrl =>
      _user?.userImageUrl.isNotEmpty == true
          ? _user!.userImageUrl
          : _authRepository.currentUser?.photoUrl ?? '';

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
    // Limpa o cache de verificação de documentos antes de fazer logout
    UserDocumentService.clearCache();
    await _authRepository.signOut();
  }

  @override
  void dispose() {
    _userSub?.cancel();
    super.dispose();
  }
}
