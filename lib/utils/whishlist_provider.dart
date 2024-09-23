import 'package:flutter/material.dart';

class WishlistProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _wishlist = [];

  List<Map<String, dynamic>> get wishlist => _wishlist;

  // Check if product is in wishlist using serialNo
  bool isInWishlist(Map<String, dynamic> product) {
    return _wishlist.any((item) => item['serialNo'] == product['serialNo']);
  }

  // Add product to wishlist if it's not already there
  void addItem(Map<String, dynamic> product) {
    if (!isInWishlist(product)) {
      _wishlist.add(product);
      notifyListeners();
    }
  }

  // Remove product from wishlist using serialNo
  void removeItem(Map<String, dynamic> product) {
    _wishlist.removeWhere((item) => item['serialNo'] == product['serialNo']);
    notifyListeners();
  }
}
