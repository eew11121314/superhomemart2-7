import 'dart:io'; // นำเข้า File
import 'package:path_provider/path_provider.dart'; // ใช้สำหรับจัดการ path ในเครื่อง
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart'; // นำเข้า package สำหรับเลือกภาพ
import 'package:superhomemart2/main.dart'; // นำเข้า main.dart เพื่อใช้ HomeScreen
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart'; // เพิ่มการนำเข้า MediaType
import 'package:superhomemart2/Pagemain/widgets_main/edit_profile_m.dart'; // นำเข้า edit_profile_m.dart

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? username;
  XFile? _image; // ตัวแปรเก็บภาพที่เลือก
  double imageSize = 50.0; // ตัวแปรสำหรับควบคุมขนาดของรูปภาพ

  final ImagePicker _picker = ImagePicker(); // สร้าง ImagePicker

  @override
  void initState() {
    super.initState();
    loadUserProfile();
    _loadImageFromPreferences(); // โหลดภาพจาก SharedPreferences เมื่อเริ่มต้น
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

  // ฟังก์ชันสำหรับเลือกภาพจากแกลเลอรี่หรือกล้อง
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
        source: ImageSource
            .gallery); // สามารถเปลี่ยนเป็น ImageSource.camera หากต้องการถ่ายจากกล้อง
    if (pickedFile != null) {
      // จัดเก็บภาพใน local storage
      final directory =
          await getApplicationDocumentsDirectory(); // ใช้ path_provider เพื่อหา directory ที่เหมาะสม
      final fileName = pickedFile.name;
      final savedImage =
          await File(pickedFile.path).copy('${directory.path}/$fileName');

      // บันทึก path ของภาพลงใน SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_image_path_$username', savedImage.path);

      setState(() {
        _image = XFile(savedImage.path); // ใช้ path ที่บันทึกไว้
      });

      // อัปโหลดภาพไปยังเซิร์ฟเวอร์
      await _uploadImage(File(savedImage.path));
    }
  }

  // ฟังก์ชันสำหรับอัปโหลดไฟล์ไปยังเซิร์ฟเวอร์
  Future<void> _uploadImage(File imageFile) async {
    final uri = Uri.parse(
        'http://192.168.1.15:7007/upload'); // เปลี่ยน URL เป็นที่อยู่ IP ของเซิร์ฟเวอร์และพอร์ตใหม่
    final mimeType = lookupMimeType(imageFile.path);

    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        contentType: MediaType.parse(mimeType!),
      ));

    final response = await request.send();

    if (response.statusCode == 200) {
      debugPrint('File uploaded successfully');
    } else {
      debugPrint('File upload failed with status: ${response.statusCode}');
    }
  }

  // ฟังก์ชันสำหรับแสดงรูปภาพขยาย
  void _viewImage(BuildContext context) {
    if (_image != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Image.file(File(_image!.path)),
          );
        },
      );
    }
  }

  // ฟังก์ชันโหลดภาพจาก SharedPreferences
  Future<void> _loadImageFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs
        .getString('user_image_path_$username'); // ดึง path ของภาพตาม username
    if (imagePath != null) {
      setState(() {
        _image = XFile(imagePath); // แสดงภาพที่เก็บไว้
      });
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // ลบข้อมูลทั้งหมดใน SharedPreferences

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreenGuest()),
      (Route<dynamic> route) => false,
    ); // นำทางไปยังหน้า HomeScreen และลบ stack ของหน้าทั้งหมด
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData == null
              ? const Center(child: Text("Unable to connect to user profile."))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // ใช้ Stack เพื่อจัดตำแหน่ง
                      Stack(
                        clipBehavior:
                            Clip.none, // ไม่ให้ Stack ครอบคลุม widget อื่น
                        children: [
                          GestureDetector(
                            onTap: () => _viewImage(
                                context), // เมื่อกดที่รูปภาพจะแสดงรูปขนาดใหญ่
                            child: CircleAvatar(
                              radius: imageSize, // ใช้ตัวแปรที่ควบคุมขนาดรูปภาพ
                              backgroundImage: _image != null
                                  ? FileImage(File(
                                      _image!.path)) // แสดงภาพจาก local storage
                                  : userData!['image'] != null
                                      ? NetworkImage(userData!['image'])
                                      : const AssetImage(
                                              'assets/default_user.png')
                                          as ImageProvider,
                            ),
                          ),
                          Positioned(
                            bottom: -0, // ขยับไอคอนลงมาจากวงกลม
                            right: -5, // ขยับไอคอนไปทางขวา
                            child: GestureDetector(
                              onTap:
                                  _pickImage, // เมื่อกดที่ไอคอนจะเปิดให้เลือกภาพใหม่
                              child: SvgPicture.asset(
                                'assets/Icon/add-camera.svg', // ไฟล์ SVG ที่จะใช้เป็นไอคอน
                                width: 30,
                                height: 30,
                                color: const Color.fromARGB(
                                    150, 190, 184, 184), // กำหนดสีไอคอนให้จางลง
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${userData!['fname']} ${userData!['lname']}",
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text("@${userData!['username']}",
                          style: const TextStyle(
                              fontSize: 18, color: Colors.grey)),
                      const Divider(),
                      ListTile(
                        leading: SvgPicture.asset(
                          'assets/Icon/phone.svg', // ใช้ไฟล์ SVG แทนไอคอน
                          width: 24,
                          height: 24,
                        ),
                        title: Text(userData!['number'] ?? 'N/A'),
                        trailing: IconButton(
                          icon: SvgPicture.asset(
                            'assets/Icon/edit.svg', // ใช้ไฟล์ SVG แทนไอคอน
                            width: 24,
                            height: 24,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileScreen(
                                  field: 'number',
                                  value: userData!['number'] ?? '',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      ListTile(
                        leading: SvgPicture.asset(
                          'assets/Icon/email.svg', // ใช้ไฟล์ SVG แทนไอคอน
                          width: 24,
                          height: 24,
                        ),
                        title: Text(userData!['email'] ?? 'N/A'),
                        trailing: IconButton(
                          icon: SvgPicture.asset(
                            'assets/Icon/edit.svg', // ใช้ไฟล์ SVG แทนไอคอน
                            width: 24,
                            height: 24,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileScreen(
                                  field: 'email',
                                  value: userData!['email'] ?? '',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      ListTile(
                        leading: SvgPicture.asset(
                          'assets/Icon/home2.svg', // ใช้ไฟล์ SVG แทนไอคอน
                          width: 24,
                          height: 24,
                        ),
                        title: Text(userData!['address'] ?? 'N/A'),
                        trailing: IconButton(
                          icon: SvgPicture.asset(
                            'assets/Icon/edit.svg', // ใช้ไฟล์ SVG แทนไอคอน
                            width: 24,
                            height: 24,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileScreen(
                                  field: 'address',
                                  value: userData!['address'] ?? '',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          // แสดงการแจ้งเตือนก่อนออกจากระบบ
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("ออกจากระบบ"),
                                content: const Text("คุณออกจากระบบแล้ว"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      _logout(); // เรียกฟังก์ชัน logout
                                    },
                                    child: const Text("ตกลง"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(
                              double.infinity, 50), // ปรับขนาดปุ่มให้เต็มหน้าจอ
                        ),
                        child: const Text("ออกจากระบบ"),
                      ),
                    ],
                  ),
                ),
    );
  }
}
