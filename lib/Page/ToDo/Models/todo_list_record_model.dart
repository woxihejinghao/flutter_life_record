final String ToDoRecordTable = "todo_list_record";

class ToDoListRecordModel {
  late int id;
  late int itemID;
  late int projectID;
  late String name;
  late int finishTime; //完成的时间戳
  String? remark; //备注

  ToDoListRecordModel() {
    finishTime = DateTime.now().microsecondsSinceEpoch;
  }

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      "itemID": itemID,
      "name": name,
      "finishTime": finishTime,
      "remark": remark,
      "projectID": projectID
    };

    return map;
  }

  ToDoListRecordModel.fromMap(Map<String, Object?> map) {
    id = map["id"] as int;
    name = map["name"] as String;
    itemID = map["itemID"] as int;
    finishTime = map["finishTime"] as int;
    remark = map["remark"] as String;
    projectID = map["projectID"] as int;
  }
}
