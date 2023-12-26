import 'package:flutter/material.dart';
import 'package:ten_app/screens/video_player.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieDetailScreen extends StatefulWidget {
  final String link;

  MovieDetailScreen({required this.link});

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Future<Map<String, dynamic>> movieData;

  @override
  void initState() {
    super.initState();
    movieData = _fetchMovieData(widget.link);
  }

  Future<Map<String, dynamic>> _fetchMovieData(String link) async {
    final response = await http.get(Uri.parse('https://doraflixvn.com/api/api_phim.php?link_phim=$link'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Lỗi: Không thể kết nối đến máy chủ!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thông tin phim',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: FutureBuilder<Map<String, dynamic>>(
          future: movieData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Lỗi: ${snapshot.error}'));
            } else {
              final movie = snapshot.data!['phim'];
              final tapPhimList = snapshot.data!['tap_phim'];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      movie['ten_phim'],
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: tapPhimList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            'Tập ${tapPhimList[index]['so_tap']}',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoPlayerWidget(
                                  videoUrl: tapPhimList[index]['link_player'],
                                  tenPhim: movie['ten_phim'],
                                  soTap: tapPhimList[index]['so_tap'],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
