import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'productdetails1_m.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:superhomemart2/Pageguest/_page2/productbrand_guest/decakila_g.dart';
import 'package:superhomemart2/Pageguest/_page2/productbrand_guest/jadever_g.dart';
import 'package:superhomemart2/Pageguest/_page2/productbrand_guest/total_g.dart';
import 'package:superhomemart2/Pageguest/_page2/productbrand_guest/ricota_g.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:superhomemart2/Pagemain/_page1_main/icons/icon_cart.dart';
import 'package:superhomemart2/Pagemain/_page1_main/icons/icon_menu.dart';
import 'package:superhomemart2/Pagemain/_page1_main/icons/icon_slips.dart';
import 'package:superhomemart2/Pagemain/_page1_main/icons/icon_ProfileButton.dart';
// นำเข้า Page1BottomNavigationBar
import '../../search_widget.dart'; // Import the search widget
import 'package:shimmer/shimmer.dart';

class Page1M extends StatefulWidget {
  const Page1M({super.key});

  @override
  Page1MState createState() => Page1MState();
}

class Page1MState extends State<Page1M> {
  Timer? _timer;

  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  bool _isSearching = false;
  bool _isLoading = true;
  List<dynamic> products = []; // รายการผลิตภัณฑ์ทั้งหมด
  List<dynamic> displayedProducts = []; // รายการผลิตภัณฑ์ที่แสดง
  String searchQuery = ""; // คำค้นหาที่ผู้ใช้พิมพ์
  int _currentPageIndex = 0;
  final int _itemsPerPage = 20;
  final double _currentHeight = 2870;

  void _searchProducts(String query) {
    if (query.isEmpty) {
      setState(() {
        displayedProducts =
            List.from(products); // แสดงผลิตภัณฑ์ทั้งหมดถ้าไม่มีการค้นหา
      });
    } else {
      setState(() {
        displayedProducts = products.where((product) {
          final productName = product["name"]?.toLowerCase() ?? '';
          return productName.contains(query.toLowerCase());
        }).toList(); // กรองผลิตภัณฑ์ตามคำค้น

        if (displayedProducts.isEmpty) {
          displayedProducts = [
            {"name": "ไม่พบข้อมูลสินค้า"}
          ];
        }
      });
    }
  }

  void fetchUsers() async {
    const String url = "http://superhomemart.duckdns.org/product";
    const String apiKey = "WHt)m6gpqxkF1r(oDczv8mq%";

    // ตรวจสอบสถานะการเชื่อมต่อ
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      if (mounted) {
        setState(() {
          _isLoading = false; // ปิดการโหลด
        });
      }
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
        if (mounted) {
          setState(() {
            products =
                jsonData.where((product) => product["status"] == "on").toList();
            _isLoading = false;
          });
        }

        for (var product in products) {
          await Future.delayed(const Duration(milliseconds: 50));
          if (mounted) {
            setState(() {
              displayedProducts.add(product);
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _loadMoreProducts() {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      Future.delayed(const Duration(milliseconds: 400), () {
        int startIndex = _currentPageIndex * _itemsPerPage;
        int endIndex = startIndex + _itemsPerPage;
        if (endIndex > products.length) {
          endIndex = products.length;
        }

        setState(() {
          displayedProducts = products.getRange(startIndex, endIndex).toList();
          _isLoading = false;
        });
      });
    }
  }

  void _changePage(int pageIndex) {
    setState(() {
      _currentPageIndex = pageIndex;
      _loadMoreProducts();
    });
  }

  Widget _buildPaginationControls() {
    int totalPages = (products.length / _itemsPerPage).ceil();
    int startPage = _currentPageIndex - 2 < 0 ? 0 : _currentPageIndex - 2;
    int endPage = startPage + 4 > totalPages ? totalPages : startPage + 4;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_currentPageIndex > 0)
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => _changePage(_currentPageIndex - 1),
          ),
        ...List.generate(
          endPage - startPage,
          (index) {
            int pageIndex = startPage + index;
            return GestureDetector(
              onTap: () => _changePage(pageIndex),
              child: Container(
                margin: const EdgeInsets.all(4.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: _currentPageIndex == pageIndex
                      ? Colors.blue
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  '${pageIndex + 1}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        ),
        if (_currentPageIndex < totalPages - 1)
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => _changePage(_currentPageIndex + 1),
          ),
      ],
    );
  }

  final List<String> _adImages = [
    'assets/10.10 Shopee.jpg',
    'assets/LAZADA 10.10 KOSANALAND.jpg',
    'assets/LAZADA 10.10 SUPER.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _adImages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (mounted) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
    fetchUsers(); // เรียกใช้ fetchUsers โดยไม่ต้องใช้ผลลัพธ์
    _loadMoreProducts(); // เรียกใช้ _loadMoreProducts หลังจาก fetchUsers
  }

  @override
  void dispose() {
    _timer?.cancel();
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
    String description = product["description"] ?? "No description available";
    String category = product["category"] ?? "No category available";
    int stock = product["stock"] ?? 0;

    // เช็คค่า null สำหรับรูปภาพและตั้งค่าเป็นสตริงว่างถ้าเป็น null
    String photo_1 =
        product["photo_1"]?.isNotEmpty == true ? product["photo_1"] : '';
    String photo_2 =
        product["photo_2"]?.isNotEmpty == true ? product["photo_2"] : '';
    String photo_3 =
        product["photo_3"]?.isNotEmpty == true ? product["photo_3"] : '';
    String photo_4 =
        product["photo_4"]?.isNotEmpty == true ? product["photo_4"] : '';
    String photo_5 =
        product["photo_5"]?.isNotEmpty == true ? product["photo_5"] : '';
    String photo_6 =
        product["photo_6"]?.isNotEmpty == true ? product["photo_6"] : '';

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
          description: description,
          category: category,
          stock: stock,
          photo_1: photo_1,
          photo_2: photo_2,
          photo_3: photo_3,
          photo_4: photo_4,
          photo_5: photo_5,
          photo_6: photo_6,
          sh_weight: shWeight,
          sh_length: shLength,
          sh_width: shWidth,
          sh_height: shHeight,
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
            ? SearchWidget(
                onSearch: (value) {
                  _searchProducts(
                      value); // เรียกใช้ฟังก์ชันค้นหาเมื่อมีการพิมพ์
                  setState(() {
                    searchQuery = value; // อัปเดตคำค้น
                  });
                },
                onCancel: () {
                  setState(() {
                    _isSearching = false; // ปิดโหมดค้นหา
                    searchQuery = ""; // ล้างคำค้น
                    displayedProducts = List.from(products);
                  });
                },
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
                      itemCount: _adImages.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(_adImages[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                _isLoading
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: 6, // จำนวนช่องโครงร่างที่ต้องการแสดง
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            );
                          },
                        ),
                      )
                    : displayedProducts.isEmpty ||
                            displayedProducts[0]["name"] == "ไม่พบข้อมูลสินค้า"
                        ? const Center(
                            child: Text(
                              "ไม่พบข้อมูลสินค้า",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          )
                        : Column(
                            children: [
                              Container(
                                height: 100,
                                padding: const EdgeInsets.all(8.0),
                                child: GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    crossAxisSpacing:
                                        MediaQuery.of(context).size.width *
                                            0.016,
                                    mainAxisSpacing:
                                        MediaQuery.of(context).size.width *
                                            0.016,
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
                                            // Use a logging framework instead of print
                                            debugPrint(
                                                'Unknown image asset: $imageAsset');
                                            break;
                                        }
                                      },
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 8.0,
                                    mainAxisSpacing: 8.0,
                                    childAspectRatio: 0.7,
                                  ),
                                  itemCount: displayedProducts.length,
                                  itemBuilder: (context, index) {
                                    final product = displayedProducts[index];
                                    return InkWell(
                                      onTap: () {
                                        _navigateToProductDetails(
                                            context, product);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                  fontSize: 14,
                                                  fontFamily: 'Kanit'),
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
                // Improved Pagination controls
                _buildPaginationControls(),
              ],
            ),
          ),
          // if (_isLoading)
          //   const Center(
          //     child: CircularProgressIndicator(),
          //   ),
          // เพิ่ม DraggableCartIcon ที่มุมขวาล่าง
          const DraggableCartIcon(),
          const MenuIcon(),
          const SlipsIcon(),
          //TabBarWidget(),

          //HomeScreen()
        ],
      ),
    );
  }
}
