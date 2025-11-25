import 'package:flutter/material.dart';

import '/data/services/auth/base_auth_user_provider.dart';
import '/data/services/auth/firebase_auth/auth_util.dart';
import '/data/services/auth/firebase_auth/firebase_auth_manager.dart';

/// Service layer wrapping FirebaseAuthManager to keep UI/ViewModels isolated
/// from Firebase/AuthManager implementation details.
class FirebaseAuthService {
  FirebaseAuthService({FirebaseAuthManager? manager})
      : _manager = manager ?? authManager;

  final FirebaseAuthManager _manager;

  Future<BaseAuthUser?> signInWithEmail(
    BuildContext context,
    String email,
    String password,
  ) =>
      _manager.signInWithEmail(context, email, password);

  Future<BaseAuthUser?> createAccountWithEmail(
    BuildContext context,
    String email,
    String password,
  ) =>
      _manager.createAccountWithEmail(context, email, password);

  Future<BaseAuthUser?> signInAnonymously(BuildContext context) =>
      _manager.signInAnonymously(context);

  Future<BaseAuthUser?> signInWithGoogle(BuildContext context) =>
      _manager.signInWithGoogle(context);

  Future<BaseAuthUser?> signInWithApple(BuildContext context) =>
      _manager.signInWithApple(context);

  Future<void> resetPassword(BuildContext context, String email) =>
      _manager.resetPassword(email: email, context: context);

  Future<void> updateEmail(BuildContext context, String email) =>
      _manager.updateEmail(email: email, context: context);

  Future<void> signOut() => _manager.signOut();

  Future<void> deleteUser(BuildContext context) =>
      _manager.deleteUser(context);
}
