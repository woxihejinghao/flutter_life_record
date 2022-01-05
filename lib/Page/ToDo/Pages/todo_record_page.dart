import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ToDoRecordPage extends StatefulWidget {
  const ToDoRecordPage({Key? key}) : super(key: key);

  @override
  _ToDoRecordPageState createState() => _ToDoRecordPageState();
}

class _ToDoRecordPageState extends State<ToDoRecordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("统计"),
      ),
    );
  }
}
