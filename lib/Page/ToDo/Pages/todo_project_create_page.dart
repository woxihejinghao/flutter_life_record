import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_color.dart';
import 'package:flutter_life_record/Common/lr_tool.dart';
import 'package:flutter_life_record/Page/ToDo/Widgets/color_select_item.dart';
import 'package:flutter_life_record/Page/ToDo/Widgets/todo_project_card.dart';

const List colorList = [
  "#f05b72",
  "#1d953f",
  "#ffc20e",
  "#008792",
  "#f58220",
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
  String title = "标题";
  IconData icons = Icons.add;
  Color iconColor = Colors.black;
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("创建列表"),
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: ProjectHeaderDelegate(),
            pinned: true,
          ),
          titleTextField()
        ],
      ),
    );
  }

  Widget titleTextField() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(left: 14, right: 14),
        child: TextField(
          decoration: InputDecoration(
              hintText: "请输入标题",
              contentPadding: EdgeInsets.only(left: 8, right: 8)),
        ),
      ),
    );
  }

  Widget titleSection(String sectionTitle) {
    return Container(
      width: 40,
      margin: EdgeInsets.only(left: 14),
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
            color: LRThemeColor.mainColor,
          )
        ],
      ),
    );
  }

  Widget colorSelectSection() {
    double spaceing = 20;
    double width = MediaQuery.of(context).size.width;
    width = (width - 5 * spaceing - 28) / 6;
    return Container(
      height: width * 2 + 34,
      margin: EdgeInsets.only(left: 14, right: 14),
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
                    isSelected: e == colorList[this.selectedIndex],
                  ))
              .toList(),
        ),
        shape: LRTool.getBorderRadius(8),
      ),
    );
  }

  Widget iconSelectSection() {
    return Container(
      child: Card(
        shape: LRTool.getBorderRadius(8),
      ),
    );
  }
}

class ProjectHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final IconData icons;
  final Color iconColor;

  ProjectHeaderDelegate(
      {this.title = "", this.icons = Icons.add, this.iconColor = Colors.black});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return projectHeader();
  }

  @override
  bool shouldRebuild(ProjectHeaderDelegate oldDelegate) {
    return false;
  }

  @override
  double get minExtent => 190;

  @override
  double get maxExtent => 190;

  Widget projectHeader() {
    return Container(
      alignment: Alignment.center,
      child: Container(
        height: 150,
        width: 120,
        child: ToDoProjectCard(
          title: this.title,
          iconData: this.icons,
          color: this.iconColor,
        ),
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.red,width: 1))
      ),
    );
  }
}
