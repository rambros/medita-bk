import 'package:flutter/material.dart';
import '/auth/firebase_auth/auth_util.dart';

class AuthRepository {
  Future<BaseAuthUser?> signInWithEmail(
    BuildContext context,
    String email,
    String password,
  ) async {
    return await authManager.signInWithEmail(context, email, password);
  }

  Future<BaseAuthUser?> createAccountWithEmail(
    BuildContext context,
    String email,
    String password,
  ) async {
    return await authManager.createAccountWithEmail(context, email, password);
  }

  Future<BaseAuthUser?> signInAnonymously(BuildContext context) async {
    return await authManager.signInAnonymously(context);
  }

  Future<BaseAuthUser?> signInWithGoogle(BuildContext context) async {
    return await authManager.signInWithGoogle(context);
  }

  Future<BaseAuthUser?> signInWithApple(BuildContext context) async {
    return await authManager.signInWithApple(context);
  }

  Future<void> resetPassword(BuildContext context, String email) async {
    await authManager.resetPassword(email: email, context: context);
  }

  Future<void> updateEmail(BuildContext context, String email) async {
    await authManager.updateEmail(email: email, context: context);
  }

  Future<void> signOut() async {
    await authManager.signOut();
  }

  Future<void> deleteUser(BuildContext context) async {
    await authManager.deleteUser(context);
  }
}
