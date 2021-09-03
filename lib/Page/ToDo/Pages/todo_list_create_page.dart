import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_color.dart';
import 'package:flutter_life_record/Common/lr_tool.dart';

class ToDoListCreatePage extends StatefulWidget {
  const ToDoListCreatePage({Key? key}) : super(key: key);

  @override
  _ToDoListCreatePageState createState() => _ToDoListCreatePageState();
}

class _ToDoListCreatePageState extends State<ToDoListCreatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("创建待办事项"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(left: 14, right: 14, top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              inputSection(),
              SizedBox(
                height: 20,
              ),
              cardItem("测试"),
              cardItem("测试2")
            ],
          ),
        ),
      ),
    );
  }

  Widget inputSection() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            maxLines: 1,
            style: TextStyle(fontSize: 18),
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "输入标题",
                contentPadding: EdgeInsets.only(left: 8, right: 8)),
          ),
          Divider(
            height: 0.5,
            color: LRThemeColor.lineColor,
          ),
          TextField(
            minLines: 5,
            maxLines: 5,
            style: TextStyle(fontSize: 18),
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "输入备注",
                contentPadding: EdgeInsets.only(left: 8, right: 8, top: 10)),
          )
        ],
      ),
      shape: LRTool.getBorderRadius(8),
    );
  }

  Widget cardItem(String title) {
    return Card(
      shape: LRTool.getBorderRadius(8),
      child: Container(
        height: 50,
        padding: EdgeInsets.only(left: 14, right: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: LRThemeColor.lightTextColor,
            )
          ],
        ),
      ),
      elevation: 1,
    );
  }
}
