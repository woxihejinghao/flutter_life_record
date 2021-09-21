import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_color.dart';
import 'package:flutter_life_record/Common/lr_tool.dart';

class SwitchItem extends StatelessWidget {
  final String title;
  final String? subTitle;
  final bool isOn;
  final ValueChanged<bool>? valueChanged;

  const SwitchItem(
      {Key? key,
      this.title = "标题",
      this.subTitle,
      this.isOn = false,
      this.valueChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          this.title,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        subtitle: this.subTitle == null
            ? null
            : Text(
                this.subTitle ?? "",
                style: TextStyle(color: LRThemeColor.mainColor),
              ),
        trailing: CupertinoSwitch(
          activeColor: LRThemeColor.mainColor,
          value: this.isOn,
          onChanged: this.valueChanged,
        ),
      ),
      shape: LRTool.getBorderRadius(8),
    );
  }
}
