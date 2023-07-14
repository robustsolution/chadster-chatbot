import 'package:flutter/material.dart';

import '../app/constants/color_constant.dart';
import '../app/constants/sizeConstant.dart';

GestureDetector button({
  double height = 50,
  double width = 341,
  String? title = "",
  Color? backgroundColor,
  Color? borderColor,
  Color? textColor,
  Widget? widget,
  double? fontsize = 14,
  double? radius = 6,
  GestureTapCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap ?? () {},
    child: Container(
      height: MySize.getHeight(height),
      width: MySize.getWidth(width),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius!),
        border: Border.all(
            color: (borderColor == null) ? Colors.transparent : borderColor,
            width: 1),
        color: (backgroundColor == null)
            ? appTheme.secondaryTheme
            : backgroundColor,
      ),
      alignment: Alignment.center,
      child: (widget != null)
          ? Center(child: widget)
          : Text(
              title!,
              style: TextStyle(
                  color: (textColor == null) ? Colors.white : textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: MySize.getHeight(fontsize!)),
            ),
    ),
  );
}
