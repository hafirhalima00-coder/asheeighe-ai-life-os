import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user_level.dart';
import '../entities/xp_event.dart';
import '../entities/badge.dart';
import '../entities/streak.dart';
import '../entities/leaderboard.dart';

abstract class GamificationRepository {
  Future<Either<Failure, UserLevel>> getUserLevel();

  Future<Either<Failure, UserLevel>> addXp(XpEvent event);

  Future<Either<Failure, List<XpEvent>>> getXpHistory({int limit = 50});

  Future<Either<Failure, List<Badge>>> getBadges();

  Future<Either<Failure, List<Badge>>> getEarnedBadges();

  Future<Either<Failure, Badge>> earnBadge(String badgeId);

  Future<Either<Failure, List<Streak>>> getStreaks();

  Future<Either<Failure, Streak>> updateStreak(StreakType type);

  Future<Either<Failure, List<LeaderboardEntry>>> getLeaderboard({
    String period = 'weekly',
    int limit = 10,
  });

  Future<Either<Failure, int>> getUserRank({String period = 'weekly'});

  Future<Either<Failure, Map<String, dynamic>>> getGamificationStats();
}
