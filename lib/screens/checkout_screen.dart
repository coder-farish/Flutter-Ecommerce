import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:myproject/screens/order_confirmation_screen.dart';
import 'package:provider/provider.dart';
import 'package:myproject/utils/cart_provider.dart';
import 'package:myproject/data/item_db.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String _paymentMode = 'Cash';

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    // Calculate totals
    double subTotal = cartProvider.cartItems.fold(0.0, (sum, item) {
      return sum + (item['price'] * item['quantityInCart']);
    });
    double shippingFee = 500.0;
    double totalAmount = subTotal + shippingFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // User Information
              Text('Enter Your Details',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email Address'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _contactController,
                decoration: const InputDecoration(labelText: 'Contact Number'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              const SizedBox(height: 16),

              // Payment Mode
              Text('Select Payment Mode',
                  style: Theme.of(context).textTheme.titleMedium),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('Cash'),
                      leading: Radio<String>(
                        value: 'Cash',
                        groupValue: _paymentMode,
                        onChanged: (value) {
                          setState(() {
                            _paymentMode = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Online'),
                      leading: Radio<String>(
                        value: 'Online',
                        groupValue: _paymentMode,
                        onChanged: (value) {
                          setState(() {
                            _paymentMode = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Cart Items
              Text('Order Summary',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              ListView.builder(
                itemCount: cartProvider.cartItems.length,
                shrinkWrap:
                    true, // This helps the ListView to occupy only the needed height
                physics:
                    const NeverScrollableScrollPhysics(), // Disables scrolling within the ListView
                itemBuilder: (context, index) {
                  final item = cartProvider.cartItems[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Image.network(
                          item['imagePath'] ??
                              'https://via.placeholder.com/150',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['itemName'],
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              Text('Size: ${item['size']}',
                                  style:
                                      Theme.of(context).textTheme.labelSmall),
                              Text('Color: ${item['color']}',
                                  style:
                                      Theme.of(context).textTheme.labelSmall),
                            ],
                          ),
                        ),
                        Text('Qty: ${item['quantityInCart']}'),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Total and Place Order
              Text('Subtotal: PKR ${subTotal.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleSmall),
              Text('Shipping Fee: PKR ${shippingFee.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleSmall),
              Text('Total Amount: PKR ${totalAmount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  // Convert cart items to JSON
                  final String itemsJson = jsonEncode(cartProvider.cartItems);

                  // Create an order object
                  final order = {
                    'name': _nameController.text,
                    'email': _emailController.text,
                    'contact': _contactController.text,
                    'address': _addressController.text,
                    'paymentMode': _paymentMode,
                    'subTotal': subTotal,
                    'shippingFee': shippingFee,
                    'totalAmount': totalAmount,
                    'items': itemsJson, // Save as a JSON string
                  };

                  if (cartProvider.cartItems.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Your cart is empty!')),
                    );
                    return;
                  }

                  try {
                    // Save the order to the database and get the inserted orderId
                    final dbHelper = ItemDatabaseHelper();
                    final orderId = await dbHelper.insertOrder(order);

                    // Decrease the stock for each item in the cart
                    for (var item in cartProvider.cartItems) {
                      final itemId = item['serialNo'];
                      final quantityInCart = item['quantityInCart'];
                      await dbHelper.decreaseItemQuantity(
                          itemId, quantityInCart);
                    }

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderConfirmationScreen(
                          orderId: orderId,
                          totalAmount: totalAmount,
                          shippingFee: shippingFee,
                          subTotal: subTotal,
                          paymentMode: _paymentMode,
                          cartItems: cartProvider.cartItems,
                        ),
                      ),
                    );
                    Future.delayed(const Duration(milliseconds: 1000), () {
                      cartProvider.clearCart();
                    });
                  } catch (e) {
                    // Handle error
                    print('Error placing order: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to place order: $e')),
                    );
                  }
                },
                child: const Text('Place Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
