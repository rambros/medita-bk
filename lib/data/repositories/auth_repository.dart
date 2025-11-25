import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/users_record.dart';
import '/data/services/auth/base_auth_user_provider.dart';
import '/data/services/auth/firebase_auth/firebase_auth_service.dart';
import '/data/services/auth/firebase_auth/auth_util.dart' as auth_util;

class AuthRepository {
  AuthRepository({required FirebaseAuthService authService})
      : _authService = authService;

  final FirebaseAuthService _authService;

  Future<BaseAuthUser?> signInWithEmail(
    BuildContext context,
    String email,
    String password,
  ) async {
    return await _authService.signInWithEmail(context, email, password);
  }

  Future<BaseAuthUser?> createAccountWithEmail(
    BuildContext context,
    String email,
    String password,
  ) async {
    return await _authService.createAccountWithEmail(context, email, password);
  }

  Future<BaseAuthUser?> signInAnonymously(BuildContext context) async {
    return await _authService.signInAnonymously(context);
  }

  Future<BaseAuthUser?> signInWithGoogle(BuildContext context) async {
    return await _authService.signInWithGoogle(context);
  }

  Future<BaseAuthUser?> signInWithApple(BuildContext context) async {
    return await _authService.signInWithApple(context);
  }

  Future<void> resetPassword(BuildContext context, String email) async {
    await _authService.resetPassword(context, email);
  }

  Future<void> updateEmail(BuildContext context, String email) async {
    await _authService.updateEmail(context, email);
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<void> deleteUser(BuildContext context) async {
    await _authService.deleteUser(context);
  }

  /// Current user helpers (sourced from auth_util).
  UsersRecord? get currentUser => auth_util.currentUserDocument;
  String get currentUserEmail => auth_util.currentUserEmail;
  String get currentUserUid => auth_util.currentUserUid;
  DocumentReference? get currentUserRef => auth_util.currentUserReference;

  /// Stream of the authenticated user document.
  Stream<UsersRecord?> authUserStream() => auth_util.authenticatedUserStream;
}
