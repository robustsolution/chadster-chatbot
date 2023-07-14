
import 'package:aichatapp/app/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../../utilities/button.dart';
import '../../../../utilities/input_feild.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/sizeConstant.dart';
import '../controllers/ai_response_controller.dart';

class AiResponseView extends GetWidget<AiResponseController> {
  AiResponseView({super.key});
  final aiController = Get.put(AiResponseController());
  @override
  Widget build(BuildContext context) {
    // Task task = Get.arguments['task'];
    // Category category = Get.arguments['category'];
    // String input = Get.arguments['input'];
    // String response = Get.arguments['response'];
    // log(task.title);
    // log(category.title);
    // log(input);
    // log(response);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Space.height(10),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MySize.getWidth(16),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: MySize.getHeight(12),
                ),
                decoration: BoxDecoration(
                    color: appTheme.backgroundAppBarColor,
                    border: Border(
                      bottom: BorderSide(
                        color: appTheme.greyColor,
                      ),
                    )),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: SvgPicture.asset(
                        imagePath + "icon_back.svg",
                        width: MySize.getWidth(24),
                        fit: BoxFit.fitWidth,
                        height: MySize.getHeight(24),
                      ),
                    ),
                    Space.width(16),
                    Text(
                      "Back",
                      style: TextStyle(
                        color: appTheme.textBlackColor,
                        fontSize: MySize.getHeight(16),
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Space.height(24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getTopSection(
                        task: aiController.task!,
                        input: aiController.input,
                        response: aiController.response,
                        controller: aiController.responseController),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding getTopSection(
      {required Task task,
      required String input,
      required String response,
      required TextEditingController controller}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MySize.getWidth(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: task.prompt.split('\$').first,
                    style: TextStyle(
                      color: appTheme.textBlackColor,
                      fontSize: MySize.getHeight(16),
                      fontWeight: FontWeight.w500,
                    ),
                    children: <InlineSpan>[
                      TextSpan(
                        text: input,
                        style: TextStyle(
                          color: appTheme.textBlackColor,
                          fontSize: MySize.getHeight(16),
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.back(result: {
                    'category': Get.arguments['category'],
                    'task': task,
                  });
                },
                child: SvgPicture.asset(
                  "${imagePath}icon_edit.svg",
                  width: MySize.getWidth(20),
                  fit: BoxFit.fitWidth,
                  height: MySize.getHeight(20),
                ),
              )
            ],
          ),
          Space.height(12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                MySize.getHeight(12),
              ),
              border: Border.all(
                color: appTheme.borderGrayColor,
              ),
            ),
            padding: EdgeInsets.all(
              MySize.getHeight(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputFeild(
                    hinntText: '',
                    type: TextInputType.multiline,
                    maxLines: null,
                    validatior: () {},
                    inputController: controller),
                // Text(
                //   response,
                //   style: TextStyle(
                //     color: appTheme.iconBlackColor,
                //     fontSize: MySize.getHeight(14),
                //     fontWeight: FontWeight.w400,
                //   ),
                // ),
                Space.height(54),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    child: SvgPicture.asset(
                      "${imagePath}icon_copy.svg",
                      width: MySize.getWidth(20),
                      fit: BoxFit.fitWidth,
                      height: MySize.getHeight(20),
                    ),
                    onTap: () {
                      Get.snackbar('Copied', 'Text has been copied');

                      Clipboard.setData(
                        ClipboardData(text: controller.text),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Space.height(12),
          // Center(
          //   child: Text(
          //     "Tell me more",
          //     style: TextStyle(
          //       color: appTheme.primaryTheme,
          //       fontSize: MySize.getHeight(14),
          //       fontWeight: FontWeight.w600,
          //     ),
          //   ),
          // ),
          Space.height(16),
          button(
            onTap: () {
              Get.back(result: {
                'category': Get.arguments['category'],
                'task': task,
              });
              // Get.toNamed(Routes.QUESTION_SCREEN, arguments: {
              //   'category': Get.arguments['category'],
              //   'task': task,
              // });
            },
            radius: 8,
            backgroundColor: appTheme.primaryTheme,
            title: "Ask another question...",
            fontsize: 16,
          ),
          Space.height(24),
        ],
      ),
    );
  }
}
