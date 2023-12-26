import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ten_app/screens/home_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String fullName = '';
  bool isLoggedIn = false;

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
    if (savedUsername != null && savedFullName != null) {
      // Đã có thông tin đăng nhập, thực hiện đăng nhập tự động
      loginUser(savedUsername, savedFullName);
    }
  }

  Future<void> loginUser(String username, String fullName) async {
    setState(() {
      isLoggedIn = true;
      this.fullName = fullName;
    });
  }

  Future<void> performLogout() async {
    // Xóa session khi đăng xuất
    await _secureStorage.delete(key: 'username');
    await _secureStorage.delete(key: 'fullname');

    setState(() {
      isLoggedIn = false;
      fullName = '';
    });
  }

  Future<void> loginUserFromInput() async {
    final response = await http.post(
      Uri.parse('https://doraflixvn.com/api/api_dangnhap.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'login': true, 'username': usernameController.text, 'password': passwordController.text}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success']) {
      // Kiểm tra trạng thái tài khoản
      int trangThai = data['user']['trangthai'];

      if (trangThai == 0) {
        // Đăng nhập thành công, xử lý dữ liệu người dùng
        setState(() {
          isLoggedIn = true;
          fullName = data['user']['fullname'];
        });

        // Lưu session (sử dụng flutter_secure_storage)
        await _secureStorage.write(key: 'username', value: data['user']['username'] ?? '');
        await _secureStorage.write(key: 'fullname', value: data['user']['fullname'] ?? '');

        // Hiển thị Snackbar với thông báo đăng nhập thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đăng nhập thành công!'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
         // Chuyển sang trang chính (HomeScreen)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
         } else if (trangThai == 1) {
        // Tài khoản bị khóa, hiển thị thông báo
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tài khoản của bạn đang bị khóa.'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
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
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Đăng nhập'),
             backgroundColor: Colors.black, // Màu nền
        foregroundColor: Colors.white, // Màu chữ
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
