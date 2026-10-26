import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:evently/providers/app_theme_provider.dart';
import 'package:evently/providers/app_language_provider.dart';
import 'package:evently/screens/onboarding/onboarding_setup_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget buildTestableWidget() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppThemeProvider()),
        ChangeNotifierProvider(create: (_) => AppLanguageProvider()),
      ],
      child: const MaterialApp(
        home: OnboardingSetupScreen(),
      ),
    );
  }

  group('OnboardingSetupScreen Widget Tests', () {
    testWidgets('renders title, description and triggers language toggle', (tester) async {
      await tester.pumpWidget(buildTestableWidget());

      expect(find.text('Personalize Your Experience'), findsOneWidget);
      expect(find.text("Let's Start"), findsOneWidget);

      // Tap on Arabic option
      await tester.tap(find.text('عربي'));
      await tester.pump();

      final languageProvider = tester.element(find.byType(OnboardingSetupScreen)).read<AppLanguageProvider>();
      expect(languageProvider.isEnglish, isFalse);
    });

    testWidgets('triggers theme toggle when dark mode button is tapped', (tester) async {
      await tester.pumpWidget(buildTestableWidget());

      // Tap on Dark theme icon / toggle
      await tester.tap(find.byKey(const Key('theme_dark_button')));
      await tester.pump();

      final themeProvider = tester.element(find.byType(OnboardingSetupScreen)).read<AppThemeProvider>();
      expect(themeProvider.isDarkMode, isTrue);
    });
  });
}
