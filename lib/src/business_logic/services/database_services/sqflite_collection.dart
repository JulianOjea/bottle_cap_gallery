import 'package:sqflite/sqflite.dart';
import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQFliteCollection {
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDb();
    return _database;
  }

  initDb() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, "test.db");
    var database = await openDatabase(path, version: 1, onCreate: _onCreate);
    return database;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE Employee(id INTEGER PRIMARY KEY, firstname TEXT, lastname TEXT, mobileno TEXT,emailId TEXT )");
    print("Created tables");
  }
}
