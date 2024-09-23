import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myproject/utils/whishlist_provider.dart';
import 'package:myproject/screens/item_search.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('My Wishlist'),
      // ),
      body: wishlistProvider.wishlist.isEmpty
          ? const Center(child: Text('Oppss.... Add your favorites!!'))
          : ListView.builder(
              itemCount: wishlistProvider.wishlist.length,
              itemBuilder: (context, index) {
                final product = wishlistProvider.wishlist[index];
                return ListTile(
                  leading: Image.network(product['imagePath']),
                  title: Text(product['itemName']),
                  subtitle: Text('PKR${product['price']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon:
                            const Icon(Icons.info_outline, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ItemSearchScreen(product: product),
                            ),
                          );
                        },
                      ),
                      // Delete button
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          wishlistProvider.removeItem(product);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
