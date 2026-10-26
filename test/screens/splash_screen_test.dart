import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:evently/screens/splash/splash_screen.dart';
import 'package:evently/utils/app_routes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SplashScreen Widget Tests', () {
    testWidgets('renders Evently logo title and Route footer', (tester) async {
      SharedPreferences.setMockInitialValues({'is_first_time': false});

      await tester.pumpWidget(
        MaterialApp(
          routes: {
            AppRoutes.splash: (_) => const SplashScreen(navigationDelayMs: 50),
            AppRoutes.login: (_) => const Scaffold(body: Text('Login Screen')),
            AppRoutes.onboarding: (_) => const Scaffold(body: Text('Onboarding Screen')),
          },
          initialRoute: AppRoutes.splash,
        ),
      );

      expect(find.text('Evently'), findsOneWidget);
      expect(find.text('Supervised by Route'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      expect(find.text('Login Screen'), findsOneWidget);
    });

    testWidgets('navigates to Onboarding when is_first_time is true or unset', (tester) async {
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(
        MaterialApp(
          routes: {
            AppRoutes.splash: (_) => const SplashScreen(navigationDelayMs: 50),
            AppRoutes.onboarding: (_) => const Scaffold(body: Text('Onboarding Screen')),
            AppRoutes.login: (_) => const Scaffold(body: Text('Login Screen')),
          },
          initialRoute: AppRoutes.splash,
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      expect(find.text('Onboarding Screen'), findsOneWidget);
    });
  });
}
