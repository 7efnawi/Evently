// test/screens/onboarding_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:evently/screens/onboarding/onboarding_screen.dart';
import 'package:evently/utils/app_routes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  setUp(() {
    SharedPreferences.setMockInitialValues({'is_first_time': true});
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      routes: {
        AppRoutes.login: (_) => const Scaffold(body: Text('Login Screen')),
      },
      home: const OnboardingScreen(),
    );
  }

  group('OnboardingScreen Carousel Tests', () {
    testWidgets('renders first slide and advances with next button', (tester) async {
      await tester.pumpWidget(buildTestableWidget());

      expect(find.text('Find Events That Inspire You'), findsOneWidget);

      // Tap next button
      await tester.tap(find.byKey(const Key('onboarding_next_button')));
      await tester.pumpAndSettle();

      expect(find.text('Effortless Event Planning'), findsOneWidget);

      // Tap next button to reach 3rd slide
      await tester.tap(find.byKey(const Key('onboarding_next_button')));
      await tester.pumpAndSettle();

      expect(find.text('Connect with Friends & Share Moments'), findsOneWidget);

      // Tap next button on last slide to finish onboarding
      await tester.tap(find.byKey(const Key('onboarding_next_button')));
      await tester.pumpAndSettle();

      expect(find.text('Login Screen'), findsOneWidget);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('is_first_time'), isFalse);
    });

    testWidgets('navigates backwards when back button is tapped', (tester) async {
      await tester.pumpWidget(buildTestableWidget());

      // Advance to 2nd slide
      await tester.tap(find.byKey(const Key('onboarding_next_button')));
      await tester.pumpAndSettle();
      expect(find.text('Effortless Event Planning'), findsOneWidget);

      // Tap back button
      await tester.tap(find.byKey(const Key('onboarding_back_button')));
      await tester.pumpAndSettle();
      expect(find.text('Find Events That Inspire You'), findsOneWidget);
    });
  });
}
