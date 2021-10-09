import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_color.dart';
import 'package:flutter_life_record/Page/ToDo/Models/todo_list_item_model.dart';

class ToDoListCard extends StatelessWidget {
  final ToDoListItemModel? model;
  final bool isSelected;
  const ToDoListCard({Key? key, this.model, this.isSelected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Padding(
          padding: EdgeInsets.only(left: 14, bottom: 20, top: 20),
          child: Row(
            children: [
              Icon(
                this.isSelected
                    ? Icons.check_circle_outline
                    : Icons.radio_button_unchecked_outlined,
                size: 25,
                color: this.isSelected
                    ? LRThemeColor.mainColor
                    : LRThemeColor.lineColor,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                this.model?.name ?? "",
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
