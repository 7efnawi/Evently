import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:evently/providers/app_events_provider.dart';
import 'package:evently/screens/event/event_details_screen.dart';
import 'package:evently/utils/app_routes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget buildTestableWidget(AppEventsProvider provider, String eventId) {
    return ChangeNotifierProvider<AppEventsProvider>.value(
      value: provider,
      child: MaterialApp(
        routes: {
          AppRoutes.editEvent: (_) => const Scaffold(body: Text('Edit Event Screen')),
        },
        home: EventDetailsScreen(eventId: eventId),
      ),
    );
  }

  group('EventDetailsScreen Widget Tests', () {
    testWidgets('renders event details, edit and delete buttons', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final provider = AppEventsProvider();
      await provider.loadEvents();
      final targetEvent = provider.events.first;

      await tester.pumpWidget(buildTestableWidget(provider, targetEvent.id));
      await tester.pumpAndSettle();

      expect(find.text('Event Details'), findsOneWidget);
      expect(find.text(targetEvent.title), findsOneWidget);
      expect(find.text(targetEvent.location), findsOneWidget);
      expect(find.text(targetEvent.description), findsOneWidget);
      expect(find.byKey(const Key('edit_event_btn')), findsOneWidget);
      expect(find.byKey(const Key('delete_event_btn')), findsOneWidget);
    });

    testWidgets('tapping edit button navigates to EditEventScreen', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final provider = AppEventsProvider();
      await provider.loadEvents();
      final targetEvent = provider.events.first;

      await tester.pumpWidget(buildTestableWidget(provider, targetEvent.id));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('edit_event_btn')));
      await tester.pumpAndSettle();

      expect(find.text('Edit Event Screen'), findsOneWidget);
    });

    testWidgets('tapping delete button opens confirmation dialog and deletes event', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final provider = AppEventsProvider();
      await provider.loadEvents();
      final targetEvent = provider.events.first;

      await tester.pumpWidget(buildTestableWidget(provider, targetEvent.id));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('delete_event_btn')));
      await tester.pumpAndSettle();

      expect(find.text('Delete Event'), findsWidgets);
      expect(find.text('Are you sure you want to delete this event?'), findsOneWidget);
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(provider.getEventById(targetEvent.id), isNull);
    });

    testWidgets('displays not found message when event does not exist', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final provider = AppEventsProvider();
      await provider.loadEvents();

      await tester.pumpWidget(buildTestableWidget(provider, 'non_existent_id'));
      await tester.pumpAndSettle();

      expect(find.text('Event not found'), findsOneWidget);
    });
  });
}
