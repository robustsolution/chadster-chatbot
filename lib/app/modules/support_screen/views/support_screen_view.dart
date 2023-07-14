import 'package:aichatapp/utilities/button.dart';
import 'package:aichatapp/utilities/text_field.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../constants/color_constant.dart';
import '../../../constants/sizeConstant.dart';
import '../controllers/support_screen_controller.dart';

class SupportScreenView extends GetWidget<SupportScreenController> {
  const SupportScreenView({super.key});

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
                    "Contact for Support",
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
              child: SingleChildScrollView(
                child: Form(
                  key: controller.formKey,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: MySize.getWidth(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: MySize.getHeight(14)),
                        ),
                        Spacing.height(4),
                        getTextField(
                            textEditingController: controller.nameController,
                            hintText: "enter name"),
                        Spacing.height(24),
                        Text(
                          "Email Address",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: MySize.getHeight(14)),
                        ),
                        Spacing.height(4),
                        getTextField(
                            textEditingController: controller.mailController,
                            hintText: "enter email address"),
                        Spacing.height(24),
                        Text(
                          "Message",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: MySize.getHeight(14)),
                        ),
                        Spacing.height(4),
                        getTextField(
                            textEditingController: controller.messageController,
                            hintText: "enter message"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: button(
                height: 48,
                width: 343,
                title: "Submit",
                backgroundColor: appTheme.primaryTheme,
                textColor: Colors.white,
                radius: MySize.getHeight(15),
              ),
            ),
            Spacing.height(16),
          ],
        ),
      ),
    );
  }
}
