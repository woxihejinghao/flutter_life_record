import 'package:flutter_life_record/Page/ToDo/Models/todo_list_item_model.dart';
import 'package:flutter_life_record/Extension/lr_extesion.dart';

const String ToDoRecordTable = "todo_list_records";

class ToDoListRecordModel {
  late int id;
  late int finishTime; //完成的时间戳
  late String todoItemJson;
  String? remark; //备注

  ToDoListItemModel? _itemModel;

  ///待办数据
  ToDoListItemModel get itemModel {
    if (_itemModel != null) {
      return _itemModel!;
    }
    Map<String, Object?> map = todoItemJson.convertToObject();

    _itemModel = ToDoListItemModel.fromeMap(map);
    return _itemModel!;
  }

  ToDoListRecordModel() {
    finishTime = DateTime.now().microsecondsSinceEpoch;
  }

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      "finishTime": finishTime,
      "remark": remark,
      "todoItemJson": todoItemJson
    };

    return map;
  }

  ToDoListRecordModel.fromMap(Map<String, Object?> map) {
    id = map["id"] as int;
    finishTime = map["finishTime"] as int;
    remark = map["remark"] as String?;

    todoItemJson = map["todoItemJson"] as String;
  }
}
