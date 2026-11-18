import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:evently/core/services/pending_sync_queue.dart';
import 'package:evently/models/event_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late PendingSyncQueue queue;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    queue = PendingSyncQueue();
  });

  final sampleEvent = EventModel(
    id: 'op_event_1',
    title: 'Offline Event',
    description: 'Created with no internet.',
    category: EventCategory.sport,
    dateTime: DateTime(2026, 12, 1, 10, 0),
    location: 'Giza, Egypt',
    imagePath: 'assets/images/sport_banner.png',
    isFavorite: true,
  );

  group('PendingSyncQueue Tests', () {
    test('enqueues create operation and persists to SharedPreferences', () async {
      await queue.enqueue(SyncOperation(
        id: 'sync_1',
        type: SyncOpType.create,
        event: sampleEvent,
      ));

      final items = await queue.getOperations();
      expect(items.length, 1);
      expect(items.first.type, SyncOpType.create);
      expect(items.first.event?.id, 'op_event_1');
    });

    test('enqueues delete operation correctly', () async {
      await queue.enqueue(SyncOperation(
        id: 'sync_2',
        type: SyncOpType.delete,
        eventId: 'delete_me_123',
      ));

      final items = await queue.getOperations();
      expect(items.length, 1);
      expect(items.first.type, SyncOpType.delete);
      expect(items.first.eventId, 'delete_me_123');
    });

    test('remove deletes specific operation by id', () async {
      await queue.enqueue(SyncOperation(
        id: 'sync_a',
        type: SyncOpType.toggleFavorite,
        eventId: 'target_fav',
        isFavorite: true,
      ));
      await queue.enqueue(SyncOperation(
        id: 'sync_b',
        type: SyncOpType.delete,
        eventId: 'target_del',
      ));

      await queue.remove('sync_a');
      final items = await queue.getOperations();
      expect(items.length, 1);
      expect(items.first.id, 'sync_b');
    });

    test('clear removes all pending operations', () async {
      await queue.enqueue(SyncOperation(
        id: 'sync_x',
        type: SyncOpType.create,
        event: sampleEvent,
      ));

      await queue.clear();
      final items = await queue.getOperations();
      expect(items, isEmpty);
    });
  });
}
