import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/data/services/auth/base_auth_user_provider.dart';
import '/data/services/auth/firebase_auth/firebase_auth_service.dart';
import '/data/services/auth/firebase_auth/auth_util.dart' as auth_util;
import '/data/models/firebase/user_model.dart';
import '/data/services/firebase/firestore_service.dart';

class AuthRepository {
  AuthRepository({required FirebaseAuthService authService, FirestoreService? firestoreService})
      : _authService = authService,
        _firestoreService = firestoreService ?? FirestoreService();

  final FirebaseAuthService _authService;
  final FirestoreService _firestoreService;

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
  UserModel? get currentUser => _currentUserModel;
  String get currentUserEmail => auth_util.currentUserEmail;
  String get currentUserUid => auth_util.currentUserUid;
  DocumentReference? get currentUserRef => auth_util.currentUserReference;

  UserModel? _currentUserModel;

  /// Stream of the authenticated user document.
  Stream<UserModel?> authUserStream() {
    final uid = currentUserUid;
    if (uid.isEmpty) return Stream.value(null);
    return _firestoreService.streamDocument(
      collectionPath: 'users',
      documentId: uid,
      fromSnapshot: UserModel.fromFirestore,
    );
  }

  /// Refresh the cached current user model.
  Future<void> refreshCurrentUser() async {
    final uid = currentUserUid;
    if (uid.isEmpty) {
      _currentUserModel = null;
      return;
    }
    _currentUserModel = await _firestoreService.getDocument(
      collectionPath: 'users',
      documentId: uid,
      fromSnapshot: UserModel.fromFirestore,
    );
  }
}
