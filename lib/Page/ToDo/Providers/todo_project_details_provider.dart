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
    // refreshRecordList();
  }

  /// 刷新待办列表
  refreshItemList() async {
    _itemList =
        await LRDataBaseTool.getInstance().getToDoList(projectID: model.id);

    notifyListeners();
  }

  deleteItem(int id) async {
    var num = await LRDataBaseTool.getInstance().deleteToDoItem(id);
    if (num > 0) {
      _itemList.removeWhere((element) => element.id == id);
    }

    ///更新今日待办
    currentContext.read<ToDoHomeProvider>().updateToDayItemList();
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

    currentContext.read<ToDoHomeProvider>().updateToDayItemList(); //更新首页数据
    refreshItemList();
  }

  ///更新名称外观
  setProjectModel(ToDoProjectModel model) {
    _model = model;
    notifyListeners();
  }
}
