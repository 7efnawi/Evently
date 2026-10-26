import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:evently/providers/app_theme_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppThemeProvider State Management Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('Initial theme mode is ThemeMode.light by default', () async {
      final provider = AppThemeProvider();
      expect(provider.themeMode, ThemeMode.light);
      expect(provider.isDarkMode, isFalse);
    });

    test('changeTheme switches to dark and notifies listeners', () async {
      final provider = AppThemeProvider();
      bool notified = false;
      provider.addListener(() => notified = true);

      await provider.changeTheme(ThemeMode.dark);

      expect(provider.themeMode, ThemeMode.dark);
      expect(provider.isDarkMode, isTrue);
      expect(notified, isTrue);
    });
  });
}
