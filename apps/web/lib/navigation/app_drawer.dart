import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF6B9D), Color(0xFF6C63FF)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 32,
                    color: Color(0xFFFF6B9D),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'PINKZ User',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'user@pinkz.app',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _drawerItem(Icons.dashboard_outlined, 'Dashboard', () {
            Navigator.pop(context);
          }),
          _drawerItem(Icons.auto_awesome_outlined, 'AI Chat', () {
            Navigator.pop(context);
          }),
          _drawerItem(Icons.calendar_month_outlined, 'Calendar', () {
            Navigator.pop(context);
          }),
          _drawerItem(Icons.checklist_outlined, 'Tasks', () {
            Navigator.pop(context);
          }),
          const Divider(),
          _drawerItem(Icons.settings_outlined, 'Settings', () {
            Navigator.pop(context);
          }),
          _drawerItem(Icons.help_outline, 'Help & Support', () {
            Navigator.pop(context);
          }),
          _drawerItem(Icons.logout, 'Sign Out', () {
            Navigator.pop(context);
          }),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF6B7280)),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF1A1A2E),
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
