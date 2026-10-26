import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:evently/providers/app_auth_provider.dart';
import 'package:evently/screens/auth/forget_password_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget buildTestableWidget() {
    return ChangeNotifierProvider(
      create: (_) => AppAuthProvider(),
      child: const MaterialApp(
        home: ForgetPasswordScreen(),
      ),
    );
  }

  group('ForgetPasswordScreen Widget Tests', () {
    testWidgets('renders title, email field, and reset button', (tester) async {
      await tester.pumpWidget(buildTestableWidget());

      expect(find.text('Forget Password'), findsOneWidget);
      expect(find.text('Reset Password'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('validates email and shows SnackBar on success', (tester) async {
      await tester.pumpWidget(buildTestableWidget());

      // Empty email submission triggers validation
      await tester.tap(find.text('Reset Password'));
      await tester.pumpAndSettle();
      expect(find.text('Please enter a valid email address'), findsOneWidget);

      // Enter valid email and submit
      await tester.enterText(find.byType(TextFormField), 'valid@example.com');
      await tester.tap(find.text('Reset Password'));
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Password reset link sent to your email.'), findsOneWidget);
    });
  });
}
