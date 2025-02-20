import 'dart:developer';

import 'package:get/get.dart';
import 'package:movie_app/services/db/db_movies.dart';

class MovieDetailController extends GetxController {
  final DbMovies _dbHelper = DbMovies.instance;
  final isFavorite = false.obs;
  dynamic movie;

  @override
  Future<void> onInit() async {
    super.onInit();
    movie = Get.arguments;
    _checkFavorite();
  }

  void _checkFavorite() async {
    try {
      bool fav = await _dbHelper.isFavorite(movie['id']);
      isFavorite.value = fav;
    } catch (e, stackTrace) {
      log('_checkFavorite: Error - $e',
          name: 'MovieDetailController', error: e, stackTrace: stackTrace);
    }
  }

  void toggleFavorite() async {
    try {
      if (isFavorite.value) {
        await _dbHelper.deleteFavorite(movie['id']);
      } else {
        await _dbHelper.addFavorite(movie);
      }
      isFavorite.toggle();
    } catch (e, stackTrace) {
      log('toggleFavorite: Error - $e',
          name: 'MovieDetailController', error: e, stackTrace: stackTrace);
    }
  }
}
