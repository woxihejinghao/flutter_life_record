import 'package:flutter_life_record/Page/ToDo/Models/todo_list_item_model.dart';
import 'package:flutter_life_record/Page/ToDo/Models/todo_project_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class LRDataBaseTool {
  LRDataBaseTool._();

  static final _instance = LRDataBaseTool._();

  factory LRDataBaseTool.getInstance() => _instance;

  String? dbPath;
  Database? database;
  int dbVersion = 1;

  //打开数据库
  Future<Database> openDB() async {
    if (database != null) {
      return database!;
    }
    dbPath = await getDatabasesPath();

    database = await openDatabase(join(dbPath ?? "", 'my.db'),
        version: dbVersion, onCreate: (db, version) async {
      //项目表
      await db.execute(
          "create table todo_project (id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,color TEXT,icon TEXT,createTime INTEGER)");
      //代办列表
      await db.execute(
          "create table todo_list_item (id INTEGER PRIMARY KEY AUTOINCREMENT,projectID INTEGER NOT NULL,name TEXT NOT NULL,remark TEXT,preferential INTEGER,cycle INTEGER,date TEXT,time TEXT,createTime INTEGER)");
    });

    return database!;
  }

  //插入待办列表数据
  Future<ToDoProjectModel> insertToDoProject(ToDoProjectModel model) async {
    var db = await openDB();
    model.id = await db.insert(tableToDoProject, model.toMap());
    print("插入待办列表:${model.id}");
    return model;
  }

  //更新待办列表
  Future updateToDoProject(ToDoProjectModel model) async {
    var db = await openDB();
    await db.update(tableToDoProject, model.toMap(),
        where: "id = ?", whereArgs: [model.id]);
  }

  ///查询数据
  Future<List<ToDoProjectModel>> getToDoProjectList() async {
    var db = await openDB();
    var maps = await db.query(tableToDoProject,
        columns: ["id", "name", "color", "icon", "createTime"]);

    return maps.map((e) => ToDoProjectModel.fromMap(e)).toList();
  }

  ///查询列表（支持ID）
  Future<ToDoProjectModel?> getToDoProject(int projectID) async {
    var db = await openDB();
    var maps = await db.query(tableToDoProject,
        columns: ["id", "name", "color", "icon", "createTime"],
        where: "id = ?",
        whereArgs: [projectID]);

    if (maps.isEmpty) {
      return null;
    } else {
      return ToDoProjectModel.fromMap(maps.first);
    }
  }

  ///插入待办事项
  Future<ToDoListItemModel> insertToDoItem(ToDoListItemModel model) async {
    var db = await openDB();
    try {
      model.id = await db.insert(tableToDoList, model.toMap());
    } catch (e) {
      print("插入数据失败");
    }

    return model;
  }

  ///查询待办列表
  Future<List<ToDoListItemModel>> getToDoList(
      int? id, int? projectID, DateTime? time) async {
    String? whereStr;
    List<Object?>? whereArgs;

    if (id != null) {
      whereStr = "id = ?";
      whereArgs = [id];
    } else if (projectID != null) {
      whereStr = "projectID = ?";
      whereArgs = [projectID];
    }

    var db = await openDB();
    var maps =
        await db.query(tableToDoList, where: whereStr, whereArgs: whereArgs);

    return maps.map((e) => ToDoListItemModel.fromeMap(e)).toList();
  }
}
