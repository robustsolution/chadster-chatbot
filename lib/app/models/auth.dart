import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth extends GetxController {
  // 0C:26:43:0B:A5:AC:1B:5F:2D:CE:30:56:13:F5:0F:29:B1:BD:5A:10
  // SHA1: 0C:26:43:0B:A5:AC:1B:5F:2D:CE:30:56:13:F5:0F:29:B1:BD:5A:10
  User? currentUser;
  // bool isFirstVisit = false;

  // Future<void> setFirstVisit() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('firstVisit', true);
  //   log('visited');
  // }

  // Future<void> getFirstVisit() async {
  //   // Obtain shared preferences.
  //   final prefs = await SharedPreferences.getInstance();
  //   final bool? repeat = prefs.getBool('firstVisit');
  //   if (repeat == null) {
  //     isFirstVisit = false;
  //   } else {
  //     isFirstVisit = repeat;
  //   }
  //   update();
  // }

  Future<bool> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential response =
          await FirebaseAuth.instance.signInWithCredential(credential);
      currentUser = response.user!;

      if (currentUser != null) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      log(error.toString());
      return false;
    }
  }

  Future<bool> signInWithApple() async {
    try {
      final appleProvider = AppleAuthProvider();

      // Once signed in, return the UserCredential
      UserCredential response =
          await FirebaseAuth.instance.signInWithProvider(appleProvider);

      currentUser = response.user!;

      if (currentUser != null) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print(error.toString());
      return false;
    }
  }

  //----------------------------- annonymous ---------------------------//
  Future<bool> anonymousSignIn() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      currentUser = userCredential.user;
      print("Signed in with temporary account.");
      if (currentUser != null) {
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          log("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          log("Unknown error.");
      }
      return false;
    }
  }

  //------------------------facebook login-----------------------//
  Future<bool> signInWithFacebook() async {
    print(123);
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      log('success');
      // Create a credential from the access token
      final OAuthCredential credential =
          FacebookAuthProvider.credential(result.accessToken!.token);

      // Once signed in, return the UserCredential
      var response =
          await FirebaseAuth.instance.signInWithCredential(credential);
      currentUser = response.user;
      log('currentuser: ${currentUser!.displayName.toString()}');
      if (currentUser != null) {
        return true;
      } else {
        return false;
      }
    } else {
      log(result.message!);
      return false;
    }
  }

  Future<void> storeUserInfo(
      {required User user, required String method}) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    var exists = (await users.doc(user.uid).get()).exists;

    if (!exists) {
      users
          .doc(user.uid)
          .set({
            'name': user.displayName,
            'email': user.email,
            'loginMethod': method,
            'subscription': Timestamp.fromDate(DateTime(2000)),
          }, SetOptions(merge: true))
          .then((value) => print("User Added"))
          .catchError(
            (error) => print("Failed to add user: $error"),
          );
    }
  }

  //-----------------increment queries----------------
  Future<void> incrementAiQueryOnTaskView({required User user}) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    users
        .doc(user.uid)
        .update({'ai_queries': FieldValue.increment(1)}).catchError(
      (error) => print("Failed to add queires: $error"),
    );
  }
}
