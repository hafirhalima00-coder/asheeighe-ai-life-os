import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../domain/entities/user_level.dart';
import '../domain/entities/xp_event.dart';
import '../domain/entities/badge.dart';
import '../domain/entities/streak.dart';
import '../domain/entities/leaderboard.dart';
import '../domain/repositories/gamification_repository.dart';
import '../data/gamification_local_storage.dart';

class GamificationState {
  final UserLevel userLevel;
  final List<Badge> badges;
  final List<Badge> earnedBadges;
  final List<Streak> streaks;
  final List<XpEvent> recentXp;
  final List<LeaderboardEntry> leaderboard;
  final int userRank;
  final bool showLevelUp;
  final XpEvent? lastXpGain;
  final bool isLoading;
  final String? error;

  const GamificationState({
    this.userLevel = const UserLevel(level: 1, xpRequired: 100, title: 'Novice'),
    this.badges = const [],
    this.earnedBadges = const [],
    this.streaks = const [],
    this.recentXp = const [],
    this.leaderboard = const [],
    this.userRank = 0,
    this.showLevelUp = false,
    this.lastXpGain,
    this.isLoading = false,
    this.error,
  });

  GamificationState copyWith({
    UserLevel? userLevel,
    List<Badge>? badges,
    List<Badge>? earnedBadges,
    List<Streak>? streaks,
    List<XpEvent>? recentXp,
    List<LeaderboardEntry>? leaderboard,
    int? userRank,
    bool? showLevelUp,
    bool clearLevelUp = false,
    XpEvent? lastXpGain,
    bool clearLastXp = false,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return GamificationState(
      userLevel: userLevel ?? this.userLevel,
      badges: badges ?? this.badges,
      earnedBadges: earnedBadges ?? this.earnedBadges,
      streaks: streaks ?? this.streaks,
      recentXp: recentXp ?? this.recentXp,
      leaderboard: leaderboard ?? this.leaderboard,
      userRank: userRank ?? this.userRank,
      showLevelUp: clearLevelUp ? false : (showLevelUp ?? this.showLevelUp),
      lastXpGain: clearLastXp ? null : (lastXpGain ?? this.lastXpGain),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  int get totalXp => userLevel.currentXp;
  int get totalBadgesEarned => earnedBadges.length;
  bool get hasActiveStreaks => streaks.any((s) => s.isActive && s.currentCount > 0);

  Streak? streakByType(StreakType type) {
    final matches = streaks.where((s) => s.type == type);
    return matches.isNotEmpty ? matches.first : null;
  }
}

final gamificationProvider =
    NotifierProvider<GamificationNotifier, GamificationState>(
  GamificationNotifier.new,
);

class GamificationNotifier extends Notifier<GamificationState> {
  late final GamificationLocalStorage _storage;
  final _uuid = const Uuid();

  @override
  GamificationState build() {
    _storage = GamificationLocalStorage();
    _loadData();
    return const GamificationState(isLoading: true);
  }

  Future<void> _loadData() async {
    final level = await _storage.getLevel();
    final badges = await _storage.getBadges();
    final streaks = await _storage.getStreaks();
    final xpHistory = await _storage.getXpHistory(limit: 20);
    final earned = badges.where((b) => b.isUnlocked).toList();

    state = GamificationState(
      userLevel: level,
      badges: badges,
      earnedBadges: earned,
      streaks: streaks,
      recentXp: xpHistory,
      isLoading: false,
    );
  }

  Future<void> addXp(XpEventType type, {String? description, int? amount}) async {
    final xpAmount = amount ?? XpEvent.defaultXp(type);
    final event = XpEvent(
      id: _uuid.v4(),
      type: type,
      amount: xpAmount,
      description: description,
      timestamp: DateTime.now(),
    );

    await _storage.addXpEvent(event);

    var currentLevel = state.userLevel;
    var newXp = currentLevel.currentXp + xpAmount;
    var levelNum = currentLevel.level;
    bool leveledUp = false;

    while (newXp >= currentLevel.xpRequired && !currentLevel.isMaxLevel) {
      newXp -= currentLevel.xpRequired;
      levelNum++;
      leveledUp = true;
      currentLevel = UserLevel.fromLevel(levelNum, currentXp: newXp);
    }

    if (!currentLevel.isMaxLevel) {
      currentLevel = currentLevel.copyWith(currentXp: newXp);
    } else {
      currentLevel = currentLevel.copyWith(currentXp: 0);
    }

    await _storage.saveLevel(currentLevel);

    final updatedBadges =
        _checkBadgeUnlocks(state.badges, levelNum, state.earnedBadges.length + 1);
    final earned = updatedBadges.where((b) => b.isUnlocked).toList();
    await _storage.saveBadges(updatedBadges);

    state = state.copyWith(
      userLevel: currentLevel,
      badges: updatedBadges,
      earnedBadges: earned,
      recentXp: [event, ...state.recentXp],
      lastXpGain: event,
      showLevelUp: leveledUp,
    );
  }

  Future<void> updateStreak(StreakType type) async {
    final streaks = List<Streak>.from(state.streaks);
    final idx = streaks.indexWhere((s) => s.type == type);
    if (idx == -1) return;

    final streak = streaks[idx];
    final now = DateTime.now();
    if (streak.isTodayCompleted) return;

    final isConsecutive =
        streak.lastDate != null && now.difference(streak.lastDate!).inDays == 1;
    final newCount = isConsecutive ? streak.currentCount + 1 : 1;
    final newBest = newCount > streak.bestCount ? newCount : streak.bestCount;

    streaks[idx] = streak.copyWith(
      currentCount: newCount,
      bestCount: newBest,
      lastDate: now,
      isActive: true,
    );

    await _storage.saveStreaks(streaks);
    state = state.copyWith(streaks: streaks);

    if (newCount == 7 || newCount == 30) {
      await addXp(
        XpEventType.streakBonus,
        description: '${streak.displayName} streak: $newCount days',
      );
    }
  }

  void dismissLevelUp() {
    state = state.copyWith(clearLevelUp: true);
  }

  void dismissLastXpGain() {
    state = state.copyWith(clearLastXp: true);
  }

  List<Badge> _checkBadgeUnlocks(
    List<Badge> badges,
    int level,
    int totalActions,
  ) {
    return badges.map((badge) {
      if (badge.isUnlocked) return badge;

      bool shouldUnlock = false;
      switch (badge.id) {
        case 'first_steps':
          shouldUnlock = totalActions >= 1;
          break;
        case 'knowledge_seeker':
          shouldUnlock = totalActions >= 10;
          break;
        case 'scholar':
          shouldUnlock = level >= 10;
          break;
        case 'life_architect':
          shouldUnlock = level >= 25;
          break;
        case 'pinkz_legend':
          shouldUnlock = level >= 50;
          break;
        case 'productivity_guru':
          shouldUnlock = totalActions >= 100;
          break;
        default:
          shouldUnlock = false;
      }

      if (shouldUnlock) {
        return badge.copyWith(
          isUnlocked: true,
          earnedAt: DateTime.now(),
        );
      }
      return badge;
    }).toList();
  }
}
