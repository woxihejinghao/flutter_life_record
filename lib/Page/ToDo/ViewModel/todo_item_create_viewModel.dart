import 'package:flutter_life_record/Common/lr_database_tool.dart';
import 'package:flutter_life_record/Page/ToDo/Models/todo_list_item_model.dart';

class ToDoItemCreateViewModel {
  Future<int> saveToDoItem(ToDoListItemModel model) async {
    var id = await LRDataBaseTool.getInstance().insertToDoItem(model);
    return id;
  }
}
