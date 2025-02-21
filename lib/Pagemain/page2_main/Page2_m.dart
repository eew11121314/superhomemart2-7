import 'package:flutter/material.dart';
import 'package:superhomemart2/Pageguest/page2/productbrand_Pageguest/jadever.dart';
import 'package:superhomemart2/Pageguest/page2/productbrand_Pageguest/total.dart';
import 'package:superhomemart2/Pageguest/page2/productbrand_Pageguest/ricota.dart';
import 'package:superhomemart2/Pageguest/page2/productbrand_Pageguest/decakila.dart';
import 'package:superhomemart2/Pagemain/widgets_main/page1_bar_main.dart'; // นำเข้า Page1BottomNavigationBar
import 'package:superhomemart2/Pagemain/page1_main/page1_m.dart'; // นำเข้า Page1M
import 'package:superhomemart2/Pagemain/page3_main/page3_m.dart'; // นำเข้า Page3M

class Page2M extends StatefulWidget {
  const Page2M({super.key});

  @override
  _Page2MState createState() => _Page2MState();
}

class _Page2MState extends State<Page2M> {
  int _currentIndex = 1; // ตั้งค่าเริ่มต้นให้เป็นหน้า Menu

  final List<Widget> _pages_m = [
    const Page1M(), // หน้า Home
    const Page2M(), // หน้า Menu
    const Page3M(), // หน้า Settings
  ];

  void _onItemTapped(int index) {
    if (index != 1) {
      // ถ้าไม่ใช่หน้า Menu ให้เปลี่ยนหน้า
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
          'Menu',
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
              'Jadever',
              style: TextStyle(
                  fontFamily: 'Kanit'), // Apply Kanit font to ListTile text
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const JadeverCategoryPage()),
              );
            },
          ),
          ListTile(
            title: const Text(
              'Total',
              style: TextStyle(
                  fontFamily: 'Kanit'), // Apply Kanit font to ListTile text
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TotalCategoryPage()),
              );
            },
          ),
          ListTile(
            title: const Text(
              'Ricota',
              style: TextStyle(
                  fontFamily: 'Kanit'), // Apply Kanit font to ListTile text
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RicotaCategoryPage()),
              );
            },
          ),
          ListTile(
            title: const Text(
              'Decakila',
              style: TextStyle(
                  fontFamily: 'Kanit'), // Apply Kanit font to ListTile text
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DecakilaCategoryPage()),
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
