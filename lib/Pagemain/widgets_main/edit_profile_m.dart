import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart'; // นำเข้า flutter_svg

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

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
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

    final prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');

    if (username == null) {
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
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: widget.field,
                border: OutlineInputBorder(),
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
