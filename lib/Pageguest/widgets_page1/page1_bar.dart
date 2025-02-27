import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/Icon/home.svg',
            width: 24,
            height: 24,
            color: currentIndex == 0 ? Colors.black : Colors.grey,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/Icon/menu.svg',
            width: 24,
            height: 24,
            color: currentIndex == 1 ? Colors.black : Colors.grey,
          ),
          label: 'Menu',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/Icon/settings.svg',
            width: 24,
            height: 24,
            color: currentIndex == 2 ? Colors.black : Colors.grey,
          ),
          label: 'Settings',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/Icon/user.svg',
            width: 24,
            height: 24,
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
