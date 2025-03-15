import 'package:flutter/material.dart';
import 'package:superhomemart2/Pageguest/_page1/Page1.dart';
import 'package:superhomemart2/Pageguest/_page2/Page2.dart';
import 'package:superhomemart2/Pageguest/_page3/Page3.dart';
import 'package:superhomemart2/login&register/login.dart'; // ตรวจสอบการนำเข้า LoginPage
import 'package:superhomemart2/Pageguest/_page1/delivery.dart';
import 'package:provider/provider.dart';
import 'package:superhomemart2/Pagemain/order_main/cart/cart_provider_m.dart';
import 'package:superhomemart2/Pagemain/order_main/order1_m.dart'; // นำเข้า OrderPageM
import 'package:window_manager/window_manager.dart';
import 'dart:io';
import 'package:superhomemart2/Pageguest/widgets_page1/page1_bar.dart'; // นำเข้า CustomBottomNavigationBar
import 'package:shared_preferences/shared_preferences.dart'; // นำเข้า SharedPreferences
import 'package:logger/logger.dart'; // นำเข้าแพ็กเกจ logger

final logger = Logger(); // สร้าง instance ของ Logger

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    await windowManager.ensureInitialized();
    await windowManager.setSize(const Size(428, 926));
    await windowManager.setMinimumSize(const Size(428, 926));
    await windowManager.setMaximumSize(const Size(428, 926));
    await windowManager.setResizable(false);
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final username = prefs.getString('username');
    if (isLoggedIn && username != null) {
      logger.i('Current logged in user: $username'); // แสดง log ใน terminal
    }
    return isLoggedIn;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          final bool isLoggedIn = snapshot.data ?? false;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Kanit', // กำหนดฟอนต์เริ่มต้นที่นี่
            ),
            home: isLoggedIn
                ? const HomeScreenGuest() // ใช้ HomeScreenGuest เป็น class เดียว
                : const HomeScreenGuest(), // เริ่มที่ HomeScreenGuest เสมอ
            routes: {
              '/login': (context) => const LoginPage(),
              '/delivery': (context) => const DeliveryPage(
                    productName: '',
                  ),
              '/order': (context) =>
                  const OrderPageM(), // เพิ่มเส้นทางสำหรับ OrderPageM
            },
          );
        }
      },
    );
  }
}

class HomeScreenGuest extends StatefulWidget {
  const HomeScreenGuest({super.key});

  @override
  HomeScreenGuestState createState() => HomeScreenGuestState();
}

class HomeScreenGuestState extends State<HomeScreenGuest> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Page1(),
    const Page2(),
    const Page3(),
    const LoginPage(showBackButton: false), //LoginButtonPage
  ];

  @override
  void initState() {
    super.initState();
    // กำหนดสถานะเริ่มต้นที่นี่
    _currentIndex = 0;
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        iconSize: screenWidth * 0.07, // ปรับขนาดไอคอนตามขนาดหน้าจอ
      ),
    );
  }
}
