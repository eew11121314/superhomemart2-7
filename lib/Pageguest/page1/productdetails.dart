import 'package:flutter/material.dart';
import 'package:superhomemart2/login.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductDetails extends StatefulWidget {
  final String name;
  final String image;
  final double price;
  final String sku;
  final String description;
  final String category;
  final int stock;
  final String photo_1;
  final String photo_2;
  final String photo_3;
  final String photo_4;
  final String photo_5;
  final String photo_6;
  final double sh_weight;
  final double sh_length;
  final double sh_width;
  final double sh_height;

  const ProductDetails({
    super.key,
    required this.name,
    required this.image,
    required this.price,
    required this.sku,
    required this.description,
    required this.category,
    required this.stock,
    required this.photo_1,
    required this.photo_2,
    required this.photo_3,
    required this.photo_4,
    required this.photo_5,
    required this.photo_6,
    required this.sh_weight,
    required this.sh_length,
    required this.sh_width,
    required this.sh_height,
  });

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

const double imageSize = 60;
final BoxDecoration imageDecoration = BoxDecoration(
  border: Border.all(color: Colors.grey, width: 1),
  borderRadius: BorderRadius.circular(8),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withAlpha((0.5 * 255).toInt()),
      spreadRadius: 1,
      blurRadius: 5,
      offset: const Offset(0, 2),
    ),
  ],
);

class _ProductDetailsState extends State<ProductDetails> {
  bool _isDetailsVisible = false;
  bool _isSpecificationsVisible = false;
  late PageController _pageController;
  int currentPage = 0;
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleOrder(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    const String defaultImageUrl =
        "http://superhomemart.duckdns.org/upload/PreloaderProduct.jpg";

    List<String?> photos = [
      widget.image.isNotEmpty ? widget.image : defaultImageUrl,
      widget.photo_1.isNotEmpty ? widget.photo_1 : defaultImageUrl,
      widget.photo_2.isNotEmpty ? widget.photo_2 : defaultImageUrl,
      widget.photo_3.isNotEmpty ? widget.photo_3 : defaultImageUrl,
      widget.photo_4.isNotEmpty ? widget.photo_4 : defaultImageUrl,
      widget.photo_5.isNotEmpty ? widget.photo_5 : defaultImageUrl,
      widget.photo_6.isNotEmpty ? widget.photo_6 : defaultImageUrl,
    ];

    // ตรวจสอบว่ามีรูปที่ไม่เป็น null หรือไม่
    bool hasValidPhotos = photos.any((photo) => photo != null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('รายละเอียดสินค้า',
            style: TextStyle(fontFamily: 'Kanit')),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/Icon/left.svg',
            width: 30,
            height: 30,
            color: Colors.white,
          ), // ใช้ SVG แทนไอคอน
          onPressed: () {
            Navigator.pop(context); // ย้อนกลับไปหน้าก่อนหน้า
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (hasValidPhotos)
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha((0.5 * 255).toInt()),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 400,
                          child: PageView.builder(
                            controller: _pageController,
                            physics: const BouncingScrollPhysics(),
                            onPageChanged: (index) {
                              setState(() {
                                currentPage = index;
                              });
                            },
                            itemCount: photos.length,
                            itemBuilder: (context, index) {
                              if (index >= photos.length) {
                                return Container();
                              }

                              String? photoUrl = photos[index];

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FullScreenImageViewer(
                                        photos: photos,
                                        initialIndex: index,
                                      ),
                                    ),
                                  );
                                },
                                child: Image.network(
                                  "http://superhomemart.duckdns.org:80/upload/$photoUrl.jpg",
                                  width: double.infinity,
                                  height: 400,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.network(
                                      defaultImageUrl,
                                      width: double.infinity,
                                      height: 400,
                                      fit: BoxFit.contain,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            photos.length,
                            (dotIndex) => GestureDetector(
                              onTap: () {
                                _pageController.jumpToPage(dotIndex);
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                width: 12.0,
                                height: 12.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: currentPage == dotIndex
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Visibility(
                            visible: widget.photo_1.isNotEmpty,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = 1;
                                  _pageController.jumpToPage(1);
                                });
                              },
                              child: Container(
                                decoration: imageDecoration.copyWith(
                                  border: Border.all(
                                    color: selectedIndex == 1
                                        ? Colors.blue
                                        : Colors.grey,
                                    width: 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    "http://superhomemart.duckdns.org:80/upload/${widget.photo_1}.jpg",
                                    width: imageSize,
                                    height: imageSize,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.network(
                                        defaultImageUrl,
                                        width: imageSize,
                                        height: imageSize,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Visibility(
                            visible: widget.photo_2.isNotEmpty,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = 2;
                                  _pageController.jumpToPage(2);
                                });
                              },
                              child: Container(
                                decoration: imageDecoration.copyWith(
                                  border: Border.all(
                                    color: selectedIndex == 2
                                        ? Colors.blue
                                        : Colors.grey,
                                    width: 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    "http://superhomemart.duckdns.org:80/upload/${widget.photo_2}.jpg",
                                    width: imageSize,
                                    height: imageSize,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.network(
                                        defaultImageUrl,
                                        width: imageSize,
                                        height: imageSize,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Visibility(
                            visible: widget.photo_3.isNotEmpty,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = 3;
                                  _pageController.jumpToPage(3);
                                });
                              },
                              child: Container(
                                decoration: imageDecoration.copyWith(
                                  border: Border.all(
                                    color: selectedIndex == 3
                                        ? Colors.blue
                                        : Colors.grey,
                                    width: 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    "http://superhomemart.duckdns.org:80/upload/${widget.photo_3}.jpg",
                                    width: imageSize,
                                    height: imageSize,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.network(
                                        defaultImageUrl,
                                        width: imageSize,
                                        height: imageSize,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Visibility(
                            visible: widget.photo_4.isNotEmpty,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = 4;
                                  _pageController.jumpToPage(4);
                                });
                              },
                              child: Container(
                                decoration: imageDecoration.copyWith(
                                  border: Border.all(
                                    color: selectedIndex == 4
                                        ? Colors.blue
                                        : Colors.grey,
                                    width: 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    "http://superhomemart.duckdns.org:80/upload/${widget.photo_4}.jpg",
                                    width: imageSize,
                                    height: imageSize,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.network(
                                        defaultImageUrl,
                                        width: imageSize,
                                        height: imageSize,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Visibility(
                            visible: widget.photo_5.isNotEmpty,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = 5;
                                  _pageController.jumpToPage(5);
                                });
                              },
                              child: Container(
                                decoration: imageDecoration.copyWith(
                                  border: Border.all(
                                    color: selectedIndex == 5
                                        ? Colors.blue
                                        : Colors.grey,
                                    width: 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    "http://superhomemart.duckdns.org:80/upload/${widget.photo_5}.jpg",
                                    width: imageSize,
                                    height: imageSize,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.network(
                                        defaultImageUrl,
                                        width: imageSize,
                                        height: imageSize,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Visibility(
                            visible: widget.photo_6.isNotEmpty,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = 6;
                                  _pageController.jumpToPage(6);
                                });
                              },
                              child: Container(
                                decoration: imageDecoration.copyWith(
                                  border: Border.all(
                                    color: selectedIndex == 6
                                        ? Colors.blue
                                        : Colors.grey,
                                    width: 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    "http://superhomemart.duckdns.org:80/upload/${widget.photo_6}.jpg",
                                    width: imageSize,
                                    height: imageSize,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.network(
                                        defaultImageUrl,
                                        width: imageSize,
                                        height: imageSize,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Kanit',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  '${widget.price} ฿',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontFamily: 'Kanit',
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isDetailsVisible = !_isDetailsVisible;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    color: const Color.fromARGB(255, 78, 84, 94),
                    child: const Text(
                      'รายละเอียดสินค้า',
                      style:
                          TextStyle(color: Colors.white, fontFamily: 'Kanit'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Visibility(
                  visible: _isDetailsVisible,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.withAlpha((0.2 * 255).toInt()),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.description,
                      style: const TextStyle(fontSize: 14, fontFamily: 'Kanit'),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isSpecificationsVisible = !_isSpecificationsVisible;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    color: const Color.fromARGB(255, 78, 84, 94),
                    child: const Text(
                      'ขนาดสินค้า',
                      style:
                          TextStyle(color: Colors.white, fontFamily: 'Kanit'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Visibility(
                  visible: _isSpecificationsVisible,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.withAlpha((0.2 * 255).toInt()),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...[
                          'น้ำหนัก: ${widget.sh_weight} kg',
                          'ยาว: ${widget.sh_length} cm',
                          'กว้าง: ${widget.sh_width} cm',
                          'สูง: ${widget.sh_height} cm',
                        ].map((spec) => Text(
                              spec,
                              style: const TextStyle(fontFamily: 'Kanit'),
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 50,
                padding: const EdgeInsets.symmetric(vertical: 0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 37, 60, 99),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: TextButton(
                  onPressed: () => _handleOrder(context),
                  child: const Text(
                    'สั่งซื้อสินค้า',
                    style: TextStyle(fontFamily: 'Kanit', color: Colors.white),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class FullScreenImageViewer extends StatefulWidget {
  final List<String?> photos;
  final int initialIndex;

  const FullScreenImageViewer({
    super.key,
    required this.photos,
    required this.initialIndex,
  });

  @override
  _FullScreenImageViewerState createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late PageController pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.initialIndex);
    currentPage = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    // กรองรายการรูปภาพที่เป็น null หรือช่องว่าง
    List<String?> validPhotos = widget.photos
        .where((photo) => photo != null && photo.isNotEmpty)
        .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/Icon/arrow.svg', // ใช้ SVG แทนไอคอน
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          PageView.builder(
            itemCount: validPhotos.length,
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Center(
                child: validPhotos[index] != null
                    ? Image.network(
                        "http://superhomemart.duckdns.org:80/upload/${validPhotos[index]}.jpg",
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.network(
                            "http://superhomemart.duckdns.org/upload/PreloaderProduct.jpg",
                            fit: BoxFit.contain,
                          );
                        },
                      )
                    : Container(),
              );
            },
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                validPhotos.length,
                (dotIndex) => GestureDetector(
                  onTap: () {
                    pageController.jumpToPage(dotIndex);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: 12.0,
                    height: 12.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          currentPage == dotIndex ? Colors.blue : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
