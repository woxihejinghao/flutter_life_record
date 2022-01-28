import 'package:date_format/date_format.dart';
import 'package:flutter_life_record/Page/ToDo/Pages/todo_item_create_page.dart';
import 'package:time/time.dart';

///表单-待办列表
final String tableToDoList = "todo_list";

class ToDoListItemModel {
  late int id;
  String? name;
  late int projectID;
  late int updateTime;
  int? finishTime; //下次完成的时间
  String? remark;
  int? datetime; //初始目标时间
  // String? time;
  bool preferential = false; //是否优先
  ///循环类型 0:不循环 1:日循环 2:周循环 3:月循环 4:年循环
  int cycleType = 0;

  ///是否已经完成
  bool finished = false;
  //完成的时间
  DateTime? get finishedDateTime {
    if (finishTime != null) {
      return DateTime.fromMicrosecondsSinceEpoch(finishTime!);
    } else if (datetime != null) {
      return DateTime.fromMicrosecondsSinceEpoch(datetime!);
    } else {
      return null;
    }
  }

  ///上次完成的datetime
  DateTime? get nextDateTime {
    if (datetime == null) {
      return null;
    }
    var date = DateTime.fromMicrosecondsSinceEpoch(datetime ?? 0);
    DateTime lastDate;
    if (finishTime == null) {
      lastDate = date;
    } else {
      lastDate = DateTime.fromMicrosecondsSinceEpoch(finishTime ?? 0);
    }
    //现在的时间
    var now = DateTime.now();

    var diff = lastDate.difference(now);
    switch (cycleType) {
      case 0:
        return lastDate;
      case 1:
        if (diff.inDays < -1) {
          return now.copyWith(hour: lastDate.hour, minute: lastDate.minute) +
              1.days;
        }
        return lastDate + 1.days;
      case 2:
        if (diff.inDays < -7) {
          return now + 7.days;
        }
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

  String? get dateFormatterString {
    if (datetime == null) {
      return null;
    }

    DateTime date;
    if (finishTime == null) {
      date = DateTime.fromMicrosecondsSinceEpoch(datetime!);
    } else {
      date = DateTime.fromMicrosecondsSinceEpoch(finishTime!);
    }
    String str = "";
    if (date.isToday) {
      str = "今天";
    } else if (date.isTomorrow) {
      str = "明天";
    } else if (date.wasYesterday) {
      str = "昨天";
    } else {
      str = formatDate(date, [yyyy, '/', mm, '/', dd]);
    }
    switch (date.weekday) {
      case 1:
        str += "（周一）";
        break;
      case 2:
        str += "（周二）";
        break;
      case 3:
        str += "（周三）";
        break;
      case 4:
        str += "（周四）";
        break;
      case 5:
        str += "（周五）";
        break;
      case 6:
        str += "（周六）";
        break;
      case 7:
        str += "（周日）";
        break;
      default:
    }

    if (cycleType != 0) {
      str += cycleTypeMap[cycleType];
    }
    return str;
  }

  ///今天是否完成

  ToDoListItemModel() {
    updateTime = DateTime.now().microsecondsSinceEpoch;
  }

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      "projectID": projectID,
      "name": name,
      "remark": remark,
      "preferential": preferential ? 1 : 0,
      "datetime": datetime,
      "updateTime": updateTime,
      "finishTime": finishTime,
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
    updateTime = map["updateTime"] as int;
    cycleType = map["cycleType"] as int;
    finishTime = map["finishTime"] as int?;
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
