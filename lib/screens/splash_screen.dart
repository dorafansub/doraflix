import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ten_app/screens/home_screen.dart';
import 'package:ten_app/screens/login_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), _navigateToNextScreen);
  }

  Future<bool> isUserLoggedIn() async {
    String? savedUsername = await _secureStorage.read(key: 'username');
    String? savedFullName = await _secureStorage.read(key: 'fullname');
    return savedUsername != null && savedFullName != null;
  }

  void _navigateToNextScreen() async {
    bool isLoggedIn = await isUserLoggedIn();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => isLoggedIn ? HomeScreen() : LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          '../assets/icon/doraflix.png',  // Đặt đường dẫn đúng đến file logo của bạn
          width: 200,  // Điều chỉnh kích thước hình ảnh nếu cần
          height: 200,
        ),
      ),
    );
  }
}
