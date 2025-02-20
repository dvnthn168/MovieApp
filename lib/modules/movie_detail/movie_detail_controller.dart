import 'package:get/get.dart';
import 'package:movie_app/services/db/db_movies.dart';

class MovieDetailController extends GetxController {
  final DbMovies _dbHelper = DbMovies.instance;
  var _dbFavorite;
  final isFavorite = false.obs;
  dynamic movie;

  @override
  Future<void> onInit() async {
    super.onInit();
    movie = Get.arguments;
    _dbFavorite = await _dbHelper.dbFavorite;
    _checkFavorite();
  }

  void _checkFavorite() async {
    bool fav = await _dbHelper.isFavorite(_dbFavorite, movie['id']);
    isFavorite.value = fav;
  }

  void toggleFavorite() async {
    if (isFavorite.value) {
      await _dbHelper.deleteFavorite(_dbFavorite, movie['id']);
    } else {
      await _dbHelper.addFavorite(_dbFavorite, movie);
    }

    isFavorite.toggle();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
