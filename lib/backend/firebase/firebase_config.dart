import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDKHyXfWgktqZul8IKdn7gtl9GEas3n47g",
            authDomain: "meditabk2020.firebaseapp.com",
            projectId: "meditabk2020",
            storageBucket: "meditabk2020.appspot.com",
            messagingSenderId: "12988405371",
            appId: "1:12988405371:web:b8d80bb06af10209d3b4de",
            measurementId: "G-WF641V682X"));
  } else {
    await Firebase.initializeApp();
  }
}
