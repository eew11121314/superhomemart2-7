import 'package:flutter/material.dart';
import 'package:superhomemart2/Pagemain/_page2_main/productbrand_main/jadever_m.dart';
import 'package:superhomemart2/Pagemain/_page2_main/productbrand_main/total_m.dart';
import 'package:superhomemart2/Pagemain/_page2_main/productbrand_main/ricota_m.dart';
import 'package:superhomemart2/Pagemain/_page2_main/productbrand_main/decakila_m.dart';

class Page2M extends StatefulWidget {
  const Page2M({super.key});

  @override
  _Page2MState createState() => _Page2MState();
}

class _Page2MState extends State<Page2M> {
  bool _showBackButton = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ตรวจสอบเส้นทางการนำทางที่มาก่อนหน้า
    ModalRoute? previousRoute = ModalRoute.of(context);
    if (previousRoute != null && previousRoute.settings.name == '/') {
      setState(() {
        _showBackButton = false;
      });
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
        automaticallyImplyLeading:
            _showBackButton, // ซ่อนปุ่มย้อนกลับอัตโนมัติถ้าไม่ต้องการ
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
    );
  }
}
