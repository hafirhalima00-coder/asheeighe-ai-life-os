import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  String get formatted => DateFormat('MMM d, yyyy').format(this);

  String get formattedWithTime => DateFormat('MMM d, yyyy HH:mm').format(this);

  String get formattedTime => DateFormat('HH:mm').format(this);

  String get formattedShort => DateFormat('MMM d').format(this);

  String get formattedDay => DateFormat('EEEE').format(this);

  String get formattedMonth => DateFormat('MMMM').format(this);

  String get formattedYear => DateFormat('yyyy').format(this);

  String get formattedShortDay => DateFormat('E').format(this);

  String get formattedNumeric => DateFormat('MM/dd/yyyy').format(this);

  String get formattedISO => DateFormat('yyyy-MM-dd').format(this);

  String get formattedISOWithTime => DateFormat('yyyy-MM-dd HH:mm:ss').format(this);

  String get formattedRelative {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inSeconds < 60) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      final minutes = diff.inMinutes;
      return '$minutes min ago';
    } else if (diff.inHours < 24) {
      final hours = diff.inHours;
      return '$hours hr ago';
    } else if (diff.inDays < 7) {
      final days = diff.inDays;
      return '$days day${days > 1 ? 's' : ''} ago';
    } else if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else {
      final years = (diff.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    }
  }

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  bool get isThisWeek {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 7));
    return isAfter(weekStart) && isBefore(weekEnd);
  }

  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  bool get isPast => isBefore(DateTime.now());

  bool get isFuture => isAfter(DateTime.now());

  DateTime get startOfDay => DateTime(year, month, day);

  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  DateTime get startOfWeek {
    final weekDay = weekday - 1;
    return subtract(Duration(days: weekDay)).startOfDay;
  }

  DateTime get endOfWeek => startOfWeek.add(const Duration(days: 7));

  DateTime get startOfMonth => DateTime(year, month, 1);

  DateTime get endOfMonth {
    if (month == 12) {
      return DateTime(year + 1, 1, 0, 23, 59, 59, 999);
    }
    return DateTime(year, month + 1, 0, 23, 59, 59, 999);
  }

  String timeAgo({bool numeric = false}) {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inDays >= 365) {
      final years = (diff.inDays / 365).floor();
      return numeric ? '$years year${years > 1 ? 's' : ''} ago' : 'a year ago';
    } else if (diff.inDays >= 30) {
      final months = (diff.inDays / 30).floor();
      return numeric ? '$months month${months > 1 ? 's' : ''} ago' : 'a month ago';
    } else if (diff.inDays >= 7) {
      final weeks = (diff.inDays / 7).floor();
      return numeric ? '$weeks week${weeks > 1 ? 's' : ''} ago' : 'a week ago';
    } else if (diff.inDays >= 1) {
      return numeric ? '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago' : 'a day ago';
    } else if (diff.inHours >= 1) {
      return numeric ? '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago' : 'an hour ago';
    } else if (diff.inMinutes >= 1) {
      return numeric ? '${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago' : 'a minute ago';
    } else {
      return 'just now';
    }
  }
}

extension DateTimeNullableExtensions on DateTime? {
  String get formattedOrEmpty =>
      this != null ? this!.formatted : '';

  String get formattedWithTimeOrEmpty =>
      this != null ? this!.formattedWithTime : '';
}
