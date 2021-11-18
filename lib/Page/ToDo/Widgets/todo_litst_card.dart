import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_color.dart';
import 'package:flutter_life_record/Page/ToDo/Models/todo_list_item_model.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class ToDoListCard extends StatefulWidget {
  final ToDoListItemModel? model;
  final bool isSelected;
  final GestureTapCallback? finishCallBack;

  ToDoListCard(
      {Key? key, this.model, this.isSelected = false, this.finishCallBack})
      : super(key: key);

  @override
  _ToDoListCardState createState() => _ToDoListCardState();
}

class _ToDoListCardState extends State<ToDoListCard> {
  late bool selected;

  double _opacity = 1;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    this.selected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: Duration(milliseconds: 250),
      child: Container(
        child: Card(
          child: Padding(
            padding: EdgeInsets.only(left: 14, bottom: 10, top: 10),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    //触觉反馈
                    var _type = FeedbackType.impact;
                    Vibrate.feedback(_type);
                    setState(() {
                      //完成动画
                      this.selected = !this.selected;
                      _opacity = 0;
                    });
                    //倒计时完成
                    _timer =
                        Timer.periodic(Duration(milliseconds: 250), (timer) {
                      if (widget.finishCallBack != null) {
                        widget.finishCallBack!();
                      }
                    });
                  },
                  icon: Icon(
                      this.selected
                          ? Icons.check_circle_outline
                          : Icons.radio_button_unchecked_outlined,
                      size: 25,
                      color: this.selected
                          ? LRThemeColor.mainColor
                          : LRThemeColor.lineColor),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.model?.name ?? "",
                      style: TextStyle(
                          fontSize: 20,
                          color: widget.isSelected
                              ? LRThemeColor.lightTextColor
                              : LRThemeColor.normalTextColor,
                          decoration: widget.isSelected
                              ? TextDecoration.lineThrough
                              : null),
                    ),
                    if (widget.model?.nextDateTime != null)
                      Text(
                          "${formatDate(widget.model?.nextDateTime ?? DateTime.now(), [
                            yyyy,
                            '-',
                            mm,
                            '-',
                            dd
                          ])}")
                  ],
                )
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
