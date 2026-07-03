import 'package:equatable/equatable.dart';

enum StreakType {
  dailyLogin,
  prayer,
  dhikr,
  coding,
  tasks,
}

class Streak extends Equatable {
  final StreakType type;
  final int currentCount;
  final int bestCount;
  final DateTime? lastDate;
  final bool isActive;

  const Streak({
    required this.type,
    this.currentCount = 0,
    this.bestCount = 0,
    this.lastDate,
    this.isActive = false,
  });

  bool get isBroken => !isActive && currentCount > 0;

  bool get is todayCompleted {
    if (lastDate == null) return false;
    final now = DateTime.now();
    return lastDate!.year == now.year &&
        lastDate!.month == now.month &&
        lastDate!.day == now.day;
  }

  String get displayName {
    switch (type) {
      case StreakType.dailyLogin:
        return 'Daily Login';
      case StreakType.prayer:
        return 'Prayer';
      case StreakType.dhikr:
        return 'Dhikr';
      case StreakType.coding:
        return 'Coding';
      case StreakType.tasks:
        return 'Tasks';
    }
  }

  Streak copyWith({
    StreakType? type,
    int? currentCount,
    int? bestCount,
    DateTime? lastDate,
    bool clearLastDate = false,
    bool? isActive,
  }) {
    return Streak(
      type: type ?? this.type,
      currentCount: currentCount ?? this.currentCount,
      bestCount: bestCount ?? this.bestCount,
      lastDate: clearLastDate ? null : (lastDate ?? this.lastDate),
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [type, currentCount, bestCount, lastDate, isActive];
}
