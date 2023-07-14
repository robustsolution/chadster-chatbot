import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/constants/color_constant.dart';
import '../app/constants/sizeConstant.dart';

AppBar buildAppBar({
  required String title,
  required Widget trailing,
}) {
  return AppBar(
    backgroundColor: appTheme.backgroundAppBarColor,
    shadowColor: Colors.grey.withOpacity(0.1),
    leading: IconButton(
      onPressed: () {
        Get.back();
      },
      icon: Icon(
        Icons.keyboard_backspace,
        size: 30,
        color: Colors.black,
      ),
    ),
    title: Text(
      title,
      maxLines: 2,
      style: TextStyle(
        color: appTheme.textBlackColor,
        fontSize: MySize.getHeight(16),
        fontWeight: FontWeight.w700,
      ),
      textAlign: TextAlign.left,
    ),
    actions: [Container(margin: EdgeInsets.only(right: 20), child: trailing)],
  );
}
