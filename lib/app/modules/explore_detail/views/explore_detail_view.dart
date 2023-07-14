import 'package:aichatapp/app/constants/color_constant.dart';
import 'package:aichatapp/app/modules/explore_detail/views/widgets/explore_detail_bbar.dart';
import 'package:aichatapp/utilities/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/explore_detail_controller.dart';
import 'widgets/info_container.dart';

class ExploreDetailView extends GetView<ExploreDetailController> {
  const ExploreDetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // final task = Get.arguments as Task?;

    return GetBuilder(
        init: ExploreDetailController(),
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black,
              actions: [
                Obx(
                  () => Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: IconButton(
                      onPressed: () {
                        controller.favoriteTask();
                      },
                      icon: Icon(
                        controller.isFavorite.value
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: controller.isFavorite.value
                            ? Colors.yellow
                            : Colors.black,
                        size: 24.h,
                      ),
                    ),
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Divider(
                    thickness: 1,
                    height: 0.h,
                    color: appTheme.greyColor,
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoContainer(
                          task: controller.task!,
                        ),
                        SizedBox(height: 24.h),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                controller.task!.powerPrompt.isEmpty
                                    ? controller.task!.prompt
                                        .replaceAll('\${input}', '')
                                    : controller.task!.powerPrompt
                                        .replaceAll('\${input}', ''),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color: appTheme.textBlackColor),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Bounce(
                              duration: Duration(milliseconds: 300),
                              onPressed: () {
                                Get.defaultDialog(
                                    title: 'Tips',
                                    content: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w, vertical: 0.h),
                                      child: Column(
                                        children: [
                                          ...controller.task!.tips
                                              .map((e) => Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 5.0.h),
                                                    child: Text(
                                                        '${controller.task!.tips.indexOf(e) + 1}. ${e}'),
                                                  ))
                                        ],
                                      ),
                                    ));
                              },
                              child: controller.task!.tips.length <= 0
                                  ? Container()
                                  : Icon(
                                      Icons.info_outline,
                                      color: appTheme.iconBlackColor,
                                      size: 20.h,
                                    ),
                            )
                          ],
                        ),
                        SizedBox(height: 16.h),
                        getTextField(
                          isFilled: true,
                          textEditingController: controller.InputController,
                          borderRadius: 16,
                          maxLine: 6,
                          hintText:
                              controller.task!.powerPromptPlaceholder.isEmpty
                                  ? controller.task!.prompt
                                      .replaceAll('\${input}', '')
                                  : controller.task!.powerPromptPlaceholder
                                      .replaceAll('\${input}', ''),
                        ),
                        SizedBox(height: 24.h),
                        if (controller.task!.prompt_extension!.isNotEmpty)
                          ...controller.task!.prompt_extension!.map((e) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      e.replaceFirst('\$(input)', ''),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w500,
                                          color: appTheme.textBlackColor),
                                    ),
                                    SizedBox(width: 12.w),
                                    Bounce(
                                      duration: Duration(milliseconds: 300),
                                      onPressed: () {
                                        Get.defaultDialog(
                                            title: 'Tips',
                                            content: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12.w,
                                                  vertical: 0.h),
                                              child: Column(
                                                children: [
                                                  ...controller.task!.tips
                                                      .map((e) => Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom:
                                                                        5.0.h),
                                                            child: Text(
                                                                '${controller.task!.tips.indexOf(e) + 1}. ${e}'),
                                                          ))
                                                ],
                                              ),
                                            ));
                                      },
                                      child: controller.task!.tips.length <= 0
                                          ? Container()
                                          : Icon(
                                              Icons.info_outline,
                                              color: appTheme.iconBlackColor,
                                              size: 20.h,
                                            ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 16.h),
                                getTextField(
                                  isFilled: true,
                                  textEditingController:
                                      controller.toneControllers[e],
                                  borderRadius: 16,
                                  maxLine: 1,
                                  labelText: e.replaceFirst('\$(input)', ''),
                                ),
                              ],
                            );
                          }).toList(),
                      ],
                    ),
                  )
                ],
              ),
            ),
            bottomNavigationBar: ExploreDetailBBar(controller: controller),
          );
        });
  }
}
