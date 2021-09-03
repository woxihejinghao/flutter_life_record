import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_color.dart';
import 'package:flutter_life_record/Page/ToDo/Pages/todo_list_create_page.dart';
import 'package:flutter_life_record/Page/ToDo/widgets/todo_litst_card.dart';
import 'package:flutter_life_record/Page/ToDo/widgets/todo_project_card.dart';

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
              title: Text(timeString),
              titlePadding: EdgeInsets.fromLTRB(20, 0, 0, 20),
              centerTitle: false,
              collapseMode: CollapseMode.parallax,
            ),
          ),
          todoProject(), //项目列表
          SliverToBoxAdapter(
            //今日待办
            child: Container(
              margin: EdgeInsets.only(left: 14),
              child: Text(
                "今日待办",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return Container(
              padding: EdgeInsets.only(left: 14, right: 14),
              margin: EdgeInsets.only(bottom: 10),
              height: 80,
              child: ToDoListCard(),
            );
          }, childCount: 50)),

          SliverToBoxAdapter(
            child: SafeArea(
                child: Container(
              alignment: Alignment.center,
              child: Text("到底了，努力完成吧~"),
            )),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //创建
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) {
                    return ToDoListCreatePage();
                  },
                  fullscreenDialog: true));
        },
        child: Icon(
          Icons.add,
          size: 25,
        ),
        backgroundColor: LRThemeColor.mainColor,
      ),
    );
  }

  Widget todoProject() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.fromLTRB(14, 8, 14, 8),
        height: 150,
        child: ListView.builder(
          itemBuilder: (context, index) {
            return SizedBox(
              width: 120,
              child: ToDoProjectCard(),
            );
          },
          itemCount: 50,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}
