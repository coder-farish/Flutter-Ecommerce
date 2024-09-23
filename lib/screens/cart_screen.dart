import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myproject/utils/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Cart'),
      // ),
      body: cartProvider.cartItems.isEmpty
          ? const Center(child: Text('No items in the cart'))
          : ListView.builder(
              itemCount: cartProvider.cartItems.length,
              itemBuilder: (context, index) {
                final item = cartProvider.cartItems[index];

                // Calculate the total quantity of this product (across variants)
                final totalQuantityInCart = cartProvider.cartItems
                    .where(
                        (cartItem) => cartItem['serialNo'] == item['serialNo'])
                    .fold<int>(
                        0,
                        (prev, cartItem) =>
                            prev + cartItem['quantityInCart'] as int);

                final availableStock =
                    item['quantity']; // Total available stock

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: Image.network(
                        item['imagePath'] ?? 'https://via.placeholder.com/150',
                        width: 50),
                    title: Text(item['itemName']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Size: ${item['size']}, Color: ${item['color']}'),
                        const SizedBox(height: 4),
                        Text(
                          'Total: PKR ${(item['price'] * item['quantityInCart']).toStringAsFixed(2)}',
                        ),
                      ],
                    ),
                    trailing: SizedBox(
                      width: 130,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Remove button
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  cartProvider.decreaseQuantity(item);
                                },
                              ),
                              Text(
                                '${item['quantityInCart']}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              // Add button, disabled when total quantity >= available stock
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: totalQuantityInCart < availableStock
                                    ? () {
                                        cartProvider.increaseQuantity(item);
                                      }
                                    : null, // Disable button when stock is exceeded
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: cartProvider.cartItems.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/checkout');
                },
                child: const Text('Checkout'),
              ),
            ),
    );
  }
}
