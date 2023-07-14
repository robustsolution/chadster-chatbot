import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

import '../app/constants/color_constant.dart';
import '../app/constants/sizeConstant.dart';

class ProgressDialogUtils {
  static bool isProgressVisible = false;

  ///common method for showing progress dialog
  static void showProgressDialog({isCancellable = false}) async {
    if (!isProgressVisible) {
      Get.dialog(
        Center(
          child: CircularProgressIndicator.adaptive(
            strokeWidth: 4,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.white,
            ),
          ),
        ),
        barrierDismissible: isCancellable,
      );
      isProgressVisible = true;
    }
  }

  ///common method for hiding progress dialog
  static void hideProgressDialog() {
    if (isProgressVisible) Get.back();
    isProgressVisible = false;
  }
}

class CustomDialogs {
  void showCircularDialog(BuildContext context) {
    CircularDialog.showLoadingDialog(context);
  }

  void hideCircularDialog(BuildContext context) {
    Get.back();
  }

  getDialog(
      {String title = "Error",
      String desc = "Some Thing went wrong....",
      Callback? onTap}) {
    return Get.defaultDialog(
        barrierDismissible: false,
        title: title,
        content: Center(
          child: Text(desc, textAlign: TextAlign.center),
        ),
        buttonColor: appTheme.primaryTheme,
        textConfirm: "Ok",
        confirmTextColor: Colors.white,
        onConfirm: (isNullEmptyOrFalse(onTap))
            ? () {
                Get.back();
              }
            : onTap);
  }
}

class CircularDialog {
  static Future<void> showLoadingDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
            child: Center(
              child: CircularProgressIndicator(color: appTheme.primaryTheme),
            ),
            onWillPop: () async {
              return false;
            });
      },
      barrierDismissible: false,
    );
  }
}
