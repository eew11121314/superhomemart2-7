import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditProfileScreen extends StatefulWidget {
  final String field;
  final String value;

  const EditProfileScreen({
    Key? key,
    required this.field,
    required this.value,
  }) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _controller;
  bool _isLoading = false;
  bool _isFieldValid = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  // ฟังก์ชันแสดง Alert
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

  // ฟังก์ชันอัปเดตข้อมูลไปยัง API
  Future<void> _updateDatabase(Map<String, String> fields) async {
    final String url =
        "https://superhomemart.duckdns.org/api/upload/user/member/app";
    const String apiKey = "WHt)m6gpqxkF1r(oDczv8mq%";

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': apiKey,
        },
        body: jsonEncode(fields), // ส่งข้อมูลในรูปแบบ JSON
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          _showAlert(context, 'อัปเดตข้อมูลสำเร็จ');
        } else if (jsonData['status'] == 'not_found') {
          _showAlert(context, 'ไม่พบข้อมูลที่ต้องการแก้ไข');
        } else {
          _showAlert(context, 'อัปเดตข้อมูลล้มเหลว: ${jsonData['message']}');
        }
      } else {
        _showAlert(context, 'เกิดข้อผิดพลาด: ${response.statusCode}');
      }
    } catch (e) {
      _showAlert(context, 'เกิดข้อผิดพลาด: $e');
    }
  }

  // ฟังก์ชันบันทึกข้อมูล
  Future<void> _saveChanges() async {
    setState(() {
      _isLoading = true;
    });

    // ตรวจสอบว่าฟิลด์ไม่ว่างเปล่า
    _isFieldValid = _controller.text.isNotEmpty;

    if (!_isFieldValid) {
      _showAlert(context, 'กรุณากรอกข้อมูลให้ครบถ้วน');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // ดึงข้อมูลจาก SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id'); // ใช้ id เป็นตัวระบุหลัก
    String? number = prefs.getString('number');
    String? email = prefs.getString('email');
    String? address = prefs.getString('address');

    if (id == null) {
      _showAlert(context, 'ไม่พบข้อมูลผู้ใช้');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // สร้าง Map สำหรับส่งข้อมูลไปยัง API
    Map<String, String> fields = {
      'id': id, // ใช้ id เป็นตัวระบุหลัก
      'fname': 'ชื่อใหม่', // ตัวอย่างข้อมูล
      'lname': 'นามสกุลใหม่', // ตัวอย่างข้อมูล
      'number': number ?? '',
      'email': email ?? '',
      'address': address ?? '',
      widget.field: _controller.text, // ฟิลด์ที่แก้ไข
    };

    await _updateDatabase(fields);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.field}'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/Icon/left.svg',
            width: 24,
            height: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: widget.field,
                border: const OutlineInputBorder(),
                filled: true,
                fillColor:
                    _isFieldValid ? Colors.white : Colors.red.withOpacity(0.3),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _saveChanges,
                    child: const Text('บันทึกข้อมูล'),
                  ),
          ],
        ),
      ),
    );
  }
}
