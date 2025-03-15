import 'package:flutter/material.dart';

class PaymentMethodWidget extends StatelessWidget {
  final String paymentMethod;

  const PaymentMethodWidget({
    Key? key,
    required this.paymentMethod,
  }) : super(key: key);

  String _translatePaymentMethod(String method) {
    switch (method) {
      case 'pickup':
        return 'รับหน้าร้าน';
      case 'delivery':
        return 'จัดส่งสินค้า';
      case 'cash_on_delivery':
        return 'เก็บค่าจัดส่งปลายทาง';
      default:
        return method;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'วิธีการชำระเงิน',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Kanit',
            fontWeight: FontWeight.bold,
            color: Colors.black,
            // shadows: [
            //   Shadow(
            //     offset: Offset(1.0, 1.0),
            //     blurRadius: 2.0,
            //     color: Colors.grey,
            //   ),
            // ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          _translatePaymentMethod(paymentMethod),
          style: const TextStyle(
            fontSize: 18,
            fontFamily: 'Kanit',
            fontWeight: FontWeight.bold, // เพิ่มความหนาของตัวหนังสือ
            color: Color.fromARGB(255, 32, 112, 35),
            // shadows: [
            //   Shadow(
            //     offset: Offset(1.0, 1.0),
            //     blurRadius: 2.0,
            //     color: Colors.grey,
            //   ),
            // ],
          ),
        ),
      ],
    );
  }
}
