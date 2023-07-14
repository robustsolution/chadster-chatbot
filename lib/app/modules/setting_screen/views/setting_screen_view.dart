import 'dart:developer';

import 'package:aichatapp/app/constants/color_constant.dart';
import 'package:aichatapp/app/models/review.dart';
import 'package:aichatapp/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../services/listen_changes.dart';
import '../../../../utilities/review_widget.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/sizeConstant.dart';
import '../controllers/setting_screen_controller.dart';

class SettingScreenView extends GetWidget<SettingScreenController> {
  final reviewController = Get.put(AppReview());
  final changelistener = Get.put(ChangesListener());

  @override
  Widget build(BuildContext context) {
    Future<void> _launchUrl(String _url) async {
      if (!await launchUrl(Uri.parse(_url),
          mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $_url';
      }
    }

    return GetBuilder(
      init: SettingScreenController(),
      builder: (SettingScreenController controller) {
        return Scaffold(
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: MySize.getHeight(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacing.height(50),
                Text(
                  "Settings",
                  style: TextStyle(
                      fontSize: MySize.getHeight(24),
                      fontWeight: FontWeight.w700),
                ),
                Spacing.height(16),
                // Text(
                //   "ABOUT",
                //   style: TextStyle(color: appTheme.textGrayColor2, fontSize: MySize.getHeight(12), fontWeight: FontWeight.w700),
                // ),
                // Spacing.height(8),
                // GestureDetector(
                //   onTap: () {
                //     Get.toNamed(Routes.ABOUT_APP_SCREEN);
                //   },
                //   child: getContainer(title: "About app", image: "setting_info_icon.svg"),
                // ),
                // GestureDetector(
                //   onTap: () {
                //     Get.toNamed(Routes.SUPPORT_SCREEN);
                //   },
                //   child: getContainer(title: "Contact for support", image: "setting_support_icon.svg"),
                // ),
                // Spacing.height(24),
                Text(
                  "LEGAL",
                  style: TextStyle(
                      color: appTheme.textGrayColor2,
                      fontSize: MySize.getHeight(12),
                      fontWeight: FontWeight.w700),
                ),
                Spacing.height(8),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.WEBVIEW, arguments: {
                      'title': 'Disclaimer',
                      'url':
                          'https://www.trendicator.io/legal/chadster/disclaimer/',
                    });
                    // _launchUrl("https://www.trendicator.io/legal/chadster/disclaimer/");
                  },
                  child: getContainer(
                      title: "Disclaimer",
                      image: "setting_disclaimer_icon.svg"),
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.WEBVIEW, arguments: {
                      'title': 'Terms of Service',
                      'url': "https://www.trendicator.io/legal/tos",
                    });
                    // _launchUrl("https://www.trendicator.io/legal/tos");
                  },
                  child: getContainer(
                      title: "Terms of Service",
                      image: "setting_summaries_icon.svg"),
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.WEBVIEW, arguments: {
                      'title': 'Privacy Policy',
                      'url': 'https://www.trendicator.io/legal/privacy/',
                    });
                    // _launchUrl("https://www.trendicator.io/legal/privacy/");
                  },
                  child: getContainer(
                    title: "Privacy Policy",
                    image: "setting_privacy_icon.svg",
                  ),
                ),
                Spacing.height(24),
                Text(
                  "APP",
                  style: TextStyle(
                      color: appTheme.textGrayColor2,
                      fontSize: MySize.getHeight(12),
                      fontWeight: FontWeight.w700),
                ),
                Spacing.height(8),
                GestureDetector(
                  onTap: () {
                    if (ChangesListener.to.isSubscribed()) {
                      Get.snackbar('Error', 'Already subscribed.');
                      return;
                    }

                    final InAppPurchase _inAppPurchase = InAppPurchase.instance;

                    _inAppPurchase.restorePurchases();
                  },
                  child: getContainer(
                      title: "Restore Purchases",
                      image: "setting_refresh_icon.svg"),
                ),
                GestureDetector(
                  onTap: () {
                    showRatingDialog(
                        title: 'Chadster',
                        message: 'Tap a star to rate it on the App Store',
                        appStoreId: '1665164822');
                  },
                  child:
                      getContainer(title: "Rate Us", image: "setting_rate.svg"),
                ),
                GestureDetector(
                  onTap: () {
                    final Size size = MediaQuery.of(context).size;
                    print(123);
                    Share.share(
                      'https://apps.apple.com/in/app/chadster-ai-genie/id1665164822',
                      sharePositionOrigin:
                          Rect.fromLTWH(0, 0, size.width, size.height / 2),
                    );
                  },
                  child:
                      getContainer(title: "Share", image: "setting_share.svg"),
                ),

                GestureDetector(
                  onTap: () async {
                    log(FirebaseAuth.instance.currentUser!.email.toString());
                    FirebaseMessaging messaging = FirebaseMessaging.instance;
                    await messaging.unsubscribeFromTopic(
                        FirebaseAuth.instance.currentUser!.uid);
                    if (changelistener.isSubscribed()) {
                      log('subscribe: ${changelistener.isSubscribed()}');
                      await messaging.unsubscribeFromTopic('activeSubs');
                    } else {
                      log('subscribe: ${changelistener.isSubscribed()}');
                      await messaging.unsubscribeFromTopic('inActiveSubs');
                    }
                    await FirebaseAuth.instance.signOut();
                    Get.offAllNamed(Routes.LOGIN_SCREEN);
                  },
                  child: getContainer(
                      title: "Log out", image: "setting_logout_icon.svg"),
                ),
                Center(
                  child: controller.isDeleting
                      ? Center(
                          child: CircularProgressIndicator(
                              color: Colors.green[900]),
                        )
                      : TextButton(
                          onPressed: () {
                            Get.defaultDialog(
                                title: 'Delete Account',
                                content: Text('Are you sure?'),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      Get.back();
                                      controller.setDelete(value: true);

                                      try {
                                        await FirebaseAuth.instance.currentUser!
                                            .delete();

                                        controller.setDelete(value: false);
                                        Get.offAllNamed(Routes.LOGIN_SCREEN);
                                        Get.snackbar(
                                          'Deleted',
                                          'Your account has been deleted',
                                          colorText: Colors.white,
                                          backgroundColor:
                                              Color.fromRGBO(71, 160, 130, 1),
                                        );
                                      } on FirebaseAuthException catch (e) {
                                        if (e.code == "requires-recent-login") {
                                          FirebaseAuth.instance.signOut();
                                          Get.offAllNamed(Routes.LOGIN_SCREEN);
                                          Get.snackbar('Error',
                                              'Please login again and delete the account');
                                        }
                                      }
                                    },
                                    child: Text('Yes'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text('No'),
                                  )
                                ]);
                          },
                          child: Text(
                            'Delete Account',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          )),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget getContainer({required String image, required String title}) {
    return Container(
      height: MySize.getHeight(56),
      width: MySize.getWidth(343),
      margin: EdgeInsets.only(
        bottom: MySize.getHeight(12),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: appTheme.borderGreyColor),
        borderRadius: BorderRadius.circular(
          MySize.getHeight(12),
        ),
      ),
      child: Row(
        children: [
          Spacing.width(17),
          SvgPicture.asset(imagePath + image),
          Spacing.width(18),
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w500, fontSize: MySize.getHeight(16)),
          ),
        ],
      ),
    );
  }
}
