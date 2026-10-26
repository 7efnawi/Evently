import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:evently/providers/app_language_provider.dart';
import 'package:evently/screens/profile/widgets/language_bottom_sheet.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  Widget buildTestableWidget(AppLanguageProvider provider) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: const MaterialApp(
        home: Scaffold(
          body: LanguageBottomSheet(),
        ),
      ),
    );
  }

  group('LanguageBottomSheet Widget Tests', () {
    testWidgets('renders English and Arabic options and checkmark for selected', (tester) async {
      final provider = AppLanguageProvider();
      await tester.pumpWidget(buildTestableWidget(provider));

      expect(find.text('English'), findsOneWidget);
      expect(find.text('العربية'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget); // English is default
    });

    testWidgets('tapping Arabic changes language and pops modal', (tester) async {
      final provider = AppLanguageProvider();
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
                      builder: (_) => const LanguageBottomSheet(),
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

      expect(find.text('العربية'), findsOneWidget);
      await tester.tap(find.text('العربية'));
      await tester.pumpAndSettle();

      expect(provider.appLocale.languageCode, 'ar');
      expect(find.byType(LanguageBottomSheet), findsNothing);
    });
  });
}
