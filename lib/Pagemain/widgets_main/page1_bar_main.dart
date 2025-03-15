import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:superhomemart2/Pagemain/_page1_main/page1_m.dart';
import 'package:superhomemart2/Pagemain/_page2_main/page2_m.dart';
import 'package:superhomemart2/Pagemain/_page3_main/page3_m.dart';

class Custom_MBottomNavigationBar extends StatefulWidget {
  const Custom_MBottomNavigationBar({Key? key}) : super(key: key);

  @override
  _Custom_MBottomNavigationBarState createState() =>
      _Custom_MBottomNavigationBarState();
}

class _Custom_MBottomNavigationBarState
    extends State<Custom_MBottomNavigationBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Page1M(),
    const Page2M(),
    const Page3M(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 14, // ขนาดฟอนต์เมื่อเลือก
        unselectedFontSize: 0, // ขนาดฟอนต์เมื่อไม่ได้เลือก
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/Icon/home.svg',
              width: 24,
              height: 24,
              color: _currentIndex == 0 ? Colors.black : Colors.grey,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/Icon/menu.svg',
              width: 24,
              height: 24,
              color: _currentIndex == 1 ? Colors.black : Colors.grey,
            ),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/Icon/settings.svg',
              width: 24,
              height: 24,
              color: _currentIndex == 2 ? Colors.black : Colors.grey,
            ),
            label: 'Settings',
          ),
        ],
        selectedLabelStyle: const TextStyle(fontFamily: 'Kanit'),
        unselectedLabelStyle: const TextStyle(fontFamily: 'Kanit'),
      ),
    );
  }
}
