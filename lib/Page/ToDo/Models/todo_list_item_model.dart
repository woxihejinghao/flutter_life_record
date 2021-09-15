final String tableToDoList = "todo_list_item";

class ToDoListItemModel {
  late int id;
  late String name;
  late String projectID;
  late int createTime;
  String? remark;
  String? date;
  String? time;
  bool? preferential; //是否优先
  bool? cycle; //是否重复循环

  ToDoListItemModel() {
    createTime = DateTime.now().microsecondsSinceEpoch;
  }

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      "projectID": projectID,
      "name": name,
      "remark": remark,
      "preferential": preferential == true ? 1 : 0,
      "date": date,
      "time": time,
      "cycle": cycle == true ? 1 : 0,
      "createTime": createTime
    };

    return map;
  }

  ToDoListItemModel.fromeMap(Map<String, Object?> map) {
    id = map["id"] as int;
    name = map["name"] as String;
    projectID = map["projectID"] as String;
    remark = map["remark"] as String?;
    preferential = map["preferential"] == 1;
    cycle = map["cycle"] == 1;
    date = map["date"] as String?;
    time = map["time"] as String?;
    createTime = map["createTime"] as int;
  }
}