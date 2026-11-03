import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AppAuthProvider extends ChangeNotifier {
  static const String _userKey = 'current_user_email';
  static const String _registeredUsersDbKey = 'registered_users_db';

  UserModel? _currentUser;
  final List<UserModel> _registeredUsers = [];
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  List<UserModel> get registeredUsers => List.unmodifiable(_registeredUsers);
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AppAuthProvider() {
    _loadSavedUser();
  }

  Future<void> _loadSavedUser() async {
    final prefs = await SharedPreferences.getInstance();

    // Load registered users database
    final rawUsers = prefs.getString(_registeredUsersDbKey);
    if (rawUsers != null) {
      try {
        final List<dynamic> decoded = jsonDecode(rawUsers) as List<dynamic>;
        _registeredUsers.clear();
        for (final item in decoded) {
          _registeredUsers.add(UserModel.fromMap(item as Map<String, dynamic>));
        }
      } catch (_) {}
    }

    // Load active session user
    final email = prefs.getString(_userKey);
    if (email != null) {
      final existing = _registeredUsers.where((u) => u.email == email);
      if (existing.isNotEmpty) {
        _currentUser = existing.first;
      } else {
        _currentUser = UserModel(
          id: 'local_${email.hashCode}',
          name: email.split('@').first,
          email: email,
        );
      }
      notifyListeners();
    }
  }

  Future<void> _persistRegisteredUsers(SharedPreferences prefs) async {
    final encoded = jsonEncode(_registeredUsers.map((u) => u.toMap()).toList());
    await prefs.setString(_registeredUsersDbKey, encoded);
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

      final prefs = await SharedPreferences.getInstance();
      final existing = _registeredUsers.where((u) => u.email == email);
      if (existing.isNotEmpty) {
        _currentUser = existing.first;
      } else {
        _currentUser = UserModel(
          id: 'user_${email.hashCode}',
          name: email.split('@').first,
          email: email,
        );
        _registeredUsers.add(_currentUser!);
        await _persistRegisteredUsers(prefs);
      }

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

      final user = UserModel(
        id: 'user_${email.hashCode}',
        name: name,
        email: email,
      );

      _currentUser = user;
      final prefs = await SharedPreferences.getInstance();

      final existingIndex = _registeredUsers.indexWhere((u) => u.email == email);
      if (existingIndex >= 0) {
        _registeredUsers[existingIndex] = user;
      } else {
        _registeredUsers.add(user);
      }
      await _persistRegisteredUsers(prefs);
      await prefs.setString(_userKey, email);

      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signInWithGoogle({
    required String name,
    required String email,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await Future.delayed(const Duration(milliseconds: 150));
      if (name.trim().isEmpty || email.trim().isEmpty) {
        _errorMessage = 'Name and email are required for Google Sign-In.';
        _setLoading(false);
        return false;
      }

      final user = UserModel(
        id: 'google_${email.hashCode}',
        name: name.trim(),
        email: email.trim(),
      );

      _currentUser = user;
      final prefs = await SharedPreferences.getInstance();

      final existingIndex =
          _registeredUsers.indexWhere((u) => u.email == user.email);
      if (existingIndex >= 0) {
        _registeredUsers[existingIndex] = user;
      } else {
        _registeredUsers.add(user);
      }

      await _persistRegisteredUsers(prefs);
      await prefs.setString(_userKey, user.email);

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
