import 'dart:developer';

import 'package:aichatapp/app/routes/app_pages.dart';
import 'package:aichatapp/services/listen_changes.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

// import '../../../../utilities/button.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/sizeConstant.dart';
import '../controllers/notification_controller.dart';

class NotificationView extends GetWidget<NotificationController> {
  @override
  Widget build(BuildContext context) {
    MySize().init(context);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(
          MySize.getHeight(16),
        ).copyWith(top: MySize.getHeight(52)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            getTopBarSection(),
            Space.height(53),
            getImageSection(),
            Expanded(
              child: Container(),
            ),
            getBounceButton(),
            // getBottomButton(),
            Space.height(24),
          ],
        ),
      ),
    );
  }

  Bounce getBounceButton() {
    return Bounce(
        child: Container(
          height: MySize.getHeight(50),
          width: MySize.getWidth(341),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: appTheme.primaryTheme),
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MySize.getWidth(24),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Continue",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MySize.getHeight(16),
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SvgPicture.asset(
                  "${imagePath}ic_arrow_right.svg",
                ),
              ],
            ),
          ),
        ),
        duration: Duration(milliseconds: 250),
        onPressed: () async {
            final changelistener = ChangesListener.to;
          FirebaseMessaging messaging = FirebaseMessaging.instance;
          await messaging.requestPermission();
          await messaging
              .subscribeToTopic(FirebaseAuth.instance.currentUser!.uid);
          if (changelistener.isSubscribed()) {
            log('subscribe: ${changelistener.isSubscribed()}');
            await messaging.subscribeToTopic('activeSubs');
          } else {
            log('subscribe: ${changelistener.isSubscribed()}');
            await messaging.subscribeToTopic('inActiveSubs');
          }
          Get.toNamed(Routes.TRAIL);
        });
  }

  // GestureDetector getBottomButton() {
  //   return button(
  //     radius: 8,
  //     onTap: () async {
  //       FirebaseMessaging messaging = FirebaseMessaging.instance;

  //       await messaging.requestPermission();
  //       Get.toNamed(Routes.STORE_SCREEN, arguments: {
  //         'skip': true,
  //         'limitExceed': false,
  //       });
  //     },
  //     backgroundColor: appTheme.primaryTheme,
  //     widget: Padding(
  //       padding: EdgeInsets.symmetric(
  //         horizontal: MySize.getWidth(24),
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Text(
  //             "Continue",
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontSize: MySize.getHeight(16),
  //               fontWeight: FontWeight.w600,
  //             ),
  //             textAlign: TextAlign.center,
  //           ),
  //           SvgPicture.asset(
  //             "${imagePath}ic_arrow_right.svg",
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Column getTopBarSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Enable Notifications",
          style: TextStyle(
            color: appTheme.textBlackColor,
            fontSize: MySize.getHeight(26),
            fontWeight: FontWeight.w600,
          ),
        ),
        Space.height(8),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MySize.getHeight(16),
          ),
          child: Text(
            "We are constantly adding new tasks you can have the AI do..",
            style: TextStyle(
              color: appTheme.textBlackColor,
              fontSize: MySize.getHeight(16),
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Column getImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "${imagePath}notification_avtar_icon.svg",
          height: MySize.getHeight(253),
          width: MySize.getWidth(271),
        ),
        Space.height(34),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MySize.getWidth(12),
          ),
          child: Text(
            "Give us permission to send you notifications. (we don’t bug you much, don’t worry).",
            style: TextStyle(
              color: appTheme.textBlackColor,
              fontSize: MySize.getHeight(16),
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
