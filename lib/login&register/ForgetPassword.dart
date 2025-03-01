import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // เพิ่มการนำเข้า

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _otpSent = false;

  void _sendOTP() {
    String email = _emailController.text;

    if (email.isEmpty ||
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      // แสดง Alert หาก email ไม่ถูกต้อง
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
                const Text(
                  'Please enter a valid email address.',
                  style: TextStyle(fontFamily: 'Kanit'),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK', style: TextStyle(fontFamily: 'Kanit')),
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        _otpSent = true; // แสดงช่องกรอก OTP
      });

      // คุณสามารถเพิ่มการส่ง OTP ผ่าน Backend ได้ที่นี่
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'OTP has been sent to your email.',
            style: TextStyle(fontFamily: 'Kanit'),
          ),
        ),
      );
    }
  }

  void _verifyOTP() {
    String otp = _otpController.text;

    if (otp.isEmpty || otp.length != 6) {
      // แสดง Alert หาก OTP ไม่ถูกต้อง
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
                const Text(
                  'Please enter a valid 6-digit OTP.',
                  style: TextStyle(fontFamily: 'Kanit'),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK', style: TextStyle(fontFamily: 'Kanit')),
              ),
            ],
          );
        },
      );
    } else {
      // ตรวจสอบ OTP ผ่าน Backend และเปลี่ยนรหัสผ่าน
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ResetPasswordPage()),
      );
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
        title: const Text(
          'Forget Password',
          style: TextStyle(fontFamily: 'Kanit'),
        ),
        backgroundColor: const Color(0xFF073074),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your email to reset your password',
              style: TextStyle(fontSize: 18, fontFamily: 'Kanit'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Your email',
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
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 20),
            if (!_otpSent) // แสดงปุ่มส่ง OTP เมื่อยังไม่ได้ส่ง
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _sendOTP,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: const Color(0xFF4059F1),
                  ),
                  child: const Text(
                    'Send OTP',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'Kanit',
                    ),
                  ),
                ),
              )
            else // แสดงช่องกรอก OTP และปุ่มยืนยันเมื่อส่ง OTP แล้ว
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter the OTP sent to your email',
                    style: TextStyle(fontSize: 18, fontFamily: 'Kanit'),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      hintText: '6-digit OTP',
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
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _verifyOTP,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: const Color(0xFF4059F1),
                      ),
                      child: const Text(
                        'Verify OTP',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: 'Kanit',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reset Password',
          style: TextStyle(fontFamily: 'Kanit'),
        ),
      ),
      body: const Center(
        child: Text(
          'Reset Password Page',
          style: TextStyle(fontFamily: 'Kanit', fontSize: 18),
        ),
      ),
    );
  }
}
