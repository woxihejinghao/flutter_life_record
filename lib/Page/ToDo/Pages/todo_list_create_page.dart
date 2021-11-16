import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_color.dart';
import 'package:flutter_life_record/Common/lr_instances.dart';
import 'package:flutter_life_record/Common/lr_route.dart';
import 'package:flutter_life_record/Common/lr_tool.dart';
import 'package:flutter_life_record/Page/ToDo/Models/todo_list_item_model.dart';
import 'package:flutter_life_record/Page/ToDo/Models/todo_project_model.dart';
import 'package:flutter_life_record/Page/ToDo/Pages/todo_cycle_type_select_page.dart';
import 'package:flutter_life_record/Page/ToDo/Pages/todo_list_time_select_page.dart';
import 'package:flutter_life_record/Page/ToDo/Pages/todo_project_select_page.dart';
import 'package:flutter_life_record/Page/ToDo/Providers/todo_home_provider.dart';
import 'package:flutter_life_record/Page/ToDo/Providers/todo_project_details_provider.dart';
import 'package:flutter_life_record/Page/ToDo/ViewModel/todo_item_create_viewModel.dart';
import 'package:flutter_life_record/Page/ToDo/Widgets/normal_list_tile.dart';
import 'package:flutter_life_record/Page/ToDo/Widgets/switch_item.dart';
import 'package:flutter_life_record/Page/ToDo/Widgets/todo_datetime_item.dart';
import 'package:oktoast/oktoast.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class ToDoListCreatePage extends StatefulWidget {
  final ToDoListItemModel? model;
  final int? projectID;
  const ToDoListCreatePage({Key? key, this.model, this.projectID})
      : super(key: key);

  @override
  _ToDoListCreatePageState createState() => _ToDoListCreatePageState();
}

class _ToDoListCreatePageState extends State<ToDoListCreatePage> {
  late ToDoListItemModel _itemModel;

  ToDoProjectModel? _projectModel;

  ToDoItemCreateViewModel _viewModel = ToDoItemCreateViewModel();

  late TextEditingController _titleEditingController;
  late TextEditingController _remarkEditingController;

  ///隐藏循环类型选项
  bool _hideCycleItem = true;

  @override
  void initState() {
    super.initState();
    if (widget.projectID != null) {
      _projectModel = context
          .read<ToDoHomeProvider>()
          .projectList
          .firstWhere((element) => element.id == widget.projectID);
    } else {
      _projectModel = context.read<ToDoHomeProvider>().projectList.first;
    }

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
              onPressed: _saveToDoItem,
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
              _inputSection(),
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
              _buildTimeItem(),
              SizedBox(
                height: 20,
              ),
              SwitchItem(
                title: "优先",
                isOn: _itemModel.preferential,
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

  //时间
  Widget _buildTimeItem() {
    return Card(
      child: Column(
        children: [
          ToDoDataTimeitem(
            "日期",
            subTitle: _itemModel.date == null ? "选择日期" : _itemModel.date!,
            onTap: _selectDate,
            showDelButton: _itemModel.date != null,
            delCallBack: () => setState(() {
              _itemModel.date = null;
            }),
          ),
          ToDoDataTimeitem(
            "时间",
            subTitle: _itemModel.time == null ? "选择时间" : _itemModel.time!,
            showDelButton: _itemModel.time != null,
            onTap: _selectTime,
            delCallBack: () => setState(() {
              _itemModel.time = null;
            }),
          ),
          Offstage(
            offstage: _hideCycleItem,
            child: AnimatedOpacity(
              opacity: _itemModel.date == null ? 0 : 1,
              duration: Duration(microseconds: 200),
              child: NormalListTile(
                title: "重复",
                hideBackground: true,
                subTitle: cycleTypeMap[_itemModel.cycleType],
                onTap: () => lrPushPage(ToDoCyclyeTypeSelectPage(
                  selectedType: _itemModel.cycleType,
                )).then((value) {
                  if (value != null) {
                    setState(() {
                      _itemModel.cycleType = value;
                    });
                  }
                }),
              ),
              onEnd: () {
                setState(() {
                  _hideCycleItem = !_hideCycleItem;
                });
              },
            ),
          ),
        ],
      ),
      shape: LRTool.getBorderRadius(8),
    );
  }

//标题和备注
  Widget _inputSection() {
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
  _saveToDoItem() async {
    if (_itemModel.name == null || _itemModel.name!.isEmpty) {
      showToast("请输入标题");
      return;
    }

    await _viewModel.saveToDoItem(_itemModel);
    currentContext.read<ToDoHomeProvider>().updateToDayItemList();
    context.read<ToDoProjectDetailsProvider>().refreshItemList();
    Navigator.of(context).pop();
    showToast("创建成功");
  }

  ///选择日期
  _selectDate() async {
    DateTime? dateTime = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1800, 1),
        lastDate: DateTime(9999, 12),
        builder: (context, child) {
          return Theme(
              data: ThemeData(
                  cardColor: LRThemeColor.mainColor,
                  primaryColorLight: LRThemeColor.mainColor,
                  brightness: Brightness.light),
              child: child!);
        });
    if (dateTime != null) {
      setState(() {
        _itemModel.date = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
      });
    }
  }

  ///选择时间
  _selectTime() async {
    TimeOfDay initialTime = TimeOfDay.now();
    TimeOfDay? result =
        await showTimePicker(context: context, initialTime: initialTime);
    if (result != null) {
      setState(() {
        _itemModel.time = "${result.hour}:${result.minute}";
        if (_itemModel.date == null) {
          DateTime now = DateTime.now();
          _itemModel.date = "${now.year}-${now.month}-${now.day}";
        }
      });
    }
  }
}
