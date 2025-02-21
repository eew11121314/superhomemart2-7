import 'package:flutter/material.dart';

class CartItem {
  final String productName;
  final double price;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.productName,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  List<CartItem> _cartItems = [];

  List<CartItem> get items => _items;
  List<CartItem> get cartItems => _cartItems;

  double get totalPrice =>
      _items.fold(0, (total, item) => total + item.price * item.quantity);

  void addItem(CartItem item) {
    _items.add(item);
    _cartItems.add(item);
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    _cartItems.removeAt(index);
    notifyListeners();
  }

  void increaseQuantity(int index) {
    _items[index].quantity++;
    notifyListeners();
  }

  void decreaseQuantity(int index) {
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _cartItems.clear();
    notifyListeners();
  }
}
