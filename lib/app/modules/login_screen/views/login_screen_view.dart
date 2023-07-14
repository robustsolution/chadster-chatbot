import 'dart:io';

import 'package:aichatapp/app/constants/color_constant.dart';
// import 'package:aichatapp/app/models/auth.dart';
// import 'package:aichatapp/app/routes/app_pages.dart';
import 'package:aichatapp/utilities/button.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/sizeConstant.dart';
import '../controllers/login_screen_controller.dart';

class LoginScreenView extends GetWidget<LoginScreenController> {
  const LoginScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return GetBuilder(builder: (LoginScreenController controller) {
      return Scaffold(
        body: Container(
          padding: EdgeInsets.all(
            MySize.getHeight(16),
          ).copyWith(top: MySize.getHeight(52)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              getTopBarSection(),
              getImageSection(),
              getBottomButtonSection(),
            ],
          ),
        ),
      );
    });
  }

  Column getTopBarSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Your Ai Assistant",
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
            "Get the world's most powerful AI to do your most tedious tasks.",
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

  Widget getBottomButtonSection() {
    return controller.isLoading
        ? Center(
            child: CircularProgressIndicator(
              color: Colors.green[900],
            ),
          )
        : Container(
            width: MySize.screenWidth,
            padding: EdgeInsets.symmetric(
              horizontal: MySize.getWidth(16),
              vertical: MySize.getHeight(24),
            ),
            // height: MySize.getHeight(71),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(MySize.getHeight(4), MySize.getHeight(4)),
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: MySize.getHeight(5),
                  spreadRadius: MySize.getHeight(5),
                ),
              ],
              borderRadius: BorderRadius.circular(
                MySize.getHeight(24),
              ),
            ),
            child: Column(
              children: [
                Text.rich(
                  TextSpan(
                    text: 'By continuing, you agree with our ',
                    style: TextStyle(
                      color: appTheme.textBlackColor,
                      fontSize: MySize.getHeight(10),
                      fontWeight: FontWeight.w500,
                    ),
                    children: <InlineSpan>[
                      TextSpan(
                        text: 'Privacy Policy & Terms of use.',
                        style: TextStyle(
                          color: appTheme.textBlackColor,
                          fontSize: MySize.getHeight(10),
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
                Space.height(8),
                if (Platform.isIOS)
                  button(
                    radius: 8,
                    onTap: () {
                      controller.signIn(method: LoginMethod.apple);
                    },
                    widget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "${imagePath}login_apple_icon.svg",
                          height: MySize.getHeight(16),
                          width: MySize.getHeight(16),
                        ),
                        Space.width(10),
                        Text(
                          "Continue with Apple",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MySize.getHeight(14),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                Space.height(8),
                button(
                  onTap: () async {
                    controller.signIn(method: LoginMethod.google);
                  },
                  radius: 8,
                  backgroundColor: Colors.white,
                  borderColor: appTheme.greyColor,
                  widget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "${imagePath}login_google_icon.svg",
                        height: MySize.getHeight(16),
                        width: MySize.getHeight(16),
                      ),
                      Space.width(10),
                      Text(
                        "Continue with Google",
                        style: TextStyle(
                          color: appTheme.secondaryTheme,
                          fontSize: MySize.getHeight(14),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Space.height(8),
                button(
                  onTap: () async {
                    controller.signIn(method: LoginMethod.facebook);
                  },
                  radius: 8,
                  backgroundColor: Color.fromRGBO(66, 103, 178, 1),
                  borderColor: appTheme.greyColor,
                  widget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.facebook,
                        color: Colors.white,
                        size: MySize.getHeight(24),
                      ),
                      Space.width(10),
                      Text(
                        "Continue with Facebook",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MySize.getHeight(14),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Space.height(8),
                // button(
                //   onTap: () async {
                //     controller.signIn(method: LoginMethod.anonymous);
                //   },
                //   radius: 8,
                //   backgroundColor: Colors.white,
                //   borderColor: appTheme.greyColor,
                //   widget: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       const Icon(
                //         Icons.mail_outline,
                //         color: Colors.grey,
                //       ),
                //       Space.width(10),
                //       Text(
                //         "Annonymous SignIn",
                //         style: TextStyle(
                //           color: appTheme.secondaryTheme,
                //           fontSize: MySize.getHeight(14),
                //           fontWeight: FontWeight.w500,
                //         ),
                //         textAlign: TextAlign.center,
                //       ),
                //     ],
                //   ),
                // ),
                // Space.height(8),
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child: Text(
                //     "Skip for now",
                //     style: TextStyle(
                //       color: appTheme.secondaryTheme,
                //       fontSize: MySize.getHeight(14),
                //       fontWeight: FontWeight.w700,
                //     ),
                //     textAlign: TextAlign.center,
                //   ),
                // ),
              ],
            ),
          );
  }

  Column getImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          imagePath + "login_avtar.svg",
          height: MySize.getHeight(283),
        ),
        Space.height(34),
        Text(
          "Simply, choose a task, give it some details and voila! The AI does it’s magic!.",
          style: TextStyle(
            color: appTheme.textBlackColor,
            fontSize: MySize.getHeight(16),
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
