import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // เพิ่มการนำเข้า
import 'package:flutter_svg/flutter_svg.dart'; // นำเข้า flutter_svg
import 'package:superhomemart2/json_data_loader.dart'; // นำเข้าคลาส JsonDataLoader
import 'package:shared_preferences/shared_preferences.dart'; // นำเข้า SharedPreferences

class AddressForm extends StatefulWidget {
  final TextEditingController fullNameController;
  final TextEditingController houseNumberController;
  final TextEditingController provinceController;
  final TextEditingController districtController;
  final TextEditingController subDistrictController;
  final TextEditingController postalCodeController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController addressController;
  final TextEditingController usernameController;
  final TextEditingController companyController;
  final TextEditingController taxIdController;
  final TextEditingController shippingCostController;
  final TextEditingController textAboutController;

  final VoidCallback onChangeAddress;

  const AddressForm({
    Key? key,
    required this.fullNameController,
    required this.houseNumberController,
    required this.provinceController,
    required this.districtController,
    required this.subDistrictController,
    required this.postalCodeController,
    required this.phoneController,
    required this.emailController,
    required this.addressController,
    required this.usernameController,
    required this.companyController,
    required this.taxIdController,
    required this.shippingCostController,
    required this.textAboutController,
    required this.onChangeAddress,
  }) : super(key: key);

  @override
  AddressFormState createState() => AddressFormState();
}

class AddressFormState extends State<AddressForm> {
  bool _isFormVisible = false; // ตั้งค่าเริ่มต้นให้ฟอร์มถูกซ่อน
  List<dynamic> _provinces = [];
  List<dynamic> _districts = [];
  List<dynamic> _subDistricts = [];
  final JsonDataLoader _jsonDataLoader = JsonDataLoader();
  String? _username; // ตัวแปรเก็บ username

  @override
  void initState() {
    super.initState();
    _loadJsonData();
    _loadUsername(); // โหลด username จาก SharedPreferences
    _loadSavedAddress(); // โหลดข้อมูลที่อยู่ที่บันทึกไว้
  }

  Future<void> _loadJsonData() async {
    await _jsonDataLoader.loadJsonData();
    setState(() {
      _provinces = _jsonDataLoader.provinces;
    });
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username =
          prefs.getString('username'); // ดึง username จาก SharedPreferences
      widget.usernameController.text =
          _username ?? ''; // แสดง username ในช่อง username
    });
  }

  Future<void> _loadSavedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      widget.fullNameController.text = prefs.getString('fullName') ?? '';
      widget.companyController.text = prefs.getString('company') ?? '';
      widget.taxIdController.text = prefs.getString('taxId') ?? '';
      widget.houseNumberController.text = prefs.getString('houseNumber') ?? '';
      widget.provinceController.text = prefs.getString('province') ?? '';
      widget.districtController.text = prefs.getString('district') ?? '';
      widget.subDistrictController.text = prefs.getString('subDistrict') ?? '';
      widget.postalCodeController.text = prefs.getString('postalCode') ?? '';
      widget.phoneController.text = prefs.getString('phone') ?? '';
      widget.emailController.text = prefs.getString('email') ?? '';
      widget.shippingCostController.text =
          prefs.getString('shippingCost') ?? ''; // โหลดค่าจัดส่งที่บันทึกไว้
      widget.textAboutController.text = prefs.getString('textAbout') ??
          ''; // โหลดข้อความเกี่ยวกับที่บันทึกไว้
    });
  }

  void _onProvinceChanged(String? value) {
    setState(() {
      widget.provinceController.text = value!;
      int provinceId = _provinces
          .firstWhere((province) => province['name_th'] == value)['id'];
      _districts = _jsonDataLoader.getDistrictsByProvinceId(provinceId);
      widget.districtController.clear();
      widget.subDistrictController.clear();
      widget.postalCodeController.clear();
      _subDistricts = [];
    });
  }

  void _onDistrictChanged(String? value) {
    setState(() {
      widget.districtController.text = value!;
      int districtId = _districts
          .firstWhere((district) => district['name_th'] == value)['id'];
      _subDistricts = _jsonDataLoader.getSubDistrictsByDistrictId(districtId);
      widget.subDistrictController.clear();
      widget.postalCodeController.clear();
    });
  }

  void _onSubDistrictChanged(String? value) {
    setState(() {
      widget.subDistrictController.text = value!;
      widget.postalCodeController.text =
          _jsonDataLoader.getPostalCodeBySubDistrictName(value);
    });
  }

  Future<void> _saveAddress() async {
    if (widget.fullNameController.text.isEmpty ||
        widget.houseNumberController.text.isEmpty ||
        widget.provinceController.text.isEmpty ||
        widget.districtController.text.isEmpty ||
        widget.subDistrictController.text.isEmpty ||
        widget.postalCodeController.text.isEmpty ||
        widget.phoneController.text.isEmpty) {
      // แสดงข้อความแจ้งเตือนว่าฟิลด์ที่จำเป็นต้องกรอก
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณากรอกข้อมูลให้ครบถ้วน'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (widget.phoneController.text.length > 10) {
      // แสดงข้อความแจ้งเตือนว่าเบอร์โทรศัพท์ต้องไม่เกิน 10 ตัวอักษร
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('เบอร์โทรศัพท์ต้องไม่เกิน 10 ตัวอักษร'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // บันทึกข้อมูลที่อยู่ลง SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fullName', widget.fullNameController.text);
    await prefs.setString('company', widget.companyController.text);
    await prefs.setString('taxId', widget.taxIdController.text);
    await prefs.setString('houseNumber', widget.houseNumberController.text);
    await prefs.setString('province', widget.provinceController.text);
    await prefs.setString('district', widget.districtController.text);
    await prefs.setString('subDistrict', widget.subDistrictController.text);
    await prefs.setString('postalCode', widget.postalCodeController.text);
    await prefs.setString('phone', widget.phoneController.text);
    await prefs.setString('email', widget.emailController.text);
    await prefs.setString(
        'shippingCost', widget.shippingCostController.text); // บันทึกค่าจัดส่ง
    await prefs.setString(
        'textAbout', widget.textAboutController.text); // บันทึกข้อความเกี่ยวกับ

    // แสดงข้อความสำเร็จและซ่อนฟอร์ม
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('บันทึกข้อมูลสำเร็จ'),
        backgroundColor: Colors.green,
      ),
    );
    setState(() {
      _isFormVisible = false;
    });
  }

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
                Text(
                  'Username: $_username',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: widget.fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'ชื่อ-นามสกุล',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: widget.companyController,
                  decoration: const InputDecoration(
                    labelText: 'บริษัท (ถ้ามี)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: widget.taxIdController,
                  decoration: const InputDecoration(
                    labelText: 'เลขผู้เสียภาษี',
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
                  controller: widget.phoneController,
                  decoration: const InputDecoration(
                    labelText: 'เบอร์โทรศัพท์',
                    border: OutlineInputBorder(),
                    counterText: '', // ซ่อนจำนวนที่แสดง
                  ),
                  maxLength: 10, // เพิ่มการจำกัดความยาวของเบอร์โทรศัพท์
                  keyboardType:
                      TextInputType.number, // กำหนดให้เป็นคีย์บอร์ดตัวเลข
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // อนุญาตเฉพาะตัวเลข
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: widget.emailController,
                  decoration: const InputDecoration(
                    labelText: 'อีเมล ',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: widget.provinceController.text.isEmpty
                      ? null
                      : widget.provinceController.text,
                  onChanged: _onProvinceChanged,
                  items: _provinces.map<DropdownMenuItem<String>>((province) {
                    return DropdownMenuItem<String>(
                      value: province['name_th'],
                      child: Text(province['name_th']),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'จังหวัด',
                    border: OutlineInputBorder(),
                  ),
                  icon: SvgPicture.asset(
                    'assets/Icon/arrow_down.svg',
                    height: 24,
                    width: 24,
                    color: Colors.black, // เปลี่ยนสีไอคอนเป็นสีดำ
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: widget.districtController.text.isEmpty
                      ? null
                      : widget.districtController.text,
                  onChanged: _onDistrictChanged,
                  items: _districts.map<DropdownMenuItem<String>>((district) {
                    return DropdownMenuItem<String>(
                      value: district['name_th'],
                      child: Text(district['name_th']),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'อำเภอ/เขต',
                    border: const OutlineInputBorder(),
                    fillColor: widget.districtController.text.isEmpty
                        ? Colors.grey[200]
                        : Colors.white,
                    filled: true,
                  ),
                  icon: SvgPicture.asset(
                    'assets/Icon/arrow_down.svg',
                    height: 24,
                    width: 24,
                    color: Colors.black, // เปลี่ยนสีไอคอนเป็นสีดำ
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: widget.subDistrictController.text.isEmpty
                      ? null
                      : widget.subDistrictController.text,
                  onChanged: _onSubDistrictChanged,
                  items: _subDistricts
                      .map<DropdownMenuItem<String>>((subDistrict) {
                    return DropdownMenuItem<String>(
                      value: subDistrict['name_th'],
                      child: Text(subDistrict['name_th']),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'ตำบล/แขวง',
                    border: OutlineInputBorder(),
                    fillColor: widget.subDistrictController.text.isEmpty
                        ? Colors.grey[200]
                        : Colors.white,
                    filled: true,
                  ),
                  icon: SvgPicture.asset(
                    'assets/Icon/arrow_down.svg',
                    height: 24,
                    width: 24,
                    color: Colors.black, // เปลี่ยนสีไอคอนเป็นสีดำ
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
                Visibility(
                  visible: false, // ซ่อน TextField สำหรับค่าจัดส่ง
                  child: TextField(
                    controller: widget.shippingCostController,
                    decoration: const InputDecoration(
                      labelText: 'ค่าจัดส่ง',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType:
                        TextInputType.number, // กำหนดให้เป็นคีย์บอร์ดตัวเลข
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // อนุญาตเฉพาะตัวเลข
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: false, // ซ่อน TextField สำหรับข้อความเกี่ยวกับ
                  child: TextField(
                    controller: widget.textAboutController,
                    decoration: const InputDecoration(
                      labelText: 'ข้อความเกี่ยวกับ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveAddress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 0, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('ยืนยันที่อยู่',
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
