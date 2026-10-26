import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:evently/main.dart';
import 'package:evently/providers/app_language_provider.dart';
import 'package:evently/providers/app_theme_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  group('EventlyApp Root Widget Tests', () {
    testWidgets('launches standalone and displays SplashScreen',
        (tester) async {
      SharedPreferences.setMockInitialValues({'is_first_time': true});

      await tester.pumpWidget(const EventlyApp());
      expect(find.text('Evently'), findsOneWidget);
      expect(find.text('Supervised by Route'), findsOneWidget);

      // Settle pending timer from SplashScreen
      await tester.pump(const Duration(milliseconds: 2100));
      await tester.pumpAndSettle();
    });

    testWidgets(
        'launches with outer MultiProvider and reacts to theme/locale changes',
        (tester) async {
      SharedPreferences.setMockInitialValues({'is_first_time': true});

      final themeProvider = AppThemeProvider();
      final languageProvider = AppLanguageProvider();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AppThemeProvider>.value(
              value: themeProvider,
            ),
            ChangeNotifierProvider<AppLanguageProvider>.value(
              value: languageProvider,
            ),
          ],
          child: const EventlyApp(),
        ),
      );

      expect(find.text('Evently'), findsOneWidget);
      expect(find.text('Supervised by Route'), findsOneWidget);

      // Verify theme dynamic reaction
      themeProvider.changeTheme(ThemeMode.dark);
      languageProvider.changeLanguage('ar');
      await tester.pump();

      expect(themeProvider.isDarkMode, isTrue);
      expect(languageProvider.isEnglish, isFalse);

      // Settle pending timer from SplashScreen
      await tester.pump(const Duration(milliseconds: 2100));
      await tester.pumpAndSettle();
    });
  });
}
