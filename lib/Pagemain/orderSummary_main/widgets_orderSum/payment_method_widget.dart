import 'package:flutter/material.dart';

class PaymentMethodWidget extends StatelessWidget {
  final String paymentMethod;

  const PaymentMethodWidget({
    Key? key,
    required this.paymentMethod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'วิธีการชำระเงิน',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Kanit',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(paymentMethod),
      ],
    );
  }
}
