import 'package:flutter_life_record/Common/lr_database_tool.dart';
import 'package:flutter_life_record/Page/ToDo/Controller/todo_home_controller.dart';
import 'package:flutter_life_record/Page/ToDo/Models/todo_list_item_model.dart';
import 'package:get/get.dart';

class ToDoProjectDetailsController extends GetxController {
  final itemList = <ToDoListItemModel>[].obs;

  final int projectID;
  ToDoProjectDetailsController(this.projectID) {
    refreshItemList();
  }

  refreshItemList() async {
    var list =
        await LRDataBaseTool.getInstance().getToDoList(projectID: projectID);

    itemList.assignAll(list);
  }

  deleteItem(int id) async {
    await LRDataBaseTool.getInstance().deleteToDoItem(id);
    refreshItemList();

    ///刷新今日代办
    var homeController = Get.find<ToDoHomeController>();
    homeController.refreshItemList();
  }

  updateItemFinish(ToDoListItemModel model) {
    model.lastFinishTime = DateTime.now().microsecond;
    refreshItemList();
  }
}
