import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:evently/models/event_model.dart';
import 'package:evently/providers/app_events_provider.dart';
import 'package:evently/screens/event/create_event_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget buildTestableWidget(AppEventsProvider provider) {
    return ChangeNotifierProvider<AppEventsProvider>.value(
      value: provider,
      child: const MaterialApp(
        home: CreateEventScreen(),
      ),
    );
  }

  group('CreateEventScreen Widget Tests', () {
    testWidgets('renders all fields, chips, and Add Event button', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final provider = AppEventsProvider();
      await tester.pumpWidget(buildTestableWidget(provider));
      await tester.pumpAndSettle();

      expect(find.text('Create Event'), findsOneWidget);
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Event Date'), findsOneWidget);
      expect(find.text('Event Time'), findsOneWidget);
      expect(find.text('Location'), findsOneWidget);
      expect(find.text('Add Event'), findsOneWidget);
    });

    testWidgets('validates required fields on submission', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final provider = AppEventsProvider();
      await tester.pumpWidget(buildTestableWidget(provider));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Add Event'));
      await tester.tap(find.text('Add Event'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter event title'), findsOneWidget);
      expect(find.text('Please enter event description'), findsOneWidget);
    });

    testWidgets('creates event and pops screen when valid', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final provider = AppEventsProvider();
      await tester.pumpWidget(buildTestableWidget(provider));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Graduation Ceremony');
      await tester.enterText(textFields.at(1), 'Annual celebration event for students.');

      await tester.ensureVisible(find.text('Add Event'));
      await tester.tap(find.text('Add Event'));
      await tester.pumpAndSettle();

      final created = provider.events.firstWhere((e) => e.title == 'Graduation Ceremony');
      expect(created, isNotNull);
      expect(created.category, EventCategory.sport); // default category
    });

    testWidgets('selecting different category updates selected category', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final provider = AppEventsProvider();
      await tester.pumpWidget(buildTestableWidget(provider));
      await tester.pumpAndSettle();

      // Tap Birthday category chip
      await tester.tap(find.text('Birthday'));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Birthday Celebration');
      await tester.enterText(textFields.at(1), 'Come party with us!');

      await tester.ensureVisible(find.text('Add Event'));
      await tester.tap(find.text('Add Event'));
      await tester.pumpAndSettle();

      final created = provider.events.firstWhere((e) => e.title == 'Birthday Celebration');
      expect(created.category, EventCategory.birthday);
    });
  });
}
