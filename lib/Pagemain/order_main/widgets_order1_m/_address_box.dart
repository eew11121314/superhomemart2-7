//โชว์ข้อมูลที่อยู่ของผู้ใช้งาน
/*
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart'; // เพิ่มการนำเข้า flutter_svg

class AddressBox extends StatefulWidget {
  const AddressBox({Key? key}) : super(key: key);

  @override
  _AddressBoxState createState() => _AddressBoxState();
}

class _AddressBoxState extends State<AddressBox> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? username;

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username'); // ดึง username
    debugPrint("Username: $username");
    if (username == null) {
      debugPrint("No user logged in");
      setState(() => isLoading = false);
      return;
    }

    final String url =
        "http://superhomemart.duckdns.org/api/user/member/app/user?username=$username";
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
          isLoading = false;
          userData = jsonData[0]; // เข้าถึง object แรกใน array
        });
        debugPrint("Success: $jsonData");
      } else {
        debugPrint("Failed to load profile: ${response.statusCode}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint("Error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : userData == null
            ? const Center(child: Text("Unable to connect to user profile."))
            : Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${userData!['fname']} ${userData!['lname']}",
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/Icon/home2.svg', // แทนที่ด้วยไฟล์ SVG ของคุณ
                          color: const Color.fromARGB(220, 190, 184, 184),
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            userData!['address'] ?? 'N/A',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/Icon/phone.svg', // แทนที่ด้วยไฟล์ SVG ของคุณ
                          color: const Color.fromARGB(220, 190, 184, 184),
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          userData!['number'] ?? 'N/A',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/Icon/email.svg', // แทนที่ด้วยไฟล์ SVG ของคุณ
                          color: const Color.fromARGB(220, 190, 184, 184),
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          userData!['email'] ?? 'N/A',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              );
  }
}
*/
