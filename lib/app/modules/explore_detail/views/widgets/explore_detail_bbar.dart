import 'package:aichatapp/app/constants/color_constant.dart';
import 'package:aichatapp/app/modules/explore_detail/controllers/explore_detail_controller.dart';
import 'package:aichatapp/app/routes/app_pages.dart';
import 'package:aichatapp/utilities/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ExploreDetailBBar extends StatelessWidget {
  final ExploreDetailController controller;
  const ExploreDetailBBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 66.h,
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            button(
                height: 32.h,
                width: 32.h,
                radius: 8.r,
                backgroundColor: appTheme.greyColor,
                widget: Icon(
                  Icons.remove,
                  color: appTheme.iconBlackColor,
                ),
                onTap: () {
                  controller.totalCount.value = controller.totalCount.value - 1;
                }),
            SizedBox(
              width: 16.w,
            ),
            Obx(
              () => Text(
                controller.totalCount.value.toString(),
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: appTheme.textBlackColor,
                ),
              ),
            ),
            SizedBox(
              width: 16.w,
            ),
            button(
                height: 32.h,
                width: 32.h,
                radius: 8.r,
                backgroundColor: appTheme.greyColor,
                widget: Icon(
                  Icons.add,
                  color: appTheme.iconBlackColor,
                ),
                onTap: () {
                  controller.totalCount.value = controller.totalCount.value + 1;
                }),
            SizedBox(
              width: 32.w,
            ),
            Expanded(
              child: button(
                radius: 12.r,
                height: 42.h,
                onTap: () async {
                  String aiResponse = await controller.askAi(
                      input: controller.InputController.text.trim());
                  Get.toNamed(Routes.EXPLORE_RESPONSE, arguments: {
                    'category': controller.cat!,
                    'task': controller.task!,
                    'input': controller.InputController.text.trim(),
                    'response': aiResponse,
                  });
                  // Get.toNamed(Routes.EXPLORE_RESPONSE);
                },
                width: double.infinity,
                widget: Obx(
                  () => controller.isgenerating.value
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Generate',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            )
                          ],
                        ),
                ),
                backgroundColor: appTheme.primaryTheme,
              ),
            )
          ],
        ),
      ),
    );
  }
}
