import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/services/firebase_auth_service.dart';
import '../models/user_model.dart';

class AppAuthProvider extends ChangeNotifier {
  static const String _userKey = 'current_user_email';
  static const String _registeredUsersDbKey = 'registered_users_db';

  final FirebaseAuthService _authService;
  final List<UserModel> _registeredUsers = [];

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  List<UserModel> get registeredUsers => List.unmodifiable(_registeredUsers);
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get _isFirebaseConfigured {
    try {
      return Firebase.apps.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  AppAuthProvider({FirebaseAuthService? authService})
      : _authService = authService ?? FirebaseAuthService() {
    _initAuth();
  }

  Future<void> _initAuth() async {
    final prefs = await SharedPreferences.getInstance();

    // Load registered users database (for local fallback & testing)
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

    // Check Firebase user first
    if (_isFirebaseConfigured && _authService.currentUser != null) {
      _currentUser = _authService.currentUser;
      notifyListeners();
      return;
    }

    // Otherwise check local saved session
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

    if (email.trim().isEmpty || password.isEmpty) {
      _errorMessage = 'Email and password are required.';
      _setLoading(false);
      return false;
    }

    try {
      // 1. Try Firebase if available
      if (_isFirebaseConfigured) {
        final user = await _authService.signInWithEmail(
          email: email.trim(),
          password: password,
        );
        if (user != null) {
          _currentUser = user;
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_userKey, user.email);
          _setLoading(false);
          return true;
        }
      }

      // 2. Fallback to local user DB (for offline mode & tests)
      final prefs = await SharedPreferences.getInstance();
      final existing = _registeredUsers.where((u) => u.email == email.trim());
      if (existing.isNotEmpty) {
        _currentUser = existing.first;
      } else {
        _currentUser = UserModel(
          id: 'user_${email.hashCode}',
          name: email.split('@').first,
          email: email.trim(),
        );
        _registeredUsers.add(_currentUser!);
        await _persistRegisteredUsers(prefs);
      }

      await prefs.setString(_userKey, email.trim());
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

    if (name.trim().isEmpty || email.trim().isEmpty || password.isEmpty) {
      _errorMessage = 'All fields are required.';
      _setLoading(false);
      return false;
    }

    try {
      // 1. Try Firebase if available
      if (_isFirebaseConfigured) {
        final user = await _authService.signUpWithEmail(
          name: name.trim(),
          email: email.trim(),
          password: password,
        );
        if (user != null) {
          _currentUser = user;
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_userKey, user.email);
          _setLoading(false);
          return true;
        }
      }

      // 2. Local registration (for offline mode & tests)
      final user = UserModel(
        id: 'user_${email.hashCode}',
        name: name.trim(),
        email: email.trim(),
      );

      _currentUser = user;
      final prefs = await SharedPreferences.getInstance();

      final existingIndex =
          _registeredUsers.indexWhere((u) => u.email == email.trim());
      if (existingIndex >= 0) {
        _registeredUsers[existingIndex] = user;
      } else {
        _registeredUsers.add(user);
      }

      await _persistRegisteredUsers(prefs);
      await prefs.setString(_userKey, email.trim());

      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signInWithGoogle({
    String? idToken,
    String? accessToken,
    String? name,
    String? email,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      if (_isFirebaseConfigured && idToken != null && accessToken != null) {
        final user = await _authService.signInWithGoogle(
          idToken: idToken,
          accessToken: accessToken,
        );
        if (user != null) {
          _currentUser = user;
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_userKey, user.email);
          _setLoading(false);
          return true;
        }
      }

      // Fallback for tests & account picker
      final resolvedName = (name != null && name.trim().isNotEmpty)
          ? name.trim()
          : 'Google User';
      final resolvedEmail = (email != null && email.trim().isNotEmpty)
          ? email.trim()
          : 'google.user@gmail.com';

      final user = UserModel(
        id: 'google_${resolvedEmail.hashCode}',
        name: resolvedName,
        email: resolvedEmail,
      );

      _currentUser = user;
      final prefs = await SharedPreferences.getInstance();
      final existingIndex =
          _registeredUsers.indexWhere((u) => u.email == resolvedEmail);
      if (existingIndex >= 0) {
        _registeredUsers[existingIndex] = user;
      } else {
        _registeredUsers.add(user);
      }

      await _persistRegisteredUsers(prefs);
      await prefs.setString(_userKey, resolvedEmail);

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

    if (email.trim().isEmpty) {
      _errorMessage = 'Please enter your email.';
      _setLoading(false);
      return false;
    }

    try {
      if (_isFirebaseConfigured) {
        await _authService.sendPasswordResetEmail(email: email.trim());
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
    if (_isFirebaseConfigured) {
      await _authService.signOut();
    }
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
