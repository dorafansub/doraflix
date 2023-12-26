import 'package:flutter/material.dart';
import 'package:ten_app/services/api_service.dart';
import 'package:ten_app/models/movie_model.dart';
import 'package:ten_app/screens/movie_detail_screen.dart.dart';

enum MovieListLoadMovies {
  newMovies,
  popularMovies,
  latestMovies,
  seriesMovies,
}

class MovieList extends StatelessWidget {
  final ApiService apiService =
      ApiService('https://doraflixvn.com/api/api_dataphim.php');
  final MovieListLoadMovies loadMovies;

  MovieList({required this.loadMovies});

  Future<List<Movie>> _loadMovies() async {
    switch (loadMovies) {
      case MovieListLoadMovies.newMovies:
        return apiService.getNewMovies();
      case MovieListLoadMovies.popularMovies:
        return apiService.getPopularMovies();
      case MovieListLoadMovies.latestMovies:
        return apiService.getLatestMovies();
      case MovieListLoadMovies.seriesMovies:
        return apiService.getSeriesMovies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: _loadMovies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Lỗi: Không thể kết nối đến máy chủ!'),
          );
        } else {
          final movies = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var movie in movies)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailScreen(
                            link: movie.link,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                        width: 155.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.network(
                                movie.image,
                                width: 250.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              _truncateText(movie.title, 20),
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }
      },
    );
  }

  String _truncateText(String text, int maxLength) {
    if (text.length > maxLength) {
      return text.substring(0, maxLength) + '...';
    }
    return text;
  }
}
