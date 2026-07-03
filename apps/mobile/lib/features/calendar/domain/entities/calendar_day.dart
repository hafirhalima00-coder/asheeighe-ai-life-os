import 'package:equatable/equatable.dart';
import 'calendar_event.dart';

class CalendarDay extends Equatable {
  final DateTime date;
  final List<CalendarEvent> events;
  final bool isToday;
  final bool isCurrentMonth;

  const CalendarDay({
    required this.date,
    this.events = const [],
    this.isToday = false,
    this.isCurrentMonth = true,
  });

  CalendarDay copyWith({
    DateTime? date,
    List<CalendarEvent>? events,
    bool? isToday,
    bool? isCurrentMonth,
  }) {
    return CalendarDay(
      date: date ?? this.date,
      events: events ?? this.events,
      isToday: isToday ?? this.isToday,
      isCurrentMonth: isCurrentMonth ?? this.isCurrentMonth,
    );
  }

  @override
  List<Object?> get props => [date, events, isToday, isCurrentMonth];
}
