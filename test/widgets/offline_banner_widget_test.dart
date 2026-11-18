import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:evently/core/services/connectivity_service.dart';
import 'package:evently/providers/app_events_provider.dart';
import 'package:evently/widgets/offline_banner_widget.dart';

class _FakeConnectivityService extends ConnectivityService {
  final bool status;
  _FakeConnectivityService(this.status);

  @override
  Future<bool> get isConnected async => status;

  @override
  Stream<bool> get onConnectivityChanged => Stream.value(status);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });
  testWidgets('OfflineBannerWidget displays warning text when offline', (tester) async {
    final offlineProvider = AppEventsProvider(
      connectivityService: _FakeConnectivityService(false),
    );
    await offlineProvider.loadEvents();

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<AppEventsProvider>.value(
          value: offlineProvider,
          child: const Scaffold(
            body: Column(
              children: [
                OfflineBannerWidget(),
                Text('Screen Content'),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(OfflineBannerWidget), findsOneWidget);
    expect(find.textContaining('Offline Mode'), findsOneWidget);
    expect(find.byIcon(Icons.wifi_off_rounded), findsOneWidget);
  });

  testWidgets('OfflineBannerWidget is hidden when online', (tester) async {
    final onlineProvider = AppEventsProvider(
      connectivityService: _FakeConnectivityService(true),
    );
    await onlineProvider.loadEvents();

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<AppEventsProvider>.value(
          value: onlineProvider,
          child: const Scaffold(
            body: Column(
              children: [
                OfflineBannerWidget(),
                Text('Screen Content'),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(OfflineBannerWidget), findsOneWidget);
    expect(find.textContaining('Offline Mode'), findsNothing);
  });
}
