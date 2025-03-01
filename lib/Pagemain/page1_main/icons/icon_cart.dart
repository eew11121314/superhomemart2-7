import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:superhomemart2/Pagemain/order_main/cart_m.dart';
import 'package:superhomemart2/Pagemain/order_main/cart_provider_m.dart';

class DraggableCartIcon extends StatelessWidget {
  const DraggableCartIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100, // ระยะจากขอบล่าง
      right: 10, // ระยะจากขอบขวา
      child: GestureDetector(
        onTap: () {
          final cartProvider =
              Provider.of<CartProvider>(context, listen: false);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CartScreen(cartItems: cartProvider.cartItems),
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
                    .withOpacity(0.9), // ใช้ withOpacity แทน withValues
                borderRadius: BorderRadius.circular(10), // ขอบมน
              ),
            ),
            // ไอคอนกับพื้นหลัง
            Container(
              width: 40, // ขนาดไอคอน
              height: 40,
              decoration: const BoxDecoration(),
              child: Center(
                child: SvgPicture.asset(
                  'assets/Icon/cart.svg', // ไฟล์ SVG ของไอคอนรถเข็น
                  width: 40,
                  height: 40,
                  color: const Color.fromARGB(
                      255, 255, 255, 255), // เปลี่ยนสีของไอคอนที่นี่
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
