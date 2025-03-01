// นำเข้าแพ็กเกจที่จำเป็น
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

// สร้างคลาส JsonDataLoader สำหรับจัดการข้อมูล JSON
class JsonDataLoader {
  // ประกาศตัวแปรสำหรับเก็บข้อมูล
  List<dynamic> provinces = [];
  List<dynamic> districts = [];
  List<dynamic> subDistricts = [];
  Map<String, dynamic> postalCodes = {};

  // ฟังก์ชันสำหรับโหลดข้อมูล JSON จากไฟล์
  Future<void> loadJsonData() async {
    // โหลดข้อมูล JSON จากไฟล์ในโฟลเดอร์ assets/district
    final String response1 =
        await rootBundle.loadString('assets/district/1.json');
    final String response2 =
        await rootBundle.loadString('assets/district/2.json');
    final String response3 =
        await rootBundle.loadString('assets/district/3.json');

    // แปลงข้อมูล JSON เป็นรูปแบบที่สามารถใช้งานได้ใน Dart
    final data1 = await json.decode(response1);
    final data2 = await json.decode(response2);
    final data3 = await json.decode(response3);

    // เก็บข้อมูลที่แปลงแล้วในตัวแปรที่ประกาศไว้
    provinces = data1;
    districts = data2;
    subDistricts = data3;

    // สร้างแผนที่สำหรับเก็บรหัสไปรษณีย์โดยใช้ชื่อของตำบลเป็นคีย์
    postalCodes = {
      for (var item in subDistricts)
        item['name_th']: item['zip_code'].toString()
    };
  }

  // ฟังก์ชันสำหรับดึงข้อมูลอำเภอโดยใช้รหัสจังหวัด
  List<dynamic> getDistrictsByProvinceId(int provinceId) {
    return districts
        .where((district) => district['province_id'] == provinceId)
        .toList();
  }

  // ฟังก์ชันสำหรับดึงข้อมูลตำบลโดยใช้รหัสอำเภอ
  List<dynamic> getSubDistrictsByDistrictId(int districtId) {
    return subDistricts
        .where((subDistrict) => subDistrict['amphure_id'] == districtId)
        .toList();
  }

  // ฟังก์ชันสำหรับดึงรหัสไปรษณีย์โดยใช้ชื่อตำบล
  String getPostalCodeBySubDistrictName(String subDistrictName) {
    return postalCodes[subDistrictName] ?? '';
  }
}
