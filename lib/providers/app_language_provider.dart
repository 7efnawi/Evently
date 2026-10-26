import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguageProvider extends ChangeNotifier {
  static const String _languagePrefKey = 'app_language_code';
  Locale _appLocale = const Locale('en');

  Locale get appLocale => _appLocale;
  bool get isEnglish => _appLocale.languageCode == 'en';

  AppLanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString(_languagePrefKey);
    if (savedCode != null) {
      _appLocale = Locale(savedCode);
      notifyListeners();
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    if (_appLocale.languageCode == languageCode) return;
    _appLocale = Locale(languageCode);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languagePrefKey, languageCode);
  }
}
