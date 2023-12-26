import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ten_app/models/movie_model.dart';

class ApiService {
  final String apiUrl;

  ApiService(this.apiUrl);

  Future<List<Movie>> getNewMovies() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> newMoviesData = data['phim_moi'];
      return newMoviesData.map((e) => Movie(
        title: e['tieu_de'],
        image: e['hinh_anh'],
        link: e['lien_ket'],
        isShowing: e['sap_chieu'],
      )).toList();
    } else {
      throw Exception('Failed to load new movies');
    }
  }

  Future<List<Movie>> getPopularMovies() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> popularMoviesData = data['phim_pho_bien'];
      return popularMoviesData.map((e) => Movie(
        title: e['tieu_de'],
        image: e['hinh_anh'],
        link: e['lien_ket'],
        isShowing: e['sap_chieu'],
      )).toList();
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  Future<List<Movie>> getLatestMovies() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> latestMoviesData = data['phim_le'];
      return latestMoviesData.map((e) => Movie(
        title: e['tieu_de'],
        image: e['hinh_anh'],
        link: e['lien_ket'],
        isShowing: e['sap_chieu'],
      )).toList();
    } else {
      throw Exception('Failed to load latest movies');
    }
  }
  Future<List<Movie>> getSearchResults(String searchTerm) async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> searchResultsData = data['phim_tim_kiem'];

      // Filter search results based on the searchTerm
      final List<Movie> searchResults = searchResultsData
          .where((movie) =>
              movie['tieu_de'].toLowerCase().contains(searchTerm.toLowerCase()))
          .map((e) => Movie(
                title: e['tieu_de'],
                image: e['hinh_anh'],
                link: e['lien_ket'],
                isShowing: e['sap_chieu'],
              ))
          .toList();

      return searchResults;
    } else {
      throw Exception('Failed to load search results');
    }
  }
  Future<List<Movie>> getSeriesMovies() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> seriesMoviesData = data['phim_bo'];
      return seriesMoviesData.map((e) => Movie(
        title: e['tieu_de'],
        image: e['hinh_anh'],
        link: e['lien_ket'],
        isShowing: e['sap_chieu'],
      )).toList();
    } else {
      throw Exception('Failed to load series movies');
    }
  }
}