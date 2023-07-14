
import 'package:aichatapp/app/routes/app_pages.dart';
import 'package:aichatapp/services/listen_changes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/auth.dart';

enum LoginMethod { google, anonymous, apple, facebook }

class LoginScreenController extends GetxController {
  bool isLoading = false;
  final authController = Get.put(Auth());
  int counter = 0;
  @override
  void onInit() async {
    // FirebaseAuth.instance.authStateChanges().listen((User? user) {
    //   if (user == null) {
    //     print('User is currently signed out!');
    //   } else {
    //     Get.toNamed(Routes.MAIN_DASHBOARD);
    //   }
    // });
    // setCounter();
    // await authController.getFirstVisit();
    // log('isvisited: ${authController.isFirstVisit}');
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  Future<bool> signIn({required LoginMethod method}) async {
    ChangesListener.to.justLoggedIn = true;

    final status = await AppTrackingTransparency.requestTrackingAuthorization();
    if (status == TrackingStatus.authorized) {
      await FacebookAuth.i.autoLogAppEventsEnabled(true);
      print(
          "isAutoLogAppEventsEnabled:: ${await FacebookAuth.i.isAutoLogAppEventsEnabled}");
    }

    if (method == LoginMethod.google) {
      isLoading = true;
      update();
      bool isLogin1 = await authController.signInWithGoogle();
      // log(Auht().currentUser!.phoneNumber.toString());
      if (isLogin1) {
        authController.storeUserInfo(
            user: FirebaseAuth.instance.currentUser!, method: 'Google');

        Get.toNamed(Routes.NOTIFICATION, arguments: true);
      } else {
        Get.showSnackbar(
          const GetSnackBar(
            title: 'Error: ',
            duration: Duration(seconds: 2),
            message: 'Something went wrong',
          ),
        );
      }
      isLoading = false;
      update();
      return isLogin1;
    } else if (method == LoginMethod.anonymous) {
      isLoading = true;
      update();
      bool isLogin = await authController.anonymousSignIn();
      // log(Auht().currentUser!.phoneNumber.toString());
      if (isLogin) {
        authController.storeUserInfo(
            user: FirebaseAuth.instance.currentUser!, method: 'Anonymous');
        Get.toNamed(Routes.NOTIFICATION, arguments: true);
      } else {
        Get.showSnackbar(
          const GetSnackBar(
            title: 'Error: ',
            duration: Duration(seconds: 2),
            message: 'Something went wrong',
          ),
        );
      }
      isLoading = false;
      update();
      return isLogin;
    } else if (method == LoginMethod.apple) {
      isLoading = true;
      update();
      bool isLogin1 = await authController.signInWithApple();
      // log(Auht().currentUser!.phoneNumber.toString());
      if (isLogin1) {
        authController.storeUserInfo(
            user: FirebaseAuth.instance.currentUser!, method: 'Apple');

        Get.toNamed(Routes.NOTIFICATION, arguments: true);
      } else if (method == LoginMethod.facebook) {
        authController.storeUserInfo(
            user: FirebaseAuth.instance.currentUser!, method: 'Apple');

        Get.toNamed(Routes.NOTIFICATION, arguments: true);
      } else {
        Get.showSnackbar(
          const GetSnackBar(
            title: 'Error: ',
            duration: Duration(seconds: 2),
            message: 'Something went wrong',
          ),
        );
      }
      isLoading = false;
      update();
      return isLogin1;
    } else if (method == LoginMethod.facebook) {
      isLoading = true;
      update();
      bool isFbLogin = await authController.signInWithFacebook();
      if (isFbLogin) {
        authController.storeUserInfo(
            user: FirebaseAuth.instance.currentUser!, method: 'Apple');

        Get.toNamed(Routes.NOTIFICATION, arguments: true);
      } else {
        Get.showSnackbar(
          const GetSnackBar(
            title: 'Error: ',
            duration: Duration(seconds: 2),
            message: 'Something went wrong',
          ),
        );
      }
      isLoading = false;
      update();
      return isFbLogin;
    } else {
      return false;
    }
  }

  @override
  void onClose() {}
}
