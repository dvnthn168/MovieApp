import 'dart:developer';

import 'package:get/get.dart';
import 'package:movie_app/services/db/db_movies.dart';

class FavoriteController extends GetxController {
  final DbMovies _dbHelper = DbMovies.instance;
  final favoriteMovies = [].obs;

  @override
  Future<void> onInit() async {
    _loadFavorites();
    super.onInit();
  }

  void _loadFavorites() async {
    try {
      final favorites = await _dbHelper.getFavorites();
      favoriteMovies.value = favorites;
    } catch (e, stackTrace) {
      log('_loadFavorites: Error - $e',
          name: 'FavoriteController', error: e, stackTrace: stackTrace);
    }
  }

  void removeFavorite(int id) async {
    try {
      await _dbHelper.deleteFavorite(id);
      _loadFavorites();
    } catch (e, stackTrace) {
      log('removeFavorite: Error - $e',
          name: 'FavoriteController', error: e, stackTrace: stackTrace);
    }
  }
}
