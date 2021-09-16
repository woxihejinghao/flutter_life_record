import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_color.dart';
import 'package:flutter_life_record/Common/lr_database_tool.dart';
import 'package:flutter_life_record/Page/ToDo/Models/todo_project_model.dart';
import 'package:flutter_life_record/Page/ToDo/Widgets/todo_project_card.dart';

class ToDoProjectSelectPage extends StatefulWidget {
  const ToDoProjectSelectPage({Key? key}) : super(key: key);

  @override
  _ToDoProjectSelectPageState createState() => _ToDoProjectSelectPageState();
}

class _ToDoProjectSelectPageState extends State<ToDoProjectSelectPage> {
  List<ToDoProjectModel> _projectList = [];

  @override
  void initState() {
    super.initState();
    requestProjectList();
  }

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
            ToDoProjectModel model = _projectList[index];
            return GestureDetector(
              child: ToDoProjectCard(
                color: HexColor(model.colorHex),
                title: model.name,
                iconData: model.getIconData(),
              ),
              onTap: () {
                Navigator.of(context).pop(model);
              },
            );
          },
          itemCount: _projectList.length,
        ),
      ),
    );
  }

  requestProjectList() async {
    _projectList = await LRDataBaseTool.getInstance().getToDoProjectList();
    setState(() {});
  }
}
