import 'package:flutter/material.dart';

class QRCodeWidget extends StatelessWidget {
  final String qrImagePath;

  const QRCodeWidget({Key? key, required this.qrImagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          qrImagePath,
          width: 200.0,
          height: 200.0,
        ),
        const SizedBox(height: 20),
        const Text(
          'กรุณาสแกน QR Code เพื่อชำระเงินสินค้า',
          style: TextStyle(fontFamily: 'Kanit', fontSize: 16),
        ),
        const SizedBox(height: 20),
        const Text(
          'เมื่อชำระค่าบริการเสร็จกรุณาส่งสลิป',
          style: TextStyle(fontFamily: 'Kanit', fontSize: 16),
        ),
      ],
    );
  }
}
