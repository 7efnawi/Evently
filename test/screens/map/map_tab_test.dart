import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:evently/providers/app_events_provider.dart';
import 'package:evently/screens/map/map_tab.dart';
import 'package:evently/screens/map/widgets/map_event_card.dart';
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
        home: const Scaffold(body: MapTab()),
      ),
    );
  }

  group('MapTab Widget Tests', () {
    testWidgets('renders map background, GPS button, and bottom event cards',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final provider = AppEventsProvider();
      await provider.loadEvents();

      await tester.pumpWidget(buildTestableWidget(provider));
      await tester.pumpAndSettle();

      expect(find.byType(MapEventCard), findsWidgets);
      expect(find.byKey(const Key('gps_locate_btn')), findsOneWidget);
      expect(find.text(provider.events.first.title), findsOneWidget);
    });

    testWidgets('tapping map event card navigates to EventDetailsScreen',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final provider = AppEventsProvider();
      await provider.loadEvents();
      final firstEvent = provider.events.first;

      await tester.pumpWidget(buildTestableWidget(provider));
      await tester.pumpAndSettle();

      await tester.tap(find.text(firstEvent.title));
      await tester.pumpAndSettle();

      expect(find.text('Event Details Screen'), findsOneWidget);
    });
  });
}
