import 'package:flutter/material.dart';

class ToDoProjectCard extends StatefulWidget {
  const ToDoProjectCard({Key? key}) : super(key: key);

  @override
  _ToDoProjectCardState createState() => _ToDoProjectCardState();
}

class _ToDoProjectCardState extends State<ToDoProjectCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.access_alarms),
            SizedBox(
              height: 8,
            ),
            Text("标题")
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      elevation: 2,
    );
  }
}
