import 'package:flutter/material.dart';

class LRThemeColor {
  ///主题颜色
  static var mainColor = HexColor("#FF4040");

  ///字体颜色（999999）
  static var lightTextColor = HexColor("#999999");

  ///中等字体颜色（666666）
  static var mediumTextColor = HexColor("#666666");

  ///标题字体颜色 （333333）
  static var normalTextColor = HexColor("#333333");

  ///分割线颜色
  static var lineColor = HexColor("EFEFEF");
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
