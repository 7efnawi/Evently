import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/services/connectivity_service.dart';
import '../core/services/firestore_service.dart';
import '../core/services/pending_sync_queue.dart';
import '../models/event_model.dart';
import '../utils/app_images.dart';

class AppEventsProvider extends ChangeNotifier {
  static const String _storageKey = 'evently_stored_events';

  final FirestoreService _firestoreService;
  final ConnectivityService _connectivityService;
  final PendingSyncQueue _pendingQueue;
  final bool _hasCustomService;

  String? _uid;
  StreamSubscription<List<EventModel>>? _eventsSubscription;
  StreamSubscription<bool>? _connectivitySubscription;

  List<EventModel> _events = [];
  EventCategory _selectedCategory = EventCategory.all;
  bool _isLoading = false;
  bool _isOnline = true;

  List<EventModel> get events => List.unmodifiable(_events);
  EventCategory get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  bool get isOnline => _isOnline;
  String? get currentUid => _uid;

  List<EventModel> get filteredEvents {
    if (_selectedCategory == EventCategory.all) {
      return List.unmodifiable(_events);
    }
    return List.unmodifiable(
      _events.where((event) => event.category == _selectedCategory),
    );
  }

  List<EventModel> get favoriteEvents {
    return List.unmodifiable(
      _events.where((event) => event.isFavorite),
    );
  }

  bool get _isFirebaseConfigured {
    try {
      return Firebase.apps.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  bool get _shouldUseFirestore =>
      (_hasCustomService || _isFirebaseConfigured) && (_uid != null && _uid!.isNotEmpty);

  AppEventsProvider({
    FirestoreService? firestoreService,
    ConnectivityService? connectivityService,
    PendingSyncQueue? pendingQueue,
    String? uid,
  })  : _firestoreService = firestoreService ?? FirestoreService(),
        _hasCustomService = firestoreService != null,
        _connectivityService = connectivityService ?? ConnectivityService(),
        _pendingQueue = pendingQueue ?? PendingSyncQueue(),
        _uid = uid {
    _initConnectivity();
    loadEvents();
  }

  Future<void> _initConnectivity() async {
    try {
      _isOnline = await _connectivityService.isConnected;
    } catch (_) {
      _isOnline = true;
    }

    _connectivitySubscription = _connectivityService.onConnectivityChanged.listen((online) {
      final wasOffline = !_isOnline;
      _isOnline = online;
      notifyListeners();
      if (wasOffline && online) {
        syncPendingOperations();
      }
    });
  }

  void updateUid(String? newUid) {
    if (_uid != newUid) {
      _uid = newUid;
      _eventsSubscription?.cancel();
      _eventsSubscription = null;
      loadEvents();
    }
  }

  Future<void> loadEvents() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_shouldUseFirestore) {
        final seeds = _generateInitialSeedEvents();
        await _firestoreService.seedInitialEventsIfEmpty(_uid!, seeds);

        _eventsSubscription?.cancel();
        _eventsSubscription = _firestoreService.streamEvents(_uid!).listen(
          (cloudEvents) {
            _events = cloudEvents;
            _saveToStorage();
            _isLoading = false;
            notifyListeners();
          },
          onError: (_) {
            _loadLocalFallback();
          },
        );

        final initial = await _firestoreService.getEvents(_uid!);
        if (initial.isNotEmpty) {
          _events = initial;
          await _saveToStorage();
        } else {
          await _loadLocalFallback();
        }
      } else {
        await _loadLocalFallback();
      }
    } catch (_) {
      await _loadLocalFallback();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> syncPendingOperations() async {
    if (!_shouldUseFirestore || _uid == null || _uid!.isEmpty) return;

    final operations = await _pendingQueue.getOperations();
    for (final op in operations) {
      try {
        switch (op.type) {
          case SyncOpType.create:
            if (op.event != null) {
              await _firestoreService.createEvent(_uid!, op.event!);
            }
            break;
          case SyncOpType.update:
            if (op.event != null) {
              await _firestoreService.updateEvent(_uid!, op.event!);
            }
            break;
          case SyncOpType.delete:
            if (op.eventId != null) {
              await _firestoreService.deleteEvent(_uid!, op.eventId!);
            }
            break;
          case SyncOpType.toggleFavorite:
            if (op.eventId != null && op.isFavorite != null) {
              await _firestoreService.toggleFavorite(_uid!, op.eventId!, op.isFavorite!);
            }
            break;
        }
        await _pendingQueue.remove(op.id);
      } catch (_) {
        // Leave in queue for next sync cycle
      }
    }
  }

  Future<void> _loadLocalFallback() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedString = prefs.getString(_storageKey);

      if (storedString != null && storedString.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(storedString);
        _events = decoded
            .map((item) => EventModel.fromMap(Map<String, dynamic>.from(item as Map)))
            .toList();
      } else {
        _events = _generateInitialSeedEvents();
        await _saveToStorage();
      }
    } catch (_) {
      _events = _generateInitialSeedEvents();
    }
  }

  void setCategory(EventCategory category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      notifyListeners();
    }
  }

  Future<bool> createEvent(EventModel event) async {
    // 1. Optimistic UI update
    _events.insert(0, event);
    notifyListeners();
    await _saveToStorage();

    // 2. Cloud sync or queue
    if (_shouldUseFirestore) {
      if (_isOnline) {
        try {
          await _firestoreService.createEvent(_uid!, event);
          return true;
        } catch (_) {
          await _enqueueOperation(SyncOpType.create, event: event);
          return true;
        }
      } else {
        await _enqueueOperation(SyncOpType.create, event: event);
        return true;
      }
    }

    return true;
  }

  Future<bool> updateEvent(EventModel updatedEvent) async {
    // 1. Optimistic UI update
    final index = _events.indexWhere((e) => e.id == updatedEvent.id);
    if (index != -1) {
      _events[index] = updatedEvent;
      notifyListeners();
      await _saveToStorage();
    }

    // 2. Cloud sync or queue
    if (_shouldUseFirestore) {
      if (_isOnline) {
        try {
          await _firestoreService.updateEvent(_uid!, updatedEvent);
          return true;
        } catch (_) {
          await _enqueueOperation(SyncOpType.update, event: updatedEvent);
          return true;
        }
      } else {
        await _enqueueOperation(SyncOpType.update, event: updatedEvent);
        return true;
      }
    }

    return index != -1;
  }

  Future<bool> deleteEvent(String eventId) async {
    // 1. Optimistic UI update
    final index = _events.indexWhere((e) => e.id == eventId);
    if (index != -1) {
      _events.removeAt(index);
      notifyListeners();
      await _saveToStorage();
    }

    // 2. Cloud sync or queue
    if (_shouldUseFirestore) {
      if (_isOnline) {
        try {
          await _firestoreService.deleteEvent(_uid!, eventId);
          return true;
        } catch (_) {
          await _enqueueOperation(SyncOpType.delete, eventId: eventId);
          return true;
        }
      } else {
        await _enqueueOperation(SyncOpType.delete, eventId: eventId);
        return true;
      }
    }

    return index != -1;
  }

  Future<void> toggleFavorite(String eventId) async {
    final index = _events.indexWhere((e) => e.id == eventId);
    if (index != -1) {
      final current = _events[index];
      final newFavorite = !current.isFavorite;

      // 1. Optimistic UI update
      _events[index] = current.copyWith(isFavorite: newFavorite);
      notifyListeners();
      await _saveToStorage();

      // 2. Cloud sync or queue
      if (_shouldUseFirestore) {
        if (_isOnline) {
          try {
            await _firestoreService.toggleFavorite(_uid!, eventId, newFavorite);
          } catch (_) {
            await _enqueueOperation(
              SyncOpType.toggleFavorite,
              eventId: eventId,
              isFavorite: newFavorite,
            );
          }
        } else {
          await _enqueueOperation(
            SyncOpType.toggleFavorite,
            eventId: eventId,
            isFavorite: newFavorite,
          );
        }
      }
    }
  }

  EventModel? getEventById(String eventId) {
    try {
      return _events.firstWhere((e) => e.id == eventId);
    } catch (_) {
      return null;
    }
  }

  Future<void> _enqueueOperation(
    SyncOpType type, {
    EventModel? event,
    String? eventId,
    bool? isFavorite,
  }) async {
    final op = SyncOperation(
      id: 'sync_${DateTime.now().microsecondsSinceEpoch}',
      type: type,
      event: event,
      eventId: eventId ?? event?.id,
      isFavorite: isFavorite,
    );
    await _pendingQueue.enqueue(op);
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(_events.map((e) => e.toMap()).toList());
      await prefs.setString(_storageKey, encoded);
    } catch (_) {}
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _eventsSubscription?.cancel();
    super.dispose();
  }

  List<EventModel> _generateInitialSeedEvents() {
    final now = DateTime.now();
    return [
      EventModel(
        id: 'seed_event_1',
        title: 'This is a Birthday Party ',
        description:
            'Lorem ipsum dolor sit amet consectetur. Vulputate eleifend suscipit eget neque senectus a. Nulla at non malesuada odio duis lectus amet nisi sit.',
        category: EventCategory.birthday,
        dateTime: DateTime(now.year, now.month, 21, 19, 0),
        location: 'Cairo , Egypt',
        imagePath: AppImages.birthdayBanner,
        isFavorite: false,
      ),
      EventModel(
        id: 'seed_event_2',
        title: 'Meeting for Updating The Development Method ',
        description:
            'Team meeting to discuss Flutter architectural standards, unit testing rules, and design token integration.',
        category: EventCategory.meeting,
        dateTime: DateTime(now.year, now.month, 25, 12, 12),
        location: 'Cairo , Egypt',
        imagePath: AppImages.meetingBanner,
        isFavorite: false,
      ),
      EventModel(
        id: 'seed_event_3',
        title: 'We Are Going To Play Football',
        description:
            'Weekly friendly football tournament for mobile developers and engineering enthusiasts.',
        category: EventCategory.sport,
        dateTime: DateTime(now.year, now.month, 28, 20, 30),
        location: 'Cairo , Egypt',
        imagePath: AppImages.sportBanner,
        isFavorite: false,
      ),
      EventModel(
        id: 'seed_event_4',
        title: 'Reading Book Club Gathering',
        description:
            'Monthly book discussion focusing on clean code, software craftmanship, and modern architectures.',
        category: EventCategory.bookClub,
        dateTime: DateTime(now.year, now.month, 30, 16, 0),
        location: 'Cairo , Egypt',
        imagePath: AppImages.bookClubBanner,
        isFavorite: false,
      ),
    ];
  }
}
