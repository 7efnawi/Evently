import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:evently/widgets/custom_text_field.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  group('CustomTextField Widget Tests', () {
    testWidgets('renders hint text and accepts user input', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              hint: 'Enter Email',
              controller: controller,
            ),
          ),
        ),
      );

      expect(find.text('Enter Email'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'test@example.com');
      expect(controller.text, 'test@example.com');
    });

    testWidgets('toggles obscureText when isPassword is true', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              hint: 'Enter Password',
              isPassword: true,
            ),
          ),
        ),
      );

      final textFieldFinder = find.byType(TextField);
      TextField textField = tester.widget<TextField>(textFieldFinder);
      expect(textField.obscureText, isTrue);

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      textField = tester.widget<TextField>(textFieldFinder);
      expect(textField.obscureText, isFalse);
    });
  });
}
