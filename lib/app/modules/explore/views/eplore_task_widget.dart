import 'package:aichatapp/app/constants/app_constant.dart';
import 'package:aichatapp/app/constants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExploreTaskWidget extends StatelessWidget {
  final String? icon;
  final String title;
  final String desc;
  final Function() onPressed;
  const ExploreTaskWidget(
      {super.key,
      required this.icon,
      required this.title,
      required this.desc,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Bounce(
      duration: Duration(milliseconds: 300),
      onPressed: onPressed,
      child: Container(
        padding: EdgeInsets.all(12.h),
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: appTheme.greyColor, width: 1.h),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 40.h,
                  width: 40.w,
                  decoration: BoxDecoration(
                    color: appTheme.greyColor,
                    shape: BoxShape.circle,
                  ),
                  child: icon == null || icon!.isEmpty
                      ? SvgPicture.asset(
                          '${imagePath}home_custom_icon.svg',
                          height: 20.h,
                          width: 20.h,
                        )
                      : SvgPicture.network(
                          icon!,
                          height: 20.h,
                          width: 20.h,
                        ),
                ),
                SizedBox(
                  width: 12.w,
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 12.w,
            ),
            Text(
              desc,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
                color: appTheme.textGrayColor2,
              ),
            )
          ],
        ),
      ),
    );
  }
}
