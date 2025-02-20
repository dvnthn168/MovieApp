import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/modules/favorite/favorite_screen.dart';
import 'package:movie_app/modules/movie_list/movie_list_controller.dart';
import 'package:movie_app/modules/movie_detail/movie_detail_screen.dart';

class MovieListScreen extends StatelessWidget {
  const MovieListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: MovieController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: const Text('Popular Movies')),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.movie), label: "Movies"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite), label: "Favorites"),
            ],
            onTap: (index) {
              if (index == 1) {
                Get.to(() => const FavoriteScreen());
              }
            },
          ),
          body: Obx(
            () => controller.isLoading.value
                ? _circularLoading()
                : Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: controller.refreshMovies,
                          child: ListView.builder(
                            controller: controller.scrollController,
                            itemCount: controller.movies.length,
                            itemBuilder: (context, index) {
                              final movie = controller.movies[index];

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 6.0),
                                child: InkWell(
                                  onTap: () => Get.to(
                                      () => const MovieDetailScreen(),
                                      arguments: movie),
                                  borderRadius: BorderRadius.circular(12),
                                  child: _cardItem(movie),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      controller.isLoadingMore.value
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: _circularLoading(),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _circularLoading() => const Center(child: CircularProgressIndicator());

  Widget _cardItem(movie) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl:
                    'https://image.tmdb.org/t/p/w200${movie['poster_path']}',
                width: 100,
                height: 150,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 100,
                  height: 150,
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 100,
                  height: 150,
                  color: Colors.grey,
                  child: const Icon(Icons.error, size: 40),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie['title'] ?? 'No Title',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        movie['release_date'] ?? 'N/A',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 18, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '${movie['vote_average']?.toStringAsFixed(1) ?? 'N/A'} / 10',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
