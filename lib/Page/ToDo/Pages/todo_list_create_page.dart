import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_color.dart';
import 'package:flutter_life_record/Common/lr_database_tool.dart';
import 'package:flutter_life_record/Common/lr_instances.dart';
import 'package:flutter_life_record/Common/lr_route.dart';
import 'package:flutter_life_record/Common/lr_tool.dart';
import 'package:flutter_life_record/Page/ToDo/Models/todo_list_item_model.dart';
import 'package:flutter_life_record/Page/ToDo/Models/todo_project_model.dart';
import 'package:flutter_life_record/Page/ToDo/Pages/todo_cycle_type_select_page.dart';
import 'package:flutter_life_record/Page/ToDo/Pages/todo_project_select_page.dart';
import 'package:flutter_life_record/Page/ToDo/Providers/todo_home_provider.dart';
import 'package:flutter_life_record/Page/ToDo/Providers/todo_project_details_provider.dart';
import 'package:flutter_life_record/Page/ToDo/Widgets/normal_list_tile.dart';
import 'package:flutter_life_record/Page/ToDo/Widgets/switch_item.dart';
import 'package:flutter_life_record/Page/ToDo/Widgets/todo_datetime_item.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:oktoast/oktoast.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

///重复类型
const Map cycleTypeMap = {0: "从不", 1: "每天", 2: "每周", 3: "每月", 4: "每年"};

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
      _hideCycleItem = _itemModel.datetime == null;
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
                widget.model != null ? "保存" : "添加",
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
          // ToDoDataTimeitem(
          //   "日期",
          //   subTitle: _itemModel.date == null ? "选择日期" : _itemModel.date!,
          //   onTap: _selectDate,
          //   showDelButton: _itemModel.date != null,
          //   delCallBack: () => setState(() {
          //     _itemModel.date = null;
          //   }),
          // ),
          ToDoDataTimeitem(
            "时间",
            subTitle: _itemModel.datetime == null
                ? "选择时间"
                : formatDate(
                    DateTime.fromMicrosecondsSinceEpoch(_itemModel.datetime!),
                    [yyyy, '/', mm, '/', dd, ' ', HH, ':', nn]),
            showDelButton: _itemModel.datetime != null,
            onTap: _selectDate,
            delCallBack: () => setState(() {
              _itemModel.datetime = null;
            }),
          ),
          Offstage(
            offstage: _hideCycleItem,
            child: AnimatedOpacity(
              opacity: _itemModel.datetime == null ? 0 : 1,
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
    if (widget.model == null) {
      //插入待办事项
      await LRDataBaseTool.getInstance().insertToDoItem(_itemModel);
    } else {
      //更新待办事项
      await LRDataBaseTool.getInstance().updateToDoItem(_itemModel);
    }
    // 更新首页数据
    currentContext.read<ToDoHomeProvider>().updateToDayItemList();
    context.read<ToDoProjectDetailsProvider?>()?.refreshItemList(); //更新待办详情
    Navigator.of(context).pop();
  }

  ///选择日期
  _selectDate() async {
    double height = MediaQuery.of(context).size.height * 0.25;
    if (height > 250) {
      height = 250;
    } else if (height < 200) {
      height = 200;
    }
    Picker(
        adapter: DateTimePickerAdapter(type: PickerDateTimeType.kYMDHM),
        height: height,
        title: Text("请选择时间"),
        cancelText: "取消",
        confirmText: "确认",
        cancelTextStyle:
            TextStyle(fontSize: 16, color: LRThemeColor.lightTextColor),
        confirmTextStyle:
            TextStyle(fontSize: 16, color: LRThemeColor.mainColor),
        onConfirm: (picker, data) {
          var time = (picker.adapter as DateTimePickerAdapter).value;
          if (time != null) {
            setState(() {
              _itemModel.finishTime = null;
              _itemModel.datetime = time.microsecondsSinceEpoch;
            });
          }
        },
        footer: Container(
          color: Colors.white,
          child: SafeArea(child: Container()),
        )).showModal(context);
  }
}
