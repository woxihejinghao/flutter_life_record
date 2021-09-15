import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_color.dart';
import 'package:flutter_life_record/Common/lr_tool.dart';
import 'package:flutter_life_record/Page/ToDo/ViewModel/todo_project_create_viewModel.dart';
import 'package:flutter_life_record/Page/ToDo/Widgets/color_select_item.dart';
import 'package:flutter_life_record/Page/ToDo/Widgets/todo_project_card.dart';
import 'package:oktoast/oktoast.dart';

const List colorList = [
  "#f05b72",
  "#1d953f",
  "#005344",
  "#008792",
  "#33a3dc",
  "#b69968",
  "#444693",
  "#d71345",
  "#4a3113",
  "#4f5555",
  "#a1a3a6",
  "#6c4c49"
];

const List iconList = [
  Icons.face,
  Icons.favorite,
  Icons.lock,
  Icons.description,
  Icons.event,
  Icons.list,
  Icons.dashboard,
  Icons.article,
  Icons.paid,
  Icons.shopping_cart,
  Icons.trending_up,
  Icons.accessibility,
  Icons.flight_takeoff,
  Icons.sports_esports,
  Icons.sports_baseball,
  Icons.palette,
  Icons.style,
  Icons.face_retouching_natural,
  Icons.keyboard,
  Icons.directions_car,
  Icons.restaurant_menu,
  Icons.medical_services,
  Icons.star_rate,
  Icons.headphones,
  Icons.tv,
  Icons.watch,
  Icons.light_mode,
];

class ToDoProjectCreatePage extends StatefulWidget {
  const ToDoProjectCreatePage({Key? key}) : super(key: key);

  @override
  _ToDoProjectCreatePageState createState() => _ToDoProjectCreatePageState();
}

class _ToDoProjectCreatePageState extends State<ToDoProjectCreatePage> {
  //viewModel
  ToDoProjectCreateViewModel _viewModel = ToDoProjectCreateViewModel();
  String title = "标题";
  IconData icons = iconList[0];
  Color iconColor = HexColor(colorList.first);
  String _colorHex = colorList.first;
  int selectedIndex = 0;
//是否显示卡片底部阴影
  double _borderLine0paque = 0;
  // 滑动监听
  ScrollController _scrollController = ScrollController();
  // 输入监听
  TextEditingController _textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    //监听滚动事件
    _scrollController.addListener(() {
      double temp = _scrollController.offset / 50;
      if (temp > 1) {
        temp = 1;
      } else if (temp < 0) {
        temp = 0;
      }

      if (temp != _borderLine0paque) {
        setState(() {
          _borderLine0paque = temp;
        });
      }
    });

    //监听输入
    _textEditingController.addListener(() {
      setState(() {
        this.title = _textEditingController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("创建列表"),
        elevation: 0,
        actions: [
          TextButton(
              onPressed: () async {
                if (_textEditingController.text.isEmpty) {
                  showToast("请输入名称");
                  return;
                }
                await _viewModel.saveProject(
                    _textEditingController.text, _colorHex, icons);
                Navigator.pop(context);
                showToast("创建成功");
              },
              child: Text(
                "创建",
                style: TextStyle(color: LRThemeColor.mainColor, fontSize: 18),
              ))
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPersistentHeader(
            delegate: ProjectHeaderDelegate(
                borderOpaque: this._borderLine0paque,
                iconColor: this.iconColor,
                title: this.title,
                icons: this.icons),
            pinned: true,
          ),
          titleTextField(),
          titleSection("颜色"),
          colorSelectSection(),
          titleSection("图标"),
          iconSelectSection()
        ],
      ),
    );
  }

  Widget titleTextField() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(left: 14, right: 14),
        child: TextField(
          controller: _textEditingController,
          cursorColor: LRThemeColor.mainColor,
          maxLength: 6,
          decoration: InputDecoration(
            hintText: "请输入标题(1-6个字符)",
            contentPadding: EdgeInsets.only(left: 8, right: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),
      ),
    );
  }

  Widget titleSection(String sectionTitle) {
    return SliverToBoxAdapter(
      child: Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(left: 14, top: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              sectionTitle,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
            Container(
              height: 2,
              width: 40,
              color: LRThemeColor.mainColor,
            )
          ],
        ),
      ),
    );
  }

  ///选择颜色
  Widget colorSelectSection() {
    double spaceing = 20;
    double width = MediaQuery.of(context).size.width;
    width = (width - 5 * spaceing - 28) / 6;

    return SliverToBoxAdapter(
      child: Container(
        height: width * 2 + 34,
        margin: EdgeInsets.only(left: 14, right: 14, top: 20),
        child: Card(
          child: GridView.count(
            padding: EdgeInsets.only(left: 14, right: 14, top: 8, bottom: 8),
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 6,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1,
            children: colorList
                .map((e) => ColorSelectItem(
                      color: HexColor(e),
                      radius: width / 2,
                      callback: () {
                        setState(() {
                          this.iconColor = HexColor(e);
                          this._colorHex = e;
                        });
                      },
                    ))
                .toList(),
          ),
          shape: LRTool.getBorderRadius(8),
        ),
      ),
    );
  }

  Widget iconSelectSection() {
    double spaceing = 20;
    double width = MediaQuery.of(context).size.width;
    width = (width - 5 * spaceing - 28) / 6;

    return SliverToBoxAdapter(
      child: SafeArea(
          child: Container(
        height: width * 6 + 34,
        margin: EdgeInsets.only(left: 14, right: 14, top: 20),
        child: Card(
          child: GridView.count(
            padding: EdgeInsets.only(left: 14, right: 14, top: 8, bottom: 8),
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 6,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1,
            children: iconList
                .map((e) => GestureDetector(
                      child: Container(
                        child: Icon(
                          e,
                          size: 25,
                        ),
                        decoration: BoxDecoration(
                            color: LRThemeColor.lineColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                      onTap: () {
                        setState(() {
                          this.icons = e;
                        });
                      },
                    ))
                .toList(),
          ),
          shape: LRTool.getBorderRadius(8),
        ),
      )),
    );
  }
}

class ProjectHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final IconData icons;
  final Color iconColor;
  final double borderOpaque;

  ProjectHeaderDelegate(
      {this.title = "",
      this.icons = Icons.add,
      this.iconColor = Colors.black,
      this.borderOpaque = 0});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return projectHeader();
  }

  @override
  bool shouldRebuild(ProjectHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  double get minExtent => 190;

  @override
  double get maxExtent => 190;

  Widget projectHeader() {
    return Container(
      alignment: Alignment.center,
      child: Container(
        height: 120,
        width: 180,
        child: ToDoProjectCard(
          title: this.title,
          iconData: this.icons,
          color: this.iconColor,
        ),
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
                  color: HexColor("#f1f1f1").withOpacity(this.borderOpaque),
                  width: 2))),
    );
  }
}
