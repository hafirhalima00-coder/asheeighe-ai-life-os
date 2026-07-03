import 'package:flutter/material.dart';

class PinkzNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Map<int, int> badgeCounts;

  const PinkzNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.badgeCounts = const {},
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex < 4 ? currentIndex : 0,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFFFF6B9D),
      unselectedItemColor: const Color(0xFF9CA3AF),
      backgroundColor: Colors.white,
      elevation: 8,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: _buildBadge(
            child: const Icon(Icons.auto_awesome_outlined),
            count: badgeCounts[1] ?? 0,
          ),
          activeIcon: _buildBadge(
            child: const Icon(Icons.auto_awesome),
            count: badgeCounts[1] ?? 0,
          ),
          label: 'AI Chat',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          activeIcon: Icon(Icons.calendar_month),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: _buildBadge(
            child: const Icon(Icons.checklist_outlined),
            count: badgeCounts[3] ?? 0,
          ),
          activeIcon: _buildBadge(
            child: const Icon(Icons.checklist),
            count: badgeCounts[3] ?? 0,
          ),
          label: 'Tasks',
        ),
      ],
    );
  }

  Widget _buildBadge({required Widget child, required int count}) {
    if (count <= 0) return child;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          right: -8,
          top: -4,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Color(0xFFFF6B9D),
              shape: BoxShape.circle,
            ),
            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
            child: Text(
              count > 9 ? '9+' : count.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
