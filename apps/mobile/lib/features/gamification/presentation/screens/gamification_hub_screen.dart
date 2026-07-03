import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../providers/gamification_provider.dart';
import '../widgets/xp_gain_animation.dart';
import '../widgets/level_up_dialog.dart';
import '../widgets/streak_widget.dart';
import '../widgets/badge_card.dart';
import '../widgets/progress_bar_animated.dart';
import 'achievements_screen.dart';
import 'leaderboard_screen.dart';

class GamificationHubScreen extends ConsumerWidget {
  const GamificationHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gamificationProvider);
    final notifier = ref.read(gamificationProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state.showLevelUp) {
        showDialog(
          context: context,
          builder: (_) => LevelUpDialog(
            level: state.userLevel.level,
            title: state.userLevel.title,
            onDismiss: () => notifier.dismissLevelUp(),
          ),
        );
      }
      if (state.lastXpGain != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: XpGainAnimation(amount: state.lastXpGain!.amount),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
        notifier.dismissLastXpGain();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gamification Hub'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard_rounded),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
              );
            },
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LevelCard(level: state.userLevel),
                  const SizedBox(height: 20),
                  _XpBreakdown(recentXp: state.recentXp),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Active Streaks',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const AchievementsScreen(initialTab: 1),
                            ),
                          );
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: state.streaks
                          .where((s) => s.currentCount > 0)
                          .map((s) => Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: StreakWidget(streak: s),
                              ))
                          .toList(),
                    ),
                  ),
                  if (state.streaks.every((s) => s.currentCount == 0))
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.local_fire_department_outlined,
                                  size: 40, color: Colors.grey[400]),
                              const SizedBox(height: 8),
                              Text(
                                'Start a streak today!',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Badges (${state.earnedBadges.length}/${state.badges.length})',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const AchievementsScreen(initialTab: 0),
                            ),
                          );
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: state.badges
                          .take(6)
                          .map((b) => Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: BadgeCard(badge: b),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Recent Activity',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...state.recentXp.take(5).map((event) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          child: Icon(
                            Icons.bolt_rounded,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          event.displayName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          event.description ?? '+${event.amount} XP',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        trailing: Text(
                          '+${event.amount} XP',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.amber[700],
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }),
                  if (state.recentXp.isEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: Text(
                            'Complete tasks to earn XP!',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final dynamic level;

  const _LevelCard({required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.tertiary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${level.level}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Level ${level.level}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      level.title,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ProgressBarAnimated(
            progress: level.progressToNext,
            height: 10,
            backgroundColor: Colors.white24,
            valueColor: Colors.white,
          ),
          const SizedBox(height: 8),
          Text(
            '${level.currentXp} / ${level.xpRequired} XP to next level',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}

class _XpBreakdown extends StatelessWidget {
  final List recentXp;

  const _XpBreakdown({required this.recentXp});

  @override
  Widget build(BuildContext context) {
    final todayXp = recentXp
        .where((e) =>
            e.timestamp.day == DateTime.now().day &&
            e.timestamp.month == DateTime.now().month &&
            e.timestamp.year == DateTime.now().year)
        .fold<int>(0, (sum, e) => sum + e.amount);

    return Row(
      children: [
        _XpStat(
          label: 'Today',
          amount: todayXp,
          icon: Icons.today_rounded,
        ),
        const SizedBox(width: 12),
        _XpStat(
          label: 'This Week',
          amount: recentXp.take(20).fold<int>(0, (sum, e) => sum + e.amount),
          icon: Icons.date_range_rounded,
        ),
        const SizedBox(width: 12),
        _XpStat(
          label: 'Total',
          amount: recentXp.fold<int>(0, (sum, e) => sum + e.amount),
          icon: Icons.bolt_rounded,
        ),
      ],
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms);
  }
}

class _XpStat extends StatelessWidget {
  final String label;
  final int amount;
  final IconData icon;

  const _XpStat({
    required this.label,
    required this.amount,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 6),
            Text(
              '$amount',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
