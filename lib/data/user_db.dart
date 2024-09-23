import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserDatabaseHelper {
  // Singleton instance
  static final UserDatabaseHelper _instance = UserDatabaseHelper._internal();
  factory UserDatabaseHelper() => _instance;
  UserDatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Initialize the database with the path and name
    String path = await getDatabasesPath();
    return await openDatabase(
      join(path, 'your_database.db'),
      onCreate: (db, version) async {
        // Create user table
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fullName TEXT,
            email TEXT UNIQUE,
            password TEXT,
            address TEXT,
            isAdmin INTEGER DEFAULT 0
          )
        ''');
      },
      version: 1,
    );
  }

  // ============ User Methods ============

  // Insert a new user
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    try {
      return await db.insert('users', user);
    } catch (e) {
      print('Error inserting user: $e');
      rethrow;
    }
  }

  // Get a user by email
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    try {
      final result =
          await db.query('users', where: 'email = ?', whereArgs: [email]);
      if (result.isNotEmpty) return result.first;
    } catch (e) {
      print('Error getting user by email: $e');
    }
    return null;
  }

  // Get a user by email and password
  Future<Map<String, dynamic>?> getUserByEmailAndPassword(
      String email, String password) async {
    final db = await database;
    try {
      final result = await db.query('users',
          where: 'email = ? AND password = ?', whereArgs: [email, password]);
      if (result.isNotEmpty) return result.first;
    } catch (e) {
      print('Error getting user by email and password: $e');
    }
    return null;
  }

  // Update user by ID
  Future<int> updateUser(int id, Map<String, dynamic> user) async {
    final db = await database;
    try {
      return await db.update('users', user, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  // Get all users
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    try {
      return await db.query('users');
    } catch (e) {
      print('Error retrieving all users: $e');
      return [];
    }
  }

  // Delete a user by ID
  Future<int> deleteUser(int id) async {
    final db = await database;
    try {
      return await db.delete('users', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }

  // Update user role (isAdmin)
  Future<int> updateUserRole(int userId, int isAdmin) async {
    final db = await database;
    try {
      return await db.update('users', {'isAdmin': isAdmin},
          where: 'id = ?', whereArgs: [userId]);
    } catch (e) {
      print('Error updating user role: $e');
      rethrow;
    }
  }

  // Get a user by ID
  Future<Map<String, dynamic>?> getUserById(int id) async {
    final db = await database;
    try {
      final result = await db.query('users', where: 'id = ?', whereArgs: [id]);
      if (result.isNotEmpty) return result.first;
    } catch (e) {
      print('Error getting user by ID: $e');
    }
    return null;
  }
}
