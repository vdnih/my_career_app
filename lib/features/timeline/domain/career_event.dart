import 'package:flutter/foundation.dart';

@immutable
class CareerEvent {
  final String date; // yyyy-MM
  final String? endDate; // yyyy-MM
  final String title;
  final String description;
  final bool isLifeEvent;

  const CareerEvent({
    required this.date,
    this.endDate,
    required this.title,
    required this.description,
    this.isLifeEvent = false,
  });

  DateTime get dateTime {
    final parts = date.split('-');
    return DateTime(int.parse(parts[0]), int.parse(parts[1]));
  }

  DateTime? get endDateTime {
    if (endDate == null) return null;
    final parts = endDate!.split('-');
    return DateTime(int.parse(parts[0]), int.parse(parts[1]));
  }

  bool get hasDuration => endDate != null;

  CareerEvent copyWith({
    String? date,
    String? endDate,
    String? title,
    String? description,
    bool? isLifeEvent,
  }) {
    return CareerEvent(
      date: date ?? this.date,
      endDate: endDate ?? this.endDate,
      title: title ?? this.title,
      description: description ?? this.description,
      isLifeEvent: isLifeEvent ?? this.isLifeEvent,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CareerEvent &&
        other.date == date &&
        other.endDate == endDate &&
        other.title == title &&
        other.description == description &&
        other.isLifeEvent == isLifeEvent;
  }

  @override
  int get hashCode {
    return date.hashCode ^
        endDate.hashCode ^
        title.hashCode ^
        description.hashCode ^
        isLifeEvent.hashCode;
  }
}
