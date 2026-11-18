import 'dart:async';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:evently/core/services/connectivity_service.dart';
import 'package:evently/core/services/firestore_service.dart';
import 'package:evently/core/services/pending_sync_queue.dart';
import 'package:evently/models/event_model.dart';
import 'package:evently/providers/app_events_provider.dart';

class _FakeConnectivityService extends ConnectivityService {
  bool onlineStatus;
  final _controller = StreamController<bool>.broadcast();

  _FakeConnectivityService({this.onlineStatus = true});

  @override
  Future<bool> get isConnected async => onlineStatus;

  @override
  Stream<bool> get onConnectivityChanged => _controller.stream;

  void toggleOnline(bool status) {
    onlineStatus = status;
    _controller.add(status);
  }

  void dispose() {
    _controller.close();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreService firestoreService;
  late PendingSyncQueue queue;
  late _FakeConnectivityService connectivity;
  const testUid = 'offline_user_777';

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    fakeFirestore = FakeFirebaseFirestore();
    firestoreService = FirestoreService(firestore: fakeFirestore);
    queue = PendingSyncQueue();
    connectivity = _FakeConnectivityService(onlineStatus: false); // Start offline
  });

  tearDown(() {
    connectivity.dispose();
  });

  group('AppEventsProvider Offline & Optimistic UI Tests', () {
    test('createEvent updates in-memory list immediately when offline and enqueues operation', () async {
      final provider = AppEventsProvider(
        firestoreService: firestoreService,
        connectivityService: connectivity,
        pendingQueue: queue,
        uid: testUid,
      );
      await provider.loadEvents();

      final newEvent = EventModel(
        id: 'optimistic_event_1',
        title: 'Instant UI Event',
        description: 'Should show on UI with 0 latency.',
        category: EventCategory.meeting,
        dateTime: DateTime.now(),
        location: 'Cairo',
        imagePath: 'assets/images/meeting_banner.png',
      );

      final result = await provider.createEvent(newEvent);
      expect(result, isTrue);

      // Instant optimistic UI update
      expect(provider.events.any((e) => e.id == 'optimistic_event_1'), isTrue);

      // Verify operation enqueued in SharedPreferences
      final pending = await queue.getOperations();
      expect(pending.any((op) => op.eventId == 'optimistic_event_1'), isTrue);
    });

    test('reconnecting online automatically flushes queue and writes to Firestore', () async {
      final provider = AppEventsProvider(
        firestoreService: firestoreService,
        connectivityService: connectivity,
        pendingQueue: queue,
        uid: testUid,
      );
      await provider.loadEvents();

      final offlineEvent = EventModel(
        id: 'sync_me_to_cloud',
        title: 'Sync To Cloud Event',
        description: 'Syncs on reconnection.',
        category: EventCategory.birthday,
        dateTime: DateTime.now(),
        location: 'Alexandria',
        imagePath: 'assets/images/birthday_banner.png',
      );

      await provider.createEvent(offlineEvent);
      expect((await queue.getOperations()).isNotEmpty, isTrue);

      // Reconnect online!
      connectivity.toggleOnline(true);
      await Future.delayed(const Duration(milliseconds: 20));
      await provider.syncPendingOperations();

      // Cloud document now exists in Firestore
      final cloudDoc = await fakeFirestore
          .collection('users')
          .doc(testUid)
          .collection('events')
          .doc('sync_me_to_cloud')
          .get();

      expect(cloudDoc.exists, isTrue);
      expect(cloudDoc.data()?['title'], 'Sync To Cloud Event');

      // Queue is cleared
      final remaining = await queue.getOperations();
      expect(remaining, isEmpty);
    });

    test('toggleFavorite updates immediately offline and queues sync', () async {
      final provider = AppEventsProvider(
        firestoreService: firestoreService,
        connectivityService: connectivity,
        pendingQueue: queue,
        uid: testUid,
      );
      await provider.loadEvents();

      final firstEvent = provider.events.first;
      final originalFav = firstEvent.isFavorite;

      await provider.toggleFavorite(firstEvent.id);
      expect(provider.getEventById(firstEvent.id)?.isFavorite, !originalFav);

      final pending = await queue.getOperations();
      expect(pending.any((op) => op.type == SyncOpType.toggleFavorite && op.eventId == firstEvent.id), isTrue);
    });

    test('deleteEvent updates immediately offline and queues sync', () async {
      final provider = AppEventsProvider(
        firestoreService: firestoreService,
        connectivityService: connectivity,
        pendingQueue: queue,
        uid: testUid,
      );
      await provider.loadEvents();

      final firstId = provider.events.first.id;
      final result = await provider.deleteEvent(firstId);
      expect(result, isTrue);
      expect(provider.getEventById(firstId), isNull);

      final pending = await queue.getOperations();
      expect(pending.any((op) => op.type == SyncOpType.delete && op.eventId == firstId), isTrue);
    });
  });
}
