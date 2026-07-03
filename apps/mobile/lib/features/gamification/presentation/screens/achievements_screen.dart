import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../providers/gamification_provider.dart';
import '../widgets/badge_card.dart';
import '../widgets/streak_widget.dart';

class AchievementsScreen extends ConsumerStatefulWidget {
  final int initialTab;

  const AchievementsScreen({super.key, this.initialTab = 0});

  @override
  ConsumerState<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends ConsumerState<AchievementsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTab,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gamificationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Badges'),
            Tab(text: 'Streaks'),
            Tab(text: 'Levels'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _BadgeGrid(badges: state.badges),
          _StreakList(streaks: state.streaks),
          _LevelProgress(level: state.userLevel),
        ],
      ),
    );
  }
}

class _BadgeGrid extends StatelessWidget {
  final List badges;

  const _BadgeGrid({required this.badges});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: badges.length,
      itemBuilder: (context, index) {
        final badge = badges[index];
        return BadgeCard(badge: badge)
            .animate()
            .fadeIn(duration: 300.ms, delay: (index * 50).ms)
            .scale(begin: const Offset(0.8, 0.8));
      },
    );
  }
}

class _StreakList extends StatelessWidget {
  final List streaks;

  const _StreakList({required this.streaks});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...streaks.map((streak) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: StreakWidget(streak: streak, compact: true),
              title: Text(
                streak.displayName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'Current: ${streak.currentCount} days | Best: ${streak.bestCount} days',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              trailing: streak.isActive
                  ? Icon(Icons.check_circle, color: Colors.green[500], size: 20)
                  : Icon(Icons.cancel_outlined, color: Colors.grey[400], size: 20),
            ),
          );
        }),
        const SizedBox(height: 16),
        _StreakCalendar(streaks: streaks),
      ],
    );
  }
}

class _StreakCalendar extends StatelessWidget {
  final List streaks;

  const _StreakCalendar({required this.streaks});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Activity Calendar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: List.generate(28, (index) {
                final isActive = index < 7;
                return Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: isActive
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelProgress extends StatelessWidget {
  final dynamic level;

  const _LevelProgress({required this.level});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  'Level ${level.level}',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  level.title,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(5, (index) {
            final lvl = level.level - 2 + index;
            if (lvl < 1) return const SizedBox.shrink();
            final isCurrent = lvl == level.level;
            final isPast = lvl < level.level;

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              color: isCurrent
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                  : null,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isPast
                      ? Colors.green.withOpacity(0.1)
                      : isCurrent
                          ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.1),
                  child: isPast
                      ? const Icon(Icons.check, color: Colors.green, size: 20)
                      : Text(
                          '$lvl',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: isCurrent
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                          ),
                        ),
                ),
                title: Text(
                  'Level $lvl - ${level.title}',
                  style: TextStyle(
                    fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                    color: isCurrent ? Theme.of(context).colorScheme.primary : null,
                  ),
                ),
                trailing: isPast
                    ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
                    : isCurrent
                        ? const Icon(Icons.arrow_forward_ios_rounded,
                            size: 16, color: Colors.blue)
                        : Icon(Icons.lock_outline, size: 20, color: Colors.grey[400]),
              ),
            );
          }),
        ],
      ),
    );
  }
}
