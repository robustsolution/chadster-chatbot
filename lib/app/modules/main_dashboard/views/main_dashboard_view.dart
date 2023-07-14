import 'dart:io';

import 'package:aichatapp/app/constants/app_constant.dart';
import 'package:aichatapp/app/constants/color_constant.dart';
import 'package:aichatapp/app/constants/sizeConstant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import '../controllers/main_dashboard_controller.dart';

class MainDashboardView extends GetWidget<MainDashboardController> {
  buildDailog() {
    return Get.dialog(AlertDialog(
      title: Text('testing'),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text(
            'Okay',
          ),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return GetBuilder(builder: (MainDashboardController controller) {
      return Scaffold(
        body: Column(
          children: [
            Expanded(child: controller.tabs[controller.selectedIndex]),
          ],
        ),
        bottomNavigationBar: Container(
          width: MySize.screenWidth,
          height: MySize.getHeight(71),
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
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(MySize.getHeight(25)),
                  topLeft: Radius.circular(MySize.getHeight(25)))),
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(bottom: Platform.isIOS ? 13 : 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                getBottomIcon(
                  title: "AI Tasks",
                  image: (controller.selectedIndex == 0)
                      ? "filled_Home_home_icon.svg"
                      : "Home_home_icon.svg",
                  index: 0,
                  isSelected: controller.selectedIndex == 0,
                ),
                getBottomIcon(
                  title: "Explore",
                  image: (controller.selectedIndex == 1)
                      ? "home_fill_explore.svg"
                      : "home_explore.svg",
                  index: 1,
                  isSelected: controller.selectedIndex == 1,
                ),
                getBottomIcon(
                  title: "Premium",
                  image: "home_store_icon.svg",
                  index: 2,
                  isSelected: controller.selectedIndex == 2,
                ),
                // getBottomIcon(
                //   title: "History",
                //   index: 3,
                //   image: "home_save_icon.svg",
                //   isSelected: controller.selectedIndex == 3,
                // ),
                getBottomIcon(
                  title: "Chat",
                  index: 4,
                  image: (controller.selectedIndex == 4)
                      ? "filled_home_chat_icon.svg"
                      : "home_chat_icon.svg",
                  isSelected: controller.selectedIndex == 4,
                ),
                getBottomIcon(
                  title: "Settings",
                  index: 5,
                  image: (controller.selectedIndex == 5)
                      ? "filled_home_setting_icon.svg"
                      : "home_setting_icon.svg",
                  isSelected: controller.selectedIndex == 5,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget getBottomIcon(
      {required String image,
      required String title,
      required int index,
      required bool isSelected}) {
    return InkWell(
      onTap: () {
        controller.setTabIndex(index: index);
        // controller.pageController.jumpToPage(index);
      },
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(imagePath + image,
                color: (isSelected)
                    ? appTheme.primaryTheme
                    : appTheme.iconBlackColor,
                width: MySize.getWidth(23),
                height: MySize.getHeight(23)),
            Spacing.height(6),
            Text(
              title,
              style: TextStyle(
                  color: (isSelected)
                      ? appTheme.primaryTheme
                      : appTheme.iconBlackColor,
                  fontWeight: FontWeight.w700,
                  fontSize: MySize.getHeight(14)),
            ),
          ],
        ),
      ),
    );
  }
}
