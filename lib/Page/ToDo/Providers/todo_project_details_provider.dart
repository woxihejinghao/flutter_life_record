import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_database_tool.dart';
import 'package:flutter_life_record/Common/lr_instances.dart';
import 'package:flutter_life_record/Page/ToDo/Models/todo_list_item_model.dart';
import 'package:flutter_life_record/Page/ToDo/Models/todo_project_model.dart';
import 'package:flutter_life_record/Page/ToDo/Providers/todo_home_provider.dart';
import 'package:provider/provider.dart';

class ToDoProjectDetailsProvider extends ChangeNotifier {
  List<ToDoListItemModel> _itemList = [];

  List<ToDoListItemModel> get itemList => _itemList;

  late ToDoProjectModel _model;

  ToDoProjectModel get model => _model;
  ToDoProjectDetailsProvider(ToDoProjectModel model) {
    this._model = model;
    refreshItemList();
    refreshRecordList();
  }

  refreshRecordList() async {
    var list = await LRDataBaseTool.getInstance().queryRecordList();

    if (list.isNotEmpty) {
      print(list.first.itemModel.name);
    }
  }

  /// 刷新待办列表
  refreshItemList() async {
    _itemList =
        await LRDataBaseTool.getInstance().getToDoList(projectID: model.id);

    notifyListeners();
  }

  deleteItem(int id) async {
    var success = await LRDataBaseTool.getInstance().deleteToDoItem(id);
    if (success) {
      _itemList.removeWhere((element) => element.id == id);
    }

    ///更新今日待办
    currentContext.read<ToDoHomeProvider>().updateToDayItemList();
  }

  updateItemFinish(ToDoListItemModel model) async {
    model.lastFinishTime = DateTime.now().microsecond;
    await LRDataBaseTool.getInstance().updateToDoItem(model);
    await LRDataBaseTool.getInstance().insertRecord(model);
    refreshItemList();
  }

  ///更新名称外观
  setProjectModel(ToDoProjectModel model) {
    _model = model;
    notifyListeners();
  }
}
