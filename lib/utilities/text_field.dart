import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import '../app/constants/color_constant.dart';
import '../app/constants/sizeConstant.dart';

TextFormField getTextField({
  String? hintText,
  String? labelText,
  TextEditingController? textEditingController,
  Widget? prefixIcon,
  double? borderRadius,
  Widget? suffixIcon,
  double? size = 70,
  Widget? suffix,
  Color? borderColor,
  Color? fillColor,
  bool isFilled = false,
  Color? labelColor,
  TextInputType textInputType = TextInputType.name,
  TextInputAction textInputAction = TextInputAction.next,
  bool textVisible = false,
  bool readOnly = false,
  VoidCallback? onTap,
  int maxLine = 1,
  String errorText = "",
  Function(String)? onChange,
  FormFieldValidator<String>? validation,
  double fontSize = 15,
  double hintFontSize = 14,
  TextCapitalization textCapitalization = TextCapitalization.none,
}) {
  return TextFormField(
    controller: textEditingController,
    obscureText: textVisible,
    textInputAction: textInputAction,
    keyboardType: textInputType,
    textCapitalization: textCapitalization,
    cursorColor: appTheme.primaryTheme,
    readOnly: readOnly,
    validator: validation,
    onTap: onTap,
    maxLines: maxLine,
    onChanged: onChange,
    style: TextStyle(
      fontSize: MySize.getHeight(fontSize),
    ),
    decoration: InputDecoration(
      fillColor: fillColor ?? Colors.white,
      filled: isFilled,
      labelText: labelText,
      labelStyle: TextStyle(
          color: labelColor ?? appTheme.primaryTheme,
          fontWeight: FontWeight.w300),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor ?? appTheme.greyColor),
        borderRadius: BorderRadius.circular(
            (borderRadius == null) ? MySize.getHeight(5) : borderRadius),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
            (borderRadius == null) ? MySize.getHeight(5) : borderRadius),
        borderSide: BorderSide(color: borderColor ?? appTheme.primaryTheme),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
            (borderRadius == null) ? MySize.getHeight(5) : borderRadius),
        // borderSide: BorderSide(color: borderColor ?? appTheme.primaryTheme),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
            (borderRadius == null) ? MySize.getHeight(5) : borderRadius),
      ),
      contentPadding: EdgeInsets.only(
        left: MySize.getWidth(20),
        right: MySize.getWidth(10),
        bottom: size! / 2, // HERE THE IMPORTANT PART
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      suffix: suffix,
      errorMaxLines: 2,
      errorText: (isNullEmptyOrFalse(errorText)) ? null : errorText,
      hintText: hintText,
      hintStyle: TextStyle(
          fontSize: MySize.getHeight(hintFontSize),
          color: appTheme.iconBlackColor),
    ),
  );
}
