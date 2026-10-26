import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:evently/providers/app_auth_provider.dart';
import 'package:evently/screens/auth/register_screen.dart';
import 'package:evently/utils/app_routes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget buildTestableWidget() {
    return ChangeNotifierProvider(
      create: (_) => AppAuthProvider(),
      child: MaterialApp(
        routes: {
          AppRoutes.mainLayout: (_) => const Scaffold(body: Text('Main Dashboard')),
        },
        home: const RegisterScreen(),
      ),
    );
  }

  group('RegisterScreen Widget Tests', () {
    testWidgets('renders all registration fields and buttons', (tester) async {
      await tester.pumpWidget(buildTestableWidget());

      expect(find.text('Register'), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(4)); // Name, Email, Password, RePassword
    });

    testWidgets('validates password mismatch and prevents submission', (tester) async {
      await tester.pumpWidget(buildTestableWidget());

      final inputs = find.byType(TextFormField);
      await tester.enterText(inputs.at(0), 'John Doe');
      await tester.enterText(inputs.at(1), 'john@example.com');
      await tester.enterText(inputs.at(2), 'password123');
      await tester.enterText(inputs.at(3), 'different_password');

      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match'), findsOneWidget);
      expect(find.text('Main Dashboard'), findsNothing);
    });

    testWidgets('registers successfully when valid and navigates to main layout', (tester) async {
      await tester.pumpWidget(buildTestableWidget());

      final inputs = find.byType(TextFormField);
      await tester.enterText(inputs.at(0), 'John Doe');
      await tester.enterText(inputs.at(1), 'john@example.com');
      await tester.enterText(inputs.at(2), 'password123');
      await tester.enterText(inputs.at(3), 'password123');

      await tester.tap(find.text('Create Account'));
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();

      expect(find.text('Main Dashboard'), findsOneWidget);
    });
  });
}
