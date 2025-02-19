import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          body: Obx(
            () => controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: controller.refreshMovies,
                          child: ListView.builder(
                            addAutomaticKeepAlives: false,
                            controller: controller.scrollController,
                            itemCount: controller.movies.length,
                            itemBuilder: (context, index) {
                              final movie = controller.movies[index];
                              return ListTile(
                                leading: CachedNetworkImage(
                                  imageUrl:
                                      'https://image.tmdb.org/t/p/w200${movie['poster_path']}',
                                  width: 50,
                                  fit: BoxFit.cover,
                                  memCacheWidth: 100,
                                  memCacheHeight: 150,
                                ),
                                title: Text(movie['title']),
                                subtitle:
                                    Text('Rating: ${movie['vote_average']}'),
                                onTap: () => Get.to(
                                    () => MovieDetailScreen(movie: movie)),
                              );
                            },
                          ),
                        ),
                      ),
                      controller.isLoadingMore.value
                          ? const Center(child: CircularProgressIndicator())
                          : const SizedBox.shrink()
                    ],
                  ),
          ),
        );
      },
    );
  }
}
