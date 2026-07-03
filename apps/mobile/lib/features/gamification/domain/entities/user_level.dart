import 'package:equatable/equatable.dart';

class UserLevel extends Equatable {
  final int level;
  final int xpRequired;
  final int currentXp;
  final String title;
  final List<String> rewards;

  const UserLevel({
    required this.level,
    required this.xpRequired,
    this.currentXp = 0,
    required this.title,
    this.rewards = const [],
  });

  double get progressToNext =>
      xpRequired > 0 ? currentXp / xpRequired : 0;

  bool get isMaxLevel => level >= 50;

  UserLevel copyWith({
    int? level,
    int? xpRequired,
    int? currentXp,
    String? title,
    List<String>? rewards,
  }) {
    return UserLevel(
      level: level ?? this.level,
      xpRequired: xpRequired ?? this.xpRequired,
      currentXp: currentXp ?? this.currentXp,
      title: title ?? this.title,
      rewards: rewards ?? this.rewards,
    );
  }

  static const Map<int, String> levelTitles = {
    1: 'Novice',
    5: 'Apprentice',
    10: 'Scholar',
    15: 'Adept',
    20: 'Master',
    25: 'Life Architect',
    30: 'Sage',
    40: 'Grandmaster',
    50: 'Asheeighe Legend',
  };

  static String titleForLevel(int level) {
    String title = 'Novice';
    for (final entry in levelTitles.entries) {
      if (level >= entry.key) {
        title = entry.value;
      }
    }
    return title;
  }

  static int xpForLevel(int level) {
    return (level * 100) + ((level - 1) * 50);
  }

  factory UserLevel.fromLevel(int level, {int currentXp = 0}) {
    return UserLevel(
      level: level,
      xpRequired: xpForLevel(level),
      currentXp: currentXp,
      title: titleForLevel(level),
    );
  }

  @override
  List<Object?> get props => [level, xpRequired, currentXp, title, rewards];
}
