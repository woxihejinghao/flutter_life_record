import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_color.dart';
import 'package:flutter_life_record/Common/lr_tool.dart';

class SwitchItem extends StatelessWidget {
  final String title;
  final bool isOn;
  final ValueChanged<bool>? valueChanged;
  const SwitchItem(
      {Key? key, this.title = "标题", this.isOn = false, this.valueChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Text(
          this.title,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        trailing: CupertinoSwitch(
          value: this.isOn,
          onChanged: this.valueChanged,
          activeColor: LRThemeColor.mainColor,
        ),
      ),
      shape: LRTool.getBorderRadius(8),
    );
  }
}
