import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:superhomemart2/Pagemain/order_main/cart/cart_provider_m.dart';
import 'package:superhomemart2/Pagemain/order_main/order1_m.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatelessWidget {
  final List<CartItem> cartItems;

  const CartScreen({Key? key, required this.cartItems}) : super(key: key);

  bool isValidUrl(String url) {
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final formatter = NumberFormat('#,##0.00');

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: SvgPicture.asset(
                'assets/Icon/left.svg',
                width: 30,
                height: 30,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const Text('ตะกร้าสินค้า'),
          ],
        ),
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Text(
                'ไม่มีสินค้าในตะกร้า',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Kanit', // เปลี่ยนฟอนต์ที่นี่
                ),
              ),
            )
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                final imageUrl = isValidUrl(item.imageUrl)
                    ? item.imageUrl
                    : 'http://superhomemart.duckdns.org:80/upload/${item.imageUrl}.jpg';
                return Card(
                  margin: const EdgeInsets.all(8.0),
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
                              Text('Price: ฿${item.price.toStringAsFixed(2)}'),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  IconButton(
                                    icon: SvgPicture.asset(
                                      'assets/Icon/minus.svg',
                                      width: 24,
                                      height: 24,
                                    ),
                                    onPressed: () =>
                                        cartProvider.decreaseQuantity(index),
                                  ),
                                  Text('${item.quantity}',
                                      style: const TextStyle(fontSize: 16)),
                                  IconButton(
                                    icon: SvgPicture.asset(
                                      'assets/Icon/plus.svg',
                                      width: 24,
                                      height: 24,
                                    ),
                                    onPressed: () =>
                                        cartProvider.increaseQuantity(index),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: SvgPicture.asset(
                                      'assets/Icon/bin.svg',
                                      width: 24,
                                      height: 24,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      cartProvider.removeItem(index);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/Icon/bin.svg',
                                                width: 24,
                                                height: 24,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(width: 10),
                                              const Text(
                                                  'ลบสินค้าออกจากตะกร้าเรียบร้อยแล้ว'),
                                            ],
                                          ),
                                          backgroundColor: Colors.red,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          margin: const EdgeInsets.all(10),
                                          duration: const Duration(
                                              seconds:
                                                  2), // ตั้งค่า duration เป็น 2 วินาที
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ทั้งหมด: ${formatter.format(cartProvider.totalPrice)} ฿',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: cartItems.isEmpty
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrderPageM(),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // กำหนดสีพื้นหลังเป็นสีเขียว
                ),
                child: const Text(
                  'Checkout',
                  style:
                      TextStyle(color: Colors.white), // กำหนดสีฟอนต์เป็นสีขาว
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
