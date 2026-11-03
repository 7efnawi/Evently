import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:evently/models/event_model.dart';
import 'package:evently/providers/app_events_provider.dart';
import 'package:evently/screens/favorites/favorites_tab.dart';
import 'package:evently/utils/app_images.dart';
import 'package:evently/utils/app_routes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget buildTestableWidget(AppEventsProvider provider) {
    return ChangeNotifierProvider<AppEventsProvider>.value(
      value: provider,
      child: MaterialApp(
        routes: {
          AppRoutes.eventDetails: (_) =>
              const Scaffold(body: Text('Event Details Screen')),
        },
        home: const Scaffold(body: FavoritesTab()),
      ),
    );
  }

  group('FavoritesTab Widget Tests', () {
    testWidgets('renders search field and empty state when no favorites exist',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final provider = AppEventsProvider();
      await provider.loadEvents();

      // Ensure no favorites initially
      for (final event in provider.events) {
        if (event.isFavorite) {
          await provider.toggleFavorite(event.id);
        }
      }

      await tester.pumpWidget(buildTestableWidget(provider));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('No favorite events yet'), findsOneWidget);
    });

    testWidgets('displays favorite events when favorites exist', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final provider = AppEventsProvider();
      await provider.loadEvents();

      // Mark first event as favorite
      final firstId = provider.events.first.id;
      if (!provider.getEventById(firstId)!.isFavorite) {
        await provider.toggleFavorite(firstId);
      }

      await tester.pumpWidget(buildTestableWidget(provider));
      await tester.pumpAndSettle();

      expect(find.text(provider.getEventById(firstId)!.title), findsOneWidget);
      expect(find.text('No favorite events yet'), findsNothing);
    });

    testWidgets('live search filters favorite events by query', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final provider = AppEventsProvider();
      await provider.loadEvents();

      // Add two distinct favorite events
      final event1 = EventModel(
        id: 'fav_1',
        title: 'Flutter Cairo Meetup',
        description: 'Tech talk',
        category: EventCategory.meeting,
        dateTime: DateTime.now(),
        location: 'Cairo , Egypt',
        imagePath: AppImages.meetingBanner,
        isFavorite: true,
      );
      final event2 = EventModel(
        id: 'fav_2',
        title: 'Swimming Championship',
        description: 'Sports event',
        category: EventCategory.sport,
        dateTime: DateTime.now(),
        location: 'Alexandria',
        imagePath: AppImages.sportBanner,
        isFavorite: true,
      );

      await provider.createEvent(event1);
      await provider.createEvent(event2);

      await tester.pumpWidget(buildTestableWidget(provider));
      await tester.pumpAndSettle();

      expect(find.text('Flutter Cairo Meetup'), findsOneWidget);
      expect(find.text('Swimming Championship'), findsOneWidget);

      // Search for 'Swimming'
      await tester.enterText(find.byType(TextField), 'Swimming');
      await tester.pumpAndSettle();

      expect(find.text('Swimming Championship'), findsOneWidget);
      expect(find.text('Flutter Cairo Meetup'), findsNothing);
    });

    testWidgets('tapping event card navigates to EventDetailsScreen',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final provider = AppEventsProvider();
      await provider.loadEvents();

      final firstId = provider.events.first.id;
      if (!provider.getEventById(firstId)!.isFavorite) {
        await provider.toggleFavorite(firstId);
      }

      await tester.pumpWidget(buildTestableWidget(provider));
      await tester.pumpAndSettle();

      await tester.tap(find.text(provider.getEventById(firstId)!.title));
      await tester.pumpAndSettle();

      expect(find.text('Event Details Screen'), findsOneWidget);
    });
  });
}
