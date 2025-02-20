import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:movie_app/services/api/dio_clients.dart';

class MovieListController extends GetxController {
  final DioClient dioClient = DioClient();
  final movies = [].obs;
  final isLoading = true.obs;
  final isLoadingMore = false.obs;
  final hasMore = true.obs;
  int currentPage = 1;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    _fetchMovies();
    scrollController.addListener(_loadMoreMovies);
    super.onInit();
  }

  @override
  void dispose() {
    movies.close();
    isLoading.close();
    super.dispose();
  }

  Future<void> _fetchMovies() async {
    try {
      if (!hasMore.value) return;

      final response = await dioClient.get('/movie/popular', queryParameters: {
        'page': currentPage,
      });

      if (currentPage >= response.data['total_pages'] ||
          response.data['results'].length < 20) {
        hasMore.value = false;
      }

      movies.addAll(response.data['results']);
      currentPage++;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load movies');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshMovies() async {
    isLoading.value = true;
    hasMore.value = true;
    currentPage = 1;
    movies.clear();
    await _fetchMovies();
  }

  void _loadMoreMovies() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent) {
      if (!isLoadingMore.value && hasMore.value) {
        isLoadingMore.value = true;
        _fetchMovies().then((_) => isLoadingMore.value = false);
      }
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    imageCache.clear();
    imageCache.clearLiveImages();
    super.onClose();
  }
}
