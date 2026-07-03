import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/route_names.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  static const _menuItems = [
    _DrawerItemData('Dashboard', Icons.dashboard_outlined, '/dashboard', 0),
    _DrawerItemData('AI Chat', Icons.auto_awesome_outlined, '/chat', 1),
    _DrawerItemData('Calendar', Icons.calendar_month_outlined, '/calendar', 2),
    _DrawerItemData('Tasks', Icons.checklist_outlined, '/tasks', 3),
    _DrawerItemData('Notes', Icons.sticky_note_2_outlined, null, null),
    _DrawerItemData('Reminders', Icons.notifications_outlined, null, null),
    _DrawerItemData('Islamic Hub', Icons.nightlight_round_outlined, '/islamic', null),
    _DrawerItemData('Code Tutor', Icons.code_outlined, '/code-tutor', null),
    _DrawerItemData('Templates', Icons.dashboard_customize_outlined, '/templates', null),
    _DrawerItemData('Achievements', Icons.emoji_events_outlined, '/achievements', null),
    _DrawerItemData('Composio', Icons.integration_instructions_outlined, null, null),
    _DrawerItemData('Settings', Icons.settings_outlined, '/settings', 4),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.valueOrNull?.user;

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFF0F5), Color(0xFFF8E8FF)],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF6B9D), Color(0xFF6C63FF)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF6B9D).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: user?.avatarUrl != null
                          ? ClipOval(
                              child: Image.network(
                                user!.avatarUrl!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              size: 32,
                              color: Colors.white,
                            ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user?.name ?? 'Guest User',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? 'Sign in to get started',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: _menuItems.map((item) {
                return _DrawerItem(
                  data: item,
                  isSelected: _isSelected(context, item),
                  onTap: () {
                    Navigator.pop(context);
                    if (item.route != null) {
                      context.go(item.route!);
                    }
                  },
                );
              }).toList(),
            ),
          ),
          const Divider(color: Color(0xFFE5E7EB), height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Text(
                  'Dark Mode',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 28,
                  child: Switch.adaptive(
                    value: Theme.of(context).brightness == Brightness.dark,
                    onChanged: (_) {},
                    activeColor: const Color(0xFFFF6B9D),
                    inactiveTrackColor: const Color(0xFFE5E7EB),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ref.read(authNotifierProvider.notifier).logout();
                  context.goNamed(RouteNames.login);
                },
                icon: const Icon(
                  Icons.logout_outlined,
                  size: 20,
                  color: Color(0xFFE53935),
                ),
                label: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Color(0xFFE53935),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'PINKZ v1.0.0',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  bool _isSelected(BuildContext context, _DrawerItemData item) {
    final location = GoRouterState.of(context).matchedLocation;
    return item.route != null && location.startsWith(item.route!);
  }
}

class _DrawerItemData {
  final String label;
  final IconData icon;
  final String? route;
  final int? index;

  const _DrawerItemData(this.label, this.icon, this.route, this.index);
}

class _DrawerItem extends StatelessWidget {
  final _DrawerItemData data;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.data,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isSelected
                  ? const Color(0xFFFFF0F5)
                  : Colors.transparent,
            ),
            child: Row(
              children: [
                Icon(
                  data.icon,
                  size: 20,
                  color: isSelected
                      ? const Color(0xFFFF6B9D)
                      : const Color(0xFF6B7280),
                ),
                const SizedBox(width: 16),
                Text(
                  data.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? const Color(0xFFFF6B9D)
                        : const Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
