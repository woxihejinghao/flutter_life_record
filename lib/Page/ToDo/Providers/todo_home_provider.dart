import 'package:flutter/cupertino.dart';
import 'package:flutter_life_record/Common/lr_database_tool.dart';
import 'package:flutter_life_record/Page/ToDo/Models/todo_list_item_model.dart';
import 'package:flutter_life_record/Page/ToDo/Models/todo_project_model.dart';
import 'package:time/time.dart';

class ToDoHomeProvider extends ChangeNotifier {
  /// 代办项目列表
  List<ToDoProjectModel> _projectList = [];

  /// 待办项列表
  List<ToDoListItemModel> _itemList = [];

  /// 今天代办数量
  int _todayNum = 0;

  /// 全部数量
  int _totalNum = 0;

  List<ToDoProjectModel> get projectList => _projectList;

  int get todayNum => _todayNum;

  int get totalNum => _totalNum;

  ToDoHomeProvider() {
    updateProjectList();
    updateToDayItemList();
  }
// 刷新代办项目列表
  updateProjectList() async {
    var list = await LRDataBaseTool.getInstance().getToDoProjectList();
    _projectList = list;
    _updateNum();
  }

  //刷新今日代办列表
  updateToDayItemList() async {
    var list = await LRDataBaseTool.getInstance().getToDoList();
    _itemList = list;
    _totalNum = list.length;
    var newList = list.where((element) {
      DateTime time =
          DateTime.fromMicrosecondsSinceEpoch(element.finishTime ?? 0);
      return time.isToday;
    }).toList();
    _todayNum = newList.length;
    _updateNum();
  }

  ///更新数量
  _updateNum() async {
    _projectList.forEach((element) {
      element.itemCount = 0;
      _itemList.forEach((item) {
        if (item.projectID == element.id) {
          element.itemCount += 1;
        }
      });
    });

    notifyListeners();
  }

  ///删除待办项目
  deleteProject(int id) async {
    await LRDataBaseTool.getInstance().deleteToDoProject(id);
    updateProjectList(); //刷新列表
  }

  updateItemFinish(ToDoListItemModel model) async {
    model.finishTime = model.nextDateTime?.microsecondsSinceEpoch;

    if (model.cycleType != 0) {
      //如果待办事项不循环的话，插入数据
      var newModel = model;
      await LRDataBaseTool.getInstance().insertToDoItem(newModel);
    }

    model.finished = true;
    await LRDataBaseTool.getInstance().updateToDoItem(model);

    updateToDayItemList();
  }
}
