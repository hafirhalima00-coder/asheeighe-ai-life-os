import 'package:flutter/material.dart';

enum QuickAction {
  addTask('Add Task', Icons.check_circle_outline, Color(0xFFFF6B9D)),
  addEvent('Add Event', Icons.event_outlined, Color(0xFF6C63FF)),
  addNote('Add Note', Icons.sticky_note_2_outlined, Color(0xFFFFD93D)),
  newChat('New Chat', Icons.chat_outlined, Color(0xFF4CAF50));

  final String label;
  final IconData icon;
  final Color color;

  const QuickAction(this.label, this.icon, this.color);
}

class QuickActionFab extends StatefulWidget {
  final void Function(QuickAction action)? onActionSelected;

  const QuickActionFab({super.key, this.onActionSelected});

  @override
  State<QuickActionFab> createState() => _QuickActionFabState();
}

class _QuickActionFabState extends State<QuickActionFab>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOutBack,
    );
    _rotateAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animController.forward();
      } else {
        _animController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(QuickAction.values.length, (index) {
          final action = QuickAction.values[index];
          return _buildActionItem(action);
        }),
        const SizedBox(height: 12),
        FloatingActionButton(
          onPressed: _toggle,
          backgroundColor: const Color(0xFFFF6B9D),
          elevation: 4,
          child: AnimatedBuilder(
            animation: _rotateAnimation,
            builder: (_, child) => Transform.rotate(
              angle: _rotateAnimation.value * 3.14159,
              child: child,
            ),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildActionItem(QuickAction action) {
    return AnimatedBuilder(
      animation: _expandAnimation,
      builder: (_, __) {
        return Opacity(
          opacity: _expandAnimation.value,
          child: Transform(
            transform: Matrix4.translationValues(
              0,
              -20 * (1 - _expandAnimation.value),
              0,
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      action.label,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      _toggle();
                      widget.onActionSelected?.call(action);
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            action.color,
                            action.color.withOpacity(0.8),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: action.color.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(action.icon, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
