import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../providers/gamification_provider.dart';
import '../domain/entities/leaderboard.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _mockLeaderboard = [
    const LeaderboardEntry(
      userId: '1', name: 'Ahmad K.', level: 42, xp: 12500, rank: 1, streak: 45,
    ),
    const LeaderboardEntry(
      userId: '2', name: 'Fatima S.', level: 38, xp: 10200, rank: 2, streak: 30,
    ),
    const LeaderboardEntry(
      userId: '3', name: 'Omar R.', level: 35, xp: 9800, rank: 3, streak: 28,
    ),
    const LeaderboardEntry(
      userId: '4', name: 'Layla M.', level: 30, xp: 8100, rank: 4, streak: 21,
    ),
    const LeaderboardEntry(
      userId: '5', name: 'Yusuf A.', level: 28, xp: 7500, rank: 5, streak: 18,
    ),
    const LeaderboardEntry(
      userId: '6', name: 'Maryam H.', level: 25, xp: 6200, rank: 6, streak: 15,
    ),
    const LeaderboardEntry(
      userId: '7', name: 'Hassan B.', level: 22, xp: 5100, rank: 7, streak: 12,
    ),
    const LeaderboardEntry(
      userId: '8', name: 'Aisha N.', level: 20, xp: 4800, rank: 8, streak: 10,
    ),
    const LeaderboardEntry(
      userId: '9', name: 'Khalid J.', level: 18, xp: 3900, rank: 9, streak: 8,
    ),
    const LeaderboardEntry(
      userId: '10', name: 'Zainab F.', level: 15, xp: 3200, rank: 10, streak: 6,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: const Text('Leaderboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Weekly'),
            Tab(text: 'Monthly'),
            Tab(text: 'All Time'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _LeaderboardList(entries: _mockLeaderboard),
          _LeaderboardList(entries: _mockLeaderboard),
          _LeaderboardList(entries: _mockLeaderboard),
        ],
      ),
    );
  }
}

class _LeaderboardList extends StatelessWidget {
  final List<LeaderboardEntry> entries;

  const _LeaderboardList({required this.entries});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (entries.length >= 3)
          _TopThreePodium(
            first: entries[0],
            second: entries[1],
            third: entries[2],
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: entry.isTopThree
                        ? _rankColor(entry.rank).withOpacity(0.15)
                        : Colors.grey.withOpacity(0.1),
                    child: Text(
                      '${entry.rank}',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: entry.isTopThree
                            ? _rankColor(entry.rank)
                            : Colors.grey[600],
                      ),
                    ),
                  ),
                  title: Text(
                    entry.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'Level ${entry.level} · ${entry.streak} day streak',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  trailing: Text(
                    '${entry.xp} XP',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.amber[700],
                    ),
                  ),
                ),
              ).animate().fadeIn(
                    duration: 300.ms,
                    delay: (index * 50).ms,
                  );
            },
          ),
        ),
      ],
    );
  }

  Color _rankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700);
      case 2:
        return const Color(0xFFC0C0C0);
      case 3:
        return const Color(0xFFCD7F32);
      default:
        return Colors.grey;
    }
  }
}

class _TopThreePodium extends StatelessWidget {
  final LeaderboardEntry first;
  final LeaderboardEntry second;
  final LeaderboardEntry third;

  const _TopThreePodium({
    required this.first,
    required this.second,
    required this.third,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _PodiumEntry(entry: second, color: Colors.grey[400]!),
          const SizedBox(width: 12),
          _PodiumEntry(entry: first, color: const Color(0xFFFFD700), isWinner: true),
          const SizedBox(width: 12),
          _PodiumEntry(entry: third, color: const Color(0xFFCD7F32)),
        ],
      ),
    );
  }
}

class _PodiumEntry extends StatelessWidget {
  final LeaderboardEntry entry;
  final Color color;
  final bool isWinner;

  const _PodiumEntry({
    required this.entry,
    required this.color,
    this.isWinner = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: isWinner ? 28 : 24,
          backgroundColor: color.withOpacity(0.2),
          child: Text(
            entry.name[0],
            style: TextStyle(
              fontSize: isWinner ? 22 : 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          entry.name,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          '${entry.xp} XP',
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
        Container(
          width: 60,
          height: isWinner ? 50 : 35,
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Center(
            child: Text(
              '#${entry.rank}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
