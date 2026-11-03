import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:evently/l10n/app_localizations.dart';
import 'package:evently/providers/app_auth_provider.dart';
import 'package:evently/providers/app_language_provider.dart';
import 'package:evently/providers/app_theme_provider.dart';
import 'package:evently/screens/auth/login_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget buildArabicApp() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        ChangeNotifierProvider(create: (_) => AppThemeProvider()),
        ChangeNotifierProvider(create: (_) => AppLanguageProvider()),
      ],
      child: const MaterialApp(
        locale: Locale('ar'),
        supportedLocales: [Locale('en'), Locale('ar')],
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: LoginScreen(),
      ),
    );
  }

  group('UI Localization Integration Tests', () {
    testWidgets('LoginScreen renders Arabic text when locale is Arabic', (tester) async {
      await tester.pumpWidget(buildArabicApp());
      await tester.pumpAndSettle();

      expect(find.text('تسجيل الدخول'), findsWidgets); // Button / Title
      expect(find.text('نسيت كلمة المرور؟'), findsOneWidget);
      expect(find.text('ليس لديك حساب؟ '), findsOneWidget);
      expect(find.text('إنشاء حساب'), findsOneWidget);
    });
  });
}
