import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_color.dart';
import 'package:flutter_life_record/Page/ToDo/Widgets/todo_project_card.dart';

class ToDoProjectSelectPage extends StatefulWidget {
  const ToDoProjectSelectPage({Key? key}) : super(key: key);

  @override
  _ToDoProjectSelectPageState createState() => _ToDoProjectSelectPageState();
}

class _ToDoProjectSelectPageState extends State<ToDoProjectSelectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("选择列表"),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 14, right: 14),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 180 / 120.0,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
          itemBuilder: (context, index) {
            return ToDoProjectCard(
              color: LRThemeColor.mainColor,
            );
          },
          itemCount: 50,
        ),
      ),
    );
  }
}
