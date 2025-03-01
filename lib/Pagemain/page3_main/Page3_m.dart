import 'package:flutter/material.dart';
import 'package:superhomemart2/Pagemain/page3_main/about_main.dart';
import 'package:superhomemart2/Pagemain/page3_main/helpcenter_main.dart';
import 'package:superhomemart2/main.dart'; // นำเข้า HomeScreenGuest
import 'package:shared_preferences/shared_preferences.dart'; // นำเข้า SharedPreferences

class Page3M extends StatefulWidget {
  const Page3M({super.key});

  @override
  _Page3MState createState() => _Page3MState();
}

class _Page3MState extends State<Page3M> {
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
          ListTile(
            title: const Text(
              'Log Out',
              style: TextStyle(fontFamily: 'Kanit'),
            ),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomeScreenGuest()),
              );
            },
          ),
        ],
      ),
    );
  }
}
