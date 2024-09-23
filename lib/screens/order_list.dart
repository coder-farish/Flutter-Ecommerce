import 'package:flutter/material.dart';
import 'package:myproject/utils/theme.dart'; // Import your theme
import 'package:myproject/data/item_db.dart';
import 'package:myproject/screens/order_detail_screen.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final ItemDatabaseHelper dbHelper = ItemDatabaseHelper();
  List<Map<String, dynamic>> orders = [];
  List<Map<String, dynamic>> filteredOrders = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final allOrders = await dbHelper.getAllOrders();
    setState(() {
      orders = allOrders;
      filteredOrders = allOrders;
    });
  }

  void searchOrderById(String query) {
    final results = orders.where((order) {
      final orderId = order['orderNo'].toString();
      return orderId.contains(query);
    }).toList();

    setState(() {
      filteredOrders = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Orders'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  labelText: 'Search by Order ID',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  searchOrderById(value);
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = filteredOrders[index];
                  return Card(
                    elevation: 2,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text('Order ID: ${order['orderNo']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name: ${order['name']}'),
                          Text('Total Amount: PKR ${order['totalAmount']}'),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OrderDetailPage(orderId: order['orderNo']),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
