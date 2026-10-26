import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:evently/providers/app_auth_provider.dart';
import 'package:evently/providers/app_theme_provider.dart';
import 'package:evently/providers/app_language_provider.dart';
import 'package:evently/screens/profile/profile_tab.dart';
import 'package:evently/screens/profile/widgets/language_bottom_sheet.dart';
import 'package:evently/screens/profile/widgets/theme_bottom_sheet.dart';
import 'package:evently/utils/app_routes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget buildTestableWidget({
    required AppAuthProvider authProvider,
    required AppThemeProvider themeProvider,
    required AppLanguageProvider languageProvider,
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: languageProvider),
      ],
      child: MaterialApp(
        routes: {
          AppRoutes.login: (_) => const Scaffold(body: Text('Login Screen')),
        },
        home: const Scaffold(body: ProfileTab()),
      ),
    );
  }

  group('ProfileTab Widget Tests', () {
    testWidgets('renders user credentials, language, theme items, and logout button', (tester) async {
      final authProvider = AppAuthProvider();
      final themeProvider = AppThemeProvider();
      final languageProvider = AppLanguageProvider();

      await tester.pumpWidget(
        buildTestableWidget(
          authProvider: authProvider,
          themeProvider: themeProvider,
          languageProvider: languageProvider,
        ),
      );

      expect(find.text('Language'), findsOneWidget);
      expect(find.text('Theme'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('John Safwat'), findsOneWidget);
      expect(find.text('johnsafwat.route@gmail.com'), findsOneWidget);
    });

    testWidgets('displays logged-in user name and email when currentUser is set', (tester) async {
      final authProvider = AppAuthProvider();
      final themeProvider = AppThemeProvider();
      final languageProvider = AppLanguageProvider();

      await tester.runAsync(() async {
        await authProvider.login('test@route.com', '123456');
      });

      await tester.pumpWidget(
        buildTestableWidget(
          authProvider: authProvider,
          themeProvider: themeProvider,
          languageProvider: languageProvider,
        ),
      );

      expect(find.text('test'), findsOneWidget);
      expect(find.text('test@route.com'), findsOneWidget);
    });

    testWidgets('tapping Language item opens LanguageBottomSheet', (tester) async {
      final authProvider = AppAuthProvider();
      final themeProvider = AppThemeProvider();
      final languageProvider = AppLanguageProvider();

      await tester.pumpWidget(
        buildTestableWidget(
          authProvider: authProvider,
          themeProvider: themeProvider,
          languageProvider: languageProvider,
        ),
      );

      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();

      expect(find.byType(LanguageBottomSheet), findsOneWidget);
    });

    testWidgets('tapping Theme item opens ThemeBottomSheet', (tester) async {
      final authProvider = AppAuthProvider();
      final themeProvider = AppThemeProvider();
      final languageProvider = AppLanguageProvider();

      await tester.pumpWidget(
        buildTestableWidget(
          authProvider: authProvider,
          themeProvider: themeProvider,
          languageProvider: languageProvider,
        ),
      );

      await tester.tap(find.text('Light'));
      await tester.pumpAndSettle();

      expect(find.byType(ThemeBottomSheet), findsOneWidget);
    });

    testWidgets('tapping Logout logs out and navigates to LoginScreen', (tester) async {
      final authProvider = AppAuthProvider();
      final themeProvider = AppThemeProvider();
      final languageProvider = AppLanguageProvider();

      await tester.runAsync(() async {
        await authProvider.login('test@route.com', '123456');
      });

      await tester.pumpWidget(
        buildTestableWidget(
          authProvider: authProvider,
          themeProvider: themeProvider,
          languageProvider: languageProvider,
        ),
      );

      final logoutBtn = find.text('Logout');
      await tester.ensureVisible(logoutBtn);
      await tester.tap(logoutBtn);
      await tester.pumpAndSettle();

      expect(authProvider.isAuthenticated, isFalse);
      expect(find.text('Login Screen'), findsOneWidget);
    });
  });
}
