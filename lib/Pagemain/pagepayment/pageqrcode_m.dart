import 'package:flutter/material.dart';

class PageQRCode extends StatelessWidget {
  final String qrImagePath;

  const PageQRCode({Key? key, required this.qrImagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'QR Code Payment',
          style: TextStyle(fontFamily: 'Kanit', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 253, 254, 255),
        automaticallyImplyLeading: false, // ซ่อนปุ่มย้อนกลับอัตโนมัติ
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
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
          ],
        ),
      ),
    );
  }
}
