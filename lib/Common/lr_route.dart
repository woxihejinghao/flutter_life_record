import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_instances.dart';

/// MaterialPageRoute 页面跳转扩展方法
lrPushPage(Widget page) {
  navigatorState.push(MaterialPageRoute(builder: (ctx) => page));
}
