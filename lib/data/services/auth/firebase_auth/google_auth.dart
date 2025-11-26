import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

final _googleSignIn = GoogleSignIn.instance;
var _googleInitialized = false;

Future<UserCredential?> googleSignInFunc() async {
  if (kIsWeb) {
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
  }

  await signOutWithGoogle().catchError((_) => null);
  await _ensureInitialized();
  try {
    final account = await _googleSignIn.authenticate(scopeHint: const ['profile', 'email']);
    final authz = await account.authorizationClient.authorizeScopes(const ['profile', 'email']);
    final authTokens = account.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: authTokens.idToken,
      accessToken: authz.accessToken,
    );
    return FirebaseAuth.instance.signInWithCredential(credential);
  } on GoogleSignInException {
    return null;
  }
}

Future<void> _ensureInitialized() async {
  if (_googleInitialized) return;
  await _googleSignIn.initialize();
  _googleInitialized = true;
}

Future signOutWithGoogle() => _googleInitialized ? _googleSignIn.signOut() : Future.value();
