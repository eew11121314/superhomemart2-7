import 'package:flutter/material.dart';

class PaymentOptions extends StatefulWidget {
  final VoidCallback onOnlinePayment;
  final VoidCallback onQRCodePayment;
  final VoidCallback onCashOnDelivery;

  const PaymentOptions({
    Key? key,
    required this.onOnlinePayment,
    required this.onQRCodePayment,
    required this.onCashOnDelivery,
  }) : super(key: key);

  @override
  _PaymentOptionsState createState() => _PaymentOptionsState();
}

class _PaymentOptionsState extends State<PaymentOptions> {
  String _selectedPaymentMethod = '';

  void _selectPaymentMethod(String method) {
    setState(() {
      _selectedPaymentMethod = method;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const Text(
            'เลือกวิธีการชำระเงิน',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Kanit',
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          _buildPaymentOption(
            'ชำระเงินบัญชีธนาคาร',
            'online',
            widget.onOnlinePayment,
          ),
          const SizedBox(height: 10),
          _buildPaymentOption(
            'ชำระผ่าน QR Code',
            'qr',
            widget.onQRCodePayment,
          ),
          const SizedBox(height: 10),
          _buildPaymentOption(
            'ชำระค่าจัดส่งปลายทาง',
            'cod',
            widget.onCashOnDelivery,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
    String text,
    String method,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: () {
        _selectPaymentMethod(method);
        onPressed();
      },
      child: Row(
        children: [
          Radio<String>(
            value: method,
            groupValue: _selectedPaymentMethod,
            onChanged: (value) {
              _selectPaymentMethod(value!);
              onPressed();
            },
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Kanit',
              color: _selectedPaymentMethod == method
                  ? Colors.green
                  : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
