import 'package:flutter/material.dart';

class AccountBank extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 37, 27, 155), // พื้นหลังสีน้ำเงิน
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
          Text(
            'ชื่อบัญชี: บจก.ซูเปอร์โฮมมาร์ท',
            style: TextStyle(
              fontFamily: 'Kanit',
              fontSize: screenWidth * 0.045, // ปรับขนาดตัวอักษรตามขนาดหน้าจอ
              color: Colors.white, // ตัวหนังสือสีขาว
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'บัญชีธนาคาร: 218-270055-2 ธ.ไทยพาณิชย์ สาขาสะพานเหลือง',
            style: TextStyle(
              fontFamily: 'Kanit',
              fontSize: screenWidth * 0.045, // ปรับขนาดตัวอักษรตามขนาดหน้าจอ
              color: Colors.yellow, // ตัวหนังสือสีเหลือง
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'ทางร้านจะเช็คสต๊อกสินค้าและแจ้งกลับเพื่อยืนยันคำสั่งซื้อ กรุณารอทางร้านยืนยันก่อนทำการชำระเงิน',
            style: TextStyle(
              fontFamily: 'Kanit',
              fontSize: screenWidth * 0.04, // ปรับขนาดตัวอักษรตามขนาดหน้าจอ
              color: Colors.white, // ตัวหนังสือสีขาว
            ),
          ),
        ],
      ),
    );
  }
}
