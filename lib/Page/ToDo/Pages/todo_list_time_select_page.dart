import 'package:flutter/material.dart';

class ToDoListTimeSelectPage extends StatefulWidget {
  const ToDoListTimeSelectPage({Key? key}) : super(key: key);

  @override
  _ToDoListTimeSelectPageState createState() => _ToDoListTimeSelectPageState();
}

class _ToDoListTimeSelectPageState extends State<ToDoListTimeSelectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("时间设置"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          ListTile(
            title: Text("日期"),
            trailing: Icon(Icons.arrow_forward_ios),
          )
        ],
      ),
    );
  }
}
