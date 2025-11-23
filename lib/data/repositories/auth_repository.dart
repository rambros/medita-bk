import 'package:flutter/material.dart';
import '/auth/firebase_auth/auth_util.dart';

class AuthRepository {
  Future<void> signOut() async {
    await authManager.signOut();
  }

  Future<void> deleteUser(BuildContext context) async {
    await authManager.deleteUser(context);
  }
}
