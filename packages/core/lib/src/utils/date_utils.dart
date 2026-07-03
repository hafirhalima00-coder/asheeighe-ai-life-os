import 'package:intl/intl.dart';

extension AsheeigheDateTimeX on DateTime {
  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay =>
      DateTime(year, month, day, 23, 59, 59, 999);
  DateTime get startOfWeek =>
      subtract(Duration(days: weekday - 1)).startOfDay;
  DateTime get endOfWeek =>
      add(Duration(days: 7 - weekday)).endOfDay;
  DateTime get startOfMonth => DateTime(year, month, 1);
  DateTime get endOfMonth =>
      DateTime(year, month + 1, 0, 23, 59, 59, 999);
  DateTime get startOfYear => DateTime(year, 1, 1);
  DateTime get endOfYear => DateTime(year, 12, 31, 23, 59, 59, 999);

  bool get isToday =>
      startOfDay.isAtSameMomentAs(DateTime.now().startOfDay);
  bool get isTomorrow =>
      add(const Duration(days: -1)).isToday;
  bool get isYesterday =>
      add(const Duration(days: 1)).isToday;

  bool isSameDayAs(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  bool isSameWeekAs(DateTime other) {
    final d1 = startOfWeek;
    final d2 = other.startOfWeek;
    return d1.isAtSameMomentAs(d2);
  }

  bool isSameMonthAs(DateTime other) =>
      year == other.year && month == other.month;

  DateTime nextRecurrence(String rule) {
    final parts = rule.split(':');
    if (parts.length < 2) return this;
    final freq = parts[0].toLowerCase();
    final interval = int.tryParse(parts[1]) ?? 1;
    switch (freq) {
      case 'daily':
        return add(Duration(days: interval));
      case 'weekly':
        return add(Duration(days: 7 * interval));
      case 'monthly':
        return DateTime(year, month + interval, day);
      case 'yearly':
        return DateTime(year + interval, month, day);
      default:
        return this;
    }
  }
}

abstract final class AsheeigheDateFormats {
  AsheeigheDateFormats._();

  static final fullDate = DateFormat('EEEE, MMMM d, y');
  static final fullDateTime = DateFormat('EEEE, MMMM d, y – h:mm a');
  static final shortDate = DateFormat('MMM d, y');
  static final shortDateTime = DateFormat('MMM d, h:mm a');
  static final time = DateFormat('h:mm a');
  static final dayMonth = DateFormat('MMM d');
  static final monthYear = DateFormat('MMMM y');
  static final weekday = DateFormat('EEEE');
  static final weekdayShort = DateFormat('E');
  static final iso8601 = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
  static final relative = DateFormat('yMMMd');
}
