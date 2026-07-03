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

  static const _tabs = [
    _NavTabData('Home', Icons.home_outlined, Icons.home),
    _NavTabData('AI Chat', Icons.auto_awesome_outlined, Icons.auto_awesome),
    _NavTabData('Islamic', Icons.nightlight_round_outlined, Icons.nightlight),
    _NavTabData('Tasks', Icons.checklist_outlined, Icons.checklist),
    _NavTabData('More', Icons.menu_outlined, Icons.menu),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_tabs.length, (index) {
              final tab = _tabs[index];
              final isSelected = index == currentIndex;
              final badge = badgeCounts[index];

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(index),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected
                          ? const Color(0xFFFFF0F5)
                          : Colors.transparent,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                isSelected ? tab.activeIcon : tab.icon,
                                key: ValueKey('$index-${isSelected ? 1 : 0}'),
                                size: 22,
                                color: isSelected
                                    ? const Color(0xFFFF6B9D)
                                    : const Color(0xFF9CA3AF),
                              ),
                            ),
                            if (badge != null && badge > 0)
                              Positioned(
                                right: -8,
                                top: -4,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFF6B9D),
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  child: Text(
                                    badge > 99 ? '99+' : '$badge',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected
                                ? const Color(0xFFFF6B9D)
                                : const Color(0xFF9CA3AF),
                          ),
                          child: Text(tab.label),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavTabData {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const _NavTabData(this.label, this.icon, this.activeIcon);
}
