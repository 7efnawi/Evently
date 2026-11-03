import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:evently/l10n/app_localizations.dart';
import 'package:evently/providers/app_auth_provider.dart';
import 'package:evently/providers/app_events_provider.dart';
import 'package:evently/providers/app_language_provider.dart';
import 'package:evently/providers/app_theme_provider.dart';
import 'package:evently/screens/home/home_screen.dart';
import 'package:evently/screens/favorites/favorites_tab.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget buildArabicApp({required Widget home}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        ChangeNotifierProvider(create: (_) => AppThemeProvider()),
        ChangeNotifierProvider(create: (_) => AppLanguageProvider()),
        ChangeNotifierProvider(create: (_) => AppEventsProvider()),
      ],
      child: MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: const [Locale('en'), Locale('ar')],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: home,
      ),
    );
  }

  group('Events Localization Tests', () {
    testWidgets('HomeScreen renders Arabic welcome and category names', (tester) async {
      await tester.pumpWidget(buildArabicApp(home: const HomeScreen()));
      await tester.pumpAndSettle();

      expect(find.text('مرحباً بك مجدداً ✨'), findsOneWidget);
      expect(find.text('الكل'), findsOneWidget);
      expect(find.text('رياضة'), findsOneWidget);
      expect(find.text('عيد ميلاد'), findsOneWidget);
    });

    testWidgets('FavoritesTab renders Arabic search hint and empty state', (tester) async {
      await tester.pumpWidget(buildArabicApp(home: const FavoritesTab()));
      await tester.pumpAndSettle();

      expect(find.text('البحث عن فعالية'), findsOneWidget);
    });
  });
}
