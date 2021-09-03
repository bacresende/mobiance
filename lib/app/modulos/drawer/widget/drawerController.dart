import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DrawerTileController extends GetxController {
  final controllers = PageController();
  GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> logout() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    
    bool logadoNoGoogle = await googleSignIn.isSignedIn();
    await auth.signOut();
    if (logadoNoGoogle) {
      await googleSignIn.signOut();
    }
  }
}
