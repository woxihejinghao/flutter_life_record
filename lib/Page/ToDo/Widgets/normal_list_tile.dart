import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_color.dart';
import 'package:flutter_life_record/Common/lr_tool.dart';

class NormalListTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final GestureTapCallback? onTap;
  final bool hideBackground; //隐藏背景，包括阴影圆角
  const NormalListTile(
      {Key? key,
      this.title = "标题",
      this.subTitle = "",
      this.onTap,
      this.hideBackground = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: hideBackground ? null : LRTool.getBorderRadius(8),
      elevation: hideBackground ? 0 : 1,
      margin: hideBackground ? EdgeInsets.all(1) : EdgeInsets.all(4),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 18),
        ),
        trailing: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              subTitle,
              style:
                  TextStyle(fontSize: 16, color: LRThemeColor.lightTextColor),
            ),
            SizedBox(
              width: 5,
            ),
            Icon(Icons.keyboard_arrow_right)
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
