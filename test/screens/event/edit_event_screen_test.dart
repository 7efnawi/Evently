import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:evently/models/event_model.dart';
import 'package:evently/providers/app_events_provider.dart';
import 'package:evently/screens/event/edit_event_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget buildTestableWidget(AppEventsProvider provider, EventModel event) {
    return ChangeNotifierProvider<AppEventsProvider>.value(
      value: provider,
      child: MaterialApp(
        home: EditEventScreen(event: event),
      ),
    );
  }

  group('EditEventScreen Widget Tests', () {
    testWidgets('pre-fills event fields and updates event on submission', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final provider = AppEventsProvider();
      await provider.loadEvents();
      final targetEvent = provider.events.first;

      await tester.pumpWidget(buildTestableWidget(provider, targetEvent));
      await tester.pumpAndSettle();

      expect(find.text('Edit Event'), findsOneWidget);
      expect(find.text('Update Event'), findsOneWidget);
      expect(find.text(targetEvent.title), findsOneWidget);
      expect(find.text(targetEvent.description), findsOneWidget);

      final titleField = find.byType(TextFormField).first;
      await tester.enterText(titleField, 'Completely Changed Title');

      await tester.ensureVisible(find.text('Update Event'));
      await tester.tap(find.text('Update Event'));
      await tester.pumpAndSettle();

      expect(provider.getEventById(targetEvent.id)?.title, 'Completely Changed Title');
    });

    testWidgets('validates required fields on submission', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final provider = AppEventsProvider();
      await provider.loadEvents();
      final targetEvent = provider.events.first;

      await tester.pumpWidget(buildTestableWidget(provider, targetEvent));
      await tester.pumpAndSettle();

      final titleField = find.byType(TextFormField).first;
      await tester.enterText(titleField, '');

      await tester.ensureVisible(find.text('Update Event'));
      await tester.tap(find.text('Update Event'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter title'), findsOneWidget);
    });

    testWidgets('changing category updates category selection and banner', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final provider = AppEventsProvider();
      await provider.loadEvents();
      // targetEvent is birthday (or first seed event)
      final targetEvent = provider.events.first;

      await tester.pumpWidget(buildTestableWidget(provider, targetEvent));
      await tester.pumpAndSettle();

      // Change category to Meeting
      await tester.tap(find.text('Meeting'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Update Event'));
      await tester.tap(find.text('Update Event'));
      await tester.pumpAndSettle();

      expect(provider.getEventById(targetEvent.id)?.category, EventCategory.meeting);
    });

    testWidgets('initializes correctly from route arguments when event not passed directly', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final provider = AppEventsProvider();
      await provider.loadEvents();
      final targetEvent = provider.events.first;

      await tester.pumpWidget(
        ChangeNotifierProvider<AppEventsProvider>.value(
          value: provider,
          child: MaterialApp(
            home: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      settings: RouteSettings(arguments: targetEvent),
                      builder: (_) => const EditEventScreen(),
                    ),
                  );
                },
                child: const Text('Open Edit'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Edit'));
      await tester.pumpAndSettle();

      expect(find.text('Edit Event'), findsOneWidget);
      expect(find.text(targetEvent.title), findsOneWidget);
    });
  });
}
