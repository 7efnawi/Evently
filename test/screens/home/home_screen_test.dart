import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:evently/providers/app_events_provider.dart';
import 'package:evently/providers/app_auth_provider.dart';
import 'package:evently/providers/app_theme_provider.dart';
import 'package:evently/providers/app_language_provider.dart';
import 'package:evently/screens/home/home_screen.dart';
import 'package:evently/utils/app_routes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget buildTestableWidget(AppEventsProvider eventsProvider) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: eventsProvider),
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        ChangeNotifierProvider(create: (_) => AppThemeProvider()),
        ChangeNotifierProvider(create: (_) => AppLanguageProvider()),
      ],
      child: MaterialApp(
        routes: {
          AppRoutes.eventDetails: (_) => const Scaffold(body: Text('Event Details Screen')),
        },
        home: const HomeScreen(),
      ),
    );
  }

  group('HomeScreen Widget Tests', () {
    testWidgets('renders greeting, categories chips, and event cards', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final eventsProvider = AppEventsProvider();
      await eventsProvider.loadEvents();
      await tester.pumpWidget(buildTestableWidget(eventsProvider));
      await tester.pumpAndSettle();

      expect(find.text('Welcome Back ✨'), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Sport'), findsOneWidget);
      expect(find.text('Birthday'), findsOneWidget);
      expect(find.text('This is a Birthday Party '), findsOneWidget);
    });

    testWidgets('filtering by Birthday displays only Birthday events', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final eventsProvider = AppEventsProvider();
      await eventsProvider.loadEvents();
      await tester.pumpWidget(buildTestableWidget(eventsProvider));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Birthday'));
      await tester.pumpAndSettle();

      expect(find.text('This is a Birthday Party '), findsOneWidget);
      expect(find.text('We Are Going To Play Football'), findsNothing);
    });

    testWidgets('tapping event card navigates to EventDetailsScreen', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final eventsProvider = AppEventsProvider();
      await eventsProvider.loadEvents();
      await tester.pumpWidget(buildTestableWidget(eventsProvider));
      await tester.pumpAndSettle();

      await tester.tap(find.text('This is a Birthday Party '));
      await tester.pumpAndSettle();

      expect(find.text('Event Details Screen'), findsOneWidget);
    });
  });
}
