import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'bottom_nav.dart';
import 'app_drawer.dart';
import 'quick_action_fab.dart';

class AppShell extends StatefulWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _tabAnimController;

  @override
  void initState() {
    super.initState();
    _tabAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _tabAnimController.dispose();
    super.dispose();
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/chat')) return 1;
    if (location.startsWith('/calendar')) return 2;
    if (location.startsWith('/tasks')) return 3;
    return 4;
  }

  void _onItemTapped(int index, BuildContext context) {
    _tabAnimController.forward(from: 0);
    switch (index) {
      case 0:
        context.goNamed('dashboard');
      case 1:
        context.goNamed('chat');
      case 2:
        context.goNamed('calendar');
      case 3:
        context.goNamed('tasks');
      case 4:
        _scaffoldKey.currentState?.openDrawer();
    }
  }

  Widget _fabForTab(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return QuickActionFab(
          onActionSelected: (action) {},
        );
      case 1:
        return QuickActionFab(
          onActionSelected: (action) {
            if (action == QuickAction.newChat) {}
          },
        );
      case 2:
        return QuickActionFab(
          onActionSelected: (action) {
            if (action == QuickAction.addEvent) {}
          },
        );
      case 3:
        return QuickActionFab(
          onActionSelected: (action) {
            if (action == QuickAction.addTask) {}
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth >= 600;
    final currentIndex = _calculateSelectedIndex(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (isWideScreen) {
          return _buildWideLayout(currentIndex);
        }
        return _buildCompactLayout(currentIndex);
      },
    );
  }

  Widget _buildWideLayout(int currentIndex) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              selectedIndex: currentIndex < 4 ? currentIndex : 0,
              onDestinationSelected: (index) =>
                  _onItemTapped(index, context),
              labelType: NavigationRailLabelType.all,
              backgroundColor: Colors.white,
              extended: false,
              minWidth: 72,
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: IconButton(
                  icon: const Icon(Icons.menu, color: Color(0xFF1A1A2E)),
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard_outlined, color: Color(0xFF9CA3AF)),
                  selectedIcon: Icon(Icons.dashboard, color: Color(0xFFFF6B9D)),
                  label: Text('Dashboard'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.auto_awesome_outlined, color: Color(0xFF9CA3AF)),
                  selectedIcon:
                      Icon(Icons.auto_awesome, color: Color(0xFFFF6B9D)),
                  label: Text('AI Chat'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.calendar_month_outlined, color: Color(0xFF9CA3AF)),
                  selectedIcon:
                      Icon(Icons.calendar_month, color: Color(0xFFFF6B9D)),
                  label: Text('Calendar'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.checklist_outlined, color: Color(0xFF9CA3AF)),
                  selectedIcon:
                      Icon(Icons.checklist, color: Color(0xFFFF6B9D)),
                  label: Text('Tasks'),
                ),
              ],
            ),
            const VerticalDivider(width: 1, color: Color(0xFFE5E7EB)),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: KeyedSubtree(
                  key: ValueKey(currentIndex),
                  child: widget.child,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _fabForTab(currentIndex),
    );
  }

  Widget _buildCompactLayout(int currentIndex) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: KeyedSubtree(
          key: ValueKey(currentIndex),
          child: widget.child,
        ),
      ),
      bottomNavigationBar: PinkzNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => _onItemTapped(index, context),
        badgeCounts: const {1: 3, 3: 5},
      ),
      floatingActionButton: _fabForTab(currentIndex),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
