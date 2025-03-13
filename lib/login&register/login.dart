import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:superhomemart2/login&register/ForgetPassword.dart';
import 'package:superhomemart2/login&register/register.dart';
import 'package:superhomemart2/Pagemain/widgets_main/page1_bar_main.dart'; // Update the import
import 'package:flutter_svg/flutter_svg.dart'; // เพิ่มการนำเข้า
import 'package:shared_preferences/shared_preferences.dart'; // นำเข้า SharedPreferences

class LoginPage extends StatefulWidget {
  final bool showBackButton;

  const LoginPage({super.key, this.showBackButton = true});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false; // สถานะการแสดงรหัสผ่าน
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

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          users = jsonData;
        });
        debugPrint("Success: $jsonData");
      } else {
        debugPrint("Error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Exception: $e");
    }
  }

  Future<void> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username'); // ลบชื่อผู้ใช้
    await prefs.setBool(
        'isLoggedIn', false); // เปลี่ยนสถานะการเข้าสู่ระบบเป็น false
  }

  @override
  void initState() {
    super.initState();
    fetchUsers(); // เรียกใช้ฟังก์ชันเพื่อดึงข้อมูลผู้ใช้เมื่อเปิดหน้า
  }

  // ฟังก์ชันแสดง alert message
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
              ), // ใช้ SVG แทนไอคอน
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

  // ฟังก์ชันเปรียบเทียบข้อมูลผู้ใช้จาก API กับข้อมูลที่กรอก
  void _loginUser() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showAlert(context, 'กรุณากรอกข้อมูลให้ครบ');
    } else {
      bool userFound = false;
      for (var user in users) {
        if (user['username'] == username &&
            BCrypt.checkpw(password, user['password'])) {
          userFound = true;

          // บันทึกข้อมูลการเข้าสู่ระบบใน SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('username', username); // เก็บชื่อผู้ใช้
          await prefs.setBool('isLoggedIn', true); // เก็บสถานะการเข้าสู่ระบบ

          // แสดงชื่อผู้ใช้บน terminal
          debugPrint("Logged in as: $username");

          break;
        }
      }

      if (userFound) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const Custom_MBottomNavigationBar()), // ไปยังหน้า Page1BarMain
        );
      } else {
        _showAlert(context, 'ใส่ username หรือ password ไม่ถูกต้อง');
      }
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
              child: Container(
                  color:
                      Colors.black.withAlpha(25)), // 0.1 * 255 = 25.5 ประมาณ 25
            ),
          ),
          // ปุ่มย้อนกลับ
          if (widget.showBackButton)
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: SvgPicture.asset(
                  'assets/Icon/left.svg',
                  color: Colors.white,
                ), // ใช้ SVG แทนไอคอน
                onPressed: () {
                  Navigator.pop(context);
                },
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
                        ), // ใช้ SVG แทนไอคอน
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      filled: true,
                      fillColor: Colors.white.withAlpha(
                          (0.8 * 255).toInt()), // เปลี่ยนจาก withOpacity
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText:
                        !_isPasswordVisible, // ใช้ค่า _isPasswordVisible
                    decoration: InputDecoration(
                      hintText: 'Type your password',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(
                          'assets/Icon/lock.svg',
                          width: 24,
                          height: 24,
                        ), // ใช้ SVG แทนไอคอน
                      ),
                      suffixIcon: IconButton(
                        icon: SvgPicture.asset(
                          _isPasswordVisible
                              ? 'assets/Icon/eyeon.svg'
                              : 'assets/Icon/eyeoff.svg',
                          color: Colors.grey,
                          width: 24,
                          height: 24,
                        ), // ใช้ SVG แทนไอคอน
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible =
                                !_isPasswordVisible; // เปลี่ยนสถานะการแสดงรหัสผ่าน
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      filled: true,
                      fillColor: Colors.white.withAlpha(
                          (0.8 * 255).toInt()), // เปลี่ยนจาก withOpacity
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgetPasswordPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'ลืมรหัสผ่าน?',
                        style:
                            TextStyle(color: Colors.white, fontFamily: 'Kanit'),
                      ),
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
                        onPressed: _loginUser, // เรียกใช้ฟังก์ชันการเข้าสู่ระบบ
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
                  const Text(
                    'Sign Up Using',
                    style: TextStyle(color: Colors.white, fontFamily: 'Kanit'),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // IconButton(
                      //   icon: SvgPicture.asset(
                      //     'assets/Icon/facebook.svg',
                      //     width: 30,
                      //     height: 30,
                      //     color: const Color.fromARGB(180, 255, 255, 255),
                      //   ), // ใช้ SVG แทนไอคอน
                      //   onPressed: () {},
                      // ),
                      //   IconButton(
                      //     icon: SvgPicture.asset(
                      //       'assets/Icon/gmail.svg',
                      //       width: 30,
                      //       height: 30,
                      //       color: const Color.fromARGB(180, 255, 255, 255),
                      //     ), // ใช้ SVG แทนไอคอน
                      //     onPressed: () {},
                      //   ),
                      //   IconButton(
                      //     icon: SvgPicture.asset(
                      //       'assets/Icon/phone.svg',
                      //       width: 30,
                      //       height: 30,
                      //       color: const Color.fromARGB(180, 255, 255, 255),
                      //     ), // ใช้ SVG แทนไอคอน
                      //     onPressed: () {},
                      //   ),
                    ],
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
                        fontSize: 20, // เพิ่มขนาดฟอนต์
                        fontWeight: FontWeight
                            .bold, // ทำให้ตัวหนังสือหนาขึ้น (เพิ่มหรือไม่ก็ได้)
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
