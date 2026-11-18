import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:evently/core/services/firestore_service.dart';
import 'package:evently/models/event_model.dart';
import 'package:evently/providers/app_events_provider.dart';
import 'package:evently/utils/app_images.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('AppEventsProvider Unit Tests', () {
    test('Initial events provider state loads default seed events or empty', () async {
      final provider = AppEventsProvider();
      await provider.loadEvents();

      expect(provider.events, isNotEmpty);
      expect(provider.selectedCategory, EventCategory.all);
      expect(provider.filteredEvents.length, provider.events.length);
    });

    test('createEvent adds event to list and notifies listeners', () async {
      final provider = AppEventsProvider();
      await provider.loadEvents();

      final initialCount = provider.events.length;
      final newEvent = EventModel(
        id: 'new_event_1',
        title: 'New Reading Club',
        description: 'Weekly reading meetup.',
        category: EventCategory.bookClub,
        dateTime: DateTime.now(),
        location: 'Maadi, Cairo',
        imagePath: AppImages.bookClubBanner,
      );

      final success = await provider.createEvent(newEvent);
      expect(success, isTrue);
      expect(provider.events.length, initialCount + 1);
      expect(provider.getEventById('new_event_1'), equals(newEvent));
    });

    test('updateEvent modifies event details correctly', () async {
      final provider = AppEventsProvider();
      await provider.loadEvents();

      final firstEvent = provider.events.first;
      final updated = firstEvent.copyWith(title: 'Modified Title 123');

      final success = await provider.updateEvent(updated);
      expect(success, isTrue);
      expect(provider.getEventById(firstEvent.id)?.title, 'Modified Title 123');
    });

    test('deleteEvent removes event from list', () async {
      final provider = AppEventsProvider();
      await provider.loadEvents();

      final firstId = provider.events.first.id;
      final success = await provider.deleteEvent(firstId);

      expect(success, isTrue);
      expect(provider.getEventById(firstId), isNull);
    });

    test('toggleFavorite updates favorite state and notifies listeners', () async {
      final provider = AppEventsProvider();
      await provider.loadEvents();

      final target = provider.events.first;
      final initialFav = target.isFavorite;

      await provider.toggleFavorite(target.id);
      expect(provider.getEventById(target.id)?.isFavorite, !initialFav);
    });

    test('setCategory filters events by category correctly', () async {
      final provider = AppEventsProvider();
      await provider.loadEvents();

      provider.setCategory(EventCategory.birthday);
      expect(provider.selectedCategory, EventCategory.birthday);
      for (final event in provider.filteredEvents) {
        expect(event.category, EventCategory.birthday);
      }

      provider.setCategory(EventCategory.all);
      expect(provider.filteredEvents.length, provider.events.length);
    });
  });

  group('AppEventsProvider Firestore Mode Tests', () {
    late FakeFirebaseFirestore fakeFirestore;
    late FirestoreService firestoreService;
    const testUid = 'user_cloud_999';

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      firestoreService = FirestoreService(firestore: fakeFirestore);
    });

    test('loadEvents seeds initial events into Firestore when collection is empty', () async {
      final provider = AppEventsProvider(
        firestoreService: firestoreService,
        uid: testUid,
      );
      await provider.loadEvents();

      expect(provider.events, isNotEmpty);
      final cloudEvents = await firestoreService.getEvents(testUid);
      expect(cloudEvents.length, provider.events.length);
    });

    test('createEvent adds event to Firestore and updates in-memory list', () async {
      final provider = AppEventsProvider(
        firestoreService: firestoreService,
        uid: testUid,
      );
      await provider.loadEvents();

      final newEvent = EventModel(
        id: 'cloud_new_1',
        title: 'Cloud Marathon',
        description: 'Running event in Cairo.',
        category: EventCategory.sport,
        dateTime: DateTime.now(),
        location: 'Zamalek',
        imagePath: AppImages.sportBanner,
      );

      final success = await provider.createEvent(newEvent);
      expect(success, isTrue);
      expect(provider.getEventById('cloud_new_1'), equals(newEvent));

      final cloudDoc = await fakeFirestore
          .collection('users')
          .doc(testUid)
          .collection('events')
          .doc('cloud_new_1')
          .get();
      expect(cloudDoc.exists, isTrue);
    });

    test('updateEvent updates event in Firestore', () async {
      final provider = AppEventsProvider(
        firestoreService: firestoreService,
        uid: testUid,
      );
      await provider.loadEvents();

      final first = provider.events.first;
      final updated = first.copyWith(title: 'Updated in Cloud');

      final success = await provider.updateEvent(updated);
      expect(success, isTrue);
      expect(provider.getEventById(first.id)?.title, 'Updated in Cloud');

      final cloudDoc = await fakeFirestore
          .collection('users')
          .doc(testUid)
          .collection('events')
          .doc(first.id)
          .get();
      expect(cloudDoc.data()?['title'], 'Updated in Cloud');
    });

    test('deleteEvent removes event from Firestore', () async {
      final provider = AppEventsProvider(
        firestoreService: firestoreService,
        uid: testUid,
      );
      await provider.loadEvents();

      final firstId = provider.events.first.id;
      final success = await provider.deleteEvent(firstId);
      expect(success, isTrue);
      expect(provider.getEventById(firstId), isNull);

      final cloudDoc = await fakeFirestore
          .collection('users')
          .doc(testUid)
          .collection('events')
          .doc(firstId)
          .get();
      expect(cloudDoc.exists, isFalse);
    });

    test('toggleFavorite updates isFavorite in Firestore', () async {
      final provider = AppEventsProvider(
        firestoreService: firestoreService,
        uid: testUid,
      );
      await provider.loadEvents();

      final first = provider.events.first;
      final originalFav = first.isFavorite;

      await provider.toggleFavorite(first.id);
      expect(provider.getEventById(first.id)?.isFavorite, !originalFav);

      final cloudDoc = await fakeFirestore
          .collection('users')
          .doc(testUid)
          .collection('events')
          .doc(first.id)
          .get();
      expect(cloudDoc.data()?['isFavorite'], !originalFav);
    });

    test('updateUid changes active user and reloads events', () async {
      final provider = AppEventsProvider(
        firestoreService: firestoreService,
        uid: testUid,
      );
      await provider.loadEvents();
      expect(provider.events, isNotEmpty);

      // Switch to different user
      provider.updateUid('different_user_empty');
      await Future.delayed(const Duration(milliseconds: 20));
      expect(provider.events, isNotEmpty);
      expect(provider.currentUid, 'different_user_empty');
    });
  });
}
