import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/entities/badge.dart';
import '../domain/entities/streak.dart';
import '../domain/entities/user_level.dart';
import '../domain/entities/xp_event.dart';

class GamificationLocalStorage {
  static const _levelKey = 'gamification_level';
  static const _xpKey = 'gamification_xp';
  static const _badgesKey = 'gamification_badges';
  static const _streaksKey = 'gamification_streaks';
  static const _xpHistoryKey = 'gamification_xp_history';

  Future<UserLevel> getLevel() async {
    final prefs = await SharedPreferences.getInstance();
    final level = prefs.getInt(_levelKey) ?? 1;
    final xp = prefs.getInt(_xpKey) ?? 0;
    return UserLevel.fromLevel(level, currentXp: xp);
  }

  Future<void> saveLevel(UserLevel level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_levelKey, level.level);
    await prefs.setInt(_xpKey, level.currentXp);
  }

  Future<List<Badge>> getBadges() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_badgesKey);
    if (data == null) return predefinedBadges;
    final list = jsonDecode(data) as List<dynamic>;
    return list.map((b) => _badgeFromJson(b as Map<String, dynamic>)).toList();
  }

  Future<void> saveBadges(List<Badge> badges) async {
    final prefs = await SharedPreferences.getInstance();
    final data = badges.map((b) => _badgeToJson(b)).toList();
    await prefs.setString(_badgesKey, jsonEncode(data));
  }

  Future<List<Streak>> getStreaks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_streaksKey);
    if (data == null) return defaultStreaks;
    final list = jsonDecode(data) as List<dynamic>;
    return list.map((s) => _streakFromJson(s as Map<String, dynamic>)).toList();
  }

  Future<void> saveStreaks(List<Streak> streaks) async {
    final prefs = await SharedPreferences.getInstance();
    final data = streaks.map((s) => _streakToJson(s)).toList();
    await prefs.setString(_streaksKey, jsonEncode(data));
  }

  Future<void> addXpEvent(XpEvent event) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_xpHistoryKey);
    final list = data != null
        ? (jsonDecode(data) as List<dynamic>)
        : <dynamic>[];
    list.add({
      'id': event.id,
      'type': event.type.name,
      'amount': event.amount,
      'description': event.description,
      'timestamp': event.timestamp.toIso8601String(),
    });
    if (list.length > 100) {
      list.removeRange(0, list.length - 100);
    }
    await prefs.setString(_xpHistoryKey, jsonEncode(list));
  }

  Future<List<XpEvent>> getXpHistory({int limit = 50}) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_xpHistoryKey);
    if (data == null) return [];
    final list = jsonDecode(data) as List<dynamic>;
    return list
        .take(limit)
        .map((e) => XpEvent(
              id: e['id'] as String,
              type: XpEventType.values.firstWhere((t) => t.name == e['type']),
              amount: e['amount'] as int,
              description: e['description'] as String?,
              timestamp: DateTime.parse(e['timestamp'] as String),
            ))
        .toList();
  }

  Map<String, dynamic> _badgeToJson(Badge badge) {
    return {
      'id': badge.id,
      'name': badge.name,
      'description': badge.description,
      'icon': badge.icon,
      'category': badge.category.name,
      'rarity': badge.rarity.name,
      'earnedAt': badge.earnedAt?.toIso8601String(),
      'isUnlocked': badge.isUnlocked,
    };
  }

  Badge _badgeFromJson(Map<String, dynamic> json) {
    return Badge(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      category: BadgeCategory.values.firstWhere((c) => c.name == json['category']),
      rarity: BadgeRarity.values.firstWhere((r) => r.name == json['rarity']),
      earnedAt: json['earnedAt'] != null
          ? DateTime.parse(json['earnedAt'] as String)
          : null,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> _streakToJson(Streak streak) {
    return {
      'type': streak.type.name,
      'currentCount': streak.currentCount,
      'bestCount': streak.bestCount,
      'lastDate': streak.lastDate?.toIso8601String(),
      'isActive': streak.isActive,
    };
  }

  Streak _streakFromJson(Map<String, dynamic> json) {
    return Streak(
      type: StreakType.values.firstWhere((t) => t.name == json['type']),
      currentCount: json['currentCount'] as int? ?? 0,
      bestCount: json['bestCount'] as int? ?? 0,
      lastDate: json['lastDate'] != null
          ? DateTime.parse(json['lastDate'] as String)
          : null,
      isActive: json['isActive'] as bool? ?? false,
    );
  }

  static const List<Badge> predefinedBadges = [
    Badge(
      id: 'first_steps',
      name: 'First Steps',
      description: 'Complete your first task',
      icon: '👣',
      category: BadgeCategory.productivity,
      rarity: BadgeRarity.common,
    ),
    Badge(
      id: 'knowledge_seeker',
      name: 'Knowledge Seeker',
      description: 'Complete 10 lessons',
      icon: '📚',
      category: BadgeCategory.coding,
      rarity: BadgeRarity.rare,
    ),
    Badge(
      id: 'code_ninja',
      name: 'Code Ninja',
      description: 'Complete a coding challenge',
      icon: '🥷',
      category: BadgeCategory.coding,
      rarity: BadgeRarity.epic,
    ),
    Badge(
      id: 'devoted_reader',
      name: 'Devoted Reader',
      description: 'Read Quran 7 days in a row',
      icon: '📖',
      category: BadgeCategory.spiritual,
      rarity: BadgeRarity.rare,
    ),
    Badge(
      id: 'morning_light',
      name: 'Morning Light',
      description: 'Complete morning adhkar 7 days',
      icon: '🌅',
      category: BadgeCategory.spiritual,
      rarity: BadgeRarity.rare,
    ),
    Badge(
      id: 'evening_peace',
      name: 'Evening Peace',
      description: 'Complete evening adhkar 7 days',
      icon: '🌇',
      category: BadgeCategory.spiritual,
      rarity: BadgeRarity.rare,
    ),
    Badge(
      id: 'prayer_warrior',
      name: 'Prayer Warrior',
      description: 'On-time prayers 30 days',
      icon: '🕌',
      category: BadgeCategory.spiritual,
      rarity: BadgeRarity.epic,
    ),
    Badge(
      id: 'streak_master',
      name: 'Streak Master',
      description: '30-day streak in any category',
      icon: '🔥',
      category: BadgeCategory.streak,
      rarity: BadgeRarity.epic,
    ),
    Badge(
      id: 'scholar',
      name: 'Scholar',
      description: 'Reach level 10',
      icon: '🎓',
      category: BadgeCategory.milestone,
      rarity: BadgeRarity.rare,
    ),
    Badge(
      id: 'life_architect',
      name: 'Life Architect',
      description: 'Reach level 25',
      icon: '🏗️',
      category: BadgeCategory.milestone,
      rarity: BadgeRarity.epic,
    ),
    Badge(
      id: 'pinkz_legend',
      name: 'PINKZ Legend',
      description: 'Reach level 50',
      icon: '👑',
      category: BadgeCategory.milestone,
      rarity: BadgeRarity.legendary,
    ),
    Badge(
      id: 'social_butterfly',
      name: 'Social Butterfly',
      description: 'Share 10 achievements',
      icon: '🦋',
      category: BadgeCategory.social,
      rarity: BadgeRarity.common,
    ),
    Badge(
      id: 'mentor',
      name: 'Mentor',
      description: 'Help 5 friends learn to code',
      icon: '🤝',
      category: BadgeCategory.social,
      rarity: BadgeRarity.epic,
    ),
    Badge(
      id: 'polymath',
      name: 'Polymath',
      description: 'Learn 3 programming languages',
      icon: '🧠',
      category: BadgeCategory.coding,
      rarity: BadgeRarity.legendary,
    ),
    Badge(
      id: 'quran_hafiz',
      name: 'Quran Hafiz',
      description: 'Complete reading entire Quran',
      icon: '✨',
      category: BadgeCategory.spiritual,
      rarity: BadgeRarity.legendary,
    ),
    Badge(
      id: 'productivity_guru',
      name: 'Productivity Guru',
      description: 'Complete 100 tasks',
      icon: '⚡',
      category: BadgeCategory.productivity,
      rarity: BadgeRarity.epic,
    ),
  ];

  static const List<Streak> defaultStreaks = [
    Streak(type: StreakType.dailyLogin),
    Streak(type: StreakType.prayer),
    Streak(type: StreakType.dhikr),
    Streak(type: StreakType.coding),
    Streak(type: StreakType.tasks),
  ];
}
