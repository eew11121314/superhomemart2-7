import 'package:flutter/material.dart';
import 'package:superhomemart2/Pagemain/order_main/widgets_order1_m/accountbank_m.dart'; // เพิ่มการนำเข้า
import 'package:superhomemart2/Pagemain/transferslips_main/widgets_slips/transfer_slipsupload_widget.dart'; // นำเข้า TransferSlipsWidget
import 'package:superhomemart2/Pagemain/transferslips_main/widgets_slips/transfer_datetime_widget.dart'; // นำเข้า TransferDateTimePicker
import 'package:superhomemart2/Pagemain/transferslips_main/widgets_slips/transfer_from_widget.dart'; // นำเข้า TransferSlipsFormFields

class TransferSlipsPage extends StatefulWidget {
  const TransferSlipsPage({Key? key}) : super(key: key);

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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_transferDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('กรุณาเลือกเวลาในการโอน')),
        );
        return;
      }
      // ส่งข้อมูลไปยังเซิร์ฟเวอร์หรือทำการประมวลผลอื่น ๆ
      // ...
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ส่งข้อมูลเรียบร้อยแล้ว')),
      );
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
        preferredSize: const Size.fromHeight(80.0), // ปรับความสูงของ AppBar
        child: AppBar(
          title: const Text(
            'ส่งสลิปโอนเงิน',
            style: TextStyle(
              fontFamily: 'Kanit',
              fontSize: 24.0, // ปรับขนาดตัวอักษร
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
                AccountBank(), // ลบ const ออก
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
                const TransferSlipsWidget(), // ใช้ TransferSlipsWidget แทน
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
                        shadows: [
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 2.0,
                            color: Colors.grey,
                          ),
                        ],
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
