import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:superhomemart2/Pagemain/page1_main/profile_m.dart';

class ProfileIconButton extends StatelessWidget {
  const ProfileIconButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(
        'assets/Icon/person.svg', // ใช้ SVG แทนไอคอนรูปคน
        width: 50,
        height: 50,
        color: const Color.fromARGB(255, 57, 55, 55),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      },
    );
  }
}
