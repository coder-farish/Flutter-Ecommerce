import 'package:flutter/material.dart';
import 'package:myproject/data/user_db.dart';

class UsersManagementScreen extends StatefulWidget {
  const UsersManagementScreen({super.key});

  @override
  _UsersManagementScreenState createState() => _UsersManagementScreenState();
}

class _UsersManagementScreenState extends State<UsersManagementScreen> {
  final UserDatabaseHelper _dbHelper = UserDatabaseHelper();
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final users = await _dbHelper.getAllUsers();
    setState(() {
      _users = users;
    });
  }

  Future<void> _deleteUser(int id) async {
    await _dbHelper.deleteUser(id);
    _loadUsers();
  }

  Future<void> _updateUserRole(int userId, bool isAdmin) async {
    await _dbHelper.updateUserRole(userId, isAdmin ? 0 : 1);
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          final isAdmin = user['isAdmin'] == 1;

          return ListTile(
            title: Text(user['fullName']),
            subtitle: Text(user['email']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(isAdmin ? Icons.lock_open : Icons.lock),
                  onPressed: () {
                    _updateUserRole(user['id'], isAdmin);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _deleteUser(user['id']);
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
