import 'package:flutter_life_record/Common/lr_database_tool.dart';
import 'package:get/get.dart';

class ToDoProjectDetailsController extends GetxController {
  final itemList = [].obs;

  final int projectID;
  ToDoProjectDetailsController(this.projectID) {
    refreshItemList();
  }

  refreshItemList() async {
    var list =
        await LRDataBaseTool.getInstance().getToDoList(projectID: projectID);
    itemList.assignAll(list);
  }
}
