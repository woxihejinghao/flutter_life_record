import 'package:flutter/material.dart';

class ToDoListCard extends StatefulWidget {
  const ToDoListCard({Key? key}) : super(key: key);

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
                Icons.access_alarm,
                size: 25,
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
