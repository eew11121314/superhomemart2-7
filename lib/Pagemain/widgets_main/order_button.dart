//รูปรถเข็นหน้า productdetails1_m.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:superhomemart2/Pagemain/order_main/cart_provider_m.dart';

class OrderButton extends StatelessWidget {
  final String productId; // เพิ่มฟิลด์ productId
  // final String productToid; // เพิ่มฟิลด์ productToid
  final String productName;
  final String imageUrl;
  final double price;

  const OrderButton({
    Key? key,
    required this.productId, // เพิ่มฟิลด์ productId
    // required this.productToid, // เพิ่มฟิลด์ productToid
    required this.productName,
    required this.imageUrl,
    required this.price,
  }) : super(key: key);

  void _handleOrder(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.addItem(CartItem(
      productId: productId, // เพิ่มการส่งค่า productId
      // productToid: productToid, // เพิ่มการส่งค่า productToid
      productName: productName,
      imageUrl: imageUrl,
      quantity: 1,
      price: price,
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SvgPicture.asset(
              'assets/Icon/check.svg',
              width: 25,
              height: 25,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            const Text('เพิ่มสินค้าในตะกร้าเรียบร้อยแล้ว'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 1), // ตั้งค่า duration เป็น 2 วินาที
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 37, 60, 99),
        borderRadius: BorderRadius.circular(0),
      ),
      child: TextButton(
        onPressed: () => _handleOrder(context),
        child: const Text(
          'สั่งซื้อสินค้า',
          style: TextStyle(fontFamily: 'Kanit', color: Colors.white),
        ),
      ),
    );
  }
}
