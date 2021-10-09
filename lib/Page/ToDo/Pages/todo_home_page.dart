import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_color.dart';
import 'package:flutter_life_record/Common/lr_tool.dart';
import 'package:flutter_life_record/Page/ToDo/Controller/todo_home_controller.dart';
import 'package:flutter_life_record/Page/ToDo/Models/todo_project_model.dart';
import 'package:flutter_life_record/Page/ToDo/Pages/todo_list_create_page.dart';
import 'package:flutter_life_record/Page/ToDo/Pages/todo_project_details_page.dart';
import 'package:flutter_life_record/Page/ToDo/Widgets/todo_litst_card.dart';
import 'package:flutter_life_record/Page/ToDo/widgets/todo_project_card.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get.dart';

class ToDoHomePage extends StatefulWidget {
  const ToDoHomePage({Key? key}) : super(key: key);

  @override
  _ToDoHomePageState createState() => _ToDoHomePageState();
}

class _ToDoHomePageState extends State<ToDoHomePage> {
  String timeString = "";
  final controller = Get.put(ToDoHomeController());
  @override
  void initState() {
    var now = DateTime.now();
    timeString = "${now.year}年 ${now.month}月 ${now.day}日";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            centerTitle: false,
            expandedHeight: 100,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                timeString,
                style: TextStyle(color: Colors.black),
              ),
              titlePadding: EdgeInsets.fromLTRB(20, 0, 0, 20),
              centerTitle: false,
              collapseMode: CollapseMode.parallax,
            ),
          ),
          todoProject(), //项目列表
          SliverToBoxAdapter(
            //今日待办
            child: Container(
              margin: EdgeInsets.only(left: 14, bottom: 14),
              child: Text(
                "今日待办",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          todayToDoList(),

          SliverToBoxAdapter(
            child: SafeArea(
                child: Container(
              alignment: Alignment.center,
              child: Text("到底了，努力完成吧~"),
            )),
          )
        ],
      ),

      floatingActionButton: Obx(() => FloatingActionButton(
            onPressed: () => Get.to(() => ToDoListCreatePage()),
            child: Icon(
              Icons.add,
              size: 25,
            ),
            backgroundColor: controller.projectList.isNotEmpty
                ? LRThemeColor.mainColor
                : LRThemeColor.lightTextColor,
          )),

      // floatingActionButton: Selector<ToDoHomeViewModel, bool>(
      //   selector: (context, provider) => provider.projectList.isNotEmpty,
      //   child: Icon(
      //     Icons.add,
      //     size: 25,
      //   ),
      //   builder: (context, value, child) {
      //     return FloatingActionButton(
      //       onPressed: () async {
      //         if (!value) {
      //           showToast("请创建列表");
      //           return;
      //         }
      //         //创建
      //         Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //                 builder: (context) {
      //                   return ConsumerSingleWidget<ToDoHomeViewModel>(
      //                       child: ToDoListCreatePage(
      //                     model: null,
      //                   ));
      //                 },
      //                 fullscreenDialog: true));
      //       },
      //       child: child,
      //       backgroundColor:
      //           value ? LRThemeColor.mainColor : LRThemeColor.lightTextColor,
      //     );
      //   },
      // ),
    );
  }

//今日代表
  Obx todayToDoList() {
    return Obx(() => SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          var model = controller.itemList[index];
          return Container(
            padding: EdgeInsets.only(left: 14, right: 14),
            margin: EdgeInsets.only(bottom: 5),
            child: ToDoListCard(
              model: model,
            ),
          );
        }, childCount: controller.itemList.length)));
  }

  //列表
  Widget todoProject() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.fromLTRB(14, 8, 14, 8),
        height: 120,
        child: Obx(() => ListView.builder(
              itemBuilder: (context, index) {
                ToDoProjectModel? model;
                if (index != 0) {
                  model = controller.projectList[index - 1];
                }
                return GestureDetector(
                  child: SizedBox(
                    width: 180,
                    child: index != 0
                        ? ToDoProjectCard(
                            color: HexColor(model!.colorHex),
                            iconData: model.getIconData(),
                            title: model.name,
                          )
                        : ToDoCreateProjectCard(),
                  ),
                  onTap: () {
                    Get.to(ToDoProjectDetailsPage(
                      model!,
                    ));
                  },
                );
              },
              itemCount: controller.projectList.length + 1,
              scrollDirection: Axis.horizontal,
            )),
      ),
    );
  }
}

class ToDoCreateProjectCard extends StatelessWidget {
  const ToDoCreateProjectCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add,
            color: LRThemeColor.mainColor,
          ),
          SizedBox(
            height: 5,
          ),
          Text("创建列表")
        ],
      )),
      shape: LRTool.getBorderRadius(8),
    );
  }
}
