import 'package:flutter/material.dart';
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
              IconButton(
                  onPressed: () => Get.to(ToDoProjectCreatePage(
                        model: this.model,
                      )),
                  icon: Icon(Icons.settings))
            ],
            pinned: true,
            centerTitle: false,
            expandedHeight: 100,
            flexibleSpace: FlexibleSpaceBar(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(this.model.getIconData()),
                  Text(
                    this.model.name,
                    style: TextStyle(color: Colors.black),
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
                  child: ToDoListCard(
                    model: model,
                  ),
                );
              }, childCount: controller.itemList.length)))
        ],
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
