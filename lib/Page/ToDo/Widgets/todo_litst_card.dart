import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_color.dart';
import 'package:flutter_life_record/Page/ToDo/Models/todo_list_item_model.dart';
import 'package:date_format/date_format.dart';

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
  @override
  void initState() {
    super.initState();
    this.selected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Padding(
          padding: EdgeInsets.only(left: 14, bottom: 10, top: 10),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    this.selected = !this.selected;
                  });
                  if (widget.finishCallBack != null) {
                    widget.finishCallBack!();
                  }
                },
                icon: Icon(
                  widget.isSelected
                      ? Icons.check_circle_outline
                      : Icons.radio_button_unchecked_outlined,
                  size: 25,
                  color: LRThemeColor.lineColor,
                ),
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
                  if (widget.model?.lastFinishDateTime != null)
                    Text(
                        "${formatDate(widget.model?.lastFinishDateTime ?? DateTime.now(), [
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
    );
  }
}
