// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_color.dart';
import 'package:flutter_life_record/Common/lr_instances.dart';
import 'package:flutter_life_record/Common/lr_route.dart';

import 'package:flutter_life_record/Page/ToDo/Models/todo_project_model.dart';
import 'package:flutter_life_record/Page/ToDo/Pages/setting_drawer_page.dart';
import 'package:flutter_life_record/Page/ToDo/Pages/todo_item_create_page.dart';
import 'package:flutter_life_record/Page/ToDo/Pages/todo_project_create_page.dart';
import 'package:flutter_life_record/Page/ToDo/Pages/todo_project_details_page.dart';
import 'package:flutter_life_record/Page/ToDo/Providers/providers.dart';
import 'package:flutter_life_record/Page/ToDo/Providers/todo_home_provider.dart';
import 'package:flutter_life_record/Page/ToDo/Providers/todo_project_details_provider.dart';
import 'package:flutter_life_record/Page/ToDo/Widgets/todo_home_progress.dart';
import 'package:flutter_life_record/Page/ToDo/widgets/todo_project_card.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:flutter_life_record/Extension/lr_extension.dart';

class ToDoHomePage extends StatefulWidget {
  const ToDoHomePage({Key? key}) : super(key: key);

  @override
  _ToDoHomePageState createState() => _ToDoHomePageState();
}

class _ToDoHomePageState extends State<ToDoHomePage> with RouteAware {
  String timeString = "";
  @override
  void initState() {
    var now = DateTime.now();
    timeString = "${now.year}年 ${now.month}月 ${now.day}日";
    //请求权限
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    //路由订阅
    routerObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    super.dispose();
    //取消订阅
    routerObserver.unsubscribe(this);
  }

  @override
  void didPopNext() {
    super.didPopNext();
    //刷新每日行程
    currentContext.read<ToDoHomeProvider>().updateToDayItemList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: SettingDrawerPage(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
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
          // SliverToBoxAdapter(
          //   //进度条
          //   child: ToDoHomeProgress(),
          // ),
          _buildTopSection(),

          SliverToBoxAdapter(
            //今日待办
            child: Container(
              margin: EdgeInsets.only(left: 14, bottom: 5, top: 14),
              child: Text(
                "我的列表",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          _buildToDoProjectList(), //项目列表
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (context.read<ToDoHomeProvider>().projectList.isEmpty) {
            showToast("请先创建列表");
            return;
          }
          lrPushPage(valueProvider(context.read<ToDoHomeProvider>(),
              child: ToDoItemCreatePage()));
        },
        child: Icon(
          Icons.add,
          size: 25,
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    //创建单个Item
    Widget _buildTopItem(
        Color backgroundColor, String title, IconData iconData, int num,
        {GestureTapCallback? tapCallback}) {
      return GestureDetector(
        child: Card(
          child: Container(
            child: Stack(
              children: [
                Positioned(
                  child: Text(
                    title,
                    style: context.lrTextTheme.subtitle1!
                        .copyWith(color: Colors.white),
                  ),
                  left: 10,
                  top: 10,
                ),
                Positioned(
                  child: Icon(
                    iconData,
                    color: Colors.white,
                  ),
                  bottom: 10,
                  right: 10,
                ),
                Positioned(
                  child: Text(
                    "$num",
                    style: context.lrTextTheme.subtitle1!
                        .copyWith(color: Colors.white, fontSize: 30),
                  ),
                  bottom: 10,
                  left: 10,
                )
              ],
            ),
            color: backgroundColor,
          ),
        ),
        onTap: tapCallback,
      );
    }

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(left: 14, right: 14, top: 14),
        height: 80,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: Selector<ToDoHomeProvider, int>(
                    builder: (context, num, child) => _buildTopItem(
                            context.lrColorScheme.primaryVariant,
                            "今天",
                            Icons.today,
                            num, tapCallback: () {
                          ToDoProjectModel projectModel = ToDoProjectModel();
                          projectModel.id = -1;
                          projectModel.name = "今天";
                          projectModel.setIcon(Icons.today);
                          projectModel.colorHex = context
                              .lrColorScheme.primaryVariant.value
                              .toRadixString(16);
                          lrPushPage(buildProvider(
                              ToDoProjectDetailsProvider(projectModel),
                              child: ToDoProjectDetailsPage()));
                        }),
                    selector: (context, provider) => provider.todayNum)),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: Selector<ToDoHomeProvider, int>(
                    builder: (context, num, child) => _buildTopItem(
                            context.lrColorScheme.secondaryVariant,
                            "全部",
                            Icons.assignment,
                            num, tapCallback: () {
                          ToDoProjectModel projectModel = ToDoProjectModel();
                          projectModel.id = -2;
                          projectModel.name = "全部";
                          projectModel.setIcon(Icons.assignment);
                          projectModel.colorHex = context
                              .lrColorScheme.secondaryVariant.value
                              .toRadixString(16);
                          lrPushPage(buildProvider(
                              ToDoProjectDetailsProvider(projectModel),
                              child: ToDoProjectDetailsPage()));
                        }),
                    selector: (context, provider) => provider.totalNum)),
          ],
        ),
      ),
    );
  }

  //列表
  Widget _buildToDoProjectList() {
    return SliverPadding(
      padding: EdgeInsets.only(left: 14, right: 14),
      sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate((context, index) {
            Widget child;
            ToDoProjectModel? model;
            if (index == 0) {
              child = ToDoCreateProjectCard();
            } else {
              model = context.read<ToDoHomeProvider>().projectList[index - 1];
              child = ToDoProjectCard(
                model.name,
                itemCount: model.itemCount,
                color: HexColor(model.colorHex),
                iconData: model.getIconData(),
                // title: model.name,
              );
            }

            return GestureDetector(
              child: child,
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
              childCount:
                  context.watch<ToDoHomeProvider>().projectList.length + 1),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 4.0 / 3)),
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
            size: 40,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "创建列表",
            style: context.lrTextTheme.subtitle1,
          )
        ],
      )),
    );
  }
}
