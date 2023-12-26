import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ten_app/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String fullName = '';
  bool isLoggedIn = false;
  String userAvatarUrl = ''; // Thêm biến này để lưu URL của avatar

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    // Kiểm tra nếu có session đã lưu, tức là đã đăng nhập trước đó
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    String? savedUsername = await _secureStorage.read(key: 'username');
    String? savedFullName = await _secureStorage.read(key: 'fullname');
    String? savedUserAvatarUrl = await _secureStorage.read(key: 'userAvatarUrl');

    if (savedUsername != null && savedFullName != null) {
      // Đã có thông tin đăng nhập, thực hiện đăng nhập tự động
      loginUser(savedUsername, savedFullName, savedUserAvatarUrl);
    }
  }

  Future<void> loginUser(String username, String fullName, String? userAvatarUrl) async {
    setState(() {
      isLoggedIn = true;
      this.fullName = fullName;
      this.userAvatarUrl = userAvatarUrl ?? ''; // Nếu không có URL, gán giá trị mặc định
    });
  }

  Future<void> performLogout() async {
    // Xóa session khi đăng xuất
    await _secureStorage.delete(key: 'username');
    await _secureStorage.delete(key: 'fullname');
    await _secureStorage.delete(key: 'userAvatarUrl');

    setState(() {
      isLoggedIn = false;
      fullName = '';
      userAvatarUrl = '';
    });
    // Chuyển hướng đến trang đăng nhập sau khi đăng xuất
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Future<void> loginUserFromInput() async {
    final response = await http.post(
      Uri.parse('https://doraflixvn.com/api/api_dangnhap.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'login': true,
        'username': usernameController.text,
        'password': passwordController.text
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data['success']) {
        // Đăng nhập thành công, xử lý dữ liệu người dùng
        setState(() {
          isLoggedIn = true;
          fullName = data['user']['fullname'];
          userAvatarUrl = data['user']['avatar'] ?? '';
        });

        // Lưu session (sử dụng flutter_secure_storage)
        await _secureStorage.write(key: 'username', value: data['user']['username'] ?? '');
        await _secureStorage.write(key: 'fullname', value: data['user']['fullname'] ?? '');
        await _secureStorage.write(key: 'userAvatarUrl', value: userAvatarUrl);

        // Hiển thị Snackbar với thông báo đăng nhập thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đăng nhập thành công!'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        // Đăng nhập thất bại, hiển thị Snackbar với thông báo lỗi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đăng nhập thất bại: ${data['message']}'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      // Xử lý lỗi kết nối
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi kết nối: ${response.reasonPhrase}'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
      // Giao diện đã đăng nhập
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Trang Cá Nhân'),
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: performLogout,
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[200],
            backgroundImage: userAvatarUrl.isNotEmpty ? Image.network(userAvatarUrl).image : AssetImage('../assets/icon/icon.png'),
            ),
            SizedBox(height: 16),
            Text(
              fullName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Thêm các phần tử giao diện khác ở đây
          ],
        ),
      );
    } else {
      // Giao diện đăng nhập
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Đăng nhập'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Tên đăng nhập'),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Mật khẩu'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: loginUserFromInput,
                child: Text('Đăng nhập'),
              ),
            ],
          ),
        ),
      );
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: AccountScreen(),
  ));
}
