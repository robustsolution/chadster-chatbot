import 'package:aichatapp/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../../utilities/button.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/sizeConstant.dart';

class AICreditView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MySize().init(context);

    return Scaffold(
      backgroundColor: Color(0xffE7F2EC),
      body: Container(
        padding: EdgeInsets.all(
          MySize.getHeight(16),
        ).copyWith(top: MySize.getHeight(52)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Spacer(flex: 10),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                "CHADSTER",
                style: TextStyle(
                  color: appTheme.primaryTheme,
                  fontSize: MySize.getHeight(34),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Spacer(flex: 100),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    "Welcome to chadster",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: MySize.getHeight(24),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("As a thank you for trying us, we are giving you"),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: appTheme.primaryTheme, width: .6),
                      color: Color(0xff47A082).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          MAX_FREE_AI_USER.toString(),
                          style: TextStyle(
                            color: appTheme.primaryTheme,
                            fontSize: MySize.getHeight(55),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "FREE AI Uses!",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: MySize.getHeight(24),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text("AI uses are used to ask the AI to do tasks."),
                  SizedBox(height: 35),
                  getBounceButton(),
                ],
              ),
            ),
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
                  "Start Now",
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
          Get.offAndToNamed(Routes.MAIN_DASHBOARD);
        });
  }

  GestureDetector getBottomButton() {
    return button(
      radius: 8,
      onTap: () async {
        Get.offAndToNamed(Routes.MAIN_DASHBOARD);
      },
      backgroundColor: appTheme.primaryTheme,
      widget: Padding(
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
    );
  }

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
