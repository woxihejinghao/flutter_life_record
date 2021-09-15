import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_color.dart';
import 'package:flutter_life_record/Page/ToDo/Widgets/switch_item.dart';

class ToDoListTimeSelectPage extends StatefulWidget {
  const ToDoListTimeSelectPage({Key? key}) : super(key: key);

  @override
  _ToDoListTimeSelectPageState createState() => _ToDoListTimeSelectPageState();
}

class _ToDoListTimeSelectPageState extends State<ToDoListTimeSelectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("时间设置"),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(14, 20, 14, 20),
        child: Column(
          children: [
            getListItem("日期", "请选择日期", () {
              selectDate();
            }),
            SizedBox(
              height: 5,
            ),
            getListItem("时间", "请选择时间", () {
              selectTime();
            }),
            SizedBox(
              height: 5,
            ),
            SwitchItem(
              title: "重复",
              isOn: true,
              valueChanged: (isOn) {
                print("切换$isOn");
              },
            )
          ],
        ),
      ),
    );
  }

  Widget getListItem(String title, String value, GestureTapCallback? onTap) {
    return Card(
      child: ListTile(
        leading: Text(
          title,
          style: TextStyle(fontSize: 18),
        ),
        trailing: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value),
            SizedBox(
              width: 5,
            ),
            Icon(Icons.keyboard_arrow_right)
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  ///选择日期
  selectDate() async {
    DateTime? dateTime = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1800, 1),
        lastDate: DateTime(9999, 12),
        builder: (context, child) {
          return Theme(
              data: ThemeData(
                  cardColor: LRThemeColor.mainColor,
                  primaryColorLight: LRThemeColor.mainColor,
                  brightness: Brightness.light),
              child: child!);
        });

    print("选择的时间$dateTime");
  }

  ///选择时间
  selectTime() async {
    TimeOfDay initialTime = TimeOfDay.now();
    TimeOfDay? result =
        await showTimePicker(context: context, initialTime: initialTime);

    print("选择的时间$result");
  }
}
