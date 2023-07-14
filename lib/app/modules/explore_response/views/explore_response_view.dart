import 'package:aichatapp/app/constants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../constants/sizeConstant.dart';
import '../controllers/explore_response_controller.dart';

class ExploreResponseView extends GetView<ExploreResponseController> {
  const ExploreResponseView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // // title: const Text('ExploreResponseView'),
          // centerTitle: true,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        bottomNavigationBar: InkWell(
          onTap: () {
            Get.back(result: {
              'task': controller.task,
              'cat': controller.category,
            });
          },
          child: Container(
            height: 42.h,
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 24.w),
            decoration: BoxDecoration(
                color: appTheme.primaryTheme,
                borderRadius: BorderRadius.circular(24.r)),
            child: Text(
              'Regenerate',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      controller.response,
                      textAlign: TextAlign.justify,
                      style: TextStyle(height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20.h,
              right: 10.w,
              child: Row(
                children: [
                  RsponseButton(
                    title: 'Copy',
                    icon: 'assets/image/icon_copy.svg',
                    onTap: () {
                      Get.snackbar('Copied', 'Text has been copied',
                          backgroundColor: appTheme.primaryTheme,
                          colorText: Colors.white);

                      Clipboard.setData(
                        ClipboardData(text: controller.response),
                      );
                    },
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  RsponseButton(
                    title: 'Share',
                    icon: 'assets/image/share-alt-svgrepo-com.svg',
                    onTap: () {
                      Share.share(controller.response);
                      // Get.snackbar('Copied', 'Text has been copied',
                      //     backgroundColor: appTheme.primaryTheme,
                      //     colorText: Colors.white);

                      // Clipboard.setData(
                      //   ClipboardData(text: controller.response),
                      // );
                    },
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

class RsponseButton extends StatelessWidget {
  RsponseButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          alignment: Alignment.center,
          // padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
          width: 75.w,
          height: 30.h,
          decoration: BoxDecoration(
              color: appTheme.primaryTheme,
              borderRadius: BorderRadius.circular(6.r)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                width: MySize.getWidth(20),
                fit: BoxFit.fitWidth,
                color: Colors.white,
                height: MySize.getHeight(20),
              ),
              SizedBox(
                width: 5.w,
              ),
              Text(
                title,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        onTap: onTap);
  }
}
