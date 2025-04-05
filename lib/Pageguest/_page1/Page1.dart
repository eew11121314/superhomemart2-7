import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'productdetails.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:superhomemart2/Pageguest/_page2/productbrand_guest/decakila_g.dart';
// import 'package:superhomemart2/Pageguest/_page2/productbrand_guest/jadever_g.dart';
// import 'package:superhomemart2/Pageguest/_page2/productbrand_guest/total_g.dart';
// import 'package:superhomemart2/Pageguest/_page2/productbrand_guest/ricota_g.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../search_widget.dart'; // Import the search widget
import 'package:shimmer/shimmer.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
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

  // ตัวแปรสำหรับความสูงสูงสุดและความสูงปัจจุบัน

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
    setState(() {
      _isLoading = true; // ตั้งค่าสถานะการโหลดเป็น true
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      List<dynamic> sourceList = searchQuery.isEmpty
          ? products // ถ้าไม่มีคำค้นหา ให้ใช้สินค้าทั้งหมด
          : products.where((product) {
              final productName = product["name"]?.toLowerCase() ?? '';
              return productName.contains(searchQuery.toLowerCase());
            }).toList(); // กรองสินค้าตามคำค้นหา

      int startIndex = _currentPageIndex * _itemsPerPage;
      int endIndex = startIndex + _itemsPerPage;
      if (endIndex > sourceList.length) {
        endIndex = sourceList.length;
      }

      setState(() {
        displayedProducts = sourceList.getRange(startIndex, endIndex).toList();
        _isLoading = false; // ตั้งค่าสถานะการโหลดเป็น false หลังจากโหลดเสร็จ
      });
    });
  }

  void _changePage(int pageIndex) {
    setState(() {
      _currentPageIndex = pageIndex;
      _loadMoreProducts(); // โหลดสินค้าสำหรับหน้าปัจจุบัน
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
    'http://superhomemart.duckdns.org/EIWtest/picpro/picpro1.jpg',
    'http://superhomemart.duckdns.org/EIWtest/picpro/picpro2.jpg',
    'http://superhomemart.duckdns.org/EIWtest/picpro/picpro3.jpg',
    'http://superhomemart.duckdns.org/EIWtest/picpro/picpro4.jpg',
    'http://superhomemart.duckdns.org/EIWtest/picpro/picpro5.jpg',
    'http://superhomemart.duckdns.org/EIWtest/picpro/picpro6.jpg',
    'http://superhomemart.duckdns.org/EIWtest/picpro/picpro7.jpg',
    'http://superhomemart.duckdns.org/EIWtest/picpro/picpro8.jpg',
    'http://superhomemart.duckdns.org/EIWtest/picpro/picpro9.jpg',
    'http://superhomemart.duckdns.org/EIWtest/picpro/picpro10.jpg',
    'http://superhomemart.duckdns.org/EIWtest/picpro/picpro11.jpg',
    'http://superhomemart.duckdns.org/EIWtest/picpro/picpro12.jpg',
  ];

  Future<List<String>> filterValidImages(List<String> images) async {
    List<String> validImages = [];
    for (String imageUrl in images) {
      try {
        final response = await http.head(Uri.parse(imageUrl));
        if (response.statusCode == 200) {
          validImages.add(imageUrl); // เพิ่มเฉพาะรูปที่โหลดได้สำเร็จ
        }
      } catch (e) {
        debugPrint(
            'Error loading image: $imageUrl'); // แสดงข้อผิดพลาดใน debug console
      }
    }
    return validImages;
  }

  @override
  void initState() {
    super.initState();

    filterValidImages(_adImages).then((validImages) {
      setState(() {
        _adImages.clear();
        _adImages.addAll(validImages); // อัปเดต _adImages ด้วยรูปที่โหลดได้
      });
    });

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
    fetchUsers().then((_) {
      _loadMoreProducts();
    });

    // Remove the infinite scroll listener
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     _loadMoreProducts();
    //   }
    // });
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
        builder: (context) => ProductDetails(
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
          category_1: product["category_1"] ?? "No category available",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height *
            0.075), // ปรับความสูงของ AppBar
        child: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: _isSearching
              ? SearchWidget(
                  onSearch: (value) {
                    _searchProducts(value);
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  onCancel: () {
                    setState(() {
                      _isSearching = false;
                      searchQuery = "";
                      displayedProducts = List.from(products);
                    });
                  },
                )
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                  child: const Text(
                    'ค้นหาสินค้า',
                    style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(136, 0, 0, 0),
                        fontFamily: 'Kanit'),
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
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 239, 240, 244),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // ซ่อน PageView.builder หากไม่มีรูปภาพใน _adImages
                if (_adImages.isNotEmpty)
                  AspectRatio(
                    aspectRatio: 16 / 9, // รักษาสัดส่วน 16:9
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _adImages.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              image: DecorationImage(
                                image: NetworkImage(_adImages[index]),
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
                                      'http://superhomemart.duckdns.org/upload/KANTO@2x.png'
                                    ][index % 4];

                                    return InkWell(
                                      onTap: () {
                                        String query =
                                            ''; // ตัวแปรสำหรับเก็บข้อความค้นหา
                                        switch (imageAsset) {
                                          case 'http://superhomemart.duckdns.org/upload/DECAKILA@2x.png':
                                            query = 'DECAKILA';
                                            break;
                                          case 'http://superhomemart.duckdns.org/upload/JADEVER@2x.png':
                                            query = 'JADEVER';
                                            break;
                                          case 'http://superhomemart.duckdns.org/upload/TOTAL@2x.png':
                                            query = 'TOTAL';
                                            break;
                                          case 'http://superhomemart.duckdns.org/upload/KANTO@2x.png':
                                            query = 'KANTO';
                                            break;
                                          default:
                                            print(
                                                'Unknown image asset: $imageAsset');
                                            return;
                                        }

                                        // อัปเดตข้อความในช่องค้นหาและกรองสินค้า
                                        setState(() {
                                          searchQuery =
                                              query; // อัปเดตข้อความในช่องค้นหา
                                          _searchProducts(
                                              query); // เรียกฟังก์ชันค้นหา
                                          _isSearching = true; // เปิดโหมดค้นหา
                                        });
                                      },
                                      child: SizedBox(
                                        width: MediaQuery.of(context)
                                                .size
                                                .width *
                                            0.23, // ปรับขนาดตามความกว้างหน้าจอ
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.network(
                                              imageAsset,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05, // ปรับขนาดตามความสูงหน้าจอ
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
                                padding: const EdgeInsets.all(8.0),
                                child: GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: MediaQuery.of(context)
                                                .size
                                                .width >
                                            600
                                        ? 3
                                        : 2, // ปรับจำนวนคอลัมน์ตามความกว้างหน้าจอ
                                    crossAxisSpacing: 8.0,
                                    mainAxisSpacing: 8.0,
                                    childAspectRatio:
                                        MediaQuery.of(context).size.width > 600
                                            ? 0.8
                                            : 0.7, // ปรับสัดส่วนของ Grid
                                  ),
                                  itemCount: displayedProducts.length >
                                          _itemsPerPage
                                      ? _itemsPerPage
                                      : displayedProducts
                                          .length, // จำกัดจำนวนสินค้าที่แสดง
                                  itemBuilder: (context, index) {
                                    final product = displayedProducts[index];
                                    return InkWell(
                                      onTap: () {
                                        _navigateToProductDetails(
                                            context, product);
                                      },
                                      child: Container(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(8.0),
                                                  topRight:
                                                      Radius.circular(8.0),
                                                ),
                                                child: Image.network(
                                                  "http://superhomemart.duckdns.org:80/upload/${product["photo"]}.jpg",
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      product["name"],
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontFamily: 'Kanit',
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      '${product["price"]} THB',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontFamily: 'Kanit',
                                                        color: Color.fromARGB(
                                                            255, 223, 31, 31),
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
        ],
      ),
    );
  }
}
