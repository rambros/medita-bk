import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

const _defaultAuthDomain = 'meditabk2020.firebaseapp.com';
const _defaultProjectId = 'meditabk2020';
const _defaultStorageBucket = 'meditabk2020.appspot.com';
const _defaultMessagingSenderId = '12988405371';
const _defaultAppId = '1:12988405371:web:b8d80bb06af10209d3b4de';
const _defaultMeasurementId = 'G-WF641V682X';

Future initFirebase() async {
  if (kIsWeb) {
    const firebaseApiKey =
        String.fromEnvironment('FIREBASE_WEB_API_KEY', defaultValue: '');
    if (firebaseApiKey.isEmpty) {
      throw StateError(
          'FIREBASE_WEB_API_KEY is not set. Provide it via --dart-define for web builds.');
    }

    const authDomain = String.fromEnvironment('FIREBASE_AUTH_DOMAIN',
        defaultValue: _defaultAuthDomain);
    const projectId = String.fromEnvironment('FIREBASE_PROJECT_ID',
        defaultValue: _defaultProjectId);
    const storageBucket = String.fromEnvironment('FIREBASE_STORAGE_BUCKET',
        defaultValue: _defaultStorageBucket);
    const messagingSenderId = String.fromEnvironment(
        'FIREBASE_MESSAGING_SENDER_ID',
        defaultValue: _defaultMessagingSenderId);
    const appId = String.fromEnvironment('FIREBASE_APP_ID',
        defaultValue: _defaultAppId);
    const measurementId = String.fromEnvironment('FIREBASE_MEASUREMENT_ID',
        defaultValue: _defaultMeasurementId);

    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: firebaseApiKey,
            authDomain: authDomain,
            projectId: projectId,
            storageBucket: storageBucket,
            messagingSenderId: messagingSenderId,
            appId: appId,
            measurementId: measurementId));
  } else {
    await Firebase.initializeApp();
  }
}
