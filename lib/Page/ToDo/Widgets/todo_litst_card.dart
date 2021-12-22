import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_life_record/Common/lr_color.dart';
import 'package:flutter_life_record/Page/ToDo/Models/todo_list_item_model.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:flutter_life_record/Extension/lr_extesion.dart';

class ToDoListCard extends StatefulWidget {
  final ToDoListItemModel? model;
  final bool isSelected;
  final GestureTapCallback? finishCallBack;
  final GestureTapCallback? onTap;

  ToDoListCard(
      {Key? key,
      this.model,
      this.isSelected = false,
      this.finishCallBack,
      this.onTap})
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
      child: InkWell(
        onTap: widget.onTap,
        child: Card(
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.only(left: 14, bottom: 10, top: 10),
            child: Row(
              children: [
                _buildFinishButton(),
                SizedBox(
                  width: 10,
                ),
                _buildTitleAndTime(),
                Expanded(child: Container()),
                if (widget.model!.preferential)
                  Icon(
                    Icons.star,
                    color: context.lrColorScheme.secondaryVariant,
                  ),
                SizedBox(
                  width: 14,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //标题和时间
  Column _buildTitleAndTime() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.model?.name ?? "",
          style: context.lrTextTheme.subtitle1!.copyWith(fontSize: 18),
        ),
        if (widget.model?.dateFormatterString != null)
          Text(
            widget.model!.dateFormatterString!,
            style: TextStyle(color: getTextColor(), fontSize: 16),
          )
      ],
    );
  }

  //完成按钮
  IconButton _buildFinishButton() {
    return IconButton(
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
        _timer = Timer.periodic(Duration(milliseconds: 250), (timer) {
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
          color:
              this.selected ? LRThemeColor.mainColor : LRThemeColor.lineColor),
    );
  }

  Color getTextColor() {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    DateTime? time = widget.model?.finishedDateTime;
    if (time == null) {
      return LRThemeColor.normalTextColor;
    }
    return time.isBefore(DateTime.now())
        ? colorScheme.error
        : LRThemeColor.normalTextColor;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
