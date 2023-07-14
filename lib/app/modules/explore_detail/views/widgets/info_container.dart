import 'package:aichatapp/app/constants/app_constant.dart';
import 'package:aichatapp/app/constants/color_constant.dart';
import 'package:aichatapp/app/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InfoContainer extends StatelessWidget {
  final Task task;
  const InfoContainer({required this.task, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.h),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: appTheme.greyColor, width: 1.h),
        color: Colors.white,
      ),
      child: Column(
        children: [
          task.imageUrl.isEmpty
              ? SvgPicture.asset(
                  '${imagePath}home_custom_icon.svg',
                  height: 40.h,
                  width: 40.h,
                )
              : SvgPicture.network(
                  task.imageUrl,
                  height: 40.h,
                  width: 40.h,
                ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            task.title,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
              color: appTheme.textBlackColor,
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            task.desc!,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: appTheme.iconBlackColor),
          ),
        ],
      ),
    );
  }
}
