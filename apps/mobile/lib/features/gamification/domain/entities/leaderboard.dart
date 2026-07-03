import 'package:equatable/equatable.dart';

class LeaderboardEntry extends Equatable {
  final String userId;
  final String name;
  final String? avatar;
  final int level;
  final int xp;
  final int rank;
  final int streak;

  const LeaderboardEntry({
    required this.userId,
    required this.name,
    this.avatar,
    required this.level,
    required this.xp,
    required this.rank,
    this.streak = 0,
  });

  LeaderboardEntry copyWith({
    String? userId,
    String? name,
    String? avatar,
    bool clearAvatar = false,
    int? level,
    int? xp,
    int? rank,
    int? streak,
  }) {
    return LeaderboardEntry(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      avatar: clearAvatar ? null : (avatar ?? this.avatar),
      level: level ?? this.level,
      xp: xp ?? this.xp,
      rank: rank ?? this.rank,
      streak: streak ?? this.streak,
    );
  }

  bool get isTopThree => rank <= 3;

  String get rankSuffix {
    switch (rank) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  @override
  List<Object?> get props => [userId, name, avatar, level, xp, rank, streak];
}
