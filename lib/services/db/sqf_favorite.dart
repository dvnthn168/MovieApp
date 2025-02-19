import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Sqf {
  static Database? _database;
  static const String tableName = 'favorites';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'movies.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY,
            title TEXT,
            poster_path TEXT,
            vote_average REAL
          )''',
        );
      },
    );
  }

  Future<void> addFavorite(Map<String, dynamic> movie, Database db) async {
    await db.insert(tableName, movie, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await database;
    return await db.query(tableName);
  }

  Future<void> removeFavorite(int id) async {
    final db = await database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> isFavorite(int id) async {
    final db = await database;
    final result = await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty;
  }
}
