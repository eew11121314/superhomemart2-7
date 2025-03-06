import 'package:flutter/material.dart';
import 'package:superhomemart2/Pagemain/order_main/cart/cart_provider_m.dart';
import 'package:intl/intl.dart';

class ProductPreview extends StatelessWidget {
  final List<CartItem> cartItems;

  const ProductPreview({Key? key, required this.cartItems}) : super(key: key);

  bool isValidUrl(String url) {
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0.00');
    double totalPrice =
        cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'สินค้าที่เลือก',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Kanit',
          ),
        ),
        const SizedBox(height: 10),
        ...cartItems.map((item) {
          final imageUrl = isValidUrl(item.imageUrl)
              ? item.imageUrl
              : 'http://superhomemart.duckdns.org:80/upload/${item.imageUrl}.jpg';
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(25),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          'http://superhomemart.duckdns.org/upload/PreloaderProduct.jpg',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.productName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text('ราคา: ฿${item.price.toStringAsFixed(2)}'),
                        const SizedBox(height: 5),
                        Text('จำนวน: ${item.quantity}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
        const SizedBox(height: 10),
        Text(
          'รวมทั้งหมด: ฿${formatter.format(totalPrice)}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Kanit',
          ),
        ),
      ],
    );
  }
}
