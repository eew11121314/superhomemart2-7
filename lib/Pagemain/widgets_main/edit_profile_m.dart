import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart'; // นำเข้า flutter_svg
import 'package:flutter/services.dart'; // นำเข้า input formatter

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

  // ตัวแปรสำหรับควบคุมการแสดงผลของฟิลด์
  bool _showPhoneField = false;
  bool _showEmailField = false;
  bool _showAddressField = false;

  // ตัวแปรสำหรับตรวจสอบกรอบที่ผิด
  bool _isFieldValid = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);

    // กำหนดการแสดงผลของฟิลด์ตามค่า field
    if (widget.field == 'number') {
      _showPhoneField = true;
    } else if (widget.field == 'email') {
      _showEmailField = true;
    } else if (widget.field == 'address') {
      _showAddressField = true;
    }
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

  Future<void> _updateDatabase(String field, String value) async {
    final prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');

    if (username == null) {
      debugPrint('No username found');
      return;
    }

    final String url =
        "https://superhomemart.duckdns.org/api/upload/user/member/app";
    const String apiKey = "WHt)m6gpqxkF1r(oDczv8mq%";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': apiKey,
        },
        body: jsonEncode({
          'username': username,
          field: value,
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          debugPrint('Database updated successfully');
        } else {
          debugPrint('Failed to update database: ${jsonData['message']}');
        }
      } else {
        debugPrint('Failed to update database: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error updating database: $e');
    }
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isLoading = true;
    });

    // ตรวจสอบข้อมูลที่กรอกในแต่ละช่อง
    setState(() {
      _isFieldValid = _controller.text.isNotEmpty;
    });

    if (!_isFieldValid) {
      _showAlert(context, 'กรุณาเติมให้ครบทุกช่อง');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    await _updateDatabase(widget.field, _controller.text);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.field}'),
        automaticallyImplyLeading: false, // ซ่อนปุ่มย้อนกลับ
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/Icon/left.svg', // ไฟล์ SVG สำหรับลูกศร
            width: 24,
            height: 24,
          ),
          onPressed: () {
            Navigator.pop(context); // การทำงานของปุ่มย้อนกลับ
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Visibility(
              visible: _showPhoneField,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: _isFieldValid
                      ? Colors.white.withAlpha((0.8 * 255).toInt())
                      : Colors.red.withAlpha((0.3 * 255).toInt()),
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // แค่ตัวเลข
                  LengthLimitingTextInputFormatter(10), // จำกัด 10 ตัว
                ],
              ),
            ),
            Visibility(
              visible: _showEmailField,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: _isFieldValid
                      ? Colors.white.withAlpha((0.8 * 255).toInt())
                      : Colors.red.withAlpha((0.3 * 255).toInt()),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Visibility(
              visible: _showAddressField,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: _isFieldValid
                      ? Colors.white.withAlpha((0.8 * 255).toInt())
                      : Colors.red.withAlpha((0.3 * 255).toInt()),
                ),
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
