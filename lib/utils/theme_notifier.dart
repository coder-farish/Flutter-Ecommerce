import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme.dart'; // Import the theme file

class ThemeNotifier extends ChangeNotifier {
  bool _isDarkTheme = false;
  ThemeData _currentTheme = AppTheme.lightTheme;

  bool get isDarkTheme => _isDarkTheme;
  ThemeData get currentTheme => _currentTheme;

  ThemeNotifier() {
    _loadFromPrefs(); // Load saved theme preference
  }

  // Toggles between light and dark themes
  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    _currentTheme =
        _isDarkTheme ? AppTheme.darkTheme : AppTheme.lightTheme; // Switch theme
    _saveToPrefs(); // Save the preference
    notifyListeners();
  }

  // Load the saved theme mode from SharedPreferences
  void _loadFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    _currentTheme = _isDarkTheme
        ? AppTheme.darkTheme
        : AppTheme.lightTheme; // Set initial theme
    notifyListeners(); // Ensure listeners are updated once the theme is loaded
  }

  // Save the current theme mode to SharedPreferences
  void _saveToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkTheme', _isDarkTheme);
  }
}
