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

  Widget _buildAddressField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Kanit',
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
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
            'ที่อยู่จัดส่ง',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          _buildAddressField('ชื่อ', '$fname $lname'),
          _buildAddressField('บ้านเลขที่', houseNumber),
          _buildAddressField('ตำบล/แขวง', subDistrict),
          _buildAddressField('อำเภอ/เขต', district),
          _buildAddressField('จังหวัด', province),
          _buildAddressField('รหัสไปรษณีย์', postalCode),
          _buildAddressField('เบอร์โทรศัพท์', phone),
          _buildAddressField('อีเมล', email),
        ],
      ),
    );
  }
}
