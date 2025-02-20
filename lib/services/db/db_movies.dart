import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbMovies {
  static Database? _database;
  static final DbMovies instance = DbMovies._init();

  DbMovies._init();

  Future<Database> get dbFavorite async {
    if (_database != null) return _database!;
    _database = await _initFavorites();
    return _database!;
  }

  Future<Database> _initFavorites() async {
    String path = join(await getDatabasesPath(), 'movies.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE IF NOT EXISTS favorites (
          id INTEGER PRIMARY KEY,
          adult BOOLEAN NOT NULL,
          backdrop_path TEXT,
          genre_ids TEXT, 
          original_language TEXT,
          original_title TEXT,
          overview TEXT,
          popularity REAL,
          poster_path TEXT,
          release_date TEXT,
          title TEXT,
          video BOOLEAN NOT NULL,
          vote_average REAL,
          vote_count INTEGER
        )''',
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> getFavorites(Database db) async {
    return await db.query('favorites');
  }

  Future<int> addFavorite(Database db, Map<String, dynamic> movie) async {
    return await db.insert('favorites', movie);
  }

  Future<int> deleteFavorite(Database db, int id) async {
    return await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> isFavorite(Database db, int id) async {
    final result =
        await db.query('favorites', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty;
  }

  Future close(Database db) async => db.close();

  // delete db
  Future delete(path) async => deleteDatabase(path);
}
