import 'package:flutter/material.dart';
import 'package:ten_app/services/api_service.dart';
import 'package:ten_app/models/movie_model.dart';
import 'package:ten_app/screens/movie_detail_screen.dart.dart';
import 'package:shimmer/shimmer.dart';

enum MovieListLoadMovies {
  newMovies,
  popularMovies,
  latestMovies,
  seriesMovies,
}

class MovieList extends StatefulWidget {
  final MovieListLoadMovies loadMovies;

  MovieList({required this.loadMovies});

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  final ApiService apiService =
      ApiService('https://doraflixvn.com/api/api_phim.php');
  late Future<List<Movie>> _moviesFuture;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _moviesFuture = _loadMovies();
  }

  Future<List<Movie>> _loadMovies() async {
    List<Movie> movies;
    switch (widget.loadMovies) {
      case MovieListLoadMovies.newMovies:
        movies = await apiService.getNewMovies();
        break;
      case MovieListLoadMovies.popularMovies:
        movies = await apiService.getPopularMovies();
        break;
      case MovieListLoadMovies.latestMovies:
        movies = await apiService.getLatestMovies();
        break;
      case MovieListLoadMovies.seriesMovies:
        movies = await apiService.getSeriesMovies();
        break;
    }

    setState(() {
      _isLoading = false;
    });

    return movies;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: _moviesFuture,
      builder: (context, snapshot) {
        if (_isLoading) {
          return _buildLoadingSkeleton();
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Lỗi: Không thể kết nối đến máy chủ!'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text('Không có dữ liệu'),
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
                        width: 150.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildImage(movie.image),
                            SizedBox(height: 8.0),
                            _buildTitle(movie.title),
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

  Widget _buildLoadingSkeleton() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          5, // You can adjust the number of skeleton items
          (index) => Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
             width: 150.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageSkeleton(),
                  SizedBox(height: 8.0),
                  _buildTitleSkeleton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Image.network(
        imageUrl,
        width: 150,
        height: 200,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      _truncateText(title, 20),
      style: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      overflow: TextOverflow.ellipsis,
      softWrap: false,
    );
  }

  Widget _buildImageSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          color: Colors.white,
          width: 150,
           height: 200,
        ),
      ),
    );
  }

  Widget _buildTitleSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        color: Colors.white,
        width: 100.0,
        height: 16.0,
      ),
    );
  }

  String _truncateText(String text, int maxLength) {
    if (text.length > maxLength) {
      return text.substring(0, maxLength) + '...';
    }
    return text;
  }
}  
