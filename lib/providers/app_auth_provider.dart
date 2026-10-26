import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AppAuthProvider extends ChangeNotifier {
  static const String _userKey = 'current_user_email';
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AppAuthProvider() {
    _loadSavedUser();
  }

  Future<void> _loadSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_userKey);
    if (email != null) {
      _currentUser = UserModel(
        id: 'local_${email.hashCode}',
        name: email.split('@').first,
        email: email,
      );
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await Future.delayed(const Duration(milliseconds: 100)); // simulated latency
      if (email.isEmpty || password.isEmpty) {
        _errorMessage = 'Email and password are required.';
        _setLoading(false);
        return false;
      }

      _currentUser = UserModel(
        id: 'user_${email.hashCode}',
        name: email.split('@').first,
        email: email,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, email);

      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await Future.delayed(const Duration(milliseconds: 100));
      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        _errorMessage = 'All fields are required.';
        _setLoading(false);
        return false;
      }

      _currentUser = UserModel(
        id: 'user_${email.hashCode}',
        name: name,
        email: email,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, email);

      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await Future.delayed(const Duration(milliseconds: 100));
      if (email.isEmpty) {
        _errorMessage = 'Please enter your email.';
        _setLoading(false);
        return false;
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
