import 'package:flutter/material.dart';

class ShippingAddressWidget extends StatelessWidget {
  final String fname;
  final String lname;
  final String houseNumber;
  final String province;
  final String district;
  final String subDistrict;
  final String postalCode;
  final String phone;
  final String email;

  const ShippingAddressWidget({
    Key? key,
    required this.fname,
    required this.lname,
    required this.houseNumber,
    required this.province,
    required this.district,
    required this.subDistrict,
    required this.postalCode,
    required this.phone,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ที่อยู่จัดส่ง',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Kanit',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text('ชื่อ: $fname $lname'),
        Text('บ้านเลขที่: $houseNumber'),
        Text('ตำบล/แขวง: $subDistrict'),
        Text('อำเภอ/เขต: $district'),
        Text('จังหวัด: $province'),
        Text('รหัสไปรษณีย์: $postalCode'),
        Text('เบอร์โทรศัพท์: $phone'),
        Text('อีเมล: $email'),
      ],
    );
  }
}
