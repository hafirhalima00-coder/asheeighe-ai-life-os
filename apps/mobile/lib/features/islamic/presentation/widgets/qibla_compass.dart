import 'dart:math';
import 'package:flutter/material.dart';

class QiblaCompass extends StatefulWidget {
  final double direction;

  const QiblaCompass({super.key, required this.direction});

  @override
  State<QiblaCompass> createState() => _QiblaCompassState();
}

class _QiblaCompassState extends State<QiblaCompass> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = Tween<double>(
      begin: 0,
      end: widget.direction * pi / 180,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _controller.forward();
  }

  @override
  void didUpdateWidget(QiblaCompass oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.direction != widget.direction) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.direction * pi / 180,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer circle
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF2E7D32).withOpacity(0.3),
                    width: 3,
                  ),
                ),
              ),
              // Compass markings
              ...List.generate(8, (index) {
                final angle = index * 45.0 * pi / 180;
                final isMain = index % 2 == 0;
                return Transform.rotate(
                  angle: angle,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: isMain ? 3 : 1.5,
                      height: isMain ? 12 : 8,
                      margin: const EdgeInsets.only(top: 4),
                      color: isMain ? const Color(0xFF2E7D32) : Colors.grey[300],
                    ),
                  ),
                );
              }),
              // Center dot
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFD4AF37),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD4AF37).withOpacity(0.3),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
              // Qibla direction indicator
              Transform.rotate(
                angle: _animation.value,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 4,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF2E7D32).withOpacity(0.2),
                            const Color(0xFF2E7D32),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Icon(
                      Icons.arrow_drop_up,
                      color: Color(0xFF2E7D32),
                      size: 28,
                    ),
                  ],
                ),
              ),
              // Kaaba icon at the top
              const Align(
                alignment: Alignment(0, -0.7),
                child: Text('🕋', style: TextStyle(fontSize: 24)),
              ),
              // North label
              const Align(
                alignment: Alignment(0, -0.95),
                child: Text(
                  'N',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF555555),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
