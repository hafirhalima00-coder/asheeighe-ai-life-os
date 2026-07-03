import 'package:flutter/material.dart';

enum QuickAction { newTask, newNote, newChat, addEvent, setReminder }

class QuickActionFab extends StatefulWidget {
  final ValueChanged<QuickAction> onActionSelected;

  const QuickActionFab({
    super.key,
    required this.onActionSelected,
  });

  @override
  State<QuickActionFab> createState() => _QuickActionFabState();
}

class _QuickActionFabState extends State<QuickActionFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: _isOpen ? 280 : 56,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_isOpen) ..._buildActionItems(),
          FloatingActionButton(
            onPressed: _toggle,
            backgroundColor: const Color(0xFFFF6B9D),
            child: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: _expandAnimation,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActionItems() {
    return [
      _actionItem(Icons.notifications_outlined, 'Reminder', QuickAction.setReminder),
      const SizedBox(height: 8),
      _actionItem(Icons.event_outlined, 'Event', QuickAction.addEvent),
      const SizedBox(height: 8),
      _actionItem(Icons.auto_awesome_outlined, 'Chat', QuickAction.newChat),
      const SizedBox(height: 8),
      _actionItem(Icons.note_add_outlined, 'Note', QuickAction.newNote),
      const SizedBox(height: 8),
      _actionItem(Icons.task_alt, 'Task', QuickAction.newTask),
      const SizedBox(height: 8),
    ];
  }

  Widget _actionItem(IconData icon, String label, QuickAction action) {
    return FloatingActionButton.small(
      heroTag: label,
      onPressed: () {
        _toggle();
        widget.onActionSelected(action);
      },
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF1A1A2E),
      child: Icon(icon),
    );
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }
}
