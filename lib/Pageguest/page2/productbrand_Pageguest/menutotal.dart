// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class CategoryDetailPage extends StatefulWidget {
  final String categoryName;

  const CategoryDetailPage({super.key, required this.categoryName});

  @override
  _CategoryDetailPageState createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  bool isGridMode = false;

  final List<Map<String, dynamic>> products = [
    {
      'name': 'Product 1',
      'price': 100.0,
      'description': 'THT00001',
      'image': 'assets/banner1.jpg'
    },
    {
      'name': 'Product 2',
      'price': 150.0,
      'description': 'THT00002',
      'image': 'assets/banner2.jpg'
    },
    {
      'name': 'Product 3',
      'price': 200.0,
      'description': 'THT00003',
      'image': 'assets/banner3.jpg'
    },
    {
      'name': 'Product 4',
      'price': 250.0,
      'description': 'THT00004',
      'image': 'assets/banner4.jpg'
    },
    {
      'name': 'Product 5',
      'price': 300.0,
      'description': 'THT00005',
      'image': 'assets/banner5.jpg'
    },
    {
      'name': 'Product 6',
      'price': 350.0,
      'description': 'THT00006',
      'image': 'assets/banner6.jpg'
    },
    {
      'name': 'Product 7',
      'price': 400.0,
      'description': 'THT00007',
      'image': 'assets/banner7.jpg'
    },
    {
      'name': 'Product 8',
      'price': 450.0,
      'description': 'THT00008',
      'image': 'assets/banner8.jpg'
    },
    {
      'name': 'Product 9',
      'price': 500.0,
      'description': 'THT00009',
      'image': 'assets/banner9.jpg'
    },
    {
      'name': 'Product 10',
      'price': 550.0,
      'description': 'THT00010',
      'image': 'assets/banner10.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.categoryName} Total',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'Kanit', // Apply Kanit font to AppBar title
          ),
        ),
        elevation: 4.0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isGridMode ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                isGridMode = !isGridMode;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: isGridMode ? _buildGridView() : _buildListView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.0),
          ),
          elevation: 5,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset(
                product['image'],
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              '${product['name']}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF008080),
                fontFamily: 'Kanit',
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  '\$${product['price'].toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: 'Kanit',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontFamily: 'Kanit',
                  ),
                ),
              ],
            ),
            trailing:
                const Icon(Icons.arrow_forward_ios, color: Color(0xFF008080)),
            onTap: () {
              _showProductDialog(context, product['name']);
            },
          ),
        );
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 2 / 2.5,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return GestureDetector(
          onTap: () {
            _showProductDialog(context, product['name']);
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3.0),
            ),
            elevation: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(3.0),
                  child: Image.asset(
                    product['image'],
                    height: 170,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Text(
                    product['name'],
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF008080),
                      fontFamily: 'Kanit',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // คำอธิบายสินค้า
                      Expanded(
                        child: Text(
                          product['description'],
                          style: const TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Kanit',
                          ),
                        ),
                      ),
                      // ราคาอยู่ทางขวา
                      Text(
                        '\$${product['price'].toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 8,
                          color: Colors.black,
                          fontFamily: 'Kanit',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showProductDialog(BuildContext context, String productName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: const Color(0xFF008080),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'พบกันเร็วๆนี้กับ $productName',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Kanit',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008080),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'ปิด',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontFamily: 'Kanit',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
