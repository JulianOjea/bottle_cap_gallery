import 'package:bottle_cap_gallery/src/views/utils/item.dart';

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';

class SQFliteCollection {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      //exists a data base in some devices called bottlecap
      join(path, 'bottlecap1.db'),
      onCreate: (database, version) async {
        await database.execute(
          """CREATE TABLE bottlecaptable0(id INTEGER PRIMARY KEY AUTOINCREMENT, 
          brandname TEXT NOT NULL, type TEXT NOT NULL, description TEXT NOT NULL, 
          country TEXT NOT NULL, city TEXT NOT NULL, releasedate TEXT NOT NULL, 
          image BLOB, folder TEXT NOT NULL, creationdate TEXT NOT NULL)""",
        );
      },
      version: 1,
    );
  }

  Future<int> insertItem(Item item) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.insert('bottlecaptable0', item.toMap());
    return result;
  }

  Future<int> insertItemList(List<Item> items) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var item in items) {
      result = await db.insert('bottlecaptable0', item.toMap());
    }
    return result;
  }

  Future<List<Item>> retrieveItems() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('bottlecaptable0');
    return queryResult.map((e) => Item.fromMap(e)).toList();
  }

  Future<void> deleteItem(int id) async {
    final db = await initializeDB();
    await db.delete(
      'bottlecaptable0',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> updateItem(Item item) async {
    final Database db = await initializeDB();

    await db.update(
      'bottlecaptable0',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> getNumberOfItems() async {
    final Database db = await initializeDB();
    var result = await db.rawQuery('SELECT COUNT(*) FROM bottlecaptable0');
    int? count = Sqflite.firstIntValue(result);
    print(count);
    return count!;
  }

  Future<void> dropTable() async {
    String path = await getDatabasesPath();
    await deleteDatabase(
        path + "bottlecap.db"); //this is the past database should be deleted
    print("deleted");
    final Database db = await initializeDB();
    await db.execute("DROP TABLE IF EXISTS bottlecaptable0");
    print("deleted2");
  }
}
