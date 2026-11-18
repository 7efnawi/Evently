import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:evently/core/services/firestore_service.dart';
import 'package:evently/models/event_model.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreService service;
  const testUid = 'user_123';

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    service = FirestoreService(firestore: fakeFirestore);
  });

  final testEvent = EventModel(
    id: 'event_test_1',
    title: 'Tech Meetup',
    description: 'Flutter & Firebase architecture deep dive.',
    category: EventCategory.meeting,
    dateTime: DateTime(2026, 11, 25, 18, 0),
    location: 'Cairo, Egypt',
    imagePath: 'assets/images/meeting_banner.png',
    isFavorite: false,
  );

  group('FirestoreService Tests', () {
    test('createEvent saves document in users/{uid}/events/{eventId}', () async {
      await service.createEvent(testUid, testEvent);

      final doc = await fakeFirestore
          .collection('users')
          .doc(testUid)
          .collection('events')
          .doc(testEvent.id)
          .get();

      expect(doc.exists, isTrue);
      expect(doc.data()?['title'], 'Tech Meetup');
      expect(doc.data()?['category'], 'meeting');
    });

    test('getEvents retrieves all user events', () async {
      await service.createEvent(testUid, testEvent);
      final events = await service.getEvents(testUid);

      expect(events.length, 1);
      expect(events.first.id, testEvent.id);
      expect(events.first.title, testEvent.title);
    });

    test('updateEvent updates existing document fields', () async {
      await service.createEvent(testUid, testEvent);
      final updated = testEvent.copyWith(title: 'Updated Tech Meetup', isFavorite: true);

      await service.updateEvent(testUid, updated);
      final events = await service.getEvents(testUid);

      expect(events.first.title, 'Updated Tech Meetup');
      expect(events.first.isFavorite, isTrue);
    });

    test('deleteEvent removes document from Firestore', () async {
      await service.createEvent(testUid, testEvent);
      await service.deleteEvent(testUid, testEvent.id);

      final events = await service.getEvents(testUid);
      expect(events, isEmpty);
    });

    test('toggleFavorite updates isFavorite field', () async {
      await service.createEvent(testUid, testEvent);
      await service.toggleFavorite(testUid, testEvent.id, true);

      final events = await service.getEvents(testUid);
      expect(events.first.isFavorite, isTrue);
    });

    test('streamEvents emits updated list on snapshot changes', () async {
      final stream = service.streamEvents(testUid);

      expectLater(
        stream,
        emitsInOrder([
          isEmpty,
          predicate<List<EventModel>>((list) => list.length == 1 && list.first.id == testEvent.id),
        ]),
      );

      await Future.delayed(const Duration(milliseconds: 10));
      await service.createEvent(testUid, testEvent);
    });

    test('seedInitialEventsIfEmpty only inserts when collection is empty', () async {
      final seeds = [
        testEvent,
        testEvent.copyWith(id: 'seed_2', title: 'Seed 2'),
      ];

      await service.seedInitialEventsIfEmpty(testUid, seeds);
      var events = await service.getEvents(testUid);
      expect(events.length, 2);

      // Call again — should NOT duplicate
      await service.seedInitialEventsIfEmpty(testUid, seeds);
      events = await service.getEvents(testUid);
      expect(events.length, 2);
    });
  });
}
