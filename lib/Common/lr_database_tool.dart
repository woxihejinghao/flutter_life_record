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
  Future openDataBase(String dbNme) async {
    if (dbPath == null || dbNme.isEmpty) {
      dbPath = await getDatabasesPath();
    }
    //如果数据库存在，先关闭数据库

    database = await openDatabase(join(dbPath ?? "", dbNme + '.db'),
        version: dbVersion, onCreate: (db, version) async {
      //项目表
      await db.execute(
          "create table todo_project (id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,color TEXT,icon TEXT,createTime TEXT)");
      //代办列表
      await db.execute(
          "create table todo_list_item (id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,)");
    });
  }
}
