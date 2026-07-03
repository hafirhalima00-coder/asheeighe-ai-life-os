import 'package:flutter_test/flutter_test.dart';

class DateUtils {
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static bool isSameMonth(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month;
  }

  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return to.difference(from).inDays;
  }

  static DateTime firstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static DateTime lastDayOfMonth(DateTime date) {
    if (date.month == 12) {
      return DateTime(date.year + 1, 1, 0);
    }
    return DateTime(date.year, date.month + 1, 0);
  }

  static DateTime firstDayOfWeek(DateTime date) {
    final weekday = date.weekday - 1;
    return DateTime(date.year, date.month, date.day - weekday);
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  static bool isPast(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  static bool isFuture(DateTime date) {
    return date.isAfter(DateTime.now());
  }
}

void main() {
  group('DateUtils', () {
    group('isSameDay', () {
      test('identical dates should be same day', () {
        final d1 = DateTime(2024, 6, 15, 10, 0);
        final d2 = DateTime(2024, 6, 15, 22, 30);
        expect(DateUtils.isSameDay(d1, d2), true);
      });

      test('different days should not match', () {
        final d1 = DateTime(2024, 6, 15);
        final d2 = DateTime(2024, 6, 16);
        expect(DateUtils.isSameDay(d1, d2), false);
      });
    });

    group('isSameMonth', () {
      test('same month should match', () {
        expect(
          DateUtils.isSameMonth(
            DateTime(2024, 6, 1),
            DateTime(2024, 6, 30),
          ),
          true,
        );
      });

      test('different months should not match', () {
        expect(
          DateUtils.isSameMonth(
            DateTime(2024, 6, 1),
            DateTime(2024, 7, 1),
          ),
          false,
        );
      });
    });

    group('daysBetween', () {
      test('should return 0 for same day', () {
        expect(DateUtils.daysBetween(
          DateTime(2024, 6, 15),
          DateTime(2024, 6, 15),
        ), 0);
      });

      test('should return correct day difference', () {
        expect(DateUtils.daysBetween(
          DateTime(2024, 6, 1),
          DateTime(2024, 6, 10),
        ), 9);
      });

      test('should return negative for past dates', () {
        expect(DateUtils.daysBetween(
          DateTime(2024, 6, 10),
          DateTime(2024, 6, 1),
        ), -9);
      });
    });

    group('firstDayOfMonth', () {
      test('should return 1st of month', () {
        final result = DateUtils.firstDayOfMonth(DateTime(2024, 6, 15));
        expect(result.day, 1);
        expect(result.month, 6);
        expect(result.year, 2024);
      });
    });

    group('lastDayOfMonth', () {
      test('should return last day of month', () {
        final result = DateUtils.lastDayOfMonth(DateTime(2024, 6, 15));
        expect(result.day, 30);
      });

      test('should handle December correctly', () {
        final result = DateUtils.lastDayOfMonth(DateTime(2024, 12, 15));
        expect(result.day, 31);
        expect(result.month, 12);
      });
    });

    group('firstDayOfWeek', () {
      test('should return Monday of same week', () {
        final wednesday = DateTime(2024, 6, 19);
        final result = DateUtils.firstDayOfWeek(wednesday);
        expect(result.weekday, 1);
      });
    });

    group('isToday', () {
      test('should return true for today', () {
        expect(DateUtils.isToday(DateTime.now()), true);
      });

      test('should return false for yesterday', () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        expect(DateUtils.isToday(yesterday), false);
      });
    });

    group('isTomorrow', () {
      test('should return true for tomorrow', () {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        expect(DateUtils.isTomorrow(tomorrow), true);
      });
    });

    group('isYesterday', () {
      test('should return true for yesterday', () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        expect(DateUtils.isYesterday(yesterday), true);
      });
    });

    group('isPast', () {
      test('should return true for past date', () {
        final past = DateTime.now().subtract(const Duration(days: 1));
        expect(DateUtils.isPast(past), true);
      });
    });

    group('isFuture', () {
      test('should return true for future date', () {
        final future = DateTime.now().add(const Duration(days: 1));
        expect(DateUtils.isFuture(future), true);
      });
    });
  });
}
