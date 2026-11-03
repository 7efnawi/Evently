import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:evently/main.dart';
import 'package:evently/providers/app_auth_provider.dart';
import 'package:evently/providers/app_events_provider.dart';
import 'package:evently/providers/app_language_provider.dart';
import 'package:evently/providers/app_theme_provider.dart';
import 'package:evently/screens/auth/login_screen.dart';
import 'package:evently/screens/event/create_event_screen.dart';
import 'package:evently/screens/favorites/favorites_tab.dart';
import 'package:evently/screens/home/home_screen.dart';
import 'package:evently/screens/home/widgets/event_card.dart';
import 'package:evently/screens/main_layout/main_layout_screen.dart';
import 'package:evently/screens/profile/profile_tab.dart';
import 'package:evently/screens/profile/widgets/language_bottom_sheet.dart';
import 'package:evently/screens/profile/widgets/theme_bottom_sheet.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  setUp(() {
    SharedPreferences.setMockInitialValues({'is_first_time': false});
  });

  Widget buildFullApp() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppThemeProvider()),
        ChangeNotifierProvider(create: (_) => AppLanguageProvider()),
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        ChangeNotifierProvider(create: (_) => AppEventsProvider()),
      ],
      child: const EventlyApp(),
    );
  }

  group('E2E User Journeys Integration Tests', () {
    testWidgets(
        'Complete lifecycle: Login -> MainLayout -> Create Event -> Favorite -> Profile -> Logout',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildFullApp());
      // Advance past splash timer (2000ms delay)
      await tester.pump(const Duration(milliseconds: 2100));
      await tester.pumpAndSettle();

      // Should be on Login Screen
      expect(find.byType(LoginScreen), findsOneWidget);

      // Perform Google Login via BottomSheet
      await tester.tap(find.text('Login With Google'));
      await tester.pumpAndSettle();

      expect(find.text('Choose an account'), findsOneWidget);
      await tester.tap(find.text('Ahmed Ali'));
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // Should navigate to MainLayoutScreen
      expect(find.byType(MainLayoutScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsOneWidget);

      // Tap Floating Action Button to open Create Event
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.byType(CreateEventScreen), findsOneWidget);

      // Fill in event title and description
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'E2E Tech Summit');
      await tester.enterText(
          textFields.at(1), 'Annual developer summit in Cairo');

      // Submit event
      await tester.ensureVisible(find.text('Add Event'));
      await tester.tap(find.text('Add Event'));
      await tester.pumpAndSettle();

      // Back on MainLayoutScreen, new event should be visible
      expect(find.byType(MainLayoutScreen), findsOneWidget);
      expect(find.text('E2E Tech Summit'), findsOneWidget);

      // Toggle favorite on the newly created event card
      final eventCard = find.ancestor(
        of: find.text('E2E Tech Summit'),
        matching: find.byType(EventCard),
      );
      final favoriteButton = find.descendant(
        of: eventCard,
        matching: find.byType(IconButton),
      );
      await tester.tap(favoriteButton);
      await tester.pumpAndSettle();

      // Navigate to Favorites tab
      await tester.tap(find.text('Love'));
      await tester.pumpAndSettle();
      expect(find.byType(FavoritesTab), findsOneWidget);
      expect(find.text('E2E Tech Summit'), findsOneWidget);

      // Navigate to Profile tab
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      expect(find.byType(ProfileTab), findsOneWidget);
      expect(find.text('Ahmed Ali'), findsOneWidget);

      // Logout
      await tester.ensureVisible(find.text('Logout'));
      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();

      // Back to LoginScreen
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets(
        'Email & Password authentication and profile settings journey',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildFullApp());
      await tester.pump(const Duration(milliseconds: 2100));
      await tester.pumpAndSettle();

      // On Login Screen
      expect(find.byType(LoginScreen), findsOneWidget);

      // Enter valid email and password
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'john@evently.com');
      await tester.enterText(textFields.at(1), 'password123');

      // Tap Login
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();

      // Should navigate to MainLayoutScreen
      expect(find.byType(MainLayoutScreen), findsOneWidget);

      // Open Profile Tab
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      expect(find.byType(ProfileTab), findsOneWidget);

      // Open Theme bottom sheet by tapping the setting selector
      await tester.tap(find.text('Light'));
      await tester.pumpAndSettle();
      expect(find.byType(ThemeBottomSheet), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);

      // Select Dark Theme
      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      // Open Language bottom sheet
      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();
      expect(find.byType(LanguageBottomSheet), findsOneWidget);
      expect(find.text('العربية'), findsOneWidget);

      // Dismiss bottom sheet by selecting English
      await tester.tap(find.text('English').last);
      await tester.pumpAndSettle();

      // Logout
      await tester.ensureVisible(find.text('Logout'));
      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
    });
  });
}
