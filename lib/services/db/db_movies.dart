import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbMovies {
  static Database? _dbFavorite;
  static final DbMovies instance = DbMovies._init();

  DbMovies._init();

  Future<Database> get dbFavorite async {
    if (_dbFavorite != null) return _dbFavorite!;
    _dbFavorite = await _initFavorites();
    return _dbFavorite!;
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

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await dbFavorite;
    return await db.query('favorites');
  }

  Future<int> addFavorite(Map<String, dynamic> movie) async {
    final db = await dbFavorite;
    return await db.insert('favorites', movie);
  }

  Future<int> deleteFavorite(int id) async {
    final db = await dbFavorite;
    return await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> isFavorite(int id) async {
    final db = await dbFavorite;
    final result =
        await db.query('favorites', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty;
  }

  Future<void> close() async {
    if (_dbFavorite != null && _dbFavorite!.isOpen) {
      await _dbFavorite!.close();
      _dbFavorite = null;
    }
  }

  Future<void> deleteDatabaseFile() async {
    String path = join(await getDatabasesPath(), 'movies.db');
    await deleteDatabase(path);
    _dbFavorite = null;
  }
}
