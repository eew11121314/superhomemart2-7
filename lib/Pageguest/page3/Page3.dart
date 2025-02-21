import 'package:flutter/material.dart';
import 'package:superhomemart2/Pageguest/page3/helpcenter.dart';
import 'package:superhomemart2/Pageguest/page3/about.dart';

class Page3 extends StatelessWidget {
  const Page3({super.key});

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
                MaterialPageRoute(builder: (context) => const AboutPage()),
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
                MaterialPageRoute(builder: (context) => const HelpcenterPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
