// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_color.dart';
import 'package:flutter_life_record/Common/lr_route.dart';

import 'package:flutter_life_record/Page/ToDo/Models/todo_project_model.dart';
import 'package:flutter_life_record/Page/ToDo/Pages/setting_drawer_page.dart';
import 'package:flutter_life_record/Page/ToDo/Pages/todo_list_create_page.dart';
import 'package:flutter_life_record/Page/ToDo/Pages/todo_project_create_page.dart';
import 'package:flutter_life_record/Page/ToDo/Pages/todo_project_details_page.dart';
import 'package:flutter_life_record/Page/ToDo/Providers/providers.dart';
import 'package:flutter_life_record/Page/ToDo/Providers/todo_home_provider.dart';
import 'package:flutter_life_record/Page/ToDo/Providers/todo_project_details_provider.dart';
import 'package:flutter_life_record/Page/ToDo/Widgets/todo_litst_card.dart';
import 'package:flutter_life_record/Page/ToDo/widgets/todo_project_card.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/src/provider.dart';
import 'package:flutter_life_record/Extension/lr_extesion.dart';

class ToDoHomePage extends StatefulWidget {
  const ToDoHomePage({Key? key}) : super(key: key);

  @override
  _ToDoHomePageState createState() => _ToDoHomePageState();
}

class _ToDoHomePageState extends State<ToDoHomePage> {
  String timeString = "";
  @override
  void initState() {
    var now = DateTime.now();
    timeString = "${now.year}年 ${now.month}月 ${now.day}日";
    //请求权限
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: SettingDrawerPage(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            // actions: [
            //   IconButton(
            //       onPressed: () {
            //         Scaffold.of(context).openEndDrawer();
            //       },
            //       icon: Icon(Icons.settings))
            // ],
            centerTitle: false,
            expandedHeight: 100,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                timeString,
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
              child: Text(
                "到底了，努力完成吧~",
                style: context.lrTextTheme.caption,
              ),
            )),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (context.read<ToDoHomeProvider>().projectList.isEmpty) {
            showToast("请先创建列表");
            return;
          }
          lrPushPage(valueProvider(context.read<ToDoHomeProvider>(),
              child: ToDoListCreatePage()));
        },
        child: Icon(
          Icons.add,
          size: 25,
        ),
      ),
    );
  }

//今日代表
  SliverList todayToDoList() {
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      var model = context.read<ToDoHomeProvider>().todayItemList[index];
      return Container(
        padding: EdgeInsets.only(left: 14, right: 14),
        margin: EdgeInsets.only(bottom: 5),
        child: ToDoListCard(
            onTap: () => lrPushPage(ToDoListCreatePage(
                  model: model,
                )),
            model: model,
            finishCallBack: () =>
                context.read<ToDoHomeProvider>().updateItemFinish(model)),
      );
    }, childCount: context.watch<ToDoHomeProvider>().todayItemList.length));
  }

  //列表
  Widget todoProject() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.fromLTRB(14, 8, 14, 8),
        height: 120,
        child: ListView.builder(
          itemBuilder: (context, index) {
            ToDoProjectModel? model;
            if (index != 0) {
              model = context.read<ToDoHomeProvider>().projectList[index - 1];
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
                if (index == 0) {
                  lrPushPage(ToDoProjectCreatePage());
                } else {
                  lrPushPage(buildProvider(ToDoProjectDetailsProvider(model!),
                      child: ToDoProjectDetailsPage()));
                }
              },
            );
          },
          itemCount: context.watch<ToDoHomeProvider>().projectList.length + 1,
          scrollDirection: Axis.horizontal,
        ),
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
      elevation: 2,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add,
            color: context.lrColorScheme.primary,
          ),
          SizedBox(
            height: 5,
          ),
          Text("创建列表")
        ],
      )),
    );
  }
}
