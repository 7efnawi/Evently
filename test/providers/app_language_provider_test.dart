import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:evently/providers/app_language_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppLanguageProvider State Management Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('Initial locale is English by default', () {
      final provider = AppLanguageProvider();
      expect(provider.appLocale.languageCode, 'en');
      expect(provider.isEnglish, isTrue);
    });

    test('changeLanguage to Arabic updates locale and notifies listeners', () async {
      final provider = AppLanguageProvider();
      bool notified = false;
      provider.addListener(() => notified = true);

      await provider.changeLanguage('ar');

      expect(provider.appLocale.languageCode, 'ar');
      expect(provider.isEnglish, isFalse);
      expect(notified, isTrue);
    });
  });
}
