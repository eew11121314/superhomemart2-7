import 'package:flutter/material.dart';
import 'package:superhomemart2/Pageguest/page1/Page1.dart';
import 'package:superhomemart2/Pageguest/page2/Page2.dart';
import 'package:superhomemart2/Pageguest/page3/Page3.dart';
import 'package:superhomemart2/Login.dart';
import 'package:superhomemart2/Pageguest/page4/login_hide.dart';
import 'package:superhomemart2/Pageguest/page1/delivery.dart';
import 'package:provider/provider.dart';
import 'package:superhomemart2/Pagemain/order_main/cart_provider_m.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:io';
import 'package:superhomemart2/Pageguest/widgets_page1/page1_bar.dart'; // นำเข้า CustomBottomNavigationBar
import 'package:shared_preferences/shared_preferences.dart'; // นำเข้า SharedPreferences

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
    return prefs.getBool('isLoggedIn') ?? false;
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
                ? const Page1() // ใช้ Page1 เป็น class เดียว
                : const HomeScreenGuest(), // เริ่มที่ Page1 เสมอ
            routes: {
              '/login': (context) => const LoginPage(),
              '/delivery': (context) => const DeliveryPage(
                    productName: '',
                  ),
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
    const LoginP4(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
