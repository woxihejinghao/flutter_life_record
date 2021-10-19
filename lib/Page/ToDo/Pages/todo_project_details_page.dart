import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_color.dart';
import 'package:flutter_life_record/Page/ToDo/Controller/todo_home_controller.dart';
import 'package:flutter_life_record/Page/ToDo/Controller/todo_project_details_controller.dart';
import 'package:flutter_life_record/Page/ToDo/Models/todo_project_model.dart';
import 'package:flutter_life_record/Page/ToDo/Pages/todo_project_create_page.dart';
import 'package:flutter_life_record/Page/ToDo/Widgets/todo_litst_card.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get.dart';

class ToDoProjectDetailsPage extends StatelessWidget {
  final ToDoProjectModel model;
  const ToDoProjectDetailsPage(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ToDoProjectDetailsController(this.model.id));
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            actions: [
              _editButtonWidget(),
            ],
            pinned: true,
            centerTitle: false,
            expandedHeight: 100,
            flexibleSpace: FlexibleSpaceBar(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(this.model.getIconData(),
                      color: HexColor(this.model.colorHex)),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    this.model.name,
                    style: TextStyle(color: HexColor(this.model.colorHex)),
                  )
                ],
              ),
              centerTitle: false,
            ),
          ),
          Obx(() => SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                var model = controller.itemList[index];
                return Container(
                  padding: EdgeInsets.only(left: 14, right: 14),
                  margin: EdgeInsets.only(top: 15),
                  child: Dismissible(
                      background: _deleteBackgroundWidget(),
                      key: ValueKey(model),
                      onDismissed: (d) => controller.deleteItem(model.id),
                      child: ToDoListCard(
                        model: model,
                      )),
                );
              }, childCount: controller.itemList.length)))
        ],
      ),
    );
  }

  //编辑按钮
  PopupMenuButton<int> _editButtonWidget() {
    return PopupMenuButton(
      child: Padding(
        padding: EdgeInsets.only(right: 10),
        child: Icon(Icons.edit),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Text("名称和外观"),
          value: 0,
        ),
        PopupMenuItem(
          child: Text(
            "删除列表",
            style: TextStyle(color: Colors.red),
          ),
          value: 1,
        )
      ],
      onSelected: (index) async {
        if (index == 0) {
          //修改名称外观
          Get.to(() => ToDoProjectCreatePage(
                model: this.model,
              ));
        } else if (index == 1) {
          //删除列表
          await showDialog(
              context: Get.context!,
              builder: (context) => AlertDialog(
                    title: Text("提示"),
                    content: Text("是否确认删除该列表"),
                    actions: [
                      TextButton(
                          onPressed: () => Get.back(),
                          child: Text(
                            "取消",
                            style:
                                TextStyle(color: LRThemeColor.lightTextColor),
                          )),
                      TextButton(
                          onPressed: () async {
                            ToDoHomeController homeController = Get.find();
                            await homeController.deleteProject(this.model.id);
                            Get.back();
                          },
                          child: Text(
                            "确认",
                            style: TextStyle(color: LRThemeColor.mainColor),
                          ))
                    ],
                  )).then((value) => Get.back());
        }
      },
    );
  }

  Padding _deleteBackgroundWidget() {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              "删除",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(8))),
      ),
    );
  }

  GetBuilder getItemList() {
    return GetBuilder<ToDoProjectDetailsController>(builder: (controller) {
      print("数量:${controller.itemList.length}");
      return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        var model = controller.itemList[index];
        return ToDoListCard(
          model: model,
        );
      }, childCount: controller.itemList.length));
    });
  }
}
