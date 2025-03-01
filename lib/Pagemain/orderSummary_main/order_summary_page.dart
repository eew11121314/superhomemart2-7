//หน้าสรุปการสั่งซื้อยังไม่ได้ใช้งาน และยังไม่ได้ทำการเชื่อมต่อกับหน้าอื่นๆ

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:superhomemart2/Pagemain/OrderSummary_main/thankyou_page.dart'; // เพิ่มการนำเข้า
import 'package:superhomemart2/Pagemain/orderSummary_main/widgets_orderSum/shipping_address_widget.dart'; // เพิ่มการนำเข้า
import 'package:superhomemart2/Pagemain/orderSummary_main/widgets_orderSum/payment_method_widget.dart'; // เพิ่มการนำเข้า
import 'package:superhomemart2/Pagemain/orderSummary_main/widgets_orderSum/cart_items_widget.dart'; // เพิ่มการนำเข้า

class OrderSummaryPage extends StatelessWidget {
  final String fname;
  final String lname;
  final String houseNumber;
  final String province;
  final String district;
  final String subDistrict;
  final String postalCode;
  final String phone;
  final String email;
  final String paymentMethod;

  const OrderSummaryPage({
    Key? key,
    required this.fname,
    required this.lname,
    required this.houseNumber,
    required this.province,
    required this.district,
    required this.subDistrict,
    required this.postalCode,
    required this.phone,
    required this.email,
    required this.paymentMethod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'สรุปคำสั่งซื้อ',
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
              ShippingAddressWidget(
                fname: fname,
                lname: lname,
                houseNumber: houseNumber,
                province: province,
                district: district,
                subDistrict: subDistrict,
                postalCode: postalCode,
                phone: phone,
                email: email,
              ),
              const SizedBox(height: 20),
              PaymentMethodWidget(paymentMethod: paymentMethod),
              const SizedBox(height: 20),
              const CartItemsWidget(),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle order confirmation logic here
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ThankYouPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 0, 255),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'ยืนยันการสั่งซื้อ',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
