import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:evently/main.dart';
import 'package:evently/providers/app_auth_provider.dart';
import 'package:evently/providers/app_language_provider.dart';
import 'package:evently/providers/app_theme_provider.dart';
import 'package:evently/screens/auth/forget_password_screen.dart';
import 'package:evently/screens/auth/login_screen.dart';
import 'package:evently/screens/auth/register_screen.dart';
import 'package:evently/screens/main_layout/main_layout_screen.dart';
import 'package:evently/utils/app_routes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  setUp(() {
    SharedPreferences.setMockInitialValues({'is_first_time': true});
  });

  group('EventlyApp Root Widget Tests', () {
    testWidgets('launches standalone and displays SplashScreen',
        (tester) async {
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
      final themeProvider = AppThemeProvider();
      final languageProvider = AppLanguageProvider();
      final authProvider = AppAuthProvider();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AppThemeProvider>.value(
              value: themeProvider,
            ),
            ChangeNotifierProvider<AppLanguageProvider>.value(
              value: languageProvider,
            ),
            ChangeNotifierProvider<AppAuthProvider>.value(
              value: authProvider,
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

    testWidgets('provides AppAuthProvider in the widget tree', (tester) async {
      await tester.pumpWidget(const EventlyApp());

      final BuildContext navContext =
          tester.element(find.byType(Navigator).first);
      final authProvider =
          Provider.of<AppAuthProvider>(navContext, listen: false);
      expect(authProvider, isNotNull);
      expect(authProvider.isAuthenticated, isFalse);

      await tester.pump(const Duration(milliseconds: 2100));
      await tester.pumpAndSettle();
    });

    testWidgets('routes map to correct auth screens', (tester) async {
      await tester.pumpWidget(const EventlyApp());

      final NavigatorState navigator =
          tester.state<NavigatorState>(find.byType(Navigator).first);

      // Navigate to LoginScreen
      navigator.pushNamed(AppRoutes.login);
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);

      // Navigate to RegisterScreen
      navigator.pushNamed(AppRoutes.register);
      await tester.pumpAndSettle();
      expect(find.byType(RegisterScreen), findsOneWidget);

      // Navigate to ForgetPasswordScreen
      navigator.pushNamed(AppRoutes.forgetPassword);
      await tester.pumpAndSettle();
      expect(find.byType(ForgetPasswordScreen), findsOneWidget);
    });

    testWidgets('routes map to MainLayoutScreen and render navigation tabs',
        (tester) async {
      await tester.pumpWidget(const EventlyApp());

      final NavigatorState navigator =
          tester.state<NavigatorState>(find.byType(Navigator).first);

      navigator.pushNamed(AppRoutes.mainLayout);
      await tester.pumpAndSettle();

      expect(find.byType(MainLayoutScreen), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Map'), findsOneWidget);
      expect(find.text('Love'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });
  });
}
