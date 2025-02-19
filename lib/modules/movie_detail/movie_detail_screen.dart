import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MovieDetailScreen extends StatelessWidget {
  final dynamic movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    String backdropUrl = movie['backdrop_path'] != null
        ? 'https://image.tmdb.org/t/p/w780${movie['backdrop_path']}'
        : 'https://image.tmdb.org/t/p/w500${movie['poster_path']}';

    String posterUrl = 'https://image.tmdb.org/t/p/w500${movie['poster_path']}';

    return Scaffold(
      appBar: AppBar(title: Text(movie['title'] ?? 'No Title')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _imageBackdrop(backdropUrl),
            _informMovie(posterUrl),
          ],
        ),
      ),
    );
  }

  Widget _informMovie(String posterUrl) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: posterUrl,
                  width: 100,
                  height: 150,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const SizedBox(
                      width: 100,
                      height: 150,
                      child: Center(child: CircularProgressIndicator())),
                  errorWidget: (context, url, error) => Container(
                      width: 100,
                      height: 150,
                      color: Colors.grey,
                      child: const Icon(Icons.error, size: 50)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie['original_title'] ?? 'Unknown Title',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Release Date: ${movie['release_date'] ?? 'N/A'}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
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
          const SizedBox(height: 16),
          Text(
            movie['overview'] ?? 'No description available.',
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _imageBackdrop(String backdropUrl) {
    return CachedNetworkImage(
      imageUrl: backdropUrl,
      width: double.infinity,
      height: 250,
      fit: BoxFit.cover,
      placeholder: (context, url) => const SizedBox(
          height: 250, child: Center(child: CircularProgressIndicator())),
      errorWidget: (context, url, error) => Container(
          height: 250,
          color: Colors.grey,
          child: const Icon(Icons.error, size: 50)),
    );
  }
}
