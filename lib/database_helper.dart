import 'dart:io';

import 'package:alarm_clock/alarm_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "alarm.db");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db,int version) async{
    await db.execute('''
    CREATE TABLE alarmTable(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    alarmId INTEGER,
    alarmTitle TEXT,
    timeOfDay TEXT,
    ringtoneName TEXT
    )
    ''');
  }

  Future<List<AlarmModel>> getAlarm() async {
    Database db = await instance.database;
    var alarmModelItem = await db.query("alarmTable",orderBy: 'id');
    List<AlarmModel> alarmList = alarmModelItem.isNotEmpty ? alarmModelItem.map((e) => AlarmModel.fromMap(e)).toList() : [] ;
    return alarmList;
  }

  Future<int> addAlarm(AlarmModel alarm) async {
    Database db = await instance.database;
    return await db.insert("alarmTable", alarm.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, Object?>>> getLastId() async{
    Database db = await instance.database;
    var lastId = await db.rawQuery("SELECT * FROM alarmTable ORDER BY id DESC LIMIT 1 ");
    return lastId;
  }

  Future<int> deleteAlarm(int id) async {
    Database db = await instance.database;
    return await db.delete('alarmTable',where: 'id = ?',whereArgs: [id]);
  }

}