import 'package:flutter/cupertino.dart';
import 'package:flutter_life_record/Common/lr_database_tool.dart';
import 'package:flutter_life_record/Page/ToDo/Models/todo_list_item_model.dart';
import 'package:flutter_life_record/Page/ToDo/Models/todo_project_model.dart';

class ToDoHomeProvider extends ChangeNotifier {
  /// 代办项目列表
  List<ToDoProjectModel> _projectList = [];

  ///今日代办列表
  List<ToDoListItemModel> _todayItemList = [];

  List<ToDoProjectModel> get projectList => _projectList;

  List<ToDoListItemModel> get todayItemList => _todayItemList;

  ToDoHomeProvider() {
    updateProjectList();
    updateToDayItemList();
  }
// 刷新代办项目列表
  updateProjectList() async {
    var list = await LRDataBaseTool.getInstance().getToDoProjectList();
    _projectList = list;
    notifyListeners();
  }

  //刷新今日代办列表
  updateToDayItemList() async {
    var list = await LRDataBaseTool.getInstance().getToDoList();
    _todayItemList = list;
    notifyListeners();
  }

  ///删除待办项目
  deleteProject(int id) async {
    await LRDataBaseTool.getInstance().deleteToDoProject(id);
    updateProjectList(); //刷新列表
  }

  updateItemFinish(ToDoListItemModel model) async {
    model.lastFinishTime = model.nextDateTime?.microsecondsSinceEpoch;

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
