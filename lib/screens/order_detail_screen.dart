import 'package:flutter/material.dart';
import 'package:myproject/data/item_db.dart'; // Import your database helper

class OrderDetailPage extends StatefulWidget {
  final int orderId;

  const OrderDetailPage({super.key, required this.orderId});

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  final ItemDatabaseHelper dbHelper = ItemDatabaseHelper();
  Map<String, dynamic>? orderDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrderDetails();
  }

  // Fetch order details by order number
  Future<void> fetchOrderDetails() async {
    final details = await dbHelper.getOrderByOrderNo(widget.orderId);
    setState(() {
      orderDetails = details;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details - #${widget.orderId}'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orderDetails == null
              ? Center(
                  child: Text('Order not found',
                      style: theme.textTheme.bodyMedium))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order Information',
                                  style:
                                      theme.textTheme.titleLarge, // Use theme
                                ),
                                const SizedBox(height: 10),
                                _buildInfoRow(context, Icons.receipt_long,
                                    'Order ID:', '${orderDetails!['orderNo']}'),
                                _buildInfoRow(context, Icons.person, 'Name:',
                                    '${orderDetails!['name']}'),
                                _buildInfoRow(context, Icons.email, 'Email:',
                                    '${orderDetails!['email']}'),
                                _buildInfoRow(context, Icons.phone, 'Contact:',
                                    '${orderDetails!['contact']}'),
                                _buildInfoRow(context, Icons.location_on,
                                    'Address:', '${orderDetails!['address']}'),
                                _buildInfoRow(
                                    context,
                                    Icons.payment,
                                    'Payment Mode:',
                                    '${orderDetails!['paymentMode']}'),
                                const SizedBox(height: 10),
                                const Divider(),
                                _buildInfoRow(
                                    context,
                                    Icons.attach_money,
                                    'Subtotal:',
                                    '${orderDetails!['subTotal']}'),
                                _buildInfoRow(
                                    context,
                                    Icons.local_shipping,
                                    'Shipping Fee:',
                                    'PKR ${orderDetails!['shippingFee']}'),
                                _buildInfoRow(
                                    context,
                                    Icons.monetization_on,
                                    'Total Amount:',
                                    'PKR ${orderDetails!['totalAmount']}'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Items Ordered Section
                        Text(
                          'Items Ordered:',
                          style: theme.textTheme.titleLarge, // Use theme
                        ),
                        const SizedBox(height: 10),

                        // List of Ordered Items
                        ListView.builder(
                          itemCount: dbHelper
                              .decodeItems(orderDetails!['items'])
                              .length,
                          shrinkWrap: true, // Ensures proper layout
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final item = dbHelper
                                .decodeItems(orderDetails!['items'])[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      theme.colorScheme.primary, // Use theme
                                  child: Text(
                                    '${item['quantityInCart']}x',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text(
                                  '${item['itemName']}',
                                  style: theme.textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ), // Use theme
                                ),
                                subtitle: Text('Price: PKR ${item['price']}',
                                    style: theme.textTheme.bodyMedium),
                                trailing: Text(
                                  'Total: PKR ${(item['price'] * item['quantityInCart']).toStringAsFixed(2)}',
                                  style: theme.textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ), // Use theme
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  // Helper function to build info rows with icons
  Widget _buildInfoRow(
      BuildContext context, IconData icon, String label, String value) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon,
              color: theme.colorScheme.primary, // Use theme
              size: 20),
          const SizedBox(width: 10),
          Text(
            label,
            style: theme.textTheme.bodyMedium!
                .copyWith(fontWeight: FontWeight.bold), // Use theme
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium!
                  .copyWith(color: Colors.black54), // Use theme
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
