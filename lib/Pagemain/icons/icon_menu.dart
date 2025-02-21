import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:superhomemart2/Pageguest/page2/Page2.dart'; // นำเข้า Page2 ที่คุณต้องการนำทางไป

class MenuIcon extends StatelessWidget {
  final double bottomOffset; // Allow bottom offset customization
  final double rightOffset; // Allow right offset customization

  const MenuIcon({
    super.key,
    this.bottomOffset = 20, // Default position
    this.rightOffset = 10, // Default position
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottomOffset, // Adjustable bottom position
      right: rightOffset, // Adjustable right position
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Page2(), // ไปหน้า Page2
            ),
          );
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            // พื้นหลังที่สามารถปรับขนาดได้
            Container(
              width: 60, // ขนาดของพื้นที่พื้นหลัง
              height: 60,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 47, 69, 92)
                    .withValues(alpha: 0.9), // ใช้ withValues() แทน withOpacity
                borderRadius: BorderRadius.circular(10), // ขอบมน
              ),
            ),
            // ไอคอนกับพื้นหลัง
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(),
              child: Center(
                child: SvgPicture.asset(
                  'assets/Icon/menu2.svg', // ไฟล์ SVG ของไอคอนเมนู
                  width: 40,
                  height: 40,
                  color: const Color.fromARGB(255, 255, 255, 255), // สีของไอคอน
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
