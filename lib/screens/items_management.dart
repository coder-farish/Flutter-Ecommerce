import 'package:flutter/material.dart';
import 'package:myproject/data/item_db.dart';

class ItemsManagementScreen extends StatefulWidget {
  const ItemsManagementScreen({super.key});

  @override
  _ItemsManagementScreenState createState() => _ItemsManagementScreenState();
}

class _ItemsManagementScreenState extends State<ItemsManagementScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> _filteredItems = [];
  bool _isLoading = false;
  String _searchQuery = '';

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller and fade animation
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();
    _loadItems();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final items = await ItemDatabaseHelper().getAllItems();
      setState(() {
        _items = items;
        _filteredItems = _items; // Initialize filtered items
      });
    } catch (e) {
      print("Error loading items: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _searchItems(String query) {
    setState(() {
      _searchQuery = query;
      _filteredItems = _items.where((item) {
        final itemName = item['itemName'].toLowerCase();
        final searchQuery = _searchQuery.toLowerCase();
        return itemName.contains(searchQuery);
      }).toList();
    });
  }

  Future<void> _showEditModal(Map<String, dynamic> item) async {
    final TextEditingController itemNameController =
        TextEditingController(text: item['itemName']);
    final TextEditingController quantityController =
        TextEditingController(text: item['quantity'].toString());
    final TextEditingController priceController =
        TextEditingController(text: item['price'].toString());
    final TextEditingController imageLinkController =
        TextEditingController(text: item['imagePath']);
    final TextEditingController descriptionController =
        TextEditingController(text: item['description'] ?? '');
    final TextEditingController colorController =
        TextEditingController(text: item['color'] ?? '');
    final TextEditingController sizeController =
        TextEditingController(text: item['size'] ?? '');

    String selectedCategory = item['category'];
    String selectedFeatured = item['featured'];

    await showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      isScrollControlled: true,
      builder: (context) {
        // Calculate the keyboard height
        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

        return Padding(
          padding: EdgeInsets.only(bottom: keyboardHeight),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Edit Item',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                TextFormField(
                  controller: itemNameController,
                  decoration: const InputDecoration(labelText: 'Item Name'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: quantityController,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: ['Casual', 'Formal', 'Shoes', 'Accessories']
                      .map((cat) =>
                          DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                  onChanged: (val) {
                    selectedCategory = val!;
                  },
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedFeatured,
                  items: ['Yes', 'No']
                      .map((feat) =>
                          DropdownMenuItem(value: feat, child: Text(feat)))
                      .toList(),
                  onChanged: (val) {
                    selectedFeatured = val!;
                  },
                  decoration: const InputDecoration(labelText: 'Featured'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: imageLinkController,
                  decoration: const InputDecoration(labelText: 'Image Link'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: colorController,
                  decoration: const InputDecoration(labelText: 'Color'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: sizeController,
                  decoration: const InputDecoration(labelText: 'Size'),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final updatedItem = {
                          'serialNo': item['serialNo'],
                          'itemName': itemNameController.text,
                          'quantity': int.parse(quantityController.text),
                          'price': double.parse(priceController.text),
                          'category': selectedCategory,
                          'featured': selectedFeatured,
                          'size': sizeController.text,
                          'imagePath': imageLinkController.text,
                          'description': descriptionController.text,
                          'color': colorController.text,
                        };
                        try {
                          await ItemDatabaseHelper().updateItem(updatedItem);
                          _showSnackBar('Item updated successfully!');
                          await _loadItems();
                        } catch (e) {
                          print("Error updating item: $e");
                          _showSnackBar('Failed to update item.');
                        }
                        Navigator.of(context).pop();
                      },
                      child: const Text('Update'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showAddModal() async {
    final TextEditingController itemNameController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController imageLinkController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController colorController = TextEditingController();
    final TextEditingController sizeController = TextEditingController();
    String selectedCategory = 'Casual';
    String selectedFeatured = 'No';

    await showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      isScrollControlled: true,
      builder: (context) {
        // Calculate the keyboard height
        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

        return Padding(
          padding: EdgeInsets.only(bottom: keyboardHeight),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Add Item', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                TextFormField(
                  controller: itemNameController,
                  decoration: const InputDecoration(labelText: 'Item Name'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: quantityController,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: ['Casual', 'Formal', 'Shoes', 'Accessories']
                      .map((cat) =>
                          DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                  onChanged: (val) {
                    selectedCategory = val!;
                  },
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedFeatured,
                  items: ['Yes', 'No']
                      .map((feat) =>
                          DropdownMenuItem(value: feat, child: Text(feat)))
                      .toList(),
                  onChanged: (val) {
                    selectedFeatured = val!;
                  },
                  decoration: const InputDecoration(labelText: 'Featured'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: imageLinkController,
                  decoration: const InputDecoration(labelText: 'Image Link'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: colorController,
                  decoration: const InputDecoration(labelText: 'Color'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: sizeController,
                  decoration: const InputDecoration(labelText: 'Color'),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final newItem = {
                          'itemName': itemNameController.text,
                          'quantity': int.parse(quantityController.text),
                          'price': double.parse(priceController.text),
                          'category': selectedCategory,
                          'featured': selectedFeatured,
                          'size': sizeController.text,
                          'imagePath': imageLinkController.text,
                          'description': descriptionController.text,
                          'color': colorController.text,
                        };
                        try {
                          await ItemDatabaseHelper().insertItem(newItem);
                          _showSnackBar('Item added successfully!');
                          await _loadItems();
                        } catch (e) {
                          print("Error adding item: $e");
                          _showSnackBar('Failed to add item.');
                        }
                        Navigator.of(context).pop();
                      },
                      child: const Text('Add'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showSnackBar(String message) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items Management'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _searchItems,
              decoration: const InputDecoration(
                labelText: 'Search Items',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : FadeTransition(
                    opacity: _fadeAnimation,
                    child: ListView.builder(
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return ListTile(
                          title: Text(item['itemName'],
                              style: Theme.of(context).textTheme.bodyMedium),
                          subtitle: Text(
                              'Quantity: ${item['quantity']}, Price: \PKR ${item['price']}\n'
                              'Description: ${item['description'] ?? 'N/A'}, Color: ${item['color'] ?? 'N/A'}',
                              style: Theme.of(context).textTheme.bodyMedium),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit,
                                    color: Theme.of(context).iconTheme.color),
                                onPressed: () {
                                  _showEditModal(item);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete,
                                    color: Theme.of(context).iconTheme.color),
                                onPressed: () async {
                                  final confirmed = await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Confirm Delete'),
                                        content: const Text(
                                            'Are you sure you want to delete this item?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(true);
                                            },
                                            child: const Text('Delete'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(false);
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  if (confirmed) {
                                    try {
                                      await ItemDatabaseHelper()
                                          .deleteItem(item['serialNo']);
                                      _showSnackBar(
                                          'Item deleted successfully!');
                                      await _loadItems();
                                    } catch (e) {
                                      print("Error deleting item: $e");
                                      _showSnackBar('Failed to delete item.');
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddModal,
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
