import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_color.dart';
import 'package:flutter_life_record/Common/lr_tool.dart';
import 'package:flutter_life_record/Page/ToDo/Widgets/normal_list_tile.dart';
import 'package:flutter_life_record/Page/ToDo/Widgets/switch_item.dart';

class ToDoListTimeSelectPage extends StatefulWidget {
  const ToDoListTimeSelectPage({Key? key}) : super(key: key);

  @override
  _ToDoListTimeSelectPageState createState() => _ToDoListTimeSelectPageState();
}

class _ToDoListTimeSelectPageState extends State<ToDoListTimeSelectPage> {
  String? _dateString;
  String? _timeString;
  bool _cycle = false;

  DateTime? _date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("时间设置"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop({
                  "cycle": _cycle,
                  "date": _date.toString(),
                  "time": _timeString
                });
              },
              child: Text(
                "存储",
                style: TextStyle(fontSize: 18, color: LRThemeColor.mainColor),
              ))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(14, 20, 14, 20),
        child: Column(
          children: [
            NormalListTile(
                title: "日期",
                subTitle: _dateString ?? "",
                onTap: () {
                  selectDate();
                }),
            SizedBox(
              height: 5,
            ),
            NormalListTile(
                title: "时间",
                subTitle: _timeString ?? "",
                onTap: () {
                  selectTime();
                }),
            SizedBox(
              height: 5,
            ),
            SwitchItem(
              title: "重复",
              isOn: _cycle,
              valueChanged: (isOn) {
                setState(() {
                  _cycle = isOn;
                });
              },
            )
          ],
        ),
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
    if (dateTime != null) {
      setState(() {
        _date = dateTime;
        _dateString = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
      });
    }
  }

  ///选择时间
  selectTime() async {
    TimeOfDay initialTime = TimeOfDay.now();
    TimeOfDay? result =
        await showTimePicker(context: context, initialTime: initialTime);
    if (result != null) {
      setState(() {
        _timeString = "${result.hour}:${result.minute}";
      });
    }
  }
}
