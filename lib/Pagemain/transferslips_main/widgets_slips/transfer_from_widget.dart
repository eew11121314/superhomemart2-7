import 'package:flutter/material.dart';

class TransferSlipsFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController orderNumberController;
  final TextEditingController amountController;

  const TransferSlipsFormFields({
    Key? key,
    required this.nameController,
    required this.emailController,
    required this.orderNumberController,
    required this.amountController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'ชื่อผู้โอน',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'กรุณากรอกชื่อผู้โอน';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'อีเมลสำหรับยืนยัน',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'กรุณากรอกอีเมล';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: orderNumberController,
          decoration: const InputDecoration(
            labelText: 'เลขคำสั่งซื้อ',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'กรุณากรอกเลขคำสั่งซื้อ';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: amountController,
          decoration: const InputDecoration(
            labelText: 'จำนวนเงินที่โอน',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'กรุณากรอกจำนวนเงินที่โอน';
            }
            return null;
          },
        ),
      ],
    );
  }
}
