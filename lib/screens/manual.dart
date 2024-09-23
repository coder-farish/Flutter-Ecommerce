import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart'; // For loading the JSON file

class ManualAddScreen extends StatelessWidget {
  const ManualAddScreen({super.key});

  // Method to read the JSON file and add all items from the JSON to the database
  Future<void> _addItemsFromJson() async {
    try {
      // Load the JSON file from assets
      String jsonString = await rootBundle.loadString('assets/data/dummy.json');

      // Parse the JSON data
      List<dynamic> itemsList = json.decode(jsonString);

      // Loop through each item in the list and insert it into the database
      for (var item in itemsList) {
        await ItemDatabaseHelper().insertItem(item);
      }

      print('All items added from JSON successfully');
    } catch (e) {
      print("Error adding items from JSON: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manual Add Item'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () async {
              await _addItemsFromJson(); // Call the method to add items from JSON
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Items added from JSON successfully!')),
              );
            },
            child: const Text('Add Items from JSON'),
          ),
        ),
      ),
    );
  }
}

class ItemDatabaseHelper {
  static final ItemDatabaseHelper _instance = ItemDatabaseHelper._internal();
  factory ItemDatabaseHelper() => _instance;

  ItemDatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'items_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE items (
        serialNo INTEGER PRIMARY KEY AUTOINCREMENT,
        itemName TEXT,
        quantity INTEGER,
        price REAL,
        category TEXT,
        featured TEXT,
        size TEXT,
        imagePath TEXT,
        description TEXT,
        color TEXT
      )
    ''');
  }

  // Insert item into the database
  Future<void> insertItem(Map<String, dynamic> newItem) async {
    final db = await database;
    await db.insert('items', newItem,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
