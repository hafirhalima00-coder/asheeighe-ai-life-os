import 'package:flutter_test/flutter_test.dart';
import 'package:asheeighe/core/extensions/date_extensions.dart';

void main() {
  group('DateTimeExtensions', () {
    final fixedDate = DateTime(2024, 6, 15, 14, 30, 0);

    group('formatted getters', () {
      test('formatted should return MMM d, yyyy', () {
        expect(fixedDate.formatted, 'Jun 15, 2024');
      });

      test('formattedWithTime should include time', () {
        expect(fixedDate.formattedWithTime, 'Jun 15, 2024 14:30');
      });

      test('formattedTime should return HH:mm', () {
        expect(fixedDate.formattedTime, '14:30');
      });

      test('formattedShort should return MMM d', () {
        expect(fixedDate.formattedShort, 'Jun 15');
      });

      test('formattedDay should return full day name', () {
        expect(fixedDate.formattedDay, 'Saturday');
      });

      test('formattedMonth should return full month name', () {
        expect(fixedDate.formattedMonth, 'June');
      });

      test('formattedYear should return yyyy', () {
        expect(fixedDate.formattedYear, '2024');
      });

      test('formattedNumeric should return MM/dd/yyyy', () {
        expect(fixedDate.formattedNumeric, '06/15/2024');
      });

      test('formattedISO should return yyyy-MM-dd', () {
        expect(fixedDate.formattedISO, '2024-06-15');
      });

      test('formattedISOWithTime should return full ISO', () {
        expect(fixedDate.formattedISOWithTime, '2024-06-15 14:30:00');
      });
    });

    group('formattedRelative', () {
      test('should return "Just now" for < 60 seconds', () {
        final now = DateTime.now();
        expect(now.formattedRelative, 'Just now');
      });

      test('should return minutes for < 60 min', () {
        final past = DateTime.now().subtract(const Duration(minutes: 5));
        expect(past.formattedRelative, '5 min ago');
      });

      test('should return hours for < 24 hours', () {
        final past = DateTime.now().subtract(const Duration(hours: 3));
        expect(past.formattedRelative, '3 hr ago');
      });

      test('should return days for < 7 days', () {
        final past = DateTime.now().subtract(const Duration(days: 2));
        expect(past.formattedRelative, '2 days ago');
      });

      test('should return singular day', () {
        final past = DateTime.now().subtract(const Duration(days: 1));
        expect(past.formattedRelative, '1 day ago');
      });

      test('should return weeks for < 30 days', () {
        final past = DateTime.now().subtract(const Duration(days: 14));
        expect(past.formattedRelative, '2 weeks ago');
      });

      test('should return months for < 365 days', () {
        final past = DateTime.now().subtract(const Duration(days: 60));
        expect(past.formattedRelative, '2 months ago');
      });

      test('should return years for >= 365 days', () {
        final past = DateTime.now().subtract(const Duration(days: 400));
        expect(past.formattedRelative, '1 year ago');
      });
    });

    group('isToday / isTomorrow / isYesterday', () {
      test('isToday should be true for today', () {
        expect(DateTime.now().isToday, true);
      });

      test('isToday should be false for yesterday', () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        expect(yesterday.isToday, false);
      });

      test('isTomorrow should be true for tomorrow', () {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        expect(tomorrow.isTomorrow, true);
      });

      test('isYesterday should be true for yesterday', () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        expect(yesterday.isYesterday, true);
      });
    });

    group('isThisWeek / isThisMonth', () {
      test('isThisWeek should be true for today', () {
        expect(DateTime.now().isThisWeek, true);
      });

      test('isThisMonth should be true for today', () {
        expect(DateTime.now().isThisMonth, true);
      });

      test('isThisMonth should be false for last month', () {
        final lastMonth = DateTime.now().subtract(const Duration(days: 35));
        expect(lastMonth.isThisMonth, false);
      });
    });

    group('isPast / isFuture', () {
      test('isPast should be true for past date', () {
        final past = DateTime.now().subtract(const Duration(days: 1));
        expect(past.isPast, true);
      });

      test('isFuture should be true for future date', () {
        final future = DateTime.now().add(const Duration(days: 1));
        expect(future.isFuture, true);
      });

      test('isPast should be false for future date', () {
        final future = DateTime.now().add(const Duration(days: 1));
        expect(future.isPast, false);
      });
    });

    group('startOfDay / endOfDay', () {
      test('startOfDay should set time to 00:00:00', () {
        final start = fixedDate.startOfDay;
        expect(start.hour, 0);
        expect(start.minute, 0);
        expect(start.second, 0);
      });

      test('endOfDay should set time to 23:59:59.999', () {
        final end = fixedDate.endOfDay;
        expect(end.hour, 23);
        expect(end.minute, 59);
        expect(end.second, 59);
      });
    });

    group('startOfWeek / endOfWeek', () {
      test('startOfWeek should return Monday', () {
        final wednesday = DateTime(2024, 6, 19);
        final start = wednesday.startOfWeek;
        expect(start.weekday, 1);
      });

      test('endOfWeek should be 7 days after start', () {
        final wednesday = DateTime(2024, 6, 19);
        final diff = wednesday.endOfWeek.difference(wednesday.startOfWeek);
        expect(diff.inDays, 7);
      });
    });

    group('startOfMonth / endOfMonth', () {
      test('startOfMonth should return first day', () {
        final start = fixedDate.startOfMonth;
        expect(start.day, 1);
      });

      test('endOfMonth should return last day of month', () {
        final end = fixedDate.endOfMonth;
        expect(end.day, 30);
      });
    });

    group('timeAgo', () {
      test('should return "just now" for recent', () {
        final now = DateTime.now();
        expect(now.timeAgo(), 'just now');
      });

      test('should return numeric string when numeric=true', () {
        final past = DateTime.now().subtract(const Duration(days: 3));
        expect(past.timeAgo(numeric: true), '3 days ago');
      });
    });
  });

  group('DateTimeNullableExtensions', () {
    test('formattedOrEmpty should return empty for null', () {
      final DateTime? date = null;
      expect(date.formattedOrEmpty, '');
    });

    test('formattedOrEmpty should return formatted for non-null', () {
      final DateTime? date = DateTime(2024, 6, 15);
      expect(date.formattedOrEmpty, 'Jun 15, 2024');
    });

    test('formattedWithTimeOrEmpty should return empty for null', () {
      final DateTime? date = null;
      expect(date.formattedWithTimeOrEmpty, '');
    });
  });
}
