import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_color.dart';
import 'package:flutter_life_record/Common/lr_database_tool.dart';
import 'package:flutter_life_record/Common/lr_tool.dart';
import 'package:flutter_life_record/Page/ToDo/Models/todo_list_item_model.dart';
import 'package:flutter_life_record/Page/ToDo/Models/todo_project_model.dart';
import 'package:flutter_life_record/Page/ToDo/Pages/todo_list_time_select_page.dart';
import 'package:flutter_life_record/Page/ToDo/Pages/todo_project_select_page.dart';
import 'package:flutter_life_record/Page/ToDo/Widgets/normal_list_tile.dart';

class ToDoListCreatePage extends StatefulWidget {
  final ToDoListItemModel? model;
  const ToDoListCreatePage({Key? key, this.model}) : super(key: key);

  @override
  _ToDoListCreatePageState createState() => _ToDoListCreatePageState();
}

class _ToDoListCreatePageState extends State<ToDoListCreatePage> {
  ToDoListItemModel? _itemModel;

  String? _projectName;

  late TextEditingController _titleEditingController;
  late TextEditingController _remarkEditingController;

  @override
  void initState() {
    super.initState();

    if (widget.model == null) {
      _itemModel = ToDoListItemModel();
    } else {
      _itemModel = widget.model;
    }
    _titleEditingController = TextEditingController(text: _itemModel?.name);
    _remarkEditingController = TextEditingController(text: _itemModel?.remark);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("创建待办事项"),
        elevation: 0,
        actions: [
          TextButton(
              onPressed: () {},
              child: Text(
                "添加",
                style: TextStyle(fontSize: 18, color: LRThemeColor.mainColor),
              ))
        ],
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
              NormalListTile(
                title: "列表",
                subTitle: _projectName ?? "",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ToDoProjectSelectPage();
                  })).then((value) {
                    if (value is ToDoProjectModel) {
                      ToDoProjectModel model = value;
                      _itemModel?.projectID = model.id;
                      _projectName = model.name;
                      setState(() {});
                    }
                  });
                },
              ),
              NormalListTile(
                title: "时间",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ToDoListTimeSelectPage();
                  })).then((value) {
                    if (value is Map<String, Object?>) {
                      Map<String, Object?> map = value;
                      _itemModel?.date = map["date"] as String?;
                      _itemModel?.time = map["time"] as String?;
                      _itemModel?.cycle = map["cycle"] as bool?;
                    }
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              switchCardItem(() {})
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
            controller: _titleEditingController,
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
            controller: _remarkEditingController,
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

  Widget switchCardItem(GestureTapCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: LRTool.getBorderRadius(8),
        child: Container(
          height: 50,
          padding: EdgeInsets.only(left: 14, right: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "优先",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              CupertinoSwitch(
                activeColor: LRThemeColor.mainColor,
                value: _itemModel?.preferential ?? false,
                onChanged: (isOn) {
                  setState(() {
                    _itemModel?.preferential = isOn;
                  });
                },
              )
            ],
          ),
        ),
        elevation: 1,
      ),
    );
  }

  //检查列表
  checkProjectName(int projectID) async {
    var model = await LRDataBaseTool.getInstance().getToDoProject(projectID);
    if (model != null) {
      setState(() {
        _projectName = model.name;
      });
    }
  }
}
