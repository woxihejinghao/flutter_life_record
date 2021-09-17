import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_database_tool.dart';
import 'package:flutter_life_record/Page/ToDo/Models/todo_project_model.dart';

class ToDoHomeViewModel with ChangeNotifier {
  List<ToDoProjectModel> _projectList = [];

  List<ToDoProjectModel> get projectList => _projectList;

  ToDoHomeViewModel() {
    refreshProjectList();
  }

  ///刷新待办列表
  refreshProjectList() async {
    _projectList = await LRDataBaseTool.getInstance().getToDoProjectList();
    notifyListeners();
  }
}
