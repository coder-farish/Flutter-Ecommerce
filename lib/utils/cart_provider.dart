import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  // Add or update item in the cart
  void addItem(
      Map<String, dynamic> product, String color, String size, int quantity) {
    if (product['serialNo'] == null) {
      print('Error: Product serialNo is null');
      return;
    }

    final itemId = '${product['serialNo']}_$color' '_$size';
    print('Adding item with ID: $itemId');

    // Check total quantity of the product (across all variants) in the cart
    final totalQuantityInCart = _cartItems
        .where((item) => item['serialNo'] == product['serialNo'])
        .fold<int>(0, (prev, item) => prev + (item['quantityInCart'] as int));

    final availableStock = product['quantity'] ?? 0;

    // Check if the cumulative quantity exceeds the available stock
    if (totalQuantityInCart + quantity > availableStock) {
      print('Cannot add more items than available stock for this product');
      return;
    }

    // Find if the exact variant (same color and size) already exists in the cart
    final existingItemIndex = _cartItems.indexWhere((item) =>
        '${item['serialNo']}_${item['color']}_${item['size']}' == itemId);

    if (existingItemIndex >= 0) {
      // Update the quantity of the existing variant in the cart
      final existingItem = _cartItems[existingItemIndex];
      final currentQuantityInCart = existingItem['quantityInCart'];
      final newQuantityInCart = currentQuantityInCart + quantity;

      // Ensure the quantity for this variant does not exceed available stock
      _cartItems[existingItemIndex]['quantityInCart'] =
          newQuantityInCart > availableStock
              ? availableStock
              : newQuantityInCart;
    } else {
      // Add new variant to the cart if it does not exist
      _cartItems.add({
        'serialNo': product['serialNo'],
        'itemName': product['itemName'],
        'imagePath': product['imagePath'],
        'price': product['price'],
        'color': color,
        'size': size,
        'quantityInCart': quantity,
        'quantity': product['quantity'],
      });
    }

    notifyListeners();
  }

  // Remove item from cart
  void removeItem(Map<String, dynamic> item) {
    final itemId = '${item['serialNo']}_${item['color']}_${item['size']}';
    _cartItems.removeWhere((cartItem) =>
        '${cartItem['serialNo']}_${cartItem['color']}_${cartItem['size']}' ==
        itemId);
    notifyListeners();
  }

  // Increase quantity of item in the cart
  void increaseQuantity(Map<String, dynamic> item) {
    final itemId = '${item['serialNo']}_${item['color']}_${item['size']}';

    // Find the index of the item variant
    final existingItemIndex = _cartItems.indexWhere((cartItem) =>
        '${cartItem['serialNo']}_${cartItem['color']}_${cartItem['size']}' ==
        itemId);

    if (existingItemIndex >= 0) {
      final existingItem = _cartItems[existingItemIndex];

      // Calculate total quantity across all variants
      final totalQuantityInCart = _cartItems
          .where((cartItem) => cartItem['serialNo'] == item['serialNo'])
          .fold<int>(0,
              (prev, cartItem) => prev + (cartItem['quantityInCart'] as int));

      final availableStock = existingItem['quantity'];

      // Check if adding more would exceed available stock
      if (totalQuantityInCart >= availableStock) {
        print('Cannot increase quantity, maximum stock reached');
        return;
      }

      // If not, increase the quantity of the variant
      if (existingItem['quantityInCart'] < availableStock) {
        _cartItems[existingItemIndex]['quantityInCart']++;
        notifyListeners();
      }
    }
  }

  // Decrease quantity of item in the cart
  void decreaseQuantity(Map<String, dynamic> item) {
    final itemId = '${item['serialNo']}_${item['color']}_${item['size']}';
    final existingItemIndex = _cartItems.indexWhere((cartItem) =>
        '${cartItem['serialNo']}_${cartItem['color']}_${cartItem['size']}' ==
        itemId);
    if (existingItemIndex >= 0) {
      final existingItem = _cartItems[existingItemIndex];
      if (existingItem['quantityInCart'] > 1) {
        _cartItems[existingItemIndex]['quantityInCart']--;
      } else {
        // If the quantity in cart is 1 and the user decreases, remove the item
        removeItem(existingItem);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    cartItems.clear();
    notifyListeners();
  }
}
