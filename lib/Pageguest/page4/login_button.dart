//สำหรับเมื่อเชื่อมหลังบ้านไม่ได้เป็นปุ่มลัด เข้าหน้าอื่นๆ
// /*
import 'package:flutter/material.dart';
import 'package:superhomemart2/Pagemain/widgets_main/page1_bar_main.dart'; // Update the import
import 'package:shared_preferences/shared_preferences.dart'; // เพิ่มการนำเข้า
import 'package:superhomemart2/Pagemain/order_main/order1_m.dart'; // เพิ่มการนำเข้า
import 'package:superhomemart2/Pagemain/orderSummary_main/order_summary_page.dart'; // เพิ่มการนำเข้า
import 'package:superhomemart2/Pagemain/Pagepayment/pageqrcode_m.dart'; // เพิ่มการนำเข้า

class LoginButtonPage extends StatelessWidget {
  const LoginButtonPage({Key? key}) : super(key: key);

  Future<void> _login(BuildContext context) async {
    // บันทึกสถานะการเข้าสู่ระบบใน SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);

    // นำทางไปยังหน้า Custom_MBottomNavigationBar
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Custom_MBottomNavigationBar(),
      ),
    );
  }

  Future<void> _navigateToOrderPage(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const OrderPageM(), // แทนที่ด้วยชื่อคลาสของหน้า order1_m.dart
      ),
    );
  }

  Future<void> _navigateToOrderSummaryPage(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OrderSummaryPage(
          fname: 'John',
          lname: 'Doe',
          houseNumber: '123',
          province: 'Bangkok',
          district: 'Bang Kapi',
          subDistrict: 'Hua Mak',
          postalCode: '10240',
          phone: '0123456789',
          email: 'john.doe@example.com',
          paymentMethod: 'Online Payment',
        ),
      ),
    );
  }

  Future<void> _navigateToQRCodePage(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const PageQRCode(qrImagePath: 'assets/QRCODE_test.png'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ปุ่มลัด'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _login(context),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('เข้า page1m_dart'),
            ),
            const SizedBox(height: 20), // เพิ่มระยะห่างระหว่างปุ่ม
            ElevatedButton(
              onPressed: () => _navigateToOrderPage(context),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('ไปยังหน้า Order'),
            ),
            const SizedBox(height: 20), // เพิ่มระยะห่างระหว่างปุ่ม
            ElevatedButton(
              onPressed: () => _navigateToOrderSummaryPage(context),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('ไปยังหน้า Order Summary'),
            ),
            const SizedBox(height: 20), // เพิ่มระยะห่างระหว่างปุ่ม
            ElevatedButton(
              onPressed: () => _navigateToQRCodePage(context),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('ไปยังหน้า QR Code'),
            ),
          ],
        ),
      ),
    );
  }
}
// */
