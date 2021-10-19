import 'package:flutter_life_record/Common/lr_database_tool.dart';
import 'package:get/get.dart';

class ToDoHomeController extends GetxController {
  /// 项目列表
  var projectList = [].obs;

  /// 代办事项列表
  var itemList = [].obs;

  ToDoHomeController() {
    refreshProjectList();
    refreshItemList();
  }

  ///刷新列表
  refreshProjectList() async {
    var list = await LRDataBaseTool.getInstance().getToDoProjectList();
    projectList.assignAll(list);
  }

  //刷新代办列表
  refreshItemList() async {
    var list = await LRDataBaseTool.getInstance().getToDoList();
    itemList.assignAll(list);
  }

  ///删除代办项目
  deleteProject(int id) async {
    await LRDataBaseTool.getInstance().deleteToDoProject(id);
    refreshProjectList();
  }
}
