import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final double iconSize; // เพิ่มพารามิเตอร์ iconSize

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    this.iconSize = 24.0, // กำหนดค่าเริ่มต้นให้กับ iconSize
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      selectedFontSize: 14, // ขนาดฟอนต์เมื่อเลือก
      unselectedFontSize: 0, // ขนาดฟอนต์เมื่อไม่ได้เลือก
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/Icon/home.svg',
            width: iconSize,
            height: iconSize,
            color: currentIndex == 0 ? Colors.black : Colors.grey,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/Icon/menu.svg',
            width: iconSize,
            height: iconSize,
            color: currentIndex == 1 ? Colors.black : Colors.grey,
          ),
          label: 'Menu',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/Icon/settings.svg',
            width: iconSize,
            height: iconSize,
            color: currentIndex == 2 ? Colors.black : Colors.grey,
          ),
          label: 'Settings',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/Icon/user.svg',
            width: iconSize,
            height: iconSize,
            color: currentIndex == 3 ? Colors.black : Colors.grey,
          ),
          label: 'Profile',
        ),
      ],
      selectedLabelStyle: const TextStyle(fontFamily: 'Kanit'),
      unselectedLabelStyle: const TextStyle(fontFamily: 'Kanit'),
    );
  }
}
