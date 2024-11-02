import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:todo_app/common/models/task_model.dart';

class DBHelper {
  // Method to create tables in the database
  static Future<void> createTables(sql.Database database) async {
    await database.execute('''
      CREATE TABLE todos(
         id INTEGER PRIMARY KEY AUTOINCREMENT,
         title TEXT,
         desc TEXT,
         date TEXT,
         startTime TEXT,
         endTime TEXT,
         remind INTEGER,
         repeat TEXT,
         isCompleted INTEGER
      )
    ''');
    await database.execute('''
      CREATE TABLE user(
         id INTEGER PRIMARY KEY AUTOINCREMENT,
         isVerified INTEGER
      )
    ''');
  }

  // Method to open and initialize the database
  static Future<sql.Database> db() async {
    return sql.openDatabase("todos.db", version: 1,
        onCreate: (sql.Database database, int version) async {
          await createTables(database);
        });
  }

  // Method to create a new task item in the todos table
  static Future<int> createItem(Task task) async {
    final db = await DBHelper.db();
    final id = await db.insert(
      "todos",
      task.toJson(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    return id;
  }

  // Method to create or update user verification status
  static Future<int> createUser(int isVerified) async {
    final db = await DBHelper.db();
    final data = {"id": 1, "isVerified": isVerified};
    final id = await db.insert(
      "user",
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    return id;
  }

  // Method to retrieve user data
  static Future<List<Map<String, dynamic>>> getUser() async {
    final db = await DBHelper.db();
    return db.query("user", orderBy: "id");
  }

  // Method to retrieve all items from the todos table
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await DBHelper.db();
    return db.query("todos", orderBy: "id");
  }

  // Method to retrieve a specific item by ID from the todos table
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await DBHelper.db();
    return db.query(
      "todos",
      where: "id = ?",
      whereArgs: [id],
      limit: 1,
    );
  }

  // Method to update a task item in the todos table
  static Future<int> updateItem(
      int id,
      String title,
      String desc,
      int isCompleted,
      String date,
      String startTime,
      String endTime,
      ) async {
    final db = await DBHelper.db();
    final data = {
      "title": title,
      "desc": desc,
      "isCompleted": isCompleted,
      "date": date,
      "startTime": startTime,
      "endTime": endTime,
    };
    final results = await db.update(
      "todos",
      data,
      where: "id = ?",
      whereArgs: [id],
    );
    return results;
  }

  // Method to delete a task item by ID from the todos table
  static Future<void> deleteItem(int id) async {
    final db = await DBHelper.db();
    try {
      await db.delete("todos", where: "id = ?", whereArgs: [id]);
    } catch (e) {
      debugPrint("Error: $e");
    }
  }
}
