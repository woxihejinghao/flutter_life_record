import 'dart:convert' as convert;

import 'package:flutter/material.dart';

extension LRObject on Object {
  ///转换成JSON字符串
  String convertToJson() {
    return convert.jsonEncode(this);
  }

  ///字符串转对象
  dynamic convertToObject() {
    return convert.jsonDecode(this as String);
  }
}

extension LRTheme on BuildContext {
  /// 主题
  ThemeData get lrThemeData {
    return Theme.of(this);
  }

  /// 颜色集合
  ColorScheme get lrColorScheme {
    return this.lrThemeData.colorScheme;
  }

  /// 文本主题
  TextTheme get lrTextTheme {
    return this.lrThemeData.textTheme;
  }
}
