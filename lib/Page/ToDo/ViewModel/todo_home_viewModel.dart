import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_database_tool.dart';
import 'package:flutter_life_record/Page/ToDo/Models/todo_list_item_model.dart';
import 'package:flutter_life_record/Page/ToDo/Models/todo_project_model.dart';

class ToDoHomeViewModel with ChangeNotifier {
  List<ToDoProjectModel> _projectList = [];

  List<ToDoListItemModel> _itemList = [];

  List<ToDoProjectModel> get projectList => _projectList;
  List<ToDoListItemModel> get itemList => itemList;

  ToDoHomeViewModel() {
    refreshProjectList();
  }

  ///刷新待办列表
  refreshProjectList() async {
    _projectList = await LRDataBaseTool.getInstance().getToDoProjectList();
    notifyListeners();
  }

  //刷新代办列表
  refreshItemList() async {
    _itemList = await LRDataBaseTool.getInstance().getToDoList(null, null, null);
    notifyListeners();
  }
}
