import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_color.dart';

class SwitchItem extends StatelessWidget {
  final String title;
  final String? subTitle;
  final bool isOn;
  final ValueChanged<bool>? valueChanged;
  final GestureTapCallback? onTap;

  const SwitchItem(
      {Key? key,
      this.title = "标题",
      this.subTitle,
      this.isOn = false,
      this.valueChanged,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        elevation: 2,
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
            value: this.isOn,
            onChanged: this.valueChanged,
          ),
        ),
      ),
      onTap: this.onTap,
    );
  }
}
