import 'package:flutter_test/flutter_test.dart';
import 'package:evently/models/event_model.dart';
import 'package:evently/utils/app_images.dart';

void main() {
  group('EventModel Unit Tests', () {
    test('EventModel instantiates and serializes correctly to/from Map', () {
      final now = DateTime(2026, 11, 20, 18, 30);
      final event = EventModel(
        id: 'event_1',
        title: 'Meeting for Updating The Development Method',
        description: 'Team discussion regarding mobile development methods.',
        category: EventCategory.meeting,
        dateTime: now,
        location: 'Cairo , Egypt',
        imagePath: AppImages.meetingBanner,
        isFavorite: false,
      );

      expect(event.id, 'event_1');
      expect(event.category, EventCategory.meeting);
      expect(event.title, 'Meeting for Updating The Development Method');

      final map = event.toMap();
      expect(map['id'], 'event_1');
      expect(map['category'], 'meeting');
      expect(map['title'], 'Meeting for Updating The Development Method');

      final fromMapEvent = EventModel.fromMap(map);
      expect(fromMapEvent, equals(event));
    });

    test('EventModel copyWith correctly creates modified instance', () {
      final now = DateTime(2026, 11, 21);
      final event = EventModel(
        id: 'event_2',
        title: 'Birthday Party',
        description: 'Celebration with friends.',
        category: EventCategory.birthday,
        dateTime: now,
        location: 'Nasr City',
        imagePath: AppImages.birthdayBanner,
        isFavorite: false,
      );

      final updated = event.copyWith(isFavorite: true, title: 'Updated Party');
      expect(updated.id, 'event_2');
      expect(updated.isFavorite, isTrue);
      expect(updated.title, 'Updated Party');
      expect(updated.description, event.description);
    });

    test('EventCategory properties return correct icons and banners', () {
      expect(EventCategory.sport.displayName, 'Sport');
      expect(EventCategory.sport.iconPath, AppImages.icBike);
      expect(EventCategory.sport.bannerPath, AppImages.sportBanner);

      expect(EventCategory.birthday.displayName, 'Birthday');
      expect(EventCategory.birthday.iconPath, AppImages.icCake);
      expect(EventCategory.birthday.bannerPath, AppImages.birthdayBanner);

      expect(EventCategory.bookClub.displayName, 'Book Club');
      expect(EventCategory.bookClub.iconPath, AppImages.icBook);
      expect(EventCategory.bookClub.bannerPath, AppImages.bookClubBanner);

      expect(EventCategory.meeting.displayName, 'Meeting');
      expect(EventCategory.meeting.iconPath, AppImages.icCalendar);
      expect(EventCategory.meeting.bannerPath, AppImages.meetingBanner);
    });

    test('EventModel.fromMap parses Timestamp-like object gracefully', () {
      final expectedDate = DateTime(2026, 12, 25, 10, 0);
      final map = {
        'id': 'cloud_1',
        'title': 'Christmas Celebration',
        'description': 'Gathering with family',
        'category': 'birthday',
        'dateTime': _FakeTimestamp(expectedDate),
        'location': 'Cairo, Egypt',
        'imagePath': 'assets/images/birthday_banner.png',
        'isFavorite': true,
      };

      final event = EventModel.fromMap(map);
      expect(event.id, 'cloud_1');
      expect(event.dateTime, expectedDate);
      expect(event.category, EventCategory.birthday);
      expect(event.isFavorite, isTrue);
    });

    test('EventModel.toFirestoreMap serializes fields correctly', () {
      final date = DateTime(2026, 11, 20, 18, 30);
      final event = EventModel(
        id: 'event_10',
        title: 'Clean Architecture Workshop',
        description: 'Learn TDD and Clean Architecture.',
        category: EventCategory.meeting,
        dateTime: date,
        location: 'Online',
        imagePath: 'assets/images/meeting_banner.png',
        isFavorite: false,
      );

      final map = event.toFirestoreMap();
      expect(map['id'], 'event_10');
      expect(map['title'], 'Clean Architecture Workshop');
      expect(map['category'], 'meeting');
      expect(map['dateTime'], date.toIso8601String());
      expect(map['isFavorite'], isFalse);
    });
  });
}

class _FakeTimestamp {
  final DateTime _date;
  _FakeTimestamp(this._date);
  DateTime toDate() => _date;
}
