import 'package:bottle_cap_gallery/src/views/utils/item.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQFliteCollection {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'test.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE mytemptable(id INTEGER PRIMARY KEY AUTOINCREMENT, text TEXT NOT NULL,image BLOB)",
        );
      },
      version: 1,
    );
  }

  Future<int> insertItem(Item item) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.insert('mytemptable', item.toMap());
    return result;
  }

  Future<int> insertItemList(List<Item> items) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var item in items) {
      result = await db.insert('mytemptable', item.toMap());
    }
    return result;
  }

  Future<List<Item>> retrieveItems() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('mytemptable');
    return queryResult.map((e) => Item.fromMap(e)).toList();
  }
}
