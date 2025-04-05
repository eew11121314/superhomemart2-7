import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// คลาส CartItem ใช้เก็บข้อมูลของสินค้าที่อยู่ในตะกร้า
class CartItem {
  final String productId;
  final String productName;
  final double price;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });

  // แปลงข้อมูลของ CartItem เป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
    };
  }

  // สร้าง CartItem จาก JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'],
      productName: json['productName'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      quantity: json['quantity'],
    );
  }
}

// คลาส CartProvider ใช้จัดการตะกร้าสินค้า
class CartProvider with ChangeNotifier {
  final List<CartItem> _items = []; // รายการสินค้าที่อยู่ในตะกร้า
  List<CartItem> _cartItems = []; // รายการสินค้าที่แสดงในตะกร้า

  // Getter สำหรับรายการสินค้าที่อยู่ในตะกร้า
  List<CartItem> get items => _items;
  // Getter สำหรับรายการสินค้าที่แสดงในตะกร้า
  List<CartItem> get cartItems => _cartItems;

  // คำนวณราคารวมของสินค้าที่อยู่ในตะกร้า
  double get totalPrice =>
      _items.fold(0, (total, item) => total + item.price * item.quantity);

  // เพิ่มสินค้าลงในตะกร้า
  void addItem(CartItem item) {
    final existingItemIndex =
        _items.indexWhere((i) => i.productId == item.productId);

    if (existingItemIndex >= 0) {
      _items[existingItemIndex].quantity += 1;
    } else {
      _items.add(item);
      _cartItems.add(item);
    }

    notifyListeners();
  }

  // ลบสินค้าจากตะกร้า
  void removeItem(int index) {
    _items.removeAt(index);
    _cartItems.removeAt(index);
    notifyListeners();
  }

  // เพิ่มจำนวนของสินค้าที่อยู่ในตะกร้า
  void increaseQuantity(int index) {
    _items[index].quantity++;
    notifyListeners();
  }

  // ลดจำนวนของสินค้าที่อยู่ในตะกร้า ถ้าจำนวนมากกว่า 1
  void decreaseQuantity(int index) {
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
    } else {
      removeItem(index);
    }
    notifyListeners();
  }

  // ลบสินค้าทั้งหมดจากตะกร้า
  void clearCart() {
    _items.clear();
    _cartItems.clear();
    notifyListeners();
  }

  // บันทึกตะกร้าสินค้าของผู้ใช้ลงใน SharedPreferences
  Future<void> saveCart(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartJson =
        _items.map((item) => json.encode(item.toJson())).toList();
    await prefs.setStringList('cart_$username', cartJson);
  }

  // โหลดตะกร้าสินค้าของผู้ใช้จาก SharedPreferences
  Future<void> loadCart(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartJson = prefs.getStringList('cart_$username');
    if (cartJson != null) {
      _items.clear();
      _cartItems.clear();
      _items.addAll(cartJson
          .map((item) => CartItem.fromJson(json.decode(item)))
          .toList());
      _cartItems.addAll(_items);
      notifyListeners();
    }
  }
}
