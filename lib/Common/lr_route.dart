import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_instances.dart';

/// MaterialPageRoute 页面跳转扩展方法
Future lrPushPage(Widget page) async {
  return navigatorState.push(CupertinoPageRoute(builder: (ctx) => page));
}
