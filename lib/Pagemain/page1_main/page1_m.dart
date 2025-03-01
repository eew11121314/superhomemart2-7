import 'dart:async'; //ไอคอนตะกร้า
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'productdetails1_m.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:superhomemart2/Pageguest/page2/productbrand_Pageguest/decakila.dart';
import 'package:superhomemart2/Pageguest/page2/productbrand_Pageguest/jadever.dart';
import 'package:superhomemart2/Pageguest/page2/productbrand_Pageguest/total.dart';
import 'package:superhomemart2/Pageguest/page2/productbrand_Pageguest/ricota.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:superhomemart2/Pagemain/page1_main/icons/icon_cart.dart';
import 'package:superhomemart2/Pagemain/page1_main/icons/icon_menu.dart';
import 'package:superhomemart2/Pagemain/page1_main/icons/icon_ProfileButton.dart';
// นำเข้า Page1BottomNavigationBar

class Page1M extends StatefulWidget {
  const Page1M({super.key});

  @override
  Page1MState createState() => Page1MState();
}

class Page1MState extends State<Page1M> {
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  bool _isSearching = false;
  bool _isLoading = true;
  List<dynamic> products = []; // รายการผลิตภัณฑ์ทั้งหมด
  List<dynamic> displayedProducts = []; // รายการผลิตภัณฑ์ที่แสดง
  String searchQuery = ""; // คำค้นหาที่ผู้ใช้พิมพ์
  double _lastHeight = 0;
  bool isValidUrl(String url) {
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }

  void _searchProducts(String query) {
    if (query.isEmpty) {
      setState(() {
        displayedProducts =
            List.from(products); // แสดงผลิตภัณฑ์ทั้งหมดถ้าไม่มีการค้นหา
      });
    } else {
      setState(() {
        displayedProducts = products.where((product) {
          return product["name"].toLowerCase().contains(query.toLowerCase());
        }).toList(); // กรองผลิตภัณฑ์ตามคำค้น
      });
    }
  }

  // ตัวแปรสำหรับความสูงสูงสุดและความสูงปัจจุบัน
  final double _maxHeight = 20000;
  double _currentHeight = 1450;

  Future<void> fetchUsers() async {
    const String url = "http://superhomemart.duckdns.org/product";
    const String apiKey = "WHt)m6gpqxkF1r(oDczv8mq%";

    // ตรวจสอบสถานะการเชื่อมต่อ
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _isLoading = false; // ปิดการโหลด
      });
      return; // ออกจากฟังก์ชันถ้าออฟไลน์
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'x-api-key': apiKey},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // กรองข้อมูลที่มีสถานะเป็น 'on'
        setState(() {
          products =
              jsonData.where((product) => product["status"] == "on").toList();
          _isLoading = false;
        });

        for (var product in products) {
          await Future.delayed(const Duration(milliseconds: 50));
          setState(() {
            displayedProducts.add(product);
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _loadMoreProducts() {
    if (!_isLoading && displayedProducts.length < products.length) {
      setState(() {
        _isLoading = true;
      });

      double height = _scrollController.position.pixels;
      if (height - _lastHeight >= 100) {
        _lastHeight = height;

        // เพิ่มความสูงทีละ 1450 จนกว่าจะถึงความสูงสูงสุด
        if (_currentHeight < _maxHeight) {
          _currentHeight += 1450;
          if (_currentHeight > _maxHeight) {
            _currentHeight = _maxHeight; // ป้องกันไม่ให้เกิน
          }
        }

        // ดีเลย์ 0.4 วินาทีก่อนโหลดข้อมูลใหม่
        Future.delayed(const Duration(milliseconds: 400), () {
          int nextProductCount = displayedProducts.length + 10;
          if (nextProductCount > products.length) {
            nextProductCount = products.length;
          }

          setState(() {
            displayedProducts.addAll(
                products.getRange(displayedProducts.length, nextProductCount));
          });

          setState(() {
            _isLoading = false;
          });
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  final List<String> _adImages = [
    'assets/10.10 Shopee.jpg',
    'assets/LAZADA 10.10 KOSANALAND.jpg',
    'assets/LAZADA 10.10 SUPER.jpg',
  ];

  @override
  void initState() {
    super.initState();

    // ใช้ addPostFrameCallback เพื่อหลีกเลี่ยงปัญหาการเปลี่ยนแปลงระหว่างการ build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ดึงข้อมูลจาก SharedPreferences เมื่อเริ่มต้น
      _checkLoginStatus();
      fetchUsers();
    });

    // โค้ดที่เหลือของคุณ
    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _adImages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreProducts();
      }
    });
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username'); // ดึง username ที่บันทึกไว้

    if (username != null) {
      // เชื่อมต่อกับ API เพื่อยืนยันว่า username นี้มีข้อมูลอยู่หรือไม่
      final response = await http.get(
        Uri.parse('https://superhomemart.duckdns.org/api/user/member/app?'),
      );

      if (response.statusCode == 200) {
        // ถ้า API ตอบกลับสำเร็จ
        var data = json.decode(response.body);

        // ตัวอย่างการใช้ข้อมูลจาก API
        if (data['status'] == 'success') {
          // ถ้า username ถูกต้อง
          print("User $username is already logged in");
        } else {
          // ถ้า username ไม่ถูกต้อง
          print("No such user found in the system.");
        }
      } else {
        // ถ้าการเชื่อมต่อ API ล้มเหลว
        print(
            "Failed to connect to the API. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } else {
      // ผู้ใช้ยังไม่ได้ล็อกอิน
      print("No user logged in.");
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _navigateToProductDetails(BuildContext context, var product) {
    String name = product["name"] ?? "No name available";
    String image = product["photo"] ?? "default.jpg";
    double price = (product["price"] is int)
        ? (product["price"] as int).toDouble()
        : product["price"] ?? 0.0;
    String sku = product["sku"] ?? "N/A";
    // String id = product["id"] ?? "N/A";

    // เพิ่มข้อมูลที่ต้องการ
    String description = product["description"] ?? "No description available";
    String category = product["category"] ?? "No category available";
    int stock = product["stock"] ?? 0;

    // เช็คค่า null สำหรับรูปภาพ
    String photo_1 = product["photo_1"] ?? "default.jpg";
    String photo_2 = product["photo_2"] ?? "default.jpg";
    String photo_3 = product["photo_3"] ?? "default.jpg";
    String photo_4 = product["photo_4"] ?? "default.jpg";
    String photo_5 = product["photo_5"] ?? "default.jpg";
    String photo_6 = product["photo_6"] ?? "default.jpg";

    // เพิ่มข้อมูลใหม่
    double shWeight = (product["sh_weight"] is int)
        ? (product["sh_weight"] as int).toDouble()
        : (product["sh_weight"] is String)
            ? double.tryParse(product["sh_weight"]) ?? 0.0
            : product["sh_weight"] ?? 0.0;

    double shLength = (product["sh_length"] is int)
        ? (product["sh_length"] as int).toDouble()
        : (product["sh_length"] is String)
            ? double.tryParse(product["sh_length"]) ?? 0.0
            : product["sh_length"] ?? 0.0;

    double shWidth = (product["sh_width"] is int)
        ? (product["sh_width"] as int).toDouble()
        : (product["sh_width"] is String)
            ? double.tryParse(product["sh_width"]) ?? 0.0
            : product["sh_width"] ?? 0.0;

    double shHeight = (product["sh_height"] is int)
        ? (product["sh_height"] as int).toDouble()
        : (product["sh_height"] is String)
            ? double.tryParse(product["sh_height"]) ?? 0.0
            : product["sh_height"] ?? 0.0;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsM(
          name: name,
          image: image,
          price: price,
          sku: sku,
          // id: id,
          description: description, // เพิ่มข้อมูล description
          category: category, // เพิ่มข้อมูล category
          stock: stock, // เพิ่มข้อมูล stock
          photo_1: photo_1,
          photo_2: photo_2,
          photo_3: photo_3,
          photo_4: photo_4,
          photo_5: photo_5,
          photo_6: photo_6,
          sh_weight: shWeight, // เพิ่มข้อมูล sh_weight
          sh_length: shLength, // เพิ่มข้อมูล sh_length
          sh_width: shWidth, // เพิ่มข้อมูล sh_width
          sh_height: shHeight, // เพิ่มข้อมูล sh_height
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // นำปุ่มย้อนกลับอัตโนมัติออก
        centerTitle: true,
        title: _isSearching
            ? GestureDetector(
                onTap: () {
                  // เมื่อกดที่ช่องค้นหา จะไม่ทำอะไร
                },
                child: Column(
                  children: [
                    TextField(
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'ค้นหาสินค้า...',
                        border: InputBorder.none,
                        hintStyle:
                            TextStyle(color: Colors.black, fontFamily: 'Kanit'),
                      ),
                      style: const TextStyle(
                          color: Colors.black, fontFamily: 'Kanit'),
                      cursorColor: Colors.black,
                      onChanged: (value) {
                        _searchProducts(
                            value); // เรียกใช้ฟังก์ชันค้นหาเมื่อมีการพิมพ์
                        setState(() {
                          searchQuery = value; // อัปเดตคำค้น
                        });
                      },
                    ),
                    // แสดงคำแนะนำด้านล่างช่องค้นหา
                    if (searchQuery.isNotEmpty)
                      Container(
                        color: Colors.white,
                        child: const Column(),
                      ),
                  ],
                ),
              )
            : GestureDetector(
                onTap: () {
                  setState(() {
                    _isSearching = true; // เปิดโหมดค้นหาเมื่อกดที่ช่องค้นหา
                  });
                },
                child: const Text(
                  'ค้นหาสินค้า',
                  style: TextStyle(color: Colors.grey, fontFamily: 'Kanit'),
                ),
              ),
        actions: [
          if (_isSearching)
            IconButton(
              icon: SvgPicture.asset('assets/Icon/x.svg',
                  width: 24, height: 24), // ใช้ SVG แทนไอคอน
              onPressed: () {
                setState(() {
                  _isSearching = false; // ปิดโหมดค้นหา
                  searchQuery = ""; // ล้างคำค้น
                  displayedProducts = List.from(products);
                });
              },
            ),
          const ProfileIconButton(), // วาง Icon โปรไฟล์ที่ขวาสุด
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 5,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _adImages
                          .where((image) => image.isNotEmpty)
                          .length, // กรองภาพที่ไม่ว่างเปล่า
                      itemBuilder: (context, index) {
                        String image = _adImages
                            .where((image) => image.isNotEmpty)
                            .toList()[index]; // ใช้ภาพที่ไม่ว่างเปล่า
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                _isLoading
                    ? Container()
                    : Container(
                        height: 100,
                        padding: const EdgeInsets.all(8.0),
                        child: displayedProducts.isEmpty ||
                                displayedProducts[0]["name"] == "ไม่พบข้อมูล"
                            ? const Center(
                                child: Text(
                                  "ไม่พบข้อมูล",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing:
                                      MediaQuery.of(context).size.width * 0.016,
                                  mainAxisSpacing:
                                      MediaQuery.of(context).size.width * 0.016,
                                ),
                                itemCount: displayedProducts.length,
                                itemBuilder: (context, index) {
                                  final product = displayedProducts[index];
                                  String imageAsset = [
                                    'http://superhomemart.duckdns.org/upload/DECAKILA@2x.png',
                                    'http://superhomemart.duckdns.org/upload/JADEVER@2x.png',
                                    'http://superhomemart.duckdns.org/upload/TOTAL@2x.png',
                                    'http://superhomemart.duckdns.org/upload/RICOTA_O.png'
                                  ][index % 4];

                                  return InkWell(
                                    onTap: () {
                                      // นำทางไปยังหน้าที่เหมาะสมตาม URL ของภาพ
                                      switch (imageAsset) {
                                        case 'http://superhomemart.duckdns.org/upload/DECAKILA@2x.png':
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const DecakilaCategoryPage()),
                                          );
                                          break;
                                        case 'http://superhomemart.duckdns.org/upload/JADEVER@2x.png':
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const JadeverCategoryPage()),
                                          );
                                          break;
                                        case 'http://superhomemart.duckdns.org/upload/TOTAL@2x.png':
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const TotalCategoryPage()),
                                          );
                                          break;
                                        case 'http://superhomemart.duckdns.org/upload/RICOTA_O.png':
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const RicotaCategoryPage()),
                                          );
                                          break;
                                        default:
                                          print(
                                              'Unknown image asset: $imageAsset');
                                          break;
                                      }
                                    },
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.23,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.network(
                                            imageAsset,
                                            height: 50,
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            product["brand"] ?? '',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Kanit'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                Container(
                  height: _currentHeight,
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing:
                          MediaQuery.of(context).size.width * 0.02,
                      mainAxisSpacing: MediaQuery.of(context).size.width * 0.02,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 1.5),
                    ),
                    itemCount: displayedProducts.length,
                    itemBuilder: (context, index) {
                      final product = displayedProducts[index];
                      return InkWell(
                        onTap: () {
                          _navigateToProductDetails(context, product);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Image.network(
                                  "http://superhomemart.duckdns.org:80/upload/${product["photo"]}.jpg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                product["name"],
                                style: const TextStyle(
                                    fontSize: 14, fontFamily: 'Kanit'),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${product["price"]}฿',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Kanit',
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          // เพิ่ม DraggableCartIcon ที่มุมขวาล่าง
          const DraggableCartIcon(),
          const MenuIcon(),
          //TabBarWidget(),

          //HomeScreen()
        ],
      ),
    );
  }
}
