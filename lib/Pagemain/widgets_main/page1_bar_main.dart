import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Custom_MBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const Custom_MBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/Icon/home.svg', width: 24, height: 24),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/Icon/menu.svg', width: 24, height: 24),
          label: 'Menu',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/Icon/settings.svg',
              width: 24, height: 24),
          label: 'Settings',
        ),
      ],
      selectedLabelStyle: const TextStyle(fontFamily: 'Kanit'),
      unselectedLabelStyle: const TextStyle(fontFamily: 'Kanit'),
    );
  }
}
