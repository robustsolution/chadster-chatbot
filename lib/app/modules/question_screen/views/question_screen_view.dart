import 'package:aichatapp/app/constants/color_constant.dart';
import 'package:aichatapp/app/models/ai.dart';
import 'package:aichatapp/app/models/category.dart';
import 'package:aichatapp/app/models/task.dart';
import 'package:aichatapp/app/routes/app_pages.dart';
import 'package:aichatapp/utilities/appbar.dart';
import 'package:aichatapp/utilities/storebutton.dart';
import 'package:aichatapp/utilities/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../../services/listen_changes.dart';
import '../../../../utilities/button.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/sizeConstant.dart';
import '../controllers/question_screen_controller.dart';

class QuestionScreenView extends GetWidget<QuestionScreenController> {
  final _inputController = TextEditingController();

  final aiController = Get.put(AskAI());
  @override
  Widget build(BuildContext context) {
    // final data = Get.arguments;
    // Task task = data['task'];
    // Category category = data['category'];
    return GetBuilder(
        init: QuestionScreenController(),
        builder: (QuestionScreenController controller) {
          return Scaffold(
            appBar: buildAppBar(
                title: "Task",
                trailing: Container(
                    margin:
                        EdgeInsets.symmetric(vertical: MySize.getHeight(10)),
                    child: StoreButton())),
            body: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
              ),
              child: Column(
                children: [
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: MySize.getWidth(16)),
                  //   child: Row(
                  //     children: [
                  //       InkWell(
                  //         onTap: () {
                  //           Get.back();
                  //         },
                  //         child: Icon(
                  //           Icons.keyboard_backspace,
                  //           size: MySize.getHeight(24),
                  //           color: appTheme.iconBlackColor,
                  //         ),
                  //       ),
                  //       SizedBox(
                  //         width: 10,
                  //       ),
                  //       Text(
                  //         'Back',
                  //         maxLines: 2,
                  //         style: TextStyle(
                  //           color: appTheme.textBlackColor,
                  //           fontSize: MySize.getHeight(16),
                  //           fontWeight: FontWeight.w700,
                  //         ),
                  //         textAlign: TextAlign.left,
                  //       ),
                  //       Spacer(),
                  //       StoreButton(),
                  //     ],
                  //   ),
                  // ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getTopSection(task: controller.task!),
                        Container(
                          width: MySize.screenWidth,
                          height: MySize.getHeight(8),
                          color: appTheme.greyColor,
                        ),
                        Space.height(24),
                        if (controller.task!.tips.isNotEmpty)
                          Expanded(
                              child: getBottomCopySection(
                            cat: controller.category!,
                            task: controller.task!,
                          )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Padding getTopSection({required Task task}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MySize.getWidth(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.prompt.replaceAll('\${input}', '...'),
            style: TextStyle(
              color: appTheme.textBlackColor,
              fontSize: MySize.getHeight(20),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Space.height(12),
          getTextField(
            isFilled: true,
            textEditingController: _inputController,
            borderRadius: 16,
            maxLine: 10,
            hintText: "Be as specific as you can...",
          ),
          Space.height(12),
          controller.isWaitng
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.green[900],
                  ),
                )
              : button(
                  radius: 8,
                  onTap: () async {
                    if (_inputController.text.isEmpty) {
                      Get.showSnackbar(GetSnackBar(
                        title: 'Empty Feild',
                        message: 'Please enter something',
                        duration: Duration(seconds: 2),
                      ));
                    } else {
                      print('query value: ${ChangesListener.to.aiQueries}');
                      if (ChangesListener.to.aiQueries < MAX_FREE_AI_USER ||
                          ChangesListener.to.isSubscribed()) {
                        String responseData = await controller.askAi(
                            input: _inputController.text.trim());
                        Get.toNamed(Routes.AI_RESPONSE, arguments: {
                          'category': controller.category!,
                          'task': controller.task!,
                          'input': _inputController.text.trim(),
                          'response': responseData,
                        });
                      } else {
                        Get.toNamed(Routes.STORE_SCREEN, arguments: {
                          'skip': false,
                          'limitExceed': true,
                        });
                        Get.snackbar(
                          'Limit Exceed',
                          'Purchase a premium package',
                        );
                      }
                    }
                  },
                  backgroundColor: appTheme.primaryTheme,
                  title: "Ask Chad",
                  fontsize: 16,
                ),
          Space.height(24),
        ],
      ),
    );
  }

  Padding getBottomCopySection({required Category cat, required Task task}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MySize.getWidth(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tips",
            style: TextStyle(
              color: appTheme.textBlackColor,
              fontSize: MySize.getHeight(16),
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          Space.height(4),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                cat.title,
                style: TextStyle(
                  color: appTheme.iconBlackColor,
                  fontSize: MySize.getHeight(12),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              Space.width(10),
              CircleAvatar(
                radius: MySize.getHeight(2),
                backgroundColor: appTheme.iconBlackColor,
              ),
              Space.width(8),
              Text(
                task.title,
                style: TextStyle(
                  color: appTheme.iconBlackColor,
                  fontSize: MySize.getHeight(12),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Expanded(
            child: ListView.separated(
                padding: EdgeInsets.symmetric(
                  vertical: MySize.getHeight(16),
                ),
                itemBuilder: (context, i) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        MySize.getHeight(12),
                      ),
                      border: Border.all(
                        color: appTheme.primaryTheme,
                      ),
                    ),
                    padding: EdgeInsets.all(
                      MySize.getHeight(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.tips[i].toString(),
                          style: TextStyle(
                            color: appTheme.iconBlackColor,
                            fontSize: MySize.getHeight(14),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            child: SvgPicture.asset(
                              imagePath + "icon_copy.svg",
                              width: MySize.getWidth(20),
                              fit: BoxFit.fitWidth,
                              height: MySize.getHeight(20),
                            ),
                            onTap: () {
                              Get.snackbar('Copied', 'Text has been copied');

                              Clipboard.setData(new ClipboardData(
                                  text: task.tips[i].toString()));
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, i) {
                  return Space.height(12);
                },
                itemCount: task.tips.length),
          ),
        ],
      ),
    );
  }
}
