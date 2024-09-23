import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:myproject/screens/cart_screen.dart';
import 'package:myproject/screens/item_search.dart';
import 'package:myproject/screens/profile_screen.dart';
import 'package:myproject/screens/wishlist_screen.dart';
import 'package:myproject/utils/bottom_navigation.dart';
import 'package:provider/provider.dart';
import 'package:myproject/utils/theme_notifier.dart';
import 'package:myproject/data/item_db.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  String selectedCategory = 'All';
  List<Map<String, dynamic>> displayedProducts = [];
  late ItemDatabaseHelper _itemDatabaseHelper;

  final List<String> bannerImages = [
    'https://img.freepik.com/premium-photo/young-handsome-man-choosing-clothes-shop_926199-4113193.jpg',
    'https://img.freepik.com/premium-photo/photo-boutique-s-display-high-end-men-s-fashion_778780-1062.jpg',
    'https://img.freepik.com/premium-photo/young-man-shopping-new-pair-shoes-trying-various-styles-shoe-store_692187-3602.jpg',
    'https://ae-pic-a1.aliexpress-media.com/kf/H079e0e575a81472c9dbb48be8dfe30eb0.jpg_640x640Q90.jpg',
  ];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();

    _itemDatabaseHelper = ItemDatabaseHelper();
    _loadProducts();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    List<Map<String, dynamic>> products;
    if (selectedCategory == 'All') {
      products = await _itemDatabaseHelper.getAllItems();
    } else if (selectedCategory == 'Featured') {
      products = await _itemDatabaseHelper.getFeaturedItems();
    } else {
      products = await _itemDatabaseHelper.getItemsByCategory(selectedCategory);
    }

    setState(() {
      displayedProducts = products;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onCategoryChanged(String category) {
    setState(() {
      selectedCategory = category;
      _loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FFM Clothing Store'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(displayedProducts),
              );
            },
          ),
          Switch(
            value: themeNotifier.isDarkTheme,
            onChanged: (value) {
              themeNotifier.toggleTheme();
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeScreen(context, theme), // Home page content
          WishlistScreen(), // Wishlist placeholder
          CartScreen(), // Cart placeholder
          ProfileScreen(), // Profile placeholder
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildHomeScreen(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Banner/Carousel
        CarouselSlider(
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            autoPlayInterval: const Duration(seconds: 5),
          ),
          items: bannerImages.map((imageUrl) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            );
          }).toList(),
        ),

        // Filter Buttons
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                'All',
                'Featured',
                'Casual',
                'Formal',
                'Shoes',
                'Accessories'
              ]
                  .map((category) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1.0),
                        child: ElevatedButton(
                          onPressed: () {
                            _onCategoryChanged(category);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedCategory == category
                                ? theme.colorScheme.primary
                                : Colors.grey[300],
                          ),
                          child: Text(
                            category,
                            style: theme.textTheme.labelSmall!
                                .copyWith(fontWeight: FontWeight.w900),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),

        // Product Grid
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: displayedProducts.length,
              itemBuilder: (context, index) {
                final product = displayedProducts[index];

                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ItemSearchScreen(product: product),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12)),
                                image: DecorationImage(
                                  image: NetworkImage(product['imagePath'] ??
                                      'https://via.placeholder.com/150'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['itemName'] ?? '',
                                  style: theme.textTheme.titleMedium!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'PKR${product['price'] ?? ''}',
                                  style: theme.textTheme.titleSmall!
                                      .copyWith(color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// Search Delegate for the search functionality
class ProductSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> products;

  ProductSearchDelegate(this.products);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = products
        .where((product) =>
            product['itemName']!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return _buildSearchResults(results, context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = products
        .where((product) =>
            product['itemName']!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return _buildSearchResults(suggestions, context);
  }

  Widget _buildSearchResults(
      List<Map<String, dynamic>> results, BuildContext context) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final product = results[index];
        return ListTile(
          title: Text(product['itemName']),
          subtitle: Text('PKR${product['price']}'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemSearchScreen(product: product),
              ),
            );
          },
        );
      },
    );
  }
}
