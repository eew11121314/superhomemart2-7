import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart'; // นำเข้า package สำหรับใช้ TextInputFormatter
import 'package:flutter_svg/flutter_svg.dart'; // เพิ่มการนำเข้า
import 'package:superhomemart2/login&register/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController(); // ยืนยันรหัสผ่าน
  final TextEditingController _firstNameController =
      TextEditingController(); // ชื่อจริง
  final TextEditingController _lastNameController =
      TextEditingController(); // นามสกุล
  final TextEditingController _phoneController =
      TextEditingController(); // เบอร์โทร
  final TextEditingController _addressController =
      TextEditingController(); // ที่อยู่

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // ตัวแปรสำหรับควบคุมการแสดงผลของฟิลด์
  bool _showPhoneField = false;
  bool _showEmailField = false;
  bool _showAddressField = false;

  // ตัวแปรสำหรับตรวจสอบกรอบที่ผิด
  bool _isUsernameValid = true;
  bool _isEmailValid = true;
  bool _isPasswordValid = true;
  bool _isConfirmPasswordValid = true;
  bool _isFirstNameValid = true;
  bool _isLastNameValid = true;
  bool _isPhoneValid = true;
  bool _isAddressValid = true;

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

  // ฟังก์ชันเชื่อมต่อ API
  Future<void> _registerUser() async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String phone = _phoneController.text;
    String address = _addressController.text;

    // ตรวจสอบข้อมูลที่กรอกในแต่ละช่อง
    setState(() {
      _isUsernameValid = username.isNotEmpty;
      _isEmailValid = _showEmailField ? email.isNotEmpty : true;
      _isPasswordValid = password.isNotEmpty;
      _isConfirmPasswordValid = confirmPassword.isNotEmpty;
      _isFirstNameValid = firstName.isNotEmpty;
      _isLastNameValid = lastName.isNotEmpty;
      _isPhoneValid =
          _showPhoneField ? phone.isNotEmpty && phone.length == 10 : true;
      _isAddressValid = _showAddressField ? address.isNotEmpty : true;
    });

    // เช็คข้อมูลที่จำเป็นก่อนส่งไปยัง API
    if (!(_isUsernameValid &&
        _isEmailValid &&
        _isPasswordValid &&
        _isConfirmPasswordValid &&
        _isFirstNameValid &&
        _isLastNameValid &&
        _isPhoneValid &&
        _isAddressValid)) {
      _showAlert(context, 'กรุณาเติมให้ครบทุกช่อง');
      return;
    }

    if (password != confirmPassword) {
      _showAlert(context, 'รหัสผ่านไม่ตรงกัน');
      return;
    }

    // ส่งข้อมูลไปยัง API
    try {
      var url = Uri.parse(
          'https://superhomemart.duckdns.org/api/upload/user/member/app');
      var response = await http.post(url, body: {
        'fname': firstName,
        'lname': lastName,
        'number': phone,
        'email': email,
        'username': username,
        'password': password,
        'address': address,
        'membership_levels': 'member',
      });

      if (response.statusCode == 201) {
        var data = jsonDecode(response.body);
        if (mounted) {
          if (data['message'] != null && data['message'] != '') {
            _showAlert(context, 'Registration successful: ${data['message']}');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          }
        } else {
          if (mounted) {
            _showAlert(context, 'Unexpected success response');
          }
        }
      } else {
        if (mounted) {
          _showAlert(context, 'ลงทะเบียนไม่สำเร็จ');
        }
      }
    } catch (e) {
      if (mounted) {
        _showAlert(context, 'An error occurred: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/Icon/left.svg',
            color: Colors.white,
            width: 24,
            height: 24,
          ), // ใช้ SVG แทนไอคอน
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('', style: TextStyle(fontFamily: 'Kanit')),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF072E6F), Color(0xFF0C437D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF073074), Color(0xFF1a6f96)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'สมัครสมาชิก',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Kanit',
                    ),
                  ),
                  const SizedBox(height: 20),
                  // ชื่อจริง
                  TextField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      hintText: 'First Name',
                      hintStyle: const TextStyle(fontFamily: 'Kanit'),
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
                      fillColor: _isFirstNameValid
                          ? Colors.white.withAlpha((0.8 * 255).toInt())
                          : Colors.red.withAlpha((0.3 * 255).toInt()),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // นามสกุล
                  TextField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      hintText: 'Last Name',
                      hintStyle: const TextStyle(fontFamily: 'Kanit'),
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
                      fillColor: _isLastNameValid
                          ? Colors.white.withAlpha((0.8 * 255).toInt())
                          : Colors.red.withAlpha((0.3 * 255).toInt()),
                    ),
                  ),
                  // const SizedBox(height: 16),
                  // เบอร์โทร (ใส่เฉพาะตัวเลขและจำกัด 10 ตัว)
                  Visibility(
                    visible: _showPhoneField, // ซ่อน TextField สำหรับเบอร์โทร
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly, // แค่ตัวเลข
                        LengthLimitingTextInputFormatter(10), // จำกัด 10 ตัว
                      ],
                      decoration: InputDecoration(
                        hintText: 'Phone Number',
                        hintStyle: const TextStyle(fontFamily: 'Kanit'),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            'assets/Icon/phone.svg',
                            width: 24,
                            height: 24,
                          ), // ใช้ SVG แทนไอคอน
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor: _isPhoneValid
                            ? Colors.white.withAlpha((0.8 * 255).toInt())
                            : Colors.red.withAlpha((0.3 * 255).toInt()),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // ชื่อผู้ใช้
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      hintStyle: const TextStyle(fontFamily: 'Kanit'),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(
                          'assets/Icon/username2.svg',
                          width: 24,
                          height: 24,
                        ), // ใช้ SVG แทนไอคอน
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      filled: true,
                      fillColor: _isUsernameValid
                          ? Colors.white.withAlpha((0.8 * 255).toInt())
                          : Colors.red.withAlpha((0.3 * 255).toInt()),
                    ),
                  ),
                  // const SizedBox(height: 16),
                  // อีเมล
                  Visibility(
                    visible: _showEmailField, // ซ่อน TextField สำหรับอีเมล
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: const TextStyle(fontFamily: 'Kanit'),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            'assets/Icon/gmail.svg',
                            width: 24,
                            height: 24,
                          ), // ใช้ SVG แทนไอคอน
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor: _isEmailValid
                            ? Colors.white.withAlpha((0.8 * 255).toInt())
                            : Colors.red.withAlpha((0.3 * 255).toInt()),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // รหัสผ่าน
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: const TextStyle(fontFamily: 'Kanit'),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(
                          'assets/Icon/lock.svg',
                          width: 24,
                          height: 24,
                        ), // ใช้ SVG แทนไอคอน
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      filled: true,
                      fillColor: _isPasswordValid
                          ? Colors.white.withAlpha((0.8 * 255).toInt())
                          : Colors.red.withAlpha((0.3 * 255).toInt()),
                      suffixIcon: IconButton(
                        icon: SvgPicture.asset(
                          _obscurePassword
                              ? 'assets/Icon/eyeoff.svg'
                              : 'assets/Icon/eyeon.svg',
                          color: Colors.black,
                          width: 24,
                          height: 24,
                        ), // ใช้ SVG แทนไอคอน
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // ยืนยันรหัสผ่าน
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      hintStyle: const TextStyle(fontFamily: 'Kanit'),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(
                          'assets/Icon/lock.svg',
                          width: 24,
                          height: 24,
                        ), // ใช้ SVG แทนไอคอน
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      filled: true,
                      fillColor: _isConfirmPasswordValid
                          ? Colors.white.withAlpha((0.8 * 255).toInt())
                          : Colors.red.withAlpha((0.3 * 255).toInt()),
                      suffixIcon: IconButton(
                        icon: SvgPicture.asset(
                          _obscureConfirmPassword
                              ? 'assets/Icon/eyeoff.svg'
                              : 'assets/Icon/eyeon.svg',
                          color: Colors.black,
                          width: 24,
                          height: 24,
                        ), // ใช้ SVG แทนไอคอน
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                  ),
                  // const SizedBox(height: 16),
                  // ที่อยู่
                  Visibility(
                    visible: _showAddressField, // ซ่อน TextField สำหรับที่อยู่
                    child: TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        hintText: 'Address',
                        hintStyle: const TextStyle(fontFamily: 'Kanit'),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            'assets/Icon/location.svg',
                            width: 24,
                            height: 24,
                          ), // ใช้ SVG แทนไอคอน
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor: _isAddressValid
                            ? Colors.white.withAlpha((0.8 * 255).toInt())
                            : Colors.red.withAlpha((0.3 * 255).toInt()),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF063A70),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                    ),
                    onPressed: _registerUser,
                    child: const Text(
                      'สมัครสมาชิก',
                      style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
