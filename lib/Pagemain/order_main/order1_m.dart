import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:superhomemart2/Pagemain/widgets_order1_m/address_form.dart';
import 'package:superhomemart2/Pagemain/widgets_order1_m/payment_options.dart';
import 'package:superhomemart2/Pagemain/widgets_order1_m/discount_form.dart';
import 'package:superhomemart2/Pagemain/widgets_order1_m/product_preview.dart';
import 'package:superhomemart2/Pagemain/order_main/cart_provider_m.dart';
import 'package:provider/provider.dart';

class OrderPageM extends StatefulWidget {
  const OrderPageM({super.key});

  @override
  OrderPageMState createState() => OrderPageMState();
}

class OrderPageMState extends State<OrderPageM> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _houseNumberController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _subDistrictController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  bool _isAddressFormVisible = true;

  Future<void> _placeOrder() async {
    const String url = "http://superhomemart.duckdns.org/product";
    const String apiKey = "WHt)m6gpqxkF1r(oDczv8mq%";

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'address': _addressController.text,
        'name': _nameController.text,
        'houseNumber': _houseNumberController.text,
        'province': _provinceController.text,
        'district': _districtController.text,
        'subDistrict': _subDistrictController.text,
        'postalCode': _postalCodeController.text,
        'phone': _phoneController.text,
        'email': _emailController.text,
        'items': [1, 1, 1], // แก้ไขให้เป็นรายการสินค้าที่เลือกจาก cart_m.dart
      }),
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      // การสั่งซื้อสำเร็จ
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('สั่งซื้อสำเร็จ')),
      );
    } else {
      // การสั่งซื้อล้มเหลว
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('สั่งซื้อล้มเหลว')),
      );
    }
  }

  void _changeAddress() {
    setState(() {
      _isAddressFormVisible = !_isAddressFormVisible;
    });
  }

  void _handleOnlinePayment() {
    // Handle online payment logic here
  }

  void _handleQRCodePayment() {
    // Handle QR code payment logic here
  }

  void _handleCashOnDelivery() {
    // Handle cash on delivery logic here
  }

  void _applyDiscount() {
    // Handle discount application logic here
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'การสั่งซื้อ',
          style: TextStyle(fontFamily: 'Kanit', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 253, 254, 255),
        leading: IconButton(
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              if (_isAddressFormVisible)
                AddressForm(
                  nameController: _nameController,
                  houseNumberController: _houseNumberController,
                  provinceController: _provinceController,
                  districtController: _districtController,
                  subDistrictController: _subDistrictController,
                  postalCodeController: _postalCodeController,
                  phoneController: _phoneController,
                  emailController: _emailController,
                  addressController: _addressController,
                  onChangeAddress: _changeAddress,
                ),
              const SizedBox(height: 20),
              DiscountForm(
                discountController: _discountController,
                onApplyDiscount: _applyDiscount,
              ),
              const SizedBox(height: 20),
              PaymentOptions(
                onOnlinePayment: _handleOnlinePayment,
                onQRCodePayment: _handleQRCodePayment,
                onCashOnDelivery: _handleCashOnDelivery,
              ),
              const SizedBox(height: 20),
              ProductPreview(cartItems: cartProvider.cartItems),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _placeOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'ดำเนินการสั่งซื้อ',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
