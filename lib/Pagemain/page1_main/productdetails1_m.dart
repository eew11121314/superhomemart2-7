import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:superhomemart2/Pagemain/order_main/cart/cart_m.dart';
import 'package:provider/provider.dart';
import 'package:superhomemart2/Pagemain/order_main/cart/cart_provider_m.dart';
import 'package:superhomemart2/Pagemain//widgets_main/order_button.dart';

class ProductDetailsM extends StatefulWidget {
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

  const ProductDetailsM({
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
  _ProductDetailsMState createState() => _ProductDetailsMState();
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

class _ProductDetailsMState extends State<ProductDetailsM> {
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

  @override
  Widget build(BuildContext context) {
    const String defaultImageUrl =
        "http://superhomemart.duckdns.org/upload/PreloaderProduct.jpg";

    List<String?> photos = [
      widget.image.isNotEmpty ? widget.image : defaultImageUrl,
      widget.photo_1.isNotEmpty ? widget.photo_1 : null,
      widget.photo_2.isNotEmpty ? widget.photo_2 : null,
      widget.photo_3.isNotEmpty ? widget.photo_3 : null,
      widget.photo_4.isNotEmpty ? widget.photo_4 : null,
      widget.photo_5.isNotEmpty ? widget.photo_5 : null,
      widget.photo_6.isNotEmpty ? widget.photo_6 : null,
    ];

    // กรองรูปภาพที่ไม่เป็น null
    List<String?> validPhotos = photos.where((photo) => photo != null).toList();

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
                if (validPhotos.isNotEmpty)
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
                            itemCount: validPhotos.length,
                            itemBuilder: (context, index) {
                              String? photoUrl = validPhotos[index];

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FullScreenImageViewer(
                                        photos: validPhotos,
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
                        if (validPhotos.length > 1)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              validPhotos.length,
                              (dotIndex) => GestureDetector(
                                onTap: () {
                                  _pageController.jumpToPage(dotIndex);
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
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
                            child: ImageThumbnail(
                              photoUrl: widget.photo_1,
                              index: 1,
                              selectedIndex: selectedIndex,
                              pageController: _pageController,
                              imageSize: imageSize,
                              imageDecoration: imageDecoration,
                              defaultImageUrl: defaultImageUrl,
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
                            child: ImageThumbnail(
                              photoUrl: widget.photo_2,
                              index: 2,
                              selectedIndex: selectedIndex,
                              pageController: _pageController,
                              imageSize: imageSize,
                              imageDecoration: imageDecoration,
                              defaultImageUrl: defaultImageUrl,
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
                            child: ImageThumbnail(
                              photoUrl: widget.photo_3,
                              index: 3,
                              selectedIndex: selectedIndex,
                              pageController: _pageController,
                              imageSize: imageSize,
                              imageDecoration: imageDecoration,
                              defaultImageUrl: defaultImageUrl,
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
                            child: ImageThumbnail(
                              photoUrl: widget.photo_4,
                              index: 4,
                              selectedIndex: selectedIndex,
                              pageController: _pageController,
                              imageSize: imageSize,
                              imageDecoration: imageDecoration,
                              defaultImageUrl: defaultImageUrl,
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
                            child: ImageThumbnail(
                              photoUrl: widget.photo_5,
                              index: 5,
                              selectedIndex: selectedIndex,
                              pageController: _pageController,
                              imageSize: imageSize,
                              imageDecoration: imageDecoration,
                              defaultImageUrl: defaultImageUrl,
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
                            child: ImageThumbnail(
                              photoUrl: widget.photo_6,
                              index: 6,
                              selectedIndex: selectedIndex,
                              pageController: _pageController,
                              imageSize: imageSize,
                              imageDecoration: imageDecoration,
                              defaultImageUrl: defaultImageUrl,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: IconButton(
                icon: SvgPicture.asset(
                  'assets/Icon/shopping-cart.svg', //ตะกร้าดูรายการที่เลือก
                  width: 30,
                  height: 30,
                  color: Colors.blueAccent,
                ),
                onPressed: () {
                  final cartProvider =
                      Provider.of<CartProvider>(context, listen: false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CartScreen(cartItems: cartProvider.cartItems),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: OrderButton(
                productId: widget.sku,
                productName: widget.name,
                imageUrl: widget.image,
                price: widget.price,
              ),
            ),
          ],
        ),
      ),
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

class ImageThumbnail extends StatelessWidget {
  final String? photoUrl;
  final int index;
  final int selectedIndex;
  final PageController pageController;
  final double imageSize;
  final BoxDecoration imageDecoration;
  final String defaultImageUrl;

  const ImageThumbnail({
    required this.photoUrl,
    required this.index,
    required this.selectedIndex,
    required this.pageController,
    required this.imageSize,
    required this.imageDecoration,
    required this.defaultImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: photoUrl != null && photoUrl!.isNotEmpty,
      child: GestureDetector(
        onTap: () {
          pageController.jumpToPage(index);
        },
        child: Container(
          decoration: imageDecoration.copyWith(
            border: Border.all(
              color: selectedIndex == index ? Colors.blue : Colors.grey,
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              "http://superhomemart.duckdns.org:80/upload/$photoUrl.jpg",
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
    );
  }
}
