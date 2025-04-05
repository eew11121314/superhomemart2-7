import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:superhomemart2/login&register/register.dart';
import 'package:superhomemart2/Pagemain/widgets_main/page1_bar_main.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:superhomemart2/Pagemain/order_main/cart/cart_provider_m.dart';

class LoginPage extends StatefulWidget {
  final bool showBackButton;

  const LoginPage({super.key, this.showBackButton = true});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false; // ใช้สำหรับแสดง/ซ่อนรหัสผ่าน
  List<dynamic> users = []; // เก็บข้อมูลผู้ใช้จาก API

  // ฟังก์ชันดึงข้อมูลผู้ใช้จาก API
  Future<void> fetchUsers() async {
    const String url = "https://superhomemart.duckdns.org/api/user/member/app";
    const String apiKey = "WHt)m6gpqxkF1r(oDczv8mq%";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'x-api-key': apiKey,
        },
      );

      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (mounted) {
          setState(() {
            users = jsonData;
          });
        }
        debugPrint("Users fetched: $jsonData");
      } else {
        if (mounted) {
          _showAlert(context,
              "ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้ (Error: ${response.statusCode})");
        }
      }
    } catch (e) {
      debugPrint("Exception: $e");
      if (mounted) {
        _showAlert(context, "เกิดข้อผิดพลาด: $e");
      }
    }
  }

  // ฟังก์ชันเข้าสู่ระบบ
  void _loginUser() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showAlert(context, 'กรุณากรอกข้อมูลให้ครบ');
      return;
    }

    debugPrint("Input username: $username");
    debugPrint("Input password: $password");

    bool userFound = false;
    for (var user in users) {
      debugPrint("Checking user: ${user['username']}");
      if (user['username'] == username) {
        debugPrint("Username matched: ${user['username']}");
        if (BCrypt.checkpw(password, user['password'])) {
          debugPrint("Password matched for user: $username");
          userFound = true;

          // บันทึกข้อมูลการเข้าสู่ระบบใน SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('username', username);
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('userData', json.encode(user));

          // โหลดข้อมูลตะกร้าสินค้าของผู้ใช้
          final cartProvider =
              Provider.of<CartProvider>(context, listen: false);
          await cartProvider.loadCart(username);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Custom_MBottomNavigationBar(),
            ),
          );
          return;
        } else {
          debugPrint("Password mismatch for user: $username");
          _showAlert(context, 'รหัสผ่านไม่ถูกต้อง');
          return;
        }
      }
    }

    if (!userFound) {
      debugPrint("User not found: $username");
      _showAlert(context, 'ไม่พบชื่อผู้ใช้นี้ในระบบ');
    }
  }

  // ฟังก์ชันแสดงข้อความแจ้งเตือน
  void _showAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/Icon/wrong.svg',
                color: Colors.red,
                width: 50,
                height: 50,
              ),
              const SizedBox(height: 10),
              Text(
                message,
                style: const TextStyle(fontFamily: 'Kanit'),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(fontFamily: 'Kanit'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      String? userData = prefs.getString('userData');
      if (userData != null) {
        if (mounted) {
          setState(() {
            users = [json.decode(userData)];
          });
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const Custom_MBottomNavigationBar()),
        );
      }
    } else {
      fetchUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // พื้นหลังแบบ Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF073074), Color(0xFF1a6f96)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // เอฟเฟกต์เบลอ
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.black.withAlpha(25)),
            ),
          ),
          // เนื้อหาหลัก
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  const Text(
                    'เข้าสู่ระบบ',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Kanit',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Type your username',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(
                          'assets/Icon/username.svg',
                          width: 24,
                          height: 24,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      filled: true,
                      fillColor: Colors.white.withAlpha((0.8 * 255).toInt()),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Type your password',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(
                          'assets/Icon/lock.svg',
                          width: 24,
                          height: 24,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: SvgPicture.asset(
                          _isPasswordVisible
                              ? 'assets/Icon/eyeon.svg'
                              : 'assets/Icon/eyeoff.svg',
                          color: Colors.grey,
                          width: 24,
                          height: 24,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      filled: true,
                      fillColor: Colors.white.withAlpha((0.8 * 255).toInt()),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6D0EB5), Color(0xFF4059F1)],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ElevatedButton(
                        onPressed: _loginUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'เข้าสู่ระบบ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Kanit',
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'สมัครสมาชิก',
                      style: TextStyle(
                        color: Color(0xFFCFEE80),
                        fontFamily: 'Kanit',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
