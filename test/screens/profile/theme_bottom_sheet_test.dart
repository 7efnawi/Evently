import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:evently/providers/app_theme_provider.dart';
import 'package:evently/screens/profile/widgets/theme_bottom_sheet.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  Widget buildTestableWidget(AppThemeProvider provider) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: const MaterialApp(
        home: Scaffold(
          body: ThemeBottomSheet(),
        ),
      ),
    );
  }

  group('ThemeBottomSheet Widget Tests', () {
    testWidgets('renders Light and Dark options and checkmark for active theme', (tester) async {
      final provider = AppThemeProvider();
      await tester.pumpWidget(buildTestableWidget(provider));

      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget); // Light is default
    });

    testWidgets('tapping Dark changes theme to dark and pops modal', (tester) async {
      final provider = AppThemeProvider();
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: provider,
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => const ThemeBottomSheet(),
                    );
                  },
                  child: const Text('Open Sheet'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      expect(find.text('Dark'), findsOneWidget);
      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      expect(provider.themeMode, ThemeMode.dark);
      expect(find.byType(ThemeBottomSheet), findsNothing);
    });
  });
}
