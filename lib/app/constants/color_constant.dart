import 'package:aichatapp/app/constants/sizeConstant.dart';
import 'package:flutter/material.dart';

class BaseTheme {
  Color get primaryTheme => fromHex("#47A082");
  Color get secondaryTheme => fromHex("#222222");
  Color get backgroundColor => fromHex("#F9F9F9");
  Color get backgroundAppBarColor => fromHex("#FAFAFA");
  Color get textGrayColor => fromHex("#f1f1f1");
  Color get textGrayColor2 => fromHex("#9A9A9A");
  Color get borderGrayColor => fromHex("#BBBBBB");
  Color get textBlackColor => fromHex("#1C1C1C");
  Color get greyColor => fromHex("#F2F2F2");
  Color get borderGreyColor => fromHex("#F2F2F2");
  Color get iconBlackColor => fromHex("#494949");

  List<BoxShadow> get getShadow {
    return [
      BoxShadow(
        offset: const Offset(2, 2),
        color: Colors.black26,
        blurRadius: MySize.getHeight(2),
        spreadRadius: MySize.getHeight(2),
      ),
      BoxShadow(
        offset: const Offset(-1, -1),
        color: Colors.white.withOpacity(0.8),
        blurRadius: MySize.getHeight(2),
        spreadRadius: MySize.getHeight(2),
      ),
    ];
  }

  List<BoxShadow> get getShadow3 {
    return [
      BoxShadow(
        offset: const Offset(2, 2),
        color: Colors.black12,
        blurRadius: MySize.getHeight(0.5),
        spreadRadius: MySize.getHeight(0.5),
      ),
      BoxShadow(
        offset: const Offset(-1, -1),
        color: Colors.white.withOpacity(0.8),
        blurRadius: MySize.getHeight(0.5),
        spreadRadius: MySize.getHeight(0.5),
      ),
    ];
  }

  List<BoxShadow> get getShadow2 {
    return [
      BoxShadow(
          offset: Offset(MySize.getWidth(2.5), MySize.getHeight(2.5)),
          color: const Color(0xffAEAEC0).withOpacity(0.4),
          blurRadius: MySize.getHeight(5),
          spreadRadius: MySize.getHeight(0.2)),
      BoxShadow(
          offset: Offset(MySize.getWidth(-1.67), MySize.getHeight(-1.67)),
          color: const Color(0xffFFFFFF),
          blurRadius: MySize.getHeight(5),
          spreadRadius: MySize.getHeight(0.2)),
    ];
  }
}

BaseTheme get appTheme => BaseTheme();

Color fromHex(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}
