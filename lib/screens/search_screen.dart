import 'package:flutter/material.dart';
import 'package:ten_app/services/api_service.dart';
import 'package:ten_app/models/movie_model.dart';
import 'package:ten_app/screens/movie_detail_screen.dart.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiService apiService =
      ApiService('https://doraflixvn.com/api/api_dataphim.php');
  late TextEditingController _searchController;
  bool _searching = false;
  List<Movie> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Nhập tên phim...',
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: TextStyle(color: Colors.white),
          onSubmitted: (value) {
            _performSearch();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _performSearch();
            },
          ),
        ],
        backgroundColor: Colors.grey[800],
      ),
      body: _searching
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _searchResults.isNotEmpty
              ? _buildSearchResults()
              : Center(
                  child: Text(
                    'Không có kết quả tìm kiếm.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildSearchResults() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0, // Khoảng cách giữa các cột
        mainAxisSpacing: 8.0,   // Khoảng cách giữa các hàng
        childAspectRatio: 0.6, // Tỷ lệ giữa chiều rộng và chiều cao
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Xử lý khi nhấp vào phim
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailScreen(
                  link: _searchResults[index].link,
                ),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  _searchResults[index].image,
                  width: 250.00, // Chiều rộng tối đa
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 8.0),
                Text(
                  _truncateText(_searchResults[index].title, 20),
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
        );
      },
    );
  }

  String _truncateText(String text, int maxLength) {
    if (text.length > maxLength) {
      return text.substring(0, maxLength) + '...';
    }
    return text;
  }

  void _performSearch() {
    setState(() {
      _searching = true;
      _searchResults.clear(); // Xóa kết quả tìm kiếm trước đó
    });

    // Lấy từ khóa tìm kiếm từ người dùng
    String searchTerm = _searchController.text.trim();

    // Nếu từ khóa tìm kiếm không rỗng, thực hiện tìm kiếm
    if (searchTerm.isNotEmpty) {
      // Gọi hàm để tìm kiếm theo từ khóa và cập nhật giao diện
      apiService.getSearchResults(searchTerm).then((searchResults) {
        setState(() {
          _searching = false;
          _searchResults.addAll(searchResults);
        });
      }).catchError((error) {
        print('Error searching for $searchTerm: $error');
        // Xử lý lỗi nếu có
        setState(() {
          _searching = false;
        });
      });
    } else {
      setState(() {
        _searching = false;
      });
    }
  }
}
