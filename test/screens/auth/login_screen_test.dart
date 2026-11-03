import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:evently/l10n/app_localizations.dart';
import 'package:evently/providers/app_auth_provider.dart';
import 'package:evently/providers/app_language_provider.dart';
import 'package:evently/screens/auth/login_screen.dart';
import 'package:evently/utils/app_routes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget buildTestableWidget() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        ChangeNotifierProvider(create: (_) => AppLanguageProvider()),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('ar'),
        ],
        routes: {
          AppRoutes.mainLayout: (_) =>
              const Scaffold(body: Text('Main Dashboard')),
          AppRoutes.register: (_) => const Scaffold(body: Text('Register Screen')),
          AppRoutes.forgetPassword: (_) =>
              const Scaffold(body: Text('Forget Password Screen')),
        },
        home: const LoginScreen(),
      ),
    );
  }

  group('LoginScreen Widget Tests', () {
    testWidgets('renders logo, fields, links, and buttons', (tester) async {
      await tester.pumpWidget(buildTestableWidget());

      expect(find.text('Evently'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Forget Password?'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Login With Google'), findsOneWidget);
    });

    testWidgets('shows validation errors when submitting empty fields', (tester) async {
      await tester.pumpWidget(buildTestableWidget());

      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email address'), findsOneWidget);
      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('logs in successfully and navigates to main layout', (tester) async {
      await tester.pumpWidget(buildTestableWidget());

      final inputs = find.byType(TextFormField);
      await tester.enterText(inputs.at(0), 'user@example.com');
      await tester.enterText(inputs.at(1), 'password123');

      await tester.tap(find.text('Login'));
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();

      expect(find.text('Main Dashboard'), findsOneWidget);
    });

    testWidgets('logs in with Google successfully and navigates to main layout', (tester) async {
      await tester.pumpWidget(buildTestableWidget());

      await tester.tap(find.text('Login With Google'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ahmed Ali'));
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      expect(find.text('Main Dashboard'), findsOneWidget);
    });

    testWidgets('toggles language when language button is tapped', (tester) async {
      await tester.pumpWidget(buildTestableWidget());

      expect(find.text('عربي'), findsOneWidget);
      await tester.tap(find.text('عربي'));
      await tester.pumpAndSettle();

      expect(find.text('English'), findsOneWidget);
    });
  });
}
