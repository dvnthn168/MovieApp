import 'package:get/get.dart';
import 'package:movie_app/services/db/db_movies.dart';

class FavoriteController extends GetxController {
  final DbMovies _dbHelper = DbMovies.instance;
  final favoriteMovies = [].obs;
  var _dbFavorite;

  @override
  Future<void> onInit() async {
    _dbFavorite = await _dbHelper.dbFavorite;
    _loadFavorites();
    super.onInit();
  }

  void _loadFavorites() async {
    final favorites = await _dbHelper.getFavorites(_dbFavorite);
    favoriteMovies.value = favorites;
  }

  void removeFavorite(int id) async {
    await _dbHelper.deleteFavorite(_dbFavorite, id);
    _loadFavorites();
  }
}
