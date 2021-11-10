import 'package:flutter_life_record/Page/ToDo/Models/todo_list_item_model.dart';
import 'package:flutter_life_record/Page/ToDo/Models/todo_list_record_model.dart';
import 'package:flutter_life_record/Page/ToDo/Models/todo_project_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:flutter_life_record/Extension/lr_extesion.dart';

class LRDataBaseTool {
  LRDataBaseTool._();

  static final _instance = LRDataBaseTool._();

  factory LRDataBaseTool.getInstance() => _instance;

  String? dbPath;
  Database? database;
  int dbVersion = 3;

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
          "create table todo_list_item (id INTEGER PRIMARY KEY AUTOINCREMENT,projectID INTEGER NOT NULL,name TEXT NOT NULL,remark TEXT,preferential INTEGER,cycle INTEGER,date TEXT,time TEXT,createTime INTEGER,lastFinishTime INTEGER)");
      //完成记录表
      await db.execute(
          "create table $ToDoRecordTable (id INTEGER PRIMARY KEY AUTOINCREMENT,todoItemJson Text NOT NULL,finishTime INTEGER NOT NULL,remark TEXT)");
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      //数据库升级
      if (newVersion <= oldVersion) {
        return;
      }
      if (oldVersion == 1) {
        //增加上次完成时间
        // db.execute("alter table $tableToDoList add lastFinishTime integer");
      }
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

  ///删除Project
  Future deleteToDoProject(int id) async {
    var db = await openDB();
    await db.delete(tableToDoProject, where: "id = ?", whereArgs: [id]);
    return await db.delete(tableToDoList,
        where: "projectID", whereArgs: [id]); //删除相关列表的代办事项
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

  /// 更新待办事项
  Future updateToDoItem(ToDoListItemModel model) async {
    var db = await openDB();

    return await db.update(tableToDoList, model.toMap(),
        where: "id = ?", whereArgs: [model.id]);
  }

  ///查询待办列表
  Future<List<ToDoListItemModel>> getToDoList(
      {int? id, int? projectID, DateTime? time}) async {
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

  ///查询待办列表（未完成）
  Future<List<ToDoListItemModel>> queryUnfinishToDoItem(int projectID) async {
    var db = await openDB();
    var maps = await db.query(tableToDoList,
        where: "projectID = ? and cycle = ?", whereArgs: [projectID, false]);

    return maps.map((e) => ToDoListItemModel.fromeMap(e)).toList();
  }

  ///删除代办事项
  Future deleteToDoItem(int id) async {
    var db = await openDB();
    return await db.delete(tableToDoList, where: "id = ?", whereArgs: [id]);
  }

  //插入记录
  Future insertRecord(ToDoListItemModel model, {String? remark}) async {
    var db = await openDB();

    var recordModel = ToDoListRecordModel();
    recordModel.todoItemJson = model.toMap().convertToJson();
    recordModel.remark = remark;

    return await db.insert(ToDoRecordTable, recordModel.toMap());
  }

  ///查询记录
  Future<List<ToDoListRecordModel>> queryRecordList({int? projetID}) async {
    var db = await openDB();

    String? whereStr;
    List<Object?>? args;
    if (projetID != null) {
      whereStr = 'todoItemJson like "projectID":?';
      args = [projetID];
    }
    var maps =
        await db.query(ToDoRecordTable, where: whereStr, whereArgs: args);

    return maps.map((e) => ToDoListRecordModel.fromMap(e)).toList();
  }

  ///移除记录
  Future deleteRecord(int id) async {
    var db = await openDB();

    return db.delete(ToDoRecordTable, where: "id = ?", whereArgs: [id]);
  }
}
