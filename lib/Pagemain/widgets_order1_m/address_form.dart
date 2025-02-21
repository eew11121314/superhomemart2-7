// ใส่ที่อยู่จัดส่ง และ สั่งซื้อสินค้า
import 'package:flutter/material.dart';

class AddressForm extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController houseNumberController;
  final TextEditingController provinceController;
  final TextEditingController districtController;
  final TextEditingController subDistrictController;
  final TextEditingController postalCodeController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController addressController;
  final VoidCallback onChangeAddress;

  const AddressForm({
    Key? key,
    required this.nameController,
    required this.houseNumberController,
    required this.provinceController,
    required this.districtController,
    required this.subDistrictController,
    required this.postalCodeController,
    required this.phoneController,
    required this.emailController,
    required this.addressController,
    required this.onChangeAddress,
  }) : super(key: key);

  @override
  _AddressFormState createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  bool _isFormVisible = true;

  void _toggleFormVisibility() {
    setState(() {
      _isFormVisible = !_isFormVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _toggleFormVisibility,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isFormVisible
                  ? const Color.fromARGB(255, 138, 59, 59)
                  : const Color.fromARGB(255, 37, 107, 37),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              _isFormVisible ? 'ซ่อนที่อยู่' : 'เพิ่มที่อยู่',
              style: const TextStyle(fontFamily: 'Kanit', color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 10), // เว้นระยะห่างระหว่างปุ่มกับฟอร์ม
        if (_isFormVisible)
          Container(
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
                TextField(
                  controller: widget.nameController,
                  decoration: const InputDecoration(
                    labelText: 'ชื่อ-นามสกุล',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: widget.houseNumberController,
                  decoration: const InputDecoration(
                    labelText: 'บ้านเลขที่',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: widget.provinceController,
                  decoration: const InputDecoration(
                    labelText: 'จังหวัด',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: widget.districtController,
                  decoration: const InputDecoration(
                    labelText: 'อำเภอ/เขต',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: widget.subDistrictController,
                  decoration: const InputDecoration(
                    labelText: 'ตำบล/แขวง',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: widget.postalCodeController,
                  decoration: const InputDecoration(
                    labelText: 'รหัสไปรษณีย์',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: widget.phoneController,
                  decoration: const InputDecoration(
                    labelText: 'เบอร์โทรศัพท์',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: widget.emailController,
                  decoration: const InputDecoration(
                    labelText: 'อีเมล',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: widget.addressController,
                  decoration: const InputDecoration(
                    labelText: 'ที่อยู่ใหม่',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: widget.onChangeAddress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 0, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('เปลี่ยนที่อยู่',
                        style: TextStyle(
                            fontFamily: 'Kanit', color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
