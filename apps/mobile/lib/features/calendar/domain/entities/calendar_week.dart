import 'package:equatable/equatable.dart';
import 'calendar_day.dart';

class CalendarWeek extends Equatable {
  final DateTime startDate;
  final List<CalendarDay> days;

  const CalendarWeek({
    required this.startDate,
    this.days = const [],
  });

  CalendarWeek copyWith({
    DateTime? startDate,
    List<CalendarDay>? days,
  }) {
    return CalendarWeek(
      startDate: startDate ?? this.startDate,
      days: days ?? this.days,
    );
  }

  DateTime get endDate => startDate.add(const Duration(days: 6));

  @override
  List<Object?> get props => [startDate, days];
}
