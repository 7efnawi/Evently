import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:evently/providers/app_auth_provider.dart';
import 'package:evently/providers/app_events_provider.dart';
import 'package:evently/providers/app_theme_provider.dart';
import 'package:evently/providers/app_language_provider.dart';
import 'package:evently/screens/main_layout/main_layout_screen.dart';
import 'package:evently/screens/profile/profile_tab.dart';
import 'package:evently/utils/app_routes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget buildTestableWidget() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        ChangeNotifierProvider(create: (_) => AppThemeProvider()),
        ChangeNotifierProvider(create: (_) => AppLanguageProvider()),
        ChangeNotifierProvider(create: (_) => AppEventsProvider()),
      ],
      child: MaterialApp(
        routes: {
          AppRoutes.createEvent: (_) => const Scaffold(body: Text('Create Event Screen')),
        },
        home: const MainLayoutScreen(),
      ),
    );
  }

  group('MainLayoutScreen Widget Tests', () {
    testWidgets('renders 4 navigation tabs and centered Floating Action Button', (tester) async {
      await tester.pumpWidget(buildTestableWidget());

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Map'), findsOneWidget);
      expect(find.text('Love'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('switches to Profile tab when Profile item is tapped', (tester) async {
      await tester.pumpWidget(buildTestableWidget());

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      expect(find.byType(ProfileTab), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
    });

    testWidgets('switches to Map and Love tabs when tapped', (tester) async {
      await tester.pumpWidget(buildTestableWidget());

      await tester.tap(find.text('Map'));
      await tester.pumpAndSettle();
      expect(find.text('Map Screen'), findsOneWidget);

      await tester.tap(find.text('Love'));
      await tester.pumpAndSettle();
      expect(find.text('Favorites Screen'), findsOneWidget);

      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.text('Welcome Back ✨'), findsOneWidget);
    });

    testWidgets('tapping Floating Action Button triggers navigation to Create Event', (tester) async {
      await tester.pumpWidget(buildTestableWidget());

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('Create Event Screen'), findsOneWidget);
    });
  });
}
