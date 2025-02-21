class CartItem {
  final String productName;
  final String imageUrl;
  final int quantity;
  final double price;

  CartItem({
    required this.productName,
    required this.imageUrl,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'price': price,
    };
  }
}
