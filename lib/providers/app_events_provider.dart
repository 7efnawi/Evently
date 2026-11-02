import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event_model.dart';
import '../utils/app_images.dart';

class AppEventsProvider extends ChangeNotifier {
  static const String _storageKey = 'evently_stored_events';

  List<EventModel> _events = [];
  EventCategory _selectedCategory = EventCategory.all;
  bool _isLoading = false;

  List<EventModel> get events => List.unmodifiable(_events);
  EventCategory get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

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

  AppEventsProvider() {
    loadEvents();
  }

  Future<void> loadEvents() async {
    _isLoading = true;
    notifyListeners();

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
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCategory(EventCategory category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      notifyListeners();
    }
  }

  Future<bool> createEvent(EventModel event) async {
    _events.insert(0, event);
    await _saveToStorage();
    notifyListeners();
    return true;
  }

  Future<bool> updateEvent(EventModel updatedEvent) async {
    final index = _events.indexWhere((e) => e.id == updatedEvent.id);
    if (index != -1) {
      _events[index] = updatedEvent;
      await _saveToStorage();
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> deleteEvent(String eventId) async {
    final index = _events.indexWhere((e) => e.id == eventId);
    if (index != -1) {
      _events.removeAt(index);
      await _saveToStorage();
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> toggleFavorite(String eventId) async {
    final index = _events.indexWhere((e) => e.id == eventId);
    if (index != -1) {
      final current = _events[index];
      _events[index] = current.copyWith(isFavorite: !current.isFavorite);
      await _saveToStorage();
      notifyListeners();
    }
  }

  EventModel? getEventById(String eventId) {
    try {
      return _events.firstWhere((e) => e.id == eventId);
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_events.map((e) => e.toMap()).toList());
    await prefs.setString(_storageKey, encoded);
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
