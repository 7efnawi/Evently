import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:evently/l10n/app_localizations.dart';

void main() {
  group('AppLocalizations Unit Tests', () {
    test('English dictionary contains non-empty translations for key tokens', () {
      final l10n = AppLocalizations(const Locale('en'));
      expect(l10n.welcomeBack, 'Welcome Back ✨');
      expect(l10n.login, 'Login');
      expect(l10n.register, 'Register');
      expect(l10n.createEvent, 'Create Event');
      expect(l10n.loginWithGoogle, 'Login With Google');
      expect(l10n.searchForEvent, 'Search for Event');
    });

    test('Arabic dictionary contains non-empty Arabic translations for key tokens', () {
      final l10n = AppLocalizations(const Locale('ar'));
      expect(l10n.welcomeBack, 'مرحباً بك مجدداً ✨');
      expect(l10n.login, 'تسجيل الدخول');
      expect(l10n.register, 'إنشاء حساب');
      expect(l10n.createEvent, 'إنشاء فعالية');
      expect(l10n.loginWithGoogle, 'تسجيل الدخول عبر Google');
      expect(l10n.searchForEvent, 'البحث عن فعالية');
    });

    test('All keys in English have corresponding non-empty Arabic translations', () {
      final en = AppLocalizations(const Locale('en'));
      final ar = AppLocalizations(const Locale('ar'));

      for (final key in AppLocalizations.supportedKeys) {
        expect(en.translate(key), isNotEmpty,
            reason: 'Missing EN translation for $key');
        expect(ar.translate(key), isNotEmpty,
            reason: 'Missing AR translation for $key');
        expect(en.translate(key), isNot(equals(ar.translate(key))),
            reason: 'Translation for $key was not localized in Arabic');
      }
    });
  });
}
