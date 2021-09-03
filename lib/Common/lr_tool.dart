import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class LRTool {
  ///获取圆角
  static ShapeBorder getBorderRadius(double size) {
    return RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(size)));
  }
}
