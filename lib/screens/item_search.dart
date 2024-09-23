import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myproject/utils/cart_provider.dart';
import 'package:myproject/utils/whishlist_provider.dart';

class ItemSearchScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ItemSearchScreen({super.key, required this.product});

  @override
  _ItemSearchScreenState createState() => _ItemSearchScreenState();
}

class _ItemSearchScreenState extends State<ItemSearchScreen> {
  String selectedColor = 'Black'; // Default selected color
  String selectedSize = 'S'; // Default selected size
  int quantity = 1; // Default quantity

  final List<String> colors = ['Black', 'Brown', 'Dark Grey', 'Navy Blue'];
  final List<String> sizes = ['S', 'M', 'L', 'XL'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    // Calculate total quantity of this product in the cart
    final totalQuantityInCart = cartProvider.cartItems
        .where((item) => item['serialNo'] == widget.product['serialNo'])
        .fold<int>(0, (sum, item) => sum + (item['quantityInCart'] as int));

    int availableQuantity = widget.product['quantity'] ?? 0;
    bool isSoldOut = availableQuantity == 0;

    // Check if the product's total quantity in the cart has reached the limit (e.g., 3)
    bool isCartFull = totalQuantityInCart >= availableQuantity;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product['itemName'] ?? 'Product Detail'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        iconTheme: theme.appBarTheme.iconTheme,
        titleTextStyle: theme.appBarTheme.titleTextStyle,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.network(
                      widget.product['imagePath'] ??
                          'https://via.placeholder.com/150',
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.product['itemName'] ?? 'Product Name',
                      style: theme.textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'PKR ${widget.product['price']}',
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Description:',
                      style: theme.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.product['description'] ??
                          'No description available',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),

                    // Color selector
                    const Text('Select Color:'),
                    DropdownButton<String>(
                      value: selectedColor,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedColor = newValue!;
                        });
                      },
                      items:
                          colors.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Size selector
                    const Text('Select Size:'),
                    DropdownButton<String>(
                      value: selectedSize,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedSize = newValue!;
                        });
                      },
                      items:
                          sizes.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    isSoldOut
                        ? 'Sold Out - Coming Soon!'
                        : 'Available Stock: $availableQuantity',
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: isSoldOut ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.shopping_cart,
                          color: theme.colorScheme.primary),
                      onPressed: () {
                        Navigator.pushNamed(context, '/cart');
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        wishlistProvider.isInWishlist(widget.product)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: wishlistProvider.isInWishlist(widget.product)
                            ? Colors.red
                            : theme.colorScheme.secondary,
                      ),
                      onPressed: () {
                        if (wishlistProvider.isInWishlist(widget.product)) {
                          wishlistProvider.removeItem(widget.product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  '${widget.product['itemName']} removed from wishlist!'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        } else {
                          wishlistProvider.addItem(widget.product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  '${widget.product['itemName']} added to wishlist!'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.add_shopping_cart,
                        color: isCartFull || isSoldOut
                            ? theme.disabledColor
                            : theme.colorScheme.primary,
                      ),
                      onPressed: isCartFull || isSoldOut
                          ? () {
                              // Show a snack bar based on the condition
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(isSoldOut
                                      ? 'Sold Out - Please Add to WishList!'
                                      : 'All Available Stock Already in Cart'),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            }
                          : () {
                              // Add the selected product to the cart
                              cartProvider.addItem(
                                widget.product,
                                selectedColor,
                                selectedSize,
                                quantity,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Item added to Cart!'),
                                    duration: Duration(seconds: 2)),
                              );
                            },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
