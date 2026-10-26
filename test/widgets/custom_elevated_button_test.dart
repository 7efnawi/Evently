import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:evently/widgets/custom_elevated_button.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  group('CustomElevatedButton Widget Tests', () {
    testWidgets('renders title and triggers onPressed when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomElevatedButton(
              title: 'Login',
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Login'), findsOneWidget);
      await tester.tap(find.text('Login'));
      expect(tapped, isTrue);
    });

    testWidgets('shows CircularProgressIndicator when isLoading is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomElevatedButton(
              title: 'Login',
              isLoading: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Login'), findsNothing);
    });
  });
}
