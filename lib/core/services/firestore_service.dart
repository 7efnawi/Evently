import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/event_model.dart';

class FirestoreService {
  FirebaseFirestore? _customFirestore;

  FirestoreService({FirebaseFirestore? firestore})
      : _customFirestore = firestore;

  FirebaseFirestore get _firestore => _customFirestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _userEventsRef(String uid) {
    return _firestore.collection('users').doc(uid).collection('events');
  }

  Future<void> createEvent(String uid, EventModel event) async {
    await _userEventsRef(uid).doc(event.id).set(event.toFirestoreMap());
  }

  Future<void> updateEvent(String uid, EventModel event) async {
    await _userEventsRef(uid).doc(event.id).update(event.toFirestoreMap());
  }

  Future<void> deleteEvent(String uid, String eventId) async {
    await _userEventsRef(uid).doc(eventId).delete();
  }

  Future<void> toggleFavorite(String uid, String eventId, bool isFavorite) async {
    await _userEventsRef(uid).doc(eventId).update({'isFavorite': isFavorite});
  }

  Future<List<EventModel>> getEvents(String uid) async {
    final snapshot = await _userEventsRef(uid).get();
    return snapshot.docs.map((doc) {
      final data = Map<String, dynamic>.from(doc.data());
      data['id'] = doc.id;
      return EventModel.fromMap(data);
    }).toList();
  }

  Stream<List<EventModel>> streamEvents(String uid) {
    return _userEventsRef(uid).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        return EventModel.fromMap(data);
      }).toList();
    });
  }

  Future<void> seedInitialEventsIfEmpty(String uid, List<EventModel> seedEvents) async {
    final existing = await _userEventsRef(uid).limit(1).get();
    if (existing.docs.isEmpty) {
      final batch = _firestore.batch();
      for (final event in seedEvents) {
        final docRef = _userEventsRef(uid).doc(event.id);
        batch.set(docRef, event.toFirestoreMap());
      }
      await batch.commit();
    }
  }
}
