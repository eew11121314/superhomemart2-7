import 'package:flutter/material.dart';
import 'package:superhomemart2/Pagemain/order_main/cart_provider_m.dart';
import 'package:provider/provider.dart';

class CartItemsWidget extends StatelessWidget {
  const CartItemsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'รายการสินค้า',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Kanit',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ...cartProvider.cartItems.map((item) {
          return ListTile(
            title: Text(
                item.productName), // แก้ไขจาก item.name เป็น item.productName
            subtitle: Text('จำนวน: ${item.quantity}'),
            trailing: Text('฿${item.price * item.quantity}'),
          );
        }).toList(),
      ],
    );
  }
}
