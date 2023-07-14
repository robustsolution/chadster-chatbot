import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../constants/color_constant.dart';
import '../../../constants/sizeConstant.dart';
import '../controllers/privacy_policy_screen_controller.dart';

class PrivacyPolicyScreenView extends GetWidget<PrivacyPolicyScreenController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacing.height(50),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MySize.getHeight(18)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.keyboard_backspace,
                      size: MySize.getHeight(24),
                      color: appTheme.iconBlackColor,
                    ),
                  ),
                  Spacing.width(19),
                  Text(
                    "Privacy Policy",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: MySize.getHeight(16),
                        color: appTheme.textBlackColor),
                  ),
                ],
              ),
            ),
            Spacing.height(8),
            SizedBox(
              height: MySize.getHeight(1),
              child: Divider(
                color: appTheme.textGrayColor,
              ),
            ),
            Spacing.height(24),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: MySize.getWidth(24)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.",
                      style: TextStyle(
                          fontSize: MySize.getHeight(16),
                          fontWeight: FontWeight.w400),
                    ),
                    Spacing.height(16),
                    Text(
                      "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.",
                      style: TextStyle(
                          fontSize: MySize.getHeight(16),
                          fontWeight: FontWeight.w400),
                    ),
                    Spacing.height(16),
                    Text(
                      "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint.",
                      style: TextStyle(
                          fontSize: MySize.getHeight(16),
                          fontWeight: FontWeight.w400),
                    ),
                    Spacing.height(16),
                    Text(
                      "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.",
                      style: TextStyle(
                          fontSize: MySize.getHeight(16),
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
