import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCylW2umb3tX8v5UNuiJylF4LpuqJbY3NY",
            authDomain: "vojo-aa6b9.firebaseapp.com",
            projectId: "vojo-aa6b9",
            storageBucket: "vojo-aa6b9.appspot.com",
            messagingSenderId: "99212812249",
            appId: "1:99212812249:web:58f052ac462aa8c05903c8"));
  } else {
    await Firebase.initializeApp();
  }
}
