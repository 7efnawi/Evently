import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:evently/l10n/app_localizations.dart';
import 'package:evently/providers/app_auth_provider.dart';
import 'package:evently/screens/auth/widgets/google_sign_in_bottom_sheet.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget buildTestableWidget(AppAuthProvider provider) {
    return ChangeNotifierProvider<AppAuthProvider>.value(
      value: provider,
      child: const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en'),
          Locale('ar'),
        ],
        home: Scaffold(body: GoogleSignInBottomSheet()),
      ),
    );
  }

  group('GoogleSignInBottomSheet Widget Tests', () {
    testWidgets('renders Google accounts list and header', (tester) async {
      final provider = AppAuthProvider();
      await tester.pumpWidget(buildTestableWidget(provider));
      await tester.pumpAndSettle();

      expect(find.text('Choose an account'), findsOneWidget);
      expect(find.text('to continue to Evently'), findsOneWidget);
      expect(find.text('Use another account'), findsOneWidget);
    });

    testWidgets('tapping an account signs in and registers the user', (tester) async {
      final provider = AppAuthProvider();
      await tester.pumpWidget(buildTestableWidget(provider));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ahmed Ali'));
      await tester.pumpAndSettle();

      expect(provider.isAuthenticated, isTrue);
      expect(provider.currentUser?.email, 'ahmed.ali@gmail.com');
    });
  });
}
