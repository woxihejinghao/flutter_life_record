import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_database_tool.dart';
import 'package:flutter_life_record/Page/ToDo/Models/todo_project_model.dart';

class ToDoProjectCreateViewModel {
  saveProject(String name, String color, IconData icon) async {
    var model = ToDoProjectModel();
    model.name = name;
    model.colorHex = color;
    model.setIcon(icon);
    await LRDataBaseTool.getInstance().insertToDoProject(model);
  }

  updateProject(ToDoProjectModel model) async {
    await LRDataBaseTool.getInstance().updateToDoProject(model);
  }
}
