import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_color.dart';
import 'package:flutter_life_record/Common/lr_instances.dart';
import 'package:flutter_life_record/Page/ToDo/Pages/todo_list_create_page.dart';

class ToDoCyclyeTypeSelectPage extends StatelessWidget {
  final int selectedType;
  const ToDoCyclyeTypeSelectPage({Key? key, this.selectedType = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("重复"),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(14, 20, 14, 0),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [0, 1, 2, 3, 4]
                  .map((e) =>
                      _getListItem(cycleTypeMap[e], e, e == this.selectedType))
                  .toList(),
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8))),
          ),
        ),
      ),
    );
  }

  Widget _getListItem(String title, int type, bool isSelected) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 14, color: LRThemeColor.normalTextColor),
      ),
      trailing: isSelected
          ? Icon(
              Icons.done,
              color: LRThemeColor.mainColor,
            )
          : null,
      onTap: () {
        navigatorState.pop(type);
      },
    );
  }
}
