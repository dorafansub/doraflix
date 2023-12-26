import 'package:flutter/material.dart';
import 'package:ten_app/widgets/movie_list.dart';

class HomeTabScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Mới phát hành',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: const Color.fromRGBO(255, 255, 255, 1),
              ),
            ),
          ),
          MovieList(
            loadMovies: MovieListLoadMovies.newMovies,
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Phim thịnh hành',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: const Color.fromRGBO(255, 255, 255, 1),
              ),
            ),
          ),
          MovieList(
            loadMovies: MovieListLoadMovies.popularMovies,
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Phim lẻ',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: const Color.fromRGBO(255, 255, 255, 1),
              ),
            ),
          ),
          MovieList(
            loadMovies: MovieListLoadMovies.latestMovies,
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Phim bộ',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: const Color.fromRGBO(255, 255, 255, 1),
              ),
            ),
          ),
          MovieList(
            loadMovies: MovieListLoadMovies.seriesMovies,
          ),
        ],
      ),
    );
  }
}
