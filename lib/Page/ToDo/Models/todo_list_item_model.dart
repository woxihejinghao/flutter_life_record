import 'package:time/time.dart';

///表单-待办列表
final String tableToDoList = "todo_list";

class ToDoListItemModel {
  late int id;
  String? name;
  late int projectID;
  late int createTime;
  int? lastFinishTime; //上次完成的时间
  String? remark;
  int? datetime; //目标时间
  // String? time;
  bool preferential = false; //是否优先
  ///循环类型 0:不循环 1:日循环 2:周循环 3:月循环 4:年循环
  int cycleType = 0;

  ///是否已经完成
  bool finished = false;

  ///上次完成的datetime
  DateTime? get nextDateTime {
    if (datetime == null) {
      return null;
    }
    var date = DateTime.fromMicrosecondsSinceEpoch(datetime ?? 0);
    if (lastFinishTime == null) {
      return date;
    }

    var lastDate = DateTime.fromMicrosecondsSinceEpoch(lastFinishTime ?? 0);
    switch (cycleType) {
      case 0:
        return date;
      case 1:
        return lastDate + 1.days;
      case 2:
        return lastDate + 7.days;
      case 3: //计算下一个月
        var month = lastDate.month + 1;
        var year = lastDate.year;
        var day = lastDate.day;
        if (month > 12) {
          month = 1;
          year += 1;
        }

        if (date.day == date.daysInMonth ||
            date.day > _getDaysInMonth(month, year)) {
          //当月的最后一天 或者 当月的天数大于下个月的天数
          day = _getDaysInMonth(month, year);
        }

        return lastDate.copyWith(year: year, month: month, day: day);
      case 4:
        var nextDate = lastDate.copyWith(year: lastDate.year + 1);
        if (date.month == 2 && date.day == 29) {
          //如果是闰年的29号
          if (!nextDate.isLeapYear) {
            //下一年不是闰年的话前置一天
            nextDate = nextDate.copyWith(day: 28);
          } else {
            nextDate = nextDate.copyWith(day: 29);
          }
        }
        return nextDate;
      default:
        return date;
    }
  }

  ///今天是否完成

  ToDoListItemModel() {
    createTime = DateTime.now().microsecondsSinceEpoch;
  }

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      "projectID": projectID,
      "name": name,
      "remark": remark,
      "preferential": preferential ? 1 : 0,
      "datetime": datetime,
      "createTime": createTime,
      "lastFinishTime": lastFinishTime,
      "cycleType": cycleType,
      "finished": finished ? 1 : 0
    };

    return map;
  }

  ToDoListItemModel.fromeMap(Map<String, Object?> map) {
    if (map.containsKey("id")) {
      id = map["id"] as int;
    }
    name = map["name"] as String;
    projectID = map["projectID"] as int;
    remark = map["remark"] as String?;
    preferential = (map["preferential"] as int) == 1;
    datetime = map["datetime"] as int?;
    createTime = map["createTime"] as int;
    cycleType = map["cycleType"] as int;
    lastFinishTime = map["lastFinishTime"] as int?;
    finished = (map["finished"] as int) == 1;
  }

  ///获取月份的天数
  int _getDaysInMonth(int month, int year) {
    bool isLeapYear =
        year >= 1582 && year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
    final days = [
      31, // January
      if (isLeapYear) 29 else 28, // February
      31, // March
      30, // April
      31, // May
      30, // June
      31, // July
      31, // August
      30, // September
      31, // October
      30, // November
      31, // December
    ];

    return days[month - 1];
  }
}
