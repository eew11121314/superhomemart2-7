import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:superhomemart2/Pagemain/order_main/widgets_order1_m/_add_address_form.dart';
import 'package:superhomemart2/Pagemain/order_main/widgets_order1_m/payment_options.dart';
import 'package:superhomemart2/Pagemain/order_main/widgets_order1_m/product_preview.dart';
import 'package:superhomemart2/Pagemain/order_main/cart/cart_provider_m.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart'; // นำเข้า logger
import 'package:shared_preferences/shared_preferences.dart'; // นำเข้า shared_preferences
import 'package:superhomemart2/Pagemain/order_main/widgets_order1_m/accountbank_m.dart'; // นำเข้า accountBank_m.dart
import 'package:superhomemart2/Pagemain/orderSummary_main/order_summary_page.dart'; // นำเข้า order_summary_page.dart

class OrderPageM extends StatefulWidget {
  const OrderPageM({super.key});

  @override
  OrderPageMState createState() => OrderPageMState();
}

class OrderPageMState extends State<OrderPageM> with WidgetsBindingObserver {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _fullNameController =
      TextEditingController(); // เพิ่ม TextEditingController สำหรับชื่อเต็ม
  final TextEditingController _companyController =
      TextEditingController(); // เพิ่ม TextEditingController สำหรับบริษัท
  final TextEditingController _taxIdController =
      TextEditingController(); // เพิ่ม TextEditingController สำหรับเลขผู้เสียภาษี
  final TextEditingController _houseNumberController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _subDistrictController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController =
      TextEditingController(); // เพิ่ม TextEditingController สำหรับ username
  final TextEditingController _shippingCostController = TextEditingController(
      text:
          '0'); // เพิ่ม TextEditingController สำหรับค่าจัดส่งและตั้งค่าเริ่มต้นเป็น 0
  final TextEditingController _textAboutController =
      TextEditingController(); // เพิ่ม TextEditingController สำหรับข้อความเกี่ยวกับ

  bool _isAddressFormVisible = true;
  final Logger _logger = Logger(); // สร้าง instance ของ Logger
  String _selectedPaymentMethod =
      ''; // เพิ่มตัวแปรสำหรับเก็บวิธีการชำระเงินที่เลือก
  bool _isLoginChecked = false; // Add a flag to check login status

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadSavedOrderData(); // โหลดข้อมูลการสั่งซื้อที่บันทึกไว้
    _checkLoginStatus(); // ตรวจสอบสถานะการล็อกอิน
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkLoginStatus(); // ตรวจสอบสถานะการล็อกอินเมื่อแอปกลับมาใช้งาน
    }
  }

  Future<void> _loadSavedOrderData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _addressController.text = prefs.getString('address') ?? '';
      _fullNameController.text = prefs.getString('fullName') ?? '';
      _companyController.text = prefs.getString('company') ?? '';
      _taxIdController.text = prefs.getString('taxId') ?? '';
      _houseNumberController.text = prefs.getString('houseNumber') ?? '';
      _provinceController.text = prefs.getString('province') ?? '';
      _districtController.text = prefs.getString('district') ?? '';
      _subDistrictController.text = prefs.getString('subDistrict') ?? '';
      _postalCodeController.text = prefs.getString('postalCode') ?? '';
      _phoneController.text = prefs.getString('phone') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
      _shippingCostController.text =
          (prefs.getString('shippingCost')?.isEmpty ?? true)
              ? '0'
              : prefs.getString(
                  'shippingCost')!; // โหลดค่าจัดส่งที่บันทึกไว้ หรือ 0 ถ้าไม่มี
      _textAboutController.text = prefs.getString('textAbout') ??
          ''; // โหลดข้อความเกี่ยวกับที่บันทึกไว้
    });
  }

  Future<void> _checkLoginStatus() async {
    if (_isLoginChecked) return; // Skip if login status is already checked

    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
    } else {
      setState(() {
        _isLoginChecked = true; // Set the flag to true after checking
      });
    }
  }

  // ...existing code...

  Future<void> _placeOrder() async {
    const String url = "https://superhomemart.duckdns.org/api/orders";
    const String apiKey =
        'WHt)m6gpqxkF1r(oDczv8mq%'; // แทนที่ด้วย API Key ที่ถูกต้อง

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final cartItems = cartProvider.cartItems.map((item) {
      return {
        'product_id': item.productId,
        'quantity': item.quantity,
      };
    }).toList();

    // คำนวณ total_amount
    final totalAmount = cartProvider.cartItems.fold<double>(
      0.00,
      (sum, item) => sum + (item.price * item.quantity),
    );

    final orderData = {
      'name': _fullNameController.text,
      'company': _companyController.text,
      'tax_id': _taxIdController.text,
      'address':
          '${_houseNumberController.text} ต.${_subDistrictController.text} อ.${_districtController.text} จ.${_provinceController.text} ${_postalCodeController.text}',
      'phone': _phoneController.text,
      'email': _emailController.text,
      'delivery_method': _selectedPaymentMethod,
      'shipping_cost': _shippingCostController.text, // เพิ่มค่าจัดส่งที่ดึงมา
      'text_about': _textAboutController.text, // เพิ่มข้อความเกี่ยวกับที่ดึงมา
      'cart': cartItems,
      'total_amount': totalAmount.toString(), // เพิ่ม total_amount
      'website': 'appshm',
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey', // เพิ่ม API Key ใน header
      },
      body: jsonEncode(orderData),
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final orderId = data['order_id'].toString(); // แปลง orderId เป็น String

      // ตรวจสอบ product_id ก่อนส่งข้อมูลไปยัง API order-items
      for (var item in cartItems) {
        final productResponse = await http.get(
          Uri.parse(
              "http://superhomemart.duckdns.org/api/product/${item['product_id']}"),
          headers: {
            'x-api-key': '$apiKey', // เพิ่ม API Key ใน header
          },
        );

        if (productResponse.statusCode == 200) {
          final productData = jsonDecode(productResponse.body);
          _logger.i(productData);
          final productId = int.tryParse(productData['id']
              .toString()); // ดึงค่า ID จากข้อมูลที่ได้และแปลงเป็น int
          _logger.i(productId);

          // ส่งข้อมูลรายการสินค้าของคำสั่งซื้อนั้นไปยัง API
          await http.post(
            Uri.parse("https://superhomemart.duckdns.org/api/order-items"),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'order_id': orderId,
              'product_id': productId, // ใช้ค่า ID ที่ได้จาก API /product
              'quantity': item['quantity'],
            }),
          );
        } else {
          _logger
              .e('Failed to fetch product data for SKU: ${item['product_id']}');
        }
      }

      // แสดงข้อความสั่งซื้อสำเร็จ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              SvgPicture.asset(
                'assets/Icon/check.svg',
                width: 25,
                height: 25,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              const Text('สั่งซื้อสำเร็จ'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 2),
        ),
      );

      // Navigate to Order Summary Page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderSummaryPage(
            fname: _fullNameController.text,
            lname: '', // เพิ่ม lname ถ้ามี
            houseNumber: _houseNumberController.text,
            province: _provinceController.text,
            district: _districtController.text,
            subDistrict: _subDistrictController.text,
            postalCode: _postalCodeController.text,
            phone: _phoneController.text,
            email: _emailController.text,
            paymentMethod: _selectedPaymentMethod,
            orderId: orderId, // ส่ง orderId ไปยัง OrderSummaryPage
            totalAmount: totalAmount, // ส่ง totalAmount ไปยัง OrderSummaryPage
          ),
        ),
      );
    } else {
      // แสดงข้อความสั่งซื้อไม่สำเร็จ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              SvgPicture.asset(
                'assets/Icon/error.svg',
                width: 25,
                height: 25,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              const Text('การสั่งซื้อยังไม่สำเร็จ'),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    // Log ข้อมูลที่กรอกมา
    _logger.i('Full Name: ${_fullNameController.text}');
    _logger.i('Company: ${_companyController.text}');
    _logger.i('Tax ID: ${_taxIdController.text}');
    _logger.i('House Number: ${_houseNumberController.text}');
    _logger.i('Province: ${_provinceController.text}');
    _logger.i('District: ${_districtController.text}');
    _logger.i('Sub District: ${_subDistrictController.text}');
    _logger.i('Postal Code: ${_postalCodeController.text}');
    _logger.i('Phone: ${_phoneController.text}');
    _logger.i('Email: ${_emailController.text}');
    _logger.i('Shipping Cost: ${_shippingCostController.text}');
    _logger.i('Text About: ${_textAboutController.text}');
    _logger.i('Selected Payment Method: $_selectedPaymentMethod');

    // Log ข้อมูลสินค้า
    for (var item in cartProvider.cartItems) {
      _logger.i(
          'Product Name: ${item.productName}, Quantity: ${item.quantity}, Price: ${item.price}');
    }

    // บันทึกข้อมูลการสั่งซื้อลง SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('address', _addressController.text);
    await prefs.setString('fullName', _fullNameController.text);
    await prefs.setString('company', _companyController.text);
    await prefs.setString('taxId', _taxIdController.text);
    await prefs.setString('houseNumber', _houseNumberController.text);
    await prefs.setString('province', _provinceController.text);
    await prefs.setString('district', _districtController.text);
    await prefs.setString('subDistrict', _subDistrictController.text);
    await prefs.setString('postalCode', _postalCodeController.text);
    await prefs.setString('phone', _phoneController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setString(
        'shippingCost', _shippingCostController.text); // บันทึกค่าจัดส่ง
    await prefs.setString(
        'textAbout', _textAboutController.text); // บันทึกข้อความเกี่ยวกับ
  }

  // ...existing code...

  void _changeAddress() {
    setState(() {
      _isAddressFormVisible = !_isAddressFormVisible;
    });
  }

  void _handleOnlinePayment() {
    setState(() {
      _selectedPaymentMethod = 'pickup';
    });
  }

  void _handleQRCodePayment() {
    setState(() {
      _selectedPaymentMethod = 'delivery';
    });
  }

  void _handleCashOnDelivery() {
    setState(() {
      _selectedPaymentMethod = 'cash_on_delivery';
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'การสั่งซื้อ',
          style: TextStyle(fontFamily: 'Kanit', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 253, 254, 255),
        automaticallyImplyLeading: false, // ซ่อนปุ่มย้อนกลับอัตโนมัติ
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/Icon/left.svg',
            width: 30,
            height: 30,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
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
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              if (_isAddressFormVisible)
                AddressForm(
                  fullNameController:
                      _fullNameController, // เพิ่ม fullNameController
                  usernameController:
                      _usernameController, // เพิ่ม usernameController
                  houseNumberController: _houseNumberController,
                  provinceController: _provinceController,
                  districtController: _districtController,
                  subDistrictController: _subDistrictController,
                  postalCodeController: _postalCodeController,
                  phoneController: _phoneController,
                  emailController: _emailController,
                  addressController: _addressController,
                  onChangeAddress: _changeAddress,
                  companyController:
                      _companyController, // เพิ่ม companyController
                  taxIdController: _taxIdController, // เพิ่ม taxIdController
                  shippingCostController:
                      _shippingCostController, // เพิ่ม shippingCostController
                  textAboutController:
                      _textAboutController, // เพิ่ม textAboutController
                ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              PaymentOptions(
                onOnlinePayment: _handleOnlinePayment,
                onQRCodePayment: _handleQRCodePayment,
                onCashOnDelivery: _handleCashOnDelivery,
              ),
              const SizedBox(height: 20),
              AccountBank(), // เพิ่ม AccountBank widget ที่นี่
              const SizedBox(height: 20),
              ProductPreview(cartItems: cartProvider.cartItems),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _placeOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 0, 255),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'ดำเนินการสั่งซื้อ',
                      style: TextStyle(
                        fontSize: screenWidth *
                            0.045, // ปรับขนาดตัวอักษรตามขนาดหน้าจอ
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
