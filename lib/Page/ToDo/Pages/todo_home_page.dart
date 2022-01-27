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
import 'package:flutter_life_record/Page/ToDo/Widgets/todo_litst_card.dart';
import 'package:flutter_life_record/Page/ToDo/widgets/todo_project_card.dart';
import 'package:oktoast/oktoast.dart';
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
          SliverToBoxAdapter(
            //进度条
            child: ToDoHomeProgress(),
          ),
          _buildTopSection(),
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
        Color backgroundColor, String title, IconData iconData) {
      return Card(
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
              )
            ],
          ),
          color: backgroundColor,
        ),
      );
    }

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(left: 14, right: 14),
        height: 80,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: _buildTopItem(
                    context.lrColorScheme.primaryVariant, "今天", Icons.today)),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: _buildTopItem(context.lrColorScheme.secondaryVariant,
                    "全部", Icons.assignment))
          ],
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
            onTap: () => lrPushPage(ToDoItemCreatePage(
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
          physics: BouncingScrollPhysics(),
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
