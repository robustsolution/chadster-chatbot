import 'dart:developer';

import 'package:aichatapp/app/constants/app_constant.dart';
import 'package:aichatapp/app/constants/color_constant.dart';
import 'package:aichatapp/app/routes/app_pages.dart';
import 'package:aichatapp/utilities/appbar.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import '../../../../utilities/storebutton.dart';
import '../../../constants/sizeConstant.dart';
import '../controllers/tasks_screen_controller.dart';

class TasksScreenView extends GetWidget<TasksScreenController> {
  const TasksScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: TasksScreenController(),
        builder: (TasksScreenController controller) {
          log('sufyantask ${controller.taskItemList.length.toString()}');
          return Scaffold(
            appBar: buildAppBar(
              title: 'What can I help you with in ${controller.cat.title}?',
              trailing: Container(
                margin: EdgeInsets.symmetric(vertical: MySize.getHeight(10)),
                child: StoreButton(),
              ),
            ),
            body: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: MySize.getWidth(16)),
                child: Column(
                  children: [
                    // Spacing.height(10),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Row(
                    //       children: [
                    //         InkWell(
                    //           onTap: () {
                    //             Get.back();
                    //           },
                    //           child: Icon(
                    //             Icons.keyboard_backspace,
                    //             size: MySize.getHeight(24),
                    //             color: appTheme.iconBlackColor,
                    //           ),
                    //         ),
                    //         Spacing.width(19),
                    //         Text(
                    //           "What can I help you with ${cat.title}?",
                    //           overflow: TextOverflow.ellipsis,
                    //           style: TextStyle(
                    //               fontWeight: FontWeight.w700,
                    //               fontSize: MySize.getHeight(16),
                    //               color: appTheme.textBlackColor),
                    //         ),
                    //       ],
                    //     ),
                    //     StoreButton(),
                    //   ],
                    // ),
                    Spacing.height(8),
                    SizedBox(
                        height: MySize.getHeight(1),
                        child: Divider(
                          color: appTheme.textGrayColor,
                        )),
                    Spacing.height(24),
                    controller.isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                                color: Colors.green[900]),
                          )
                        : controller.taskItemList.isEmpty
                            ? Center(
                                child: Text(
                                  'No task found',
                                  style: TextStyle(
                                      fontSize: MySize.getHeight(16),
                                      color: appTheme.textBlackColor),
                                ),
                              )
                            : Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      ...controller.taskItemList
                                          .map(
                                            (task) => Theme(
                                              data: ThemeData(
                                                splashColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  Get.toNamed(
                                                      Routes.QUESTION_SCREEN,
                                                      arguments: {
                                                        'category':
                                                            Get.arguments,
                                                        'task': task,
                                                      });
                                                },
                                                child: getContainer(
                                                    image: task.imageUrl,
                                                    title: task.title),
                                              ),
                                            ),
                                          )
                                          .toList()
                                    ],
                                  ),
                                ),
                              ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget getContainer({required String image, required String title}) {
    return Container(
      height: MySize.getHeight(56),
      width: MySize.getWidth(343),
      margin: EdgeInsets.only(
        bottom: MySize.getHeight(16),
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
          image.isEmpty
              ? SvgPicture.asset('${imagePath}home_custom_icon.svg')
              : ExtendedImage.network(
                  image,
                  cache: true,
                ),
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
