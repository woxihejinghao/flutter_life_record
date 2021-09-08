import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_color.dart';

class ToDoListCard extends StatefulWidget {
  final bool isSelected;
  const ToDoListCard({Key? key, this.isSelected = false}) : super(key: key);

  @override
  _ToDoListCardState createState() => _ToDoListCardState();
}

class _ToDoListCardState extends State<ToDoListCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Padding(
          padding: EdgeInsets.only(left: 14),
          child: Row(
            children: [
              Icon(
                widget.isSelected
                    ? Icons.check_circle_outline
                    : Icons.radio_button_unchecked_outlined,
                size: 25,
                color: widget.isSelected
                    ? LRThemeColor.mainColor
                    : LRThemeColor.lineColor,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "标题",
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
      ),
    );
  }
}
