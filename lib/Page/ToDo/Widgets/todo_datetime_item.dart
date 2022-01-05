import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_color.dart';

class ToDoDateTimeItem extends StatelessWidget {
  final String title;
  final String? subTitle;
  final GestureTapCallback? delCallBack;
  final GestureTapCallback? onTap;
  final bool showDelButton;
  const ToDoDateTimeItem(this.title,
      {Key? key, this.subTitle, this.delCallBack, this.onTap, this.showDelButton = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        title: Text(
          this.title,
          style: TextStyle(fontSize: 18),
        ),
        onTap: this.onTap,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (this.subTitle != null)
              Text(
                this.subTitle ?? "",
                style: TextStyle(fontSize: 16, color: LRThemeColor.lightTextColor),
              ),
            _buildRightItem()
          ],
        ),
      ),
    );
  }

  Widget _buildRightItem() {
    if (this.showDelButton) {
      return IconButton(
        onPressed: () {
          this.delCallBack!();
        },
        icon: Icon(Icons.highlight_off),
      );
    } else {
      return Icon(Icons.keyboard_arrow_right);
    }
  }
}
