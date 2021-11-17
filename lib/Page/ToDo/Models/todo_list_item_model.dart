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
  DateTime? get lastFinishDateTime {
    if (lastFinishTime == null) {
      return null;
    }

    return DateTime.fromMicrosecondsSinceEpoch(lastFinishTime!);
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
}
