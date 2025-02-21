import 'package:flutter/material.dart';

class DiscountForm extends StatelessWidget {
  final TextEditingController discountController;
  final VoidCallback onApplyDiscount;

  const DiscountForm({
    Key? key,
    required this.discountController,
    required this.onApplyDiscount,
  }) : super(key: key);

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
            'ใส่รหัสส่วนลด',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Kanit',
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: discountController,
            decoration: const InputDecoration(
              labelText: 'รหัสส่วนลด',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onApplyDiscount,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'ใช้ส่วนลด',
                style: TextStyle(fontFamily: 'Kanit', color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
