import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movie_app/modules/favorite/favorite_controller.dart';
import 'package:movie_app/modules/movie_detail/movie_detail_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: FavoriteController(),
        builder: (FavoriteController controller) {
          return Scaffold(
              appBar: AppBar(title: const Text('Favorite Movies')),
              body: Obx(
                () => controller.favoriteMovies.isEmpty
                    ? const Center(child: Text('No favorite movies yet!'))
                    : ListView.builder(
                        itemCount: controller.favoriteMovies.length,
                        itemBuilder: (context, index) {
                          final movie = controller.favoriteMovies[index];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'https://image.tmdb.org/t/p/w200${movie['poster_path']}',
                                  width: 60,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(movie['title']),
                              subtitle: Row(
                                children: [
                                  const Icon(Icons.star,
                                      size: 16, color: Colors.amber),
                                  const SizedBox(width: 4),
                                  Text(
                                      '${movie['vote_average']?.toStringAsFixed(1) ?? 'N/A'} / 10'),
                                ],
                              ),
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    controller.removeFavorite(movie['id']),
                              ),
                              onTap: () => Get.to(
                                  () => const MovieDetailScreen(),
                                  arguments: movie),
                            ),
                          );
                        },
                      ),
              ));
        });
  }
}
