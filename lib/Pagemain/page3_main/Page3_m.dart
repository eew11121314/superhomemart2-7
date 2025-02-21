import 'package:flutter/material.dart';
import 'package:superhomemart2/Pagemain/page3_main/about_main.dart';
import 'package:superhomemart2/Pagemain/page3_main/helpcenter_main.dart';
import 'package:superhomemart2/Pagemain/widgets_main/page1_bar_main.dart'; // นำเข้า Page1BottomNavigationBar
import 'package:superhomemart2/Pagemain/page1_main/page1_m.dart'; // นำเข้า Page1M
import 'package:superhomemart2/Pagemain/page2_main/page2_m.dart'; // นำเข้า Page2M

class Page3M extends StatefulWidget {
  const Page3M({super.key});

  @override
  _Page3MState createState() => _Page3MState();
}

class _Page3MState extends State<Page3M> {
  int _currentIndex = 2; // ตั้งค่าเริ่มต้นให้เป็นหน้า Settings

  final List<Widget> _pages_m = [
    const Page1M(), // หน้า Home
    const Page2M(), // หน้า Menu
    const Page3M(), // หน้า Settings
  ];

  void _onItemTapped(int index) {
    if (index != 2) {
      // ถ้าไม่ใช่หน้า Settings ให้เปลี่ยนหน้า
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => _pages_m[index]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
              fontFamily: 'Kanit'), // Apply Kanit font to AppBar title
        ),
        centerTitle: true,
        automaticallyImplyLeading: false, // ซ่อนปุ่มย้อนกลับอัตโนมัติ
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: const Text(
              'About',
              style: TextStyle(
                  fontFamily: 'Kanit'), // Apply Kanit font to ListTile text
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPageM()),
              );
            },
          ),
          ListTile(
            title: const Text(
              'Help Center',
              style: TextStyle(
                  fontFamily: 'Kanit'), // Apply Kanit font to ListTile text
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const HelpcenterPageM()),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: Custom_MBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
