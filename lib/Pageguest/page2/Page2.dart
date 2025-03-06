import 'package:flutter/material.dart';
import 'package:superhomemart2/Pageguest/page2/productbrand_guest/jadever_g.dart';
import 'package:superhomemart2/Pageguest/page2/productbrand_guest/total_g.dart';
import 'package:superhomemart2/Pageguest/page2/productbrand_guest/ricota_g.dart';
import 'package:superhomemart2/Pageguest/page2/productbrand_guest/decakila_g.dart';

class Page2 extends StatelessWidget {
  const Page2({super.key});

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
