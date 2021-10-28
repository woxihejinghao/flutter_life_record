import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_color.dart';
import 'package:flutter_life_record/Common/lr_tool.dart';
import 'package:flutter_life_record/Page/ToDo/Controller/todo_home_controller.dart';
import 'package:flutter_life_record/Page/ToDo/Models/todo_list_item_model.dart';
import 'package:flutter_life_record/Page/ToDo/Models/todo_project_model.dart';
import 'package:flutter_life_record/Page/ToDo/Pages/todo_list_time_select_page.dart';
import 'package:flutter_life_record/Page/ToDo/Pages/todo_project_select_page.dart';
import 'package:flutter_life_record/Page/ToDo/ViewModel/todo_item_create_viewModel.dart';
import 'package:flutter_life_record/Page/ToDo/Widgets/normal_list_tile.dart';
import 'package:flutter_life_record/Page/ToDo/Widgets/switch_item.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

class ToDoListCreatePage extends StatefulWidget {
  final ToDoListItemModel? model;
  const ToDoListCreatePage({Key? key, this.model}) : super(key: key);

  @override
  _ToDoListCreatePageState createState() => _ToDoListCreatePageState();
}

class _ToDoListCreatePageState extends State<ToDoListCreatePage> {
  late ToDoListItemModel _itemModel;

  ToDoProjectModel? _projectModel;

  ToDoItemCreateViewModel _viewModel = ToDoItemCreateViewModel();

  late TextEditingController _titleEditingController;
  late TextEditingController _remarkEditingController;
  final controller = Get.find<ToDoHomeController>();

  @override
  void initState() {
    super.initState();
    _projectModel = controller.projectList.first;
    if (widget.model == null) {
      _itemModel = ToDoListItemModel();
      _itemModel.projectID = _projectModel?.id ?? 0;
    } else {
      _itemModel = widget.model!;
    }
    _titleEditingController = TextEditingController(text: _itemModel.name);
    _remarkEditingController = TextEditingController(text: _itemModel.remark);

    _titleEditingController.addListener(() {
      _itemModel.name = _titleEditingController.text;
    });

    _remarkEditingController.addListener(() {
      _itemModel.remark = _remarkEditingController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("创建待办事项"),
        elevation: 0,
        actions: [
          TextButton(
              onPressed: saveToDoItem,
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
                subTitle: _projectModel?.name ?? "",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ToDoProjectSelectPage();
                  })).then((value) {
                    if (value is ToDoProjectModel) {
                      _projectModel = value;
                      setState(() {});
                    }
                  });
                },
              ),
              NormalListTile(
                title: "时间",
                subTitle: "${_itemModel.date ?? ""} ${_itemModel.time ?? ""}",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ToDoListTimeSelectPage();
                  })).then((value) {
                    if (value is Map<String, Object?>) {
                      Map<String, Object?> map = value;
                      _itemModel.date = map["date"] as String?;
                      _itemModel.time = map["time"] as String?;
                      _itemModel.cycle = map["cycle"] as bool?;
                      setState(() {});
                    }
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              SwitchItem(
                title: "优先",
                isOn: _itemModel.preferential ?? false,
                valueChanged: (isOn) {
                  setState(() {
                    _itemModel.preferential = isOn;
                  });
                },
              )
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

  ///创建待办
  saveToDoItem() async {
    if (_itemModel.name == null || _itemModel.name!.isEmpty) {
      showToast("请输入标题");
      return;
    }

    await _viewModel.saveToDoItem(_itemModel);
    controller.refreshItemList();
    Navigator.of(context).pop();
    showToast("创建成功");
  }
}
