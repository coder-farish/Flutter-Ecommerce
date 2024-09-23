import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

class ItemDatabaseHelper {
  // Singleton instance
  static final ItemDatabaseHelper _instance = ItemDatabaseHelper._internal();
  factory ItemDatabaseHelper() => _instance;
  ItemDatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

// Get items by category
  Future<List<Map<String, dynamic>>> getItemsByCategory(String category) async {
    final db = await database;
    try {
      final result = await db.query(
        'items',
        where: 'category = ?',
        whereArgs: [category],
      );
      return result;
    } catch (e) {
      print('Error retrieving items by category: $e');
      return [];
    }
  }

// Function to get featured items where featured = 'yes'
  Future<List<Map<String, dynamic>>> getFeaturedItems() async {
    final db = await database;
    return await db.query('items', where: 'featured = ?', whereArgs: ['Yes']);
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'items_database.db');

    return await openDatabase(
      dbPath,
      version: 3, // Incremented version to handle schema changes for orders
      onCreate: (db, version) async {
        // Create the items table
        await db.execute('''
          CREATE TABLE items (
            serialNo INTEGER PRIMARY KEY AUTOINCREMENT,
            itemName TEXT NOT NULL,
            quantity INTEGER NOT NULL,
            price REAL NOT NULL,
            category TEXT,
            featured TEXT,
            size TEXT,
            imagePath TEXT,
            description TEXT, 
            color TEXT
          )
        ''');

        // Create the orders table
        await db.execute('''
          CREATE TABLE orders (
            orderNo INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT NOT NULL,
            contact TEXT NOT NULL,
            address TEXT NOT NULL,
            paymentMode TEXT NOT NULL,
            subTotal REAL NOT NULL,
            shippingFee REAL NOT NULL,
            totalAmount REAL NOT NULL,
            items TEXT NOT NULL -- JSON string of ordered items
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          // Create the orders table if it doesn't exist
          await db.execute('''
            CREATE TABLE IF NOT EXISTS orders (
              orderNo INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              email TEXT NOT NULL,
              contact TEXT NOT NULL,
              address TEXT NOT NULL,
              paymentMode TEXT NOT NULL,
              subTotal REAL NOT NULL,
              shippingFee REAL NOT NULL,
              totalAmount REAL NOT NULL,
              items TEXT NOT NULL -- JSON string of ordered items
            )
          ''');
        }
      },
    );
  }

  // Add a new item
  Future<int> insertItem(Map<String, dynamic> item) async {
    final db = await database;
    try {
      return await db.insert('items', item);
    } catch (e) {
      print('Error inserting item: $e');
      rethrow;
    }
  }

  // Get all items
  Future<List<Map<String, dynamic>>> getAllItems() async {
    final db = await database;
    try {
      return await db.query('items');
    } catch (e) {
      print('Error retrieving items: $e');
      return [];
    }
  }

  // Add a new order
  Future<int> insertOrder(Map<String, dynamic> order) async {
    final db = await database;
    try {
      return await db.insert('orders', order);
    } catch (e) {
      print('Error inserting order: $e');
      rethrow;
    }
  }

  // Get all orders
  Future<List<Map<String, dynamic>>> getAllOrders() async {
    final db = await database;
    try {
      return await db.query('orders');
    } catch (e) {
      print('Error retrieving orders: $e');
      return [];
    }
  }

  // Get a specific order by order number
  Future<Map<String, dynamic>?> getOrderByOrderNo(int orderNo) async {
    final db = await database;
    try {
      final result = await db.query(
        'orders',
        where: 'orderNo = ?',
        whereArgs: [orderNo],
      );
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      print('Error retrieving order by orderNo: $e');
      return null;
    }
  }

  // Convert JSON string to map for orders
  List<Map<String, dynamic>> decodeItems(String itemsJson) {
    List<dynamic> decodedItems = jsonDecode(itemsJson);
    return List<Map<String, dynamic>>.from(decodedItems);
  }

  // Function to check if a column exists in the database
  Future<void> _addColumnIfNotExists(
      Database db, String table, String column, String columnType) async {
    try {
      final result = await db.rawQuery('PRAGMA table_info($table)');
      final exists = result.any((row) => row['name'] == column);

      if (!exists) {
        await db.execute('ALTER TABLE $table ADD COLUMN $column $columnType');
      }
    } catch (e) {
      print('Error adding column $column to table $table: $e');
    }
  }

  // Update an item by serialNo
  Future<int> updateItem(Map<String, dynamic> item) async {
    final db = await database;
    try {
      if (item.containsKey('serialNo')) {
        return await db.update(
          'items',
          item,
          where: 'serialNo = ?',
          whereArgs: [item['serialNo']],
        );
      } else {
        throw ArgumentError('Item must contain a serialNo.');
      }
    } catch (e) {
      print('Error updating item: $e');
      rethrow;
    }
  }

  // Delete an item by serialNo
  Future<int> deleteItem(int serialNo) async {
    final db = await database;
    try {
      return await db.delete(
        'items',
        where: 'serialNo = ?',
        whereArgs: [serialNo],
      );
    } catch (e) {
      print('Error deleting item: $e');
      rethrow;
    }
  }

  // Get an item by serialNo
  Future<Map<String, dynamic>?> getItemBySerialNo(int serialNo) async {
    final db = await database;
    try {
      final result = await db.query(
        'items',
        where: 'serialNo = ?',
        whereArgs: [serialNo],
      );
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      print('Error retrieving item by serialNo: $e');
      return null;
    }
  }

  Future<void> decreaseItemQuantity(int? itemId, int? quantityOrdered) async {
    if (itemId == null || quantityOrdered == null || quantityOrdered < 0) {
      throw Exception('Invalid item ID or quantity.');
    }

    final db = await database;
    await db.rawUpdate(
      'UPDATE items SET quantity = quantity - ? WHERE serialNo = ?',
      [quantityOrdered, itemId],
    );
  }
}
