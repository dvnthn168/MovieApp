import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/modules/movie_list/movie_detail_screen.dart';

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie App',
      theme: ThemeData.dark(),
      home: const MovieListScreen(),
    );
  }
}