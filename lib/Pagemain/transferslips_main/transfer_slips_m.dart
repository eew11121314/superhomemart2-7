import 'package:flutter/material.dart';
import 'package:superhomemart2/Pagemain/order_main/widgets_order1_m/accountbank_m.dart';
import 'package:superhomemart2/Pagemain/transferslips_main/widgets_slips/transfer_datetime_widget.dart';
import 'package:superhomemart2/Pagemain/transferslips_main/widgets_slips/transfer_from_widget.dart';
import 'package:superhomemart2/Pagemain/transferslips_main/widgets_slips/transfer_slipsupload_widget.dart'; // เพิ่มการนำเข้า
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:superhomemart2/Pagemain/order_main/cart/cart_provider_m.dart';
import 'package:superhomemart2/Pagemain/_page1_main/page1_m.dart';

class TransferSlipsPage extends StatefulWidget {
  final String name;
  final String email;
  final String orderNumber;
  final double amount;

  const TransferSlipsPage({
    Key? key,
    required this.name,
    required this.email,
    required this.orderNumber,
    required this.amount,
  }) : super(key: key);

  @override
  _TransferSlipsPageState createState() => _TransferSlipsPageState();
}

class _TransferSlipsPageState extends State<TransferSlipsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _orderNumberController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime? _transferDate;
  File? _slipFile;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _emailController.text = widget.email;
    _orderNumberController.text = widget.orderNumber;
    _amountController.text = widget.amount.toString();
  }

  void _onImageSelected(File? image) {
    setState(() {
      _slipFile = image;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_transferDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('กรุณาเลือกเวลาในการโอน')),
        );
        return;
      }

      if (_slipFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('กรุณาแนบไฟล์สลิปโอนเงิน')),
        );
        return;
      }

      try {
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('https://superhomemart.duckdns.org/api/upload_slip'),
        );
        request.files
            .add(await http.MultipartFile.fromPath('slip', _slipFile!.path));
        request.fields['name'] = _nameController.text;
        request.fields['email'] = _emailController.text;
        request.fields['order_number'] = _orderNumberController.text;
        request.fields['datetime'] = _transferDate!.toIso8601String();
        request.fields['amount'] = _amountController.text;

        final response = await request.send();

        if (response.statusCode == 200) {
          Provider.of<CartProvider>(context, listen: false).clearCart();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ส่งข้อมูลเรียบร้อยแล้ว')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Page1M()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('เกิดข้อผิดพลาดในการส่งข้อมูล')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('เกิดข้อผิดพลาดในการส่งข้อมูล')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          title: const Text(
            'ส่งสลิปโอนเงิน',
            style: TextStyle(
              fontFamily: 'Kanit',
              fontSize: 24.0,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AccountBank(),
                const SizedBox(height: 20),
                TransferSlipsFormFields(
                  nameController: _nameController,
                  emailController: _emailController,
                  orderNumberController: _orderNumberController,
                  amountController: _amountController,
                ),
                const SizedBox(height: 16),
                TransferDateTimePicker(
                  initialDate: _transferDate,
                  onDateTimeChanged: (newDate) {
                    setState(() {
                      _transferDate = newDate;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TransferSlipsUploadWidget(
                  onImageSelected: _onImageSelected,
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 37, 37, 158),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.bold,
                        // shadows: [
                        //   Shadow(
                        //     offset: Offset(1.0, 1.0),
                        //     blurRadius: 2.0,
                        //     color: Colors.grey,
                        //   ),
                        // ],
                      ),
                    ),
                    child: const Text(
                      'ส่งข้อมูล',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Page1M()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'ดำเนินการสำเร็จ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
