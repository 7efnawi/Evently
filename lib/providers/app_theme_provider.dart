import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeProvider extends ChangeNotifier {
  static const String _themePrefKey = 'app_theme_mode';
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  AppThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString(_themePrefKey);
    if (savedMode == 'dark') {
      _themeMode = ThemeMode.dark;
      notifyListeners();
    } else if (savedMode == 'light') {
      _themeMode = ThemeMode.light;
      notifyListeners();
    }
  }

  Future<void> changeTheme(ThemeMode newThemeMode) async {
    if (_themeMode == newThemeMode) return;
    _themeMode = newThemeMode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _themePrefKey,
      newThemeMode == ThemeMode.dark ? 'dark' : 'light',
    );
  }

  Future<void> toggleTheme() async {
    await changeTheme(isDarkMode ? ThemeMode.light : ThemeMode.dark);
  }
}
