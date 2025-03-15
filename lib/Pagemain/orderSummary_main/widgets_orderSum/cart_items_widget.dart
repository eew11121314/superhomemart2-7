import 'package:flutter/material.dart';
import 'package:superhomemart2/Pagemain/order_main/cart/cart_provider_m.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // เพิ่มการนำเข้า

class CartItemsWidget extends StatelessWidget {
  const CartItemsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final totalPrice = cartProvider.totalPrice; // รับราคารวมจาก Provider
    final formatter = NumberFormat('#,##0'); // สร้างตัวจัดรูปแบบตัวเลข

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'รายการสินค้า',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Kanit',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ...cartProvider.cartItems.map((item) {
          return Column(
            children: [
              ListTile(
                title: Text(
                  item.productName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Kanit',
                  ),
                ),
                subtitle: Text(
                  'จำนวน: ${item.quantity}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Kanit',
                  ),
                ),
                trailing: Text(
                  '฿${formatter.format(item.price * item.quantity)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1,
                indent: 16,
                endIndent: 16,
              ),
            ],
          );
        }).toList(),
        const SizedBox(height: 20),
        Center(
          child: Text(
            'รวมทั้งหมด ฿${formatter.format(totalPrice)} บาท',
            style: const TextStyle(
              fontSize: 24,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
