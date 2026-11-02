import 'package:equatable/equatable.dart';
import '../utils/app_images.dart';

enum EventCategory {
  all,
  sport,
  birthday,
  bookClub,
  meeting,
}

extension EventCategoryExtension on EventCategory {
  String get displayName {
    switch (this) {
      case EventCategory.all:
        return 'All';
      case EventCategory.sport:
        return 'Sport';
      case EventCategory.birthday:
        return 'Birthday';
      case EventCategory.bookClub:
        return 'Book Club';
      case EventCategory.meeting:
        return 'Meeting';
    }
  }

  String get iconPath {
    switch (this) {
      case EventCategory.all:
        return AppImages.icCompass;
      case EventCategory.sport:
        return AppImages.icBike;
      case EventCategory.birthday:
        return AppImages.icCake;
      case EventCategory.bookClub:
        return AppImages.icBook;
      case EventCategory.meeting:
        return AppImages.icCalendar;
    }
  }

  String get bannerPath {
    switch (this) {
      case EventCategory.all:
      case EventCategory.sport:
        return AppImages.sportBanner;
      case EventCategory.birthday:
        return AppImages.birthdayBanner;
      case EventCategory.bookClub:
        return AppImages.bookClubBanner;
      case EventCategory.meeting:
        return AppImages.meetingBanner;
    }
  }

  static EventCategory fromString(String value) {
    return EventCategory.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => EventCategory.sport,
    );
  }
}

class EventModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final EventCategory category;
  final DateTime dateTime;
  final String location;
  final String imagePath;
  final bool isFavorite;

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.dateTime,
    required this.location,
    required this.imagePath,
    this.isFavorite = false,
  });

  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    EventCategory? category,
    DateTime? dateTime,
    String? location,
    String? imagePath,
    bool? isFavorite,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      dateTime: dateTime ?? this.dateTime,
      location: location ?? this.location,
      imagePath: imagePath ?? this.imagePath,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.name,
      'dateTime': dateTime.toIso8601String(),
      'location': location,
      'imagePath': imagePath,
      'isFavorite': isFavorite,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      category: EventCategoryExtension.fromString(map['category'] as String? ?? 'sport'),
      dateTime: DateTime.tryParse(map['dateTime'] as String? ?? '') ?? DateTime.now(),
      location: map['location'] as String? ?? 'Cairo , Egypt',
      imagePath: map['imagePath'] as String? ?? AppImages.sportBanner,
      isFavorite: map['isFavorite'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        category,
        dateTime,
        location,
        imagePath,
        isFavorite,
      ];
}
