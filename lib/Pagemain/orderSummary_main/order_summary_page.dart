import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:superhomemart2/Pagemain/orderSummary_main/widgets_orderSum/shipping_address_widget.dart'; // เพิ่มการนำเข้า
import 'package:superhomemart2/Pagemain/orderSummary_main/widgets_orderSum/payment_method_widget.dart'; // เพิ่มการนำเข้า
import 'package:superhomemart2/Pagemain/orderSummary_main/widgets_orderSum/cart_items_widget.dart'; // ตระกร้าสินค้า
import 'package:superhomemart2/Pagemain/transferslips_main/transfer_slips_m.dart'; // เพิ่มการนำเข้า
import 'package:superhomemart2/Pagemain/order_main/widgets_order1_m/accountbank_m.dart'; // เพิ่มการนำเข้า

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
  final String orderId; // เพิ่มตัวแปร orderId
  final double totalAmount; // เพิ่มตัวแปร totalAmount

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
    required this.orderId, // เพิ่มตัวแปร orderId
    required this.totalAmount, // เพิ่มตัวแปร totalAmount
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
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
                  child: Text(
                    'เลขคำสั่งซื้อ: $orderId', // แสดงเลขคำสั่งซื้อ
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Kanit',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AccountBank(), // ลบ const ออกจาก AccountBank widget
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to TransferSlipsPage with data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransferSlipsPage(
                            name: fname,
                            email: email,
                            orderNumber: orderId,
                            amount: totalAmount, // ส่ง totalAmount ไปด้วย
                          ),
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
                    child: Text(
                      'ยืนยันการสั่งซื้อ',
                      style: TextStyle(
                        fontSize: screenWidth *
                            0.045, // ปรับขนาดตัวอักษรตามขนาดหน้าจอ
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
