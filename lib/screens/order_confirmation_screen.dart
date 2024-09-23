import 'package:flutter/material.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final int orderId;
  final double totalAmount;
  final double shippingFee;
  final double subTotal;
  final String paymentMode;
  final List<dynamic> cartItems;

  const OrderConfirmationScreen({
    super.key,
    required this.orderId,
    required this.totalAmount,
    required this.shippingFee,
    required this.subTotal,
    required this.paymentMode,
    required this.cartItems,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Thank You for Your Order!',
              style: Theme.of(context).textTheme.displayLarge, // Use theme
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Order Number
            Text(
              'Order Number: #$orderId',
              style: Theme.of(context).textTheme.bodyMedium, // Use theme
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Order Summary Title
            Text(
              'Order Summary',
              style: Theme.of(context).textTheme.titleLarge, // Use theme
            ),
            const SizedBox(height: 16),

            // Ordered Items
            Expanded(
              child: cartItems.isNotEmpty
                  ? ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item['imagePath'] ??
                                        'https://via.placeholder.com/150',
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['itemName'] ?? 'Unknown Item',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                            ), // Use theme
                                      ),
                                      const SizedBox(height: 4),
                                      Text('Size: ${item['size'] ?? 'N/A'}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall), // Use theme
                                      Text('Color: ${item['color'] ?? 'N/A'}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall), // Use theme
                                      Text(
                                          'Qty: ${item['quantityInCart'] ?? 0}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium), // Use theme
                                    ],
                                  ),
                                ),

                                // Price
                                Text(
                                  'PKR ${(item['price'] * item['quantityInCart']).toStringAsFixed(2)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ), // Use theme
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'No items in cart.',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 18,
                              color: Colors.black54,
                            ), // Use theme
                      ),
                    ),
            ),

            const Divider(),

            // Subtotal, Shipping, Total, and Payment Mode
            _buildInfoRow(
                context, 'Subtotal:', 'PKR ${subTotal.toStringAsFixed(2)}'),
            _buildInfoRow(context, 'Shipping Fee:',
                '\$${shippingFee.toStringAsFixed(2)}'),
            _buildInfoRow(context, 'Total Amount:',
                'PKR ${totalAmount.toStringAsFixed(2)}',
                isBold: true, color: Colors.black87),
            _buildInfoRow(context, 'Payment Mode:', paymentMode),

            const SizedBox(height: 24),

            // Continue Shopping Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/home', (route) => false);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Continue Shopping',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build rows for order summary info
  Widget _buildInfoRow(BuildContext context, String label, String value,
      {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                ), // Use theme
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: color ?? Colors.black54,
                ), // Use theme
          ),
        ],
      ),
    );
  }
}
