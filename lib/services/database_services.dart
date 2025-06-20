// services/database_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../mvc/models/checklist_item.dart';

class DatabaseService {

  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  // ===========================================================
  // = Section: Getter method for database =
  // ===========================================================


  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // ===========================================================
  // = Section: Method to initialize database =
  // ===========================================================

  Future<Database> _initDatabase() async {
    try{
      String path = join(await getDatabasesPath(), 'checklist.db');
      return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
      );
    } catch (e) {
        throw Exception('Failed to initialize database : $e');
    }
  }

  // ===========================================================
  // = Section: Table creation =
  // ===========================================================

  Future<void> _onCreate(Database db, int version) async {
    try {
      await db.execute('''
    CREATE TABLE checklist_items(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      isCompleted INTEGER NOT NULL DEFAULT 0,
      createdAt INTEGER NOT NULL,
      dueDate INTEGER,
      category TEXT
    )
  ''');
    } catch (e) {
      throw Exception('Failed to create database tables: $e');
    }
  }

  //region crud methods

  // ===========================================================
  // = Section: Method to retrieve all items =
  // ===========================================================

  Future<List<ChecklistItem>> getAllItems() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'checklist_items',
        orderBy: 'createdAt DESC'
      );
      return List.generate(maps.length, (i) => ChecklistItem.fromMap(maps[i]));
    } catch (e) {
      throw Exception('Failed to get all items: $e');
    }
  }

  // ===========================================================
  // = Section: Method to insert item in the database =
  // ===========================================================

  Future<int> insertItem(ChecklistItem item) async {
    try {
      final db = await database;
      final itemMap = item.toMap();
      // Remove id from map as it's auto-increment
      itemMap.remove('id');
      return await db.insert('checklist_items', itemMap);
    } catch (e) {
      throw Exception('Failed to insert item: $e');
    }
  }

  // ===========================================================
  // = Section: Method to update existing item in the database =
  // ===========================================================

  Future<int> updateItem(ChecklistItem item) async {
    try {
      final db = await database;
      if (item.id == null) {
        throw Exception('Cannot update item without ID');
      }

      final result = await db.update(
        'checklist_items',
        item.toMap(),
        where: 'id = ?',
        whereArgs: [item.id],
      );

      if (result == 0) {
        throw Exception('No item found with id ${item.id}');
      }

      return result;
    } catch (e) {
      throw Exception('Failed to update item: $e');
    }
  }

  // ===========================================================
  // = Section: Method to delete item from the database =
  // ===========================================================

  Future<int> deleteItem(int id) async {
    try {
      final db = await database;
      final result = await db.delete(
        'checklist_items',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (result == 0) {
        throw Exception('No item found with id $id');
      }

      return result;
    } catch (e) {
      throw Exception('Failed to delete item: $e');
    }
  }

  //endregion
}
