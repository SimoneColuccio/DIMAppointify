import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:Appointfy/Pages/loggedInPage.dart';

FirebaseAuth auth = FirebaseAuth.instance;

Future<void> googleSignIn(context) async {
  final gooleSignIn = GoogleSignIn();
  final googleSignInAccount = await gooleSignIn.signIn();
  if (googleSignInAccount != null) {
    final googleAuth = await googleSignInAccount.authentication;
    if (googleAuth.accessToken != null && googleAuth.idToken != null) {
      try {
        await auth.signInWithCredential(GoogleAuthProvider.credential(
            idToken: googleAuth.idToken, accessToken: googleAuth.accessToken));
        // Navigator.of(context).pushReplacement(WelcomeScreen())
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen())
        );
        print("successfully login!");
      } catch (e) {
        print("failed login!");
      }
    }
  }
}

Future<void> signInWithMailAndPassword(String email, String password, VoidCallback onSuccess) async {
  try {
    await auth.signInWithEmailAndPassword(email: email, password: password);
    onSuccess();
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  }
}