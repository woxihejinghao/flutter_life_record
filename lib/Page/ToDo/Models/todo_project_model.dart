import 'package:flutter/material.dart';
import 'dart:convert' as convert;

final String tableToDoProject = "todo_project";

class ToDoProjectModel {
  late int id;
  late String icon;
  late String name;
  late String colorHex;
  late int createTime;

  ///列表下的待办数量，不写入数据库
  int itemCount = 0;

  setIcon(IconData iconData) {
    Map<String, Object?> map = {
      "codePoint": iconData.codePoint,
      "fontFamily": iconData.fontFamily,
      "fontPackage": iconData.fontPackage
    };
    String iconStirng = convert.jsonEncode(map);
    this.icon = iconStirng;
  }

  IconData getIconData() {
    Map<String, Object?> map = convert.jsonDecode(this.icon);
    int codePoint = map["codePoint"] as int;
    var fontFamily = map["fontFamily"] as String?;
    var fontPackage = map["fontPackage"] as String?;
    IconData iconData =
        IconData(codePoint, fontFamily: fontFamily, fontPackage: fontPackage);

    return iconData;
  }

  ToDoProjectModel() {
    createTime = DateTime.now().microsecondsSinceEpoch;
  }

  Map<String, Object> toMap() {
    var map = <String, Object>{
      "icon": icon,
      "name": name,
      "color": colorHex,
      "createTime": createTime
    };

    return map;
  }

  ToDoProjectModel.fromMap(Map<String, Object?> map) {
    id = map["id"] as int;
    icon = map["icon"] as String;
    name = map["name"] as String;
    colorHex = map["color"] as String;
    createTime = map["createTime"] as int;
  }
}
